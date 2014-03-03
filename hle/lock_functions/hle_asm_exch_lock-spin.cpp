#include "hle_asm_exch_lock-spin.h"
#include <xmmintrin.h> // _mm_pause
#include "../lib/hle-emulation.h"
//#define __HLE_ACQUIRE ".byte 0xf2 ; "
//#define __HLE_RELEASE ".byte 0xf3 ; "

void hle_asm_exch_lock_spin(type *lock) {
	type val = 1;
	do {
		asm volatile(__HLE_ACQUIRE " ; lock ; xchg %0,%1"
				: "+q" (val), "+m" (*lock)
				:
				: "memory");
		if (val != 1) { // we're done
			return; // don't do inner loop
		}
		/* Wait for lock to become free again before retrying. */
		type store_val;
		do {
			_mm_pause();
			// __hle_acquire_store_n(lock, &val);
			asm volatile(__HLE_ACQUIRE "mov %1,%0"
					: "=m" (store_val)
					: "q" (*lock)
					: "memory");
//		} while (*lock == 1); // TODO shouldn't this be store_val?
		} while (store_val == 1);
	} while (val);
}
void hle_asm_exch_unlock_spin(type *lock) {
	asm volatile(__HLE_RELEASE "mov %1,%0"
			: "=m" (*lock)
			: "q" (0)
			: "memory");
}

//	while (__hle_acquire_exchange_n4(lock, 1)) {
//		int val;
//		/* Wait for lock to become free again before retrying. */
//		do {
//		_mm_pause();
//			/* Abort speculation */
//			__hle_acquire_store_n(lock, &val);
//		} while (val == 1);
//	}
//
//	__hle_release_clear4(lock);
