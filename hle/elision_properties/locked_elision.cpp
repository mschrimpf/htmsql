#include <stdio.h>
#include <stdlib.h>

#include "../../util.h"

#include "../lib/hle-emulation.h"

int main(int argc, char *argv[]) {
	const int initialLockVal = 1;
	while (true) {
		int test = 0;
		unsigned lockVal = initialLockVal;
		unsigned * lock = &lockVal;

		__hle_acquire_exchange_n4(lock, 1);

		test = 1;

//		__hle_release_clear4(lock);
		__hle_release_store_n4(lock, initialLockVal);

//		printf("Test: %d | lock: %d\n", test, lockVal);
		// prints (for initialLockVal=1) Test: 1 | lock: 1
		// prints (for initialLockVal=0) Test: 1 | lock: 0

		// perf results
		// * very few aborts for initialLockVal = 0
		// * very few aborts for initialLockVal = 1 -> (from specification:)
		// If the instruction is restoring the value of the lock to the value it had
		// prior to the XACQUIRE prefixed lock-acquire operation on the same lock,
		// the processor elides the external write request associated with the release of the lock
		// and does not add the address of the lock to the write-set.

		// IF we would set the initialLockVal to 1 and then release_clear it,
		// we would abort 100% of the times since release_clear calls store_n(lock, 0)
		// internally and according to the specification, the transaction aborts
		// if the lock-value being written is different from the initial one.
	}
}
