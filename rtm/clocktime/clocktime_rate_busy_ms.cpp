/*
 * max_time.cpp
 *
 *  Created on: 30.10.2013
 *      Author: Martin
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <unistd.h>
#include <vector>

#include <immintrin.h>

#include "util.h"


double average(std::vector<double> times) {
	double sum = 0;
	for (std::vector<double>::iterator it = times.begin(); it != times.end();
			it++) {
		sum += *it;
	}
	return sum / times.size();
}


int main(int argc, char *argv[]) {
	int loops = 100000, repeats = 10000;
	int *values[] = { &loops, &repeats };
	const char *identifier[] = { "-l", "-r" };
	handle_args(argc, argv, 2, values, identifier);

	printf("Loops:    %d\n", loops);
//	printf("Time:     %.0f ms\n", time);
	printf("Repeats:  %d\n", repeats);

	int attempts = 0;
	int failures = 0;
	std::vector<double> times;
	for (int l = 0; l < loops; l++) {
		// time measurement
		struct timeval start, end;
		gettimeofday(&start, NULL);

		/* BEGIN: Core Code */
		attempts++;
		if (_xbegin() == _XBEGIN_STARTED) {
			for (int i = 0; i < repeats; i++) {
			}

			_xend();
		} else {
			failures++;
		}
		/* END: Core Code */

		gettimeofday(&end, NULL);
		double elapsed = ((end.tv_sec - start.tv_sec) * 1000)
				+ (end.tv_usec / 1000 - start.tv_usec / 1000);
		times.push_back(elapsed);
	}

	printf("Average time: %.2fms\n", average(times));
	printf("Attempts:     %d\n", attempts);
	printf("Failures:     %d (rate %.2f%%)\n", failures,
			failures * 100.0 / attempts);

	return 0;
}
