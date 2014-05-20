#include <stdlib.h>
#include <stdio.h>
#include <thread>
#include <immintrin.h> // RTM
#include "../util.h"

int shared;

void run(int repeats) {
	for (int i = 0; i < repeats; i++) {
		retry: if (_xbegin() == _XBEGIN_STARTED) {
			shared++;
			_xend();
		} else {
			goto retry;
		}
	}
}

int main(int argc, char *argv[]) {
	int repeats = 1000000, num_threads = 2;
	int *values[] = { &repeats, &num_threads };
	const char *labels[] = { "-r", "-t" };
	handle_args(argc, argv, 2, values, labels);

	printf("Repeats: %d\n", repeats);
	printf("Threads: %d\n", num_threads);

	std::thread threads[num_threads];
	for(int i=0; i<num_threads;i++) {
		threads[i] = std::thread(run, repeats);
	}
	for(int i=0; i<num_threads;i++) {
		threads[i].join();
	}
}
