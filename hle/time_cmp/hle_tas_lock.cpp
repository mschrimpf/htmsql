#include "hle_tas_lock.h"
#include <xmmintrin.h>
#include "../lib/hle-emulation.h"

#define type unsigned

void hle_tas_lock(type *lock) {
	while (__hle_acquire_test_and_set4(lock)) { // wait until lock was not locked
		_mm_pause();
//		__asm volatile ("pause" ::: "memory");
	}
}
void hle_tas_unlock(type *lock) {
	__hle_release_clear4(lock);
}
