#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <immintrin.h>
#include <vector>
#include <unistd.h> // usleep

#include "../hle/lib/hle-emulation.h"

int main(int argc, char *argv[]) {
	usleep(5 * 100000); // allow perf to catch up

	int loops = 1000000;
	int add = 5;

	pthread_mutex_t mutex;
	mutex = PTHREAD_MUTEX_INITIALIZER; // default init

	int n = 0;
	for (int i = 0; i < loops; i++) {
		pthread_mutex_lock(&mutex);
		n += add;
		pthread_mutex_unlock(&mutex);
	}
	printf("n: %d (%s)\n", n, n == loops * add ? "correct" : "incorrect");

	// force usage of libstdc++.so.6
	std::vector<int> v;
	v.push_back(n);
	printf("v: %lu\n", v.size());
}
