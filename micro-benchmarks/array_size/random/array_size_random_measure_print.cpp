#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <sys/time.h>

#include <immintrin.h>

#include "util.h"

int main(int argc, char *argv[]) {
	int size = 10000, loops = 10000, init = 1;
	int* values[] = { &size, &loops , &init};
	const char* identifier[] = { "-s", "-l" , "-i"};
	handle_args(argc, argv, 2, values, identifier);
	printf("Array size:       %d\n", size);
	printf("Loops:            %d\n", loops);
	printf("Init:             %s\n", init ? "yes" : "no");

	// file handle
	const char* file_header = "Retries;Accesses;"
			"Partial Attempts;Partial Failures;Partial Failure Rate;"
			"Attempts;Failures;Failure Rate";

	// time measurement
	struct timeval start, end;
	gettimeofday(&start, NULL);

	// define measured values
	int retries[] = { 0, 1, 2, 3 };
	int accesses[] = { 1, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000 };

	srand (time(NULL)); // pseudo-randomness for current time
	int rnd = rand();
	// execute suite: check the failure rate for all accesses in all retries
	int repeats = sizeof(retries) / sizeof(retries[0]);
	for (int r = 0; r < repeats; r++) { // retry loop
		printf("____ Retry %d____\n%s\n", retries[r], file_header);

		for (int a = 0; a < sizeof(accesses) / sizeof(accesses[0]); a++) { // accesses loop
			printf("%d;%d;", retries[r], accesses[a]);

			int attempts = 0, partial_attempts = 0, partial_failures = 0,
					failures = 0;
			for (int l = 0; l < loops; l++) {
				volatile int* array = (volatile int *) malloc(
						size * sizeof(int));
				if(init) {
					for(int i=0; i<size; i++)
						array[i] = 0;
				}

				/* BEGIN: core code */
				int retrynum = 0;
				attempts++;
				retry:
				srand(rnd); // generate new randomness
				rnd = rand();
				partial_attempts++;
				if (_xbegin() == _XBEGIN_STARTED) {
					for (int i = 0; i < accesses[a]; i++) {
						array[rand() % size]++; // does only work for arrays up to 2042
//						array[rand() % 2042]++; // does not work any better

//						array[rand() % 1000]++; // 0% for 10 retries
//						array[10 + rand() % 1000]++; // works!
//						array[rand() % 1010]++; // works!
//						array[1000 + rand() % 1000]++; // does not work!

//						array[i % size]++; // works for every array size
					}
					_xend();
				} else {
					partial_failures++;
					if (retrynum < retries[r]) {
						retrynum++;
						goto retry;
					} else {
						failures++;
					}
				}
				/* END: core code */
				free((void*) array);
			}

			printf("%d;%d;%.2f;%d;%d;%.2f\n", partial_attempts,
					partial_failures,
					(float) partial_failures * 100 / partial_attempts, attempts,
					failures, (float) failures * 100 / attempts);
		}
	}
	gettimeofday(&end, NULL);

	double elapsed = ((end.tv_sec - start.tv_sec) * 1000)
			+ (end.tv_usec / 1000 - start.tv_usec / 1000);
	printf("\nFinished in %.0f ms\n", elapsed);

	return 0;
}

