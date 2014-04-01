#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <thread>
#include <unistd.h>
#include <sys/time.h> // time measurement
#include <vector> // time measurement
#include <set>
#include <cmath> // sqrt
#include <limits.h> // INT_MAX
#include "../lock_functions/LockType.h"
#include "HashMap.h"
#include "HashMap-rtm.h"
#include "../../util.h"

#define CORES 4

#define VALUE_RANGE INT_MAX
std::vector<int> values;
std::vector<int> operations;
#define OPERATION_INSERT 1
#define OPERATION_CONTAINS 0
#define OPERATION_REMOVE -1

#define RAND(limit) rand_gerhard(limit)

// NOTE: not used, approach does not work
void checkResult(HashMap *map) {
	return; // vector is not thread-safe
	std::set<int> expectedValues;
	// collect expectedValues
	std::vector<int>::iterator vIt = values.begin();
	std::vector<int>::const_iterator oIt = operations.begin();
	for (; vIt != values.end(); vIt++, oIt++) {
		int value = *vIt;
		int operation = *oIt;
		switch (operation) {
		case OPERATION_INSERT:
			expectedValues.insert(value);
			break;
		case OPERATION_REMOVE:
			expectedValues.erase(value);
			break;
			// nothing changed for OPERATION_CONTAINS
		}
	}

	for (std::set<int>::iterator sIt = expectedValues.begin();
			sIt != expectedValues.end(); sIt++) {
		int value = *sIt;
		if (!map->remove(value)) {
			printf("ERROR: map is supposed to contain %d\n", value);
		}
	}
	if (map->countElements() > 0) {
		printf("ERROR: Map is not supposed to contain any more values\n");
	}
}

/**
 * Use the values- and operations-vector partitioned for each thread.
 */
void createValues(int threads_count, int repeats, int probability_insert,
		int probability_remove, int probability_contains) {
	for (int r = 0; r < threads_count * repeats; r++) {
		int rnd_op = RAND(
				probability_insert + probability_remove + probability_contains);
		int rnd_val = RAND(VALUE_RANGE);
		values.push_back(rnd_val);
		if (rnd_op < probability_insert) { // insert
			operations.push_back(OPERATION_INSERT);
		} else if (rnd_op < probability_insert + probability_remove) { // remove
			operations.push_back(OPERATION_INSERT);
		} else { // contains
			operations.push_back(OPERATION_CONTAINS);
		}
	}
}

/**
 * Performs random operations, based on the defined probabilities.
 */
void random_operations(int tid, HashMap *map, int repeats, int base_inserts,
		int probability_insert, int probability_remove,
		int probability_contains) {
	// insert base-values to achieve a defined base-size of the map
	for (int i = 0; i < base_inserts; i++) {
		int rnd_val = RAND(VALUE_RANGE);
		map->insert(rnd_val);
	}
	// operations run
	for (int r = 0; r < repeats; r++) {
		int rnd_op = RAND(
				probability_insert + probability_remove + probability_contains);
		int rnd_val = RAND(VALUE_RANGE);
		if (rnd_op < probability_insert) { // insert
			map->insert(rnd_val);
		} else if (rnd_op < probability_insert + probability_remove) { // remove
			map->remove(rnd_val);
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
	int mapSize = 1000, loops = 100, repeats_min = 100000,
			repeats_max = 1500000, repeats_step = 700000, probability_insert =
					25, probability_remove = 25, probability_contains = 50,
			base_inserts = 5000, lockType = -1;
	int *arg_values[] =
			{ &mapSize, &num_threads, &loops, &repeats_min, &repeats_max,
					&repeats_step, &probability_insert, &probability_remove,
					&probability_contains, &base_inserts, &lockType };
	const char *identifier[] = { "-s", "-n", "-l", "-rmin", "-rmax", "-rstep",
			"-pi", "-pr", "-pc", "-bi", "-t" };
	handle_args(argc, argv, 11, arg_values, identifier);

	printf("MapSize:      %d\n", mapSize);
	printf("Threads:      %d\n", num_threads);
	printf("Loops:        %d\n", loops);
	printf("%d - %d repeats with steps of %d\n", repeats_min, repeats_max,
			repeats_step);
	printf(
			"run function: %s\n\t(base_inserts=%d, prob_ins=%d, prob_rem=%d, prob_con=%d)\n",
			"random_operations", base_inserts, probability_insert,
			probability_remove, probability_contains);
	printf("\n");
	int repeats_count = (repeats_max - repeats_min + repeats_step)
			/ repeats_step;
	int repeats[repeats_count];
	for (int i = 0; i < repeats_count; i++) {
		repeats[i] = repeats_min + i * repeats_step;
	}

	// define locktypes
	LockType::EnumType lockTypesEnum[] = {
	// 0
			LockType::PTHREAD,
			// 1
			LockType::ATOMIC_EXCH_SPEC,
			// 2
			LockType::HLE_EXCH_SPEC,
			// 3
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
	const char *appendings[2];
	appendings[0] = "ExpectedValue";
	appendings[1] = "Stddev";
	LockType::printHeaderRange(lockTypes, lockTypesMin, lockTypesMax,
			appendings, 2);
	for (int r = 0; r < sizeof(repeats) / sizeof(repeats[0]); r++) {
		printf("%d", repeats[r]);
		std::cout.flush();

		// run all lock-types
		for (int t = lockTypesMin; t < lockTypesMax; t++) {
			// use a loop to check the time more than once --> normalize
			float expected_value_sum = 0, variance_sum = 0;
			for (int l = 0; l < loops; l++) {
				// init
//				HashMap map(mapSize, lockTypes[t]);
				HashMap * map = NULL;
				switch (lockTypes[t].enum_type) {
				case LockType::EnumType::RTM:
					map = new HashMapRtm(mapSize);
					break;
				default:
					map = new HashMap(mapSize, lockTypes[t]);
					break;
				}

				// measure
				struct timeval start, end;
				gettimeofday(&start, NULL);
				std::thread threads[num_threads];
				for (int i = 0; i < num_threads; i++) {
					threads[i] = std::thread(random_operations, i, map,
							repeats[r], base_inserts, probability_insert,
							probability_remove, probability_contains);
				}
				// wait for threads
				for (int i = 0; i < num_threads; i++) {
					threads[i].join();
				}

				// measure time
				gettimeofday(&end, NULL);
				float elapsed = ((end.tv_sec - start.tv_sec) * 1000000)
						+ (end.tv_usec - start.tv_usec);
				expected_value_sum += elapsed;
				variance_sum += (elapsed * elapsed);

				// check result
//				checkResult(&map);

				delete map;
			} // end of loops loop

			float expected_value = expected_value_sum * 1.0 / loops; // mu = p * sum(x_i)
			float variance = 1.0 / loops * variance_sum
					- expected_value * expected_value; // var = p * sum(x_i^2) - mu^2
			float stddev = sqrt(variance);
			float stderror = stddev / sqrt(loops);
			printf(";%.2f;%.2f", expected_value, stddev);
			std::cout.flush();
		} // end of locktype-loop
		printf("\n");
	} // end of repeats loop
}
