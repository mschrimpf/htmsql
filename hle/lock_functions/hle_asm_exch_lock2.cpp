#include "hle_asm_exch_lock2.h"
#include <xmmintrin.h> // _mm_pause
#include "../lib/hle-emulation.h"
//#define __HLE_ACQUIRE ".byte 0xf2 ; "
//#define __HLE_RELEASE ".byte 0xf3 ; "

void hle_asm_exch_lock2(type *lock) {
	asm volatile(
			"1:  movl $1, %%eax          \n\t"
			"    xacquire lock xchgl %%eax, (%0) \n\t"
			"    cmpl $0, %%eax         \n\t"
			"    jz 3f                 \n\t"
			"2:  pause                 \n\t"
			"    cmpl $1, (%0)         \n\t"
			"    jz 2b                 \n\t"
			"    jmp 1b                \n\t"
			"3:                        \n\t"
			:
			: "r"(lock)
			: "cc", "%eax", "memory");
}

void hle_asm_exch_unlock2(type *lock) {
	asm volatile(
			"xrelease movl $0,(%0) \n\t"
			:
			: "r"(lock)
			: "cc", "memory");
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
