#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <immintrin.h>

#include "../util.h"
#include "../hle/lib/hle-emulation.h"

int main(int argc, char *argv[]) {
	usleep(5 * 100000); // allow perf to catch up

	pthread_mutex_t mutex;
	mutex = PTHREAD_MUTEX_INITIALIZER; // default init

	int n = 0;
	for (int i = 0; i < 100000; i++) {
		pthread_mutex_lock(&mutex);
		n += 5;
		pthread_mutex_unlock(&mutex);
	}
	printf("n: %d\n", n);
}
