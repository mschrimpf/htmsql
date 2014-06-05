	.file	"LockType.cpp"
	.text
	.align 2
	.p2align 4,,15
	.globl	_ZN8LockType7no_lockEv
	.type	_ZN8LockType7no_lockEv, @function
_ZN8LockType7no_lockEv:
.LFB1575:
	.cfi_startproc
	rep ret
	.cfi_endproc
.LFE1575:
	.size	_ZN8LockType7no_lockEv, .-_ZN8LockType7no_lockEv
	.align 2
	.p2align 4,,15
	.globl	_ZN8LockType9no_unlockEv
	.type	_ZN8LockType9no_unlockEv, @function
_ZN8LockType9no_unlockEv:
.LFB1576:
	.cfi_startproc
	rep ret
	.cfi_endproc
.LFE1576:
	.size	_ZN8LockType9no_unlockEv, .-_ZN8LockType9no_unlockEv
	.align 2
	.p2align 4,,15
	.globl	_ZN8LockType9type_lockEv
	.type	_ZN8LockType9type_lockEv, @function
_ZN8LockType9type_lockEv:
.LFB1579:
	.cfi_startproc
	movq	%rdi, %rax
	leaq	96(%rdi), %rdi
	movq	40(%rax), %rax
	jmp	*%rax
	.cfi_endproc
.LFE1579:
	.size	_ZN8LockType9type_lockEv, .-_ZN8LockType9type_lockEv
	.align 2
	.p2align 4,,15
	.globl	_ZN8LockType11type_unlockEv
	.type	_ZN8LockType11type_unlockEv, @function
_ZN8LockType11type_unlockEv:
.LFB1580:
	.cfi_startproc
	movq	%rdi, %rax
	leaq	96(%rdi), %rdi
	movq	48(%rax), %rax
	jmp	*%rax
	.cfi_endproc
.LFE1580:
	.size	_ZN8LockType11type_unlockEv, .-_ZN8LockType11type_unlockEv
	.align 2
	.p2align 4,,15
	.globl	_ZN8LockType12pthread_lockEv
	.type	_ZN8LockType12pthread_lockEv, @function
_ZN8LockType12pthread_lockEv:
.LFB1577:
	.cfi_startproc
	addq	$56, %rdi
	jmp	pthread_mutex_lock
	.cfi_endproc
.LFE1577:
	.size	_ZN8LockType12pthread_lockEv, .-_ZN8LockType12pthread_lockEv
	.align 2
	.p2align 4,,15
	.globl	_ZN8LockType14pthread_unlockEv
	.type	_ZN8LockType14pthread_unlockEv, @function
_ZN8LockType14pthread_unlockEv:
.LFB1578:
	.cfi_startproc
	addq	$56, %rdi
	jmp	pthread_mutex_unlock
	.cfi_endproc
.LFE1578:
	.size	_ZN8LockType14pthread_unlockEv, .-_ZN8LockType14pthread_unlockEv
	.align 2
	.p2align 4,,15
	.globl	_ZN8LockTypeC2Ev
	.type	_ZN8LockTypeC2Ev, @function
_ZN8LockTypeC2Ev:
.LFB1569:
	.cfi_startproc
	movq	$0, 24(%rdi)
	movq	$0, 32(%rdi)
	movq	24(%rdi), %rax
	movq	32(%rdi), %rdx
	movq	$0, 56(%rdi)
	movq	$0, 64(%rdi)
	movq	$0, 72(%rdi)
	movq	$0, 80(%rdi)
	movq	$0, 88(%rdi)
	movl	$0, 96(%rdi)
	movq	%rax, 8(%rdi)
	movq	%rdx, 16(%rdi)
	movq	$0, 48(%rdi)
	movq	$0, 40(%rdi)
	ret
	.cfi_endproc
