#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <sys/time.h> // timeval
#include <unistd.h> // usleep
#include <vector>
#include <iostream> // cout
#include "../../util.h"
#include "lock_functions.cpp"

#include <xmmintrin.h> // _mm_pause

#include <sched.h> // thread affinity
#define DEBUG 0

#define type_uchar unsigned char // 1
#define type_ushort unsigned short // 2
#define type_u unsigned // 4
#define type_ull unsigned long long // 8
#define type type_u

#define LOCK_FUNCTIONS_LENGTH 2
#define __FUNCTION_DEFINITION(type, size)\
	void (*lock_functions[])(type *lock) = {hle_exch_lock_spin##size, hle_exch_lock_spec##size};\
	void (*unlock_function)(type *lock) = hle_unlock##size;

type *locks = NULL;
int **lock_accesses = NULL;
int partitioned = 0;

static int num_cores = sysconf(_SC_NPROCESSORS_ONLN);
int stick_this_thread_to_core(int core_id) {
	if (core_id < 0 || core_id >= num_cores)
		return -1;

	cpu_set_t cpuset;
	CPU_ZERO(&cpuset);
	CPU_SET(core_id, &cpuset);

	pthread_t current_thread = pthread_self();
	return pthread_setaffinity_np(current_thread, sizeof(cpu_set_t), &cpuset);
}

struct thread_attr {
	int tid;
	int repeats;
	void (*lock_function)(type *lock);
	void (*unlock_function)(type *lock);
};
void *run(void * attr) {
	struct thread_attr attrs = *((struct thread_attr*) attr);

	if (stick_this_thread_to_core(attrs.tid % num_cores) != 0)
		printf("Could not pin thread\n");

	for (int r = 0; r < attrs.repeats; r++) {
		int access = lock_accesses[attrs.tid][r];
#if DEBUG == 1
		printf("[T#%d] Locking %d (%p)\n", attrs.tid, access, &locks[access]);
#endif
		attrs.lock_function(&locks[access]);
//		_mm_pause();
		usleep(1); // does only make a difference for array_size=1
#if DEBUG == 1
		printf("[T#%d] Unlocking %d (%p)\n", attrs.tid, access, &locks[access]);
#endif
		attrs.unlock_function(&locks[access]);
	}

	free(attr);
}

void printHeader(FILE * out = stdout) {
	fprintf(out, "Repeats;hle_exch-spin;hle_exch-spec\n");
}

int main(int argc, char *argv[]) {
	int lock_array_size = 100;
	int repeats[] = { 1000, 5500, 10000 }; // {10, 55, 100};
	int num_threads = 4;
	int loops = 10000;
	partitioned = 0;
	int *values[] = { &num_threads, &loops, &partitioned, &lock_array_size }; // &repeats_min, &repeats_max, &repeats_step };
	const char *identifier[] = { "-n", "-l", "-p", "-s" }; //, "-rmin", "-rmax", "-rstep" };
	handle_args(argc, argv, 4, values, identifier);

	printf("Lock array size: %d\n", lock_array_size);
	printf("Threads:         %d\n", num_threads);
	printf("Loops:           %d\n", loops);
	printf("Partitioned:     %d\n", partitioned);
	printf("Type size:       %d\n", 4);


	// define lock_functions to test
	__FUNCTION_DEFINITION(type, 4)

	// init
	locks = (type *) calloc(lock_array_size, sizeof(type));

	pthread_t threads[num_threads];

	printHeader();
	for (int r = 0; r < sizeof(repeats) / sizeof(repeats[0]); r++) {
		printf("%d", repeats[r]);
		std::cout.flush();
		// the size of the array specifying where to access the locks-array
		int lock_accesses_size = repeats[r];

		// loop over functions, loops, threads
		for (int f = 0; f < LOCK_FUNCTIONS_LENGTH; f++) {
			std::vector<double> times;
			for (int l = 0; l < loops; l++) {
				// create random access values for each thread
//				lock_accesses = (int **) calloc(num_threads, sizeof(int*));
				lock_accesses = new int*[num_threads];
				for (int t = 0; t < num_threads; t++) {
//					lock_accesses[t] = (int*) calloc(lock_accesses_size,
//							sizeof(int));
					lock_accesses[t] = new int[lock_accesses_size];
					// partitioned
					int partition_left, partition_size;
					if (partitioned) {
						partition_size = lock_array_size / num_threads;
						partition_left = t * partition_size;
					}
					for (int a = 0; a < lock_accesses_size; a++) {
						if (partitioned) {
							lock_accesses[t][a] = partition_left
									+ (rand() % partition_size);
//							printf("lock_accesses[%d][%d] = %d\n", t, a, lock_accesses[t][a]);
						} else { // hotspot
							lock_accesses[t][a] = rand() % lock_array_size;
						}
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
//					free(lock_accesses[t]);
					delete[] lock_accesses[t];
				}
//				free(lock_accesses);
				delete[] lock_accesses;
				// TODO fix the corruption error
			} // end loops loop
			printf(";%.2f", average(times));
			std::cout.flush();
		} // end lock functions loop
		printf("\n");
	} // end repeats loop

	free(locks);
}
