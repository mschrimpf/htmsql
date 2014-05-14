#include <stdio.h>
#include <stdlib.h>

#include <immintrin.h>

#include "../util.h"

int nest(int nesting_count, int max_nesting) {
	int failures = 0;
	if (_xbegin() == _XBEGIN_STARTED) {
		if (++nesting_count <= max_nesting)
			nest(nesting_count, max_nesting);
		_xend();
	} else {
		failures++;
	}
	return failures;
}

int main(int argc, char *argv[]) {
	nop_wait(1000 * 1000); // let perf catch up

	int loops = argc > 1 ? atoi(argv[1]) : 10;
	int nesting_start = argc > 2 ? atoi(argv[2]) : 0;
	int nesting_end = argc > 3 ? atoi(argv[3]) : 10;

	printf("Nesting;Attempts;Failures;Failure Rate\n");
	for (int max_nesting = nesting_start; max_nesting <= nesting_end; max_nesting++) {
		printf("%d", max_nesting);
		int failures = 0;
		for (int l = 0; l < loops; l++)
			failures += nest(0, max_nesting);

		float failure_rate = (float) failures / loops * 100;
		printf(";%d;%d;%.2f\n", loops, failures, failure_rate);
	}
}
