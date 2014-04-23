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

int nops(int cycles) {
	uint64_t t; // count cycles
	t = rdtsc();
	if (_xbegin() == _XBEGIN_STARTED) {
		nop_wait(cycles);
		_mm_pause(); // abort
		_xend();
	}
	t = rdtsc() - t;
	return t;
}

int array(int size) {
	// init
	unsigned char a[size];
	for (int i = 0; i < size; i++)
		a[i] = 0;
	// access
	uint64_t t; // count cycles
	t = rdtsc();
	if (_xbegin() == _XBEGIN_STARTED) {
		for (int i = 0; i < size; i++)
			a[i]++;
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

	printf("Size:             %d\n", size);
	printf("Estimated cycles: %d\n", estimatedCycles);
	printf("\n");

	Stats statsNop, statsArray;
	for (int l = 0; l < loops; l++) {
		int cyclesNop = nops(estimatedCycles);
		int cyclesArray = array(size);
		statsNop.addValue(cyclesNop);
		statsArray.addValue(cyclesArray);
	}

	printf("_Cycles needed_\n");
	printf("%-6s: %.2f\n", "nops", statsNop.getExpectedValue());
	printf("%-6s: %.2f\n", "array", statsArray.getExpectedValue());
}
