#include <stdio.h>
#include <stdlib.h>

#include <thread>
#include <xmmintrin.h> // mm_pause
#include <immintrin.h> // rtm
#include "../../util.h"

#include "../lib/hle-emulation.h"
#include "../lib/tsx-cpuid.h"

unsigned mutex = 0;
int read_flag = 0;

void wait_tas_read_tas_wait(int wait) {
// try to elide
	while (__hle_acquire_exchange_n4(&mutex, 1)) {
//		printf("Inside tas loop\n");
//		unsigned val;
//		do {
			_mm_pause();
//			__atomic_load(&mutex, &val, __ATOMIC_CONSUME);
//		} while (val == 1);
	}

//	while (!read_flag) // potentially bad: this flag gets written from outside and leads to an abort -> serial execution, so no further aborts possible
//		nop_wait(1); // use -O0! this gets optimized away otherwise
	nop_wait(100);
//	printf("Wait did run through\n");

	// release
	__hle_release_clear4(&mutex);

	/* speculation lock */
//    11.463 cpu/cycles-t/             #    0,00% transactional cycles
//         0 cpu/tx-start/             #    0,000 K/sec
//         2 cpu/el-start/             #     5732 cycles / elision
//         8 cpu/cycles-ct/            #    0,00% aborted cycles

	/* spin lock */
//    552.469.312 cpu/cycles-t/             #   17,06% transactional cycles
//              0 cpu/tx-start/             #    0,000 K/sec
//     15.782.478 cpu/el-start/             #       35 cycles / elision
//     63.129.912 cpu/cycles-ct/            #   15,11% aborted cycles
}

//
int main(int argc, char *argv[]) {
	usleep(1 * 1000000); // let perf catch up

// start
	int wait = argc > 1 ? atoi(argv[1]) : 100; // choose carefully! few nops can already lead to aborts

	mutex = 0;
	std::thread tas_thread = std::thread(wait_tas_read_tas_wait, wait);
	_mm_pause();

	nop_wait(10);
	mutex = 1;

	usleep(1 * 1000000);
	mutex = 0;

// join
	tas_thread.join();
}

void rtm_tas_abort(int tid) {
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		printf("Aborting\n");
		_xend();
	} else {
		printf("Inside abort case\n");
	}
}

void rtm_tas_read_tas_wait(int wait) {
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		while (!read_flag) {
			nop_wait(1);
		}
		_xend();
	} else {
		printf("Inside abort case\n");
	}
//    423.100 cpu/cycles-t/             #   28,37% transactional cycles
//          1 cpu/tx-start/             #   423100 cycles / transaction
//          0 cpu/el-start/             #    0,000 K/sec
//          4 cpu/cycles-ct/            #   28,37% aborted cycles
}
