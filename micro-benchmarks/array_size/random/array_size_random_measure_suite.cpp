#include <stdlib.h>
#include <stdio.h>
#include <fstream>
#include <iostream>
#include <sstream>
#include <sys/time.h>

#include <immintrin.h>

#include "util.h"

#define FILE_VALUE_SEPARATOR " "

int main(int argc, char *argv[]) {
	int size = 100000, loops = 10000;
	int* values[] = { &size, &loops };
	const char* identifier[] = { "-s", "-l" };
	handle_args(argc, argv, 2, values, identifier);

	volatile int* array = (volatile int *) malloc(size * sizeof(int));
	printf("Array size:       %d\n", size);
	printf("Loops:            %d\n", loops);

	// file handle
	std::stringstream fstm;
	fstm << "Retries" << FILE_VALUE_SEPARATOR << "Accesses"
			<< FILE_VALUE_SEPARATOR << "Partial_Attempts"
			<< FILE_VALUE_SEPARATOR << "Partial_Failures"
			<< FILE_VALUE_SEPARATOR << "Partial Failure_Rate"
			<< FILE_VALUE_SEPARATOR << "Attempts" << FILE_VALUE_SEPARATOR
			<< "Failures" << FILE_VALUE_SEPARATOR << "Failure_Rate\"\n";
	const char* file_header = fstm.str().c_str();

	// time measurement
	struct timeval start, end;
	gettimeofday(&start, NULL);

	// define measured values
	int retries[] = { 0 }; //, 1, 2, 3 };
	int accesses[] = { 1 }; //, 10, 100, 1000, 2000, 3000 }; //, 4000, 5000, 6000, 7000, 8000,9000, 10000 };

	// execute suite: check the failure rate for all accesses in all retries
	int repeats = sizeof(retries) / sizeof(retries[0]);
	for (int r = 0; r < repeats; r++) { // retry loop
		std::stringstream sstm;
		sstm.str(std::string());
		sstm.clear();
		sstm << "array_size_random-" << r << ".txt";
		const char *filename = sstm.str().c_str();
		printf("Retry %d\n", r);

		std::fstream stats_file;
		stats_file.open(filename, std::ios::trunc | std::ios::out);
		stats_file << file_header;

		for (int a = 0; a < sizeof(accesses) / sizeof(accesses[0]); a++) { // accesses loop
			stats_file << retries[r] << FILE_VALUE_SEPARATOR << accesses[a]
					<< FILE_VALUE_SEPARATOR;

			int attempts = 0, partial_attempts = 0, partial_failures = 0,
					failures = 0;
			for (int l = 0; l < loops; l++) {
				/* BEGIN: core code */
				int retrynum = 0;
				attempts++;
				retry: partial_attempts++;
				if (_xbegin() == _XBEGIN_STARTED) {
					for (int i = 0; i < size; i++) {
						array[rand() % size]++;
					}
					_xend();
				} else {
					partial_failures++;
					if (retrynum < retries[r]) {
						retrynum++;
						goto retry;
					} else {
						failures++;
					}
				}
				/* END: core code */
			}

			stats_file << partial_attempts << FILE_VALUE_SEPARATOR;
			stats_file << partial_failures << FILE_VALUE_SEPARATOR;
			stats_file
					<< (float) partial_failures * 100
							/ partial_attempts << FILE_VALUE_SEPARATOR;
			stats_file << attempts << FILE_VALUE_SEPARATOR;
			stats_file << failures << FILE_VALUE_SEPARATOR;
			stats_file << (float) failures * 100 / attempts << "\n";
			printf("Failure rate: %.2f\n", failures * 100.0 / attempts);
		}

		stats_file.close();
	}
	free((void*) array);
	gettimeofday(&end, NULL);

	double elapsed = ((end.tv_sec - start.tv_sec) * 1000)
			+ (end.tv_usec / 1000 - start.tv_usec / 1000);
	printf("\nFinished in %.0f ms\n", elapsed);

	return 0;
}

