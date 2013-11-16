#include <stdio.h>
#include <stdlib.h>

#include <immintrin.h>

#include "../../../util.h"

#define type int

int main(int argc, char *argv[]) {
	// arguments
	int loops = 1000, sizes_min = 2000, sizes_max = 800000, sizes_step = 1000;
	int *values[] = { &loops, &sizes_min, &sizes_max, &sizes_step };
	const char *identifier[] = { "-l", "-smin", "-smax", "-sstep" };
	handle_args(argc, argv, 4, values, identifier);

	printf("%d - %d runs with steps of %d\n", sizes_min, sizes_max, sizes_step);
	printf("\n");
	int sizes_count = (sizes_max - sizes_min + sizes_step) / sizes_step;
	int sizes[sizes_count];
	for (int i = 0; i < sizes_count; i++) {
		sizes[i] = sizes_min + i * sizes_step;
	}

	FILE * out = stdout; //fopen("alloc.csv", "w");

	// info
	fprintf(out, "Sizes;Failure rate\n");

	// run suite
	for (int s = 0; s < sizeof(sizes) / sizeof(sizes[0]); s++) {
		fprintf(out, "%d", sizes[s]);
		int failures = 0;
		int attempts = 0;
		for (int l = 0; l < loops; l++) {
			retry: attempts++;
			if (_xbegin() == _XBEGIN_STARTED) {
//				volatile type *array = (volatile type*) malloc(sizes[s]); // 100%
//				free((void*) array);

				volatile type array[sizes[s]];
				_xend();
				return 1;
			} else {
				failures++;
			}
		} // end loops loop
		float failure_rate = (float) failures * 100 / attempts;
//			printf("Loops:         %d\n", loops);
//			printf("Attempts:      %d\n", attempts);
//			printf("Failures:      %d (Rate: %.2f%%)\n", failures, failure_rate);
		fprintf(out, ";%.2f", failure_rate);
		fprintf(out, "\n");
	} // end sizes loop

	fclose(out);
}
