/*
 *  Created on: 27.03.2014
 *      Author: Martin
 */

#include <stdio.h>
#include <stdlib.h>

#include <sys/time.h> // timeval
#include <immintrin.h>

#include "../../util.h"

#define RAND(limit) rand() % limit
//#define RAND(limit) rand_gerhard(limit)

int main(int argc, char *argv[]) {
	int loops = 1000, rand_calls = 1, array_size = 2000;
	int *values[] = { &loops, &rand_calls, &array_size };
	const char *identifier[] = { "-l", "-r", "-s" };
	handle_args(argc, argv, 3, values, identifier);

	printf("Loops:               %d\n", loops);
	printf("Rand calls per loop: %d\n", rand_calls);
	printf("Array size:          %d\n", array_size);
	struct timeval start, end;
	gettimeofday(&start, NULL);

	int attempts = 0, failures = 0;
	for (int l = 0; l < loops; l++) {
		attempts++;
		// init array
		unsigned char array[array_size];
		// rand calls
		for (int r = 0; r < rand_calls; r++) {
			RAND(l);
		}
		if (_xbegin() == _XBEGIN_STARTED) {
			// access all entries of the array, beginning from zero
			for (int s = 0; s < array_size; s++) {
				array[s]++;
			}
			_xend();
		} else {
			failures++;
		}
	}
// time measurement
	gettimeofday(&end, NULL);
	double elapsed = ((end.tv_sec - start.tv_sec) * 1000000)
			+ (end.tv_usec - start.tv_usec);
	printf("Finished in   %.0f microseconds\n", elapsed);
	float failure_rate = (float) failures / attempts * 100;
	printf("Attempts:     %d\n"
			"Failures:     %d\n"
			"Failure rate: %.2f%%\n", attempts, failures, failure_rate);

	return 0;
}
