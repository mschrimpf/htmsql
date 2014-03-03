/*
 * util.cpp
 *
 *  Created on: 26.10.2013
 *      Author: Martin
 */

#include <string.h>
#include <stdlib.h>
#include <vector>

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

// DO NOT USE
int rand_tausworth(int limit) {
#define TAUSWORTHE(s,a,b,c,d) ((s&c)<<d) ^ (((s <<a) ^ s)>>b)
	static struct rnd_state {
		int s1 = 2, s2 = 8, s3 = 32;
	} tausworth_state;

	tausworth_state.s1 =
	TAUSWORTHE(tausworth_state.s1, 13, 19, 4294967294, 12);
	tausworth_state.s2 =
	TAUSWORTHE(tausworth_state.s2, 2, 25, 4294967288, 4);
	tausworth_state.s3 =
	TAUSWORTHE(tausworth_state.s3, 3, 11, 4294967280, 17);

	return (tausworth_state.s1 ^ tausworth_state.s2 ^ tausworth_state.s3)
			% limit;
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
