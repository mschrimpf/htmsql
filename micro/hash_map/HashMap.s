	.file	"HashMap.cpp"
	.intel_syntax noprefix
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Could not acquire lock"
	.section	.text._ZNK13LockException4whatEv,"axG",@progbits,_ZNK13LockException4whatEv,comdat
	.align 2
	.p2align 4,,15
	.weak	_ZNK13LockException4whatEv
	.type	_ZNK13LockException4whatEv, @function
_ZNK13LockException4whatEv:
.LFB1559:
	.cfi_startproc
	mov	eax, OFFSET FLAT:.LC0
	ret
	.cfi_endproc
.LFE1559:
	.size	_ZNK13LockException4whatEv, .-_ZNK13LockException4whatEv
	.section	.text._ZN13LockExceptionD2Ev,"axG",@progbits,_ZN13LockExceptionD5Ev,comdat
	.align 2
	.p2align 4,,15
	.weak	_ZN13LockExceptionD2Ev
	.type	_ZN13LockExceptionD2Ev, @function
_ZN13LockExceptionD2Ev:
.LFB1588:
	.cfi_startproc
	mov	QWORD PTR [rdi], OFFSET FLAT:_ZTV13LockException+16
	jmp	_ZNSt9exceptionD2Ev
	.cfi_endproc
.LFE1588:
	.size	_ZN13LockExceptionD2Ev, .-_ZN13LockExceptionD2Ev
	.weak	_ZN13LockExceptionD1Ev
	.set	_ZN13LockExceptionD1Ev,_ZN13LockExceptionD2Ev
	.section	.text._ZN13LockExceptionD0Ev,"axG",@progbits,_ZN13LockExceptionD0Ev,comdat
	.align 2
	.p2align 4,,15
	.weak	_ZN13LockExceptionD0Ev
	.type	_ZN13LockExceptionD0Ev, @function
_ZN13LockExceptionD0Ev:
.LFB1590:
	.cfi_startproc
	push	rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	mov	rbx, rdi
	mov	QWORD PTR [rdi], OFFSET FLAT:_ZTV13LockException+16
	call	_ZNSt9exceptionD2Ev
	mov	rdi, rbx
	pop	rbx
	.cfi_def_cfa_offset 8
	jmp	_ZdlPv
	.cfi_endproc
.LFE1590:
	.size	_ZN13LockExceptionD0Ev, .-_ZN13LockExceptionD0Ev
	.text
	.align 2
	.p2align 4,,15
	.globl	_ZN14LinkedListItemC2EiPS_
	.type	_ZN14LinkedListItemC2EiPS_, @function
_ZN14LinkedListItemC2EiPS_:
.LFB1561:
	.cfi_startproc
	mov	DWORD PTR [rdi+8], esi
	mov	QWORD PTR [rdi], rdx
	ret
	.cfi_endproc
.LFE1561:
	.size	_ZN14LinkedListItemC2EiPS_, .-_ZN14LinkedListItemC2EiPS_
	.globl	_ZN14LinkedListItemC1EiPS_
	.set	_ZN14LinkedListItemC1EiPS_,_ZN14LinkedListItemC2EiPS_
	.align 2
	.p2align 4,,15
	.globl	_ZN14LinkedListItemC2Ei
	.type	_ZN14LinkedListItemC2Ei, @function
_ZN14LinkedListItemC2Ei:
.LFB1564:
	.cfi_startproc
	mov	DWORD PTR [rdi+8], esi
	mov	QWORD PTR [rdi], 0
	ret
	.cfi_endproc
.LFE1564:
	.size	_ZN14LinkedListItemC2Ei, .-_ZN14LinkedListItemC2Ei
	.globl	_ZN14LinkedListItemC1Ei
	.set	_ZN14LinkedListItemC1Ei,_ZN14LinkedListItemC2Ei
	.align 2
	.p2align 4,,15
	.globl	_ZN14LinkedListItem4initEiPS_
	.type	_ZN14LinkedListItem4initEiPS_, @function
