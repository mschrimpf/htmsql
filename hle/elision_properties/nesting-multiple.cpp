#include <stdio.h>
#include <stdlib.h>

#include "../lib/hle-emulation.h"
#include <xmmintrin.h> // _mm_pause
#include "../../util.h"

int i = 0;

int hle_lock(unsigned * mutex) {
	while (__hle_acquire_test_and_set4(mutex)) {
		return 1;
//		_mm_pause();
	}
	return 0;
}
void hle_unlock(unsigned * mutex) {
	__hle_release_clear4(mutex);
}

int nest_multiple(unsigned mutexes[], int mutexes_length) {
	for (int m = 0; m < mutexes_length; m++) {
		if (hle_lock(&mutexes[m]) != 0)
			return 1;
	}

	i++;

	// unlock in reverse order
	for (int m = mutexes_length - 1; m >= 0; m--) {
		hle_unlock(&mutexes[m]);
	}
	return 0;
}

int main(int argc, char *argv[]) {
	int loops = argc > 1 ? atoi(argv[1]) : 10;
	int max_mutexes = argc > 2 ? atoi(argv[2]) : 10;
	int mutex_count_step = max_mutexes > 10 ? max_mutexes / 10 : 1;

	printf("Mutexes;Attempts;Failures;Failure Rate\n");
	for (int mutex_count = 0; mutex_count <= max_mutexes;
			mutex_count += mutex_count_step) {
		printf("%d", mutex_count);
		int failures = 0;

		for (int l = 0; l < loops; l++) {
			unsigned * mutexes = (unsigned *) calloc(mutex_count,
					sizeof(unsigned));
			for (int m = 0; m < mutex_count; m++)
				mutexes[m] = 0; // make sure the mutex is not set
			failures += nest_multiple(mutexes, mutex_count);
			free(mutexes);
		}

		float failure_rate = (float) failures / loops * 100;
		printf(";%d;%d;%.2f\n", loops, failures, failure_rate);
	}

	printf("i: %d\n", i);
}
