#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <thread>
#include <unistd.h>
#include <sys/time.h>
#include <cmath> // sqrt
#include <immintrin.h> // RTM: _x
#include "entities/Account.h"
#include "entities/ThreadsafeAccount.h"
#include "../lock_functions/LockType.h"
#include "../lock_functions/rtm_lock.h"
#include "../lock_functions/atomic_exch_lock-spec.h"
#include "../../util.h"
#include "../../Stats.h"

#define PADDING 1
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

volatile int stop_run;
int * operations_count;

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

/// RTM mixed with different locks
type global_mutex;
void run_mix_rtm(int tid, Account account_pool[], int account_pool_size,
		int (*random_generator)(int limit), int probability_transfer,
		int probability_read) {
	int ops = 0; // use local variable, otherwise we're potentially in the same cache line as other threads

	while (!stop_run) {
		int rnd_op = random_generator(probability_transfer + probability_read);
		int rnd_lock = random_generator(10);
		void (*curr_lock_func)(
				type *) = rnd_lock % 2 == 0 ? atomic_exch_lock_spec : rtm_lock;
		void (*curr_unlock_func)(
				type *) = rnd_lock % 2 == 0 ? atomic_exch_unlock_spec : rtm_unlock;
//		printf("Locking with %s\n", rnd_lock % 2 == 0 ? "atomic" : "rtm");
		// update
		if (rnd_op < probability_transfer) {
			// select two random accounts
			int a1 = random_generator(account_pool_size);
			int a2 = random_generator(account_pool_size);
			// withdraw money from a1 and deposit it into a2
			int money = random_generator(MAXIMUM_MONEY);

			curr_lock_func(&global_mutex);
			account_pool[a1].withdraw(money); // remove from a1
			account_pool[a2].deposit(money); // store in a2
			curr_unlock_func(&global_mutex);
		}
		// read
		else {
			int a = random_generator(account_pool_size);

			curr_lock_func(&global_mutex);
			double balance = account_pool[a].getBalance();
			curr_unlock_func(&global_mutex);
		}
		ops++;
	}
	operations_count[tid] = ops;
}

///
/// Object-related locks run functions
///
void run_object(int tid, ThreadsafeAccount account_pool[],
		int account_pool_size, int (*random_generator)(int limit),
		int probability_transfer, int probability_read) {
	int ops = 0; // use local variable, otherwise we're potentially in the same cache line as other threads

	while (!stop_run) {
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
		ops++;
	}
	operations_count[tid] = ops;
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
	int loops = 100, duration = 1000000, warmup = duration / 10,
			rgen = 2 /* 0: sysrand, 1: customrand, 2: savedrand */,
			lockTypeSelector = -1, mix_rtm = 0;
	int *values[] = { &num_threads, &loops, &rgen, &warmup, &duration,
			&lockTypeSelector, &mix_rtm };
	const char *identifier[] = { "-n", "-l", "-r", "-w", "-d", "-t", "-m" };
	handle_args(argc, argv, 7, values, identifier);

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
	printf("Mix RTM:   %s\n", mix_rtm != 0 ? "yes" : "no");
	printf("Duration:  %d microseconds (%d microseconds warmup)\n", duration,
			warmup);
	printf("function:  %s\n", "run_object");
	printf("\n");

	if (mix_rtm) {
		lockTypeSelector = 3;
	}

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
	int lockTypesCount, lockTypesMin, lockTypesMax;
	lockTypesCount = sizeof(lockTypesEnum) / sizeof(lockTypesEnum[0]);
	if (lockTypeSelector > -1) {
		lockTypesMin = lockTypeSelector;
		lockTypesMax = lockTypeSelector + 1;
	} else {
		lockTypesMin = 0;
		lockTypesMax = lockTypesCount;
	}
	LockType lockTypes[lockTypesCount];
	for (int t = lockTypesMin; t < lockTypesMax; t++) {
		lockTypes[t].init(lockTypesEnum[t]);
	}

	printf("Read probability;Transfer probability;");
	const char *appendings[2];
	appendings[0] = "ExpectedValue";
	appendings[1] = "Stddev";
	LockType::printHeaderRange(lockTypes, lockTypesMin, lockTypesMax,
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

				// run
				operations_count = new int[num_threads];
				stop_run = 0;

				std::thread threads[num_threads];
				for (int i = 0; i < num_threads; i++) {
					if (!mix_rtm) {
						threads[i] = std::thread(run_object, i, ts_account_pool,
								ACCOUNT_COUNT, random_generator,
								probability_transfer, probability_read);
					} else {
						threads[i] = std::thread(run_mix_rtm, i, account_pool,
								ACCOUNT_COUNT, random_generator,
								probability_transfer, probability_read);
					}
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
				float throughput_total = ((float) total_operations)
						/ time_in_millis;
				stats.addValue(throughput_total);

				// check result
				if (!mix_rtm)
					checkResult(ACCOUNT_COUNT, ts_account_pool);
				else
					checkResult(ACCOUNT_COUNT, account_pool);
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

