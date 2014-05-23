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

void run(int tid, int repeats, PaddedCounter * counter, int pin) {
	if (pin && stick_this_thread_to_core(tid % CORES) != 0)
		printf("Could not pin thread\n");

	for (int r = 0; r < repeats; r++) {
		counter->increment();
	}
}

void run_unaligned(int tid, int repeats, int * counter, LockType * locker,
		int pin) {
	if (pin && stick_this_thread_to_core(tid % CORES) != 0)
		printf("Could not pin thread\n");

	for (int r = 0; r < repeats; r++) {
		(locker->*(locker->lock))();
		(*counter)++;
		(locker->*(locker->unlock))();
	}
}

void run_unaligned_rtm(int tid, int repeats, int * counter, int pin) {
	if (pin && stick_this_thread_to_core(tid % CORES) != 0)
		printf("Could not pin thread\n");

	for (int r = 0; r < repeats; r++) {
		int failures = 0, max_failures = 1000000;
		retry: if (_xbegin() == _XBEGIN_STARTED) {
			(*counter)++;
			_xend();
		} else {
			failures++;
			if (failures < max_failures)
				goto retry;
			else {
				printf("Max failures %d reached\n", failures);
				exit(1);
			}
		}
	}
}

int main(int argc, char *argv[]) {
	// arguments
	int loops = 100, repeats = 1000000, threads_min = 1, threads_max = 8,
			threads_mult = 2, lockType = -1, mode = 1, pin = 1, align = 1,
			wait = 0, global = 0;
	int *values[] = { &loops, &repeats, &threads_min, &threads_max,
			&threads_mult, &lockType, &mode, &pin, &wait, &align, &global };
	const char *identifier[] = { "-l", "-r", "-tmin", "-tmax", "-tmult", "-t",
			"-m", "-p", "-w", "-a", "-g" };
	handle_args(argc, argv, 11, values, identifier);

	if (wait)
		usleep(1000000);

	printf("Total Throughput per millisecond\n");
	printf("Loops:   %d\n", loops);
	printf("%d - %d threads in multiples of %d\n", threads_min, threads_max,
			threads_mult);
	printf("Mode:    %s\n",
			mode == COUNTER_PER_CORE ? "counter per core" : "single counter");
	printf("Pinned:  %s\n", pin ? "yes" : "no");
	printf("Aligned: %s\n", align ? "yes" : "no");
	printf("Global:  %s\n", global ? "yes" : "no");
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

				//
				PaddedCounter *singleCounter = createCounter(lockTypes[t],
						align, global);
				PaddedCounter * perCoreCounters[CORES];
				for (int c = 0; c < CORES; c++) {
					perCoreCounters[c] = createCounter(lockTypes[t], align,
							global);
				}
				// run
				struct timeval start, end;
				gettimeofday(&start, NULL);
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
						threads[i] = std::thread(run, i, repeats, counter, pin);
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
						if (lockTypes[t].enum_type != LockType::EnumType::RTM)
							threads[i] = std::thread(run_unaligned, i, repeats,
									counter, locker, pin);
						else
							threads[i] = std::thread(run_unaligned_rtm, i,
									repeats, counter, pin);
					}
				}
				// wait for threads
				for (int i = 0; i < num_threads; i++) {
					threads[i].join();
				}

				gettimeofday(&end, NULL);
				float elapsed_millis = (end.tv_sec - start.tv_sec) * 1000
						+ (end.tv_usec - start.tv_usec) / 1000;
				float throughput_total = ((float) num_threads * repeats)
						/ elapsed_millis;
				stats.addValue(throughput_total);
				// end run

				// check result
				int expected = num_threads * repeats;
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

