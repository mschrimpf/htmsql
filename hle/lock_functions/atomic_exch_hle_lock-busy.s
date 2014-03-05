	.file	"atomic_exch_hle_lock-busy.cpp"
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
	.globl	_Z25atomic_exch_hle_lock_busyPj
	.type	_Z25atomic_exch_hle_lock_busyPj, @function
_Z25atomic_exch_hle_lock_busyPj:
.LFB1993:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	jmp	.L2
.L3:
	rep nop
.L2:
	mov	rdx, QWORD PTR [rbp-8]
	mov	eax, 1
	xacquire xchg	eax, DWORD PTR [rdx]
	test	eax, eax
	setne	al
	test	al, al
	jne	.L3
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1993:
	.size	_Z25atomic_exch_hle_lock_busyPj, .-_Z25atomic_exch_hle_lock_busyPj
	.globl	_Z27atomic_exch_hle_unlock_busyPj
	.type	_Z27atomic_exch_hle_unlock_busyPj, @function
_Z27atomic_exch_hle_unlock_busyPj:
.LFB1994:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	edx, 0
	xrelease mov	DWORD PTR [rax], edx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1994:
	.size	_Z27atomic_exch_hle_unlock_busyPj, .-_Z27atomic_exch_hle_unlock_busyPj
	.ident	"GCC: (Ubuntu/Linaro 4.8.1-10ubuntu8) 4.8.1"
	.section	.note.GNU-stack,"",@progbits
