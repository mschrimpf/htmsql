#include "hle_exch_lock-spec.h"
#include <xmmintrin.h> // _mm_pause
#include "../lib/hle-emulation.h"

void hle_exch_lock_spec(type *lock) {
	while (__hle_acquire_exchange_n4(lock, 1)) {
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
void hle_exch_unlock_spec(type *lock) {
	__hle_release_clear4(lock);
}
