#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <immintrin.h>
#include <vector>
#include <unistd.h> // usleep
#include "../hle/lib/hle-emulation.h"


/**
 * _INIT_
 *   works with PTHREAD_MUTEX_INITIALIZER
 *   works with pthread_mutex_init(&mutex, &attr);
 *
 * _LOCK_
 *   works with pthread_mutex_lock: ~zero aborts
 *   works with pthread_mutex_trylock: lots of aborts
 */
int main(int argc, char *argv[]) {
	usleep(5 * 100000); // allow perf to catch up

	int loops = 1000000;
	int add = 5;

	pthread_mutex_t mutex;
	pthread_mutexattr_t my_fast_mutexattr;
	pthread_mutex_init(&mutex, &my_fast_mutexattr);
//	mutex = PTHREAD_MUTEX_INITIALIZER; // default init

	int n = 0;
	for (int i = 0; i < loops; i++) {
		if (pthread_mutex_trylock(&mutex) != 0) {
			printf("Lock occupied\n");
		} else {
			n += add;
			pthread_mutex_unlock(&mutex);
		}
	}
	printf("n: %d (%s)\n", n, n == loops * add ? "correct" : "incorrect");

	// force usage of libstdc++.so.6
	std::vector<int> v;
	v.push_back(n);
	printf("v: %lu\n", v.size());
}
