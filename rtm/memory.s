	.file	"memory.cpp"
	.text
	.globl	_Z5stacki
	.type	_Z5stacki, @function
_Z5stacki:
.LFB955:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	$-1, %eax
	xbegin	.L2
.L2:
	cmpl	$-1, %eax
	sete	%al
	testb	%al, %al
	je	.L4
	movq	%rsp, %rax
	movq	%rax, %rsi
	movl	-20(%rbp), %eax
	cltq
	subq	$1, %rax
	movq	%rax, -16(%rbp)
	movq	%rax, %rdi
	addq	$1, %rdi
	movq	%rdi, %r8
	movl	$0, %r9d
	movq	%rax, %rdi
	addq	$1, %rdi
	movq	%rdi, %rdx
	movl	$0, %ecx
	leaq	1(%rax), %rdx
	movl	$16, %eax
	subq	$1, %rax
	addq	%rdx, %rax
	movl	$16, %ecx
	movl	$0, %edx
	divq	%rcx
	imulq	$16, %rax, %rax
	subq	%rax, %rsp
	movq	%rsp, %rax
	addq	$0, %rax
	movq	%rax, -8(%rbp)
	xend
	movl	$0, %eax
	movq	%rsi, %rsp
	jmp	.L5
.L4:
	movl	$1, %eax
.L5:
.L7:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE955:
	.size	_Z5stacki, .-_Z5stacki
	.globl	_Z9freeStorei
	.type	_Z9freeStorei, @function
_Z9freeStorei:
.LFB956:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	$-1, %eax
	xbegin	.L9
.L9:
	cmpl	$-1, %eax
	sete	%al
	testb	%al, %al
	je	.L11
	movl	-20(%rbp), %eax
	cltq
	movq	%rax, %rdi
	call	_Znam
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	je	.L12
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	_ZdaPv
.L12:
	xend
	movl	$0, %eax
	jmp	.L13
.L11:
	movl	$1, %eax
.L13:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE956:
	.size	_Z9freeStorei, .-_Z9freeStorei
	.globl	_Z4heapi
	.type	_Z4heapi, @function
_Z4heapi:
.LFB957:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movl	$-1, %eax
	xbegin	.L15
.L15:
	cmpl	$-1, %eax
	sete	%al
	testb	%al, %al
	je	.L17
	movl	-20(%rbp), %eax
	cltq
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free
	xend
	movl	$0, %eax
	jmp	.L18
.L17:
	movl	$1, %eax
.L18:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE957:
	.size	_Z4heapi, .-_Z4heapi
	.section	.rodata
.LC0:
	.string	"Stack"
.LC2:
	.string	";%.2f\n"
.LC3:
	.string	"Free Store"
.LC4:
	.string	"Heap"
	.text
	.globl	main
	.type	main, @function