_ZN14LinkedListItem4initEiPS_:
.LFB1566:
	.cfi_startproc
	mov	DWORD PTR [rdi+8], esi
	mov	QWORD PTR [rdi], rdx
	ret
	.cfi_endproc
.LFE1566:
	.size	_ZN14LinkedListItem4initEiPS_, .-_ZN14LinkedListItem4initEiPS_
	.align 2
	.p2align 4,,15
	.globl	_ZN7HashMapC2Ei
	.type	_ZN7HashMapC2Ei, @function
_ZN7HashMapC2Ei:
.LFB1568:
	.cfi_startproc
	push	rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	mov	rbx, rdi
	mov	DWORD PTR [rdi], esi
	movsx	rdi, esi
	mov	esi, 8
	call	calloc
	mov	QWORD PTR [rbx+8], rax
	pop	rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE1568:
	.size	_ZN7HashMapC2Ei, .-_ZN7HashMapC2Ei
	.globl	_ZN7HashMapC1Ei
	.set	_ZN7HashMapC1Ei,_ZN7HashMapC2Ei
	.align 2
	.p2align 4,,15
	.globl	_ZN7HashMapD2Ev
	.type	_ZN7HashMapD2Ev, @function
_ZN7HashMapD2Ev:
.LFB1571:
	.cfi_startproc
	push	r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	xor	r13d, r13d
	push	r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	mov	r12, rdi
	push	rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	xor	ebp, ebp
	push	rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	sub	rsp, 8
	.cfi_def_cfa_offset 48
	mov	eax, DWORD PTR [rdi]
	test	eax, eax
	jle	.L15
	.p2align 4,,10
	.p2align 3
.L19:
	mov	rdx, rbp
	add	rdx, QWORD PTR [r12+8]
	mov	rdi, QWORD PTR [rdx]
	test	rdi, rdi
	jne	.L14
	jmp	.L12
	.p2align 4,,10
	.p2align 3
.L23:
	mov	rdi, rbx
.L14:
	mov	rbx, QWORD PTR [rdi]
	call	_ZdlPv
	test	rbx, rbx
	jne	.L23
	mov	rdx, rbp
	add	rdx, QWORD PTR [r12+8]
.L12:
	add	r13d, 1
	add	rbp, 8
	cmp	DWORD PTR [r12], r13d
	mov	QWORD PTR [rdx], 0
	jg	.L19
.L15:
	mov	rdi, QWORD PTR [r12+8]
	add	rsp, 8
	.cfi_def_cfa_offset 40
	pop	rbx
	.cfi_def_cfa_offset 32
	pop	rbp
	.cfi_def_cfa_offset 24
	pop	r12
	.cfi_def_cfa_offset 16
	pop	r13
	.cfi_def_cfa_offset 8
	jmp	free
	.cfi_endproc
.LFE1571:
	.size	_ZN7HashMapD2Ev, .-_ZN7HashMapD2Ev
	.globl	_ZN7HashMapD1Ev
	.set	_ZN7HashMapD1Ev,_ZN7HashMapD2Ev
	.align 2
	.p2align 4,,15
	.globl	_ZN7HashMap6insertEi
	.type	_ZN7HashMap6insertEi, @function
_ZN7HashMap6insertEi:
.LFB1573:
	.cfi_startproc
	push	r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	mov	eax, esi
	cdq
	push	rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	mov	ebp, esi
	push	rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	mov	rbx, rdi
	idiv	DWORD PTR [rdi]
	mov	eax, -1
	xbegin	.L25
.L25:
	cmp	eax, -1
	jne	.L26
	mov	rax, QWORD PTR [rdi+8]
	movsx	r12, edx
	mov	rax, QWORD PTR [rax+r12*8]
	test	rax, rax
	je	.L39
	cmp	DWORD PTR [rax+8], esi
	mov	rbx, QWORD PTR [rax]
	je	.L38
	test	rbx, rbx
	je	.L35
	cmp	DWORD PTR [rbx+8], esi
	jne	.L33
	.p2align 4,,5
	jmp	.L41
	.p2align 4,,10
	.p2align 3
