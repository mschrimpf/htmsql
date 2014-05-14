	.file	"p1.cpp"
	.intel_syntax noprefix
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Array size:    %d\n"
.LC1:
	.string	"Loops:         %d\n"
.LC2:
	.string	"Attempts:      %d\n"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC4:
	.string	"Failures:      %d (Rate: %.2f%%)\n"
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB558:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
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
	mov	ebx, edi
	sub	rsp, 8
	.cfi_def_cfa_offset 64
	cmp	edi, 1
	jle	.L2
	mov	rdi, QWORD PTR [rsi+8]
	mov	edx, 10
	mov	r15, rsi
	xor	esi, esi
	call	strtol
	movsx	rdi, eax
	mov	r12, rax
	mov	r14d, eax
	sal	rdi, 2
	call	malloc
	mov	edx, r12d
	mov	r13, rax
	mov	esi, OFFSET FLAT:.LC0
	xor	eax, eax
	mov	edi, 1
	call	__printf_chk
	cmp	ebx, 2
	je	.L3
	mov	rdi, QWORD PTR [r15+16]
	xor	esi, esi
	mov	edx, 10
	xor	ebx, ebx
	call	strtol
	test	eax, eax
	mov	r12d, eax
	jg	.L4
	.p2align 4,,10
	.p2align 3
.L5:
	mov	rdi, r13
	call	free
	mov	edx, r12d
	mov	esi, OFFSET FLAT:.LC1
	mov	edi, 1
	xor	eax, eax
	call	__printf_chk
	mov	edx, ebx
	mov	esi, OFFSET FLAT:.LC2
	mov	edi, 1
	xor	eax, eax
	call	__printf_chk
	cvtsi2ss	xmm0, ebp
	mov	edx, ebp
	cvtsi2ss	xmm1, ebx
	mov	esi, OFFSET FLAT:.LC4
	mov	edi, 1
	mov	eax, 1
	mulss	xmm0, DWORD PTR .LC3[rip]
	divss	xmm0, xmm1
	unpcklps	xmm0, xmm0
	cvtps2pd	xmm0, xmm0
	call	__printf_chk
	add	rsp, 8
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	xor	eax, eax
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
.L2:
	.cfi_restore_state
	mov	edi, 40000
	mov	r14d, 10000
	call	malloc
	mov	edx, 10000
	mov	r13, rax
	mov	esi, OFFSET FLAT:.LC0
	mov	edi, 1
	xor	eax, eax
	call	__printf_chk
.L3:
	mov	r12d, 100000
.L4:
	lea	eax, [r14-1]
	xor	ebx, ebx
	lea	r8, [r13+4+rax*4]
	jmp	.L12
	.p2align 4,,10
	.p2align 3
.L7:
	add	ebp, 1
.L9:
	cmp	r12d, ebx
	jle	.L5
.L12:
	add	ebx, 1
	mov	eax, -1
	xbegin	.L6
.L6:
	cmp	eax, -1
	jne	.L7
	test	r14d, r14d
	mov	rcx, r13
	jle	.L10
	.p2align 4,,10
	.p2align 3
.L15:
	mov	esi, DWORD PTR [rcx]
	add	rcx, 4
	add	esi, 1
	mov	DWORD PTR [rcx-4], esi
	cmp	rcx, r8
	jne	.L15
.L10:
	xend
	jmp	.L9
	.cfi_endproc
.LFE558:
	.size	main, .-main
	.section	.rodata.cst4,"aM",@progbits,4
	.align 4
.LC3:
	.long	1120403456
	.ident	"GCC: (Ubuntu/Linaro 4.8.1-10ubuntu8) 4.8.1"
	.section	.note.GNU-stack,"",@progbits
