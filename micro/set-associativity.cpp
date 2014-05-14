#include <stdlib.h>
#include <stdio.h>

#include <immintrin.h> // rtm
#include "../util.h"
#include "../Stats.h"

const int PADDING_SIZE = 64 - 1;
class CacheLine {
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
	int size_min = 0, size_max = 35 * 1024 / sizeof(CacheLine), size_step =
			1000 / sizeof(CacheLine);
	int step_min = 1, step_max = 6, step_step = 1;
	int *values[] = { &loops, &size_min, &size_min, &size_max, &size_max,
			&size_step, &size_step };
	const char *identifier[] = { "-l", "-smin", "-rmin", "-smax", "-rmax",
			"-sstep", "-rstep" };
	handle_args(argc, argv, 7, values, identifier);

	// prefetcher attempts to stay 256 bytes (4 cache lines) ahead of current data [Intel optimization, p. 7-2]
	int array_size = 32 * 1024 / sizeof(CacheLine) * 10; // x times L1 cache

	printf("Loops: %d\n", loops);
	printf("Size: %d - %d, steps of %d\n", size_min, size_max, size_step);
	printf("Step: %d - %d, steps of %d\n", step_min, step_max, step_step);
	printf("sizeof(CacheLine64B): %lu\n", sizeof(CacheLine));
	printf("array size: %d | %lu Byte\n", array_size,
			sizeof(CacheLine) * array_size);

	printf("Accessed Bytes");
	for (int step = step_min; step <= step_max; step += step_step) {
		printf(";%d Expected Value;%d Standard Deviation", step, step);
	}
	printf("\n");
	stick_this_thread_to_core(0);
	for (int accessed_size = size_min; accessed_size <= size_max;
			accessed_size += size_step) {
		printf("%6lu", sizeof(CacheLine) * accessed_size);

		for (int step = step_min; step <= step_max; step += step_step) {
			int adjusted_size = accessed_size * step;

			Stats stats;
			for (int l = 0; l < loops; l++) {
				int failures = 0;
				// init
				CacheLine data[array_size];
				for (int i = 0; i < array_size; i++) {
					data[i].value = 0;
					for (int ip = 0; ip < PADDING_SIZE; ip++) {
						data[i].padding[ip] = 0;
					}
				}

				for (int il = 0; il < inner_loops; il++) {
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
			printf(";%.2f;%.2f", stats.getExpectedValue(),
					stats.getStandardDeviation());
		}
		printf("\n");
	}
}
