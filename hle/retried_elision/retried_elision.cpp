#include <stdio.h>
#include <stdlib.h>

#include "../../util.h"

#include <xmmintrin.h> // mm_pause
#include "../lib/hle-emulation.h"

void test_abortion() {
	while (true) {
		int test = 0;
		unsigned lockVal = 0;
		unsigned * lock = &lockVal;

		__hle_acquire_exchange_n4(lock, 1);

		test = 1;
		_mm_pause();

		__hle_release_clear4(lock);

		printf("Test: %d\n", test);
		// 100% Transaction aborts
		// BUT
		// test is 1 after this
		// therefore, hle fell back to do a manual mutex lock
	}
}

int main(int argc, char *argv[]) {
}