.L34:
	cmp	DWORD PTR [rdx+8], ebp
	je	.L31
	mov	rbx, rdx
.L33:
	mov	rdx, QWORD PTR [rbx]
	test	rdx, rdx
	jne	.L34
.L30:
	mov	edi, 16
	call	_Znwm
	mov	DWORD PTR [rax+8], ebp
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR [rbx], rax
.L38:
	xend
.L28:
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	pop	rbp
	.cfi_def_cfa_offset 16
	pop	r12
	.cfi_def_cfa_offset 8
	ret
.L41:
	.cfi_restore_state
	mov	rdx, rbx
	.p2align 4,,10
	.p2align 3
.L31:
	xend
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	pop	rbp
	.cfi_def_cfa_offset 16
	mov	rax, rdx
	pop	r12
	.cfi_def_cfa_offset 8
	ret
.L39:
	.cfi_restore_state
	mov	edi, 16
	call	_Znwm
	mov	rdx, QWORD PTR [rbx+8]
	mov	DWORD PTR [rax+8], ebp
	mov	QWORD PTR [rax], 0
	mov	QWORD PTR [rdx+r12*8], rax
	xend
	mov	rax, QWORD PTR [rbx+8]
	mov	rax, QWORD PTR [rax+r12*8]
	jmp	.L28
.L35:
	mov	rbx, rax
	jmp	.L30
.L26:
	mov	edi, 8
	call	__cxa_allocate_exception
	mov	edx, OFFSET FLAT:_ZN13LockExceptionD1Ev
	mov	QWORD PTR [rax], OFFSET FLAT:_ZTV13LockException+16
	mov	esi, OFFSET FLAT:_ZTI13LockException
	mov	rdi, rax
	call	__cxa_throw
	.cfi_endproc
.LFE1573:
	.size	_ZN7HashMap6insertEi, .-_ZN7HashMap6insertEi
	.align 2
	.p2align 4,,15
	.globl	_ZN7HashMap6removeEi
	.type	_ZN7HashMap6removeEi, @function
_ZN7HashMap6removeEi:
.LFB1583:
	.cfi_startproc
	push	r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	mov	eax, esi
	cdq
	push	rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	push	rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	mov	rbx, rdi
	idiv	DWORD PTR [rdi]
	mov	eax, -1
	xbegin	.L43
.L43:
	cmp	eax, -1
	jne	.L44
	mov	rax, QWORD PTR [rdi+8]
	movsx	rbp, edx
	mov	rcx, QWORD PTR [rax+rbp*8]
	test	rcx, rcx
	je	.L52
	cmp	DWORD PTR [rcx+8], esi
	jne	.L48
	jmp	.L56
	.p2align 4,,10
	.p2align 3
.L55:
	cmp	DWORD PTR [rdi+8], esi
	je	.L47
	mov	rcx, rdi
.L48:
	mov	rdi, QWORD PTR [rcx]
	test	rdi, rdi
	jne	.L55
.L52:
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	pop	rbp
	.cfi_def_cfa_offset 16
	xor	eax, eax
	pop	r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L47:
	.cfi_restore_state
	mov	rax, QWORD PTR [rdi]
	mov	QWORD PTR [rcx], rax
	call	_ZdlPv
.L50:
	xend
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	pop	rbp
	.cfi_def_cfa_offset 16
	mov	eax, 1
	pop	r12
	.cfi_def_cfa_offset 8
	ret
.L56:
	.cfi_restore_state
	mov	r12, QWORD PTR [rcx]
	mov	rdi, rcx
	test	r12, r12
	je	.L49
	call	_ZdlPv
	mov	rax, QWORD PTR [rbx+8]
	mov	QWORD PTR [rax+rbp*8], r12
	jmp	.L50
