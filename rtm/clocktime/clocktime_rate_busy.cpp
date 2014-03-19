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

#include <immintrin.h>

#include "util.h"

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
	for (int l = 0; l < loops; l++) {
		attempts++;
		if (_xbegin() == _XBEGIN_STARTED) {
			for (int i = 0; i < repeats; i++) {
			}

			_xend();
		} else {
			failures++;
		}
	}

	printf("Attempts: %d\n", attempts);
	printf("Failures: %d (rate %.2f%%)\n", failures,
			failures * 100.0 / attempts);

	return 0;
}
