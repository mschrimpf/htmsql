#include "atomic_exch_lock-busy.h"
#include <xmmintrin.h> // _mm_pause

void atomic_exch_lock_busy(type *lock) {
	while (__atomic_exchange_n(lock, 1, __ATOMIC_ACQUIRE)) {
		_mm_pause();
	}
}
void atomic_exch_unlock_busy(type *lock) {
	__atomic_clear(lock, __ATOMIC_RELEASE);
//	__atomic_store_n(lock, 0, __ATOMIC_RELEASE);
}
