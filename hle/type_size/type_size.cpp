#include <stdlib.h>
#include <stdio.h>
#include <thread>
#include <sys/time.h> // timeval
#include <unistd.h> // usleep
#include <vector>
#include <iostream> // cout
#include "../../util.h"
#include "../../Stats.h"
#include "hle-lock_functions.cpp"
#include "atomic-lock_functions.cpp"

#include <xmmintrin.h> // _mm_pause
#define DEBUG 0

#define type_uchar unsigned char // 1
#define type_ushort unsigned short // 2
#define type_u unsigned // 4
#define type_ull unsigned long long // 8
#define type type_uchar

#define LOCK_FUNCTIONS_LENGTH 2
#define __FUNCTION_DEFINITION(type, size)\
	void (*lock_functions[])(type *lock) = {hle_exch_lock_spin##size, hle_exch_lock_spec##size};\
	/*hle_exch_lock_spec##size, hle_exch_lock_spec_noload##size};\
	void (*lock_functions[])(type *lock) = {atomic_tas_lock_spec, atomic_exch_lock_spec, \
			hle_tas_lock_spec##size, hle_exch_lock_spec##size};*/\
	void (*unlock_function)(type *lock) = hle_unlock##size;

type *mutexes = NULL; // TODO: padding
int **lock_accesses = NULL;
int partitioned = 0;
int pin = 1;
int sleep_time = 0; // amount to sleep for in microseconds (or 750 nop loops)

volatile int stop_run;
int * operations_count;

void *run(int tid, void (*lock_function)(type *),
		void (*unlock_function)(type *), int *lock_accesses,
		int lock_accesses_size) {
	if (pin && stick_this_thread_to_core(tid % num_cores) != 0)
		printf("Could not pin thread\n");

	int ops = 0; // use local variable, otherwise we're potentially in the same cache line as other threads
	int i = 0;
	while (!stop_run) {
		int access = lock_accesses[i];
		type* mutex_ptr = &mutexes[access];
#if DEBUG == 1
		printf("[T#%d] Locking %d (%p)\n", tid, access, mutex_ptr);
#endif
		lock_function(mutex_ptr);
		nop_wait(sleep_time);
#if DEBUG == 1
		printf("[T#%d] Unlocking %d (%p)\n", tid, access, mutex_ptr);
#endif
		unlock_function(mutex_ptr);

		ops++;
		i++;
		i = i % lock_accesses_size;
	}
	operations_count[tid] = ops;
}

void printHeader(int functionType = -1, FILE * out = stdout) {
	switch (functionType) {
	case 0:
		fprintf(out, "Sizes;hle_exch-spin\n");
		break;
	case 1:
		fprintf(out, "Sizes;hle_exch-spec\n");
		break;
	case 2:
		fprintf(out,
				"Sizes;atomic_exch-spec;atomic_tas-spec;hle_exch-spec;hle_tas-spec\n");
		break;
	case 3:
		fprintf(out, "Sizes;hle_exch-spec;hle_exch-spec-noload\n");
		break;
	default:
		fprintf(out, "Sizes;hle_exch-spin;hle_exch-spec\n");
		break;
	}
}

int main(int argc, char *argv[]) {
	int num_threads = 4;
	int loops = 10;
	int lockFunction = -1;
	int partitioned = 0, duration = 10000, warmup = duration / 10;
	int *values[] = { &num_threads, &loops, &partitioned, &lockFunction,
			&sleep_time, &pin, &duration, &warmup };
	const char *identifier[] = { "-n", "-l", "-partition", "-t", "-sleep",
			"-pin", "-d", "-w" };
	handle_args(argc, argv, 9, values, identifier);

	printf("Threads:         %d\n", num_threads);
	printf("Loops:           %d\n", loops);
	printf("Partitioned:     %s\n", partitioned ? "yes" : "no");
	printf("Pinned:          %s\n", pin ? "yes" : "no");
	printf("sleep:           %d\n", sleep_time);
	printf("Duration:        %d microseconds (%d microseconds warmup)\n",
			duration, warmup);
	printf("Type size:       %d\n", 1);
	int sizes[] = { 1, 10, 100 }; //{ 1000, 5500, 10000 }; // {10, 55, 100}; //

	// define lock_functions to test
	__FUNCTION_DEFINITION(type, 1)

	int lockFunctionsMin, lockFunctionsMax;
	switch (lockFunction) {
	case -1:
	case 2:
	case 3:
		lockFunctionsMin = 0;
		lockFunctionsMax = LOCK_FUNCTIONS_LENGTH;
		break;
	default:
		lockFunctionsMin = lockFunction;
		lockFunctionsMax = lockFunction + 1;
		break;
	}

	// init
	int lock_accesses_size = 1000000;

	pthread_t threads[num_threads];

	printHeader(lockFunction);
	for (int s = 0; s < sizeof(sizes) / sizeof(sizes[0]); s++) {
		int mutexes_array_size = sizes[s];
		printf("%d", mutexes_array_size);
		std::cout.flush();
		mutexes = (type *) calloc(mutexes_array_size, sizeof(type));

		// loop over functions, loops, threads
		for (int f = lockFunctionsMin; f < lockFunctionsMax; f++) {
			Stats stats;
			for (int l = 0; l < loops; l++) {
				// create random access values for each thread
				int ** lock_accesses = new int*[num_threads];
				for (int t = 0; t < num_threads; t++) {
					lock_accesses[t] = new int[lock_accesses_size];
					// partitioned
					int partition_left, partition_size;
					if (partitioned) {
						partition_size = mutexes_array_size / num_threads;
						partition_left = t * partition_size;
					}
					for (int a = 0; a < lock_accesses_size; a++) {
						if (partitioned) {
							lock_accesses[t][a] = partition_left
									+ (rand() % partition_size);
//							printf("lock_accesses[%d][%d] = %d\n", t, a, lock_accesses[t][a]);
						} else { // shared
							lock_accesses[t][a] = rand() % mutexes_array_size;
						}
					}
				} // measure
				operations_count = new int[num_threads];
				stop_run = 0;

				// BEGIN: run
				std::thread threads[num_threads];
				for (int t = 0; t < num_threads; t++) {
					threads[t] = std::thread(run, t, lock_functions[f],
							unlock_function, lock_accesses[t],
							lock_accesses_size);
				} // end threads loop
				  // warmup
				usleep(warmup);
				for (int i = 0; i < num_threads; i++) {
					operations_count[i] = 0; // reset
				}
				usleep(duration);
				stop_run = 1; // stop runs
				for (int i = 0; i < num_threads; i++) {
					threads[i].join(); // make sure result has been written
				}

				int total_operations = 0;
				for (int i = 0; i < num_threads; i++) {
					total_operations += operations_count[i];
				}

				// measure time
				int time_in_millis = duration / 1000;
				float throughput_total = ((float) total_operations)
						/ time_in_millis;
				stats.addValue(throughput_total);

				// clean up
				delete[] operations_count;
				for (int t = 0; t < num_threads; t++) {
					delete[] lock_accesses[t];
				}
				// TODO corruption error (double free) for uchar size 1000 and ushort size 100
			}
			printf(";%.2f", stats.getExpectedValue());
			std::cout.flush();
		} // end lock functions loop
		printf("\n");
		free(mutexes);
	}

}
