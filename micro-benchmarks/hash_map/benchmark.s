	.file	"benchmark.cpp"
	.intel_syntax noprefix
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"-s"
.LC1:
	.string	"-i"
.LC2:
	.string	"-l"
.LC3:
	.string	"-v"
.LC4:
	.string	"-p"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC5:
	.string	"The variety cannot be greater than the size!\n"
	.section	.rodata.str1.1
.LC6:
	.string	"size:    %d\n"
.LC7:
	.string	"inserts: %d\n"
.LC8:
	.string	"loops:   %d\n"
.LC9:
	.string	"variety: %d\n"
.LC10:
	.string	"____________"
	.section	.rodata.str1.8
	.align 8
.LC11:
	.string	"Attempts:   %d (%d inserts x %d loops)\n"
	.align 8
.LC13:
	.string	"Failures:   %d (Rate: % 5.2f%%)\n"
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB1041:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA1041
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	mov	edx, 5
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
	sub	rsp, 152
	.cfi_def_cfa_offset 208
	lea	rax, [rsp+12]
	lea	r8, [rsp+96]
	lea	rcx, [rsp+48]
	mov	DWORD PTR [rsp+12], 10
	mov	DWORD PTR [rsp+16], 100
	mov	QWORD PTR [rsp+48], rax
	lea	rax, [rsp+16]
	mov	DWORD PTR [rsp+20], 1000
	mov	DWORD PTR [rsp+24], 0
	mov	DWORD PTR [rsp+28], 0
	mov	QWORD PTR [rsp+56], rax
	lea	rax, [rsp+20]
	mov	QWORD PTR [rsp+96], OFFSET FLAT:.LC0
	mov	QWORD PTR [rsp+104], OFFSET FLAT:.LC1
	mov	QWORD PTR [rsp+112], OFFSET FLAT:.LC2
	mov	QWORD PTR [rsp+64], rax
	lea	rax, [rsp+24]
	mov	QWORD PTR [rsp+120], OFFSET FLAT:.LC3
	mov	QWORD PTR [rsp+128], OFFSET FLAT:.LC4
	mov	QWORD PTR [rsp+72], rax
	lea	rax, [rsp+28]
	mov	QWORD PTR [rsp+80], rax
.LEHB0:
	call	_Z11handle_argsiPPciPPiPPKc
	mov	edx, DWORD PTR [rsp+12]
	cmp	DWORD PTR [rsp+24], edx
	jg	.L26
	mov	esi, OFFSET FLAT:.LC6
	mov	edi, 1
	xor	eax, eax
	call	__printf_chk
	mov	edx, DWORD PTR [rsp+16]
	mov	esi, OFFSET FLAT:.LC7
	mov	edi, 1
	xor	eax, eax
	call	__printf_chk
	mov	edx, DWORD PTR [rsp+20]
	mov	esi, OFFSET FLAT:.LC8
	mov	edi, 1
	xor	eax, eax
	call	__printf_chk
	mov	edx, DWORD PTR [rsp+24]
	mov	esi, OFFSET FLAT:.LC9
	mov	edi, 1
	xor	eax, eax
	call	__printf_chk
	mov	edi, OFFSET FLAT:.LC10
	call	puts
	mov	ecx, DWORD PTR [rsp+20]
	test	ecx, ecx
	jle	.L18
	xor	r14d, r14d
	xor	r15d, r15d
	xor	r12d, r12d
	.p2align 4,,10
	.p2align 3
.L12:
	mov	esi, DWORD PTR [rsp+12]
	lea	rdi, [rsp+32]
	call	_ZN7HashMapC1Ei
.LEHE0:
	mov	ecx, DWORD PTR [rsp+24]
	test	ecx, ecx
	je	.L5
	mov	eax, DWORD PTR [rsp+12]
	cdq
	idiv	ecx
	mov	r13d, eax
.L6:
	mov	edx, DWORD PTR [rsp+16]
	mov	ebx, r12d
	test	edx, edx
	jle	.L7
	xor	ebp, ebp
	.p2align 4,,10
	.p2align 3
.L8:
	add	ebp, r13d
	lea	rdi, [rsp+32]
	add	ebx, 1
	mov	esi, ebp
.LEHB1:
	call	_ZN7HashMap6insertEi
.LEHE1:
.L17:
	mov	eax, ebx
	sub	eax, r12d
	cmp	eax, DWORD PTR [rsp+16]
	jl	.L8
.L7:
	mov	eax, DWORD PTR [rsp+28]
	test	eax, eax
	je	.L11
	lea	rdi, [rsp+32]
