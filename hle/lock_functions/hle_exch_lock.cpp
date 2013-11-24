#include "hle_exch_lock.h"
#include <xmmintrin.h> // _mm_pause
#include "../lib/hle-emulation.h"


void hle_exch_lock(type *lock) {
	while (__hle_acquire_exchange_n##type_size(lock, 1)) {
//		int val;
//		/* Wait for lock to become free again before retrying. */
//		do {
		_mm_pause();
//			/* Abort speculation */
//			__hle_acquire_store_n(lock, &val);
//		} while (val == 1);
	}
}
void hle_exch_unlock(type *lock) {
	__hle_release_clear##type_size(lock);
}
