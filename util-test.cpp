#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <cmath> // sqrt
#include "util.h"
#include "Stats.h"

int sysrand(int limit) {
	return rand() % limit;
}

void rnd_manual() {
	char c;
	int rnd_gerhard, rnd_gerhard_state, rnd_lcg, rnd_lcg_state;
	long gerhard_state = 1, lcg_state = 1;
	while (1) {
		do
			c = getchar();
		while (isspace(c)); // ignore spaces
		if (c == 'q') // q to quit
			break;
		int limit = c - '0'; // convert to int
		rnd_gerhard = rand_gerhard(limit);
		rnd_gerhard_state = rand_gerhard(gerhard_state, limit);
		rnd_lcg = rand_lcg(limit);
		rnd_lcg_state = rand_lcg(lcg_state, limit);

		printf("%5s %d\n", "rg", rnd_gerhard);
		printf("%5s %d\n", "rgs", rnd_gerhard_state);
		printf("%5s %d\n", "rl", rnd_lcg);
		printf("%5s %d\n", "rls", rnd_lcg_state);
	}
}
void rnd_loop(int loops, int limit) {
	int count_rnd = 3;
	int count_rnd_state = 2;
	int count = count_rnd + count_rnd_state;
	// desc
	const char *desc[count];
	desc[0] = "sysrand";
	desc[1] = "rand_gerhard";
	desc[2] = "rand_lcg";
	desc[3] = "rand_gerhard_state";
	desc[4] = "rand_lcg_state";
	// global state
	int (*func_rnd[count_rnd])(int limit);
	func_rnd[0] = sysrand;
	func_rnd[1] = rand_gerhard;
	func_rnd[2] = rand_lcg;
	// state
	int (*func_rnd_state[count_rnd_state])(long &state, int limit);
	func_rnd_state[0] = rand_gerhard;
	func_rnd_state[1] = rand_lcg;
	long rnd_states[count_rnd_state];
	rnd_states[0] = rnd_states[1] = 1;

	// expected value sum
	int expected_value_sums[count];
	int variance_sums[count];

	for (int i = 0; i < loops; i++) {
		// get values
		for (int r = 0; r < count; r++) {
			int val;
			if (r < count_rnd)
				val = func_rnd[r](limit);
			else
				val = func_rnd_state[r - count_rnd](rnd_states[r - count_rnd],
						limit);
			if (val < 0)
				printf("Value %d is < 0 for %s\n", val, desc[r]);
			expected_value_sums[r] += val;
			variance_sums[r] += val * val;
		}
	}

	for (int r = 0; r < count; r++) {
		float expected_value = expected_value_sums[r] * 1.0 / loops; // mu = p * sum(x_i)
		float variance = 1.0 / loops * variance_sums[r]
				- expected_value * expected_value; // var = p * sum(x_i^2) - mu^2
		float stddev = sqrt(variance);
		float stderror = stddev / sqrt(loops);
		printf("%-20s: EP=%.2f, VAR=%.2f\n", desc[r], expected_value, stddev);
	}
}

void stats() {
	Stats stats;
	int vals[] = { 600, 470, 170, 430, 300 };
	for (int i = 0; i < sizeof(vals) / sizeof(int); i++) {
		stats.addValue(vals[i]);
	}

	float ep = stats.getExpectedValue();
	float var = stats.getVariance();
	float sd = stats.getStandardDeviation();

	float asserted_ep = 394;
	printf("EP  should be %.2f, is %.2f - %s\n", asserted_ep, ep,
			asserted_ep == ep ? "OK" : "ERROR");
	float asserted_var = 21704;
	printf("VAR should be %.2f, is %.2f - %s\n", asserted_var, var,
			asserted_var == var ? "OK" : "ERROR");
	float asserted_sd = sqrt(asserted_var);
	printf("SD  should be %.2f, is %.2f - %s\n", asserted_sd, sd,
			asserted_sd == sd ? "OK" : "ERROR");
}

/**
 * This program reads character by character,
 * i.e. entering 11 will result in twice a limit of 1, not eleven!
 *
 * Compile with:
 *  g++ -O2 -o util-test util-test.cpp util.cpp -pthread -lm
 *
 */
int main(int argc, char *argv[]) {
	int loops = argc > 1 ? atoi(argv[1]) : 1000000;
	int limit = argc > 2 ? atoi(argv[2]) : 1000;
//	rnd_loop(loops, limit);
	stats();
}
