	.file	"p2-1.cpp"
	.intel_syntax noprefix
	.section	.text._ZStorSt13_Ios_OpenmodeS_,"axG",@progbits,_ZStorSt13_Ios_OpenmodeS_,comdat
	.p2align 4,,15
	.weak	_ZStorSt13_Ios_OpenmodeS_
	.type	_ZStorSt13_Ios_OpenmodeS_, @function
_ZStorSt13_Ios_OpenmodeS_:
.LFB664:
	.cfi_startproc
	mov	eax, edi
	or	eax, esi
	ret
	.cfi_endproc
.LFE664:
	.size	_ZStorSt13_Ios_OpenmodeS_, .-_ZStorSt13_Ios_OpenmodeS_
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"-s"
.LC1:
	.string	"-l"
.LC2:
	.string	"Array size:       %d\n"
.LC3:
	.string	"Loops:            %d\n"
.LC4:
	.string	"Retries"
.LC5:
	.string	" "
.LC6:
	.string	"Accesses"
.LC7:
	.string	"Partial_Attempts"
.LC8:
	.string	"Partial_Failures"
.LC9:
	.string	"Partial Failure_Rate"
.LC10:
	.string	"Attempts"
.LC11:
	.string	"Failures"
.LC12:
	.string	"Failure_Rate\"\n"
.LC14:
	.string	"Failure rate: %.2f%%\n"
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB1651:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA1651
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	edx, 2
	push	rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	sub	rsp, 440
	.cfi_def_cfa_offset 464
	lea	rax, [rsp+8]
	lea	r8, [rsp+48]
	lea	rcx, [rsp+32]
	mov	DWORD PTR [rsp+8], 2042
	mov	DWORD PTR [rsp+12], 100000
	mov	QWORD PTR [rsp+32], rax
	lea	rax, [rsp+12]
	mov	QWORD PTR [rsp+48], OFFSET FLAT:.LC0
	mov	QWORD PTR [rsp+56], OFFSET FLAT:.LC1
	mov	QWORD PTR [rsp+40], rax
.LEHB0:
	call	_Z11handle_argsiPPciPPiPPKc
	mov	edx, DWORD PTR [rsp+8]
	mov	esi, OFFSET FLAT:.LC2
	mov	edi, 1
	xor	eax, eax
	call	__printf_chk
	mov	edx, DWORD PTR [rsp+12]
	mov	esi, OFFSET FLAT:.LC3
	mov	edi, 1
	xor	eax, eax
	call	__printf_chk
	mov	esi, 8
	mov	edi, 16
	call	_ZStorSt13_Ios_OpenmodeS_
	lea	rdi, [rsp+64]
	mov	esi, eax
	call	_ZNSt18basic_stringstreamIcSt11char_traitsIcESaIcEEC1ESt13_Ios_Openmode
.LEHE0:
	lea	rax, [rsp+64]
	mov	esi, OFFSET FLAT:.LC4
	lea	rdi, [rax+16]
.LEHB1:
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	mov	esi, OFFSET FLAT:.LC5
	mov	rdi, rax
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	mov	esi, OFFSET FLAT:.LC6
	mov	rdi, rax
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	mov	esi, OFFSET FLAT:.LC5
	mov	rdi, rax
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	mov	esi, OFFSET FLAT:.LC7
	mov	rdi, rax
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	mov	esi, OFFSET FLAT:.LC5
	mov	rdi, rax
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	mov	esi, OFFSET FLAT:.LC8
	mov	rdi, rax
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	mov	esi, OFFSET FLAT:.LC5
	mov	rdi, rax
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	mov	esi, OFFSET FLAT:.LC9
	mov	rdi, rax
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	mov	esi, OFFSET FLAT:.LC5
	mov	rdi, rax
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	mov	esi, OFFSET FLAT:.LC10
	mov	rdi, rax
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	mov	esi, OFFSET FLAT:.LC5
	mov	rdi, rax
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	mov	esi, OFFSET FLAT:.LC11
	mov	rdi, rax
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	mov	esi, OFFSET FLAT:.LC5
	mov	rdi, rax
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	mov	esi, OFFSET FLAT:.LC12
	mov	rdi, rax
	call	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	lea	rax, [rsp+64]
	lea	rdi, [rsp+16]
	lea	rsi, [rax+24]
	call	_ZNKSt15basic_stringbufIcSt11char_traitsIcESaIcEE3strEv
	lea	rdi, [rsp+16]
	xor	ebp, ebp
	xor	ebx, ebx
	call	_ZNSsD1Ev
	movsx	rdi, DWORD PTR [rsp+8]
	sal	rdi, 2
	call	malloc
	mov	rdi, rax
	mov	eax, DWORD PTR [rsp+12]
	test	eax, eax
	jg	.L4
	jmp	.L3
	.p2align 4,,10
	.p2align 3
