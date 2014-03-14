#include <stdlib.h>
#include <stdio.h>
#include <thread>
#include <unistd.h>
#include <sys/time.h>
#include <vector>

#include <immintrin.h> // RTM: _x

#include "ThreadsafeCounter.h"
#include "../lock_functions/LockType.h"
#include "../../util.h"

#define CORES 4
#define RTM_MAX_RETRIES 1000000

void run(int tid, int repeats, ThreadsafeCounter * counter) {
	for (int r = 0; r < repeats; r++) {
		counter->increment();
	}
}

int rtm_counter;
void xrun(int tid, int repeats) {
	for (int r = 0; r < repeats; r++) {
		int failures = 0;
		retry: if (_xbegin() == _XBEGIN_STARTED) {
			rtm_counter++;
			_xend();
		} else {
			if (failures++ < RTM_MAX_RETRIES)
				goto retry;
			else
				fprintf(stderr, "Max retry count reached\n");
		}
	}
}

// provoke even more:
//	int h = i;
//	usleep(1); // provoke an error
//	h++;
//	i = h;

int main(int argc, char *argv[]) {
	// arguments
	int num_threads = CORES, loops = 100, repeats_min = 100000, repeats_max =
			1500000, repeats_step = 700000;
	int *values[] = { &num_threads, &loops, &repeats_min, &repeats_max,
			&repeats_step };
	const char *identifier[] = { "-n", "-l", "-rmin", "-rmax", "-rstep" };
	handle_args(argc, argv, 5, values, identifier);

	printf("Running %d threads in %d loops\n", num_threads, loops);
	printf("%d - %d repeats with steps of %d\n", repeats_min, repeats_max,
			repeats_step);
	printf("\n");
	int repeats_count = (repeats_max - repeats_min + repeats_step)
			/ repeats_step;
	int repeats[repeats_count];
	for (int i = 0; i < repeats_count; i++) {
		repeats[i] = repeats_min + i * repeats_step;
	}

	// all
	LockType::EnumType lockTypesEnum[] = { LockType::PTHREAD,
			// atomic - tas (1, 2)
			LockType::ATOMIC_TAS_BUSY, LockType::ATOMIC_TAS_SPEC,
			// atomic - exch (3, 4)
			LockType::ATOMIC_EXCH_BUSY, LockType::ATOMIC_EXCH_SPEC,
			// hle - tas (5, 6)
			LockType::HLE_TAS_BUSY, LockType::HLE_TAS_SPEC,
			// hle - exch (7, 8)
			LockType::HLE_EXCH_BUSY, LockType::HLE_EXCH_SPEC,
			// rtm (9)
			LockType::RTM };
	int lockTypesCount = sizeof(lockTypesEnum) / sizeof(lockTypesEnum[0]);
	LockType lockTypes[lockTypesCount];
	for (int t = 0; t < lockTypesCount; t++) {
		lockTypes[t].init(lockTypesEnum[t]);
	}

	printf("Repeats;");
	LockType::printHeader(lockTypes, sizeof(lockTypes) / sizeof(lockTypes[0]));
	for (int r = 0; r < sizeof(repeats) / sizeof(repeats[0]); r++) {
		printf("%d", repeats[r]);

		// run all lock-types
		for (int t = 0; t < sizeof(lockTypes) / sizeof(lockTypes[0]); t++) {
			// use a loop to check the time more than once --> normalize
			std::vector<double> times;
			for (int l = 0; l < loops; l++) {
				// reset
				ThreadsafeCounter counter(lockTypes[t]);
				rtm_counter = 0;
				// run
				struct timeval start, end;
				gettimeofday(&start, NULL);
				std::thread threads[num_threads];
				for (int i = 0; i < num_threads; i++) {
					switch (lockTypes[t].enum_type) {
					case LockType::EnumType::RTM:
						threads[i] = std::thread(xrun, i, repeats[r]);
						break;
					default:
						threads[i] = std::thread(run, i, repeats[r],
								&counter);
						break;
					}
				}
				// wait for threads
				for (int i = 0; i < num_threads; i++) {
					threads[i].join();
				}

				int expected = num_threads * repeats[r];
				int actual = rtm_counter > 0 ? rtm_counter : counter.get();
				if (expected != actual)
					printf("CHECK: counter should be %d, is %d - %s\n", expected, actual,
							expected == actual ? "OK" : "ERROR");

				gettimeofday(&end, NULL);
				double elapsed = ((end.tv_sec - start.tv_sec) * 1000)
						+ (end.tv_usec / 1000 - start.tv_usec / 1000);
				times.push_back(elapsed);
			}

			printf(";%.0f", average(times));
		} // end of locktype-loop
		printf("\n");
	} // end of repeats loop
}

