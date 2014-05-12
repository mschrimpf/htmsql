#include <stdio.h>
#include <stdlib.h>
#include <stdint.h> // uint64_t
#include "../util.h"
#include "../Stats.h"

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

uint64_t count_array_access(int size) {
	// init
	unsigned char a[size];
	for (int i = 0; i < size; i++)
		a[i] = 0;
	// access
	uint64_t t; // count cycles
	t = rdtsc();
	for (int i = 0; i < size; i++)
		a[i]++;
	t = rdtsc() - t;
	return t;
}

int main(int argc, char *argv[]) {
	int loops = argc > 1 ? atoi(argv[1]) : 1000;
	int array_size = argc > 2 ? atoi(argv[2]) : 2000;

	Stats stats;
	for (int l = 0; l < loops; l++) {
		int cycles = count_array_access(array_size);
		stats.addValue(cycles);
	}
	printf("Total (size %d) E: %.2f, Sd: %.2f\n", array_size,
			stats.getExpectedValue(), stats.getStandardDeviation());
	printf("Per byte        E: %.2f, Sd: %.2f\n",
			stats.getExpectedValue() / array_size,
			stats.getStandardDeviation() / array_size);
}
