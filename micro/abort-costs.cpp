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

void access_array_all(unsigned char * array, int index) {
	array[index] = index;
}

void access_array_single(unsigned char * array, int index) {
	array[0] = index;
}

void execute_array_access(unsigned char a[], int size,
		void (*access_func)(unsigned char*, int), int array_accesses[]) {
//	printf("Accessing array %p\n", a);
	for (int i = 0; i < size; i++)
		access_func(a, array_accesses[i]);
}

int regular_aborts = 0;

int run_prefilled(unsigned char * a, int size, int * array_accesses,
		void (*access_func)(unsigned char*, int), int abort_trx) {
	for (int i = 0; i < size; i++)
		a[i] = 0;
	/* a is in cache */

// benchmark
	uint64_t t; // count cycles
	t = rdtsc();
//	struct timeval start, end;
//	gettimeofday(&start, NULL);

	retry: if (_xbegin() == _XBEGIN_STARTED) {
		execute_array_access(a, size, access_func, array_accesses);
		if (abort_trx) {
			_xabort(1);
		}
		_xend();
	} else {
		if (abort_trx == 0)
			regular_aborts++;
//		else { // ignore regular aborts
		abort_trx = 0;
		goto retry;
//		}
	}

	t = rdtsc() - t;
	return t;
//	gettimeofday(&end, NULL);
//	float elapsed_micros = (end.tv_sec - start.tv_sec) * 1000000
//			+ (end.tv_usec - start.tv_usec);
//
//	return elapsed_micros;
}

int run(int size, void (*access_func)(unsigned char*, int), int abort_trx) {
	int access_array[size];
//	for(int i=0; i<size; i++) {
//		access_array[i] = rand() % size;
//	}
	fill_prefetching_unfriendly(access_array, size);

	// init array
	unsigned char * a = (unsigned char *) calloc(sizeof(unsigned char), size); // always allocates the same memory slot

	int result = run_prefilled(a, size, access_array, access_func, abort_trx);

	free(a);

	return result;
}

void print_cycles(const char label[], Stats statsNoAbort, Stats statsAbort) {
	printf("%s\n", label);
	printf("no abort:             %.2f cycles (%.2f stddev)\n",
			statsNoAbort.getExpectedValue(),
			statsNoAbort.getStandardDeviation());
	printf("abort:                %.2f cycles (%.2f stddev)\n",
			statsAbort.getExpectedValue(), statsAbort.getStandardDeviation());
	printf("estimated second run: %.2f cycles (%+.2f cycles)\n",
			statsAbort.getExpectedValue() - statsNoAbort.getExpectedValue(),
			statsAbort.getExpectedValue()
					- 2 * statsNoAbort.getExpectedValue());
}

/**
 * Mind the prefetching! Linear array-access is not gonna show anything.
 */
int main(int argc, char *argv[]) {
	// arguments
	int loops = 100000, size = 1024;
	int *values[] = { &loops, &size };
	const char *identifier[] = { "-l", "-s" };
	handle_args(argc, argv, 2, values, identifier);

	printf("Loops: %d\n", loops);
	printf("Size:  %d\n", size);
	printf("\n");

	// init
	int access_array[size];
	for(int i=0; i<size; i++) {
		access_array[i] = rand() % size;
	}
//	fill_prefetching_unfriendly(access_array, size);

	// init array
	unsigned char a[size];

	// run
	Stats statsSingle, statsAll, statsSingleAbort, statsAllAbort;
	for (int l = 0; l < loops; l++) {
		clear_cache();
//		int cyclesArraySingle = run(size, &access_array_single, 0);
		int cyclesArraySingle = run_prefilled(a, size, access_array,
				&access_array_single, 0);

		clear_cache();
//		int cyclesArraySingleAbort = run(size, &access_array_single, 1);
		int cyclesArraySingleAbort = run_prefilled(a, size, access_array,
				&access_array_single, 1);

		clear_cache();
//		int cyclesArrayAll = run(size, &access_array_all, 0);
		int cyclesArrayAll = run_prefilled(a, size, access_array,
				&access_array_all, 0);

		clear_cache();
//		int cyclesArrayAllAbort = run(size, &access_array_all, 1);
		int cyclesArrayAllAbort = run_prefilled(a, size, access_array,
				&access_array_all, 1);

		statsSingle.addValue(cyclesArraySingle);
		statsAll.addValue(cyclesArrayAll);
		statsSingleAbort.addValue(cyclesArraySingleAbort);
		statsAllAbort.addValue(cyclesArrayAllAbort);
	}

	// print
	printf("%d regular aborts (%.2f/run)\n", regular_aborts,
			((float) regular_aborts) / (loops * 4));

	print_cycles("SINGLE", statsSingle, statsSingleAbort);
	print_cycles("ALL", statsAll, statsAllAbort);
}
