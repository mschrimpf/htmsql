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
/// RTM
///
void xrun(int tid, int repeats, Account account_pool[], int account_pool_size,
		int (*random_generator)(int limit), int probability_transfer,
		int probability_read) {
	for (int r = 0; r < repeats; r++) {
		int rnd_op = random_generator(probability_transfer + probability_read);
		// update
		if (rnd_op < probability_transfer) {
			// select two random accounts
			int a1 = random_generator(account_pool_size);
			int a2 = random_generator(account_pool_size);
			// withdraw money from a1 and deposit it into a2
			int money = random_generator(MAXIMUM_MONEY);

			int failures = 0;
			retry_transfer:
			// withdraw money from a1 and deposit it into a2
			if (_xbegin() == _XBEGIN_STARTED) {
				account_pool[a1].withdraw(money); // remove from a1
				account_pool[a2].deposit(money); // store in a2
				_xend();
			} else {
				if (failures++ < RTM_MAX_RETRIES)
					goto retry_transfer;
				else
					fprintf(stderr, "Max retry count reached\n");
			}
		}
		// read
		else {
			int a = random_generator(account_pool_size);

			int failures = 0;
			retry_read: if (_xbegin() == _XBEGIN_STARTED) {
				double balance = account_pool[a].getBalance();
				_xend();
			} else {
				if (failures++ < RTM_MAX_RETRIES)
					goto retry_read;
				else
					fprintf(stderr, "Max retry count reached\n");
			}
		}
	}
}

void xrun_partitioned(int tid, int repeats, Account account_pool[],
		int account_pool_size) {
// partition the array and build an assumed best-case for HLE: no conflicts at all
	int partition_size = account_pool_size / CORES;
	int partition_left = tid * partition_size;
	for (int r = 0; r < repeats; r++) {
		int a1 = partition_left + (r % partition_size);
		int a2 = partition_left + ((r + 1) % partition_size);
		int money = MAXIMUM_MONEY;

		int failures = 0;
		retry:
		// withdraw money from a1 and deposit it into a2
		if (_xbegin() == _XBEGIN_STARTED) {
			account_pool[a1].withdraw(money); // remove from a1
			account_pool[a2].deposit(money); // store in a2
			_xend();
		} else {
			if (failures++ < RTM_MAX_RETRIES)
				goto retry;
			else
				fprintf(stderr, "Max retry count reached\n");
		}
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
	int loops = 100, repeats_min = 10000, repeats_max = 150000, repeats_step =
			70000, probability_transfer = 50, probability_read = 50,
	/* 0: sysrand, 1: customrand, 2: savedrand */rgen = 1;
	int *values[] = { &num_threads, &loops, &repeats_min, &repeats_max,
			&repeats_step, &probability_transfer, &probability_read, &rgen };
	const char *identifier[] = { "-n", "-l", "-rmin", "-rmax", "-rstep", "-pt",
			"-pr", "-rgen" };
	handle_args(argc, argv, 8, values, identifier);

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

	printf("%d Threads\n", num_threads);
	printf("%d Accounts\n", ACCOUNT_COUNT);
	printf("Loops:            %d\n", loops);
	printf("%d - %d repeats with steps of %d\n", repeats_min, repeats_max,
			repeats_step);
	printf("run function:     %s\n", "run_object");
	printf("probabilities: transfer=%d | read=%d", probability_transfer,
			probability_read);
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

	printf("Repeats;");
	const char *appendings[2];
	appendings[0] = "ExpectedValue";
	appendings[1] = "Stddev";
	LockType::printHeader(lockTypes, sizeof(lockTypes) / sizeof(lockTypes[0]), appendings, 2);
	for (int r = repeats_min; r <= repeats_max; r += repeats_step) {
		printf("%d", r);
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
					switch (lockTypes[t].enum_type) {
					case LockType::EnumType::RTM:
						threads[i] = std::thread(xrun, i, r, account_pool,
								ACCOUNT_COUNT, random_generator,
								probability_transfer, probability_read);
						break;
					default:
						threads[i] = std::thread(run_object, i, r,
								ts_account_pool, ACCOUNT_COUNT,
//								account_pool, ACCOUNT_COUNT, &lockTypes[t],
								random_generator, probability_transfer,
								probability_read);
						break;
					}
				}
				// wait for threads
				for (int i = 0; i < num_threads; i++) {
					threads[i].join();
				}

				// TODO: we could would use a different metric here.
				// Rather than measuring the total time it took until ALL threads
				// are done, we can measure the time per thread.
				// With this method, we award threads that are done very quickly.
				// --
				// This technique might not be needed, since htop does not show us
				// huge differences in runtimes

				// measure time
				gettimeofday(&end, NULL);
				float elapsed_ms = ((end.tv_sec - start.tv_sec) * 1000000)
						+ (end.tv_usec - start.tv_usec);
				stats.addValue(elapsed_ms);

				// check result
				switch (lockTypes[t].enum_type) {
				case LockType::EnumType::RTM:
					checkResult(ACCOUNT_COUNT, account_pool);
					break;
				default:
					checkResult(ACCOUNT_COUNT, ts_account_pool);
					break;
				}
			} // end of loops loop

			printf(";%.2f;%.2f", stats.getExpectedValue(), stats.getStandardDeviation());

//			printf(";%.0f", average(times));

			std::cout.flush();
		} // end of locktype-loop
		printf("\n");
	} // end of repeats loop

	if (saved_rands != NULL)
		free(saved_rands);
}

