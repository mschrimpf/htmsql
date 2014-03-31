#include <stdio.h>
#include <stdlib.h>

#include <thread>
#include <xmmintrin.h> // mm_pause
#include "../../util.h"

#include "../lib/hle-emulation.h"
#include "../lib/tsx-cpuid.h"

#define LOCK_TECHNIQUE_SPIN 0
#define LOCK_TECHNIQUE_SPEC 1
#define LOCK_TECHNIQUE LOCK_TECHNIQUE_SPEC

#define memory_barrier() asm volatile("mfence" : : : "memory");
// __sync_synchronize()

const int wait_timeout = 500000;

volatile unsigned mutex = 0;
// mutex to make sure that abort_thread is in HLE-mode when modifying the read-set
volatile unsigned mutex2 = 0;
// counter
long long read_counter = 0;
// flags
volatile int notify = 0;
volatile int run = 1;

void abort_write(int tid) {
	if (stick_this_thread_to_core(tid % num_cores) != 0)
		printf("Could not pin thread\n");

	// let tas thread start up
	usleep(wait_timeout);
//	while(__hle_acquire_exchange_n4((unsigned *) &mutex2, 1)) {
//		_mm_pause();
//	}
	// abort
	mutex = 1;
	memory_barrier()
	printf("Set mutex to %d\n", mutex);
	// let the other thread read for some time
	nop_wait(2 * wait_timeout);
	// reset
	mutex = 0;
	memory_barrier()
	printf("Set mutex to %d\n", mutex);
//	__hle_release_clear4((unsigned *) &mutex2);
}

void wait_tas_read_tas_wait(int tid) {
	if (stick_this_thread_to_core(tid % num_cores) != 0)
		printf("Could not pin thread\n");

	printf("TAS thread running\n");

	// wait for abort to be set
//	usleep(wait_timeout);

// try to elide
	while (__hle_acquire_exchange_n4(const_cast<unsigned*> &mutex, 1)) {
		printf("Inside tas loop\n");
		unsigned val;
		do {
			_mm_pause();
			__atomic_load(&mutex, &val, __ATOMIC_CONSUME);
			read_counter++;
		} while (val == 1);

		// notify
		if (val == 0) {
			printf("Notifying\n");
			notify = 1;
		}
	}

	// wait
	while (run) {
		asm volatile("nop");
	}
	// release
__hle_release_clear4(const_cast<unsigned*> &mutex);
}

long long mutex_checks = 100000;
long long mutex_sum = 0;

void check_mutex(int tid) {
if (stick_this_thread_to_core(tid % num_cores) != 0)
	printf("Could not pin thread\n");

// wait for notify
while (!notify) {
	asm volatile("nop");
}

// read mutex
for (int i = 0; i < mutex_checks; i++) {
	mutex_sum += mutex;
}

float mutex_rate = (float) mutex_sum / mutex_checks * 100;
printf("Mutex was set to one in %lld cases out of %lld (%.2f%%)\n", mutex_sum,
		mutex_checks, mutex_rate);

run = 0;
}

//
int main(int argc, char *argv[]) {
printf("CPU has hle: %d\n", cpu_has_hle());

// start
std::thread tas_thread = std::thread(wait_tas_read_tas_wait, 0);
std::thread check_thread = std::thread(check_mutex, 1);
std::thread abort_thread = std::thread(abort_write, 2);

// join
tas_thread.join();
check_thread.join();
abort_thread.join();

printf("Reads: %lld\n", read_counter);
}