.LFE1569:
	.size	_ZN8LockTypeC2Ev, .-_ZN8LockTypeC2Ev
	.globl	_ZN8LockTypeC1Ev
	.set	_ZN8LockTypeC1Ev,_ZN8LockTypeC2Ev
	.align 2
	.p2align 4,,15
	.globl	_ZN8LockType4initENS_8EnumTypeE
	.type	_ZN8LockType4initENS_8EnumTypeE, @function
_ZN8LockType4initENS_8EnumTypeE:
.LFB1574:
	.cfi_startproc
	cmpl	$18, %esi
	movl	%esi, (%rdi)
	ja	.L8
	movl	%esi, %esi
	jmp	*.L11(,%rsi,8)
	.section	.rodata
	.align 8
	.align 4
.L11:
	.quad	.L10
	.quad	.L12
	.quad	.L13
	.quad	.L13
	.quad	.L13
	.quad	.L13
	.quad	.L13
	.quad	.L13
	.quad	.L13
	.quad	.L13
	.quad	.L14
	.quad	.L13
	.quad	.L13
	.quad	.L13
	.quad	.L13
	.quad	.L13
	.quad	.L13
	.quad	.L13
	.quad	.L13
	.text
	.p2align 4,,10
	.p2align 3
.L33:
	movq	$_Z26hle_asm_exch_lock_asm_specPj, 40(%rdi)
	movq	$_Z28hle_asm_exch_unlock_asm_specPj, 48(%rdi)
.L8:
	rep ret
	.p2align 4,,10
	.p2align 3
.L13:
	movq	$_ZN8LockType9type_lockEv, 8(%rdi)
	movq	$0, 16(%rdi)
	movq	$_ZN8LockType11type_unlockEv, 24(%rdi)
	movq	$0, 32(%rdi)
	ja	.L8
	jmp	*.L18(,%rsi,8)
	.section	.rodata
	.align 8
	.align 4
.L18:
	.quad	.L8
	.quad	.L8
	.quad	.L17
	.quad	.L19
	.quad	.L20
	.quad	.L21
	.quad	.L22
	.quad	.L23
	.quad	.L24
	.quad	.L25
	.quad	.L8
	.quad	.L26
	.quad	.L27
	.quad	.L28
	.quad	.L29
	.quad	.L30
	.quad	.L31
	.quad	.L32
	.quad	.L33
	.text
	.p2align 4,,10
	.p2align 3
.L12:
	movq	$_ZN8LockType12pthread_lockEv, 8(%rdi)
	movq	$0, 16(%rdi)
	movq	$_ZN8LockType14pthread_unlockEv, 24(%rdi)
	movq	$0, 32(%rdi)
	ret
	.p2align 4,,10
	.p2align 3
.L10:
	movq	$_ZN8LockType7no_lockEv, 8(%rdi)
	movq	$0, 16(%rdi)
	movq	$_ZN8LockType9no_unlockEv, 24(%rdi)
	movq	$0, 32(%rdi)
	ret
	.p2align 4,,10
	.p2align 3
.L14:
	movq	$0, 24(%rdi)
	movq	$0, 32(%rdi)
	movq	24(%rdi), %rax
	movq	32(%rdi), %rdx
	movq	$0, 48(%rdi)
	movq	$0, 40(%rdi)
	movq	%rax, 8(%rdi)
	movq	%rdx, 16(%rdi)
	ret
	.p2align 4,,10
	.p2align 3
.L32:
	movq	$_Z22hle_asm_exch_lock_specPj, 40(%rdi)
	movq	$_Z24hle_asm_exch_unlock_specPj, 48(%rdi)
	ret
	.p2align 4,,10
	.p2align 3
.L31:
	movq	$_Z22hle_asm_exch_lock_busyPj, 40(%rdi)
	movq	$_Z24hle_asm_exch_unlock_busyPj, 48(%rdi)
	ret
	.p2align 4,,10
	.p2align 3
.L30:
	movq	$_Z26hle_exch_lock_spec_checkedPj, 40(%rdi)
	movq	$_Z28hle_exch_unlock_spec_checkedPj, 48(%rdi)
	ret
	.p2align 4,,10
	.p2align 3
