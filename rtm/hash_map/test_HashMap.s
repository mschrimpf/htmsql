	.file	"test_HashMap.cpp"
	.intel_syntax noprefix
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"remove %d\n"
.LC1:
	.string	"Done"
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB44:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA44
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
	sub	rsp, 40
	.cfi_def_cfa_offset 96
	cmp	edi, 1
	jle	.L2
	mov	rdi, QWORD PTR [rsi+8]
	lea	r14, [rsp+16]
	mov	edx, 10
	mov	rbp, rsi
	xor	esi, esi
	call	strtol
	mov	rdi, r14
	mov	esi, eax
.LEHB0:
	call	_ZN7HashMapC1Ei
.LEHE0:
	cmp	ebx, 2
	je	.L3
	mov	rdi, QWORD PTR [rbp+16]
	xor	esi, esi
	mov	edx, 10
	call	strtol
	test	eax, eax
	mov	DWORD PTR [rsp+12], eax
	jg	.L4
	.p2align 4,,10
	.p2align 3
.L5:
	mov	rdi, r14
.LEHB1:
	call	_ZN7HashMap5printEv
	test	r15, r15
	mov	rbx, r15
	jne	.L28
	jmp	.L12
	.p2align 4,,10
	.p2align 3
.L37:
	mov	rbx, QWORD PTR [rbx]
	test	rbx, rbx
	je	.L12
.L28:
	.p2align 4,,5
	call	rand
	test	al, 1
	jne	.L37
	mov	edx, DWORD PTR [rbx+8]
	mov	esi, OFFSET FLAT:.LC0
	mov	edi, 1
	xor	eax, eax
	call	__printf_chk
	mov	esi, DWORD PTR [rbx+8]
	mov	rdi, r14
	call	_ZN7HashMap6removeEi
	mov	rbx, QWORD PTR [rbx]
	test	rbx, rbx
	jne	.L28
.L12:
	mov	rdi, r14
	call	_ZN7HashMap5printEv
	test	r15, r15
	jne	.L29
	.p2align 4,,2
	jmp	.L17
	.p2align 4,,10
	.p2align 3
.L38:
	mov	r15, rbx
.L29:
	mov	rbx, QWORD PTR [r15]
	mov	rdi, r15
	call	_ZdlPv
	test	rbx, rbx
	jne	.L38
.L17:
	mov	edi, OFFSET FLAT:.LC1
	call	puts
.LEHE1:
	mov	rdi, r14
.LEHB2:
	call	_ZN7HashMapD1Ev
	add	rsp, 40
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
	lea	r14, [rsp+16]
	mov	esi, 10
	mov	rdi, r14
	call	_ZN7HashMapC1Ei
.LEHE2:
.L3:
	mov	DWORD PTR [rsp+12], 10
.L4:
	xor	ebp, ebp
	xor	r13d, r13d
	jmp	.L7
	.p2align 4,,10
	.p2align 3
.L39:
	mov	QWORD PTR [r13+0], rbx
.L6:
	add	ebp, 1
	cmp	DWORD PTR [rsp+12], ebp
	jle	.L5
	mov	r13, rbx
.L7:
	call	rand
	mov	rdi, r14
	mov	esi, eax
	mov	r12d, eax
.LEHB3:
	call	_ZN7HashMap6insertEi
	mov	edi, 16
	call	_Znwm
.LEHE3:
	mov	esi, r12d
	mov	rdi, rax
	mov	rbx, rax
.LEHB4:
	call	_ZN14LinkedListItemC1Ei
.LEHE4:
	test	r13, r13
	jne	.L39
	mov	r15, rbx
	jmp	.L6
.L23:
	mov	rbp, rax
	mov	rdi, rbx
	mov	rbx, rbp
	call	_ZdlPv
.L20:
	mov	rdi, r14
	call	_ZN7HashMapD1Ev
	mov	rdi, rbx
.LEHB5:
	call	_Unwind_Resume
.LEHE5:
.L22:
	mov	rbx, rax
	jmp	.L20
	.cfi_endproc
.LFE44:
	.globl	__gxx_personality_v0
	.section	.gcc_except_table,"a",@progbits
.LLSDA44:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE44-.LLSDACSB44
.LLSDACSB44:
	.uleb128 .LEHB0-.LFB44
	.uleb128 .LEHE0-.LEHB0
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB1-.LFB44
	.uleb128 .LEHE1-.LEHB1
	.uleb128 .L22-.LFB44
	.uleb128 0
	.uleb128 .LEHB2-.LFB44
	.uleb128 .LEHE2-.LEHB2
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB3-.LFB44
	.uleb128 .LEHE3-.LEHB3
	.uleb128 .L22-.LFB44
	.uleb128 0
	.uleb128 .LEHB4-.LFB44
	.uleb128 .LEHE4-.LEHB4
	.uleb128 .L23-.LFB44
	.uleb128 0
	.uleb128 .LEHB5-.LFB44
	.uleb128 .LEHE5-.LEHB5
	.uleb128 0
	.uleb128 0
.LLSDACSE44:
	.section	.text.startup
	.size	main, .-main
	.ident	"GCC: (Ubuntu/Linaro 4.8.1-10ubuntu8) 4.8.1"
	.section	.note.GNU-stack,"",@progbits
