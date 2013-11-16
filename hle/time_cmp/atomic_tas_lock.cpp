#include "atomic_tas_lock.h"
#include <xmmintrin.h> // _mm_pause

void atomic_tas_lock(type *lock) {
	while (__atomic_test_and_set(lock, __ATOMIC_ACQUIRE)) { // wait until lock was not locked
		_mm_pause();
	}
}
void atomic_tas_unlock(type *lock) {
	__atomic_clear(lock, __ATOMIC_RELEASE);
}
