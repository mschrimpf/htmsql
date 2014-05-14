#include <stdlib.h>
#include <stdio.h>

#include <immintrin.h> // rtm
#include "../Stats.h"

/**
 * @return 0 if success, 1 otherwise
 */
int stack(int size) {
	if (_xbegin() == _XBEGIN_STARTED) {
		unsigned char buf[size];
		_xend();
		return 0;
	} else {
		return 1;
	}
}

/**
 * @return 0 if success, 1 otherwise
 */
int freeStore(int size) {
	if (_xbegin() == _XBEGIN_STARTED) {
		unsigned char *buf = new unsigned char[size];
		delete[] buf;
		_xend();
		return 0;
	} else {
		return 1;
	}
}

/**
 * @return 0 if success, 1 otherwise
 */
int heap(int size) {
	if (_xbegin() == _XBEGIN_STARTED) {
		unsigned char *buf = (unsigned char*) malloc(
				sizeof(unsigned char) * size);
		free(buf);
		_xend();
		return 0;
	} else {
		return 1;
	}
}

int main(int argc, char *argv[]) {
	int loops = argc > 1 ? atoi(argv[1]) : 1000, size =
			argc > 2 ? atoi(argv[2]) : 1;

	// Stack
	Stats stackStats;
	printf("Stack");
	for (int i = 0; i < loops; ++i) {
		int fail = stack(size);
		stackStats.addValue(fail);
	}
	printf(";%.2f\n", stackStats.getExpectedValue() * 100);

	// Free Store
	Stats freeStoreStats;
	printf("Free Store");
	for (int i = 0; i < loops; ++i) {
		int fail = freeStore(size);
		freeStoreStats.addValue(fail);
	}
	printf(";%.2f\n", freeStoreStats.getExpectedValue() * 100);

	// Heap
	Stats heapStats;
	printf("Heap");
	for (int i = 0; i < loops; ++i) {
		int fail = heap(size);
		heapStats.addValue(fail);
	}
	printf(";%.2f\n", heapStats.getExpectedValue() * 100);
}


// same results
int deleteOnly(unsigned char * p) {
	if (_xbegin() == _XBEGIN_STARTED) {
		delete p;
		_xend();
		return 0;
	} else {
		return 1;
	}
}
