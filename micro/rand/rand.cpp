/*
 *  Created on: 19.03.2014
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
	int loops = 1000, rand_calls = 1;
	int *values[] = { &loops, &rand_calls };
	const char *identifier[] = { "-l", "-r" };
	handle_args(argc, argv, 2, values, identifier);

	printf("Loops:               %d\n", loops);
	printf("Rand calls per loop: %d\n", rand_calls);
	struct timeval start, end;
	gettimeofday(&start, NULL);

	int attempts = 0, failures = 0;
	for (int l = 0; l < loops; l++) {
		attempts++;
		if (_xbegin() == _XBEGIN_STARTED) {
			for (int r = 0; r < rand_calls; r++) {
				RAND(l);
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