.L6:
	add	ebp, 1
	cmp	DWORD PTR [rsp+12], ebx
	jle	.L3
.L4:
	add	ebx, 1
	mov	eax, -1
	xbegin	.L5
.L5:
	cmp	eax, -1
	jne	.L6
	mov	ecx, DWORD PTR [rsp+8]
	test	ecx, ecx
	jle	.L9
	sub	ecx, 1
	mov	rdx, rdi
	lea	rsi, [rdi+4+rcx*4]
	.p2align 4,,10
	.p2align 3
.L10:
	mov	ecx, DWORD PTR [rdx]
	add	rdx, 4
	add	ecx, 1
	mov	DWORD PTR [rdx-4], ecx
	cmp	rdx, rsi
	jne	.L10
.L9:
	xend
	cmp	DWORD PTR [rsp+12], ebx
	jg	.L4
.L3:
	call	free
	cvtsi2sd	xmm0, ebp
	mov	esi, OFFSET FLAT:.LC14
	cvtsi2sd	xmm1, ebx
	mov	edi, 1
	mov	eax, 1
	mulsd	xmm0, QWORD PTR .LC13[rip]
	divsd	xmm0, xmm1
	call	__printf_chk
.LEHE1:
	lea	rdi, [rsp+64]
.LEHB2:
	call	_ZNSt18basic_stringstreamIcSt11char_traitsIcESaIcEED1Ev
.LEHE2:
	add	rsp, 440
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	xor	eax, eax
	pop	rbx
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
.L13:
	.cfi_restore_state
	lea	rdi, [rsp+64]
	mov	rbx, rax
	call	_ZNSt18basic_stringstreamIcSt11char_traitsIcESaIcEED1Ev
	mov	rdi, rbx
.LEHB3:
	call	_Unwind_Resume
.LEHE3:
	.cfi_endproc
.LFE1651:
	.globl	__gxx_personality_v0
	.section	.gcc_except_table,"a",@progbits
.LLSDA1651:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE1651-.LLSDACSB1651
.LLSDACSB1651:
	.uleb128 .LEHB0-.LFB1651
	.uleb128 .LEHE0-.LEHB0
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB1-.LFB1651
	.uleb128 .LEHE1-.LEHB1
	.uleb128 .L13-.LFB1651
	.uleb128 0
	.uleb128 .LEHB2-.LFB1651
	.uleb128 .LEHE2-.LEHB2
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB3-.LFB1651
	.uleb128 .LEHE3-.LEHB3
	.uleb128 0
	.uleb128 0
.LLSDACSE1651:
	.section	.text.startup
	.size	main, .-main
	.p2align 4,,15
	.type	_GLOBAL__sub_I_main, @function
_GLOBAL__sub_I_main:
.LFB1764:
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
.LFE1764:
	.size	_GLOBAL__sub_I_main, .-_GLOBAL__sub_I_main
	.section	.init_array,"aw"
	.align 8
	.quad	_GLOBAL__sub_I_main
	.local	_ZStL8__ioinit
	.comm	_ZStL8__ioinit,1,1
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC13:
	.long	0
	.long	1079574528
	.section	.tm_clone_table,"aw",@progbits
	.align 8
	.quad	_ZStorSt13_Ios_OpenmodeS_
	.quad	_ZStorSt13_Ios_OpenmodeS_
	.hidden	__dso_handle
	.ident	"GCC: (Ubuntu/Linaro 4.8.1-10ubuntu8) 4.8.1"
	.section	.note.GNU-stack,"",@progbits
