#include <stdlib.h>
#include <stdio.h>

#include <immintrin.h> // rtm
#include "../util.h"
#include "../Stats.h"

const int PADDING_SIZE = 64 - 1;
class CacheLine64B {
public:
	unsigned char value;
	unsigned char padding[PADDING_SIZE];
};

/**
 * Does not work as expected and seems to be somewhat non-deterministic.
 * Possible reasons:
 * - pre-fetching
 */
int main(int argc, char *argv[]) {
	int loops = 100, inner_loops = 100;
	int cache_lines_to_occupy_kb = 32;
	int smin = 1, smax = 4, sstep = 1;
	int *values[] = { &loops, &smin, &smin, &smax, &smax, &sstep, &sstep,
			&cache_lines_to_occupy_kb };
	const char *identifier[] = { "-l", "-smin", "-rmin", "-smax", "-rmax",
			"-sstep", "-rstep", "-c" };
	handle_args(argc, argv, 8, values, identifier);

	// prefetcher attempts to stay 256 bytes ahead of current data [Intel optimization, p. 7-2]
//	int occupied_cache_lines = (32 * 1024 - 256) / 64;
	int occupied_cache_lines = cache_lines_to_occupy_kb * 1024 / 64;
	int size_increase = smax; // x times the L1 DCache
	int array_size = occupied_cache_lines * size_increase;

	printf("Loops: %d\n", loops);
	printf("Steps: %d - %d, steps of %d\n", smin, smax, sstep);
	printf("Occupied cache lines: %d (%d KB)\n", occupied_cache_lines,
			occupied_cache_lines * 64 / 1024);
	printf("array size:           %lu Byte\n",
			sizeof(CacheLine64B) * array_size);

	printf("Step;Expected Value;Standard deviation\n");
	for (int step = smin; step <= smax; step += sstep) {
		printf("%2d", step);
		int adjusted_size = occupied_cache_lines * step;
		printf(" (adjusted size: %4d | %6lu Byte)", adjusted_size,
				sizeof(CacheLine64B) * adjusted_size);

		Stats stats;
		for (int l = 0; l < loops; l++) {
			int failures = 0;
			stick_this_thread_to_core(0);
			// init
			CacheLine64B data[array_size];
			for (int i = 0; i < array_size; i++) {
				data[i].value = 0;
//				for (int ip = 0; ip < PADDING_SIZE; ip++) {
//					data[i].padding[ip] = 0;
//				}
			}
			for (int il = 0; il < inner_loops; il++) {
				clear_cache();

				// run
				if (_xbegin() == _XBEGIN_STARTED) {
					for (int i = 0; i < adjusted_size; i += step) {
						data[i].value = 1;
					}
					_xend();
				} else {
					failures++;
				}
			}
			float failure_rate = (float) failures * 100 / inner_loops;
			stats.addValue(failure_rate);
		}
		printf(";%.2f;%.2f\n", stats.getExpectedValue(),
				stats.getStandardDeviation());
	}
}
