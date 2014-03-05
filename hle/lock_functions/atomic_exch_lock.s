	.file	"atomic_exch_lock.cpp"
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
	.globl	_Z16atomic_exch_lockPj
	.type	_Z16atomic_exch_lockPj, @function
_Z16atomic_exch_lockPj:
.LFB1993:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-24], rdi
	jmp	.L2
.L3:
	rep nop
	mov	rax, QWORD PTR [rbp-24]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rbp-4], eax
	mov	eax, DWORD PTR [rbp-4]
	cmp	eax, 1
	je	.L3
.L2:
	mov	rdx, QWORD PTR [rbp-24]
	mov	eax, 1
	xchg	eax, DWORD PTR [rdx]
	test	eax, eax
	setne	al
	test	al, al
	jne	.L3
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
.L5:
	.cfi_endproc
.LFE1993:
	.size	_Z16atomic_exch_lockPj, .-_Z16atomic_exch_lockPj
	.globl	_Z18atomic_exch_unlockPj
	.type	_Z18atomic_exch_unlockPj, @function
_Z18atomic_exch_unlockPj:
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
	mov	DWORD PTR [rax], edx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1994:
	.size	_Z18atomic_exch_unlockPj, .-_Z18atomic_exch_unlockPj
	.ident	"GCC: (Ubuntu/Linaro 4.8.1-10ubuntu8) 4.8.1"
	.section	.note.GNU-stack,"",@progbits
