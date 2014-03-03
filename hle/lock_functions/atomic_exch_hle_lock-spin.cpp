#include "atomic_exch_hle_lock-spin.h"
#include <xmmintrin.h> // _mm_pause

void atomic_exch_hle_lock_spin(type *lock) {
	while (__atomic_exchange_n(lock, 1,
			__ATOMIC_ACQUIRE | __ATOMIC_HLE_ACQUIRE) != 0) {
		type val;
		/* Wait for lock to become free again before retrying. */
		do {
			_mm_pause();
			/* Abort speculation */
			__atomic_load(lock, &val, __ATOMIC_CONSUME);
		} while (val == 1);
	}
}
void atomic_exch_hle_unlock_spin(type *lock) {
	__atomic_store_n(lock, 0, __ATOMIC_RELEASE | __ATOMIC_HLE_RELEASE);
	// from http://gcc.gnu.org/onlinedocs/gcc/x86-specific-memory-model-extensions-for-transactional-memory.html
}
