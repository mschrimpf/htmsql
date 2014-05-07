/*
 * util.h
 *
 *  Created on: 26.10.2013
 *      Author: Martin
 */

#ifndef UTIL_H_
#define UTIL_H_

#include <pthread.h>
#include <vector>
#include <unistd.h> // num_cores
#include <sched.h> // thread affinity

void handle_args(int argc, char *argv[], int value_len, int **values,
		const char* identifier[]);
/** Calculates the average value of the values in the given vector */
double average(std::vector<double> values);

static const int num_cores = sysconf(_SC_NPROCESSORS_ONLN);
int stick_this_thread_to_core(int core_id);

void nop_wait(int microseconds);

void clear_cache();

//int rand_tausworth(int limit); // segmentation faults
int rand_lcg(int limit);
int rand_lcg(long& state, int limit);
int concurrent_rand_gerhard(int limit);
int rand_gerhard(int limit);
/** Use the rand_var as your own random variable that is not shared amongst other threads */
int rand_gerhard(long& state, int limit);

#endif /* UTIL_H_ */
