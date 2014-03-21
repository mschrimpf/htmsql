	.file	"clocktime_sleep.cpp"
	.intel_syntax noprefix
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Loops:      %d\n"
.LC1:
	.string	"Sleep time: %d ms\n"
.LC2:
	.string	"Attempts:   %d\n"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC4:
	.string	"Failures:   %d (rate % 5.2f%%)\n"
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB571:
	.cfi_startproc
	push	r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	cmp	edi, 1
	push	r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	push	r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	push	rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	push	rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	mov	ebx, edi
	jle	.L2
	mov	rdi, QWORD PTR [rsi+8]
	mov	r14, rsi
	mov	edx, 10
	xor	esi, esi
	mov	r13d, 1000
	call	strtol
	cmp	ebx, 2
	mov	rbp, rax
	mov	r12d, eax
	je	.L3
	mov	rdi, QWORD PTR [r14+16]
	mov	edx, 10
	xor	esi, esi
	call	strtol
	mov	r13d, eax
.L3:
	mov	edx, ebp
	mov	esi, OFFSET FLAT:.LC0
	mov	edi, 1
	xor	eax, eax
	call	__printf_chk
	xor	eax, eax
	mov	edx, r13d
	mov	esi, OFFSET FLAT:.LC1
	mov	edi, 1
	call	__printf_chk
	test	ebp, ebp
	jle	.L16
.L4:
	xor	ebp, ebp
	xor	ebx, ebx
	jmp	.L10
	.p2align 4,,10
	.p2align 3
.L7:
	add	ebp, 1
	cmp	r12d, ebx
	jle	.L17
.L10:
	add	ebx, 1
	mov	eax, -1
	xbegin	.L6
.L6:
	cmp	eax, -1
	jne	.L7
	mov	edi, r13d
	call	usleep
	xend
	cmp	r12d, ebx
	jg	.L10
	.p2align 4,,10
	.p2align 3
.L17:
	mov	ebx, 1
	test	r12d, r12d
	cmovg	ebx, r12d
.L5:
	mov	edx, ebx
	mov	esi, OFFSET FLAT:.LC2
	mov	edi, 1
	xor	eax, eax
	call	__printf_chk
	cvtsi2sd	xmm0, ebp
	mov	edx, ebp
	cvtsi2sd	xmm1, ebx
	mov	esi, OFFSET FLAT:.LC4
	mov	edi, 1
	mov	eax, 1
	mulsd	xmm0, QWORD PTR .LC3[rip]
	divsd	xmm0, xmm1
	call	__printf_chk
	pop	rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	pop	rbp
	.cfi_def_cfa_offset 32
	pop	r12
	.cfi_def_cfa_offset 24
	pop	r13
	.cfi_def_cfa_offset 16
	xor	eax, eax
	pop	r14
	.cfi_def_cfa_offset 8
	ret
.L2:
	.cfi_restore_state
	mov	edx, 100000
	mov	esi, OFFSET FLAT:.LC0
	mov	edi, 1
	xor	eax, eax
	mov	r12d, 100000
	mov	r13d, 1000
	call	__printf_chk
	mov	edx, 1000
	mov	esi, OFFSET FLAT:.LC1
	mov	edi, 1
	xor	eax, eax
	call	__printf_chk
	jmp	.L4
.L16:
	xor	ebp, ebp
	xor	ebx, ebx
	jmp	.L5
	.cfi_endproc
.LFE571:
	.size	main, .-main
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC3:
	.long	0
	.long	1079574528
	.ident	"GCC: (Ubuntu/Linaro 4.8.1-10ubuntu8) 4.8.1"
	.section	.note.GNU-stack,"",@progbits
