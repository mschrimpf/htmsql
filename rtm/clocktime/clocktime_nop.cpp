/*
 *  Created on: 19.03.2014
 *      Author: Martin
 */

#include <stdio.h>
#include <stdlib.h>

#include <string>
#include <cmath> // sqrt
#include <immintrin.h> // rtm
#include "../../util.h"

int main(int argc, char *argv[]) {
	int loops = 10, inner_loops = 100, rmin = 10000, rmax =
			20000000;
	float rstep = 1.15;
	int *values[] = { &loops, &inner_loops, &rmin, &rmax/*, &rstep*/ };
	const char *identifier[] = { "-l", "-il", "-rmin", "-rmax"/*, "-rstep"*/ };
	handle_args(argc, argv, /*5*/4, values, identifier);

	printf("Loops:    %d\n", loops);
	printf("Clocks:  %d - %d with steps of %.2f\n", rmin, rmax, rstep);
	printf("\n");

	FILE *out = stdout;
//	std::string filename = "clocktime_nop-micro.csv";
//	FILE * out = fopen(filename.c_str(), "w");

	//	printf("Clocks;Attempts;Failures;Failure rate [%%]\n");
	fprintf(out, "Clocks;ExpectedValue;Variance;Stddev;Stderror\n");

	for (int clocks = rmin; clocks <= rmax; clocks *= rstep) {
		fprintf(out, "%d", clocks);
		float variance_sum = 0;
		float expected_value_sum = 0;
		for (int l = 0; l < loops; l++) {
			int failures = 0;
			for (int p = 0; p < inner_loops; p++) {
				if (_xbegin() == _XBEGIN_STARTED) {
					for (int i = 0; i < clocks; i++) {
						asm volatile("nop");
					}
					_xend();
				} else {
					failures++;
				}
			}
			float failure_rate = (float) failures / inner_loops * 100;
			variance_sum += failure_rate * failure_rate;
			expected_value_sum += failure_rate;
		}

		float expected_value = expected_value_sum * 1.0 / loops; // mu = p * sum(x_i)
		float variance = 1.0 / loops * variance_sum
				- expected_value * expected_value; // var = p * sum(x_i^2) - mu^2

//		float failure_rate = (float) failures / attempts * 100;
//		fprintf(out, "%d;%d;%.2f", attempts, failures, failure_rate);

//		float expected_value = (float) failures / loops;
//		int successful = loops - failures;
//		float variance = (float) (successful * failures) / (loops * loops);

		float stddev = sqrt(variance);
		float stderror = stddev / sqrt(loops);
		fprintf(out, ";%f;%f;%f;%f", expected_value, variance, stddev,
				stderror);
		fprintf(out, "\n");
	}

	return 0;
}
