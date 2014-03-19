#include <stdio.h>
#include <stdlib.h>

#include <immintrin.h>

int main(int argc, char *argv[]) {
	int size = argc > 1 ? atoi(argv[1]) : 10000;
	printf("Array size:    %d\n", size);

	// run
	int failures = 0;
	int attempts = 0;

	int loops = argc > 2 ? atoi(argv[2]) : 100000;
	int i;
	int dummy;
	for (i = 0; i < loops; i++) {
		// init
		volatile int* a = (volatile int *) malloc(size * sizeof(int));
		retry: attempts++;
		if (_xbegin() == _XBEGIN_STARTED) {
			for (int i = 0; i < size; i++) {
				a[i]++; // write
			}
			// nothing changes when going from back to front
//			for (int i = size - 1; i >= 0; i--) {
//				a[i]++;
//			}
			_xend();
		} else {
			failures++;
//			goto retry;
		}

		free((void*) a);
	}

	printf("Loops:         %d\n", loops);
	printf("Attempts:      %d\n", attempts);
	printf("Failures:      %d (Rate: %.2f%%)\n", failures,
			(float) failures * 100 / attempts);

	return 0;
}

