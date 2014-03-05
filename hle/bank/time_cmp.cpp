#include <stdlib.h>
#include <stdio.h>
#include <iostream>
#include <thread>
#include <unistd.h>
#include <sys/time.h>
#include <vector>

#include <mutex>
//#include "../pthread_lock.h"
//#include "../atomic_exch_lock.h"
//#include "../atomic_exch_hle_lock.h"
#include <immintrin.h> // RTM: _x
//#include "../hle_exch_lock.h"

#include "entities/Account.h"
#include "entities/ThreadsafeAccount.h"
#include "../lock_functions/LockType.h"
#include "../../util.h"

#define CORES 4
#define RTM_MAX_RETRIES 1000000

#define ACCOUNT_COUNT 1000
#define ACCOUNT_INITIAL 1000.0
#define MAXIMUM_MONEY 1000

#define RAND(limit) rand_gerhard(limit)

///
/// Global vars
///
int *rands = NULL;
int rands_size = 0;
int rands_counter = 0;

int num_threads = CORES;

///
/// Object-related locks run functions
///
void run_object_rand(int tid, int repeats, ThreadsafeAccount account_pool[],
		int account_pool_size) {
	for (int r = 0; r < repeats; r++) {
		// select two random accounts
		int a1 = rand() % account_pool_size;
		int a2 = rand() % account_pool_size;
		// payout money from a1 and deposit it into a2
		int money = rand() % MAXIMUM_MONEY;

		account_pool[a1].payout(money); // remove from a1
		account_pool[a2].deposit(money); // store in a2
	}
}
void run_object_partitioned(int tid, int repeats,
		ThreadsafeAccount account_pool[], int account_pool_size) {
	// partition the array and build an assumed best-case for HLE: no conflicts at all
	int partition_size = ACCOUNT_COUNT / num_threads;
	int partition_left = tid * partition_size;
	for (int r = 0; r < repeats; r++) {
		int a1 = partition_left + (r % partition_size);
		int a2 = partition_left + ((r + 1) % partition_size);
		int money = MAXIMUM_MONEY;

		account_pool[a1].payout(money); // remove from a1
		account_pool[a2].deposit(money); // store in a2
	}
}
void run_object_customrand(int tid, int repeats,
		ThreadsafeAccount account_pool[], int account_pool_size) {
	for (int r = 0; r < repeats; r++) {
		// select two random accounts
		int a1 = RAND(account_pool_size);
		int a2 = RAND(account_pool_size);
		int money = RAND(MAXIMUM_MONEY);

		account_pool[a1].payout(money); // remove from a1
		account_pool[a2].deposit(money); // store in a2
	}
}
void run_object_savedrand(int tid, int repeats,
		ThreadsafeAccount account_pool[], int account_pool_size) {
	for (int r = 0; r < repeats; r++) {
		int a1 = rands[rands_counter = (rands_counter + 1) % rands_size];
		int a2 = rands[rands_counter = (rands_counter + 1) % rands_size];
		int money = MAXIMUM_MONEY;

		account_pool[a1].payout(money); // remove from a1
		account_pool[a2].deposit(money); // store in a2
	}
}
///
/// Global lock run functions
///
void run_global_rand(int tid, int repeats, Account account_pool[],
		int account_pool_size, LockType *locker) {
	for (int r = 0; r < repeats; r++) {
		// select two random accounts
		int a1 = rand() % account_pool_size;
		int a2 = rand() % account_pool_size;
		// payout money from a1 and deposit it into a2
		int money = rand() % MAXIMUM_MONEY;

		(locker->*(locker->lock))();
		account_pool[a1].payout(money); // remove from a1
		account_pool[a2].deposit(money); // store in a2
		(locker->*(locker->unlock))();
	}
}
void run_global_partitioned(int tid, int repeats, Account account_pool[],
		int account_pool_size, LockType *locker) {
	// partition the array and build an assumed best-case for HLE: no conflicts at all
	int partition_size = ACCOUNT_COUNT / num_threads;
	int partition_left = tid * partition_size;
	for (int r = 0; r < repeats; r++) {
		int a1 = partition_left + (r % partition_size);
		int a2 = partition_left + ((r + 1) % partition_size);
		// payout money from a1 and deposit it into a2
		int money = MAXIMUM_MONEY;

		(locker->*(locker->lock))();
		account_pool[a1].payout(money); // remove from a1
		account_pool[a2].deposit(money); // store in a2
		(locker->*(locker->unlock))();
	}
}
void run_global_customrand(int tid, int repeats, Account account_pool[],
		int account_pool_size, LockType *locker) {
	for (int r = 0; r < repeats; r++) {
		// select two random accounts
		int a1 = RAND(account_pool_size);
		int a2 = RAND(account_pool_size);
		int money = RAND(MAXIMUM_MONEY);

		(locker->*(locker->lock))();
		account_pool[a1].payout(money); // remove from a1
		account_pool[a2].deposit(money); // store in a2
		(locker->*(locker->unlock))();
	}
}
void run_global_savedrand(int tid, int repeats,
		ThreadsafeAccount account_pool[], int account_pool_size,
		LockType *locker) {
	for (int r = 0; r < repeats; r++) {
		int a1 = rands[rands_counter = (rands_counter + 1) % rands_size];
		int a2 = rands[rands_counter = (rands_counter + 1) % rands_size];
		int money = MAXIMUM_MONEY;

		(locker->*(locker->lock))();
		account_pool[a1].payout(money); // remove from a1
		account_pool[a2].deposit(money); // store in a2
		(locker->*(locker->unlock))();
	}
}

