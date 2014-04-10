#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <thread>
#include <unistd.h>
#include <sys/time.h> // time measurement
#include <limits.h> // INT_MAX
#include "../lock_functions/LockType.h"
#include "List.h"
#include "ThreadsafeList.h"
#include "ThreadsafeListRtm.h"
#include "../../util.h"
#include "../../Stats.h"

#define CORES 4

#define VALUE_RANGE INT_MAX

#define OPERATION_INSERT 1
#define OPERATION_CONTAINS 0
#define OPERATION_REMOVE -1

#define RAND(limit) rand_gerhard(limit)
//#define RAND(limit) rand() % (limit)

/**
 * Performs random operations, based on the defined probabilities.
 */
void run(int tid, ThreadsafeList * list, int repeats, int base_inserts,
		int probability_insert, int probability_remove,
		int probability_contains) {
	// insert base-values to achieve a defined base-size of the list
	for (int i = 0; i < base_inserts; i++) {
		int rnd_val = RAND(VALUE_RANGE);
		list->insert(rnd_val);
	}
	// operations run
	for (int r = 0; r < repeats; r++) {
		int rnd_op = RAND(
				probability_insert + probability_remove + probability_contains);
		int rnd_val = RAND(VALUE_RANGE);
		if (rnd_op < probability_insert) { // insert
			list->insert(rnd_val);
		} else if (rnd_op < probability_insert + probability_remove) { // remove
			list->remove(rnd_val);
		} else { // contains
			list->contains(rnd_val);
		}
	}
}

///
/// main
///
int main(int argc, char *argv[]) {
	// arguments
	int num_threads = CORES;
	int repeats_min = 1000, repeats_step = 1000, repeats_max = 10000, loops =
			100, probability_insert = 25, probability_remove = 25,
			probability_contains = 50, base_inserts = 5000, lockType = -1;
	int *arg_values[] = { &num_threads, &loops, &probability_insert,
			&probability_remove, &probability_contains, &base_inserts,
			&lockType, &repeats_min, &repeats_max, &repeats_step };
	const char *identifier[] = { "-n", "-l", "-pi", "-pr", "-pc", "-bi", "-t",
			"-rmin", "-rmax", "-rstep" };
	handle_args(argc, argv, 10, arg_values, identifier);

	printf("Threads:      %d\n", num_threads);
	printf("Loops:        %d\n", loops);
	printf("Repeats:      %d - %d with steps of %d\n", repeats_min, repeats_max,
			repeats_step);
	printf("(base_inserts=%d, prob_ins=%d, prob_rem=%d, prob_con=%d)\n",
			base_inserts, probability_insert, probability_remove,
			probability_contains);
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

	printf("Size;");
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
				// init
				ThreadsafeList * list =
						lockTypes[t].enum_type == LockType::EnumType::RTM ?
								new ThreadsafeListRtm() :
								new ThreadsafeList(lockTypes[t]);

				// measure
				struct timeval start, end;
				gettimeofday(&start, NULL);

				std::thread threads[num_threads];
				for (int i = 0; i < num_threads; i++) {
					threads[i] = std::thread(run, i, list, repeats,
							base_inserts, probability_insert,
							probability_remove, probability_contains);
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

				delete list;
			} // end of loops loop

			printf(";%.2f;%.2f", stats.getExpectedValue(),
					stats.getStandardDeviation());
			std::cout.flush();
		} // end of locktype-loop
		printf("\n");
	} // end of repeats loop
}
