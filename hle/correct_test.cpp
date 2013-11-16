#include <stdlib.h>
#include <stdio.h>
#include <thread>
#include <unistd.h>
#include <sys/time.h>

#include <xmmintrin.h>

#include "lib/tsx-cpuid.h"
#include "lib/hle-emulation.h"

#include "../util.h"

#define CORES 4
#define type unsigned

int i;
type lock;
void increment() {
	type res = __hle_acquire_test_and_set4(&lock);
	while (res == 1) { // wait until lock was not locked
		_mm_pause();
//		__asm volatile ("pause" ::: "memory");
		res = __hle_acquire_test_and_set4(&lock);
	}
//	printf("Acquired Lock: %d  |  i: %d\n", lock, i);

	usleep(1); // provoke an error
	i++;

	__hle_release_clear4(&lock);
//	printf("Released Lock: %d  |  i: %d\n", lock, i);
}

// provoke even more:
//	int h = i;
//	usleep(1); // provoke an error
//	h++;
//	i = h;

void run(int tid, int repeats) {
	for (int r = 0; r < repeats; r++) {
//		printf(">> Thread %d\n", tid);
		increment();
	}
}

int main(int argc, char *argv[]) {
	struct timeval start, end;
	gettimeofday(&start, NULL);

	// arguments
	int num_threads = CORES, repeats = 10;
	int *values[] = { &num_threads, &repeats };
	const char *identifier[] = { "-n", "-r" };
	handle_args(argc, argv, 2, values, identifier);

	// run threads
	printf("Running %d threads with %d repeats each\n", num_threads, repeats);
	std::thread threads[num_threads];
	for (int i = 0; i < num_threads; i++) {
		threads[i] = std::thread(run, i, repeats);
	}
	// wait for threads
	for (int i = 0; i < num_threads; i++) {
		threads[i].join();
	}

	printf("i should be %d, is %d - %s\n", num_threads * repeats, i,
			(num_threads * repeats) == i ? "OK" : "ERROR");

	gettimeofday(&end, NULL);
	double elapsed = ((end.tv_sec - start.tv_sec) * 1000)
			+ (end.tv_usec / 1000 - start.tv_usec / 1000);
	printf("\nFinished after %.0f ms\n", elapsed);
}

