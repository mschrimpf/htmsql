#include <iostream>
#include <time.h>
#include <cstdio>

#include "../util.h"

#define type unsigned char
// from http://www.cplusplus.com/forum/general/35557/
clock_t whack_cache(const int64_t size) {
	// allocate on heap since it does not fit into stack for size > 4096 KB as tests have shown
	type* buf = new type[size];

	clock_t start = clock();

	for (int64_t i = 0; i < 64 * 1024 * 1024; i++)
		++buf[(i * 64 * 2) % size]; // writing in increments hopefully means we write to a new cache-line every time

	clock_t elapsed = clock() - start;

	delete[] buf;
	return elapsed;
}

int main() {
	stick_this_thread_to_core(1);

	for (int64_t size = 1024; size <= 16 * 1024 * 1024 * 64; size <<= 1) {
		printf("%lu KB, %lu\n", size * sizeof(type) / 1024, whack_cache(size));
	}
}

// also check
// http://stackoverflow.com/questions/12675092/writing-a-program-to-get-l1-cache-line-size
