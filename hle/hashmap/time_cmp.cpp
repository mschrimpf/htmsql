#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <thread>
#include <unistd.h>
#include <sys/time.h> // time measurement
#include <ctime> // clock
#include <vector> // time measurement
#include <queue>
#include <set>
#include <cmath> // sqrt
#include <limits.h> // INT_MAX
#include "../lock_functions/LockType.h"
#include "HashMap.h"
#include "HashMap-rtm.h"
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
void run(int tid, HashMap *map, int repeats, int probability_insert,
		int probability_remove, int probability_contains,
		std::queue<int> queue) {
	for (int r = 0; r < repeats; r++) {
		int rnd_op = RAND(
				probability_insert + probability_remove + probability_contains);
		int rnd_val = RAND(VALUE_RANGE);
		if (rnd_op < probability_insert) { // insert
			map->insert(rnd_val);
			queue.push(rnd_val);
		} else if (rnd_op < probability_insert + probability_remove
				&& !queue.empty()) { // remove
			int val = queue.front();
			queue.pop();
			map->remove(val);
		} else { // contains
			map->contains(rnd_val);
		}
	}
}

///
/// main
///
int main(int argc, char *argv[]) {
	// arguments
	int num_threads = CORES;
	int repeats = 100000, loops = 100, probability_insert = 25,
			probability_remove = 25, probability_contains = 50, base_inserts =
					1000, lockType = -1, size = -1;
	int *arg_values[] =
			{ &repeats, &num_threads, &loops, &probability_insert,
					&probability_remove, &probability_contains, &base_inserts,
					&lockType, &size };
	const char *identifier[] = { "-r", "-n", "-l", "-pi", "-pr", "-pc", "-bi",
			"-t", "-s" };
	handle_args(argc, argv, 9, arg_values, identifier);

	int * sizes = NULL;
	int sizes_len;
	if(size > 0) {
		sizes_len = 1;
		sizes = new int[sizes_len];
		sizes[0] = size;
	} else {
		sizes_len = 5;
		sizes = new int[sizes_len];
		sizes[0] = 10000;
		sizes[1] = 1000;
		sizes[2] = 100;
		sizes[3] = 10;
		sizes[4] = 1;
	}

	printf("Total Throughput per millis\n");
	printf("Threads:      %d\n", num_threads);
	printf("Loops:        %d\n", loops);
	printf("Repeats:      %d\n", repeats);
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
	for (int s = 0; s < sizes_len; s++) {
		printf("%d", sizes[s]);
		std::cout.flush();

		if (sizes[s] < 100)
			repeats = 1000;

		// run all lock-types
		for (int t = lockTypesMin; t < lockTypesMax; t++) {
			// use a loop to check the time more than once --> normalize
			Stats stats;
			for (int l = 0; l < loops; l++) {
				// init
//				HashMap map(sizes[s], lockTypes[t]);
				HashMap * map =
						lockTypes[t].enum_type == LockType::EnumType::RTM ?
								new HashMapRtm(sizes[s]) :
								new HashMap(sizes[s], lockTypes[t]);
				// insert base-values to achieve a defined base-size of the map
				// and distribute base values among multiple queues
				// to avoid the extreme shrinking of the list in the beginning
				std::queue<int> queues[num_threads];
				int rotation = 0;
				// insert base-values to achieve a defined base-size of the list
				for (int i = 0; i < base_inserts; i++) {
					int rnd_val = RAND(VALUE_RANGE);
					map->insert(rnd_val);
					queues[rotation++ % num_threads].push(rnd_val);
				}
				rotation = 0;

				// measure
				struct timeval start, end;
				gettimeofday(&start, NULL);

				std::thread threads[num_threads];
				for (int i = 0; i < num_threads; i++) {
					threads[i] = std::thread(run, i, map, repeats,
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
				float throughput_total = ((float) num_threads * repeats)
						/ elapsed_millis;
				stats.addValue(throughput_total);

				// check result
//				checkResult(&map);
				delete map;
			} // end of loops loop

			printf(";%.2f;%.2f", stats.getExpectedValue(),
					stats.getStandardDeviation());
			std::cout.flush();
		} // end of locktype-loop
		printf("\n");
	} // end of sizes loop
	delete[] sizes;
}
