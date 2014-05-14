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

const float estimatedCyclesPerByte = 0.03f;

unsigned char * initArray(int size) {
	unsigned char * a = new unsigned char[size];
	for (int i = 0; i < size; i++)
		a[i] = 0;
	return a;
}

int nops(int cycles) {
	uint64_t t; // count cycles
	t = rdtsc();
	if (_xbegin() == _XBEGIN_STARTED) {
		for (int c = 0; c < cycles; c++) {
			asm volatile("nop");
		}
		_mm_pause(); // abort
		_xend();
	}
	t = rdtsc() - t;
	return t;
}

int array_single(int size, int abort) {
	unsigned char * a = initArray(size);
	// access one single item
	uint64_t t; // count cycles
	t = rdtsc();
	if (_xbegin() == _XBEGIN_STARTED) {
		for (int i = 0; i < size; i++)
			a[0]++;
		if (abort)
			_mm_pause();
		_xend();
	}
	t = rdtsc() - t;
	return t;
}

int array_seq(int size, int abort) {
	unsigned char * a = initArray(size);
	// access all items
	uint64_t t; // count cycles
	t = rdtsc();
	if (_xbegin() == _XBEGIN_STARTED) {
		for (int i = 0; i < size; i++)
			a[i]++;
		if (abort)
			_mm_pause();
		_xend();
	}
	t = rdtsc() - t;
	return t;
}

int main(int argc, char *argv[]) {
	// arguments
	int loops = 10, size = 2000;
	int *values[] = { &loops, &size };
	const char *identifier[] = { "-l", "-s" };
	handle_args(argc, argv, 2, values, identifier);

	int estimatedCycles = (int) (estimatedCyclesPerByte * size);

	printf("Loops:            %d\n", loops);
	printf("Size:             %d\n", size);
	printf("Estimated cycles: %d\n", estimatedCycles);
	printf("\n");

	Stats statsNop, statsArraySingle, statsArrayAll, statsArraySingleNoAbort,
			statsArrayAllNoAbort;
	for (int l = 0; l < loops; l++) {
		int cyclesNop = nops(estimatedCycles);
		int cyclesArraySingle = array_single(size, 1);
		int cyclesArrayAll = array_seq(size, 1);
		int cyclesArraySingleNoAbort = array_single(size, 0);
		int cyclesArrayAllNoAbort = array_seq(size, 0);

		statsNop.addValue(cyclesNop);
		statsArraySingle.addValue(cyclesArraySingle);
		statsArrayAll.addValue(cyclesArrayAll);
		statsArraySingleNoAbort.addValue(cyclesArraySingleNoAbort);
		statsArrayAllNoAbort.addValue(cyclesArrayAllNoAbort);
	}

	printf("_Cycles needed_\n");
	printf("nops:                    %.2f cycles (%.2f stddev)\n",
			statsNop.getExpectedValue(), statsNop.getStandardDeviation());
	printf("array single:            %.2f cycles (%.2f stddev)\n",
			statsArraySingle.getExpectedValue(),
			statsArraySingle.getStandardDeviation());
	printf("array all:               %.2f cycles (%.2f stddev)\n",
			statsArrayAll.getExpectedValue(),
			statsArrayAll.getStandardDeviation());
	printf("array single (no abort): %.2f cycles (%.2f stddev)\n",
			statsArraySingleNoAbort.getExpectedValue(),
			statsArraySingleNoAbort.getStandardDeviation());
	printf("array all (no abort):    %.2f cycles (%.2f stddev)\n",
			statsArrayAllNoAbort.getExpectedValue(),
			statsArrayAllNoAbort.getStandardDeviation());
}
