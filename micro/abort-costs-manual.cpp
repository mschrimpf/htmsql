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

const int SINGLE_ACCESS = 0;
const int ALL_ACCESS = 1;

unsigned char * initArray(int size) {
	unsigned char * a = new unsigned char[size];
	for (int i = 0; i < size; i++)
		a[i] = 0;
	return a;
}

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
int run(int size, int mode, int abort_trx) {
	stick_this_thread_to_core(0);
	void (*access)(unsigned char*, int);
	switch (mode) {
	case SINGLE_ACCESS:
		access = &access_array_single;
		break;
	case ALL_ACCESS:
		access = &access_array_all;
		break;
	}
	unsigned char * a = initArray(size);
	// make sure array is in cache
	for (int i = 0; i < size; i++)
		a[i]++;
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

	Stats statsArraySingle, statsArrayAll, statsArraySingleAbort,
			statsArrayAllAbort;
	for (int l = 0; l < loops; l++) {
		int cyclesArraySingle = run(size, SINGLE_ACCESS, 0);
		int cyclesArrayAll = run(size, ALL_ACCESS, 0);
		int cyclesArraySingleAbort = run(size, SINGLE_ACCESS, 1);
		int cyclesArrayAllAbort = run(size, ALL_ACCESS, 1);

		statsArraySingle.addValue(cyclesArraySingle);
		statsArrayAll.addValue(cyclesArrayAll);
		statsArraySingleAbort.addValue(cyclesArraySingleAbort);
		statsArrayAllAbort.addValue(cyclesArrayAllAbort);
	}

	printf("_Cycles needed_\n");
	printf("array single:         %.2f cycles (%.2f stddev)\n",
			statsArraySingle.getExpectedValue(),
			statsArraySingle.getStandardDeviation());
	printf("array all:            %.2f cycles (%.2f stddev)\n",
			statsArrayAll.getExpectedValue(),
			statsArrayAll.getStandardDeviation());
	printf("array single (abort): %.2f cycles (%.2f stddev)\n",
			statsArraySingleAbort.getExpectedValue(),
			statsArraySingleAbort.getStandardDeviation());
	printf("array all (abort):    %.2f cycles (%.2f stddev)\n",
			statsArrayAllAbort.getExpectedValue(),
			statsArrayAllAbort.getStandardDeviation());
	printf("estimated second run single: %.2f cycles\n",
			statsArraySingleAbort.getExpectedValue()
					- statsArraySingle.getExpectedValue());
	printf("estimated second run all:    %.2f cycles\n",
			statsArrayAllAbort.getExpectedValue()
					- statsArrayAll.getExpectedValue());
}
