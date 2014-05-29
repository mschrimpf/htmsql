#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <immintrin.h>
#include <xmmintrin.h>
//#include <vector>
#include <unistd.h> // usleep
#include "../hle/lib/hle-emulation.h"
#include "../hle/lib/tsx-cpuid.h"

/**
 * _INIT_
 *   works with PTHREAD_MUTEX_INITIALIZER
 *   works with pthread_mutex_init(&mutex, NULL); // (default)
 *   works with initialized attr
 *   >> does _NOT_ work with uninitialized attr
 *   >> does _NOT_ work with attr PTHREAD_MUTEX_ADAPTIVE_NP
 *   works uninitialized but lots of aborts (1 - (330.893.836 / 1.406.282.450) = 76.47%)
 *   symbols PTHREAD_TIMED_NONHLE_MUTEX_INITIALIZER_NP and PTHREAD_MUTEX_HLE_ADAPTIVE_NP from the linux talk are not found
 *
 * _LOCK_
 *   works with pthread_mutex_lock: ~zero aborts
 *   works with pthread_mutex_trylock: lots of aborts (1 - (244.205.904 / 6.287.897.859) = 96.12%)
 */
int main(int argc, char *argv[]) {
	printf("Hardware has: RTM %s | HLE %s\n", cpu_has_rtm() ? "Yes" : "No",
			cpu_has_hle() ? "Yes" : "No");

	usleep(5 * 100000); // allow perf to catch up

	int loops = argc > 1 ? atoi(argv[1]) : 100000;
	int add = 5;

	pthread_mutex_t mutex;
	// works
	mutex = PTHREAD_MUTEX_INITIALIZER; // default
	// works
//	pthread_mutex_init(&mutex, NULL); // default
	// works
//	pthread_mutexattr_t my_mutexattr;
//	pthread_mutexattr_init(&my_mutexattr);
//	pthread_mutex_init(&mutex, &my_mutexattr);
	// does not work
//	pthread_mutexattr_t my_mutexattr;
//	pthread_mutexattr_init(&my_mutexattr);
//	pthread_mutexattr_settype(&my_mutexattr, PTHREAD_MUTEX_DEFAULT);
//	pthread_mutex_init(&mutex, &my_mutexattr);
	// does not work
//	pthread_mutexattr_t my_mutexattr;
//	pthread_mutexattr_init(&my_mutexattr);
//	pthread_mutexattr_settype(&my_mutexattr, PTHREAD_MUTEX_NORMAL);
//	pthread_mutex_init(&mutex, &my_mutexattr);
	// does not work
//	pthread_mutexattr_t my_mutexattr;
//	pthread_mutexattr_init(&my_mutexattr);
//	pthread_mutexattr_settype(&my_mutexattr, PTHREAD_MUTEX_ERRORCHECK);
//	pthread_mutex_init(&mutex, &my_mutexattr);
	// does not work
//	pthread_mutexattr_t my_mutexattr;
//	pthread_mutexattr_init(&my_mutexattr);
//	pthread_mutexattr_settype(&my_mutexattr, PTHREAD_MUTEX_RECURSIVE);
//	pthread_mutex_init(&mutex, &my_mutexattr);
	// does not work
//	pthread_mutexattr_t my_fast_mutexattr;
//	pthread_mutex_init(&mutex, &my_fast_mutexattr);
	// does not work
//	pthread_mutexattr_t my_mutexattr;
//	pthread_mutexattr_init(&my_mutexattr);
//	pthread_mutexattr_settype(&my_mutexattr, PTHREAD_MUTEX_ADAPTIVE_NP);
//	pthread_mutex_init(&mutex, &my_mutexattr);
	// symbol not found
//	pthread_mutexattr_t my_mutexattr;
//	pthread_mutexattr_init(&my_mutexattr);
//	pthread_mutexattr_settype(&my_mutexattr, PTHREAD_TIMED_NONHLE_MUTEX_INITIALIZER_NP); //PTHREAD_MUTEX_HLE_ADAPTIVE_NP);
//	pthread_mutex_init(&mutex, &my_mutexattr);

	int n = 0;
	for (int i = 0; i < loops; i++) {
		while (pthread_mutex_trylock(&mutex) != 0) { // lots of aborts
			_mm_pause();
		}
//		pthread_mutex_lock(&mutex); // 0% aborts
//		struct timespec timeout;
//		clock_gettime(CLOCK_REALTIME, &timeout);
//		timeout.tv_sec += 5;
//		while (pthread_mutex_timedlock(&mutex, &timeout) != 0)
//			;
//		printf("Got lock\n");
		n += add;
		pthread_mutex_unlock(&mutex);
	}

	int ret = pthread_mutex_destroy(&mutex);
	if(ret != 0)
		printf("Could not destroy mutex (error %d)\n", ret);

	printf("n: %d (%s)\n", n, n == loops * add ? "correct" : "incorrect");

	// force usage of libstdc++.so.6
//	std::vector<int> v;
//	v.push_back(n);
//	printf("v: %lu\n", v.size());
}

/* Examples from the glibc manual */

//pthread_mutex_lock (&lock);
//if (pthread_mutex_timedlock (&lock, &timeout) == 0)
//     /* With elision we always come here */
//else
//     /* With no elision we always come here because timeout happens. */
///* Force lock elision for a mutex */
//pthread_mutexattr_t attr;
//pthread_mutexattr_init (&attr);
//pthread_mutexattr_setelision_np (&attr, PTHREAD_MUTEX_ELISION_ENABLE_NP);
//pthread_mutex_init (&object->mylock, &attr);
//@end smallexample
//
//@smallexample
///* Force no lock elision for a mutex */
//pthread_mutexattr_t attr;
//pthread_mutexattr_init (&attr);
//pthread_mutexattr_setelision_np (&attr, PTHREAD_MUTEX_ELISION_DISABLE_NP);
//pthread_mutex_init (&object->mylock, &attr);
