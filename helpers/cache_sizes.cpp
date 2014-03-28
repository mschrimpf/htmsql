#include <iostream>
#include <time.h>
#include <cstdio>

clock_t whack_cache(const int sz) {
	char* buf = new char[sz];

	clock_t start = clock();

	for (int64_t i = 0; i < 64 * 1024 * 1024; i++)
		++buf[(i * 64) % sz]; // writing in increments hopefully means we write to a new cache-line every time

	clock_t elapsed = clock() - start;

	delete[] buf;
	return elapsed;
}

int main() {
	for (int sz = 1024; sz <= 64 * 1024 * 1024; sz <<= 1) {
		fprintf(stdout, "%lu bit, %lu\n", sz * sizeof(char), whack_cache(sz));
	}

	return 0;
}
