#include <stdio.h>
#include <stdlib.h>

#include <thread>
#include <xmmintrin.h> // mm_pause
#include <immintrin.h> // rtm
#include "../../util.h"

#include "../lib/hle-emulation.h"
#include "../lib/tsx-cpuid.h"

#define SPIN 0
#define SPECULATION 1
#define LOCK_TECHNIQUE SPECULATION


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


unsigned mutex = 0;
int read_flag = 0;

void wait_tas_read_tas_wait() {
// try to elide
	while (__hle_acquire_exchange_n4(&mutex, 1)) {
//		printf("Inside tas loop\n");
#if(LOCK_TECHNIQUE == SPIN)
		_mm_pause();
#elif(LOCK_TECHNIQUE == SPECULATION)
		unsigned val;
		do {
			_mm_pause();
			__atomic_load(&mutex, &val, __ATOMIC_CONSUME);
		} while (val == 1);
#endif
	}

//	int dummy = read_flag;

//	while (!read_flag) // potentially bad: this flag gets written from outside and leads to an abort -> serial execution, so no further aborts possible
//		nop_wait(1); // use -O0! this gets optimized away otherwise
	nop_wait(1000);
//	printf("Wait did run through\n");

	// release
	__hle_release_clear4(&mutex);
}

// speculation: 2 starts, 2 aborts - one misc5 (other) and one misc3 (unfriendly instructions)
// 		one of the two aborts is probably the _mm_pause, the other is the read_set modification
// spin: millions of starts and aborts, mostly misc3 (unfriendly instructions) and very few misc5 (other)
// 		makes me assume that _mm_pause is an unfriendly instruction and set-invalidations are counted to misc5
//int main(int argc, char *argv[]) {
//	usleep(1 * 1000000); // let perf catch up
//
//// start
//	mutex = 0;
//	std::thread tas_thread = std::thread(wait_tas_read_tas_wait);
//	_mm_pause();
//
//	nop_wait(10);
//	mutex = 1;
//
//	usleep(1 * 1000000);
//	mutex = 0;
//
//// join
//	tas_thread.join();
//}

// speculation: 3 starts, 3 aborts (misc5 - other, misc1 - conflicts, misc3 - unfriendly)
// 		- why not 2 misc5 + 1 misc3? --> maybe because the mutex is set to 1 which counts as misc1 before the read-set invalidation occurs in the second thread
// 		The first thread does not have another start because it goes into serial execution which does not count additionally
// spin: millions of starts and aborts, mostly misc3 + 1 misc1 + 2 misc5
// 		=> misc3 = _mm_pause or system calls in general
// 		=> misc5 = set-invalidation
// 		thus, one start = one successful elision | one aborted elision and the following serial execution
// 		 - the following serial execution counts to the same el-start
// 		==> "HLE always elides"!!! every spin-tas-call is one elision that is immediately aborted and the following sequential call that loops itself
// ====> speculation only helps because it starts fewer consecutive elisions - but both always elide!
// 			since the spin-lock performs a serial execution after the elision (which is attempted extremely often),
// 			it aborts all processors that are currently eliding. The speculation-lock does this only once and then waits for the lock to become free
// 	- but why does the third speculation-transaction not commit then?

//int main(int argc, char *argv[]) {
//	usleep(1 * 1000000); // let perf catch up
//
//// start
//	mutex = 0;
//	std::thread tas_thread = std::thread(wait_tas_read_tas_wait);
//	std::thread tas_thread2 = std::thread(wait_tas_read_tas_wait);
//	_mm_pause();
//
//	nop_wait(10);
//	read_flag = 1;
//
//// join
//	tas_thread.join();
//	tas_thread2.join();
//}

// speculation: 5 starts, 5 aborts (3 misc5 - other, 1 misc1 - conflict, 1 misc3 - unfriendly)
// 		- why not 6 starts, 4 aborts and 2 commits?

int main(int argc, char *argv[]) {
	usleep(1 * 1000000); // let perf catch up

// start
	mutex = 0;
	std::thread tas_thread = std::thread(wait_tas_read_tas_wait);
	std::thread tas_thread2 = std::thread(wait_tas_read_tas_wait);
	_mm_pause();

	nop_wait(10);
	mutex = 1;

	usleep(1 * 1000);
	mutex = 0;

// join
	tas_thread.join();
	tas_thread2.join();
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
