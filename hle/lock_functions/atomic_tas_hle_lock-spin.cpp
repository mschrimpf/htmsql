#include "atomic_tas_hle_lock-spin.h"
#include <xmmintrin.h> // _mm_pause

void atomic_tas_hle_lock_spin(type *lock) {
	while (__atomic_test_and_set(lock, __ATOMIC_ACQUIRE | __ATOMIC_HLE_ACQUIRE)) { // wait until lock was not locked
		type val;
		/* Wait for lock to become free again before retrying. */
		do {
			_mm_pause();
			/* Abort speculation */
			__atomic_load(lock, &val, __ATOMIC_CONSUME);
		} while (val == 1);
	}
}
void atomic_tas_hle_unlock_spin(type *lock) {
	__atomic_clear(lock, __ATOMIC_RELEASE | __ATOMIC_HLE_RELEASE);
}
