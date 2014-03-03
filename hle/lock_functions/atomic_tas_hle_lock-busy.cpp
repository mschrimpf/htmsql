#include "atomic_tas_hle_lock-busy.h"
#include <xmmintrin.h> // _mm_pause

void atomic_tas_hle_lock_busy(type *lock) {
	while (__atomic_test_and_set(lock, __ATOMIC_ACQUIRE | __ATOMIC_HLE_ACQUIRE)) { // wait until lock was not locked
		_mm_pause();
	}
}
void atomic_tas_hle_unlock_busy(type *lock) {
	__atomic_clear(lock, __ATOMIC_RELEASE | __ATOMIC_HLE_RELEASE);
}
