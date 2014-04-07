/**
 * Recursive method nesting.
 */
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

/**
 * Calls HLE when nesting_count == max_nesting.
 * @return 0 if rtm worked, 1 for a failure
 */
int nest(int nesting_count, int max_nesting, unsigned * mutex) {
	if (++nesting_count < max_nesting)
		return nest(nesting_count, max_nesting, mutex);
	else {
		if (hle_lock(mutex) != 0)
			return 1;
		i++;
		hle_unlock(mutex);
		return 0;
	}
}

// Leads to zero failures
int main(int argc, char *argv[]) {
	int loops = argc > 1 ? atoi(argv[1]) : 10;
	int max_nesting = argc > 2 ? atoi(argv[2]) : 10;
	int n_step = max_nesting > 10 ? max_nesting / 10 : 1;

	printf("Recursion;Attempts;Failures;Failure Rate\n");
	for (int n = 0; n < max_nesting; n += n_step) {
		printf("%d", n);
		unsigned mutex = 0;
		int failures = 0;
		for (int l = 0; l < loops; l++)
			failures += nest(0, n, &mutex);

		float failure_rate = (float) failures / loops * 100;
		printf(";%d;%d;%.2f\n", loops, failures, failure_rate);
	}

	printf("i: %d\n", i);
}
