	.file	"atomic_exch_hle_lock-busy.cpp"
	.intel_syntax noprefix
	.text
	.p2align 4,,15
	.globl	_Z25atomic_exch_hle_lock_busyPj
	.type	_Z25atomic_exch_hle_lock_busyPj, @function
_Z25atomic_exch_hle_lock_busyPj:
.LFB2078:
	.cfi_startproc
	mov	edx, 1
	jmp	.L2
	.p2align 4,,10
	.p2align 3
.L3:
	rep nop
.L2:
	mov	eax, edx
	xacquire xchg	eax, DWORD PTR [rdi]
	test	eax, eax
	jne	.L3
	rep ret
	.cfi_endproc
.LFE2078:
	.size	_Z25atomic_exch_hle_lock_busyPj, .-_Z25atomic_exch_hle_lock_busyPj
	.p2align 4,,15
	.globl	_Z27atomic_exch_hle_unlock_busyPj
	.type	_Z27atomic_exch_hle_unlock_busyPj, @function
_Z27atomic_exch_hle_unlock_busyPj:
.LFB2079:
	.cfi_startproc
	xrelease mov	BYTE PTR [rdi], 0
	ret
	.cfi_endproc
.LFE2079:
	.size	_Z27atomic_exch_hle_unlock_busyPj, .-_Z27atomic_exch_hle_unlock_busyPj
	.ident	"GCC: (Ubuntu/Linaro 4.8.1-10ubuntu8) 4.8.1"
	.section	.note.GNU-stack,"",@progbits
