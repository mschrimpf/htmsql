#include "hle_exch_lock-busy.h"
#include <xmmintrin.h> // _mm_pause
#include "../lib/hle-emulation.h"


void hle_exch_lock_busy(type *lock) {
	while (__hle_acquire_exchange_n4(lock, 1)) {
		_mm_pause();
	}
}
void hle_exch_unlock_busy(type *lock) {
	__hle_release_clear4(lock);
}
