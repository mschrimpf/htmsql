/*
 * max_time.cpp
 *
 *  Created on: 30.10.2013
 *      Author: Martin
 */

#include <stdio.h>
#include <stdlib.h>
#include <ctime>
#include <vector>
#include <algorithm>

#include <immintrin.h>

double average(std::vector<double> times);
void max_min(std::vector<double> times, double* min, double* max);
void quantiles(std::vector<double> times, int amount, double quantiles[],
		double result[]);

int main(int argc, char *argv[]) {
	int loops = argc > 1 ? atoi(argv[1]) : 100000;
	printf("Loops:    %d\n", loops);

	std::vector<double> times;
	for (int l = 0; l < loops; l++) {
//		int dummy = 0;
		std::clock_t begin = std::clock();
		int run = 1;
		while (run) {
			if (_xbegin() == _XBEGIN_STARTED) {
//				dummy++;
				_xend();
			} else {
				std::clock_t end = std::clock();
				double elapsed_clocks = double(end - begin);
				times.push_back(elapsed_clocks);
				run = 0;
			}
		}
	}

	double avg, min, max;
	int quantiles_count = 3;
	double quants[quantiles_count], _quantiles[] = { .25, .5, .75 };
	avg = average(times);
	max_min(times, &min, &max);
	quantiles(times, 3, _quantiles, quants);
//	printf("Values:\n");
//	for (std::vector<double>::iterator it = times.begin(); it != times.end();
//			it++) {
//		printf("\t%f\n", *it);
//	}
	printf("Average: %f\n", avg);
	printf("Values range from %f to %f\n", min, max);
	for (int i = 0; i < quantiles_count; i++) {
		printf("%.2f-quantile: %f\n", _quantiles[i], quants[i]);
	}

	return 0;
}

double average(std::vector<double> times) {
	double sum = 0;
	for (std::vector<double>::iterator it = times.begin(); it != times.end();
			it++) {
		sum += *it;
	}
	return sum / times.size();
}

void max_min(std::vector<double> times, double* min, double* max) {
	for (std::vector<double>::iterator it = times.begin(); it != times.end();
			it++) {
		if (*it < *min)
			*min = *it;
		if (*it > *max)
			*max = *it;
	}
}

/**
 * @param quantiles ordered from high to low!
 */
void quantiles(std::vector<double> times, int amount, double quantiles[],
		double result[]) {
	double sizes[amount];
	for (int i = 0; i < amount; i++) {
		sizes[i] = times.size() * quantiles[i];
	}

	sort(times.begin(), times.end());
	for (int i = amount - 1; i >= 0; i--) {
		result[i] = times[sizes[i]];
	}
}
