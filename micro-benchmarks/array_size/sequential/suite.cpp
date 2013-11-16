#include <stdio.h>
#include <stdlib.h>

#include <immintrin.h>

#include "../../../util.h"

#define type int

volatile type* malloc_init(int size) {
	return (volatile type *) malloc(size * sizeof(type));
}
volatile type* init_clear(int size) {
	volatile type* a = malloc_init(size);
	for (int i = 0; i < size; i++) {
		a[i] = 0;
	}
	return a;
}

int run_seq_write(volatile type **array, int size) {
	volatile type *a = *array;
	if (_xbegin() == _XBEGIN_STARTED) {
		for (int i = 0; i < size; i++) {
//			array[i]++; // write
			a[i]++;
		}
		_xend();
		return 1;
	} else {
		return 0;
	}
}
int run_seq_read(volatile type **array, int size) {
	volatile type *a = *array;
	type dummy;
	if (_xbegin() == _XBEGIN_STARTED) {
		for (int i = 0; i < size; i++) {
//			dummy = array[i]; // read - GCC option O0 needed!
			dummy = a[i];
		}
		_xend();
		return 1;
	} else {
		return 0;
	}
}

int run_rnd_write(volatile type **array, int size) {
	volatile type *a = *array;
	if (_xbegin() == _XBEGIN_STARTED) {
		for (int i = 0; i < size; i++) {
//			array[i]++; // write
			a[i]++;
		}
		_xend();
		return 1;
	} else {
		return 0;
	}
}
int run_rnd_read(volatile type **array, int size) {
	volatile type *a = *array;
	type dummy;
	if (_xbegin() == _XBEGIN_STARTED) {
		for (int i = 0; i < size; i++) {
//			dummy = array[i]; // read - GCC option O0 needed!
			dummy = a[i];
		}
		_xend();
		return 1;
	} else {
		return 0;
	}
}

class MeasureType {
public:
	static const MeasureType NOINIT_SEQWRITE;
	static const MeasureType INIT_SEQWRITE;
	static const MeasureType NOINIT_SEQREAD;
	static const MeasureType INIT_SEQREAD;

	volatile type* (*init)(int size);
	/** return: true for success, false otherwise */
	int (*run)(volatile type **array, int size);
private:
	MeasureType(volatile type* (*init)(int size),
			int (*run)(volatile type **array, int size)) {
		this->init = init;
		this->run = run;
	}
};
const MeasureType MeasureType::NOINIT_SEQWRITE = MeasureType(malloc_init,
		run_seq_write);
const MeasureType MeasureType::INIT_SEQWRITE = MeasureType(init_clear, run_seq_write);
const MeasureType MeasureType::NOINIT_SEQREAD = MeasureType(malloc_init, run_seq_read);
const MeasureType MeasureType::INIT_SEQREAD = MeasureType(init_clear, run_seq_read);
void printHeader(const MeasureType *types[], int size, FILE *out = stdout) {
	for (int t = 0; t < size; t++) {
		if (types[t] == &MeasureType::NOINIT_SEQWRITE)
			fprintf(out, "NOINIT_SEQWRITE");
		else if (types[t] == &MeasureType::INIT_SEQWRITE)
			fprintf(out, "INIT_SEQWRITE");
		else if (types[t] == &MeasureType::NOINIT_SEQREAD)
			fprintf(out, "INIT_SEQWRITE");
		else if (types[t] == &MeasureType::INIT_SEQREAD)
			fprintf(out, "INIT_SEQREAD");
		fprintf(out, "%s", t < size - 1 ? ";" : "\n");
	}
}

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

	const MeasureType *measureTypes[] = { &MeasureType::NOINIT_WRITE/*,
			&MeasureType::INIT_WRITE, &MeasureType::NOINIT_READ,
			&MeasureType::INIT_READ*/ };

	FILE * out = stdout;//fopen("clear_write_read.csv", "w");

	// info
	fprintf(out, "Sizes;");
	printHeader(measureTypes, sizeof(measureTypes) / sizeof(measureTypes[0]), out);

	// run suite
	for (int s = 0; s < sizeof(sizes) / sizeof(sizes[0]); s++) {
		fprintf(out, "%d", sizes[s]);
		for (int t = 0; t < sizeof(measureTypes) / sizeof(measureTypes[0]);
				t++) {
			int failures = 0;
			int attempts = 0;
			for (int l = 0; l < loops; l++) {
				// init
				volatile type* array = measureTypes[t]->init(sizes[s]);

				// run
				retry: attempts++;
				if (!measureTypes[t]->run(&array, sizes[s])) {
					failures++;
//					goto retry;
				}

				free((void*) array);
			} // end loops loop
			float failure_rate = (float) failures * 100 / attempts;
//			printf("Loops:         %d\n", loops);
//			printf("Attempts:      %d\n", attempts);
//			printf("Failures:      %d (Rate: %.2f%%)\n", failures, failure_rate);
			fprintf(out, ";%.2f", failure_rate);
		} // end types loop
		fprintf(out, "\n");
	} // end sizes loop

	fclose(out);
}
