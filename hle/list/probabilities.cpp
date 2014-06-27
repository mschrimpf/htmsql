#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <thread>
#include <unistd.h>
#include <sys/time.h> // time measurement
#include <limits.h> // INT_MAX
#include "TimeCmp.h"
#include "../lock_functions/LockType.h"

#include "List.h"
#include "ThreadsafeList.h"
#include "ListRtm.h"
#include "Allocator.h"
#include "DefaultAllocator.h"
#include "PreAllocator.h"
#include "AlignedAllocator.h"

#include "../../util.h"
#include "../../Stats.h"

#define USE_PRE_ALLOCATED 1

const int CORES = 4;

///
/// main
///
int main(int argc, char *argv[]) {
	// arguments
	int num_threads = CORES;
	int align = 1;
	int repeats = 5000, loops = 100, base_inserts = 100, lockType = -1,
			duration = 1000000, warmup = duration / 10;
	int wait = 0;
	int *arg_values[] = { &num_threads, &loops, &base_inserts, &lockType,
			&repeats, &wait, &align, &duration, &warmup };
	const char *identifier[] = { "-n", "-l", "-bi", "-t", "-r", "-w", "-a",
			"-d", "-wu" };
	handle_args(argc, argv, 9, arg_values, identifier);

	usleep(wait);

	printf("Total Throughput per millisecond\n");
	printf("Threads:      %d\n", num_threads);
	printf("Aligned:      %d\n", align);
	printf("Loops:        %d\n", loops);
//	printf("Repeats:      %d\n", repeats);
	printf("Duration:     %d microseconds\n", duration);
	printf("Warmup:       %d microseconds\n", warmup);
	printf("(base_inserts=%d, value_range=%d)\n", base_inserts, VALUE_RANGE);
	printf("TimeCmp size: %lu\n", sizeof(TimeCmp));
	printf("ListItem size:%lu\n", sizeof(ListItem));
	printf("\n");

	// define locktypes
	LockType::EnumType lockTypesEnum[] = {
	//
			LockType::PTHREAD,
			//
			LockType::ATOMIC_EXCH_SPEC,
			//
			LockType::HLE_EXCH_BUSY,
			//
			LockType::RTM,
			//
			LockType::NONE };
	int lockTypesCount, lockTypesMin, lockTypesMax;
	lockTypesCount = sizeof(lockTypesEnum) / sizeof(lockTypesEnum[0]);
	if (lockType > -1) {
		lockTypesMin = lockType;
		lockTypesMax = lockType + 1;
	} else {
		lockTypesMin = 0;
		lockTypesMax = lockTypesCount - 1; // ignore nosync (has to be selected explicitly)
	}
	LockType lockTypes[lockTypesCount];
	for (int t = lockTypesMin; t < lockTypesMax; t++) {
		lockTypes[t].init(lockTypesEnum[t]);
	}

//	int probabilities_contains[] = { 0, 25, 50, 75, 100 };
	int probabilities_contains[] = { 0, 50, 100 };
//	int probabilities_contains[] = { 100 };

	Allocator * allocator =
			align ? (Allocator *) new AlignedAllocator() : (Allocator *) new DefaultAllocator();
	printf("p_ins;p_rem;p_con;");
	const char *appendings[3];
	appendings[0] = "ExpectedValue";
	appendings[1] = "Stddev";
	LockType::printHeaderRange(lockTypes, lockTypesMin, lockTypesMax,
			appendings, 2);
	int probabilities_length = sizeof(probabilities_contains)
			/ sizeof(probabilities_contains[0]);
	for (int p = 0; p < probabilities_length; p++) {
		int probability_contains = probabilities_contains[p];
		int probability_update = 100 - probability_contains;
		int probability_insert = probability_update / 2;
		int probability_remove = probability_insert;
		printf("%d;%d;%d", probability_insert, probability_remove,
				probability_contains);
		std::cout.flush();

		// run all lock-types
		for (int t = lockTypesMin; t < lockTypesMax; t++) {
			// use a loop to check the time more than once --> normalize
			Stats stats;
			for (int l = 0; l < loops; l++) {
				// init
				List * list =
						lockTypes[t].enum_type == LockType::EnumType::RTM ?
								(List *) new ListRtm(allocator) :
								(List *) new ThreadsafeList(allocator,
										lockTypes[t]);

				// distribute base values among multiple queues
				// to avoid the extreme shrinking of the list in the beginning
				std::queue<int> queues[num_threads];
				int rotation = 0;
				// insert base-values to achieve a defined base-size of the list
				for (int i = 0; i < base_inserts; i++) {
					int rnd_val = RAND(VALUE_RANGE);
					list->insert(rnd_val);
					queues[rotation++ % num_threads].push(rnd_val);
				}
				rotation = 0;

				// measure
				TimeCmp timeCmps[num_threads];
				std::thread threads[num_threads];
				for (int i = 0; i < num_threads; i++) {
					threads[i] = std::thread(&TimeCmp::run_infinite,
							&timeCmps[i], i, list, probability_insert,
							probability_remove, probability_contains,
							queues[rotation++ % num_threads]);
				}
				usleep(warmup);
				for (int i = 0; i < num_threads; i++) {
					timeCmps[i].startMeasurement();
				}
				usleep(duration);
				// stop runs
				int total_operations = 0;
				for (int i = 0; i < num_threads; i++) {
					timeCmps[i].stop();
					int thread_operations = timeCmps[i].getOperations();
//					printf("[T%d] %d operations\n", i, thread_operations);
					total_operations += thread_operations;
				}
				for (int i = 0; i < num_threads; i++) {
					threads[i].join();
				}

				// measure time
				int time_in_millis = duration / 1000;
				float throughput_total = ((float) total_operations)
						/ time_in_millis;
				stats.addValue(throughput_total);

				delete list;
			} // end of loops loop

			printf(";%.2f;%.2f", stats.getExpectedValue(),
					stats.getStandardDeviation());
			std::cout.flush();
		} // end of locktype-loop
		printf("\n");
	} // end of repeats loop
	delete allocator;
}
