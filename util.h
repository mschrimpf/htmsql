/*
 * util.h
 *
 *  Created on: 26.10.2013
 *      Author: Martin
 */

#ifndef UTIL_H_
#define UTIL_H_

#include <vector>

void handle_args(int argc, char *argv[], int value_len, int **values,
		const char* identifier[]);
/** Calculates the average value of the values in the given vector */
double average(std::vector<double> values);

//int rand_tausworth(int limit); // segmentation faults
int rand_lcg(int limit);
int rand_gerhard(int limit);

#endif /* UTIL_H_ */
