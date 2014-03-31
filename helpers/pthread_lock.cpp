#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <immintrin.h>

#include "../util.h"
#include "../hle/lib/hle-emulation.h"

int main(int argc, char *argv[]) {
	pthread_mutex_t mutex;
	// 1. attr init
	pthread_mutexattr_t attr;
	pthread_mutexattr_init(&attr);
	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);
//	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_HLE_ADAPTIVE_NP); // not recognized
	pthread_mutexattr_setpshared(&attr, PTHREAD_PROCESS_PRIVATE);
	//	pthread_mutex_init(&mutex, &attr); // attr init
	// 2. initializer
	mutex = PTHREAD_MUTEX_INITIALIZER; // default init
//	mutex = PTHREAD_MUTEX_HLE_ADAPTIVE_NP; // not recognized

	unsigned hle_mutex = 0;

	pthread_mutex_lock(&mutex);
	nop_wait(2000000); // allow perf to catch up
	pthread_mutex_unlock(&mutex);

	int i = 0;
	pthread_mutex_lock(&mutex);
//	__hle_acquire_exchange_n4(&hle_mutex, 1);
	i += 5;
//	__hle_release_clear4(&hle_mutex);
	pthread_mutex_unlock(&mutex);
	printf("i: %d\n", i);
}
