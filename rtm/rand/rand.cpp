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
	int loops = 1000;
	int *values[] = { &loops };
	const char *identifier[] = { "-l" };
	handle_args(argc, argv, 1, values, identifier);

	printf("Loops:        %d\n", loops);
	struct timeval start, end;
	gettimeofday(&start, NULL);

	int attempts = 0, failures = 0;
	for (int l = 0; l < loops; l++) {
		attempts++;
		if (_xbegin() == _XBEGIN_STARTED) {
			RAND(l);
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
	printf("Attempts:     %d;\n"
			"Failures:     %d;\n"
			"Failure rate: %.4f\n", attempts, failures, failure_rate);

	return 0;
}
