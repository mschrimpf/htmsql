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
#define DEBUG 1

int partitioned = 0;
int pin = 1;
int sleep_time = 0; // amount to sleep for in microseconds (or 750 nop loops)

volatile int stop_run;
int * operations_count;

void *run(int tid, void (*lock_function)(void *mutex),
		void (*unlock_function)(void *mutex), void** mutexes,
		int *lock_accesses, int lock_accesses_size) {
	if (pin && stick_this_thread_to_core(tid % num_cores) != 0)
		printf("Could not pin thread\n");

	int ops = 0; // use local variable, otherwise we're potentially in the same cache line as other threads
	int i = 0;
	while (!stop_run) {
		int access = lock_accesses[i];
		void* mutex_ptr = mutexes[access];
#if DEBUG == 1
		printf("[T#%d] Locking %d (%p)\n", tid, access, mutex_ptr);
#endif
		lock_function(mutex_ptr);
//		_mm_pause();
		nop_wait(sleep_time);
//		usleep(1); // does only make a difference for array_size=1
#if DEBUG == 1
		printf("[T#%d] Unlocking %d (%p)\n", tid, access, mutex_ptr);
#endif
		unlock_function(mutex_ptr);

		i++;
		i = i % lock_accesses_size;
	}
	operations_count[tid] = ops;
}

int main(int argc, char *argv[]) {
	int num_threads = 4;
	int loops = 100;
	int lockFunction = -1;
	int partitioned = 0, duration = 1000000, warmup = duration / 10;
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
	printf("Type size:       %d\n", 4);
	int sizes[] = { 1, 10, 100 }; //{ 1000, 5500, 10000 }; // {10, 55, 100}; //

	void (**lock_functions[2])(void *);
	// spin
	lock_functions[0] = new (void (*[4])(void *));lock_functions
	[0][0] = hle_exch_lock_spin1;
	lock_functions[0][1] = hle_exch_lock_spin2;
	lock_functions[0][2] = hle_exch_lock_spin4;
	lock_functions[0][3] = hle_exch_lock_spin8;
	// spec
	lock_functions[1] = new (void (*[4])(void *));lock_functions
	[1][0] = hle_exch_lock_spec1;
	lock_functions[1][0] = hle_exch_lock_spec2;
	lock_functions[1][0] = hle_exch_lock_spec4;
	lock_functions[1][0] = hle_exch_lock_spec8;
	void (*unlock_functions[])(void *) = {
		hle_unlock1, hle_unlock2,
		hle_unlock4, hle_unlock8};

// the size of the array specifying where to access the locks-array
	int lock_accesses_size = 1000000;

	printf("Mutexes"
			";uchar spin;uchar spec"
			";ushort spin;ushort spec"
			";unsigned spin;unsigned spec"
			";unsigned long long spin;unsigned long long spec\n");
	for (int s = 0; s < sizeof(sizes) / sizeof(sizes[0]); s++) {
		int mutexes_array_size = sizes[s];
		printf("%d", mutexes_array_size);
		std::cout.flush();

		// loop over functions, loops, threads
		for (int type = 0; type < 4; type++) {
			for (int technique = 0; technique < 2; technique++) {
				Stats stats;
				for (int l = 0; l < loops; l++) {
					void *** mutexes = new void**[4];
					mutexes[0] = new void*[mutexes_array_size];
					for (int mutex_it = 0; mutex_it < mutexes_array_size;
							mutex_it++) {
						mutexes[0][mutex_it] = new unsigned char;
					}
					mutexes[1] = new void*[mutexes_array_size];
					for (int mutex_it = 0; mutex_it < mutexes_array_size;
							mutex_it++) {
						mutexes[1][mutex_it] = new unsigned short;
					}
					mutexes[2] = new void*[mutexes_array_size];
					for (int mutex_it = 0; mutex_it < mutexes_array_size;
							mutex_it++) {
						mutexes[2][mutex_it] = new unsigned;
					}
					mutexes[3] = new void*[mutexes_array_size];
					for (int mutex_it = 0; mutex_it < mutexes_array_size;
							mutex_it++) {
						mutexes[3][mutex_it] = new unsigned long long;
					}

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
							} else { // shared
								lock_accesses[t][a] = rand()
										% mutexes_array_size;
#if DEBUG
//								printf("lock_accesses[%d][%d]=%2d\n", t, a,
//										lock_accesses[t][a]);
#endif
							}
						}
					}

					// measure
					operations_count = new int[num_threads];
					stop_run = 0;

					// BEGIN: run
					std::thread threads[num_threads];
					for (int t = 0; t < num_threads; t++) {
//					void *run(int tid, void (*lock_function)(T *mutex),
//							void (*unlock_function)(T *mutex), T* mutexes, int *lock_accesses,
//							int lock_accesses_size) {
						threads[t] = std::thread(run, t,
								lock_functions[technique][type],
								unlock_functions[type], mutexes[type],
								lock_accesses[t], lock_accesses_size);
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
					delete[] lock_accesses;
					// TODO corruption error (double free) for uchar size 1000 and ushort size 100
					for (int mutex_type = 0; mutex_type < 4; mutex_type++) {
						for (int mutex_it = 0; mutex_it < mutexes_array_size;
								mutex_it++) {
							switch (mutex_type) {
							case 0:
								delete (unsigned char *) mutexes[mutex_type][mutex_it];
								break;
							case 1:
								delete (unsigned short *) mutexes[mutex_type][mutex_it];
								break;
							case 2:
								delete (unsigned *) mutexes[mutex_type][mutex_it];
								break;
							case 3:
								delete (unsigned long long *) mutexes[mutex_type][mutex_it];
								break;
							}
						}
						delete[] mutexes[mutex_type];
					}
					delete[] mutexes;
				}
				printf(";%.2f", stats.getExpectedValue());
				std::cout.flush();
			}
		} // end lock functions loop
		printf("\n");
	} // end repeats loop
}
