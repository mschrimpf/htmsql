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

volatile int stop_run;
int * operations_count;

/**
 * Performs random operations, based on the defined probabilities.
 */
void run(int tid, HashMap *map, int probability_insert, int probability_remove,
		int probability_contains, std::queue<int> queue) {
	int ops = 0; // use local variable, otherwise we're potentially in the same cache line as other threads
	while (!stop_run) {
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
		ops++;
	}
	operations_count[tid] = ops;
}

///
/// main
///
int main(int argc, char *argv[]) {
	// arguments
	int num_threads = CORES;
	int loops = 10, probability_insert = 25, probability_remove = 25,
			probability_contains = 50, base_inserts = 1000, lockType = -1,
			size = -1, duration = 100000, warmup = duration / 10;
	int *arg_values[] = { &num_threads, &loops, &probability_insert,
			&probability_remove, &probability_contains, &base_inserts,
			&lockType, &size, &warmup, &duration };
	const char *identifier[] = { "-n", "-l", "-pi", "-pr", "-pc", "-bi", "-t",
			"-s", "-w", "-d" };
	handle_args(argc, argv, 10, arg_values, identifier);

	int * sizes = NULL;
	int sizes_len;
	if (size > 0) {
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
	printf("Duration:     %d microseconds (%d microseconds warmup)\n", duration, warmup);
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
				operations_count = new int[num_threads];
				stop_run = 0;

				std::thread threads[num_threads];
				for (int i = 0; i < num_threads; i++) {
					threads[i] = std::thread(run, i, map, probability_insert,
							probability_remove, probability_contains,
							queues[rotation++ % num_threads]);
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
