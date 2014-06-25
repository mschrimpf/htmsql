#include <stdio.h>
#include <stdlib.h>

#include "../lib/hle-emulation.h"
#include <xmmintrin.h> // _mm_pause
#include <immintrin.h> // _xtest
#include "../../util.h"

class PaddedMutex {
private:
	unsigned char padding[64 - 4];
public:
	unsigned mutex;
};

int i = 0;

void hle_lock(unsigned * mutex) {
	while (__hle_acquire_test_and_set4(mutex)) {
		_mm_pause();
	}
}
void hle_unlock(unsigned * mutex) {
	__hle_release_clear4(mutex);
}

void smart_hle_lock(unsigned * mutex) {
	if (_xtest() && *mutex != 98789347) { // read the lock_word to store it in the read-set (compare with value that will normally not be held)
		return; // avoid nesting errors - lock only once and ignore consecutive ones
	}
	while (__hle_acquire_test_and_set4(mutex)) {
		_mm_pause();
	}
}
void smart_hle_unlock(unsigned * mutex) {
	if(*mutex == 0) // not set
		return;
	__hle_release_clear4(mutex);
}

int nest_multiple(int mutex_count, void (*lock)(unsigned*),
		void (*unlock)(unsigned*)) {
	PaddedMutex * mutexes = (PaddedMutex *) malloc(
			sizeof(PaddedMutex) * mutex_count);
//	PaddedMutex * mutexes = (PaddedMutex *) aligned_alloc(cache_line_size,
//			sizeof(PaddedMutex*) * mutex_count); // leads to nonsense segfaults in iteration
	if (!mutexes) {
		printf("Could not allocate memory for %d mutexes\n", mutex_count);
		exit(1);
	}
	for (int m = 0; m < mutex_count; m++) {
		mutexes[m].mutex = 0; // make sure the mutex is not set
//			printf("&mutexes[%d]: %p\n", m, &mutexes[m]); // they are actually aligned on multiples of 64
	}

	for (int m = 0; m < mutex_count; m++) {
		lock(&mutexes[m].mutex);
	}

	i++;

	for (int m = 0; m < mutex_count; m++) {
		unlock(&mutexes[m].mutex);
	}
	free(mutexes);
	return 0;
}

int main(int argc, char *argv[]) {
	int loops = 10, wait = 0;
	int min_mutexes = 0, max_mutexes = 10;
	int *values[] = { &loops, &min_mutexes, &max_mutexes, &wait };
	const char *identifier[] = { "-l", "-mmin", "-mmax", "-w" };
	handle_args(argc, argv, 4, values, identifier);

	if (wait)
		usleep(500000);

	int mutex_diff = max_mutexes - min_mutexes;
	int mutex_count_step = mutex_diff > 10 ? mutex_diff / 10 : 1;

	printf("%d - %d mutexes with steps of %d in %d loops\n", min_mutexes,
			max_mutexes, mutex_count_step, loops);

	printf("sizeof(PaddexMutex): %lu\n", sizeof(PaddedMutex));

	printf("\n>> MEASURE WITH PERF <<\n\n");

	printf(
			"Mutexes;Attempts;Failures;Amount of times the mutex was occupied\n");
	for (int mutex_count = min_mutexes; mutex_count <= max_mutexes;
			mutex_count += mutex_count_step) {
		printf("%d", mutex_count);
		int failures = 0;

		for (int l = 0; l < loops; l++) {
			failures += nest_multiple(mutex_count, hle_lock, hle_unlock);
			failures += nest_multiple(mutex_count, smart_hle_lock,
					smart_hle_unlock);
		}

		float failure_rate = (float) failures / loops * 100;
		printf(";%d;%d;%.2f\n", loops, failures, failure_rate);
	}

	printf("i: %d\n", i);
}
