#include "hle_exch_lock-spec-checked.h"
#include <xmmintrin.h> // _mm_pause
#include "../lib/hle-emulation.h"

void hle_exch_lock_spec_checked(type *lock) {
	// Check if lock is free before trying
	type val;
	do {
		_mm_pause();
		__atomic_load(lock, &val, __ATOMIC_CONSUME);
	} while (val == 1);

	while (__hle_acquire_exchange_n4(lock, 1)) {
		/* Wait for lock to become free again before retrying. */
		do {
			_mm_pause();
			/* Abort speculation */
			__atomic_load(lock, &val, __ATOMIC_CONSUME);
		} while (val == 1);
	}
}
void hle_exch_unlock_spec_checked(type *lock) {
	__hle_release_clear4(lock);
}
