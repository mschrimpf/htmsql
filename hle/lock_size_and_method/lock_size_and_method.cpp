#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <sys/time.h> // timeval
#include <unistd.h> // usleep
#include <vector>
#include <iostream> // cout
#include "../../util.h"
#include "lock_functions.cpp"

#define type unsigned char

#define LOCK_FUNCTIONS_LENGTH 2
#define __FUNCTION_DEFINITION(type, size)\
	void (*lock_functions[])(type *lock) = {hle_exch_lock##size, hle_exch_lock_spec##size};\
	void (*unlock_function)(type *lock) = hle_unlock##size;

type *locks;
int **lock_accesses;

struct thread_attr {
	int tid;
	int repeats;
	void (*lock_function)(type *lock);
	void (*unlock_function)(type *lock);
};
void *run(void * attr) {
	struct thread_attr attrs = *((struct thread_attr*) attr);
	for (int r = 0; r < attrs.repeats; r++) {
		int access = lock_accesses[attrs.tid][r];
		attrs.lock_function(&locks[access]);
//		usleep(1);
		attrs.unlock_function(&locks[access]);
	}

	free(attr);
}

void printHeader(FILE * out = stdout) {
	fprintf(out, "Repeats;hle_exch_lock;hle_exch_lock_speculation\n");
}

int main(int argc, char *argv[]) {
	int lock_array_size = 1000;
	int repeats[] = { 1000, 5000, 9000 };
	int num_threads = 4;
	int loops = 10000;
	int *values[] = { &num_threads, &loops, &lock_array_size }; // &repeats_min, &repeats_max, &repeats_step };
	const char *identifier[] = { "-n", "-l", "-s" }; //, "-rmin", "-rmax", "-rstep" };
	handle_args(argc, argv, 3, values, identifier);

	printf("Threads:         %d\n", num_threads);
	printf("Loops:           %d\n", loops);
	printf("Lock array size: %d\n", lock_array_size);
	printf("Type size:       %d\n", 1);

	// define lock_functions to test
	__FUNCTION_DEFINITION(type, 1)

	// init
	locks = (type *) calloc(1000, sizeof(type));

	pthread_t threads[num_threads];

	printHeader();
	for (int r = 0; r < sizeof(repeats) / sizeof(repeats[0]); r++) {
		printf("%d", repeats[r]);
		std::cout.flush();

		for (int f = 0; f < LOCK_FUNCTIONS_LENGTH; f++) {
			std::vector<double> times;
			for (int l = 0; l < loops; l++) {
				// create random access values for each thread
				lock_accesses = (int **) calloc(num_threads, sizeof(int*));
				for (int t = 0; t < num_threads; t++) {
					lock_accesses[t] = (int*) calloc(repeats[r], sizeof(int));
					for (int r = 0; r < repeats[r]; r++) {
						lock_accesses[t][r] = rand() % lock_array_size;
					}
				}
				// time measurement
				struct timeval start, end;
				gettimeofday(&start, NULL);
				// BEGIN: run
				for (int t = 0; t < num_threads; t++) {
					struct thread_attr *attrs = (struct thread_attr*) malloc(
							sizeof(struct thread_attr)); // free is performed in run function
					attrs->tid = t;
					attrs->repeats = repeats[r];
					attrs->lock_function = lock_functions[f];
					attrs->unlock_function = unlock_function;

					pthread_create(&threads[t], NULL, &run, attrs);
				} // end threads loop
				  // wait for all threads
				for (int t = 0; t < num_threads; t++) {
					pthread_join(threads[t], NULL);
				} // end join loop
				  // END: run

				  // time measurement
				gettimeofday(&end, NULL);
				double elapsed = ((end.tv_sec - start.tv_sec) * 1000)
						+ (end.tv_usec / 1000 - start.tv_usec / 1000);
				times.push_back(elapsed);

				// clean up
				for (int t = 0; t < num_threads; t++) {
					free(lock_accesses[t]);
				}
				free(lock_accesses);
			} // end loops loop
			printf(";%.2f", average(times));
			std::cout.flush();
		} // end lock functions loop
		printf("\n");
	} // end repeats loop

	free(locks);
}
