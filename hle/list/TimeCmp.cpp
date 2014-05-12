#include "TimeCmp.h"

#include <stdlib.h>
#include <stdio.h>
#include "List.h"
#include "../../util.h"

/**
 * Performs random operations, based on the defined probabilities.
 */
void TimeCmp::run(int tid, List * list, int repeats, int probability_insert,
		int probability_remove, int probability_contains,
		std::queue<int> queue) {
	for (int r = 0; r < repeats; r++) {
//		printf("[T%d] %d/%d\n", tid, r, repeats);
		int rnd_op =
				RAND(probability_insert + probability_remove + probability_contains);
		int rnd_val = RAND(VALUE_RANGE);
		if (rnd_op < probability_insert) { // insert
			list->insert(rnd_val);
			queue.push(rnd_val);
		} else if (rnd_op < probability_insert + probability_remove
				&& !queue.empty()) { // remove
			int val = queue.front();
			queue.pop();
			list->remove(val);
		} else { // contains
			list->contains(rnd_val);
		}
//		printf("[T%d] %d/%d OK\n", tid, r, repeats);
	}
}
