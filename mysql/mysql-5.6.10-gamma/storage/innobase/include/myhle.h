#ifndef _MYHLE_H
#define _MYHLE_H 1

#include "hle-emulation.h"
#include <xmmintrin.h> // _mm_pause

void hle_exch_spec_lock(type *lock) {
	while (__hle_acquire_exchange_n4(lock, 1)) {
		type val;
		/* Wait for lock to become free again before retrying. */
		do {
			_mm_pause();
			/* Abort speculation */
			__atomic_load(lock, &val, __ATOMIC_CONSUME);
		} while (val == 1);
	}
}
void hle_unlock(type *lock) {
	__hle_release_clear4(lock);
}

#endif /* _MYHLE_H */
