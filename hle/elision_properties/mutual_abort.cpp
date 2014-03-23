#include <stdio.h>
#include <stdlib.h>

#include "../../util.h"

#include <xmmintrin.h> // mm_pause
#include "../lib/hle-emulation.h"

void test_self_abortion() {
	int loop = 1;

	unsigned lockVal = 0;
	unsigned * lock = &lockVal;
	unsigned val = 1;

	while (loop) {
		__hle_acquire_exchange_n4(lock, 1);

		// exchange value
		asm volatile("lock ; xchg %0,%1" : "+q" (val), "+m" (*lock) :: "memory");
		// 100% aborts with this call
		// ~0% without

		__hle_release_clear4(lock);
	}
}


void test_mutual_abortion() {
	int loop = 1;

	unsigned lockVal = 0;
	unsigned * lock = &lockVal; // TODO: test with t=2 threads
	unsigned val = 1;

	while (loop) {
		__hle_acquire_exchange_n4(lock, 1);

		// exchange value
		asm volatile("lock ; xchg %0,%1" : "+q" (val), "+m" (*lock) :: "memory");
		// 100% aborts with this call
		// ~0% without

		__hle_release_clear4(lock);
	}
}


int main(int argc, char *argv[]) {
	test_mutual_abortion();
}
