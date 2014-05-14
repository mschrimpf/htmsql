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
	array[index] = 1;
}

void access_array_single(unsigned char * array, int index) {
	array[0] = 1;
}

void execute_array_access(unsigned char * a, int size,
		void (*access_func)(unsigned char*, int)) {
	for (int i = 0; i < size; i++)
		access_func(a, i);
}

/**
 * @param mode 0 to access only the first element, 1 to access all
 */
int run(int size, void (*access)(unsigned char*, int), int abort_trx) {
	// init array
	unsigned char a[size];
	for (int i = 0; i < size; i++)
		a[i] = 0;
	/* array is in cache */

	// benchmark
	uint64_t t; // count cycles
	t = rdtsc();
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		execute_array_access(a, size, access);
		if (abort_trx)
			_mm_pause();
		_xend();
	} else {
		abort_trx = 0;
		goto retry;
	}
	t = rdtsc() - t;
	return t;
}

int main(int argc, char *argv[]) {
	// arguments
	int loops = 100000, size = 1024;
	int *values[] = { &loops, &size };
	const char *identifier[] = { "-l", "-s" };
	handle_args(argc, argv, 2, values, identifier);

	printf("Loops: %d\n", loops);
	printf("Size:  %d\n", size);
	printf("\n");

	Stats statsSingle, statsAll, statsSingleAbort,
			statsAllAbort;
	for (int l = 0; l < loops; l++) {
		int cyclesArraySingle = run(size, &access_array_single, 0);
		int cyclesArraySingleAbort = run(size, &access_array_single, 1);
		int cyclesArrayAll = run(size, &access_array_all, 0);
		int cyclesArrayAllAbort = run(size, &access_array_all, 1);

		statsSingle.addValue(cyclesArraySingle);
		statsAll.addValue(cyclesArrayAll);
		statsSingleAbort.addValue(cyclesArraySingleAbort);
		statsAllAbort.addValue(cyclesArrayAllAbort);
	}

	printf("_Cycles needed_\n");
	printf("SINGLE\n");
	printf("no abort:             %.2f cycles (%.2f stddev)\n",
			statsSingle.getExpectedValue(),
			statsSingle.getStandardDeviation());
	printf("abort:                %.2f cycles (%.2f stddev)\n",
			statsSingleAbort.getExpectedValue(),
			statsSingleAbort.getStandardDeviation());
	printf("estimated second run: %.2f cycles (additional: %.2f)\n",
			statsSingleAbort.getExpectedValue()
					- statsSingle.getExpectedValue(),
			statsSingleAbort.getExpectedValue()
					- 2 * statsSingle.getExpectedValue());

	printf("ALL\n");
	printf("no abort:             %.2f cycles (%.2f stddev)\n",
			statsAll.getExpectedValue(),
			statsAll.getStandardDeviation());
	printf("abort:                %.2f cycles (%.2f stddev)\n",
			statsAllAbort.getExpectedValue(),
			statsAllAbort.getStandardDeviation());
	printf("estimated second run: %.2f cycles (additional: %.2f)\n",
			statsAllAbort.getExpectedValue()
					- statsAll.getExpectedValue(),
			statsAllAbort.getExpectedValue()
					- 2 * statsAll.getExpectedValue());
}
