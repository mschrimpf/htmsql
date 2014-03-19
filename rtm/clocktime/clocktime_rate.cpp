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

//		std::clock_t begin = std::clock();
//			std::clock_t end = std::clock();
//			double elapsed_clocks = double(end - begin);

int main(int argc, char *argv[]) {
	int loops = argc > 1 ? atoi(argv[1]) : 100000;
	int time = argc > 2 ? atoi(argv[2]) : 1000;

	printf("Loops:    %d\n", loops);
//	printf("Time:     %.0f ms\n", time);
	printf("Repeats:  %d^%d\n", time, time);

	int attempts = 0;
	int failures = 0;
	for (int l = 0; l < loops; l++) {
		attempts++;
//		double last_elapsed = 0;
		int j;
		if (_xbegin() == _XBEGIN_STARTED) {
//			struct timeval start, end;
//			gettimeofday(&start, NULL);
//			for(;;) {
//				gettimeofday(&end, NULL);
//				double elapsed = ((end.tv_sec - start.tv_sec) * 1000)
//						+ (end.tv_usec / 1000 - start.tv_usec / 1000);
//				if (elapsed > last_elapsed + 1000) { // printing purposes
//					printf("Elapsed: %.0f ms \n", elapsed);
//					last_elapsed = elapsed;
//				}
//				if (elapsed >= time) {
//					break;
//				}
//			}

			for (int i = 0; i<time; i++) {
				for (j = 0; j<time; j++) {
//				if (i > last_elapsed + 100) { // printing purposes
//					printf("i: %d\n", i);
//					last_elapsed = i;
//				}
//				if (i == time) {
//					break;
//				}
				}
			}

			_xend();
		} else {
			failures++;
		}
		printf("j: %d\n", j);
	}

	printf("Attempts: %d\n", attempts);
	printf("Failures: %d (rate % 5.2f%%)\n", failures,
			failures * 100.0 / attempts);

	return 0;
}
