/**
 * Recursive method nesting.
 */
#include <stdio.h>
#include <stdlib.h>

#include <immintrin.h>

#include "../util.h"

int i = 0;

/**
 * Calls RTM when nesting_count == max_nesting.
 * @return 0 if rtm worked, 1 for a failure
 */
int nest(int nesting_count, int max_nesting) {
	if (++nesting_count < max_nesting)
		return nest(nesting_count, max_nesting);
	else {
		if (_xbegin() == _XBEGIN_STARTED) {
			i++;
			_xend();
			return 0;
		} else {
			return 1;
		}
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
		int failures = 0;
		for (int l = 0; l < loops; l++)
			failures += nest(0, n);

		float failure_rate = (float) failures / loops * 100;
		printf(";%d;%d;%.2f\n", loops, failures, failure_rate);
	}

	printf("i: %d\n", i);
}