.L29:
	movq	$_Z18hle_exch_lock_specPj, 40(%rdi)
	movq	$_Z20hle_exch_unlock_specPj, 48(%rdi)
	ret
	.p2align 4,,10
	.p2align 3
.L28:
	movq	$_Z18hle_exch_lock_busyPj, 40(%rdi)
	movq	$_Z20hle_exch_unlock_busyPj, 48(%rdi)
	ret
	.p2align 4,,10
	.p2align 3
.L27:
	movq	$_Z17hle_tas_lock_specPj, 40(%rdi)
	movq	$_Z19hle_tas_unlock_specPj, 48(%rdi)
	ret
	.p2align 4,,10
	.p2align 3
.L26:
	movq	$_Z17hle_tas_lock_busyPj, 40(%rdi)
	movq	$_Z19hle_tas_unlock_busyPj, 48(%rdi)
	ret
	.p2align 4,,10
	.p2align 3
.L25:
	movq	$_Z24atomic_tas_hle_lock_specPj, 40(%rdi)
	movq	$_Z26atomic_tas_hle_unlock_specPj, 48(%rdi)
	ret
	.p2align 4,,10
	.p2align 3
.L24:
	movq	$_Z24atomic_tas_hle_lock_busyPj, 40(%rdi)
	movq	$_Z26atomic_tas_hle_unlock_busyPj, 48(%rdi)
	ret
	.p2align 4,,10
	.p2align 3
.L23:
	movq	$_Z20atomic_tas_lock_specPj, 40(%rdi)
	movq	$_Z22atomic_tas_unlock_specPj, 48(%rdi)
	ret
	.p2align 4,,10
	.p2align 3
.L22:
	movq	$_Z20atomic_tas_lock_busyPj, 40(%rdi)
	movq	$_Z22atomic_tas_unlock_busyPj, 48(%rdi)
	ret
	.p2align 4,,10
	.p2align 3
.L21:
	movq	$_Z25atomic_exch_hle_lock_specPj, 40(%rdi)
	movq	$_Z27atomic_exch_hle_unlock_specPj, 48(%rdi)
	ret
	.p2align 4,,10
	.p2align 3
.L20:
	movq	$_Z25atomic_exch_hle_lock_busyPj, 40(%rdi)
	movq	$_Z27atomic_exch_hle_unlock_busyPj, 48(%rdi)
	ret
	.p2align 4,,10
	.p2align 3
.L19:
	movq	$_Z21atomic_exch_lock_specPj, 40(%rdi)
	movq	$_Z23atomic_exch_unlock_specPj, 48(%rdi)
	ret
	.p2align 4,,10
	.p2align 3
.L17:
	movq	$_Z21atomic_exch_lock_busyPj, 40(%rdi)
	movq	$_Z23atomic_exch_unlock_busyPj, 48(%rdi)
	ret
	.cfi_endproc
.LFE1574:
	.size	_ZN8LockType4initENS_8EnumTypeE, .-_ZN8LockType4initENS_8EnumTypeE
	.align 2
	.p2align 4,,15
	.globl	_ZN8LockTypeC2ENS_8EnumTypeE
	.type	_ZN8LockTypeC2ENS_8EnumTypeE, @function
_ZN8LockTypeC2ENS_8EnumTypeE:
.LFB1572:
	.cfi_startproc
	movq	$0, 56(%rdi)
	movq	$0, 64(%rdi)
	movq	$0, 72(%rdi)
	movq	$0, 80(%rdi)
	movq	$0, 88(%rdi)
	movl	$0, 96(%rdi)
	jmp	_ZN8LockType4initENS_8EnumTypeE
	.cfi_endproc
.LFE1572:
	.size	_ZN8LockTypeC2ENS_8EnumTypeE, .-_ZN8LockTypeC2ENS_8EnumTypeE
	.globl	_ZN8LockTypeC1ENS_8EnumTypeE
	.set	_ZN8LockTypeC1ENS_8EnumTypeE,_ZN8LockTypeC2ENS_8EnumTypeE
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"No synchronization"
.LC1:
	.string	"POSIX Thread"
