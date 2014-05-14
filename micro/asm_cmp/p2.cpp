#include <stdlib.h>
#include <stdio.h>
#include <fstream>
#include <iostream>
#include <sstream>

#include <immintrin.h>

#include "util.h"

#define FILE_VALUE_SEPARATOR " "

int main(int argc, char *argv[]) {
	int size = 2042, loops = 100000;
	int* values[] = { &size, &loops };
	const char* identifier[] = { "-s", "-l" };
	handle_args(argc, argv, 2, values, identifier);

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

	// define measured values
	std::stringstream sstm;
	sstm.str(std::string());
	sstm.clear();
	sstm << "array_size_random-0.txt";
	const char *filename = sstm.str().c_str();

	std::fstream stats_file;
	stats_file.open(filename, std::ios::trunc | std::ios::out);
	stats_file << file_header;

	volatile int* array = (volatile int *) malloc(size * sizeof(int));
	int attempts = 0, /*partial_attempts = 0, partial_failures = 0,*/
	failures = 0;
	for (int l = 0; l < loops; l++) {

		/* BEGIN: core code */
		retry: attempts++;
		if (_xbegin() == _XBEGIN_STARTED) {
			for (int i = 0; i < size; i++) {
				array[i]++;
			}
			_xend();
		} else {
			failures++;
		}
		/* END: core code */
	}
	free((void*) array);

	printf("Failure rate: %.2f%%\n", failures * 100.0 / attempts);


	return 0;
}