.L49:
	call	_ZdlPv
	mov	rax, QWORD PTR [rbx+8]
	mov	QWORD PTR [rax+rbp*8], 0
	jmp	.L50
.L44:
	mov	edi, 8
	call	__cxa_allocate_exception
	mov	edx, OFFSET FLAT:_ZN13LockExceptionD1Ev
	mov	QWORD PTR [rax], OFFSET FLAT:_ZTV13LockException+16
	mov	esi, OFFSET FLAT:_ZTI13LockException
	mov	rdi, rax
	call	__cxa_throw
	.cfi_endproc
.LFE1583:
	.size	_ZN7HashMap6removeEi, .-_ZN7HashMap6removeEi
	.align 2
	.p2align 4,,15
	.globl	_ZN7HashMap4hashEi
	.type	_ZN7HashMap4hashEi, @function
_ZN7HashMap4hashEi:
.LFB1584:
	.cfi_startproc
	mov	eax, esi
	cdq
	idiv	DWORD PTR [rdi]
	mov	eax, edx
	ret
	.cfi_endproc
.LFE1584:
	.size	_ZN7HashMap4hashEi, .-_ZN7HashMap4hashEi
	.section	.rodata.str1.1
.LC1:
	.string	"%d"
.LC2:
	.string	" -> "
	.text
	.align 2
	.p2align 4,,15
	.globl	_ZN7HashMap15printLinkedListEP14LinkedListItem
	.type	_ZN7HashMap15printLinkedListEP14LinkedListItem, @function
_ZN7HashMap15printLinkedListEP14LinkedListItem:
.LFB1586:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	xor	ebp, ebp
	push	rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	mov	rbx, rsi
	sub	rsp, 8
	.cfi_def_cfa_offset 32
	jmp	.L60
	.p2align 4,,10
	.p2align 3
.L62:
	mov	esi, OFFSET FLAT:.LC2
	mov	edi, 1
	xor	eax, eax
	call	__printf_chk
.L60:
	mov	edx, DWORD PTR [rbx+8]
	xor	eax, eax
	mov	esi, OFFSET FLAT:.LC1
	mov	edi, 1
	add	ebp, 1
	call	__printf_chk
	mov	rbx, QWORD PTR [rbx]
	test	rbx, rbx
	jne	.L62
	mov	edi, 10
	call	putchar
	add	rsp, 8
	.cfi_def_cfa_offset 24
	mov	eax, ebp
	pop	rbx
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE1586:
	.size	_ZN7HashMap15printLinkedListEP14LinkedListItem, .-_ZN7HashMap15printLinkedListEP14LinkedListItem
	.section	.rodata.str1.1
.LC3:
	.string	"Map size: %d\n"
.LC4:
	.string	"[%d] => "
.LC5:
	.string	"Elements: %d\n"
	.text
	.align 2
	.p2align 4,,15
	.globl	_ZN7HashMap5printEv
	.type	_ZN7HashMap5printEv, @function
_ZN7HashMap5printEv:
.LFB1585:
	.cfi_startproc
	push	r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	xor	eax, eax
	mov	esi, OFFSET FLAT:.LC3
	push	rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	mov	rbp, rdi
	push	rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	mov	edx, DWORD PTR [rdi]
	mov	edi, 1
	call	__printf_chk
	mov	edx, DWORD PTR [rbp+0]
	test	edx, edx
	jle	.L68
	xor	ebx, ebx
	xor	r12d, r12d
	jmp	.L67
	.p2align 4,,10
	.p2align 3
.L70:
	mov	rdi, rbp
	call	_ZN7HashMap15printLinkedListEP14LinkedListItem
	add	r12d, eax
	lea	eax, [rbx+1]
	add	rbx, 1
	cmp	DWORD PTR [rbp+0], eax
	jle	.L64
