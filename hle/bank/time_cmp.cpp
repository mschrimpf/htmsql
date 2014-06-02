#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <thread>
#include <unistd.h>
#include <sys/time.h>
#include <cmath> // sqrt
#define PADDING 1

#include <immintrin.h> // RTM: _x
#include "entities/Account.h"
#include "entities/ThreadsafeAccount.h"
#include "../lock_functions/LockType.h"
#include "../../util.h"
#include "../../Stats.h"

#define CORES 4
#define RTM_MAX_RETRIES 1000000

const int ACCOUNT_COUNT = 10000;
const double ACCOUNT_INITIAL = 1000.0;
const int MAXIMUM_MONEY = 1000;

///
/// Global vars
///
int *saved_rands = NULL;
int rands_size = 0;
int rands_counter = 0;

int num_threads = CORES;

///
/// Random generators
///
int sysrand(int limit) {
	return rand() % limit;
}
int customrand(int limit) {
	return rand_gerhard(limit);
}
int savedrand(int limit) {
	return saved_rands[rands_counter = (rands_counter + 1) % rands_size];
}

///
/// Object-related locks run functions
///
void run_object(int tid, int repeats, ThreadsafeAccount account_pool[],
		int account_pool_size, int (*random_generator)(int limit),
		int probability_transfer, int probability_read) {
	for (int r = 0; r < repeats; r++) {
		int rnd_op = random_generator(probability_transfer + probability_read);
		// update
		if (rnd_op < probability_transfer) {
			// select two random accounts
			int a1 = random_generator(account_pool_size);
			int a2 = random_generator(account_pool_size);
			// withdraw money from a1 and deposit it into a2
			int money = random_generator(MAXIMUM_MONEY);

			account_pool[a1].withdraw(money); // remove from a1
			account_pool[a2].deposit(money); // store in a2
		}
		// read
		else {
			int a = random_generator(account_pool_size);

			double balance = account_pool[a].getBalance();
		}
	}
}
void run_object_partitioned(int tid, int repeats,
		ThreadsafeAccount account_pool[], int account_pool_size) {
// partition the array and build an assumed best-case for HLE: no conflicts at all
	int partition_size = account_pool_size / num_threads;
	int partition_left = tid * partition_size;
	for (int r = 0; r < repeats; r++) {
		int a1 = partition_left + (r % partition_size);
		int a2 = partition_left + ((r + 1) % partition_size);
		int money = MAXIMUM_MONEY;

		account_pool[a1].withdraw(money); // remove from a1
		account_pool[a2].deposit(money); // store in a2
	}
}
///
/// Global lock run functions
///
void run_global(int tid, int repeats, Account account_pool[],
		int account_pool_size, LockType *locker,
		int (*random_generator)(int limit), int probability_transfer,
		int probability_read) {
	LockType _locker = *locker;
	for (int r = 0; r < repeats; r++) {
		int rnd_op = random_generator(probability_transfer + probability_read);
		// update
		if (rnd_op < probability_transfer) {
			// select two random accounts
			int a1 = random_generator(account_pool_size);
			int a2 = random_generator(account_pool_size);
			// withdraw money from a1 and deposit it into a2
			int money = random_generator(MAXIMUM_MONEY);

			(_locker.*(_locker.lock))();
			account_pool[a1].withdraw(money); // remove from a1
			account_pool[a2].deposit(money); // store in a2
			(_locker.*(_locker.unlock))();
		}
		// read
		else {
			int a = random_generator(account_pool_size);

			(_locker.*(_locker.lock))();
			double balance = account_pool[a].getBalance();
			(_locker.*(_locker.unlock))();
		}
	}
}
// partition the array and build an assumed best-case for HLE: no conflicts at all
void run_global_partitioned(int tid, int repeats, Account account_pool[],
		int account_pool_size, LockType *locker) {
	int partition_size = account_pool_size / num_threads;
	int partition_left = tid * partition_size;
	for (int r = 0; r < repeats; r++) {
		int a1 = partition_left + (r % partition_size);
		int a2 = partition_left + ((r + 1) % partition_size);
		// withdraw money from a1 and deposit it into a2
		int money = MAXIMUM_MONEY;

		(locker->*(locker->lock))();
		account_pool[a1].withdraw(money); // remove from a1
		account_pool[a2].deposit(money); // store in a2
		(locker->*(locker->unlock))();
	}
}