.LC2:
	.string	"atomic_EXCH_BUSY"
.LC3:
	.string	"atomic_EXCH_SPEC"
.LC4:
	.string	"atomic_EXCH_HLE-busy"
.LC5:
	.string	"atomic_EXCH_HLE-spec"
.LC6:
	.string	"atomic_TAS_BUSY"
.LC7:
	.string	"atomic_TAS_SPEC"
.LC8:
	.string	"atomic_TAS_HLE_BUSY"
.LC9:
	.string	"atomic_TAS_HLE_SPEC"
.LC10:
	.string	"RTM"
.LC11:
	.string	"HLE_TAS_BUSY"
.LC12:
	.string	"HLE_TAS_SPEC"
.LC13:
	.string	"HLE_EXCH_BUSY"
.LC14:
	.string	"HLE_EXCH_SPEC"
.LC15:
	.string	"HLE_EXCH_SPEC_CHECKED"
.LC16:
	.string	"HLE_ASM_EXCH-busy"
.LC17:
	.string	"HLE_ASM_EXCH-spec"
.LC18:
	.string	"HLE_ASM_EXCH-asm_spec"
	.text
	.align 2
	.p2align 4,,15
	.globl	_ZN8LockType11getEnumTextENS_8EnumTypeE
	.type	_ZN8LockType11getEnumTextENS_8EnumTypeE, @function
_ZN8LockType11getEnumTextENS_8EnumTypeE:
.LFB1587:
	.cfi_startproc
	cmpl	$18, %edi
	ja	.L37
	movl	%edi, %edi
	jmp	*.L39(,%rdi,8)
	.section	.rodata
	.align 8
	.align 4
.L39:
	.quad	.L38
	.quad	.L58
	.quad	.L41
	.quad	.L42
	.quad	.L43
	.quad	.L44
	.quad	.L45
	.quad	.L46
	.quad	.L47
	.quad	.L48
	.quad	.L49
	.quad	.L50
	.quad	.L51
	.quad	.L52
	.quad	.L53
	.quad	.L54
	.quad	.L55
	.quad	.L56
	.quad	.L57
	.text
	.p2align 4,,10
	.p2align 3
.L58:
	movl	$.LC1, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L41:
	movl	$.LC2, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L42:
	movl	$.LC3, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L43:
	movl	$.LC4, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L44:
	movl	$.LC5, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L45:
	movl	$.LC6, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L46:
	movl	$.LC7, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L47:
	movl	$.LC8, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L48:
	movl	$.LC9, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L49:
	movl	$.LC10, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L50:
	movl	$.LC11, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L51:
	movl	$.LC12, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L52:
	movl	$.LC13, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L53:
	movl	$.LC14, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L54:
	movl	$.LC15, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L55:
	movl	$.LC16, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L56:
	movl	$.LC17, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L57:
	movl	$.LC18, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L38:
	movl	$.LC0, %eax
	ret
	.p2align 4,,10
	.p2align 3
.L37:
	rep ret
	.cfi_endproc
.LFE1587:
	.size	_ZN8LockType11getEnumTextENS_8EnumTypeE, .-_ZN8LockType11getEnumTextENS_8EnumTypeE
	.section	.rodata.str1.1
.LC19:
	.string	";"
.LC20:
	.string	"\n"
.LC21:
	.string	"%s"
	.text
	.align 2
	.p2align 4,,15
	.globl	_ZN8LockType16printHeaderRangeEPS_iiP8_IO_FILE
	.type	_ZN8LockType16printHeaderRangeEPS_iiP8_IO_FILE, @function
