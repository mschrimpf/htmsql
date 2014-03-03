/**
 @see hle/lock_functions/hle_asm_exch_lock-intel_store.cpp
 */

#define __hle_force_inline __attribute__((always_inline)) inline

#define __HLE_ACQUIRE ".byte 0xf2 ; "
#define __HLE_RELEASE ".byte 0xf3 ; "

// TODO the whole file needs more investigation
// now refactored it from hle_asm_exch_lock-intel_store.cpp
#define type unsigned short

void hle_lock(type *lock) {
	while (__hle_acquire_exchange_n4(lock, 1)) {
		type val;
		/* Wait for lock to become free again before retrying. */
		do {
			_mm_pause();
			/* Abort speculation */
			__hle_acquire_store_n4(lock, val); // move value of lock into val (readonly access)
		} while (val == 1);
	}
}
void hle_unlock(type *lock) {
	asm volatile(__HLE_RELEASE "mov %1,%0"
			: "=m" (*lock)
			: "q" (0)
			: "memory");
}

// Assembler-invokes
//void hle_lock(type *lock) {
//	type val = 1;
//	do {
//		asm volatile(__HLE_ACQUIRE " ; lock ; xchg %0,%1"
//				: "+q" (val), "+m" (*lock)
//				:
//				: "memory");
//		// we're done if the value was zero, thus we required the lock
//		type store_val = val;
//		while (store_val == 1) {
//			/* Wait for lock to become free again before retrying. */
//			_mm_pause();
//			asm volatile(__HLE_ACQUIRE "mov %1,%0"
//					: "=m" (store_val)
//					: "q" (*lock)
//					: "memory");
//		}
//	} while (val);
//}
