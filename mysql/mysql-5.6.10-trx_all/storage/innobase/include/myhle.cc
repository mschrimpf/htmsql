#include "hle-emulation.h"
#include <xmmintrin.h> // _mm_pause

void hle_lock(volatile unsigned *lock) {
	while (__hle_acquire_exchange_n4(lock, 1)) {
		unsigned val;
		/* Wait for lock to become free again before retrying. */
		do {
			_mm_pause();
			/* Abort speculation */
			__atomic_load(lock, &val, __ATOMIC_CONSUME);
		} while (val == 1);
	}
}
void hle_unlock(volatile unsigned *lock) {
	__hle_release_clear4(lock);
}
