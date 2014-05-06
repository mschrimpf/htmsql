#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <thread>
#include <unistd.h>
#include <sys/time.h> // time measurement
#include <limits.h> // INT_MAX
#include <queue>
#include "TimeCmp.h"
#include "../lock_functions/LockType.h"
#include "List.h"
#include "PreAllocatedList.h"
#include "ThreadsafeList.h"
#include "ListRtm.h"
#include "ThreadsafePreAllocatedList.h"
#include "PreAllocatedListRtm.h"
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
	int repeats_min = 1000, repeats_step = 1000, repeats_max = 10000, loops =
			100, probability_insert = 25, probability_remove = 25,
			probability_contains = 50, base_inserts = 1000, lockType = -1;
	int *arg_values[] = { &num_threads, &loops, &probability_insert,
			&probability_remove, &probability_contains, &base_inserts,
			&lockType, &repeats_min, &repeats_max, &repeats_step };
	const char *identifier[] = { "-n", "-l", "-pi", "-pr", "-pc", "-bi", "-t",
			"-rmin", "-rmax", "-rstep" };
	handle_args(argc, argv, 10, arg_values, identifier);

	printf("Throughput per millisecond\n");
	printf("Threads:      %d\n", num_threads);
	printf("Loops:        %d\n", loops);
	printf("Repeats:      %d - %d with steps of %d\n", repeats_min, repeats_max,
			repeats_step);
	printf(
			"(base_inserts=%d, prob_ins=%d, prob_rem=%d, prob_con=%d, value_range=%d)\n",
			base_inserts, probability_insert, probability_remove,
			probability_contains, VALUE_RANGE);
	printf("\n");

	// define locktypes
	LockType::EnumType lockTypesEnum[] = {
	//
			LockType::PTHREAD,
			//
			LockType::ATOMIC_EXCH_SPEC,
			//
			LockType::HLE_EXCH_SPEC,
			//
			LockType::RTM
	//
			};
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
//	printf("p_ins;p_rem;p_con;");
	const char *appendings[3];
	appendings[0] = "ExpectedValue";
	appendings[1] = "Stddev";
	appendings[2] = "List size";
	LockType::printHeaderRange(lockTypes, lockTypesMin, lockTypesMax,
			appendings, 3);
	for (int repeats = repeats_min; repeats <= repeats_max; repeats +=
			repeats_step) {
		printf("%d", repeats);
		std::cout.flush();

		// run all lock-types
		for (int t = lockTypesMin; t < lockTypesMax; t++) {
			// use a loop to check the time more than once --> normalize
			Stats stats;
			Stats listSizeStats;
			for (int l = 0; l < loops; l++) {
				// init
#if USE_PRE_ALLOCATED == 1
				List * list =
						lockTypes[t].enum_type == LockType::EnumType::RTM ?
								(List *) new PreAllocatedListRtm() :
								(List *) new ThreadsafePreAllocatedList(
										lockTypes[t]);
#else
				List * list =
				lockTypes[t].enum_type == LockType::EnumType::RTM ?
				(List *) new ListRtm() :
				(List *) new ThreadsafeList(lockTypes[t]);
#endif

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
				struct timeval start, end;
				gettimeofday(&start, NULL);

				TimeCmp timeCmp;
				std::thread threads[num_threads];
				for (int i = 0; i < num_threads; i++) {
					threads[i] = std::thread(&TimeCmp::run, timeCmp, i, list, repeats,
							probability_insert, probability_remove,
							probability_contains,
							queues[rotation++ % num_threads]);
				}
				// wait for threads
				for (int i = 0; i < num_threads; i++) {
					threads[i].join();
				}

				// measure time
				gettimeofday(&end, NULL);
				float elapsed_millis = (end.tv_sec - start.tv_sec) * 1000
						+ (end.tv_usec - start.tv_usec) / 1000;
				float throughput_per_milli = repeats / elapsed_millis;
				stats.addValue(throughput_per_milli);

				listSizeStats.addValue(list->size());

				delete list;
			} // end of loops loop

			printf(";%.2f;%.2f;%.2f", stats.getExpectedValue(),
					stats.getStandardDeviation(),
					listSizeStats.getExpectedValue());
			std::cout.flush();
		} // end of locktype-loop
		printf("\n");
	} // end of repeats loop
}