_ZN8LockType16printHeaderRangeEPS_iiP8_IO_FILE:
.LFB1583:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movl	%edx, %r12d
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movl	%esi, %ebx
	subq	$8, %rsp
	.cfi_def_cfa_offset 64
	cmpl	%edx, %esi
	jge	.L59
	movslq	%esi, %rax
	leal	-1(%rdx), %r14d
	movq	%rcx, %rbp
	leaq	(%rax,%rax,2), %rdx
	movl	$.LC20, %r13d
	leaq	(%rax,%rdx,4), %rax
	leaq	(%rdi,%rax,8), %r15
	.p2align 4,,10
	.p2align 3
.L63:
	movl	(%r15), %edi
	call	_ZN8LockType11getEnumTextENS_8EnumTypeE
	movl	$.LC21, %edx
	movq	%rax, %rcx
	movl	$1, %esi
	movq	%rbp, %rdi
	xorl	%eax, %eax
	call	__fprintf_chk
	cmpl	%r14d, %ebx
	movl	$.LC19, %ecx
	movl	$.LC21, %edx
	cmovge	%r13, %rcx
	movl	$1, %esi
	xorl	%eax, %eax
	movq	%rbp, %rdi
	addl	$1, %ebx
	addq	$104, %r15
	call	__fprintf_chk
	cmpl	%r12d, %ebx
	jne	.L63
.L59:
	addq	$8, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE1583:
	.size	_ZN8LockType16printHeaderRangeEPS_iiP8_IO_FILE, .-_ZN8LockType16printHeaderRangeEPS_iiP8_IO_FILE
	.align 2
	.p2align 4,,15
	.globl	_ZN8LockType11printHeaderEPS_iP8_IO_FILE
	.type	_ZN8LockType11printHeaderEPS_iP8_IO_FILE, @function
_ZN8LockType11printHeaderEPS_iP8_IO_FILE:
.LFB1582:
	.cfi_startproc
	movq	%rdx, %rcx
	movl	%esi, %edx
	xorl	%esi, %esi
	jmp	_ZN8LockType16printHeaderRangeEPS_iiP8_IO_FILE
	.cfi_endproc
.LFE1582:
	.size	_ZN8LockType11printHeaderEPS_iP8_IO_FILE, .-_ZN8LockType11printHeaderEPS_iP8_IO_FILE
	.align 2
	.p2align 4,,15
	.globl	_ZN8LockType11printHeaderEPPS_iP8_IO_FILE
	.type	_ZN8LockType11printHeaderEPPS_iP8_IO_FILE, @function
_ZN8LockType11printHeaderEPPS_iP8_IO_FILE:
.LFB1581:
	.cfi_startproc
	movq	(%rdi), %rdi
	movq	%rdx, %rcx
	movl	%esi, %edx
	xorl	%esi, %esi
	jmp	_ZN8LockType16printHeaderRangeEPS_iiP8_IO_FILE
	.cfi_endproc
.LFE1581:
	.size	_ZN8LockType11printHeaderEPPS_iP8_IO_FILE, .-_ZN8LockType11printHeaderEPPS_iP8_IO_FILE
	.section	.rodata.str1.1
.LC22:
	.string	" %s"
	.text
	.align 2
	.p2align 4,,15
	.globl	_ZN8LockType16printHeaderRangeEPS_iiPPKciP8_IO_FILE
	.type	_ZN8LockType16printHeaderRangeEPS_iiPPKciP8_IO_FILE, @function
_ZN8LockType16printHeaderRangeEPS_iiPPKciP8_IO_FILE:
.LFB1586:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movl	%edx, %ebx
	subq	$40, %rsp
	.cfi_def_cfa_offset 96
	cmpl	%edx, %esi
	movl	%esi, 12(%rsp)
	movl	%edx, 24(%rsp)
	movq	%rcx, 16(%rsp)
	jge	.L68
	movslq	%esi, %rax
	leal	-1(%r8), %r15d
	movl	%r8d, %r14d
	leaq	(%rax,%rax,2), %rdx
	movq	%r9, %r12
	leaq	(%rax,%rdx,4), %rax
	leaq	(%rdi,%rax,8), %r13
	movl	%ebx, %eax
	subl	$1, %eax
	movl	%eax, 28(%rsp)
	.p2align 4,,10
	.p2align 3
