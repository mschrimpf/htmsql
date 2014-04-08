#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <thread>
#include <unistd.h>
#include <sys/time.h>
#include <vector>

#include "ThreadsafeCounter.h"
#include "RtmCounter.h"
#include "../lock_functions/LockType.h"
#include "../../util.h"
#include "../../Stats.h"

#define CORES 4

void run(int tid, int repeats, ThreadsafeCounter * counter, int pin) {
	if (pin && stick_this_thread_to_core(tid % num_cores) != 0)
		printf("Could not pin thread\n");

	for (int r = 0; r < repeats; r++) {
		counter->increment();
	}
}

const int SINGLE_COUNTER = 0, COUNTER_PER_CORE = 1;
int main(int argc, char *argv[]) {
	if (sizeof(ThreadsafeCounter) < 64) {
		fprintf(stderr,
				"Size of ThreadsafeCounter is smaller than a cache line\n");
		return 1;
	}

	// arguments
	int num_threads = CORES, loops = 100, repeats_min = 1000000, repeats_max =
			1000000, repeats_step = 700000, lockType = -1, mode = 0, pin = 0;
	int *values[] = { &num_threads, &loops, &repeats_min, &repeats_max,
			&repeats_step, &lockType, &mode, &pin };
	const char *identifier[] = { "-n", "-l", "-rmin", "-rmax", "-rstep", "-t",
			"-m", "-p" };
	handle_args(argc, argv, 8, values, identifier);

	printf("Throughput per millisecond\n");
	printf("Running %d threads in %d loops\n", num_threads, loops);
	printf("%d - %d repeats with steps of %d\n", repeats_min, repeats_max,
			repeats_step);
	printf("Mode:   %s\n",
			mode == SINGLE_COUNTER ? "single counter" : "counter per core");
	printf("Pinned: %s\n", pin ? "yes" : "no");
	printf("\n");

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
	const char *appendings[2];
	appendings[0] = "ExpectedValue";
	appendings[1] = "Stddev";
	LockType::printHeaderRange(lockTypes, lockTypesMin, lockTypesMax,
			appendings, 2);
	for (int repeats = repeats_min; repeats <= repeats_max; repeats +=
			repeats_step) {
		printf("%d", repeats);
		std::cout.flush();

		// run all lock-types
		for (int t = lockTypesMin; t < lockTypesMax; t++) {
			// use a loop to check the time more than once --> normalize
			Stats stats;
			for (int l = 0; l < loops; l++) {
				// init all counters - decide which one to use later on
				// this also comes in handy in a way that the memory allocated
				// is the same for all tests
				ThreadsafeCounter * singleCounter =
						lockTypes[t].enum_type == LockType::EnumType::RTM ?
								new RtmCounter() :
								new ThreadsafeCounter(lockTypes[t]);
				ThreadsafeCounter * perCoreCounters[CORES];
				for (int c = 0; c < CORES; c++) {
					perCoreCounters[c] =
							lockTypes[t].enum_type == LockType::EnumType::RTM ?
									new RtmCounter() :
									new ThreadsafeCounter(lockTypes[t]);
				}
				// run
				struct timeval start, end;
				gettimeofday(&start, NULL);
				std::thread threads[num_threads];
				for (int i = 0; i < num_threads; i++) {
					ThreadsafeCounter * counter;
					switch (mode) {
					case SINGLE_COUNTER:
						counter = singleCounter;
						break;
					case COUNTER_PER_CORE:
						counter = perCoreCounters[i % CORES];
						break;
					}
					threads[i] = std::thread(run, i, repeats, counter, pin);
				}
				// wait for threads
				for (int i = 0; i < num_threads; i++) {
					threads[i].join();
				}

				gettimeofday(&end, NULL);
				float elapsed_millis = (end.tv_sec - start.tv_sec) * 1000
						+ (end.tv_usec - start.tv_usec) / 1000;
				float throughput_per_milli = repeats / elapsed_millis;
				stats.addValue(throughput_per_milli);
				// end run

				// check result
				int expected = num_threads * repeats;
				int actual = 0;
				switch (mode) {
				case SINGLE_COUNTER:
					actual += singleCounter->get();
					break;
				case COUNTER_PER_CORE:
					for (int c = 0; c < CORES; c++) {
						actual += perCoreCounters[c]->get();
					}
					break;
				}
				if (expected != actual &&
				/* only check for synchronized versions */
				lockTypes[t].enum_type != LockType::EnumType::NONE)
					printf("CHECK: counter should be %d, is %d - %s\n",
							expected, actual,
							expected == actual ? "OK" : "ERROR");

				delete singleCounter;
				for (int c = 0; c < CORES; c++) {
					delete perCoreCounters[c];
				}
			}

			printf(";%.2f;%.2f", stats.getExpectedValue(),
					stats.getStandardDeviation());
			std::cout.flush();
		} // end of locktype-loop
		printf("\n");
	} // end of repeats loop
}

