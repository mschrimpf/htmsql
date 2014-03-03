#include "hle_asm_exch_lock-asm_spin.h"
#include <xmmintrin.h> // _mm_pause
#include "../lib/hle-emulation.h"
//#define __HLE_ACQUIRE ".byte 0xf2 ; "
//#define __HLE_RELEASE ".byte 0xf3 ; "

void hle_asm_exch_lock_asm_spin(type *lock) {
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

void hle_asm_exch_unlock_asm_spin(type *lock) {
	asm volatile(
			"xrelease movl $0,(%0) \n\t"
			:
			: "r"(lock)
			: "cc", "memory");
}