main:
.LFB958:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA958
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$152, %rsp
	.cfi_offset 3, -24
	movl	%edi, -148(%rbp)
	movq	%rsi, -160(%rbp)
	cmpl	$1, -148(%rbp)
	jle	.L20
	movq	-160(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi
	jmp	.L21
.L20:
	movl	$1000, %eax
.L21:
	movl	%eax, -132(%rbp)
	cmpl	$2, -148(%rbp)
	jle	.L22
	movq	-160(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi
	jmp	.L23
.L22:
	movl	$1, %eax
.L23:
	movl	%eax, -128(%rbp)
	leaq	-112(%rbp), %rax
	movq	%rax, %rdi
.LEHB0:
	call	_ZN5StatsC1Ev
.LEHE0:
	movl	$.LC0, %edi
	movl	$0, %eax
.LEHB1:
	call	printf
	movl	$0, -144(%rbp)
	jmp	.L24
.L25:
	movl	-128(%rbp), %eax
	movl	%eax, %edi
	call	_Z5stacki
	movl	%eax, -124(%rbp)
	cvtsi2ss	-124(%rbp), %xmm0
	leaq	-112(%rbp), %rax
	movq	%rax, %rdi
	call	_ZN5Stats8addValueEf
	addl	$1, -144(%rbp)
.L24:
	movl	-144(%rbp), %eax
	cmpl	-132(%rbp), %eax
	jl	.L25
	leaq	-112(%rbp), %rax
	movq	%rax, %rdi
	call	_ZN5Stats16getExpectedValueEv
	movsd	.LC1(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movl	$.LC2, %edi
	movl	$1, %eax
	call	printf
	leaq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	_ZN5StatsC1Ev
.LEHE1:
	movl	$.LC3, %edi
	movl	$0, %eax
.LEHB2:
	call	printf
	movl	$0, -140(%rbp)
	jmp	.L26
.L27:
	movl	-128(%rbp), %eax
	movl	%eax, %edi
	call	_Z9freeStorei
	movl	%eax, -120(%rbp)
	cvtsi2ss	-120(%rbp), %xmm0
	leaq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	_ZN5Stats8addValueEf
	addl	$1, -140(%rbp)
.L26:
	movl	-140(%rbp), %eax
	cmpl	-132(%rbp), %eax
	jl	.L27
	leaq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	_ZN5Stats16getExpectedValueEv
	movsd	.LC1(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movl	$.LC2, %edi
	movl	$1, %eax
	call	printf
	leaq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	_ZN5StatsC1Ev
.LEHE2:
	movl	$.LC4, %edi
	movl	$0, %eax
.LEHB3:
	call	printf
	movl	$0, -136(%rbp)
	jmp	.L28
.L29:
	movl	-128(%rbp), %eax
	movl	%eax, %edi
	call	_Z4heapi
	movl	%eax, -116(%rbp)
	cvtsi2ss	-116(%rbp), %xmm0
	leaq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	_ZN5Stats8addValueEf
	addl	$1, -136(%rbp)
.L28:
	movl	-136(%rbp), %eax
	cmpl	-132(%rbp), %eax
	jl	.L29
	leaq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	_ZN5Stats16getExpectedValueEv
	movsd	.LC1(%rip), %xmm1
	mulsd	%xmm1, %xmm0
	movl	$.LC2, %edi
	movl	$1, %eax
	call	printf
.LEHE3:
	leaq	-48(%rbp), %rax
	movq	%rax, %rdi
.LEHB4:
	call	_ZN5StatsD1Ev
.LEHE4:
	leaq	-80(%rbp), %rax
	movq	%rax, %rdi
.LEHB5:
	call	_ZN5StatsD1Ev
.LEHE5:
	leaq	-112(%rbp), %rax
	movq	%rax, %rdi
.LEHB6:
	call	_ZN5StatsD1Ev
.LEHE6:
	movl	$0, %eax
	jmp	.L39
.L38:
	movq	%rax, %rbx
	leaq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	_ZN5StatsD1Ev
	jmp	.L32
.L37:
	movq	%rax, %rbx
.L32:
	leaq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	_ZN5StatsD1Ev
	jmp	.L33
.L36:
	movq	%rax, %rbx
.L33:
	leaq	-112(%rbp), %rax
	movq	%rax, %rdi
	call	_ZN5StatsD1Ev
	movq	%rbx, %rax
	jmp	.L34
.L35:
.L34:
	movq	%rax, %rdi
.LEHB7:
	call	_Unwind_Resume
.LEHE7:
.L39:
	addq	$152, %rsp
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE958:
	.globl	__gxx_personality_v0
	.section	.gcc_except_table,"a",@progbits
.LLSDA958:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE958-.LLSDACSB958
.LLSDACSB958:
	.uleb128 .LEHB0-.LFB958
	.uleb128 .LEHE0-.LEHB0
	.uleb128 .L35-.LFB958
	.uleb128 0
	.uleb128 .LEHB1-.LFB958
	.uleb128 .LEHE1-.LEHB1
	.uleb128 .L36-.LFB958
	.uleb128 0
	.uleb128 .LEHB2-.LFB958
	.uleb128 .LEHE2-.LEHB2
	.uleb128 .L37-.LFB958
	.uleb128 0
	.uleb128 .LEHB3-.LFB958
	.uleb128 .LEHE3-.LEHB3
	.uleb128 .L38-.LFB958
	.uleb128 0
	.uleb128 .LEHB4-.LFB958
	.uleb128 .LEHE4-.LEHB4
	.uleb128 .L37-.LFB958
	.uleb128 0
	.uleb128 .LEHB5-.LFB958
	.uleb128 .LEHE5-.LEHB5
	.uleb128 .L36-.LFB958
	.uleb128 0
	.uleb128 .LEHB6-.LFB958
	.uleb128 .LEHE6-.LEHB6
	.uleb128 .L35-.LFB958
	.uleb128 0
	.uleb128 .LEHB7-.LFB958
	.uleb128 .LEHE7-.LEHB7
	.uleb128 0
	.uleb128 0
.LLSDACSE958:
	.text
	.size	main, .-main
	.globl	_Z10deleteOnlyPh
	.type	_Z10deleteOnlyPh, @function
_Z10deleteOnlyPh:
.LFB959:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movl	$-1, %eax
	xbegin	.L41
.L41:
	cmpl	$-1, %eax
	sete	%al
	testb	%al, %al
	je	.L43
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	_ZdlPv
	xend
	movl	$0, %eax
	jmp	.L44
.L43:
	movl	$1, %eax
.L44:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE959:
	.size	_Z10deleteOnlyPh, .-_Z10deleteOnlyPh
	.section	.rodata
	.align 8
.LC1:
	.long	0
	.long	1079574528
	.ident	"GCC: (Ubuntu/Linaro 4.8.1-10ubuntu8) 4.8.1"
	.section	.note.GNU-stack,"",@progbits
