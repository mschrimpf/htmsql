#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <sys/time.h>

#include <immintrin.h>

#include "util.h"

int main(int argc, char *argv[]) {
	int size = 100000, loops = 1000, accesses = 1000, retries = 0, modulo = -1;
	int *values[] = { &size, &loops, &accesses, &retries, &modulo };
	const char* identifier[] = { "-s", "-l", "-a", "-r", "-m" };
	handle_args(argc, argv, 5, values, identifier);
	if (modulo < 0) { //not set
		modulo = size;
	}

	printf("Array size:       %d\t\tModulo:  rand() %% %d\n", size, modulo);
	printf("Accesses:         %d\t\tRetries:          %d\n", accesses, retries);
	printf("Loops:            %d\n", loops);

	volatile int* a = (volatile int *) malloc(size * sizeof(int));

	int attempts = 0, partial_attempts = 0, partial_failures = 0, failures = 0;
	srand (time(NULL)); // pseudo-randomness for current time
int 	rnd = rand();

	int i;
	int ten_percent = loops / 10, last_loop = -ten_percent / 2;
	for (int l = 0; l < loops; l++) {
		// status print every 10%, beginning with 5%
		if (l > last_loop + ten_percent) {
			printf("=");
			std::cout.flush();
			last_loop = l;
		}
		int retrynum = 0;
		attempts++;

		/* BEGIN: Core Code */
		retry: srand(rnd); // generate new randomness
		// (otherwise, the old "random" values would occur again after a retry
		// since the internal rand()-value would be aborted and therefore reset)
		rnd = rand();
		partial_attempts++;
		if (_xbegin() == _XBEGIN_STARTED) {
			for (int i = 0; i < accesses; i++) {
				a[rand() % modulo]++;
//				a[1000 + rand() % modulo]++; // behaves exactly the same
			}
			_xend();
		} else {
			partial_failures++;
			if (retrynum < retries) {
				retrynum++;
				goto retry;
			} else {
				failures++;
			}
		}
		/* END: Core Code */
	}

	printf("\n");

	free((void*) a);

	printf("Partial Attempts: %d\t\tPartial Failures: %d (Rate: %.2f%%)\n",
			partial_attempts, partial_failures,
			(float) partial_failures * 100 / partial_attempts);
	printf("Attempts:         %d\t\tFailures:         %d (Rate: %.2f%%)\n",
			attempts, failures, (float) failures * 100 / attempts);

	return 0;
}

