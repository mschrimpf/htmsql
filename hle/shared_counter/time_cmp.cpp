#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <thread>
#include <unistd.h>
#include <sys/time.h>
#include <vector>

#include <immintrin.h> // rtm
#include "PaddedCounter.h"
#include "ThreadsafeCounter.h"
#include "RtmCounter.h"
#include "GlobalThreadsafeCounter.h"
#include "../lock_functions/LockType.h"
#include "../../util.h"
#include "../../Stats.h"

#define CORES 4
const int SINGLE_COUNTER = 0, COUNTER_PER_CORE = 1;

PaddedCounter * createCounter(LockType& lockType, int align, int global) {
	PaddedCounter * counter;
	switch (lockType.enum_type) {
	case LockType::EnumType::RTM:
		counter =
				(RtmCounter *) (
						align ? aligned_alloc(cache_line_size,
										sizeof(RtmCounter)) :
								malloc(sizeof(RtmCounter)));
		new (counter) RtmCounter();
		break;
	default:
		if (!global) {
			counter = (ThreadsafeCounter *) (
					align ? aligned_alloc(cache_line_size,
									sizeof(ThreadsafeCounter)) :
							malloc(sizeof(ThreadsafeCounter)));
			new (counter) ThreadsafeCounter(lockType);
		} else {
			counter = (GlobalThreadsafeCounter *) (
					align ? aligned_alloc(cache_line_size,
									sizeof(GlobalThreadsafeCounter)) :
							malloc(sizeof(GlobalThreadsafeCounter)));
			new (counter) GlobalThreadsafeCounter(lockType);
		}
		break;
	}
	return counter;
}

volatile int stop_run;
int * operations_count;

void run(int tid, PaddedCounter * counter, int pin) {
	if (pin && stick_this_thread_to_core(tid % CORES) != 0)
		printf("Could not pin thread\n");

	int ops = 0; // use local variable, otherwise we're potentially in the same cache line as other threads

	while (!stop_run) {
		counter->increment();
		ops++;
	}
	operations_count[tid] = ops;
}

void run_unaligned(int tid, int * counter, LockType * locker,
		int pin) {
	if (pin && stick_this_thread_to_core(tid % CORES) != 0)
		printf("Could not pin thread\n");

	int ops = 0; // use local variable, otherwise we're potentially in the same cache line as other threads

	while (!stop_run) {
		(locker->*(locker->lock))();
		(*counter)++;
		(locker->*(locker->unlock))();
		ops++;
	}
	operations_count[tid] = ops;
}

int main(int argc, char *argv[]) {
	// arguments
	int loops = 100, threads_min = 1, threads_max = 8, threads_mult = 2,
			lockType = -1, mode = 1, pin = 1, align = 1, wait = 0, global = 0,
			duration = 100000, warmup = duration / 10;
	int *values[] = { &loops, &threads_min, &threads_max, &threads_mult,
			&lockType, &mode, &pin, &wait, &align, &global, &warmup, &duration };
	const char *identifier[] = { "-l", "-tmin", "-tmax", "-tmult", "-t", "-m",
			"-p", "-w", "-a", "-g", "-w", "-d" };
	handle_args(argc, argv, 11, values, identifier);

	if (wait)
		usleep(1000000);

	printf("Total Throughput per millisecond\n");
	printf("Loops:    %d\n", loops);
	printf("Duration: %d microseconds (%d microseconds warmup)\n", duration,
			warmup);
	printf("%d - %d threads in multiples of %d\n", threads_min, threads_max,
			threads_mult);
	printf("Mode:     %s\n",
			mode == COUNTER_PER_CORE ? "counter per core" : "single counter");
	printf("Pinned:   %s\n", pin ? "yes" : "no");
	printf("Aligned:  %s\n", align ? "yes" : "no");
	printf("Global:   %s\n", global ? "yes" : "no");
	printf("\n");

	// locking
	LockType::EnumType lockTypesEnum[] = {
	// unsynchronized (0)
			LockType::NONE,
			// pthread (1)
			LockType::PTHREAD,
			// atomic (2)
			LockType::ATOMIC_EXCH_SPEC,
			// hle (3)
			LockType::HLE_EXCH_SPEC,
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

	printf("Threads;");
	const char *appendings[2];
	appendings[0] = "ExpectedValue";
	appendings[1] = "Stddev";
	LockType::printHeaderRange(lockTypes, lockTypesMin, lockTypesMax,
			appendings, 2);
	for (int num_threads = threads_min; num_threads <= threads_max;
			num_threads *= threads_mult) {
		printf("%d", num_threads);
		std::cout.flush();

		// run all lock-types
		for (int t = lockTypesMin; t < lockTypesMax; t++) {
			// use a loop to check the time more than once --> normalize
			Stats stats;
			for (int l = 0; l < loops; l++) {
				// init all counters - decide which one to use later on
				// this also comes in handy in a way that the memory allocated
				// is the same for all tests
				int singleCounterInt = 0;
				int perCoreCountersInt[CORES]; // force counters in same cache line
				LockType perCoreLocks[CORES];
				for (int c = 0; c < CORES; c++) {
					perCoreCountersInt[c] = 0;
					perCoreLocks[c] = lockTypes[t];
				}

				// create counters
				PaddedCounter *singleCounter = createCounter(lockTypes[t],
						align, global);
				PaddedCounter * perCoreCounters[CORES];
				for (int c = 0; c < CORES; c++) {
					perCoreCounters[c] = createCounter(lockTypes[t], align,
							global);
				}
				// run
				operations_count = new int[num_threads];
				stop_run = 0;

				std::thread threads[num_threads];
				for (int i = 0; i < num_threads; i++) {
					if (align) {
						PaddedCounter * counter;
						switch (mode) {
						case SINGLE_COUNTER:
							counter = singleCounter;
							break;
						case COUNTER_PER_CORE:
							counter = perCoreCounters[i % CORES];
							break;
						}
						threads[i] = std::thread(run, i, counter, pin);
					}
					// unaligned
					else {
						int * counter;
						LockType * locker;
						switch (mode) {
						case SINGLE_COUNTER:
							counter = &singleCounterInt;
							locker = &lockTypes[t];
							break;
						case COUNTER_PER_CORE:
							counter = &perCoreCountersInt[i % CORES];
							locker = &perCoreLocks[i % CORES];
							break;
						}
						threads[i] = std::thread(run_unaligned, i, counter,
								locker, pin);
					}
				}
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
				delete[] operations_count;

				// measure time
				int time_in_millis = duration / 1000;
				float throughput_total = ((float) total_operations) / time_in_millis;
				stats.addValue(throughput_total);

				// check result
				int expected = total_operations;
				int actual = 0;
				switch (mode) {
				case SINGLE_COUNTER:
					actual += align ? singleCounter->get() : singleCounterInt;
					break;
				case COUNTER_PER_CORE:
					for (int c = 0; c < CORES; c++) {
						actual +=
								align ? perCoreCounters[c]->get() : perCoreCountersInt[c];
					}
					break;
				}
				if (expected != actual
						&& lockTypes[t].enum_type != LockType::EnumType::NONE)
					printf("CHECK: counter should be %d, is %d - %s\n",
							expected, actual,
							expected == actual ? "OK" : "ERROR");

				free(singleCounter);
				for (int c = 0; c < CORES; c++) {
					free(perCoreCounters[c]);
				}
			}

			printf(";%.2f;%.2f", stats.getExpectedValue(),
					stats.getStandardDeviation());
			std::cout.flush();
		} // end of locktype-loop
		printf("\n");
	} // end of repeats loop
}

