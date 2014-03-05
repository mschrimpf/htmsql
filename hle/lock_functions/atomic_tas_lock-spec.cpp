#include "atomic_tas_lock-spec.h"
#include <xmmintrin.h> // _mm_pause

void atomic_tas_lock_spec(type *lock) {
	while (__atomic_test_and_set(lock, __ATOMIC_ACQUIRE)) { // wait until lock was not locked
		/* Wait for lock to become free again before retrying. */
		type val;
		do {
			_mm_pause();
			/* Abort speculation */
			__atomic_load(lock, &val, __ATOMIC_CONSUME);
		} while (val == 1);
	}
}
void atomic_tas_unlock_spec(type *lock) {
	__atomic_clear(lock, __ATOMIC_RELEASE);
}
