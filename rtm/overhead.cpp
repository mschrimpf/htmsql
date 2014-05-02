#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <unistd.h>
#include <sys/time.h>
#include <immintrin.h> // _mm_pause
#include <xmmintrin.h> // rtm
#include "../util.h"
#include "../Stats.h"
#include <stdint.h> // uint64_t
#include "../hle/lock_functions/atomic_exch_lock-spec.h"
#include "../hle/lock_functions/hle_exch_lock-spec.h"

#ifdef __i386
__inline__ uint64_t rdtsc() {
	uint64_t x;
	__asm__ volatile ("rdtsc" : "=A" (x));
	return x;
}
#elif __amd64
__inline__ uint64_t rdtsc() {
	uint64_t a, d;
	__asm__ volatile ("rdtsc" : "=a" (a), "=d" (d));
	return (d<<32) | a;
}
#endif

void access_array(unsigned char * a, int size) {
	for (int i = 0; i < size; i++)
		a[i]++;
}

/**
 * @param mode 0 for no synchronization, 1 for pthread mutex, 2 for atomic lock, 3 for hle, 4 for rtm
 */
uint64_t run(int size, int mode) {
	stick_this_thread_to_core(0);
	unsigned char * a = new unsigned char[size];
	for (int i = 0; i < size; i++)
		a[i] = 0;
	unsigned lock = 0;
	pthread_mutex_t p_mutex = PTHREAD_MUTEX_INITIALIZER;
	uint64_t t; // count cycles
	t = rdtsc();
	switch (mode) {
	case 0:
		access_array(a, size);
		break;
	case 1:
		pthread_mutex_lock(&p_mutex);
		access_array(a, size);
		pthread_mutex_unlock(&p_mutex);
		break;
	case 2:
		atomic_exch_lock_spec(&lock);
		access_array(a, size);
		atomic_exch_unlock_spec(&lock);
		break;
	case 3:
		hle_exch_lock_spec(&lock);
		access_array(a, size);
		hle_exch_unlock_spec(&lock);
		break;
	case 4:
		retry: if (_xbegin() == _XBEGIN_STARTED) {
			access_array(a, size);
			_xend();
		} else {
			goto retry;
		}
		break;
	}
	t = rdtsc() - t;
	return t;
}

int main(int argc, char *argv[]) {
	// arguments
	int loops = 1000, size = 100, lockType = -1, wait = 0;
	int *values[] = { &loops, &size, &lockType, &wait };
	const char *identifier[] = { "-l", "-s", "-t", "-w" };
	handle_args(argc, argv, 4, values, identifier);

	printf("Loops: %d\n", loops);
	printf("Size:  %d\n", size);
	printf("\n");

	int tmin = 0;
	int tmax = 5;
	if (lockType > -1) {
		tmin = lockType;
		tmax = tmin + 1;
	}

	usleep(wait);

	Stats statsBaseline, statsPosix, statsAtomic, statsRtm, statsHle;
	Stats * stats[] = { &statsBaseline, &statsPosix, &statsAtomic, &statsHle,
			&statsRtm };
	for (int l = 0; l < loops; l++) {
		for (int i = tmin; i < tmax; i++)
			stats[i]->addValue(run(size, i));
	}

	float baseline = statsBaseline.getExpectedValue(), atomic =
			statsAtomic.getExpectedValue();
	printf(
			"Label;Cycles;Cycles standard deviation;Compared to baseline (%%);Compared to atomic lock (%%)\n");
	const char* labels[] = { "No synchronization", "POSIX", "atomic", "HLE",
			"RTM" };
	for (int i = tmin; i < tmax; i++) {
		float ep = stats[i]->getExpectedValue();
		float stddev = stats[i]->getStandardDeviation();
		printf("%s;%.2f;%.2f;%.2f;%.2f\n", labels[i], ep, stddev, ep / baseline,
				ep / atomic);
	}
}
