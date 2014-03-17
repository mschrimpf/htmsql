#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <thread>
#include <unistd.h>
#include <sys/time.h>
#include <vector>

#include <immintrin.h> // RTM: _x
#include "ThreadsafeCounter.h"
#include "../lock_functions/LockType.h"
#include "../../util.h"

#define CORES 4
#define RTM_MAX_RETRIES 1000000

void run(int tid, int repeats, ThreadsafeCounter * counter, int pin) {
	if (pin && stick_this_thread_to_core(tid % num_cores) != 0)
		printf("Could not pin thread\n");

	for (int r = 0; r < repeats; r++) {
		counter->increment();
	}
}

void xrun(int tid, int repeats, int * counter, int pin) {
	if (pin && stick_this_thread_to_core(tid % num_cores) != 0)
		printf("Could not pin thread\n");

	for (int r = 0; r < repeats; r++) {
		int failures = 0;
		retry: if (_xbegin() == _XBEGIN_STARTED) {
			(*counter)++;
			_xend();
		} else {
			if (failures++ < RTM_MAX_RETRIES)
				goto retry;
			else
				fprintf(stderr, "Max retry count reached\n");
		}
	}
}

const int SINGLE_COUNTER = 0, COUNTER_PER_CORE = 1;
int main(int argc, char *argv[]) {
	// arguments
	int num_threads = CORES, loops = 100, repeats_min = 100000, repeats_max =
			1500000, repeats_step = 700000, lockType = -1, mode = 0, pin = 0;
	int *values[] = { &num_threads, &loops, &repeats_min, &repeats_max,
			&repeats_step, &lockType, &mode, &pin };
	const char *identifier[] = { "-n", "-l", "-rmin", "-rmax", "-rstep", "-t",
			"-m", "-p" };
	handle_args(argc, argv, 8, values, identifier);

	printf("Running %d threads in %d loops\n", num_threads, loops);
	printf("%d - %d repeats with steps of %d\n", repeats_min, repeats_max,
			repeats_step);
	printf("Mode:   %s\n",
			mode == SINGLE_COUNTER ? "single counter" : "counter per core");
	printf("Pinned: %s\n", pin ? "yes" : "no");
	printf("\n");
	int repeats_count = (repeats_max - repeats_min + repeats_step)
			/ repeats_step;
	int repeats[repeats_count];
	for (int i = 0; i < repeats_count; i++) {
		repeats[i] = repeats_min + i * repeats_step;
	}

	// locking
	LockType::EnumType lockTypesEnum[] = {
	// pthread (0)
			LockType::PTHREAD,
			// atomic (1)
			LockType::ATOMIC_EXCH_SPEC,
			// hle (2)
			LockType::HLE_EXCH_SPEC,
			// unsynchronized (3)
			LockType::NONE,
			// rtm (4)
			LockType::RTM };
	int lockTypesCount, lockTypesMin, lockTypesMax;
	lockTypesCount = sizeof(lockTypesEnum) / sizeof(lockTypesEnum[0]);
	if (lockType > -1) {
		lockTypesMin = lockType;
		lockTypesMax = lockType + 1;
	} else {
		lockTypesMin = 0;
		lockTypesMax = lockTypesCount;
	}
	LockType lockTypes[lockTypesCount];
	for (int t = lockTypesMin; t < lockTypesMax; t++) {
		lockTypes[t].init(lockTypesEnum[t]);
	}

	printf("Repeats;");
	LockType::printHeaderRange(lockTypes, lockTypesMin, lockTypesMax);
	for (int r = 0; r < sizeof(repeats) / sizeof(repeats[0]); r++) {
		printf("%d", repeats[r]);
		std::cout.flush();

		// run all lock-types
		for (int t = lockTypesMin; t < lockTypesMax; t++) {
			// use a loop to check the time more than once --> normalize
			std::vector<double> times;
			for (int l = 0; l < loops; l++) {
				// init all counters - decide which one to use later on
				// this also comes in handy in a way that the memory allocated
				// is the same for all tests
				ThreadsafeCounter counter(lockTypes[t]);
				ThreadsafeCounter counters[CORES];
				int rtm_counter = 0;
				int rtm_counters[CORES];
				for (int c = 0; c < CORES; c++) {
					counters[c].init(lockTypes[t]);
					rtm_counters[c] = 0;
				}
				// run
				struct timeval start, end;
				gettimeofday(&start, NULL);
				std::thread threads[num_threads];
				for (int i = 0; i < num_threads; i++) {
					switch (lockTypes[t].enum_type) {
					case LockType::EnumType::RTM:
						threads[i] = std::thread(xrun, i, repeats[r],
								mode == SINGLE_COUNTER ?
										&rtm_counter :
										&rtm_counters[i % CORES], pin);
						break;
					default:
						threads[i] = std::thread(run, i, repeats[r],
								mode == SINGLE_COUNTER ?
										&counter : &counters[i % CORES], pin);
						break;
					}
				}
				// wait for threads
				for (int i = 0; i < num_threads; i++) {
					threads[i].join();
				}

				gettimeofday(&end, NULL);
				double elapsed = ((end.tv_sec - start.tv_sec) * 1000)
						+ (end.tv_usec / 1000 - start.tv_usec / 1000);
				times.push_back(elapsed);
				// end run

				// check result
				int expected = num_threads * repeats[r];
				int actual = 0;
				switch (mode) {
				case SINGLE_COUNTER:
					actual +=
							lockTypes[t].enum_type == LockType::EnumType::RTM ?
									rtm_counter : counter.get();
					break;
				case COUNTER_PER_CORE:
					for (int c = 0; c < CORES; c++) {
						actual +=
								lockTypes[t].enum_type
										== LockType::EnumType::RTM ?
										rtm_counters[c] : counters[c].get();
					}
					break;
				}
				if (expected != actual &&
				/* only check for synchronized versions */
				lockTypes[t].enum_type != LockType::EnumType::NONE)
					printf("CHECK: counter should be %d, is %d - %s\n",
							expected, actual,
							expected == actual ? "OK" : "ERROR");
			}

			printf(";%.0f", average(times));
			std::cout.flush();
		} // end of locktype-loop
		printf("\n");
	} // end of repeats loop
}

