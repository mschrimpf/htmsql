	.file	"hle_exch_lock-busy.cpp"
	.intel_syntax noprefix
	.section	.rodata
	.type	_ZStL19piecewise_construct, @object
	.size	_ZStL19piecewise_construct, 1
_ZStL19piecewise_construct:
	.zero	1
	.type	_ZStL13allocator_arg, @object
	.size	_ZStL13allocator_arg, 1
_ZStL13allocator_arg:
	.zero	1
	.type	_ZStL6ignore, @object
	.size	_ZStL6ignore, 1
_ZStL6ignore:
	.zero	1
	.type	_ZStL10defer_lock, @object
	.size	_ZStL10defer_lock, 1
_ZStL10defer_lock:
	.zero	1
	.type	_ZStL11try_to_lock, @object
	.size	_ZStL11try_to_lock, 1
_ZStL11try_to_lock:
	.zero	1
	.type	_ZStL10adopt_lock, @object
	.size	_ZStL10adopt_lock, 1
_ZStL10adopt_lock:
	.zero	1
	.text
	.globl	_Z18hle_exch_lock_busyPj
	.type	_Z18hle_exch_lock_busyPj, @function
_Z18hle_exch_lock_busyPj:
.LFB2105:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-24], rdi
	jmp	.L2
.L4:
	rep nop
.L2:
	mov	rax, QWORD PTR [rbp-24]
	mov	QWORD PTR [rbp-8], rax
	mov	DWORD PTR [rbp-12], 1
	mov	rcx, QWORD PTR [rbp-8]
	mov	eax, DWORD PTR [rbp-12]
	mov	rdx, QWORD PTR [rbp-8]
#APP
# 200 "../lib/hle-emulation.h" 1
	.byte 0xf2 ;  ; lock ; xchg eax,DWORD PTR [rcx]
# 0 "" 2
#NO_APP
	mov	DWORD PTR [rbp-12], eax
	mov	eax, DWORD PTR [rbp-12]
	test	eax, eax
	setne	al
	test	al, al
	jne	.L4
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2105:
	.size	_Z18hle_exch_lock_busyPj, .-_Z18hle_exch_lock_busyPj
	.globl	_Z20hle_exch_unlock_busyPj
	.type	_Z20hle_exch_unlock_busyPj, @function
_Z20hle_exch_unlock_busyPj:
.LFB2106:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-40], rdi
	mov	rax, QWORD PTR [rbp-40]
	mov	QWORD PTR [rbp-16], rax
	mov	rax, QWORD PTR [rbp-16]
	mov	QWORD PTR [rbp-8], rax
	mov	DWORD PTR [rbp-20], 0
	mov	rax, QWORD PTR [rbp-8]
	mov	edx, DWORD PTR [rbp-20]
#APP
# 200 "../lib/hle-emulation.h" 1
	.byte 0xf3 ; mov edx,DWORD PTR [rax]
# 0 "" 2
#NO_APP
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2106:
	.size	_Z20hle_exch_unlock_busyPj, .-_Z20hle_exch_unlock_busyPj
	.ident	"GCC: (Ubuntu/Linaro 4.8.1-10ubuntu8) 4.8.1"
	.section	.note.GNU-stack,"",@progbits