.L70:
	testl	%r14d, %r14d
	jle	.L73
	movq	16(%rsp), %rbp
	xorl	%ebx, %ebx
	.p2align 4,,10
	.p2align 3
.L74:
	movl	0(%r13), %edi
	call	_ZN8LockType11getEnumTextENS_8EnumTypeE
	movl	$.LC21, %edx
	movq	%rax, %rcx
	movl	$1, %esi
	movq	%r12, %rdi
	xorl	%eax, %eax
	call	__fprintf_chk
	movq	0(%rbp), %rcx
	xorl	%eax, %eax
	movl	$.LC22, %edx
	movl	$1, %esi
	movq	%r12, %rdi
	call	__fprintf_chk
	cmpl	%r15d, %ebx
	jge	.L78
	movl	$.LC19, %ecx
.L71:
	xorl	%eax, %eax
	movl	$.LC21, %edx
	movl	$1, %esi
	movq	%r12, %rdi
	addl	$1, %ebx
	addq	$8, %rbp
	call	__fprintf_chk
	cmpl	%r14d, %ebx
	jne	.L74
.L73:
	addl	$1, 12(%rsp)
	addq	$104, %r13
	movl	24(%rsp), %eax
	cmpl	%eax, 12(%rsp)
	jne	.L70
.L68:
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
.L78:
	.cfi_restore_state
	movl	12(%rsp), %eax
	cmpl	%eax, 28(%rsp)
	movl	$.LC19, %ecx
	movl	$.LC20, %eax
	cmovle	%rax, %rcx
	jmp	.L71
	.cfi_endproc
.LFE1586:
	.size	_ZN8LockType16printHeaderRangeEPS_iiPPKciP8_IO_FILE, .-_ZN8LockType16printHeaderRangeEPS_iiPPKciP8_IO_FILE
	.align 2
	.p2align 4,,15
	.globl	_ZN8LockType11printHeaderEPS_iPPKciP8_IO_FILE
	.type	_ZN8LockType11printHeaderEPS_iPPKciP8_IO_FILE, @function
_ZN8LockType11printHeaderEPS_iPPKciP8_IO_FILE:
.LFB1585:
	.cfi_startproc
	movq	%r8, %r9
	movl	%ecx, %r8d
	movq	%rdx, %rcx
	movl	%esi, %edx
	xorl	%esi, %esi
	jmp	_ZN8LockType16printHeaderRangeEPS_iiPPKciP8_IO_FILE
	.cfi_endproc
.LFE1585:
	.size	_ZN8LockType11printHeaderEPS_iPPKciP8_IO_FILE, .-_ZN8LockType11printHeaderEPS_iPPKciP8_IO_FILE
	.align 2
	.p2align 4,,15
	.globl	_ZN8LockType11printHeaderEPPS_iPPKciP8_IO_FILE
	.type	_ZN8LockType11printHeaderEPPS_iPPKciP8_IO_FILE, @function
_ZN8LockType11printHeaderEPPS_iPPKciP8_IO_FILE:
.LFB1584:
	.cfi_startproc
	movq	(%rdi), %rdi
	movq	%r8, %r9
	movl	%ecx, %r8d
	movq	%rdx, %rcx
	movl	%esi, %edx
	xorl	%esi, %esi
	jmp	_ZN8LockType16printHeaderRangeEPS_iiPPKciP8_IO_FILE
	.cfi_endproc
.LFE1584:
	.size	_ZN8LockType11printHeaderEPPS_iPPKciP8_IO_FILE, .-_ZN8LockType11printHeaderEPPS_iPPKciP8_IO_FILE
	.ident	"GCC: (Ubuntu/Linaro 4.8.1-10ubuntu8) 4.8.1"
	.section	.note.GNU-stack,"",@progbits