.L67:
	mov	esi, OFFSET FLAT:.LC4
	xor	eax, eax
	mov	edx, ebx
	mov	edi, 1
	call	__printf_chk
	mov	rax, QWORD PTR [rbp+8]
	mov	rsi, QWORD PTR [rax+rbx*8]
	test	rsi, rsi
	jne	.L70
	mov	edi, 10
	call	putchar
	lea	eax, [rbx+1]
	add	rbx, 1
	cmp	DWORD PTR [rbp+0], eax
	jg	.L67
	.p2align 4,,10
	.p2align 3
.L64:
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	pop	rbp
	.cfi_def_cfa_offset 16
	mov	edx, r12d
	mov	esi, OFFSET FLAT:.LC5
	mov	edi, 1
	pop	r12
	.cfi_def_cfa_offset 8
	xor	eax, eax
	jmp	__printf_chk
.L68:
	.cfi_restore_state
	xor	r12d, r12d
	jmp	.L64
	.cfi_endproc
.LFE1585:
	.size	_ZN7HashMap5printEv, .-_ZN7HashMap5printEv
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.type	_GLOBAL__sub_I__ZN14LinkedListItemC2EiPS_, @function
_GLOBAL__sub_I__ZN14LinkedListItemC2EiPS_:
.LFB1592:
	.cfi_startproc
	sub	rsp, 8
	.cfi_def_cfa_offset 16
	mov	edi, OFFSET FLAT:_ZStL8__ioinit
	call	_ZNSt8ios_base4InitC1Ev
	mov	edx, OFFSET FLAT:__dso_handle
	mov	esi, OFFSET FLAT:_ZStL8__ioinit
	mov	edi, OFFSET FLAT:_ZNSt8ios_base4InitD1Ev
	add	rsp, 8
	.cfi_def_cfa_offset 8
	jmp	__cxa_atexit
	.cfi_endproc
.LFE1592:
	.size	_GLOBAL__sub_I__ZN14LinkedListItemC2EiPS_, .-_GLOBAL__sub_I__ZN14LinkedListItemC2EiPS_
	.section	.init_array,"aw"
	.align 8
	.quad	_GLOBAL__sub_I__ZN14LinkedListItemC2EiPS_
	.weak	_ZTI13LockException
	.section	.rodata._ZTI13LockException,"aG",@progbits,_ZTI13LockException,comdat
	.align 16
	.type	_ZTI13LockException, @object
	.size	_ZTI13LockException, 24
_ZTI13LockException:
	.quad	_ZTVN10__cxxabiv120__si_class_type_infoE+16
	.quad	_ZTS13LockException
	.quad	_ZTISt9exception
	.weak	_ZTS13LockException
	.section	.rodata._ZTS13LockException,"aG",@progbits,_ZTS13LockException,comdat
	.align 16
	.type	_ZTS13LockException, @object
	.size	_ZTS13LockException, 16
_ZTS13LockException:
	.string	"13LockException"
	.weak	_ZTV13LockException
	.section	.rodata._ZTV13LockException,"aG",@progbits,_ZTV13LockException,comdat
	.align 32
	.type	_ZTV13LockException, @object
	.size	_ZTV13LockException, 40
_ZTV13LockException:
	.quad	0
	.quad	_ZTI13LockException
	.quad	_ZN13LockExceptionD1Ev
	.quad	_ZN13LockExceptionD0Ev
	.quad	_ZNK13LockException4whatEv
	.local	_ZStL8__ioinit
	.comm	_ZStL8__ioinit,1,1
	.section	.tm_clone_table,"aw",@progbits
	.align 8
	.quad	_ZNK13LockException4whatEv
	.quad	_ZNK13LockException4whatEv
	.hidden	__dso_handle
	.ident	"GCC: (Ubuntu/Linaro 4.8.1-10ubuntu8) 4.8.1"
	.section	.note.GNU-stack,"",@progbits