.LEHB2:
	call	_ZN7HashMap5printEv
.LEHE2:
.L11:
	lea	rdi, [rsp+32]
	add	r14d, 1
.LEHB3:
	call	_ZN7HashMapD1Ev
	cmp	DWORD PTR [rsp+20], r14d
	jle	.L4
	mov	r12d, ebx
	jmp	.L12
	.p2align 4,,10
	.p2align 3
.L5:
	mov	r13d, DWORD PTR [rsp+12]
	jmp	.L6
.L18:
	xor	r15d, r15d
	xor	ebx, ebx
.L4:
	mov	edi, OFFSET FLAT:.LC10
	call	puts
	mov	r8d, DWORD PTR [rsp+20]
	mov	ecx, DWORD PTR [rsp+16]
	mov	edx, ebx
	mov	esi, OFFSET FLAT:.LC11
	mov	edi, 1
	xor	eax, eax
	call	__printf_chk
	cvtsi2ss	xmm0, r15d
	mov	edx, r15d
	cvtsi2ss	xmm1, ebx
	mov	esi, OFFSET FLAT:.LC13
	mov	edi, 1
	mov	eax, 1
	mulss	xmm0, DWORD PTR .LC12[rip]
	divss	xmm0, xmm1
	unpcklps	xmm0, xmm0
	cvtps2pd	xmm0, xmm0
	call	__printf_chk
	xor	eax, eax
.L22:
	add	rsp, 152
	.cfi_remember_state
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
.L26:
	.cfi_restore_state
	mov	rcx, QWORD PTR stderr[rip]
	mov	edx, 45
	mov	esi, 1
	mov	edi, OFFSET FLAT:.LC5
	call	fwrite
.LEHE3:
	mov	eax, 1
	jmp	.L22
.L21:
.L24:
	lea	rdi, [rsp+32]
	mov	rbx, rax
	call	_ZN7HashMapD1Ev
	mov	rdi, rbx
.LEHB4:
	call	_Unwind_Resume
.LEHE4:
.L20:
	sub	rdx, 1
	jne	.L24
	mov	rdi, rax
	add	r15d, 1
	call	__cxa_begin_catch
.LEHB5:
	call	__cxa_end_catch
.LEHE5:
	jmp	.L17
	.cfi_endproc
.LFE1041:
	.globl	__gxx_personality_v0
	.section	.gcc_except_table,"a",@progbits
	.align 4
.LLSDA1041:
	.byte	0xff
	.byte	0x3
	.uleb128 .LLSDATT1041-.LLSDATTD1041
.LLSDATTD1041:
	.byte	0x1
	.uleb128 .LLSDACSE1041-.LLSDACSB1041
.LLSDACSB1041:
	.uleb128 .LEHB0-.LFB1041
	.uleb128 .LEHE0-.LEHB0
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB1-.LFB1041
	.uleb128 .LEHE1-.LEHB1
	.uleb128 .L20-.LFB1041
	.uleb128 0x3
	.uleb128 .LEHB2-.LFB1041
	.uleb128 .LEHE2-.LEHB2
	.uleb128 .L21-.LFB1041
	.uleb128 0
	.uleb128 .LEHB3-.LFB1041
	.uleb128 .LEHE3-.LEHB3
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB4-.LFB1041
	.uleb128 .LEHE4-.LEHB4
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB5-.LFB1041
	.uleb128 .LEHE5-.LEHB5
	.uleb128 .L21-.LFB1041
	.uleb128 0
.LLSDACSE1041:
	.byte	0
	.byte	0
	.byte	0x1
	.byte	0x7d
	.align 4
	.long	_ZTI13LockException
.LLSDATT1041:
	.section	.text.startup
	.size	main, .-main
	.p2align 4,,15
	.type	_GLOBAL__sub_I_main, @function
_GLOBAL__sub_I_main:
.LFB1043:
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
.LFE1043:
	.size	_GLOBAL__sub_I_main, .-_GLOBAL__sub_I_main
	.section	.init_array,"aw"
	.align 8
	.quad	_GLOBAL__sub_I_main
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
	.local	_ZStL8__ioinit
	.comm	_ZStL8__ioinit,1,1
	.section	.rodata.cst4,"aM",@progbits,4
	.align 4
.LC12:
	.long	1120403456
	.hidden	__dso_handle
	.ident	"GCC: (Ubuntu/Linaro 4.8.1-10ubuntu8) 4.8.1"
	.section	.note.GNU-stack,"",@progbits
