	.file	"hle_exch_lock-busy.cpp"
	.intel_syntax noprefix
	.text
	.p2align 4,,15
	.globl	_Z18hle_exch_lock_busyPj
	.type	_Z18hle_exch_lock_busyPj, @function
_Z18hle_exch_lock_busyPj:
.LFB2190:
	.cfi_startproc
	mov	eax, 1
#APP
# 200 "../lock_functions/../lib/hle-emulation.h" 1
	.byte 0xf2 ;  ; lock ; xchg eax,DWORD PTR [rdi]
# 0 "" 2
#NO_APP
	test	eax, eax
	mov	edx, 1
	je	.L1
	.p2align 4,,10
	.p2align 3
.L8:
	rep nop
	mov	eax, edx
#APP
# 200 "../lock_functions/../lib/hle-emulation.h" 1
	.byte 0xf2 ;  ; lock ; xchg eax,DWORD PTR [rdi]
# 0 "" 2
#NO_APP
	test	eax, eax
	jne	.L8
.L1:
	rep ret
	.cfi_endproc
.LFE2190:
	.size	_Z18hle_exch_lock_busyPj, .-_Z18hle_exch_lock_busyPj
	.p2align 4,,15
	.globl	_Z20hle_exch_unlock_busyPj
	.type	_Z20hle_exch_unlock_busyPj, @function
_Z20hle_exch_unlock_busyPj:
.LFB2191:
	.cfi_startproc
	xor	eax, eax
#APP
# 200 "../lock_functions/../lib/hle-emulation.h" 1
	.byte 0xf3 ; mov eax,DWORD PTR [rdi]
# 0 "" 2
#NO_APP
	ret
	.cfi_endproc
.LFE2191:
	.size	_Z20hle_exch_unlock_busyPj, .-_Z20hle_exch_unlock_busyPj
	.ident	"GCC: (Ubuntu/Linaro 4.8.1-10ubuntu8) 4.8.1"
	.section	.note.GNU-stack,"",@progbits
