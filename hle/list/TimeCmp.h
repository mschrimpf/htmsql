#ifndef TIME_CMP_H_
#define TIME_CMP_H_ 1

#include <queue>
#include "List.h"

#define RAND(limit) rand_gerhard(limit)
//#define RAND(limit) rand() % (limit)

#define VALUE_RANGE 1000
// INT_MAX

class TimeCmp {
protected:
	const int OPERATION_INSERT = 1;
	const int OPERATION_CONTAINS = 0;
	const int OPERATION_REMOVE = -1;

public:
	/**
	 * Performs random operations, based on the defined probabilities.
	 */
	void run(int tid, List * list, int repeats, int probability_insert,
			int probability_remove, int probability_contains, std::queue<int> queue);
};
#endif // TIME_CMP_H
