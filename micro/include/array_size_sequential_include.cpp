#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <sstream>
#include <fstream>

#include <immintrin.h>

int main(int argc, char *argv[]) {
	int size = argc > 1 ? atoi(argv[1]) : 10000;
	volatile int* a = (volatile int *) malloc(size * sizeof(int));
	std::stringstream sstm;
	sstm << "Array size:    " << size << "\n";
	printf("sstm & fstm\n%s", sstm.str().c_str());
//	printf("Array size:    %d\n", size);
	std::fstream file;
	file.open("test.txt", std::ios::trunc | std::ios::out);
	file << "test";

	int failures = 0, attempts = 0;

	int loops = argc > 2 ? atoi(argv[2]) : 100000;
	int i;
	for (i = 0; i < loops; i++) {

		retry: attempts++;
		if (_xbegin() == _XBEGIN_STARTED) {
			for (int i = 0; i < size; i++) {
				a[i]++;
			}
			_xend();
		} else {
			failures++;
//			goto retry;
		}
	}

	free((void*) a);

	file.close();

	printf("Loops:         %d\n", loops);
	printf("Attempts:      %d\n", attempts);
	printf("Failures:      %d (Rate: %.2f%%)\n", failures,
			(float) failures * 100 / attempts);

	return 0;
}

