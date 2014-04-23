#include <stdlib.h>
#include <stdio.h>

#include <immintrin.h> // rtm

#include "../../util.h"
#include "../../Stats.h"

int main(int argc, char *argv[]) {
	int loops = 100, inner_loops = 100;
	int smin = 0, smax = 100000, sstep = 5000;
	int *values[] = { &loops, &smin, &smin, &smax, &smax, &sstep, &sstep };
	const char *identifier[] = { "-l", "-smin", "-rmin", "-smax", "-rmax",
			"-sstep", "-rstep" };
	handle_args(argc, argv, 7, values, identifier);

	printf("Loops: %d\n", loops);
	printf("Sizes: %d - %d, steps of %d\n", smin, smax, sstep);

	printf("Size;Expected Value;Standard deviation\n");
	for (int size = smin; size <= smax; size += sstep) {
		printf("%d", size);

		Stats stats;
		for (int l = 0; l < loops; l++) {
			int failures = 0;
			for (int il = 0; il < inner_loops; il++) {
				// init
				unsigned char a[size];
				for (int i = 0; i < size; i++)
					a[i] = 0;

				// run
				int flip = 0; // alternates between 0 (read) and 1 (write)
				int dummy;

				if (_xbegin() == _XBEGIN_STARTED) {
					for (int i = 0; i < size; i++) {
						if (flip)
							dummy = a[i]; // -O0!
						else
							a[i]++;

						flip ^= 1;
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
