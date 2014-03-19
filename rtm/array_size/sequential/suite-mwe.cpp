#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/time.h>
#include <vector>
#include <string.h> // strcmp
#include <immintrin.h> // RTM: _x*

#define max(a, b) ((a) > (b) ? (a) : (b))

//
// util
//
void handle_args(int argc, char *argv[], int value_len, int **values,
		const char* identifier[], int *print_help) {
	for (int a = 1; a < argc; a++) {
		if (print_help
				&& (!strcmp(argv[a], "-h") || !strcmp(argv[a], "--help"))) {
			*print_help = 1;
			return;
		}
		for (int i = 0; i < value_len; i++) {
			if (strcmp(argv[a], identifier[i]) == 0) {
				*values[i] = atoi(argv[++a]);
			}
		}
	}
}

double average(std::vector<double> values) {
	double sum = 0;
	for (std::vector<double>::iterator it = values.begin(); it != values.end();
			it++) {
		sum += *it;
	}
	return sum / values.size();
}

//
// suite
//
int main(int argc, char *argv[]) {
	// arguments
	int loops = 1000, sizes_min = 0, sizes_max = 800000, sizes_step = 5000,
			write = 1, print_help = 0;
	int *values[] = { &loops, &sizes_min, &sizes_max, &sizes_step, &write };
	const char *identifier[] = { "-l", "-smin", "-smax", "-sstep", "-w" };
	handle_args(argc, argv, 5, values, identifier, &print_help);

	if (print_help) {
		printf(
				"Run with\n./suite-mwe [-l loops] [-smin sizes_min] [-smax sizes_max] [-sstep sizes_stepsize] [-w write]\n"
						"loops: amount of retry loops\n"
						"sizes_min: first array size\n"
						"sizes_max: last array_size\n"
						"sizes_stepsize: stepsize for sizes between sizes_min and sizes_max\n"
						"write: != 0 to write to files\n");
		return 0;
	}

	printf("%d - %d runs with steps of %d\n", sizes_min, sizes_max, sizes_step);
	printf("Looped %d times\n", loops);
	printf("Printing to %s\n", write ? "files" : "stdout");
	printf("\n");
	int sizes_small_count = 10, small_step = 1000;
	int sizes_count = sizes_small_count
			+ (sizes_max - sizes_min + sizes_step) / sizes_step;
	int sizes[sizes_count];
	for (int i = 0; i < sizes_small_count; i++) { // make smaller steps in the beginning
		sizes[i] = (i + 1) * small_step;
	}
	for (int i = sizes_small_count; i < sizes_count; i++) {
		sizes[i] = max(sizes_min, sizes_small_count * small_step)
				+ (i - sizes_small_count + 1) * sizes_step;
	}

	// open files
	const char *failures_filename = "array_suite-failures.csv";
	const char *time_filename = "array_suite-time.csv";
	FILE * failures_out = write ? fopen(failures_filename, "w") : stdout;
	FILE * time_out = write ? fopen(time_filename, "w") : stdout;

	// info
	fprintf(failures_out, "Sizes;Failure rate\n");
	fprintf(time_out, "Sizes;Time in ms\n");

	// run suite
	for (int s = 0; s < sizeof(sizes) / sizeof(sizes[0]); s++) {
		int size = sizes[s];
		fprintf(failures_out, "%d", size);
		fprintf(time_out, "%d", size);
		int failures = 0;
		int attempts = 0;
		std::vector<double> times;
		for (int l = 0; l < loops; l++) {
			// init
			volatile int* array = (volatile int *) malloc(size * sizeof(int));
			for (int i = 0; i < size; i++) {
				array[i] = 0;
			}

			// run
			attempts++;
			struct timeval start, end;
			gettimeofday(&start, NULL);

			int dummy;
			if (_xbegin() == _XBEGIN_STARTED) {
				for (int i = 0; i < size; i++) {
					dummy = array[i]; // GCC option O0 needed!
				}
				_xend();
			} else {
				failures++;
			}

			gettimeofday(&end, NULL);
			double elapsed = ((end.tv_sec - start.tv_sec) * 1000)
					+ (end.tv_usec / 1000 - start.tv_usec / 1000);
			times.push_back(elapsed);

			free((void*) array);
		} // end loops loop
		float failure_rate = (float) failures * 100 / attempts;
		float avg_time = average(times);
		fprintf(failures_out, ";%.2f\n", failure_rate);
		fprintf(time_out, ";%.2f\n", avg_time);
	} // end sizes loop

	fclose(failures_out);
	fclose(time_out);

	if (write) {
		printf("Output written to files\n");
	}
}