///
/// RTM
///
void xrun_rand(int tid, int repeats, Account account_pool[],
		int account_pool_size) {
	for (int r = 0; r < repeats; r++) {
		int a1 = rand() % account_pool_size;
		int a2 = rand() % account_pool_size;
		int money = rand() % MAXIMUM_MONEY;

		int failures = 0;
		retry:
		// payout money from a1 and deposit it into a2
		if (_xbegin() == _XBEGIN_STARTED) {
			account_pool[a1].payout(money); // remove from a1
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
void xrun_partitioned(int tid, int repeats, Account account_pool[],
		int account_pool_size) {
	// partition the array and build an assumed best-case for HLE: no conflicts at all
	int partition_size = ACCOUNT_COUNT / CORES;
	int partition_left = tid * partition_size;
	for (int r = 0; r < repeats; r++) {
		int a1 = partition_left + (r % partition_size);
		int a2 = partition_left + ((r + 1) % partition_size);
		int money = MAXIMUM_MONEY;

		int failures = 0;
		retry:
		// payout money from a1 and deposit it into a2
		if (_xbegin() == _XBEGIN_STARTED) {
			account_pool[a1].payout(money); // remove from a1
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

void xrun_customrand(int tid, int repeats, Account account_pool[],
		int account_pool_size) {
	for (int r = 0; r < repeats; r++) {
		int a1 = RAND(account_pool_size);
		int a2 = RAND(account_pool_size);
		int money = RAND(MAXIMUM_MONEY);

		int failures = 0;
		retry:
		// payout money from a1 and deposit it into a2
		if (_xbegin() == _XBEGIN_STARTED) {
			account_pool[a1].payout(money); // remove from a1
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
void xrun_savedrand(int tid, int repeats, Account account_pool[],
		int account_pool_size) {
	for (int r = 0; r < repeats; r++) {
		int a1 = rands[rands_counter = (rands_counter + 1) % rands_size];
		int a2 = rands[rands_counter = (rands_counter + 1) % rands_size];
		int money = MAXIMUM_MONEY;

		int failures = 0;
		retry: if (_xbegin() == _XBEGIN_STARTED) {
			account_pool[a1].payout(money); // remove from a1
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
void checkResult(int account_pool_size, Account account_pool[]) {
	int expected = account_pool_size * ACCOUNT_INITIAL;
	int actual = 0;
	for (int a = 0; a < account_pool_size; a++) {
		actual += account_pool[a].getBalance(); // sequential call
	}
	if (expected != actual)
		printf("CHECK: overall balance should be %d, is %d - %s\n", expected,
				actual, expected == actual ? "OK" : "ERROR");
}
void checkResult(int account_pool_size, ThreadsafeAccount ts_account_pool[]) {
	int expected = account_pool_size * ACCOUNT_INITIAL;
	int actual = 0;
	for (int a = 0; a < account_pool_size; a++) {
		actual += ts_account_pool[a].getBalance(); // sequential call
	}
	if (expected != actual)
		printf("CHECK: overall balance should be %d, is %d - %s\n", expected,
				actual, expected == actual ? "OK" : "ERROR");
}

///
/// main
///
int main(int argc, char *argv[]) {
	// arguments
	num_threads = CORES;
	int loops = 100, repeats_min = 100000, repeats_max = 1500000, repeats_step =
			100000;
	int *values[] = { &num_threads, &loops, &repeats_min, &repeats_max,
			&repeats_step };
	const char *identifier[] = { "-n", "-l", "-rmin", "-rmax", "-rstep" };
	handle_args(argc, argv, 5, values, identifier);
	const int account_pool_size = ACCOUNT_COUNT;

	printf("Threads:      %d\n", num_threads);
	printf("Loops:        %d\n", loops);
	printf("%d - %d repeats with steps of %d\n", repeats_min, repeats_max,
			repeats_step);
	printf("%d accounts\n", account_pool_size);
	printf("run function: %s\n", "run_object_rand");
	printf("\n");
	int repeats_count = (repeats_max - repeats_min + repeats_step)
			/ repeats_step;
	int repeats[repeats_count];
	for (int i = 0; i < repeats_count; i++) {
		repeats[i] = repeats_min + i * repeats_step;
	}

	// randomness setup
	srand(time(0));
	rands_size = ACCOUNT_COUNT * num_threads;
	rands = (int*) malloc(rands_size * sizeof(int));
	for (int i = 0; i < rands_size; i++) {
		rands[i] = rand() % account_pool_size;
	}

	// define locktypes
	LockType::EnumType lockTypesEnum[] = { LockType::PTHREAD, LockType::RTM,
			LockType::ATOMIC_EXCH, LockType::ATOMIC_EXCH_HLE_BUSY,
			LockType::HLE_EXCH_BUSY, LockType::HLE_ASM_EXCH_BUSY };
	int lockTypesCount = sizeof(lockTypesEnum) / sizeof(lockTypesEnum[0]);
	LockType lockTypes[lockTypesCount];
	for (int t = 0; t < lockTypesCount; t++) {
		lockTypes[t].init(lockTypesEnum[t]);
	}

	printf("Repeats;");
	LockType::printHeader(lockTypes, sizeof(lockTypes) / sizeof(lockTypes[0]));
	for (int r = 0; r < sizeof(repeats) / sizeof(repeats[0]); r++) {
		printf("%d", repeats[r]);
		std::cout.flush();

		// run all lock-types
		for (int t = 0; t < sizeof(lockTypes) / sizeof(lockTypes[0]); t++) {
			// use a loop to check the time more than once --> normalize
			std::vector<double> times;
			for (int l = 0; l < loops; l++) {
				// init accounts
				ThreadsafeAccount ts_account_pool[account_pool_size];
				for (int a = 0; a < account_pool_size; a++) {
					ts_account_pool[a].init(lockTypes[t], ACCOUNT_INITIAL);
				}
//				ThreadsafeAccount *ts_account_pool =
//						(ThreadsafeAccount *) malloc(
//								account_pool_size * sizeof(ThreadsafeAccount));
				for (int a = 0; a < account_pool_size; a++) {
					ts_account_pool[a].init(lockTypes[t], ACCOUNT_INITIAL);
				}

				Account account_pool[account_pool_size];
				for (int a = 0; a < account_pool_size; a++) {
					account_pool[a].init(ACCOUNT_INITIAL);
				}

				// measure
				struct timeval start, end;
				gettimeofday(&start, NULL);
				std::thread threads[num_threads];
				for (int i = 0; i < num_threads; i++) {
					switch (lockTypes[t].enum_type) {
					case LockType::EnumType::RTM:
						threads[i] = std::thread(xrun_rand, i, repeats[r],
								account_pool, account_pool_size);
						break;
					default:
						threads[i] = std::thread(run_object_rand, i, repeats[r],
								ts_account_pool, account_pool_size); //, &lockTypes[t]);
						break;
					}
				}
				// wait for threads
				for (int i = 0; i < num_threads; i++) {
					threads[i].join();
				}

				// measure time
				gettimeofday(&end, NULL);
				double elapsed = ((end.tv_sec - start.tv_sec) * 1000)
						+ (end.tv_usec / 1000 - start.tv_usec / 1000);
				times.push_back(elapsed);

				// check result
				switch (lockTypes[t].enum_type) {
				case LockType::EnumType::RTM:
					checkResult(account_pool_size, account_pool);
					break;
				default:
					checkResult(account_pool_size, ts_account_pool);
					break;
				}

//				free((void *) ts_account_pool);
			} // end of loops loop

			printf(";%.0f", average(times));
			std::cout.flush();
		} // end of locktype-loop
		printf("\n");
	} // end of repeats loop

	if (rands != NULL)
		free(rands);
}

