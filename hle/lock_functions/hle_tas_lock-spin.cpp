#include "hle_tas_lock-spin.h"
#include <xmmintrin.h>
#include "../lib/hle-emulation.h"

#define type unsigned

void hle_tas_lock_spin(type *lock) {
	while (__hle_acquire_test_and_set4(lock)) { // wait until lock was not locked
		type val;
		/* Wait for lock to become free again before retrying. */
		do {
			_mm_pause();
			/* Abort speculation */
//			val = *lock; // TODO what to use
			__atomic_load(lock, &val, __ATOMIC_CONSUME);
		} while (val == 1);
	}
}
void hle_tas_unlock_spin(type *lock) {
	__hle_release_clear4(lock);
}
