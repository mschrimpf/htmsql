#include <stdio.h>
#include <stdlib.h>

#include "../lib/hle-emulation.h"
#include <xmmintrin.h> // _mm_pause
#include "../../util.h"

int i = 0;

int hle_lock(unsigned * mutex) {
	while (__hle_acquire_test_and_set4(mutex)) {
		return 1;
//		_mm_pause();
	}
	return 0;
}
void hle_unlock(unsigned * mutex) {
	__hle_release_clear4(mutex);
}

int nest_hle(int nesting_count, int max_nesting, unsigned * mutex) {
	if (hle_lock(mutex) != 0)
		return 1;

	i++;
	int failures = 0;
	if (++nesting_count <= max_nesting)
		failures += nest_hle(nesting_count, max_nesting, mutex);

	hle_unlock(mutex);

	return failures;
}

int nest_double(int nesting_count, int max_nesting, unsigned * mutex_outer,
		unsigned * mutex_inner) {
	if (hle_lock(mutex_outer) != 0)
		return 1;
	if (hle_lock(mutex_inner) != 0)
		return 1;

	i++;
	int failures = 0;
	if (++nesting_count <= max_nesting)
		failures += nest_double(nesting_count, max_nesting, mutex_outer,
				mutex_inner);

	hle_unlock(mutex_inner);
	hle_unlock(mutex_outer);

	return failures;
}

int nest_triple(int nesting_count, int max_nesting, unsigned * mutex1,
		unsigned * mutex2, unsigned * mutex3) {
	if (hle_lock(mutex1) != 0)
		return 1;
	if (hle_lock(mutex2) != 0)
		return 1;
	if (hle_lock(mutex3) != 0)
		return 1;

	i++;
	int failures = 0;
	if (++nesting_count <= max_nesting)
		failures += nest_triple(nesting_count, max_nesting, mutex1, mutex2,
				mutex3);

	hle_unlock(mutex1);
	hle_unlock(mutex2);
	hle_unlock(mutex3);

	return failures;
}

int nest_iterative(int nesting_count, int max_nesting, unsigned * mutex) {
	for (; nesting_count <= max_nesting; nesting_count++) {
		if (hle_lock(mutex) != 0)
			return 1;
	}

	i++;

	for (; nesting_count >= 0; nesting_count--) {
		hle_unlock(mutex);
	}

	return 0;
}

int main(int argc, char *argv[]) {
	int loops = argc > 1 ? atoi(argv[1]) : 10;

	printf("Nesting;Attempts;Failures;Failure Rate\n");
	for (int max_nesting = 0; max_nesting < 5; max_nesting++) {
		printf("%d", max_nesting);
		int failures = 0;

		for (int l = 0; l < loops; l++) {
			unsigned mutex1 = 0, mutex2 = 0, mutex3 = 0;
			failures += nest_hle(0, max_nesting, &mutex1);
//			failures += nest_double(0, max_nesting, &mutex1, &mutex2);
//			failures += nest_triple(0, max_nesting, &mutex1, &mutex2, &mutex3);
//			failures += nest_iterative(0, max_nesting, &mutex1);
		}

		float failure_rate = (float) failures / loops * 100;
		printf(";%d;%d;%.2f\n", loops, failures, failure_rate);
	}

	printf("i: %d\n", i);
}
