#include "atomic_exch_lock.h"
#include <xmmintrin.h> // _mm_pause

void atomic_exch_lock(type *lock) {
	while (__atomic_exchange_n(lock, 1, __ATOMIC_ACQUIRE)) {
		/* Wait for lock to become free again before retrying. */
		type val;
		do {
			_mm_pause();
			/* Abort speculation */
			__atomic_load(lock, &val, __ATOMIC_CONSUME);
		} while (val == 1);
	}
}
void atomic_exch_unlock(type *lock) {
	__atomic_store_n(lock, 0, __ATOMIC_RELEASE);
}
