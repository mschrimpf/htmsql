/*
 *  Created on: 19.03.2014
 *      Author: Martin
 */

#include <stdio.h>
#include <stdlib.h>

#include <immintrin.h>

#include "../../util.h"

int main(int argc, char *argv[]) {
	int loops = 1000, rmin = 0, rstep = 1000000, rmax = 15000000;
	int *values[] = { &loops, &rmin, &rstep, &rmax };
	const char *identifier[] = { "-l", "-rmin", "-rstep", "-rmax" };
	handle_args(argc, argv, 4, values, identifier);

	printf("Loops:    %d\n", loops);
	printf("Clocks:  %d - %d with steps of %d\n", rmin, rmax, rstep);
	printf("\n");
	printf("Clocks;Attempts;Failures;Failure rate [%%]\n");

	for (int clocks = rmin; clocks <= rmax; clocks += rstep) {
		printf("%d;", clocks);
		int attempts = 0;
		int failures = 0;
		for (int l = 0; l < loops; l++) {
			attempts++;
			if (_xbegin() == _XBEGIN_STARTED) {
				for (int i = 0; i < clocks; i++) {
					asm volatile("nop");
				}
				_xend();
			} else {
				failures++;
			}
		}
		float failure_rate = (float) failures/attempts * 100;
		printf("%d;%d;%.2f\n", attempts, failures, failure_rate);
	}

	return 0;
}
