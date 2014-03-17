#include "hle_exch_lock-spec-noload.h"
#include <xmmintrin.h> // _mm_pause
#include "../lib/hle-emulation.h"

void hle_exch_lock_spec_noload(type *lock) {
	while (__hle_acquire_exchange_n4(lock, 1)) {
		type val;
		/* Wait for lock to become free again before retrying. */
		do {
			_mm_pause();
			/* Abort speculation */
			val = *lock;
		} while (val == 1);
	}
}
void hle_exch_unlock_spec_noload(type *lock) {
	__hle_release_clear4(lock);
}
