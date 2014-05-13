#include <stdlib.h>
#include <stdio.h>
#include <stdint.h> // uint64_t
#include "../util.h"
#include "../Stats.h"

const int COLD = 0;
const int WARM = 1;

const int cache_line = 64;

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

int dummy;
int * rands;

/**
 * Fills the given array so that accessing a different array with the sequentially retrieved values of this array can not be hardware-prefetched
 * Guarantees:
 * (1) all values in the array are reached
 * (2) two values a[i] and a[i+1] have a distance of at least cache_line_size+1
 */
void fill_prefetching_unfriendly(int * a, int size) {
	int offset = 0;
	for (int i = 0; i < size; i++) {
		int val = i * (cache_line * 4) + offset;
		if (val > (offset-1) * size)
			offset++;
		//a[i] = val % size;
		a[i] = rand() % size;
//		printf("a[%d] = %d\n", i, a[i]);
	}
}

int access_array(unsigned char a[], int size) {
	for (int i = 0; i < size; i++) {
//		a[i] = 1;
		dummy += a[rands[i]];
	}
}

/**
 * Load another array in the cache, erasing all the previous contents.
 */
void clear_cache_with_other_array() {
	// no significant differences for size = 32 * 1024
	int additional = 10 * 1024;
	int size = 32 * 1024 + additional;
	unsigned char a[size];
	// hw-prefetching does not hurt us here
	for (int i = 0; i < size; i++) {
		a[i] = 0;
	}
}
void warmup_cache(unsigned char a[], int size) {
	access_array(a, size);
}

//
// beware HW-prefetching - use non-linear/random access (http://stackoverflow.com/questions/12675092/writing-a-program-to-get-l1-cache-line-size#comment17115538_12675717)
//
int main(int argc, char *argv[]) {
	int loops = 10000, size = 1024;

	int *values[] = { &loops, &size };
	const char *identifier[] = { "-l", "-s" };
	handle_args(argc, argv, 2, values, identifier);

	printf("Loops: %d\n", loops);
	printf("Size:  %d\n", size);

	stick_this_thread_to_core(1);

	// rands
	rands = new int[size];
	fill_prefetching_unfriendly(rands, size);

	// run
	int modes[] = { COLD, WARM };
	const char *labels[] = { "Cold Cache", "Warm Cache" };
	printf("Cache;Expected Value;Standard Deviation\n");
	for (int m = 0; m < 2; m++) {
		Stats stats;
		// init
		unsigned char a[size];
		for (int i = 0; i < size; i++)
			a[i] = 0;

		// run
		for (int l = 0; l < loops; l++) {
			clear_cache_with_other_array();
			if (modes[m] == WARM)
				warmup_cache(a, size);

			uint64_t t;
			t = rdtsc();
			access_array(a, size);
			t = rdtsc() - t;

			stats.addValue(t);
		}

		printf("%s;%.2f;%.2f\n", labels[m], stats.getExpectedValue(),
				stats.getStandardDeviation());
	}

	delete rands;

	printf("Dummy: %d\n", dummy);
}
