/*
 * clocktime_sleep.cpp
 *
 *  Created on: 30.10.2013
 *      Author: Martin
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <immintrin.h>

int main(int argc, char *argv[]) {
	int loops = argc > 1 ? atoi(argv[1]) : 100000;
	int time = argc > 2 ? atoi(argv[2]) : 1000;

	printf("Loops:      %d\n", loops);
	printf("Sleep time: %d ms\n", time);

	int attempts = 0;
	int failures = 0;
	for (int l = 0; l < loops; l++) {
		attempts++;
		if (_xbegin() == _XBEGIN_STARTED) {
			usleep(time);
			_xend();
		} else {
			failures++;
		}
	}

	printf("Attempts:   %d\n", attempts);
	printf("Failures:   %d (rate % 5.2f%%)\n", failures,
			failures * 100.0 / attempts);

	return 0;
}
