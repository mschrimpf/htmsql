#include <stdio.h>
#include <stdlib.h>

#include <immintrin.h>

#include "../../util.h"

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

int run_seq_write(volatile type *array[], int size) {
//	volatile type *a = *array;
	if (_xbegin() == _XBEGIN_STARTED) {
		for (int i = 0; i < size; i++) {
			(*array)[i]++; // write
//			a[i]++;
		}
		_xend();
		return 1;
	} else {
		return 0;
	}
}
int run_seq_read(volatile type *array[], int size) {
	type dummy;
	if (_xbegin() == _XBEGIN_STARTED) {
		for (int i = 0; i < size; i++) {
			dummy = (*array)[i]; // read - GCC option O0 needed!
		}
		_xend();
		return 1;
	} else {
		return 0;
	}
}

int rnd;
int max_retries = 0;
int run_rnd_write(volatile type *array[], int size) {
	int failures = 0;
	retry: srand(rnd); // generate new randomness
	// (otherwise, the old "random" values would occur again after a retry
	// since the internal rand()-value would be aborted and therefore reset)
	rnd = rand();
	if (_xbegin() == _XBEGIN_STARTED) {
		for (int i = 0; i < size; i++) {
			(*array)[i]++; // write
		}
		_xend();
		return 1;
	} else {
		if(failures++ < max_retries)
			goto retry;
		return 0;
	}
}
int run_rnd_read(volatile type *array[], int size) {
	type dummy;
	int failures = 0;
	retry: srand(rnd);
	rnd = rand();
	if (_xbegin() == _XBEGIN_STARTED) {
		for (int i = 0; i < size; i++) {
			dummy = (*array)[i]; // read - GCC option O0 needed!
		}
		_xend();
		return 1;
	} else {
		if(failures++ < max_retries)
			goto retry;
		return 0;
	}
}

class MeasureType {
public:
	static const MeasureType NOINIT_SEQ_WRITE;
	static const MeasureType INIT_SEQ_WRITE;
	static const MeasureType NOINIT_SEQ_READ;
	static const MeasureType INIT_SEQ_READ;
	static const MeasureType NOINIT_RND_WRITE;
	static const MeasureType INIT_RND_WRITE;
	static const MeasureType NOINIT_RND_READ;
	static const MeasureType INIT_RND_READ;

	volatile type* (*init)(int size);
	/** return: true for success, false otherwise */
	int (*run)(volatile type *array[], int size);
private:
	MeasureType(volatile type* (*init)(int size),
			int (*run)(volatile type *array[], int size)) {
		this->init = init;
		this->run = run;
	}
};
const MeasureType MeasureType::NOINIT_SEQ_WRITE = MeasureType(malloc_init,
		run_seq_write);
const MeasureType MeasureType::INIT_SEQ_WRITE = MeasureType(init_clear,
		run_seq_write);
const MeasureType MeasureType::NOINIT_SEQ_READ = MeasureType(malloc_init,
		run_seq_read);
const MeasureType MeasureType::INIT_SEQ_READ = MeasureType(init_clear,
		run_seq_read);
const MeasureType MeasureType::NOINIT_RND_WRITE = MeasureType(malloc_init,
		run_rnd_write);
const MeasureType MeasureType::INIT_RND_WRITE = MeasureType(init_clear,
		run_rnd_write);
const MeasureType MeasureType::NOINIT_RND_READ = MeasureType(malloc_init,
		run_rnd_read);
const MeasureType MeasureType::INIT_RND_READ = MeasureType(init_clear,
		run_rnd_read);
void printHeader(const MeasureType *types[], int size, FILE *out = stdout) {
	for (int t = 0; t < size; t++) {
		if (types[t] == &MeasureType::NOINIT_SEQ_WRITE)
			fprintf(out, "NOINIT_SEQ_WRITE");
		else if (types[t] == &MeasureType::INIT_SEQ_WRITE)
			fprintf(out, "INIT_SEQ_WRITE");
		else if (types[t] == &MeasureType::NOINIT_SEQ_READ)
			fprintf(out, "NOINIT_SEQ_READ");
		else if (types[t] == &MeasureType::INIT_SEQ_READ)
			fprintf(out, "INIT_SEQ_READ");
		else if (types[t] == &MeasureType::NOINIT_RND_WRITE)
			fprintf(out, "NOINIT_RND_WRITE");
		else if (types[t] == &MeasureType::INIT_RND_WRITE)
			fprintf(out, "INIT_RND_WRITE");
		else if (types[t] == &MeasureType::NOINIT_RND_READ)
			fprintf(out, "NOINIT_RND_READ");
		else if (types[t] == &MeasureType::INIT_RND_READ)
			fprintf(out, "INIT_RND_READ");
		fprintf(out, "%s", t < size - 1 ? ";" : "\n");
	}
}

int main(int argc, char *argv[]) {
	// arguments
	int loops = 1000, sizes_min = 2000, sizes_max = 800000, sizes_step = 1000,
			write = 0;
	int *values[] = { &loops, &sizes_min, &sizes_max, &sizes_step, &write, &max_retries };
	const char *identifier[] = { "-l", "-smin", "-smax", "-sstep", "-w", "-max_retries" };
	handle_args(argc, argv, 6, values, identifier);

	printf("%d - %d runs with steps of %d\n", sizes_min, sizes_max, sizes_step);
	printf("Maximum %d retries\n", max_retries);
	printf("Looped %d times\n", loops);
	printf("Printing to %s\n", write ? "file" : "stdout");
	printf("\n");
	int sizes_count = (sizes_max - sizes_min + sizes_step) / sizes_step;
	int sizes[sizes_count];
	for (int i = 0; i < sizes_count; i++) {
		sizes[i] = sizes_min + i * sizes_step;
	}

	const MeasureType *measureTypes[] = { &MeasureType::NOINIT_SEQ_WRITE,
			&MeasureType::INIT_SEQ_WRITE, &MeasureType::NOINIT_SEQ_READ,
			&MeasureType::INIT_SEQ_READ, &MeasureType::NOINIT_RND_WRITE,
			&MeasureType::INIT_RND_WRITE, &MeasureType::NOINIT_RND_READ,
			&MeasureType::INIT_RND_READ };

	FILE * out = write ? fopen("array_suite-2retry.csv", "w") : stdout;

	// info
	fprintf(out, "Sizes;");
	printHeader(measureTypes, sizeof(measureTypes) / sizeof(measureTypes[0]),
			out);

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
