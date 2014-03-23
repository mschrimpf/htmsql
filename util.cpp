/*
 * util.cpp
 *
 *  Created on: 26.10.2013
 *      Author: Martin
 */

#include <string.h>
#include <stdlib.h>
#include "util.h"

void handle_args(int argc, char *argv[], int value_len, int **values,
		const char* identifier[]) {
	for (int a = 1; a < argc; a++) {
		for (int i = 0; i < value_len; i++) {
			if (strcmp(argv[a], identifier[i]) == 0) {
				*values[i] = atoi(argv[++a]);
			}
		}
	}
}

double average(std::vector<double> values) {
	double sum = 0;
	for (std::vector<double>::iterator it = values.begin(); it != values.end();
			it++) {
		sum += *it;
	}
	return sum / values.size();
}

int stick_this_thread_to_core(int core_id) {
	if (core_id < 0 || core_id >= num_cores)
		return -1;

	cpu_set_t cpuset;
	CPU_ZERO(&cpuset);
	CPU_SET(core_id, &cpuset);

	pthread_t current_thread = pthread_self();
	return pthread_setaffinity_np(current_thread, sizeof(cpu_set_t), &cpuset);
}

void nop_sleep(int microseconds) {
	for (int i = 0; i < microseconds * 800; ++i) {
		asm volatile("nop");
	}
}

// DO NOT USE
int rand_tausworth(int limit) {
#define TAUSWORTHE(s,a,b,c,d) ((s&c)<<d) ^ (((s <<a) ^ s)>>b)
	static int s1 = 2, s2 = 8, s3 = 32;

	s1 = TAUSWORTHE(s1, 13, 19, 4294967294, 12);
	s2 = TAUSWORTHE(s2, 2, 25, 4294967288, 4);
	s3 = TAUSWORTHE(s3, 3, 11, 4294967280, 17);

	return (s1 ^ s2 ^ s3) % limit;
}

int rand_lcg(int limit) {
	static int lcg_state = 777;

	lcg_state = lcg_state * 1664525 + 1013904223;
	return (lcg_state >> 24) % limit;
}

int rand_gerhard(int limit) {
	static long a = 1;

	a = (a * 32719 + 3) % 32749;
	return a % limit;
}
