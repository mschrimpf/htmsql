#ifndef TIME_CMP_H_
#define TIME_CMP_H_ 1

#include <queue>
#include "List.h"
#include "../../util.h"

#define RAND(limit) concurrent_rand_gerhard(limit)
//#define RAND(limit) (rand() % (limit))

#define VALUE_RANGE 1000
// INT_MAX

class TimeCmp {
private:
	unsigned char padding[64 - 20];
protected:
	const int OPERATION_INSERT = 1;
	const int OPERATION_CONTAINS = 0;
	const int OPERATION_REMOVE = -1;

	int stop_flag = 0;
	int operations = 0;

public:
	/**
	 * Performs random operations, based on the defined probabilities.
	 */
	void run(int tid, List * list, int repeats, int probability_insert,
			int probability_remove, int probability_contains,
			std::queue<int> queue);
	/**
	 * Performs random operations, based on the defined probabilities.
	 * Infinite run.
	 */
	void run_infinite(int tid, List * list, int probability_insert,
			int probability_remove, int probability_contains,
			std::queue<int> queue);

	void startMeasurement();
	void stop();
	int getOperations();
};
#endif // TIME_CMP_H
