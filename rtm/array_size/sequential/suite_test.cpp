#include <stdio.h>
#include <stdlib.h>

#include <immintrin.h>

#include "../../../util.h"

#define type int

int main(int argc, char *argv[]) {
	// arguments
	int loops = 1000, sizes_min = 2000, sizes_max = 8000, sizes_step = 1000;
	int *values[] = { &loops, &sizes_min, &sizes_max, &sizes_step };
	const char *identifier[] = { "-l", "-smin", "-smax", "-sstep" };
	handle_args(argc, argv, 4, values, identifier);

	printf("%d - %d runs with steps of %d\n", sizes_min, sizes_max, sizes_step);
	printf("Looped %d times\n", loops);
	printf("\n");
	int sizes_count = (sizes_max - sizes_min + sizes_step) / sizes_step;
	int sizes[sizes_count];
	for (int i = 0; i < sizes_count; i++) {
		sizes[i] = sizes_min + i * sizes_step;
	}

	FILE * out = stdout; //fopen("clear_write_read.csv", "w");

	// pre - not doing this will lead to higher failure rates
	int _size = 2000;
	volatile type* _array = (volatile type *) malloc(_size * sizeof(type));
//	if (_xbegin() == _XBEGIN_STARTED) {
//		for (int i = 0; i < _size; i++) {
//			_array[i]++; // write
//		}
//		_xend();
		fprintf(out, "Allocated %d array before\n", _size);
//	} else {
//		fprintf(out, "Could not init\n");
//	}
	free((void*) _array);


	// run suite
	fprintf(out, "Sizes\tFailure rate\n");
	for (int s = 0; s < sizeof(sizes) / sizeof(sizes[0]); s++) {
		int size = sizes[s];
		fprintf(out, "%d", size);
		int failures = 0;
		int attempts = 0;
		for (int l = 0; l < loops; l++) {
			volatile type* array = (volatile type *) malloc(
					size * sizeof(type));

			retry: attempts++;
			if (_xbegin() == _XBEGIN_STARTED) {
				for (int i = 0; i < size; i++) {
					array[i]++; // write
				}
				_xend();
			} else {
				failures++;
			}

			free((void*) array);
		} // end loops loop
		float failure_rate = (float) failures * 100 / attempts;
//			printf("Loops:         %d\n", loops);
//			printf("Attempts:      %d\n", attempts);
//			printf("Failures:      %d (Rate: %.2f%%)\n", failures, failure_rate);
		fprintf(out, "\t%.2f", failure_rate);
		fprintf(out, "\n");
	} // end sizes loop

	fclose(out);
}