///
/// value check
///
void checkResult(int account_pool_size, long actual_sum,
		long count_initial_balance = 0) {
	long expected = account_pool_size * ACCOUNT_INITIAL;
	if (expected != actual_sum)
		printf("CHECK: overall balance should be %ld, is %ld - %s\n", expected,
				actual_sum, expected == actual_sum ? "OK" : "ERROR");
}
void checkResult(int account_pool_size, Account account_pool[]) {
	long actual = 0, count_initial_balance = 0;
	for (int a = 0; a < account_pool_size; a++) {
		double balance = account_pool[a].getBalance();
		actual += balance;
		if (balance == ACCOUNT_INITIAL)
			count_initial_balance++;
	}
	checkResult(account_pool_size, actual, count_initial_balance);
}
void checkResult(int account_pool_size, ThreadsafeAccount ts_account_pool[]) {
	int actual = 0, count_initial_balance = 0;
	for (int a = 0; a < account_pool_size; a++) {
		double balance = ts_account_pool[a].getBalance();
		actual += balance;
		if (balance == ACCOUNT_INITIAL)
			count_initial_balance++;
	}
	checkResult(account_pool_size, actual, count_initial_balance);
}

///
/// main
///
int main(int argc, char *argv[]) {
// arguments
	num_threads = CORES;
	int loops = 100, repeats = 100000, /* 0: sysrand, 1: customrand, 2: savedrand */
	rgen = 2;
	int *values[] = { &num_threads, &loops, &repeats, &rgen };
	const char *identifier[] = { "-n", "-l", "-r", "-rgen" };
	handle_args(argc, argv, 4, values, identifier);

	int probabilities_read[] = { 0, 50, 100 };
	int probabilities_transfer[] = { 100, 50, 0 };

	printf("random generator: ");
	int (*random_generator)(int limit);
	switch (rgen) {
	case 0:
		random_generator = sysrand;
		printf("sysrand\n");
		break;
	case 1:
		random_generator = customrand;
		printf("customrand\n");
		break;
	case 2:
		random_generator = savedrand;
		printf("savedrand\n");
		break;
	}

	printf("Total Throughput per millisecond\n");
	printf("Threads:   %d\n", num_threads);
	printf("Accounts:  %d\n", ACCOUNT_COUNT);
	printf("Loops:     %d\n", loops);
	printf("Repeats:   %d\n", repeats);
	printf("function:  %s\n", "run_object");
	printf("\n");

// randomness setup
	srand(time(0));
	rands_size = ACCOUNT_COUNT * num_threads;
	saved_rands = (int*) malloc(rands_size * sizeof(int));
	for (int i = 0; i < rands_size; i++) {
		saved_rands[i] = rand() % ACCOUNT_COUNT;
	}

// define locktypes
	LockType::EnumType lockTypesEnum[] = {
//	 pthread
			LockType::PTHREAD,
			// atomic
			LockType::ATOMIC_EXCH_SPEC,
			// hle
			LockType::HLE_EXCH_SPEC,
			// rtm
			LockType::RTM
	//
			};
	int lockTypesCount = sizeof(lockTypesEnum) / sizeof(lockTypesEnum[0]);
	LockType lockTypes[lockTypesCount];
	for (int t = 0; t < lockTypesCount; t++) {
		lockTypes[t].init(lockTypesEnum[t]);
	}

	printf("Read probability;Transfer probability;");
	const char *appendings[2];
	appendings[0] = "ExpectedValue";
	appendings[1] = "Stddev";
	LockType::printHeader(lockTypes, sizeof(lockTypes) / sizeof(lockTypes[0]),
			appendings, 2);
	for (int p = 0;
			p < sizeof(probabilities_read) / sizeof(probabilities_read[0]);
			p++) {
		int probability_read = probabilities_read[p], probability_transfer =
				probabilities_transfer[p];
		printf("%d;%d", probability_read, probability_transfer);
		std::cout.flush();

		// run all lock-types
		for (int t = 0; t < sizeof(lockTypes) / sizeof(lockTypes[0]); t++) {
			// use a loop to check the time more than once --> normalize
			Stats stats;
			for (int l = 0; l < loops; l++) {
				// init accounts
				ThreadsafeAccount ts_account_pool[ACCOUNT_COUNT];
				for (int a = 0; a < ACCOUNT_COUNT; a++) {
					ts_account_pool[a].init(lockTypes[t], ACCOUNT_INITIAL);
				}

				Account account_pool[ACCOUNT_COUNT];
				for (int a = 0; a < ACCOUNT_COUNT; a++) {
					account_pool[a].init(ACCOUNT_INITIAL);
				}

				// measure
				struct timeval start, end;
				gettimeofday(&start, NULL);
				std::thread threads[num_threads];
				for (int i = 0; i < num_threads; i++) {
					threads[i] = std::thread(run_object, i, repeats,
							ts_account_pool, ACCOUNT_COUNT, // object lock
//							account_pool, ACCOUNT_COUNT, &lockTypes[t], // global lock
							random_generator, probability_transfer,
							probability_read);
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
				checkResult(ACCOUNT_COUNT, ts_account_pool);
			} // end of loops loop

			printf(";%.2f;%.2f", stats.getExpectedValue(),
					stats.getStandardDeviation());

			std::cout.flush();
		} // end of locktype-loop
		printf("\n");
	} // end of repeats loop

	if (saved_rands != NULL)
		free(saved_rands);
}

