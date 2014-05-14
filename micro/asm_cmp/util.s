	.file	"util.cpp"
	.intel_syntax noprefix
	.text
	.p2align 4,,15
	.globl	_Z11handle_argsiPPciPPiPPKc
	.type	_Z11handle_argsiPPciPPiPPKc, @function
_Z11handle_argsiPPciPPiPPKc:
.LFB40:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	eax, edx
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	sub	rsp, 40
	.cfi_def_cfa_offset 96
	cmp	edi, 1
	mov	DWORD PTR [rsp+24], edi
	mov	DWORD PTR [rsp+28], edx
	mov	QWORD PTR [rsp+16], rcx
	jle	.L1
	sub	eax, 1
	mov	rbp, rsi
	mov	r14, r8
	lea	r13, [8+rax*8]
	mov	ebx, 1
	.p2align 4,,10
	.p2align 3
.L3:
	mov	eax, DWORD PTR [rsp+28]
	test	eax, eax
	jle	.L6
	xor	r15d, r15d
	jmp	.L7
	.p2align 4,,10
	.p2align 3
.L4:
	add	r15, 8
	cmp	r15, r13
	je	.L6
.L7:
	movsx	rax, ebx
	mov	rsi, QWORD PTR [r14+r15]
	mov	rdi, QWORD PTR [rbp+0+rax*8]
	lea	r12, [0+rax*8]
	call	strcmp
	test	eax, eax
	jne	.L4
	mov	rax, QWORD PTR [rsp+16]
	mov	rdi, QWORD PTR [rbp+8+r12]
	xor	esi, esi
	mov	edx, 10
	add	ebx, 1
	mov	r8, QWORD PTR [rax+r15]
	add	r15, 8
	mov	QWORD PTR [rsp+8], r8
	call	strtol
	mov	r8, QWORD PTR [rsp+8]
	cmp	r15, r13
	mov	DWORD PTR [r8], eax
	jne	.L7
.L6:
	add	ebx, 1
	cmp	DWORD PTR [rsp+24], ebx
	jg	.L3
.L1:
	add	rsp, 40
	.cfi_def_cfa_offset 56
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	pop	r13
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	pop	r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE40:
	.size	_Z11handle_argsiPPciPPiPPKc, .-_Z11handle_argsiPPciPPiPPKc
	.ident	"GCC: (Ubuntu/Linaro 4.8.1-10ubuntu8) 4.8.1"
	.section	.note.GNU-stack,"",@progbits
