#include <pthread.h>
#include <semaphore.h>
#include <stdio.h>

// Set either of these to 1 to prevent CPU reordering
#define USE_CPU_FENCE              0
#define USE_SINGLE_HW_THREAD       0  // Supported on Linux, but not Cygwin or PS3
#define USE_MEMORY_BARRIER         0
#define USE_TRX_MEMORY_HLE	   0 // supported only by Intel Haswell CPUs
#define USE_TRX_MEMORY_RTM         1 // supported only by Intel Haswell CPUs

#if USE_SINGLE_HW_THREAD
#include <sched.h>
#endif

#if USE_TRX_MEMORY_HLE
#define __HLE_ACQUIRE ".byte 0xf2 ; "
#define __HLE_RELEASE ".byte 0xf3 ; "
#endif

#if USE_TRX_MEMORY_RTM
#include <immintrin.h>
#endif


//Mac OS X...
//#if USE_MEMORY_BARRIER
//#include <libkern/OSAtomic.h>
//#endif


//-------------------------------------
//  MersenneTwister
//  A thread-safe random number generator with good randomness
//  in a small number of instructions. We'll use it to introduce
//  random timing delays.
//-------------------------------------
#define MT_IA  397
#define MT_LEN 624

class MersenneTwister
{
    unsigned int m_buffer[MT_LEN];
    int m_index;

public:
    MersenneTwister(unsigned int seed);
    // Declare noinline so that the function call acts as a compiler barrier:
    unsigned int integer() __attribute__((noinline));
};

MersenneTwister::MersenneTwister(unsigned int seed)
{
    // Initialize by filling with the seed, then iterating
    // the algorithm a bunch of times to shuffle things up.
    for (int i = 0; i < MT_LEN; i++)
        m_buffer[i] = seed;
    m_index = 0;
    for (int i = 0; i < MT_LEN * 100; i++)
        integer();
}

unsigned int MersenneTwister::integer()
{
    // Indices
    int i = m_index;
    int i2 = m_index + 1; if (i2 >= MT_LEN) i2 = 0; // wrap-around
    int j = m_index + MT_IA; if (j >= MT_LEN) j -= MT_LEN; // wrap-around

    // Twist
    unsigned int s = (m_buffer[i] & 0x80000000) | (m_buffer[i2] & 0x7fffffff);
    unsigned int r = m_buffer[j] ^ (s >> 1) ^ ((s & 1) * 0x9908B0DF);
    m_buffer[m_index] = r;
    m_index = i2;

    // Swizzle
    r ^= (r >> 11);
    r ^= (r << 7) & 0x9d2c5680UL;
    r ^= (r << 15) & 0xefc60000UL;
    r ^= (r >> 18);
    return r;
}


//-------------------------------------
//  Main program, as decribed in the post
//-------------------------------------
sem_t beginSema1;
sem_t beginSema2;
sem_t endSema;

unsigned int aborts;

int X, Y;
int r1, r2;

void *thread1Func(void *param)
{
    MersenneTwister random(1);
    for (;;)
    {
        sem_wait(&beginSema1);  // Wait for signal
        while (random.integer() % 8 != 0) {}  // Random delay

        // ----- THE TRANSACTION! -----
#if USE_TRX_MEMORY_HLE
        __transaction_atomic {
//	asm volatile (__HLE_ACQUIRE ::: "memory");
#elif USE_TRX_MEMORY_RTM
retry1:
        if ( _xbegin() == _XBEGIN_STARTED ) {
#endif
        X = 1;
#if USE_CPU_FENCE
        asm volatile("mfence" ::: "memory");  // Prevent CPU reordering
#elif USE_MEMORY_BARRIER
        __sync_synchronize();
#elif USE_TRX_MEMORY_HLE
#elif USE_TRX_MEMORY_RTM
#else
        asm volatile("" ::: "memory");  // Prevent compiler reordering
#endif
        r1 = Y;

#if USE_TRX_MEMORY_HLE
//        asm volatile (__HLE_RELEASE ::: "memory");
	}
#elif USE_TRX_MEMORY_RTM
        _xend();
        }
        else {
         aborts++;
         goto retry1;
       }
#endif

        sem_post(&endSema);  // Notify transaction complete
    }
    return NULL;  // Never returns
};

void *thread2Func(void *param)
{
    MersenneTwister random(2);
    for (;;)
    {
        sem_wait(&beginSema2);  // Wait for signal
        while (random.integer() % 8 != 0) {}  // Random delay

        // ----- THE TRANSACTION! -----
#if USE_TRX_MEMORY_HLE
	__transaction_atomic {
//        asm volatile (__HLE_ACQUIRE ::: "memory");
#elif USE_TRX_MEMORY_RTM
retry2:
        if ( _xbegin() == _XBEGIN_STARTED ) {
#endif

        Y = 1;
#if USE_CPU_FENCE
        asm volatile("mfence" ::: "memory");  // Prevent CPU reordering
#elif USE_MEMORY_BARRIER
        __sync_synchronize();
#elif USE_TRX_MEMORY_HLE
#elif USE_TRX_MEMORY_RTM
#else
        asm volatile("" ::: "memory");  // Prevent compiler reordering
#endif
        r2 = X;

#if USE_TRX_MEMORY_HLE
//        asm volatile (__HLE_RELEASE ::: "memory");
	}
#elif USE_TRX_MEMORY_RTM
        _xend();
        }
        else {
         aborts++;
         goto retry2;
       }
#endif
        sem_post(&endSema);  // Notify transaction complete
    }
    return NULL;  // Never returns
};

int main()
{
    // Initialize the semaphores
    sem_init(&beginSema1, 0, 0);
    sem_init(&beginSema2, 0, 0);
    sem_init(&endSema, 0, 0);

    // Spawn the threads
    pthread_t thread1, thread2;
    pthread_create(&thread1, NULL, thread1Func, NULL);
    pthread_create(&thread2, NULL, thread2Func, NULL);

#if USE_SINGLE_HW_THREAD
    // Force thread affinities to the same cpu core.
    cpu_set_t cpus;
    CPU_ZERO(&cpus);
    CPU_SET(0, &cpus);
    pthread_setaffinity_np(thread1, sizeof(cpu_set_t), &cpus);
    pthread_setaffinity_np(thread2, sizeof(cpu_set_t), &cpus);
#endif

    // Repeat the experiment for 1 million iterations
    aborts = 0;
    int detected = 0;
    for (int iterations = 1; iterations <= 1000000; iterations++)
    {
        // Reset X and Y
        X = 0;
        Y = 0;
        // Signal both threads
        sem_post(&beginSema1);
        sem_post(&beginSema2);
        // Wait for both threads
        sem_wait(&endSema);
        sem_wait(&endSema);
        // Check if there was a simultaneous reorder
        if (r1 == 0 && r2 == 0)
        {
            detected++;
            printf("%d reorders detected after %d iterations\n", detected, iterations);
        }
    }
#if USE_TRX_MEMORY_RTM
    printf("There were %d hw tx aborts.\n", aborts);
#endif
    return 0;  // Never returns
}


