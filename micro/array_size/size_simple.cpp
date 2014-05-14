#include <stdlib.h>
#include <stdio.h>

#include <immintrin.h>

#include "../../util.h"

int main(int argc, char* argv[]) {
	int loops = 1000, sizes_min = 0, sizes_max = 3000, sizes_step = 50;
	int *values[] = { &loops, &sizes_min, &sizes_min, &sizes_max, &sizes_max,
			&sizes_step, &sizes_step };
	const char *identifier[] = { "-l", "-smin", "-rmin", "-smax", "-rmax",
			"-sstep", "-rstep" };
	handle_args(argc, argv, 7, values, identifier);

	printf("%d - %d accesses with steps of %d\n", sizes_min, sizes_max,
			sizes_step);
	printf("Looped %d times\n", loops);
	printf("\n");

	FILE * out = stdout;

	fprintf(out,
			"Size (array length = Byte);Uninitialized ExpectedValue;"
			"Uninitialized Stddev;Initialized ExpectedValue;Initialized Stddev\n");
	for (int s = sizes_min; s <= sizes_max; s += sizes_step) {
		fprintf(out, "%d", s);
		for (int init = 0; init <= 1; init++) {
			int failures = 0;
			for (int l = 0; l < loops; l++) {
				unsigned char array[s];
				if (init == 1) {
					for (int i = 0; i < s; i++)
						array[i] = 0;
				}
				unsigned char dummy;

				if (_xbegin() == _XBEGIN_STARTED) {
					// access all entries of the array, beginning from zero
					for (int i = 0; i < s; i++) {
//						array[i]++;
						dummy = array[i];
					}
					_xend();
				} else {
					failures++;
				}
			}

			float failure_rate = (float) failures / loops * 100;
			fprintf(out, ";%.2f", failure_rate);
		}
		fprintf(out, "\n");
	}
}
