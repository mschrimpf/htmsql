#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <unistd.h>
#include <sys/time.h>
#include <vector>
#include <cmath> // sqrt
#include <immintrin.h>

#include "../../util.h"

#define max(a, b) ((a) > (b) ? (a) : (b))

#define type unsigned char
#define RAND(lim) rand_gerhard(lim)

void shuffle_array(int *array, int size) {
	// from: http://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle#The_modern_algorithm
	for (int i = size - 1; i > 0; i--) {
		int j = rand() % i + 1;
		// swap
		int h = array[j];
		array[j] = array[i];
		array[i] = array[j];
	}
}

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
	if (_xbegin() == _XBEGIN_STARTED) {
		for (int i = 0; i < size; i++) {
			(*array)[i]++; // write
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
	retry:
//	srand(rnd); // generate new randomness
	// (otherwise, the old "random" values would occur again after a retry
	// since the internal rand()-value would be aborted and therefore reset)
	rnd = RAND(size);
	if (_xbegin() == _XBEGIN_STARTED) {
		for (int i = 0; i < size; i++) {
			(*array)[RAND(size)]++; // write
		}
		_xend();
		return 1;
	} else {
		if (failures++ < max_retries)
			goto retry;
		return 0;
	}
}
int run_rnd_read(volatile type *array[], int size) {
	type dummy;
	int failures = 0;
	retry:
//	srand(rnd);
	rnd = RAND(size);
	if (_xbegin() == _XBEGIN_STARTED) {
		for (int i = 0; i < size; i++) {
			dummy = (*array)[RAND(size)]; // read - GCC option O0 needed!
		}
		_xend();
		return 1;
	} else {
		if (failures++ < max_retries)
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
		for (int v = 0; v <= 1; v++) {
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
			fprintf(out, "%s", v == 0 ? " ExpectedValue;" : " Stddev");
			if (v == 1)
				fprintf(out, "%s", t < size - 1 ? ";" : "\n");
		}
	}
}

int main(int argc, char *argv[]) {
	// arguments
	int loops = 10, sizes_min = 1, sizes_max = 800000, sizes_step = 5000,
			write = 0;
	int *values[] = { &loops, &sizes_min, &sizes_min, &sizes_max, &sizes_max,
			&sizes_step, &sizes_step, &write, &max_retries };
	const char *identifier[] = { "-l", "-smin", "-rmin", "-smax", "-rmax",
			"-sstep", "-rstep", "-w", "-max_retries" };
	handle_args(argc, argv, 9, values, identifier);

	printf("%d - %d runs with steps of %d\n", sizes_min, sizes_max, sizes_step);
	printf("Maximum %d retries\n", max_retries);
	printf("Looped %d times\n", loops);
	printf("Printing to %s\n", write ? "files" : "stdout");
	printf("\n");

	const MeasureType *measureTypes[] = {
	// write sequential
//			&MeasureType::NOINIT_SEQ_WRITE, &MeasureType::INIT_SEQ_WRITE,
			// read sequential
//			&MeasureType::NOINIT_SEQ_READ, &MeasureType::INIT_SEQ_READ,
			// write random
			&MeasureType::NOINIT_RND_WRITE, &MeasureType::INIT_RND_WRITE,
			// read random
//			&MeasureType::NOINIT_RND_READ, &MeasureType::INIT_RND_READ
	//
			};

	// open files
	char retries_str[21]; // enough to hold all numbers up to 64-bits
	sprintf(retries_str, "%d", max_retries);
	std::string file_prefix = "write-rnd-", failures_file_suffix =
			"retries-failures.csv", time_file_suffix = "retries-time.csv";
	std::string failures_filename = file_prefix + retries_str
			+ failures_file_suffix; //"write-seq-failures.csv"; //
	std::string time_filename = file_prefix + retries_str + time_file_suffix; //"write-seq-time.csv"; //
	FILE * failures_out =
			write ? fopen(failures_filename.c_str(), "w") : stdout;
	FILE * time_out = fopen(time_filename.c_str(), "w");

	// info
	fprintf(failures_out, "Size (Byte);");
	printHeader(measureTypes, sizeof(measureTypes) / sizeof(measureTypes[0]),
			failures_out);
	fprintf(time_out, "Size (Byte);");
	printHeader(measureTypes, sizeof(measureTypes) / sizeof(measureTypes[0]),
			time_out);

	// run suite
	srand(time(0));
	for (int s = sizes_min; s <= sizes_max; s += sizes_step) {
		fprintf(failures_out, "%lu", s * sizeof(type));
		fprintf(time_out, "%lu", s * sizeof(type));
		for (int t = 0; t < sizeof(measureTypes) / sizeof(measureTypes[0]);
				t++) {
			float failure_expected_value_sum = 0, failure_variance_sum = 0;
			float time_expected_value_sum = 0, time_variance_sum = 0;
			for (int l = 0; l < loops; l++) {
				int failures = 0;
				int attempts = 0;
				std::vector<double> times;
				for (int il = 0; il < 100; il++) {
					// init
					volatile type* array = measureTypes[t]->init(s);

					// run
					attempts++;
					struct timeval start, end;
					gettimeofday(&start, NULL);
					int res = measureTypes[t]->run(&array, s);
					gettimeofday(&end, NULL);
					double elapsed = ((end.tv_sec - start.tv_sec) * 1000000)
							+ (end.tv_usec - start.tv_usec);
					times.push_back(elapsed);
					if (!res) {
						failures++;
					}

					free((void*) array);
				} // end inner loops loop
				float failure_rate = (float) failures * 100 / attempts;
				failure_expected_value_sum += failure_rate;
				failure_variance_sum += (failure_rate * failure_rate);
				float time_avg = average(times);
				time_expected_value_sum += time_avg;
				time_variance_sum += (time_avg * time_avg);
			} // end loops loop
			  // failures
			float failure_expected_value = failure_expected_value_sum * 1.0
					/ loops; // mu = p * sum(x_i)
			float failure_variance = 1.0 / loops * failure_variance_sum
					- (failure_expected_value * failure_expected_value); // var = p * sum(x_i^2) - mu^2
			float failure_stddev = sqrt(failure_variance);
			if (failure_expected_value + failure_stddev > 100)
				printf("BEEP BEEP BEEP\n"); // TODO is this case allowed from a math point of view?
			fprintf(failures_out, ";%.4f;%.4f", failure_expected_value,
					failure_stddev);
			// time
			float time_expected_value = time_expected_value_sum * 1.0 / loops; // mu = p * sum(x_i)
			float time_variance = 1.0 / loops * time_variance_sum
					- (time_expected_value * time_expected_value); // var = p * sum(x_i^2) - mu^2
			float time_stddev = sqrt(time_variance);
			fprintf(time_out, ";%.4f;%.4f", time_expected_value, time_stddev);
		} // end types loop
		fprintf(failures_out, "\n");
		fprintf(time_out, "\n");
	} // end sizes loop

	fclose(failures_out);
	fclose(time_out);
}
