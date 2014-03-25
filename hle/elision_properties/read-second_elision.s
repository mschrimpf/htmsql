	.file	"read-second_elision.cpp"
	.intel_syntax noprefix
	.section	.text._ZNKSt9type_infoeqERKS_,"axG",@progbits,_ZNKSt9type_infoeqERKS_,comdat
	.align 2
	.weak	_ZNKSt9type_infoeqERKS_
	.type	_ZNKSt9type_infoeqERKS_, @function
_ZNKSt9type_infoeqERKS_:
.LFB367:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rax, QWORD PTR [rbp-8]
	mov	rdx, QWORD PTR [rax+8]
	mov	rax, QWORD PTR [rbp-16]
	mov	rax, QWORD PTR [rax+8]
	cmp	rdx, rax
	je	.L2
	mov	rax, QWORD PTR [rbp-8]
	mov	rax, QWORD PTR [rax+8]
	movzx	eax, BYTE PTR [rax]
	cmp	al, 42
	je	.L3
	mov	rax, QWORD PTR [rbp-16]
	mov	rdx, QWORD PTR [rax+8]
	mov	rax, QWORD PTR [rbp-8]
	mov	rax, QWORD PTR [rax+8]
	mov	rsi, rdx
	mov	rdi, rax
	call	strcmp
	test	eax, eax
	jne	.L3
.L2:
	mov	eax, 1
	jmp	.L4
.L3:
	mov	eax, 0
.L4:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE367:
	.size	_ZNKSt9type_infoeqERKS_, .-_ZNKSt9type_infoeqERKS_
	.section	.text._ZnwmPv,"axG",@progbits,_ZnwmPv,comdat
	.weak	_ZnwmPv
	.type	_ZnwmPv, @function
_ZnwmPv:
.LFB382:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rax, QWORD PTR [rbp-16]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE382:
	.size	_ZnwmPv, .-_ZnwmPv
	.section	.text._ZdlPvS_,"axG",@progbits,_ZdlPvS_,comdat
	.weak	_ZdlPvS_
	.type	_ZdlPvS_, @function
_ZdlPvS_:
.LFB384:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE384:
	.size	_ZdlPvS_, .-_ZdlPvS_
	.section	.rodata
	.type	_ZStL19piecewise_construct, @object
	.size	_ZStL19piecewise_construct, 1
_ZStL19piecewise_construct:
	.zero	1
	.text
	.type	_ZL18__gthread_active_pv, @function
_ZL18__gthread_active_pv:
.LFB747:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	eax, OFFSET FLAT:_ZL28__gthrw___pthread_key_createPjPFvPvE
	test	rax, rax
	setne	al
	movzx	eax, al
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE747:
	.size	_ZL18__gthread_active_pv, .-_ZL18__gthread_active_pv
	.type	_ZL15__gthread_equalmm, @function
_ZL15__gthread_equalmm:
.LFB751:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rdx, QWORD PTR [rbp-16]
	mov	rax, QWORD PTR [rbp-8]
	mov	rsi, rdx
	mov	rdi, rax
	call	_ZL21__gthrw_pthread_equalmm
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE751:
	.size	_ZL15__gthread_equalmm, .-_ZL15__gthread_equalmm
	.type	_ZN9__gnu_cxxL18__exchange_and_addEPVii, @function
_ZN9__gnu_cxxL18__exchange_and_addEPVii:
.LFB776:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	DWORD PTR [rbp-12], esi
	mov	edx, DWORD PTR [rbp-12]
	mov	rax, QWORD PTR [rbp-8]
	lock xadd	DWORD PTR [rax], edx
	mov	eax, edx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE776:
	.size	_ZN9__gnu_cxxL18__exchange_and_addEPVii, .-_ZN9__gnu_cxxL18__exchange_and_addEPVii
	.type	_ZN9__gnu_cxxL25__exchange_and_add_singleEPii, @function
_ZN9__gnu_cxxL25__exchange_and_add_singleEPii:
.LFB778:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-24], rdi
	mov	DWORD PTR [rbp-28], esi
	mov	rax, QWORD PTR [rbp-24]
	mov	eax, DWORD PTR [rax]
	mov	DWORD PTR [rbp-4], eax
	mov	rax, QWORD PTR [rbp-24]
	mov	edx, DWORD PTR [rax]
	mov	eax, DWORD PTR [rbp-28]
	add	edx, eax
	mov	rax, QWORD PTR [rbp-24]
	mov	DWORD PTR [rax], edx
	mov	eax, DWORD PTR [rbp-4]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE778:
	.size	_ZN9__gnu_cxxL25__exchange_and_add_singleEPii, .-_ZN9__gnu_cxxL25__exchange_and_add_singleEPii
	.type	_ZN9__gnu_cxxL27__exchange_and_add_dispatchEPii, @function
_ZN9__gnu_cxxL27__exchange_and_add_dispatchEPii:
.LFB780:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	DWORD PTR [rbp-12], esi
	call	_ZL18__gthread_active_pv
	test	eax, eax
	setne	al
	test	al, al
	je	.L18
	mov	edx, DWORD PTR [rbp-12]
	mov	rax, QWORD PTR [rbp-8]
	mov	esi, edx
	mov	rdi, rax
	call	_ZN9__gnu_cxxL18__exchange_and_addEPVii
	jmp	.L19
.L18:
	mov	edx, DWORD PTR [rbp-12]
	mov	rax, QWORD PTR [rbp-8]
	mov	esi, edx
	mov	rdi, rax
	call	_ZN9__gnu_cxxL25__exchange_and_add_singleEPii
.L19:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE780:
	.size	_ZN9__gnu_cxxL27__exchange_and_add_dispatchEPii, .-_ZN9__gnu_cxxL27__exchange_and_add_dispatchEPii
	.section	.rodata
	.type	_ZStL13allocator_arg, @object
	.size	_ZStL13allocator_arg, 1
_ZStL13allocator_arg:
	.zero	1
	.type	_ZStL6ignore, @object
	.size	_ZStL6ignore, 1
_ZStL6ignore:
	.zero	1
	.section	.text._ZNSt6thread2idC2Ev,"axG",@progbits,_ZNSt6thread2idC5Ev,comdat
	.align 2
	.weak	_ZNSt6thread2idC2Ev
	.type	_ZNSt6thread2idC2Ev, @function
_ZNSt6thread2idC2Ev:
.LFB1840:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	QWORD PTR [rax], 0
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1840:
	.size	_ZNSt6thread2idC2Ev, .-_ZNSt6thread2idC2Ev
	.weak	_ZNSt6thread2idC1Ev
	.set	_ZNSt6thread2idC1Ev,_ZNSt6thread2idC2Ev
	.section	.text._ZSteqNSt6thread2idES0_,"axG",@progbits,_ZSteqNSt6thread2idES0_,comdat
	.weak	_ZSteqNSt6thread2idES0_
	.type	_ZSteqNSt6thread2idES0_, @function
_ZSteqNSt6thread2idES0_:
.LFB1845:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	mov	QWORD PTR [rbp-16], rdi
	mov	QWORD PTR [rbp-32], rsi
	mov	rdx, QWORD PTR [rbp-32]
	mov	rax, QWORD PTR [rbp-16]
	mov	rsi, rdx
	mov	rdi, rax
	call	_ZL15__gthread_equalmm
	test	eax, eax
	setne	al
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1845:
	.size	_ZSteqNSt6thread2idES0_, .-_ZSteqNSt6thread2idES0_
	.section	.text._ZNSt6threadD2Ev,"axG",@progbits,_ZNSt6threadD5Ev,comdat
	.align 2
	.weak	_ZNSt6threadD2Ev
	.type	_ZNSt6threadD2Ev, @function
_ZNSt6threadD2Ev:
.LFB1854:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZNKSt6thread8joinableEv
	test	al, al
	je	.L23
	call	_ZSt9terminatev
.L23:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1854:
	.size	_ZNSt6threadD2Ev, .-_ZNSt6threadD2Ev
	.weak	_ZNSt6threadD1Ev
	.set	_ZNSt6threadD1Ev,_ZNSt6threadD2Ev
	.section	.text._ZNKSt6thread8joinableEv,"axG",@progbits,_ZNKSt6thread8joinableEv,comdat
	.align 2
	.weak	_ZNKSt6thread8joinableEv
	.type	_ZNKSt6thread8joinableEv, @function
_ZNKSt6thread8joinableEv:
.LFB1858:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	mov	QWORD PTR [rbp-24], rdi
	lea	rax, [rbp-16]
	mov	rdi, rax
	call	_ZNSt6thread2idC1Ev
	mov	rdx, QWORD PTR [rbp-16]
	mov	rax, QWORD PTR [rbp-24]
	mov	rsi, rdx
	mov	rdi, QWORD PTR [rax]
	call	_ZSteqNSt6thread2idES0_
	xor	eax, 1
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1858:
	.size	_ZNKSt6thread8joinableEv, .-_ZNKSt6thread8joinableEv
	.section	.text._ZNSt12__shared_ptrINSt6thread10_Impl_baseELN9__gnu_cxx12_Lock_policyE2EED2Ev,"axG",@progbits,_ZNSt12__shared_ptrINSt6thread10_Impl_baseELN9__gnu_cxx12_Lock_policyE2EED2Ev,comdat
	.align 2
	.weak	_ZNSt12__shared_ptrINSt6thread10_Impl_baseELN9__gnu_cxx12_Lock_policyE2EED2Ev
	.type	_ZNSt12__shared_ptrINSt6thread10_Impl_baseELN9__gnu_cxx12_Lock_policyE2EED2Ev, @function
_ZNSt12__shared_ptrINSt6thread10_Impl_baseELN9__gnu_cxx12_Lock_policyE2EED2Ev:
.LFB1865:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	add	rax, 8
	mov	rdi, rax
	call	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EED1Ev
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1865:
	.size	_ZNSt12__shared_ptrINSt6thread10_Impl_baseELN9__gnu_cxx12_Lock_policyE2EED2Ev, .-_ZNSt12__shared_ptrINSt6thread10_Impl_baseELN9__gnu_cxx12_Lock_policyE2EED2Ev
	.section	.text._ZNSt10shared_ptrINSt6thread10_Impl_baseEED2Ev,"axG",@progbits,_ZNSt10shared_ptrINSt6thread10_Impl_baseEED5Ev,comdat
	.align 2
	.weak	_ZNSt10shared_ptrINSt6thread10_Impl_baseEED2Ev
	.type	_ZNSt10shared_ptrINSt6thread10_Impl_baseEED2Ev, @function
_ZNSt10shared_ptrINSt6thread10_Impl_baseEED2Ev:
.LFB1867:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZNSt12__shared_ptrINSt6thread10_Impl_baseELN9__gnu_cxx12_Lock_policyE2EED2Ev
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1867:
	.size	_ZNSt10shared_ptrINSt6thread10_Impl_baseEED2Ev, .-_ZNSt10shared_ptrINSt6thread10_Impl_baseEED2Ev
	.weak	_ZNSt10shared_ptrINSt6thread10_Impl_baseEED1Ev
	.set	_ZNSt10shared_ptrINSt6thread10_Impl_baseEED1Ev,_ZNSt10shared_ptrINSt6thread10_Impl_baseEED2Ev
	.section	.text._ZNSt6thread10_Impl_baseD2Ev,"axG",@progbits,_ZNSt6thread10_Impl_baseD5Ev,comdat
	.align 2
	.weak	_ZNSt6thread10_Impl_baseD2Ev
	.type	_ZNSt6thread10_Impl_baseD2Ev, @function
_ZNSt6thread10_Impl_baseD2Ev:
.LFB1869:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	QWORD PTR [rax], OFFSET FLAT:_ZTVNSt6thread10_Impl_baseE+16
	mov	rax, QWORD PTR [rbp-8]
	add	rax, 8
	mov	rdi, rax
	call	_ZNSt10shared_ptrINSt6thread10_Impl_baseEED1Ev
	mov	eax, 0
	test	eax, eax
	je	.L31
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZdlPv
.L31:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1869:
	.size	_ZNSt6thread10_Impl_baseD2Ev, .-_ZNSt6thread10_Impl_baseD2Ev
	.weak	_ZNSt6thread10_Impl_baseD1Ev
	.set	_ZNSt6thread10_Impl_baseD1Ev,_ZNSt6thread10_Impl_baseD2Ev
	.section	.text._ZNSt6thread10_Impl_baseD0Ev,"axG",@progbits,_ZNSt6thread10_Impl_baseD0Ev,comdat
	.align 2
	.weak	_ZNSt6thread10_Impl_baseD0Ev
	.type	_ZNSt6thread10_Impl_baseD0Ev, @function
_ZNSt6thread10_Impl_baseD0Ev:
.LFB1871:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZNSt6thread10_Impl_baseD1Ev
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZdlPv
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1871:
	.size	_ZNSt6thread10_Impl_baseD0Ev, .-_ZNSt6thread10_Impl_baseD0Ev
	.local	_ZL9num_cores
	.comm	_ZL9num_cores,4,4
	.globl	mutex
	.bss
	.align 4
	.type	mutex, @object
	.size	mutex, 4
mutex:
	.zero	4
	.globl	read_counter
	.align 8
	.type	read_counter, @object
	.size	read_counter, 8
read_counter:
	.zero	8
	.globl	notify
	.align 4
	.type	notify, @object
	.size	notify, 4
notify:
	.zero	4
	.globl	run
	.align 4
	.type	run, @object
	.size	run, 4
run:
	.zero	4
	.section	.rodata
.LC0:
	.string	"Could not pin thread"
	.text
	.globl	_Z11abort_writei
	.type	_Z11abort_writei, @function
_Z11abort_writei:
.LFB2763:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	DWORD PTR [rbp-4], edi
	mov	ecx, DWORD PTR _ZL9num_cores[rip]
	mov	eax, DWORD PTR [rbp-4]
	cdq
	idiv	ecx
	mov	eax, edx
	mov	edi, eax
	call	_Z25stick_this_thread_to_corei
	test	eax, eax
	setne	al
	test	al, al
	je	.L37
	mov	edi, OFFSET FLAT:.LC0
	call	puts
.L37:
	mov	DWORD PTR mutex[rip], 1
	mov	edi, 1000
	call	usleep
	mov	DWORD PTR mutex[rip], 0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2763:
	.size	_Z11abort_writei, .-_Z11abort_writei
	.section	.rodata
.LC1:
	.string	"Inside tas loop"
.LC2:
	.string	"Notifying"
	.align 8
.LC3:
	.string	"Aborted myself (this should not be printed before inside tas loop)"
	.text
	.globl	_Z22wait_tas_read_tas_waiti
	.type	_Z22wait_tas_read_tas_waiti, @function
_Z22wait_tas_read_tas_waiti:
.LFB2764:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA2764
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 64
	mov	DWORD PTR [rbp-52], edi
	mov	ecx, DWORD PTR _ZL9num_cores[rip]
	mov	eax, DWORD PTR [rbp-52]
	cdq
	idiv	ecx
	mov	eax, edx
	mov	edi, eax
.LEHB0:
	call	_Z25stick_this_thread_to_corei
	test	eax, eax
	setne	al
	test	al, al
	je	.L39
	mov	edi, OFFSET FLAT:.LC0
	call	puts
.LEHE0:
.L39:
	jmp	.L40
.L44:
	mov	edi, OFFSET FLAT:.LC1
.LEHB1:
	call	puts
.L41:
	rep nop
	mov	eax, DWORD PTR mutex[rip]
	mov	DWORD PTR [rbp-36], eax
	mov	rax, QWORD PTR read_counter[rip]
	add	rax, 1
	mov	QWORD PTR read_counter[rip], rax
	mov	eax, DWORD PTR [rbp-36]
	cmp	eax, 1
	je	.L41
	mov	eax, DWORD PTR [rbp-36]
	test	eax, eax
	jne	.L40
	mov	edi, OFFSET FLAT:.LC2
	call	puts
.LEHE1:
	mov	DWORD PTR notify[rip], 1
	mov	DWORD PTR run[rip], 1
.L40:
	mov	QWORD PTR [rbp-24], OFFSET FLAT:mutex
	mov	DWORD PTR [rbp-32], 1
	mov	rcx, QWORD PTR [rbp-24]
	mov	eax, DWORD PTR [rbp-32]
	mov	rdx, QWORD PTR [rbp-24]
#APP
# 200 "../lib/hle-emulation.h" 1
	.byte 0xf2 ;  ; lock ; xchg eax,DWORD PTR [rcx]
# 0 "" 2
#NO_APP
	mov	DWORD PTR [rbp-32], eax
	mov	eax, DWORD PTR [rbp-32]
	test	eax, eax
	setne	al
	test	al, al
	jne	.L44
	rep nop
	mov	edi, OFFSET FLAT:.LC3
.LEHB2:
	call	puts
	jmp	.L45
.L46:
#APP
# 55 "read-second_elision.cpp" 1
	nop
# 0 "" 2
#NO_APP
.L45:
	mov	eax, DWORD PTR run[rip]
	test	eax, eax
	jne	.L46
	mov	QWORD PTR [rbp-16], OFFSET FLAT:mutex
	mov	rax, QWORD PTR [rbp-16]
	mov	QWORD PTR [rbp-8], rax
	mov	DWORD PTR [rbp-28], 0
	mov	rax, QWORD PTR [rbp-8]
	mov	edx, DWORD PTR [rbp-28]
#APP
# 200 "../lib/hle-emulation.h" 1
	.byte 0xf3 ; mov edx,DWORD PTR [rax]
# 0 "" 2
#NO_APP
	jmp	.L49
.L48:
	mov	rdi, rax
	call	_Unwind_Resume
.LEHE2:
.L49:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2764:
	.globl	__gxx_personality_v0
	.section	.gcc_except_table,"a",@progbits
.LLSDA2764:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE2764-.LLSDACSB2764
.LLSDACSB2764:
	.uleb128 .LEHB0-.LFB2764
	.uleb128 .LEHE0-.LEHB0
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB1-.LFB2764
	.uleb128 .LEHE1-.LEHB1
	.uleb128 .L48-.LFB2764
	.uleb128 0
	.uleb128 .LEHB2-.LFB2764
	.uleb128 .LEHE2-.LEHB2
	.uleb128 0
	.uleb128 0
.LLSDACSE2764:
	.text
	.size	_Z22wait_tas_read_tas_waiti, .-_Z22wait_tas_read_tas_waiti
	.globl	mutex_checks
	.data
	.align 8
	.type	mutex_checks, @object
	.size	mutex_checks, 8
mutex_checks:
	.quad	100000
	.globl	mutex_sum
	.bss
	.align 8
	.type	mutex_sum, @object
	.size	mutex_sum, 8
mutex_sum:
	.zero	8
	.section	.rodata
	.align 8
.LC4:
	.string	"Mutex was 1 in %lld cases out of %lld\n"
	.text
	.globl	_Z11check_mutexi
	.type	_Z11check_mutexi, @function
_Z11check_mutexi:
.LFB2765:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	mov	DWORD PTR [rbp-20], edi
	mov	ecx, DWORD PTR _ZL9num_cores[rip]
	mov	eax, DWORD PTR [rbp-20]
	cdq
	idiv	ecx
	mov	eax, edx
	mov	edi, eax
	call	_Z25stick_this_thread_to_corei
	test	eax, eax
	setne	al
	test	al, al
	je	.L51
	mov	edi, OFFSET FLAT:.LC0
	call	puts
.L51:
	jmp	.L52
.L53:
#APP
# 70 "read-second_elision.cpp" 1
	nop
# 0 "" 2
#NO_APP
.L52:
	mov	eax, DWORD PTR notify[rip]
	test	eax, eax
	je	.L53
	mov	DWORD PTR [rbp-4], 0
	jmp	.L54
.L55:
	mov	eax, DWORD PTR mutex[rip]
	mov	edx, eax
	mov	rax, QWORD PTR mutex_sum[rip]
	add	rax, rdx
	mov	QWORD PTR mutex_sum[rip], rax
	add	DWORD PTR [rbp-4], 1
.L54:
	mov	eax, DWORD PTR [rbp-4]
	movsx	rdx, eax
	mov	rax, QWORD PTR mutex_checks[rip]
	cmp	rdx, rax
	jl	.L55
	mov	rdx, QWORD PTR mutex_checks[rip]
	mov	rax, QWORD PTR mutex_sum[rip]
	mov	rsi, rax
	mov	edi, OFFSET FLAT:.LC4
	mov	eax, 0
	call	printf
	mov	DWORD PTR run[rip], 0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2765:
	.size	_Z11check_mutexi, .-_Z11check_mutexi
	.globl	main
	.type	main, @function
main:
.LFB2766:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA2766
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	sub	rsp, 72
	.cfi_offset 3, -24
	mov	DWORD PTR [rbp-68], edi
	mov	QWORD PTR [rbp-80], rsi
	mov	DWORD PTR [rbp-52], 0
	lea	rdx, [rbp-52]
	lea	rax, [rbp-48]
	mov	esi, OFFSET FLAT:_Z22wait_tas_read_tas_waiti
	mov	rdi, rax
.LEHB3:
	call	_ZNSt6threadC1IRFviEIiEEEOT_DpOT0_
.LEHE3:
	mov	edi, 1000
.LEHB4:
	call	usleep
.LEHE4:
	mov	DWORD PTR [rbp-52], 2
	lea	rdx, [rbp-52]
	lea	rax, [rbp-32]
	mov	esi, OFFSET FLAT:_Z11check_mutexi
	mov	rdi, rax
.LEHB5:
	call	_ZNSt6threadC1IRFviEIiEEEOT_DpOT0_
.LEHE5:
	lea	rax, [rbp-48]
	mov	rdi, rax
.LEHB6:
	call	_ZNSt6thread4joinEv
	lea	rax, [rbp-32]
	mov	rdi, rax
	call	_ZNSt6thread4joinEv
.LEHE6:
	lea	rax, [rbp-32]
	mov	rdi, rax
	call	_ZNSt6threadD1Ev
	lea	rax, [rbp-48]
	mov	rdi, rax
	call	_ZNSt6threadD1Ev
	mov	eax, 0
	jmp	.L67
.L63:
	jmp	.L59
.L65:
	mov	rbx, rax
	jmp	.L61
.L66:
	mov	rbx, rax
	lea	rax, [rbp-32]
	mov	rdi, rax
	call	_ZNSt6threadD1Ev
	jmp	.L61
.L64:
	mov	rbx, rax
.L61:
	lea	rax, [rbp-48]
	mov	rdi, rax
	call	_ZNSt6threadD1Ev
	mov	rax, rbx
.L59:
	mov	rdi, rax
.LEHB7:
	call	_Unwind_Resume
.LEHE7:
.L67:
	add	rsp, 72
	pop	rbx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2766:
	.section	.gcc_except_table
.LLSDA2766:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE2766-.LLSDACSB2766
.LLSDACSB2766:
	.uleb128 .LEHB3-.LFB2766
	.uleb128 .LEHE3-.LEHB3
	.uleb128 .L63-.LFB2766
	.uleb128 0
	.uleb128 .LEHB4-.LFB2766
	.uleb128 .LEHE4-.LEHB4
	.uleb128 .L64-.LFB2766
	.uleb128 0
	.uleb128 .LEHB5-.LFB2766
	.uleb128 .LEHE5-.LEHB5
	.uleb128 .L65-.LFB2766
	.uleb128 0
	.uleb128 .LEHB6-.LFB2766
	.uleb128 .LEHE6-.LEHB6
	.uleb128 .L66-.LFB2766
	.uleb128 0
	.uleb128 .LEHB7-.LFB2766
	.uleb128 .LEHE7-.LEHB7
	.uleb128 0
	.uleb128 0
.LLSDACSE2766:
	.text
	.size	main, .-main
	.section	.text._ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EED2Ev,"axG",@progbits,_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EED5Ev,comdat
	.align 2
	.weak	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EED2Ev
	.type	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EED2Ev, @function
_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EED2Ev:
.LFB2824:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	rax, QWORD PTR [rax]
	test	rax, rax
	je	.L68
	mov	rax, QWORD PTR [rbp-8]
	mov	rax, QWORD PTR [rax]
	mov	rdi, rax
	call	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_releaseEv
.L68:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2824:
	.size	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EED2Ev, .-_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EED2Ev
	.weak	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EED1Ev
	.set	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EED1Ev,_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EED2Ev
	.section	.text._ZSt7forwardIRFviEEOT_RNSt16remove_referenceIS2_E4typeE,"axG",@progbits,_ZSt7forwardIRFviEEOT_RNSt16remove_referenceIS2_E4typeE,comdat
	.weak	_ZSt7forwardIRFviEEOT_RNSt16remove_referenceIS2_E4typeE
	.type	_ZSt7forwardIRFviEEOT_RNSt16remove_referenceIS2_E4typeE, @function
_ZSt7forwardIRFviEEOT_RNSt16remove_referenceIS2_E4typeE:
.LFB2829:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2829:
	.size	_ZSt7forwardIRFviEEOT_RNSt16remove_referenceIS2_E4typeE, .-_ZSt7forwardIRFviEEOT_RNSt16remove_referenceIS2_E4typeE
	.section	.text._ZSt7forwardIiEOT_RNSt16remove_referenceIS0_E4typeE,"axG",@progbits,_ZSt7forwardIiEOT_RNSt16remove_referenceIS0_E4typeE,comdat
	.weak	_ZSt7forwardIiEOT_RNSt16remove_referenceIS0_E4typeE
	.type	_ZSt7forwardIiEOT_RNSt16remove_referenceIS0_E4typeE, @function
_ZSt7forwardIiEOT_RNSt16remove_referenceIS0_E4typeE:
.LFB2830:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2830:
	.size	_ZSt7forwardIiEOT_RNSt16remove_referenceIS0_E4typeE, .-_ZSt7forwardIiEOT_RNSt16remove_referenceIS0_E4typeE
	.section	.text._ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EED2Ev,"axG",@progbits,_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EED5Ev,comdat
	.align 2
	.weak	_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EED2Ev
	.type	_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EED2Ev, @function
_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EED2Ev:
.LFB2833:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	add	rax, 8
	mov	rdi, rax
	call	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EED1Ev
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2833:
	.size	_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EED2Ev, .-_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EED2Ev
	.weak	_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EED1Ev
	.set	_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EED1Ev,_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EED2Ev
	.section	.text._ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED2Ev,"axG",@progbits,_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED5Ev,comdat
	.align 2
	.weak	_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED2Ev
	.type	_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED2Ev, @function
_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED2Ev:
.LFB2835:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EED2Ev
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2835:
	.size	_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED2Ev, .-_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED2Ev
	.weak	_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED1Ev
	.set	_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED1Ev,_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED2Ev
	.section	.text._ZNSt6threadC2IRFviEIiEEEOT_DpOT0_,"axG",@progbits,_ZNSt6threadC5IRFviEIiEEEOT_DpOT0_,comdat
	.align 2
	.weak	_ZNSt6threadC2IRFviEIiEEEOT_DpOT0_
	.type	_ZNSt6threadC2IRFviEIiEEEOT_DpOT0_, @function
_ZNSt6threadC2IRFviEIiEEEOT_DpOT0_:
.LFB2837:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA2837
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	sub	rsp, 88
	.cfi_offset 3, -24
	mov	QWORD PTR [rbp-72], rdi
	mov	QWORD PTR [rbp-80], rsi
	mov	QWORD PTR [rbp-88], rdx
	mov	rax, QWORD PTR [rbp-72]
	mov	rdi, rax
	call	_ZNSt6thread2idC1Ev
	mov	rax, QWORD PTR [rbp-88]
	mov	rdi, rax
	call	_ZSt7forwardIiEOT_RNSt16remove_referenceIS0_E4typeE
	mov	rbx, rax
	mov	rax, QWORD PTR [rbp-80]
	mov	rdi, rax
	call	_ZSt7forwardIRFviEEOT_RNSt16remove_referenceIS2_E4typeE
	mov	rcx, rax
	lea	rax, [rbp-32]
	mov	rdx, rbx
	mov	rsi, rcx
	mov	rdi, rax
.LEHB8:
	call	_ZSt13__bind_simpleIRFviEIiEENSt19_Bind_simple_helperIT_IDpT0_EE6__typeEOS3_DpOS4_
.LEHE8:
	lea	rax, [rbp-48]
	lea	rdx, [rbp-32]
	mov	rcx, QWORD PTR [rbp-72]
	mov	rsi, rcx
	mov	rdi, rax
.LEHB9:
	call	_ZNSt6thread15_M_make_routineISt12_Bind_simpleIFPFviEiEEEESt10shared_ptrINS_5_ImplIT_EEEOS8_
.LEHE9:
	lea	rdx, [rbp-48]
	lea	rax, [rbp-64]
	mov	rsi, rdx
	mov	rdi, rax
	call	_ZNSt10shared_ptrINSt6thread10_Impl_baseEEC1INS0_5_ImplISt12_Bind_simpleIFPFviEiEEEEvEEOS_IT_E
	lea	rdx, [rbp-64]
	mov	rax, QWORD PTR [rbp-72]
	mov	rsi, rdx
	mov	rdi, rax
.LEHB10:
	call	_ZNSt6thread15_M_start_threadESt10shared_ptrINS_10_Impl_baseEE
.LEHE10:
	lea	rax, [rbp-64]
	mov	rdi, rax
	call	_ZNSt10shared_ptrINSt6thread10_Impl_baseEED1Ev
	lea	rax, [rbp-48]
	mov	rdi, rax
	call	_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED1Ev
	jmp	.L83
.L82:
	mov	rbx, rax
	lea	rax, [rbp-64]
	mov	rdi, rax
	call	_ZNSt10shared_ptrINSt6thread10_Impl_baseEED1Ev
	lea	rax, [rbp-48]
	mov	rdi, rax
	call	_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED1Ev
	mov	rax, rbx
	jmp	.L80
.L81:
.L80:
	mov	rdi, rax
.LEHB11:
	call	_Unwind_Resume
.LEHE11:
.L83:
	add	rsp, 88
	pop	rbx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2837:
	.section	.gcc_except_table
.LLSDA2837:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE2837-.LLSDACSB2837
.LLSDACSB2837:
	.uleb128 .LEHB8-.LFB2837
	.uleb128 .LEHE8-.LEHB8
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB9-.LFB2837
	.uleb128 .LEHE9-.LEHB9
	.uleb128 .L81-.LFB2837
	.uleb128 0
	.uleb128 .LEHB10-.LFB2837
	.uleb128 .LEHE10-.LEHB10
	.uleb128 .L82-.LFB2837
	.uleb128 0
	.uleb128 .LEHB11-.LFB2837
	.uleb128 .LEHE11-.LEHB11
	.uleb128 0
	.uleb128 0
.LLSDACSE2837:
	.section	.text._ZNSt6threadC2IRFviEIiEEEOT_DpOT0_,"axG",@progbits,_ZNSt6threadC5IRFviEIiEEEOT_DpOT0_,comdat
	.size	_ZNSt6threadC2IRFviEIiEEEOT_DpOT0_, .-_ZNSt6threadC2IRFviEIiEEEOT_DpOT0_
	.weak	_ZNSt6threadC2IRFviEJiEEEOT_DpOT0_
	.set	_ZNSt6threadC2IRFviEJiEEEOT_DpOT0_,_ZNSt6threadC2IRFviEIiEEEOT_DpOT0_
	.weak	_ZNSt6threadC1IRFviEIiEEEOT_DpOT0_
	.set	_ZNSt6threadC1IRFviEIiEEEOT_DpOT0_,_ZNSt6threadC2IRFviEIiEEEOT_DpOT0_
	.weak	_ZNSt6threadC1IRFviEJiEEEOT_DpOT0_
	.set	_ZNSt6threadC1IRFviEJiEEEOT_DpOT0_,_ZNSt6threadC1IRFviEIiEEEOT_DpOT0_
	.section	.text._ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_releaseEv,"axG",@progbits,_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_releaseEv,comdat
	.align 2
	.weak	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_releaseEv
	.type	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_releaseEv, @function
_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_releaseEv:
.LFB2881:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	add	rax, 8
	mov	esi, -1
	mov	rdi, rax
	call	_ZN9__gnu_cxxL27__exchange_and_add_dispatchEPii
	cmp	eax, 1
	sete	al
	test	al, al
	je	.L84
	mov	rax, QWORD PTR [rbp-8]
	mov	rax, QWORD PTR [rax]
	add	rax, 16
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR [rbp-8]
	mov	rdi, rdx
	call	rax
	mov	rax, QWORD PTR [rbp-8]
	add	rax, 12
	mov	esi, -1
	mov	rdi, rax
	call	_ZN9__gnu_cxxL27__exchange_and_add_dispatchEPii
	cmp	eax, 1
	sete	al
	test	al, al
	je	.L84
	mov	rax, QWORD PTR [rbp-8]
	mov	rax, QWORD PTR [rax]
	add	rax, 24
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR [rbp-8]
	mov	rdi, rdx
	call	rax
.L84:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2881:
	.size	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_releaseEv, .-_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_releaseEv
	.section	.text._ZNSt11_Tuple_implILm1EIiEE7_M_tailERS0_,"axG",@progbits,_ZNSt11_Tuple_implILm1EIiEE7_M_tailERS0_,comdat
	.weak	_ZNSt11_Tuple_implILm1EIiEE7_M_tailERS0_
	.type	_ZNSt11_Tuple_implILm1EIiEE7_M_tailERS0_, @function
_ZNSt11_Tuple_implILm1EIiEE7_M_tailERS0_:
.LFB2886:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2886:
	.size	_ZNSt11_Tuple_implILm1EIiEE7_M_tailERS0_, .-_ZNSt11_Tuple_implILm1EIiEE7_M_tailERS0_
	.weak	_ZNSt11_Tuple_implILm1EJiEE7_M_tailERS0_
	.set	_ZNSt11_Tuple_implILm1EJiEE7_M_tailERS0_,_ZNSt11_Tuple_implILm1EIiEE7_M_tailERS0_
	.section	.text._ZSt4moveIRSt11_Tuple_implILm2EIEEEONSt16remove_referenceIT_E4typeEOS4_,"axG",@progbits,_ZSt4moveIRSt11_Tuple_implILm2EIEEEONSt16remove_referenceIT_E4typeEOS4_,comdat
	.weak	_ZSt4moveIRSt11_Tuple_implILm2EIEEEONSt16remove_referenceIT_E4typeEOS4_
	.type	_ZSt4moveIRSt11_Tuple_implILm2EIEEEONSt16remove_referenceIT_E4typeEOS4_, @function
_ZSt4moveIRSt11_Tuple_implILm2EIEEEONSt16remove_referenceIT_E4typeEOS4_:
.LFB2887:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2887:
	.size	_ZSt4moveIRSt11_Tuple_implILm2EIEEEONSt16remove_referenceIT_E4typeEOS4_, .-_ZSt4moveIRSt11_Tuple_implILm2EIEEEONSt16remove_referenceIT_E4typeEOS4_
	.weak	_ZSt4moveIRSt11_Tuple_implILm2EJEEEONSt16remove_referenceIT_E4typeEOS4_
	.set	_ZSt4moveIRSt11_Tuple_implILm2EJEEEONSt16remove_referenceIT_E4typeEOS4_,_ZSt4moveIRSt11_Tuple_implILm2EIEEEONSt16remove_referenceIT_E4typeEOS4_
	.section	.text._ZNSt10_Head_baseILm1EiLb0EE7_M_headERS0_,"axG",@progbits,_ZNSt10_Head_baseILm1EiLb0EE7_M_headERS0_,comdat
	.weak	_ZNSt10_Head_baseILm1EiLb0EE7_M_headERS0_
	.type	_ZNSt10_Head_baseILm1EiLb0EE7_M_headERS0_, @function
_ZNSt10_Head_baseILm1EiLb0EE7_M_headERS0_:
.LFB2889:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2889:
	.size	_ZNSt10_Head_baseILm1EiLb0EE7_M_headERS0_, .-_ZNSt10_Head_baseILm1EiLb0EE7_M_headERS0_
	.section	.text._ZNSt11_Tuple_implILm1EIiEE7_M_headERS0_,"axG",@progbits,_ZNSt11_Tuple_implILm1EIiEE7_M_headERS0_,comdat
	.weak	_ZNSt11_Tuple_implILm1EIiEE7_M_headERS0_
	.type	_ZNSt11_Tuple_implILm1EIiEE7_M_headERS0_, @function
_ZNSt11_Tuple_implILm1EIiEE7_M_headERS0_:
.LFB2888:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZNSt10_Head_baseILm1EiLb0EE7_M_headERS0_
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2888:
	.size	_ZNSt11_Tuple_implILm1EIiEE7_M_headERS0_, .-_ZNSt11_Tuple_implILm1EIiEE7_M_headERS0_
	.weak	_ZNSt11_Tuple_implILm1EJiEE7_M_headERS0_
	.set	_ZNSt11_Tuple_implILm1EJiEE7_M_headERS0_,_ZNSt11_Tuple_implILm1EIiEE7_M_headERS0_
	.section	.text._ZNSt10_Head_baseILm1EiLb0EEC2IivEEOT_,"axG",@progbits,_ZNSt10_Head_baseILm1EiLb0EEC5IivEEOT_,comdat
	.align 2
	.weak	_ZNSt10_Head_baseILm1EiLb0EEC2IivEEOT_
	.type	_ZNSt10_Head_baseILm1EiLb0EEC2IivEEOT_, @function
_ZNSt10_Head_baseILm1EiLb0EEC2IivEEOT_:
.LFB2891:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rax, QWORD PTR [rbp-16]
	mov	rdi, rax
	call	_ZSt7forwardIiEOT_RNSt16remove_referenceIS0_E4typeE
	mov	edx, DWORD PTR [rax]
	mov	rax, QWORD PTR [rbp-8]
	mov	DWORD PTR [rax], edx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2891:
	.size	_ZNSt10_Head_baseILm1EiLb0EEC2IivEEOT_, .-_ZNSt10_Head_baseILm1EiLb0EEC2IivEEOT_
	.weak	_ZNSt10_Head_baseILm1EiLb0EEC1IivEEOT_
	.set	_ZNSt10_Head_baseILm1EiLb0EEC1IivEEOT_,_ZNSt10_Head_baseILm1EiLb0EEC2IivEEOT_
	.section	.text._ZNSt11_Tuple_implILm1EIiEEC2EOS0_,"axG",@progbits,_ZNSt11_Tuple_implILm1EIiEEC5EOS0_,comdat
	.align 2
	.weak	_ZNSt11_Tuple_implILm1EIiEEC2EOS0_
	.type	_ZNSt11_Tuple_implILm1EIiEEC2EOS0_, @function
_ZNSt11_Tuple_implILm1EIiEEC2EOS0_:
.LFB2893:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rax, QWORD PTR [rbp-16]
	mov	rdi, rax
	call	_ZNSt11_Tuple_implILm1EIiEE7_M_tailERS0_
	mov	rdi, rax
	call	_ZSt4moveIRSt11_Tuple_implILm2EIEEEONSt16remove_referenceIT_E4typeEOS4_
	mov	rax, QWORD PTR [rbp-16]
	mov	rdi, rax
	call	_ZNSt11_Tuple_implILm1EIiEE7_M_headERS0_
	mov	rdi, rax
	call	_ZSt7forwardIiEOT_RNSt16remove_referenceIS0_E4typeE
	mov	rdx, rax
	mov	rax, QWORD PTR [rbp-8]
	mov	rsi, rdx
	mov	rdi, rax
	call	_ZNSt10_Head_baseILm1EiLb0EEC2IivEEOT_
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2893:
	.size	_ZNSt11_Tuple_implILm1EIiEEC2EOS0_, .-_ZNSt11_Tuple_implILm1EIiEEC2EOS0_
	.weak	_ZNSt11_Tuple_implILm1EJiEEC2EOS0_
	.set	_ZNSt11_Tuple_implILm1EJiEEC2EOS0_,_ZNSt11_Tuple_implILm1EIiEEC2EOS0_
	.weak	_ZNSt11_Tuple_implILm1EIiEEC1EOS0_
	.set	_ZNSt11_Tuple_implILm1EIiEEC1EOS0_,_ZNSt11_Tuple_implILm1EIiEEC2EOS0_
	.weak	_ZNSt11_Tuple_implILm1EJiEEC1EOS0_
	.set	_ZNSt11_Tuple_implILm1EJiEEC1EOS0_,_ZNSt11_Tuple_implILm1EIiEEC1EOS0_
	.section	.text._ZNSt11_Tuple_implILm0EIPFviEiEE7_M_tailERS2_,"axG",@progbits,_ZNSt11_Tuple_implILm0EIPFviEiEE7_M_tailERS2_,comdat
	.weak	_ZNSt11_Tuple_implILm0EIPFviEiEE7_M_tailERS2_
	.type	_ZNSt11_Tuple_implILm0EIPFviEiEE7_M_tailERS2_, @function
_ZNSt11_Tuple_implILm0EIPFviEiEE7_M_tailERS2_:
.LFB2898:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2898:
	.size	_ZNSt11_Tuple_implILm0EIPFviEiEE7_M_tailERS2_, .-_ZNSt11_Tuple_implILm0EIPFviEiEE7_M_tailERS2_
	.weak	_ZNSt11_Tuple_implILm0EJPFviEiEE7_M_tailERS2_
	.set	_ZNSt11_Tuple_implILm0EJPFviEiEE7_M_tailERS2_,_ZNSt11_Tuple_implILm0EIPFviEiEE7_M_tailERS2_
	.section	.text._ZSt4moveIRSt11_Tuple_implILm1EIiEEEONSt16remove_referenceIT_E4typeEOS4_,"axG",@progbits,_ZSt4moveIRSt11_Tuple_implILm1EIiEEEONSt16remove_referenceIT_E4typeEOS4_,comdat
	.weak	_ZSt4moveIRSt11_Tuple_implILm1EIiEEEONSt16remove_referenceIT_E4typeEOS4_
	.type	_ZSt4moveIRSt11_Tuple_implILm1EIiEEEONSt16remove_referenceIT_E4typeEOS4_, @function
_ZSt4moveIRSt11_Tuple_implILm1EIiEEEONSt16remove_referenceIT_E4typeEOS4_:
.LFB2899:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2899:
	.size	_ZSt4moveIRSt11_Tuple_implILm1EIiEEEONSt16remove_referenceIT_E4typeEOS4_, .-_ZSt4moveIRSt11_Tuple_implILm1EIiEEEONSt16remove_referenceIT_E4typeEOS4_
	.weak	_ZSt4moveIRSt11_Tuple_implILm1EJiEEEONSt16remove_referenceIT_E4typeEOS4_
	.set	_ZSt4moveIRSt11_Tuple_implILm1EJiEEEONSt16remove_referenceIT_E4typeEOS4_,_ZSt4moveIRSt11_Tuple_implILm1EIiEEEONSt16remove_referenceIT_E4typeEOS4_
	.section	.text._ZNSt10_Head_baseILm0EPFviELb0EE7_M_headERS2_,"axG",@progbits,_ZNSt10_Head_baseILm0EPFviELb0EE7_M_headERS2_,comdat
	.weak	_ZNSt10_Head_baseILm0EPFviELb0EE7_M_headERS2_
	.type	_ZNSt10_Head_baseILm0EPFviELb0EE7_M_headERS2_, @function
_ZNSt10_Head_baseILm0EPFviELb0EE7_M_headERS2_:
.LFB2901:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2901:
	.size	_ZNSt10_Head_baseILm0EPFviELb0EE7_M_headERS2_, .-_ZNSt10_Head_baseILm0EPFviELb0EE7_M_headERS2_
	.section	.text._ZNSt11_Tuple_implILm0EIPFviEiEE7_M_headERS2_,"axG",@progbits,_ZNSt11_Tuple_implILm0EIPFviEiEE7_M_headERS2_,comdat
	.weak	_ZNSt11_Tuple_implILm0EIPFviEiEE7_M_headERS2_
	.type	_ZNSt11_Tuple_implILm0EIPFviEiEE7_M_headERS2_, @function
_ZNSt11_Tuple_implILm0EIPFviEiEE7_M_headERS2_:
.LFB2900:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	add	rax, 8
	mov	rdi, rax
	call	_ZNSt10_Head_baseILm0EPFviELb0EE7_M_headERS2_
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2900:
	.size	_ZNSt11_Tuple_implILm0EIPFviEiEE7_M_headERS2_, .-_ZNSt11_Tuple_implILm0EIPFviEiEE7_M_headERS2_
	.weak	_ZNSt11_Tuple_implILm0EJPFviEiEE7_M_headERS2_
	.set	_ZNSt11_Tuple_implILm0EJPFviEiEE7_M_headERS2_,_ZNSt11_Tuple_implILm0EIPFviEiEE7_M_headERS2_
	.section	.text._ZSt7forwardIPFviEEOT_RNSt16remove_referenceIS2_E4typeE,"axG",@progbits,_ZSt7forwardIPFviEEOT_RNSt16remove_referenceIS2_E4typeE,comdat
	.weak	_ZSt7forwardIPFviEEOT_RNSt16remove_referenceIS2_E4typeE
	.type	_ZSt7forwardIPFviEEOT_RNSt16remove_referenceIS2_E4typeE, @function
_ZSt7forwardIPFviEEOT_RNSt16remove_referenceIS2_E4typeE:
.LFB2902:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2902:
	.size	_ZSt7forwardIPFviEEOT_RNSt16remove_referenceIS2_E4typeE, .-_ZSt7forwardIPFviEEOT_RNSt16remove_referenceIS2_E4typeE
	.section	.text._ZNSt10_Head_baseILm0EPFviELb0EEC2IS1_vEEOT_,"axG",@progbits,_ZNSt10_Head_baseILm0EPFviELb0EEC5IS1_vEEOT_,comdat
	.align 2
	.weak	_ZNSt10_Head_baseILm0EPFviELb0EEC2IS1_vEEOT_
	.type	_ZNSt10_Head_baseILm0EPFviELb0EEC2IS1_vEEOT_, @function
_ZNSt10_Head_baseILm0EPFviELb0EEC2IS1_vEEOT_:
.LFB2904:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rax, QWORD PTR [rbp-16]
	mov	rdi, rax
	call	_ZSt7forwardIPFviEEOT_RNSt16remove_referenceIS2_E4typeE
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR [rbp-8]
	mov	QWORD PTR [rax], rdx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2904:
	.size	_ZNSt10_Head_baseILm0EPFviELb0EEC2IS1_vEEOT_, .-_ZNSt10_Head_baseILm0EPFviELb0EEC2IS1_vEEOT_
	.weak	_ZNSt10_Head_baseILm0EPFviELb0EEC1IS1_vEEOT_
	.set	_ZNSt10_Head_baseILm0EPFviELb0EEC1IS1_vEEOT_,_ZNSt10_Head_baseILm0EPFviELb0EEC2IS1_vEEOT_
	.section	.text._ZNSt11_Tuple_implILm0EIPFviEiEEC2EOS2_,"axG",@progbits,_ZNSt11_Tuple_implILm0EIPFviEiEEC5EOS2_,comdat
	.align 2
	.weak	_ZNSt11_Tuple_implILm0EIPFviEiEEC2EOS2_
	.type	_ZNSt11_Tuple_implILm0EIPFviEiEEC2EOS2_, @function
_ZNSt11_Tuple_implILm0EIPFviEiEEC2EOS2_:
.LFB2906:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rax, QWORD PTR [rbp-16]
	mov	rdi, rax
	call	_ZNSt11_Tuple_implILm0EIPFviEiEE7_M_tailERS2_
	mov	rdi, rax
	call	_ZSt4moveIRSt11_Tuple_implILm1EIiEEEONSt16remove_referenceIT_E4typeEOS4_
	mov	rdx, rax
	mov	rax, QWORD PTR [rbp-8]
	mov	rsi, rdx
	mov	rdi, rax
	call	_ZNSt11_Tuple_implILm1EIiEEC2EOS0_
	mov	rax, QWORD PTR [rbp-16]
	mov	rdi, rax
	call	_ZNSt11_Tuple_implILm0EIPFviEiEE7_M_headERS2_
	mov	rdi, rax
	call	_ZSt7forwardIPFviEEOT_RNSt16remove_referenceIS2_E4typeE
	mov	rdx, QWORD PTR [rbp-8]
	add	rdx, 8
	mov	rsi, rax
	mov	rdi, rdx
	call	_ZNSt10_Head_baseILm0EPFviELb0EEC2IS1_vEEOT_
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2906:
	.size	_ZNSt11_Tuple_implILm0EIPFviEiEEC2EOS2_, .-_ZNSt11_Tuple_implILm0EIPFviEiEEC2EOS2_
	.weak	_ZNSt11_Tuple_implILm0EJPFviEiEEC2EOS2_
	.set	_ZNSt11_Tuple_implILm0EJPFviEiEEC2EOS2_,_ZNSt11_Tuple_implILm0EIPFviEiEEC2EOS2_
	.weak	_ZNSt11_Tuple_implILm0EIPFviEiEEC1EOS2_
	.set	_ZNSt11_Tuple_implILm0EIPFviEiEEC1EOS2_,_ZNSt11_Tuple_implILm0EIPFviEiEEC2EOS2_
	.weak	_ZNSt11_Tuple_implILm0EJPFviEiEEC1EOS2_
	.set	_ZNSt11_Tuple_implILm0EJPFviEiEEC1EOS2_,_ZNSt11_Tuple_implILm0EIPFviEiEEC1EOS2_
	.section	.text._ZNSt5tupleIIPFviEiEEC2EOS2_,"axG",@progbits,_ZNSt5tupleIIPFviEiEEC5EOS2_,comdat
	.align 2
	.weak	_ZNSt5tupleIIPFviEiEEC2EOS2_
	.type	_ZNSt5tupleIIPFviEiEEC2EOS2_, @function
_ZNSt5tupleIIPFviEiEEC2EOS2_:
.LFB2908:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rdx, QWORD PTR [rbp-16]
	mov	rax, QWORD PTR [rbp-8]
	mov	rsi, rdx
	mov	rdi, rax
	call	_ZNSt11_Tuple_implILm0EIPFviEiEEC2EOS2_
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2908:
	.size	_ZNSt5tupleIIPFviEiEEC2EOS2_, .-_ZNSt5tupleIIPFviEiEEC2EOS2_
	.weak	_ZNSt5tupleIJPFviEiEEC2EOS2_
	.set	_ZNSt5tupleIJPFviEiEEC2EOS2_,_ZNSt5tupleIIPFviEiEEC2EOS2_
	.weak	_ZNSt5tupleIIPFviEiEEC1EOS2_
	.set	_ZNSt5tupleIIPFviEiEEC1EOS2_,_ZNSt5tupleIIPFviEiEEC2EOS2_
	.weak	_ZNSt5tupleIJPFviEiEEC1EOS2_
	.set	_ZNSt5tupleIJPFviEiEEC1EOS2_,_ZNSt5tupleIIPFviEiEEC1EOS2_
	.section	.text._ZNSt12_Bind_simpleIFPFviEiEEC2EOS3_,"axG",@progbits,_ZNSt12_Bind_simpleIFPFviEiEEC5EOS3_,comdat
	.align 2
	.weak	_ZNSt12_Bind_simpleIFPFviEiEEC2EOS3_
	.type	_ZNSt12_Bind_simpleIFPFviEiEEC2EOS3_, @function
_ZNSt12_Bind_simpleIFPFviEiEEC2EOS3_:
.LFB2910:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rdx, QWORD PTR [rbp-16]
	mov	rax, QWORD PTR [rbp-8]
	mov	rsi, rdx
	mov	rdi, rax
	call	_ZNSt5tupleIIPFviEiEEC1EOS2_
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2910:
	.size	_ZNSt12_Bind_simpleIFPFviEiEEC2EOS3_, .-_ZNSt12_Bind_simpleIFPFviEiEEC2EOS3_
	.weak	_ZNSt12_Bind_simpleIFPFviEiEEC1EOS3_
	.set	_ZNSt12_Bind_simpleIFPFviEiEEC1EOS3_,_ZNSt12_Bind_simpleIFPFviEiEEC2EOS3_
	.section	.text._ZSt13__bind_simpleIRFviEIiEENSt19_Bind_simple_helperIT_IDpT0_EE6__typeEOS3_DpOS4_,"axG",@progbits,_ZSt13__bind_simpleIRFviEIiEENSt19_Bind_simple_helperIT_IDpT0_EE6__typeEOS3_DpOS4_,comdat
	.weak	_ZSt13__bind_simpleIRFviEIiEENSt19_Bind_simple_helperIT_IDpT0_EE6__typeEOS3_DpOS4_
	.type	_ZSt13__bind_simpleIRFviEIiEENSt19_Bind_simple_helperIT_IDpT0_EE6__typeEOS3_DpOS4_, @function
_ZSt13__bind_simpleIRFviEIiEENSt19_Bind_simple_helperIT_IDpT0_EE6__typeEOS3_DpOS4_:
.LFB2884:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	sub	rsp, 56
	.cfi_offset 3, -24
	mov	QWORD PTR [rbp-40], rdi
	mov	QWORD PTR [rbp-48], rsi
	mov	QWORD PTR [rbp-56], rdx
	mov	rax, QWORD PTR [rbp-56]
	mov	rdi, rax
	call	_ZSt7forwardIiEOT_RNSt16remove_referenceIS0_E4typeE
	mov	rbx, rax
	mov	rax, QWORD PTR [rbp-48]
	mov	rdi, rax
	call	_ZSt7forwardIRFviEEOT_RNSt16remove_referenceIS2_E4typeE
	mov	QWORD PTR [rbp-24], rax
	lea	rax, [rbp-24]
	mov	rdi, rax
	call	_ZNSt26_Maybe_wrap_member_pointerIPFviEE9__do_wrapEOS1_
	mov	rcx, rax
	mov	rax, QWORD PTR [rbp-40]
	mov	rdx, rbx
	mov	rsi, rcx
	mov	rdi, rax
	call	_ZNSt12_Bind_simpleIFPFviEiEEC1IIiEvEEOS1_DpOT_
	mov	rax, QWORD PTR [rbp-40]
	add	rsp, 56
	pop	rbx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2884:
	.size	_ZSt13__bind_simpleIRFviEIiEENSt19_Bind_simple_helperIT_IDpT0_EE6__typeEOS3_DpOS4_, .-_ZSt13__bind_simpleIRFviEIiEENSt19_Bind_simple_helperIT_IDpT0_EE6__typeEOS3_DpOS4_
	.weak	_ZSt13__bind_simpleIRFviEJiEENSt19_Bind_simple_helperIT_JDpT0_EE6__typeEOS3_DpOS4_
	.set	_ZSt13__bind_simpleIRFviEJiEENSt19_Bind_simple_helperIT_JDpT0_EE6__typeEOS3_DpOS4_,_ZSt13__bind_simpleIRFviEIiEENSt19_Bind_simple_helperIT_IDpT0_EE6__typeEOS3_DpOS4_
	.section	.text._ZSt7forwardISt12_Bind_simpleIFPFviEiEEEOT_RNSt16remove_referenceIS5_E4typeE,"axG",@progbits,_ZSt7forwardISt12_Bind_simpleIFPFviEiEEEOT_RNSt16remove_referenceIS5_E4typeE,comdat
	.weak	_ZSt7forwardISt12_Bind_simpleIFPFviEiEEEOT_RNSt16remove_referenceIS5_E4typeE
	.type	_ZSt7forwardISt12_Bind_simpleIFPFviEiEEEOT_RNSt16remove_referenceIS5_E4typeE, @function
_ZSt7forwardISt12_Bind_simpleIFPFviEiEEEOT_RNSt16remove_referenceIS5_E4typeE:
.LFB2913:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2913:
	.size	_ZSt7forwardISt12_Bind_simpleIFPFviEiEEEOT_RNSt16remove_referenceIS5_E4typeE, .-_ZSt7forwardISt12_Bind_simpleIFPFviEiEEEOT_RNSt16remove_referenceIS5_E4typeE
	.section	.text._ZNSt6thread15_M_make_routineISt12_Bind_simpleIFPFviEiEEEESt10shared_ptrINS_5_ImplIT_EEEOS8_,"axG",@progbits,_ZNSt6thread15_M_make_routineISt12_Bind_simpleIFPFviEiEEEESt10shared_ptrINS_5_ImplIT_EEEOS8_,comdat
	.align 2
	.weak	_ZNSt6thread15_M_make_routineISt12_Bind_simpleIFPFviEiEEEESt10shared_ptrINS_5_ImplIT_EEEOS8_
	.type	_ZNSt6thread15_M_make_routineISt12_Bind_simpleIFPFviEiEEEESt10shared_ptrINS_5_ImplIT_EEEOS8_, @function
_ZNSt6thread15_M_make_routineISt12_Bind_simpleIFPFviEiEEEESt10shared_ptrINS_5_ImplIT_EEEOS8_:
.LFB2912:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	QWORD PTR [rbp-24], rdx
	mov	rax, QWORD PTR [rbp-24]
	mov	rdi, rax
	call	_ZSt7forwardISt12_Bind_simpleIFPFviEiEEEOT_RNSt16remove_referenceIS5_E4typeE
	mov	rdx, rax
	mov	rax, QWORD PTR [rbp-8]
	mov	rsi, rdx
	mov	rdi, rax
	call	_ZSt11make_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEIS6_EESt10shared_ptrIT_EDpOT0_
	mov	rax, QWORD PTR [rbp-8]
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2912:
	.size	_ZNSt6thread15_M_make_routineISt12_Bind_simpleIFPFviEiEEEESt10shared_ptrINS_5_ImplIT_EEEOS8_, .-_ZNSt6thread15_M_make_routineISt12_Bind_simpleIFPFviEiEEEESt10shared_ptrINS_5_ImplIT_EEEOS8_
	.section	.text._ZSt4moveIRSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEONSt16remove_referenceIT_E4typeEOSC_,"axG",@progbits,_ZSt4moveIRSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEONSt16remove_referenceIT_E4typeEOSC_,comdat
	.weak	_ZSt4moveIRSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEONSt16remove_referenceIT_E4typeEOSC_
	.type	_ZSt4moveIRSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEONSt16remove_referenceIT_E4typeEOSC_, @function
_ZSt4moveIRSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEONSt16remove_referenceIT_E4typeEOSC_:
.LFB2915:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2915:
	.size	_ZSt4moveIRSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEONSt16remove_referenceIT_E4typeEOSC_, .-_ZSt4moveIRSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEONSt16remove_referenceIT_E4typeEOSC_
	.section	.text._ZNSt10shared_ptrINSt6thread10_Impl_baseEEC2INS0_5_ImplISt12_Bind_simpleIFPFviEiEEEEvEEOS_IT_E,"axG",@progbits,_ZNSt10shared_ptrINSt6thread10_Impl_baseEEC5INS0_5_ImplISt12_Bind_simpleIFPFviEiEEEEvEEOS_IT_E,comdat
	.align 2
	.weak	_ZNSt10shared_ptrINSt6thread10_Impl_baseEEC2INS0_5_ImplISt12_Bind_simpleIFPFviEiEEEEvEEOS_IT_E
	.type	_ZNSt10shared_ptrINSt6thread10_Impl_baseEEC2INS0_5_ImplISt12_Bind_simpleIFPFviEiEEEEvEEOS_IT_E, @function
_ZNSt10shared_ptrINSt6thread10_Impl_baseEEC2INS0_5_ImplISt12_Bind_simpleIFPFviEiEEEEvEEOS_IT_E:
.LFB2916:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rax, QWORD PTR [rbp-16]
	mov	rdi, rax
	call	_ZSt4moveIRSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEONSt16remove_referenceIT_E4typeEOSC_
	mov	rdx, rax
	mov	rax, QWORD PTR [rbp-8]
	mov	rsi, rdx
	mov	rdi, rax
	call	_ZNSt12__shared_ptrINSt6thread10_Impl_baseELN9__gnu_cxx12_Lock_policyE2EEC2INS0_5_ImplISt12_Bind_simpleIFPFviEiEEEEvEEOS_IT_LS3_2EE
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2916:
	.size	_ZNSt10shared_ptrINSt6thread10_Impl_baseEEC2INS0_5_ImplISt12_Bind_simpleIFPFviEiEEEEvEEOS_IT_E, .-_ZNSt10shared_ptrINSt6thread10_Impl_baseEEC2INS0_5_ImplISt12_Bind_simpleIFPFviEiEEEEvEEOS_IT_E
	.weak	_ZNSt10shared_ptrINSt6thread10_Impl_baseEEC1INS0_5_ImplISt12_Bind_simpleIFPFviEiEEEEvEEOS_IT_E
	.set	_ZNSt10shared_ptrINSt6thread10_Impl_baseEEC1INS0_5_ImplISt12_Bind_simpleIFPFviEiEEEEvEEOS_IT_E,_ZNSt10shared_ptrINSt6thread10_Impl_baseEEC2INS0_5_ImplISt12_Bind_simpleIFPFviEiEEEEvEEOS_IT_E
	.section	.text._ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv,"axG",@progbits,_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv,comdat
	.align 2
	.weak	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv
	.type	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv, @function
_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv:
.LFB2950:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	cmp	QWORD PTR [rbp-8], 0
	je	.L119
	mov	rax, QWORD PTR [rbp-8]
	mov	rax, QWORD PTR [rax]
	add	rax, 8
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR [rbp-8]
	mov	rdi, rdx
	call	rax
.L119:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2950:
	.size	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv, .-_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv
	.section	.text._ZNSt26_Maybe_wrap_member_pointerIPFviEE9__do_wrapEOS1_,"axG",@progbits,_ZNSt26_Maybe_wrap_member_pointerIPFviEE9__do_wrapEOS1_,comdat
	.weak	_ZNSt26_Maybe_wrap_member_pointerIPFviEE9__do_wrapEOS1_
	.type	_ZNSt26_Maybe_wrap_member_pointerIPFviEE9__do_wrapEOS1_, @function
_ZNSt26_Maybe_wrap_member_pointerIPFviEE9__do_wrapEOS1_:
.LFB2952:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2952:
	.size	_ZNSt26_Maybe_wrap_member_pointerIPFviEE9__do_wrapEOS1_, .-_ZNSt26_Maybe_wrap_member_pointerIPFviEE9__do_wrapEOS1_
	.section	.text._ZSt4moveIRPFviEEONSt16remove_referenceIT_E4typeEOS4_,"axG",@progbits,_ZSt4moveIRPFviEEONSt16remove_referenceIT_E4typeEOS4_,comdat
	.weak	_ZSt4moveIRPFviEEONSt16remove_referenceIT_E4typeEOS4_
	.type	_ZSt4moveIRPFviEEONSt16remove_referenceIT_E4typeEOS4_, @function
_ZSt4moveIRPFviEEONSt16remove_referenceIT_E4typeEOS4_:
.LFB2954:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2954:
	.size	_ZSt4moveIRPFviEEONSt16remove_referenceIT_E4typeEOS4_, .-_ZSt4moveIRPFviEEONSt16remove_referenceIT_E4typeEOS4_
	.section	.text._ZNSt11_Tuple_implILm2EIEEC2Ev,"axG",@progbits,_ZNSt11_Tuple_implILm2EIEEC5Ev,comdat
	.align 2
	.weak	_ZNSt11_Tuple_implILm2EIEEC2Ev
	.type	_ZNSt11_Tuple_implILm2EIEEC2Ev, @function
_ZNSt11_Tuple_implILm2EIEEC2Ev:
.LFB2959:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2959:
	.size	_ZNSt11_Tuple_implILm2EIEEC2Ev, .-_ZNSt11_Tuple_implILm2EIEEC2Ev
	.weak	_ZNSt11_Tuple_implILm2EJEEC2Ev
	.set	_ZNSt11_Tuple_implILm2EJEEC2Ev,_ZNSt11_Tuple_implILm2EIEEC2Ev
	.weak	_ZNSt11_Tuple_implILm2EIEEC1Ev
	.set	_ZNSt11_Tuple_implILm2EIEEC1Ev,_ZNSt11_Tuple_implILm2EIEEC2Ev
	.weak	_ZNSt11_Tuple_implILm2EJEEC1Ev
	.set	_ZNSt11_Tuple_implILm2EJEEC1Ev,_ZNSt11_Tuple_implILm2EIEEC1Ev
	.section	.text._ZNSt11_Tuple_implILm1EIiEEC2IiIEvEEOT_DpOT0_,"axG",@progbits,_ZNSt11_Tuple_implILm1EIiEEC5IiIEvEEOT_DpOT0_,comdat
	.align 2
	.weak	_ZNSt11_Tuple_implILm1EIiEEC2IiIEvEEOT_DpOT0_
	.type	_ZNSt11_Tuple_implILm1EIiEEC2IiIEvEEOT_DpOT0_, @function
_ZNSt11_Tuple_implILm1EIiEEC2IiIEvEEOT_DpOT0_:
.LFB2961:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZNSt11_Tuple_implILm2EIEEC2Ev
	mov	rax, QWORD PTR [rbp-16]
	mov	rdi, rax
	call	_ZSt7forwardIiEOT_RNSt16remove_referenceIS0_E4typeE
	mov	rdx, rax
	mov	rax, QWORD PTR [rbp-8]
	mov	rsi, rdx
	mov	rdi, rax
	call	_ZNSt10_Head_baseILm1EiLb0EEC2IivEEOT_
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2961:
	.size	_ZNSt11_Tuple_implILm1EIiEEC2IiIEvEEOT_DpOT0_, .-_ZNSt11_Tuple_implILm1EIiEEC2IiIEvEEOT_DpOT0_
	.weak	_ZNSt11_Tuple_implILm1EJiEEC2IiJEvEEOT_DpOT0_
	.set	_ZNSt11_Tuple_implILm1EJiEEC2IiJEvEEOT_DpOT0_,_ZNSt11_Tuple_implILm1EIiEEC2IiIEvEEOT_DpOT0_
	.weak	_ZNSt11_Tuple_implILm1EIiEEC1IiIEvEEOT_DpOT0_
	.set	_ZNSt11_Tuple_implILm1EIiEEC1IiIEvEEOT_DpOT0_,_ZNSt11_Tuple_implILm1EIiEEC2IiIEvEEOT_DpOT0_
	.weak	_ZNSt11_Tuple_implILm1EJiEEC1IiJEvEEOT_DpOT0_
	.set	_ZNSt11_Tuple_implILm1EJiEEC1IiJEvEEOT_DpOT0_,_ZNSt11_Tuple_implILm1EIiEEC1IiIEvEEOT_DpOT0_
	.section	.text._ZNSt11_Tuple_implILm0EIPFviEiEEC2IS1_IiEvEEOT_DpOT0_,"axG",@progbits,_ZNSt11_Tuple_implILm0EIPFviEiEEC5IS1_IiEvEEOT_DpOT0_,comdat
	.align 2
	.weak	_ZNSt11_Tuple_implILm0EIPFviEiEEC2IS1_IiEvEEOT_DpOT0_
	.type	_ZNSt11_Tuple_implILm0EIPFviEiEEC2IS1_IiEvEEOT_DpOT0_, @function
_ZNSt11_Tuple_implILm0EIPFviEiEEC2IS1_IiEvEEOT_DpOT0_:
.LFB2963:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	QWORD PTR [rbp-24], rdx
	mov	rax, QWORD PTR [rbp-24]
	mov	rdi, rax
	call	_ZSt7forwardIiEOT_RNSt16remove_referenceIS0_E4typeE
	mov	rdx, rax
	mov	rax, QWORD PTR [rbp-8]
	mov	rsi, rdx
	mov	rdi, rax
	call	_ZNSt11_Tuple_implILm1EIiEEC2IiIEvEEOT_DpOT0_
	mov	rax, QWORD PTR [rbp-16]
	mov	rdi, rax
	call	_ZSt7forwardIPFviEEOT_RNSt16remove_referenceIS2_E4typeE
	mov	rdx, QWORD PTR [rbp-8]
	add	rdx, 8
	mov	rsi, rax
	mov	rdi, rdx
	call	_ZNSt10_Head_baseILm0EPFviELb0EEC2IS1_vEEOT_
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2963:
	.size	_ZNSt11_Tuple_implILm0EIPFviEiEEC2IS1_IiEvEEOT_DpOT0_, .-_ZNSt11_Tuple_implILm0EIPFviEiEEC2IS1_IiEvEEOT_DpOT0_
	.weak	_ZNSt11_Tuple_implILm0EJPFviEiEEC2IS1_JiEvEEOT_DpOT0_
	.set	_ZNSt11_Tuple_implILm0EJPFviEiEEC2IS1_JiEvEEOT_DpOT0_,_ZNSt11_Tuple_implILm0EIPFviEiEEC2IS1_IiEvEEOT_DpOT0_
	.weak	_ZNSt11_Tuple_implILm0EIPFviEiEEC1IS1_IiEvEEOT_DpOT0_
	.set	_ZNSt11_Tuple_implILm0EIPFviEiEEC1IS1_IiEvEEOT_DpOT0_,_ZNSt11_Tuple_implILm0EIPFviEiEEC2IS1_IiEvEEOT_DpOT0_
	.weak	_ZNSt11_Tuple_implILm0EJPFviEiEEC1IS1_JiEvEEOT_DpOT0_
	.set	_ZNSt11_Tuple_implILm0EJPFviEiEEC1IS1_JiEvEEOT_DpOT0_,_ZNSt11_Tuple_implILm0EIPFviEiEEC1IS1_IiEvEEOT_DpOT0_
	.section	.text._ZNSt5tupleIIPFviEiEEC2IS1_ivEEOT_OT0_,"axG",@progbits,_ZNSt5tupleIIPFviEiEEC5IS1_ivEEOT_OT0_,comdat
	.align 2
	.weak	_ZNSt5tupleIIPFviEiEEC2IS1_ivEEOT_OT0_
	.type	_ZNSt5tupleIIPFviEiEEC2IS1_ivEEOT_OT0_, @function
_ZNSt5tupleIIPFviEiEEC2IS1_ivEEOT_OT0_:
.LFB2965:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	sub	rsp, 40
	.cfi_offset 3, -24
	mov	QWORD PTR [rbp-24], rdi
	mov	QWORD PTR [rbp-32], rsi
	mov	QWORD PTR [rbp-40], rdx
	mov	rax, QWORD PTR [rbp-40]
	mov	rdi, rax
	call	_ZSt7forwardIiEOT_RNSt16remove_referenceIS0_E4typeE
	mov	rbx, rax
	mov	rax, QWORD PTR [rbp-32]
	mov	rdi, rax
	call	_ZSt7forwardIPFviEEOT_RNSt16remove_referenceIS2_E4typeE
	mov	rcx, rax
	mov	rax, QWORD PTR [rbp-24]
	mov	rdx, rbx
	mov	rsi, rcx
	mov	rdi, rax
	call	_ZNSt11_Tuple_implILm0EIPFviEiEEC2IS1_IiEvEEOT_DpOT0_
	add	rsp, 40
	pop	rbx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2965:
	.size	_ZNSt5tupleIIPFviEiEEC2IS1_ivEEOT_OT0_, .-_ZNSt5tupleIIPFviEiEEC2IS1_ivEEOT_OT0_
	.weak	_ZNSt5tupleIJPFviEiEEC2IS1_ivEEOT_OT0_
	.set	_ZNSt5tupleIJPFviEiEEC2IS1_ivEEOT_OT0_,_ZNSt5tupleIIPFviEiEEC2IS1_ivEEOT_OT0_
	.weak	_ZNSt5tupleIIPFviEiEEC1IS1_ivEEOT_OT0_
	.set	_ZNSt5tupleIIPFviEiEEC1IS1_ivEEOT_OT0_,_ZNSt5tupleIIPFviEiEEC2IS1_ivEEOT_OT0_
	.weak	_ZNSt5tupleIJPFviEiEEC1IS1_ivEEOT_OT0_
	.set	_ZNSt5tupleIJPFviEiEEC1IS1_ivEEOT_OT0_,_ZNSt5tupleIIPFviEiEEC1IS1_ivEEOT_OT0_
	.section	.text._ZNSt12_Bind_simpleIFPFviEiEEC2IIiEvEEOS1_DpOT_,"axG",@progbits,_ZNSt12_Bind_simpleIFPFviEiEEC5IIiEvEEOS1_DpOT_,comdat
	.align 2
	.weak	_ZNSt12_Bind_simpleIFPFviEiEEC2IIiEvEEOS1_DpOT_
	.type	_ZNSt12_Bind_simpleIFPFviEiEEC2IIiEvEEOS1_DpOT_, @function
_ZNSt12_Bind_simpleIFPFviEiEEC2IIiEvEEOS1_DpOT_:
.LFB2967:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	sub	rsp, 40
	.cfi_offset 3, -24
	mov	QWORD PTR [rbp-24], rdi
	mov	QWORD PTR [rbp-32], rsi
	mov	QWORD PTR [rbp-40], rdx
	mov	rax, QWORD PTR [rbp-40]
	mov	rdi, rax
	call	_ZSt7forwardIiEOT_RNSt16remove_referenceIS0_E4typeE
	mov	rbx, rax
	mov	rax, QWORD PTR [rbp-32]
	mov	rdi, rax
	call	_ZSt4moveIRPFviEEONSt16remove_referenceIT_E4typeEOS4_
	mov	rcx, rax
	mov	rax, QWORD PTR [rbp-24]
	mov	rdx, rbx
	mov	rsi, rcx
	mov	rdi, rax
	call	_ZNSt5tupleIIPFviEiEEC1IS1_ivEEOT_OT0_
	add	rsp, 40
	pop	rbx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2967:
	.size	_ZNSt12_Bind_simpleIFPFviEiEEC2IIiEvEEOS1_DpOT_, .-_ZNSt12_Bind_simpleIFPFviEiEEC2IIiEvEEOS1_DpOT_
	.weak	_ZNSt12_Bind_simpleIFPFviEiEEC2IJiEvEEOS1_DpOT_
	.set	_ZNSt12_Bind_simpleIFPFviEiEEC2IJiEvEEOS1_DpOT_,_ZNSt12_Bind_simpleIFPFviEiEEC2IIiEvEEOS1_DpOT_
	.weak	_ZNSt12_Bind_simpleIFPFviEiEEC1IIiEvEEOS1_DpOT_
	.set	_ZNSt12_Bind_simpleIFPFviEiEEC1IIiEvEEOS1_DpOT_,_ZNSt12_Bind_simpleIFPFviEiEEC2IIiEvEEOS1_DpOT_
	.weak	_ZNSt12_Bind_simpleIFPFviEiEEC1IJiEvEEOS1_DpOT_
	.set	_ZNSt12_Bind_simpleIFPFviEiEEC1IJiEvEEOS1_DpOT_,_ZNSt12_Bind_simpleIFPFviEiEEC1IIiEvEEOS1_DpOT_
	.section	.text._ZSt11make_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEIS6_EESt10shared_ptrIT_EDpOT0_,"axG",@progbits,_ZSt11make_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEIS6_EESt10shared_ptrIT_EDpOT0_,comdat
	.weak	_ZSt11make_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEIS6_EESt10shared_ptrIT_EDpOT0_
	.type	_ZSt11make_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEIS6_EESt10shared_ptrIT_EDpOT0_, @function
_ZSt11make_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEIS6_EESt10shared_ptrIT_EDpOT0_:
.LFB2969:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA2969
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	sub	rsp, 40
	.cfi_offset 3, -24
	mov	QWORD PTR [rbp-40], rdi
	mov	QWORD PTR [rbp-48], rsi
	mov	rax, QWORD PTR [rbp-48]
	mov	rdi, rax
	call	_ZSt7forwardISt12_Bind_simpleIFPFviEiEEEOT_RNSt16remove_referenceIS5_E4typeE
	mov	rbx, rax
	lea	rax, [rbp-17]
	mov	rdi, rax
	call	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC1Ev
	mov	rax, QWORD PTR [rbp-40]
	lea	rcx, [rbp-17]
	mov	rdx, rbx
	mov	rsi, rcx
	mov	rdi, rax
.LEHB12:
	call	_ZSt15allocate_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_EIS6_EESt10shared_ptrIT_ERKT0_DpOT1_
.LEHE12:
	lea	rax, [rbp-17]
	mov	rdi, rax
	call	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED1Ev
	jmp	.L134
.L133:
	mov	rbx, rax
	lea	rax, [rbp-17]
	mov	rdi, rax
	call	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED1Ev
	mov	rax, rbx
	mov	rdi, rax
.LEHB13:
	call	_Unwind_Resume
.LEHE13:
.L134:
	mov	rax, QWORD PTR [rbp-40]
	add	rsp, 40
	pop	rbx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2969:
	.section	.gcc_except_table
.LLSDA2969:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE2969-.LLSDACSB2969
.LLSDACSB2969:
	.uleb128 .LEHB12-.LFB2969
	.uleb128 .LEHE12-.LEHB12
	.uleb128 .L133-.LFB2969
	.uleb128 0
	.uleb128 .LEHB13-.LFB2969
	.uleb128 .LEHE13-.LEHB13
	.uleb128 0
	.uleb128 0
.LLSDACSE2969:
	.section	.text._ZSt11make_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEIS6_EESt10shared_ptrIT_EDpOT0_,"axG",@progbits,_ZSt11make_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEIS6_EESt10shared_ptrIT_EDpOT0_,comdat
	.size	_ZSt11make_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEIS6_EESt10shared_ptrIT_EDpOT0_, .-_ZSt11make_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEIS6_EESt10shared_ptrIT_EDpOT0_
	.weak	_ZSt11make_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEJS6_EESt10shared_ptrIT_EDpOT0_
	.set	_ZSt11make_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEJS6_EESt10shared_ptrIT_EDpOT0_,_ZSt11make_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEIS6_EESt10shared_ptrIT_EDpOT0_
	.section	.text._ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC2Ev,"axG",@progbits,_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC5Ev,comdat
	.align 2
	.weak	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC2Ev
	.type	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC2Ev, @function
_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC2Ev:
.LFB2975:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	QWORD PTR [rax], 0
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2975:
	.size	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC2Ev, .-_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC2Ev
	.weak	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC1Ev
	.set	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC1Ev,_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC2Ev
	.section	.text._ZNSt12__shared_ptrINSt6thread10_Impl_baseELN9__gnu_cxx12_Lock_policyE2EEC2INS0_5_ImplISt12_Bind_simpleIFPFviEiEEEEvEEOS_IT_LS3_2EE,"axG",@progbits,_ZNSt12__shared_ptrINSt6thread10_Impl_baseELN9__gnu_cxx12_Lock_policyE2EEC5INS0_5_ImplISt12_Bind_simpleIFPFviEiEEEEvEEOS_IT_LS3_2EE,comdat
	.align 2
	.weak	_ZNSt12__shared_ptrINSt6thread10_Impl_baseELN9__gnu_cxx12_Lock_policyE2EEC2INS0_5_ImplISt12_Bind_simpleIFPFviEiEEEEvEEOS_IT_LS3_2EE
	.type	_ZNSt12__shared_ptrINSt6thread10_Impl_baseELN9__gnu_cxx12_Lock_policyE2EEC2INS0_5_ImplISt12_Bind_simpleIFPFviEiEEEEvEEOS_IT_LS3_2EE, @function
_ZNSt12__shared_ptrINSt6thread10_Impl_baseELN9__gnu_cxx12_Lock_policyE2EEC2INS0_5_ImplISt12_Bind_simpleIFPFviEiEEEEvEEOS_IT_LS3_2EE:
.LFB2977:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rax, QWORD PTR [rbp-16]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR [rbp-8]
	mov	QWORD PTR [rax], rdx
	mov	rax, QWORD PTR [rbp-8]
	add	rax, 8
	mov	rdi, rax
	call	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC1Ev
	mov	rax, QWORD PTR [rbp-16]
	lea	rdx, [rax+8]
	mov	rax, QWORD PTR [rbp-8]
	add	rax, 8
	mov	rsi, rdx
	mov	rdi, rax
	call	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EE7_M_swapERS2_
	mov	rax, QWORD PTR [rbp-16]
	mov	QWORD PTR [rax], 0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2977:
	.size	_ZNSt12__shared_ptrINSt6thread10_Impl_baseELN9__gnu_cxx12_Lock_policyE2EEC2INS0_5_ImplISt12_Bind_simpleIFPFviEiEEEEvEEOS_IT_LS3_2EE, .-_ZNSt12__shared_ptrINSt6thread10_Impl_baseELN9__gnu_cxx12_Lock_policyE2EEC2INS0_5_ImplISt12_Bind_simpleIFPFviEiEEEEvEEOS_IT_LS3_2EE
	.weak	_ZNSt12__shared_ptrINSt6thread10_Impl_baseELN9__gnu_cxx12_Lock_policyE2EEC1INS0_5_ImplISt12_Bind_simpleIFPFviEiEEEEvEEOS_IT_LS3_2EE
	.set	_ZNSt12__shared_ptrINSt6thread10_Impl_baseELN9__gnu_cxx12_Lock_policyE2EEC1INS0_5_ImplISt12_Bind_simpleIFPFviEiEEEEvEEOS_IT_LS3_2EE,_ZNSt12__shared_ptrINSt6thread10_Impl_baseELN9__gnu_cxx12_Lock_policyE2EEC2INS0_5_ImplISt12_Bind_simpleIFPFviEiEEEEvEEOS_IT_LS3_2EE
	.section	.text._ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EED2Ev,"axG",@progbits,_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EED5Ev,comdat
	.align 2
	.weak	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EED2Ev
	.type	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EED2Ev, @function
_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EED2Ev:
.LFB2985:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	QWORD PTR [rax], OFFSET FLAT:_ZTVSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE+16
	mov	eax, 0
	test	eax, eax
	je	.L137
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZdlPv
.L137:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2985:
	.size	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EED2Ev, .-_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EED2Ev
	.weak	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EED1Ev
	.set	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EED1Ev,_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EED2Ev
	.section	.text._ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EED0Ev,"axG",@progbits,_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EED0Ev,comdat
	.align 2
	.weak	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EED0Ev
	.type	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EED0Ev, @function
_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EED0Ev:
.LFB2987:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EED1Ev
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZdlPv
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2987:
	.size	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EED0Ev, .-_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EED0Ev
	.section	.text._ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2Ev,"axG",@progbits,_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC5Ev,comdat
	.align 2
	.weak	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2Ev
	.type	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2Ev, @function
_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2Ev:
.LFB2989:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2Ev
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2989:
	.size	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2Ev, .-_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2Ev
	.weak	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC1Ev
	.set	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC1Ev,_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2Ev
	.section	.text._ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED2Ev,"axG",@progbits,_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED5Ev,comdat
	.align 2
	.weak	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED2Ev
	.type	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED2Ev, @function
_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED2Ev:
.LFB2992:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED2Ev
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2992:
	.size	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED2Ev, .-_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED2Ev
	.weak	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED1Ev
	.set	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED1Ev,_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED2Ev
	.section	.text._ZSt15allocate_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_EIS6_EESt10shared_ptrIT_ERKT0_DpOT1_,"axG",@progbits,_ZSt15allocate_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_EIS6_EESt10shared_ptrIT_ERKT0_DpOT1_,comdat
	.weak	_ZSt15allocate_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_EIS6_EESt10shared_ptrIT_ERKT0_DpOT1_
	.type	_ZSt15allocate_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_EIS6_EESt10shared_ptrIT_ERKT0_DpOT1_, @function
_ZSt15allocate_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_EIS6_EESt10shared_ptrIT_ERKT0_DpOT1_:
.LFB2994:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA2994
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	sub	rsp, 56
	.cfi_offset 3, -24
	mov	QWORD PTR [rbp-40], rdi
	mov	QWORD PTR [rbp-48], rsi
	mov	QWORD PTR [rbp-56], rdx
	mov	rax, QWORD PTR [rbp-56]
	mov	rdi, rax
	call	_ZSt7forwardISt12_Bind_simpleIFPFviEiEEEOT_RNSt16remove_referenceIS5_E4typeE
	mov	rdx, rax
	mov	rcx, QWORD PTR [rbp-48]
	mov	rax, QWORD PTR [rbp-40]
	mov	BYTE PTR [rsp], bl
	mov	rsi, rcx
	mov	rdi, rax
.LEHB14:
	call	_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC1ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_
.LEHE14:
	jmp	.L149
.L148:
	mov	rdi, rax
.LEHB15:
	call	_Unwind_Resume
.LEHE15:
.L149:
	mov	rax, QWORD PTR [rbp-40]
	add	rsp, 56
	pop	rbx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2994:
	.section	.gcc_except_table
.LLSDA2994:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE2994-.LLSDACSB2994
.LLSDACSB2994:
	.uleb128 .LEHB14-.LFB2994
	.uleb128 .LEHE14-.LEHB14
	.uleb128 .L148-.LFB2994
	.uleb128 0
	.uleb128 .LEHB15-.LFB2994
	.uleb128 .LEHE15-.LEHB15
	.uleb128 0
	.uleb128 0
.LLSDACSE2994:
	.section	.text._ZSt15allocate_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_EIS6_EESt10shared_ptrIT_ERKT0_DpOT1_,"axG",@progbits,_ZSt15allocate_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_EIS6_EESt10shared_ptrIT_ERKT0_DpOT1_,comdat
	.size	_ZSt15allocate_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_EIS6_EESt10shared_ptrIT_ERKT0_DpOT1_, .-_ZSt15allocate_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_EIS6_EESt10shared_ptrIT_ERKT0_DpOT1_
	.weak	_ZSt15allocate_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_EJS6_EESt10shared_ptrIT_ERKT0_DpOT1_
	.set	_ZSt15allocate_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_EJS6_EESt10shared_ptrIT_ERKT0_DpOT1_,_ZSt15allocate_sharedINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_EIS6_EESt10shared_ptrIT_ERKT0_DpOT1_
	.section	.text._ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EE7_M_swapERS2_,"axG",@progbits,_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EE7_M_swapERS2_,comdat
	.align 2
	.weak	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EE7_M_swapERS2_
	.type	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EE7_M_swapERS2_, @function
_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EE7_M_swapERS2_:
.LFB2998:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-24], rdi
	mov	QWORD PTR [rbp-32], rsi
	mov	rax, QWORD PTR [rbp-32]
	mov	rax, QWORD PTR [rax]
	mov	QWORD PTR [rbp-8], rax
	mov	rax, QWORD PTR [rbp-24]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR [rbp-32]
	mov	QWORD PTR [rax], rdx
	mov	rax, QWORD PTR [rbp-24]
	mov	rdx, QWORD PTR [rbp-8]
	mov	QWORD PTR [rax], rdx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2998:
	.size	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EE7_M_swapERS2_, .-_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EE7_M_swapERS2_
	.section	.text._ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2Ev,"axG",@progbits,_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC5Ev,comdat
	.align 2
	.weak	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2Ev
	.type	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2Ev, @function
_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2Ev:
.LFB3002:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3002:
	.size	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2Ev, .-_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2Ev
	.weak	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC1Ev
	.set	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC1Ev,_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2Ev
	.section	.text._ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED2Ev,"axG",@progbits,_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED5Ev,comdat
	.align 2
	.weak	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED2Ev
	.type	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED2Ev, @function
_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED2Ev:
.LFB3005:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3005:
	.size	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED2Ev, .-_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED2Ev
	.weak	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED1Ev
	.set	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED1Ev,_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED2Ev
	.section	.text._ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_,"axG",@progbits,_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC5ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_,comdat
	.align 2
	.weak	_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_
	.type	_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_, @function
_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_:
.LFB3008:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	sub	rsp, 40
	.cfi_offset 3, -24
	mov	QWORD PTR [rbp-24], rdi
	mov	QWORD PTR [rbp-32], rsi
	mov	QWORD PTR [rbp-40], rdx
	mov	rax, QWORD PTR [rbp-40]
	mov	rdi, rax
	call	_ZSt7forwardISt12_Bind_simpleIFPFviEiEEEOT_RNSt16remove_referenceIS5_E4typeE
	mov	rdx, rax
	mov	rax, QWORD PTR [rbp-24]
	mov	rcx, QWORD PTR [rbp-32]
	mov	BYTE PTR [rsp], bl
	mov	rsi, rcx
	mov	rdi, rax
	call	_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EEC2ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_
	add	rsp, 40
	pop	rbx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3008:
	.size	_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_, .-_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_
	.weak	_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ISaIS7_EJS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_
	.set	_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ISaIS7_EJS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_,_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_
	.weak	_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC1ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_
	.set	_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC1ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_,_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_
	.weak	_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC1ISaIS7_EJS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_
	.set	_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC1ISaIS7_EJS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_,_ZNSt10shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC1ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_
	.section	.text._ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EEC2ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_,"axG",@progbits,_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EEC5ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_,comdat
	.align 2
	.weak	_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EEC2ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_
	.type	_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EEC2ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_, @function
_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EEC2ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_:
.LFB3021:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	sub	rsp, 56
	.cfi_offset 3, -24
	mov	QWORD PTR [rbp-40], rdi
	mov	QWORD PTR [rbp-48], rsi
	mov	QWORD PTR [rbp-56], rdx
	mov	rax, QWORD PTR [rbp-40]
	mov	QWORD PTR [rax], 0
	mov	rax, QWORD PTR [rbp-56]
	mov	rdi, rax
	call	_ZSt7forwardISt12_Bind_simpleIFPFviEiEEEOT_RNSt16remove_referenceIS5_E4typeE
	mov	rdx, rax
	mov	rax, QWORD PTR [rbp-40]
	lea	rdi, [rax+8]
	mov	rax, QWORD PTR [rbp-48]
	mov	BYTE PTR [rsp], bl
	mov	rcx, rdx
	mov	rdx, rax
	mov	esi, 0
	call	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC1INSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaISB_EISA_EEESt19_Sp_make_shared_tagPT_RKT0_DpOT1_
	mov	rax, QWORD PTR [rbp-40]
	add	rax, 8
	mov	esi, OFFSET FLAT:_ZTISt19_Sp_make_shared_tag
	mov	rdi, rax
	call	_ZNKSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info
	mov	QWORD PTR [rbp-24], rax
	mov	rax, QWORD PTR [rbp-40]
	mov	rdx, QWORD PTR [rbp-24]
	mov	QWORD PTR [rax], rdx
	mov	rax, QWORD PTR [rbp-40]
	mov	rdx, QWORD PTR [rax]
	mov	rax, QWORD PTR [rbp-40]
	mov	rax, QWORD PTR [rax]
	mov	rcx, QWORD PTR [rbp-40]
	add	rcx, 8
	mov	rsi, rax
	mov	rdi, rcx
	mov	eax, 0
	call	_ZSt32__enable_shared_from_this_helperILN9__gnu_cxx12_Lock_policyE2EEvRKSt14__shared_countIXT_EEz
	add	rsp, 56
	pop	rbx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3021:
	.size	_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EEC2ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_, .-_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EEC2ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_
	.weak	_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EEC2ISaIS7_EJS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_
	.set	_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EEC2ISaIS7_EJS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_,_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EEC2ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_
	.weak	_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EEC1ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_
	.set	_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EEC1ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_,_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EEC2ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_
	.weak	_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EEC1ISaIS7_EJS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_
	.set	_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EEC1ISaIS7_EJS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_,_ZNSt12__shared_ptrINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEELN9__gnu_cxx12_Lock_policyE2EEC1ISaIS7_EIS6_EEESt19_Sp_make_shared_tagRKT_DpOT0_
	.section	.text._ZSt4moveIRKSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEONSt16remove_referenceIT_E4typeEOSC_,"axG",@progbits,_ZSt4moveIRKSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEONSt16remove_referenceIT_E4typeEOSC_,comdat
	.weak	_ZSt4moveIRKSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEONSt16remove_referenceIT_E4typeEOSC_
	.type	_ZSt4moveIRKSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEONSt16remove_referenceIT_E4typeEOSC_, @function
_ZSt4moveIRKSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEONSt16remove_referenceIT_E4typeEOSC_:
.LFB3033:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3033:
	.size	_ZSt4moveIRKSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEONSt16remove_referenceIT_E4typeEOSC_, .-_ZSt4moveIRKSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEONSt16remove_referenceIT_E4typeEOSC_
	.section	.text._ZSt7forwardIKSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEOT_RNSt16remove_referenceISA_E4typeE,"axG",@progbits,_ZSt7forwardIKSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEOT_RNSt16remove_referenceISA_E4typeE,comdat
	.weak	_ZSt7forwardIKSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEOT_RNSt16remove_referenceISA_E4typeE
	.type	_ZSt7forwardIKSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEOT_RNSt16remove_referenceISA_E4typeE, @function
_ZSt7forwardIKSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEOT_RNSt16remove_referenceISA_E4typeE:
.LFB3034:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3034:
	.size	_ZSt7forwardIKSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEOT_RNSt16remove_referenceISA_E4typeE, .-_ZSt7forwardIKSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEOT_RNSt16remove_referenceISA_E4typeE
	.section	.text._ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC2INSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaISB_EISA_EEESt19_Sp_make_shared_tagPT_RKT0_DpOT1_,"axG",@progbits,_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC5INSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaISB_EISA_EEESt19_Sp_make_shared_tagPT_RKT0_DpOT1_,comdat
	.align 2
	.weak	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC2INSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaISB_EISA_EEESt19_Sp_make_shared_tagPT_RKT0_DpOT1_
	.type	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC2INSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaISB_EISA_EEESt19_Sp_make_shared_tagPT_RKT0_DpOT1_, @function
_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC2INSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaISB_EISA_EEESt19_Sp_make_shared_tagPT_RKT0_DpOT1_:
.LFB3035:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA3035
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	sub	rsp, 56
	.cfi_offset 3, -24
	mov	QWORD PTR [rbp-40], rdi
	mov	QWORD PTR [rbp-48], rsi
	mov	QWORD PTR [rbp-56], rdx
	mov	QWORD PTR [rbp-64], rcx
	mov	rax, QWORD PTR [rbp-40]
	mov	QWORD PTR [rax], 0
	mov	rdx, QWORD PTR [rbp-56]
	lea	rax, [rbp-25]
	mov	rsi, rdx
	mov	rdi, rax
	call	_ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEEC1IS7_EERKSaIT_E
	lea	rax, [rbp-25]
	mov	esi, 1
	mov	rdi, rax
.LEHB16:
	call	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE8allocateERSD_m
.LEHE16:
	mov	QWORD PTR [rbp-24], rax
	mov	rax, QWORD PTR [rbp-64]
	mov	rdi, rax
	call	_ZSt7forwardISt12_Bind_simpleIFPFviEiEEEOT_RNSt16remove_referenceIS5_E4typeE
	mov	rbx, rax
	mov	rax, QWORD PTR [rbp-56]
	mov	rdi, rax
	call	_ZSt4moveIRKSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEONSt16remove_referenceIT_E4typeEOSC_
	mov	rdx, rax
	mov	rsi, QWORD PTR [rbp-24]
	lea	rax, [rbp-25]
	mov	rcx, rbx
	mov	rdi, rax
.LEHB17:
	call	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE9constructISC_IKS9_S7_EEEDTcl12_S_constructfp_fp0_spcl7forwardIT0_Efp1_EEERSD_PT_DpOSH_
.LEHE17:
	mov	rax, QWORD PTR [rbp-40]
	mov	rdx, QWORD PTR [rbp-24]
	mov	QWORD PTR [rax], rdx
	lea	rax, [rbp-25]
	mov	rdi, rax
	call	_ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEED1Ev
	jmp	.L167
.L166:
	mov	rbx, rax
	call	__cxa_end_catch
	jmp	.L162
.L165:
	mov	rdi, rax
	call	__cxa_begin_catch
	mov	rcx, QWORD PTR [rbp-24]
	lea	rax, [rbp-25]
	mov	edx, 1
	mov	rsi, rcx
	mov	rdi, rax
.LEHB18:
	call	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE10deallocateERSD_PSC_m
	call	__cxa_rethrow
.LEHE18:
.L164:
	mov	rbx, rax
.L162:
	lea	rax, [rbp-25]
	mov	rdi, rax
	call	_ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEED1Ev
	mov	rax, rbx
	mov	rdi, rax
.LEHB19:
	call	_Unwind_Resume
.LEHE19:
.L167:
	add	rsp, 56
	pop	rbx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3035:
	.section	.gcc_except_table
	.align 4
.LLSDA3035:
	.byte	0xff
	.byte	0x3
	.uleb128 .LLSDATT3035-.LLSDATTD3035
.LLSDATTD3035:
	.byte	0x1
	.uleb128 .LLSDACSE3035-.LLSDACSB3035
.LLSDACSB3035:
	.uleb128 .LEHB16-.LFB3035
	.uleb128 .LEHE16-.LEHB16
	.uleb128 .L164-.LFB3035
	.uleb128 0
	.uleb128 .LEHB17-.LFB3035
	.uleb128 .LEHE17-.LEHB17
	.uleb128 .L165-.LFB3035
	.uleb128 0x1
	.uleb128 .LEHB18-.LFB3035
	.uleb128 .LEHE18-.LEHB18
	.uleb128 .L166-.LFB3035
	.uleb128 0
	.uleb128 .LEHB19-.LFB3035
	.uleb128 .LEHE19-.LEHB19
	.uleb128 0
	.uleb128 0
.LLSDACSE3035:
	.byte	0x1
	.byte	0
	.align 4
	.long	0

.LLSDATT3035:
	.section	.text._ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC2INSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaISB_EISA_EEESt19_Sp_make_shared_tagPT_RKT0_DpOT1_,"axG",@progbits,_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC5INSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaISB_EISA_EEESt19_Sp_make_shared_tagPT_RKT0_DpOT1_,comdat
	.size	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC2INSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaISB_EISA_EEESt19_Sp_make_shared_tagPT_RKT0_DpOT1_, .-_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC2INSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaISB_EISA_EEESt19_Sp_make_shared_tagPT_RKT0_DpOT1_
	.weak	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC2INSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaISB_EJSA_EEESt19_Sp_make_shared_tagPT_RKT0_DpOT1_
	.set	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC2INSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaISB_EJSA_EEESt19_Sp_make_shared_tagPT_RKT0_DpOT1_,_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC2INSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaISB_EISA_EEESt19_Sp_make_shared_tagPT_RKT0_DpOT1_
	.weak	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC1INSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaISB_EISA_EEESt19_Sp_make_shared_tagPT_RKT0_DpOT1_
	.set	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC1INSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaISB_EISA_EEESt19_Sp_make_shared_tagPT_RKT0_DpOT1_,_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC2INSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaISB_EISA_EEESt19_Sp_make_shared_tagPT_RKT0_DpOT1_
	.weak	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC1INSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaISB_EJSA_EEESt19_Sp_make_shared_tagPT_RKT0_DpOT1_
	.set	_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC1INSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaISB_EJSA_EEESt19_Sp_make_shared_tagPT_RKT0_DpOT1_,_ZNSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EEC1INSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaISB_EISA_EEESt19_Sp_make_shared_tagPT_RKT0_DpOT1_
	.section	.text._ZNKSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info,"axG",@progbits,_ZNKSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info,comdat
	.align 2
	.weak	_ZNKSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info
	.type	_ZNKSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info, @function
_ZNKSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info:
.LFB3037:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA3037
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rax, QWORD PTR [rbp-8]
	mov	rax, QWORD PTR [rax]
	test	rax, rax
	je	.L169
	mov	rax, QWORD PTR [rbp-8]
	mov	rax, QWORD PTR [rax]
	mov	rax, QWORD PTR [rax]
	add	rax, 32
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR [rbp-8]
	mov	rdx, QWORD PTR [rdx]
	mov	rcx, QWORD PTR [rbp-16]
	mov	rsi, rcx
	mov	rdi, rdx
	call	rax
	jmp	.L170
.L169:
	mov	eax, 0
.L170:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3037:
	.section	.gcc_except_table
.LLSDA3037:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE3037-.LLSDACSB3037
.LLSDACSB3037:
.LLSDACSE3037:
	.section	.text._ZNKSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info,"axG",@progbits,_ZNKSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info,comdat
	.size	_ZNKSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info, .-_ZNKSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info
	.section	.text._ZSt32__enable_shared_from_this_helperILN9__gnu_cxx12_Lock_policyE2EEvRKSt14__shared_countIXT_EEz,"axG",@progbits,_ZSt32__enable_shared_from_this_helperILN9__gnu_cxx12_Lock_policyE2EEvRKSt14__shared_countIXT_EEz,comdat
	.weak	_ZSt32__enable_shared_from_this_helperILN9__gnu_cxx12_Lock_policyE2EEvRKSt14__shared_countIXT_EEz
	.type	_ZSt32__enable_shared_from_this_helperILN9__gnu_cxx12_Lock_policyE2EEvRKSt14__shared_countIXT_EEz, @function
_ZSt32__enable_shared_from_this_helperILN9__gnu_cxx12_Lock_policyE2EEvRKSt14__shared_countIXT_EEz:
.LFB3038:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 64
	mov	QWORD PTR [rbp-168], rsi
	mov	QWORD PTR [rbp-160], rdx
	mov	QWORD PTR [rbp-152], rcx
	mov	QWORD PTR [rbp-144], r8
	mov	QWORD PTR [rbp-136], r9
	test	al, al
	je	.L173
	movaps	XMMWORD PTR [rbp-128], xmm0
	movaps	XMMWORD PTR [rbp-112], xmm1
	movaps	XMMWORD PTR [rbp-96], xmm2
	movaps	XMMWORD PTR [rbp-80], xmm3
	movaps	XMMWORD PTR [rbp-64], xmm4
	movaps	XMMWORD PTR [rbp-48], xmm5
	movaps	XMMWORD PTR [rbp-32], xmm6
	movaps	XMMWORD PTR [rbp-16], xmm7
.L173:
	mov	QWORD PTR [rbp-184], rdi
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3038:
	.size	_ZSt32__enable_shared_from_this_helperILN9__gnu_cxx12_Lock_policyE2EEvRKSt14__shared_countIXT_EEz, .-_ZSt32__enable_shared_from_this_helperILN9__gnu_cxx12_Lock_policyE2EEvRKSt14__shared_countIXT_EEz
	.section	.text._ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEEC2IS7_EERKSaIT_E,"axG",@progbits,_ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEEC5IS7_EERKSaIT_E,comdat
	.align 2
	.weak	_ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEEC2IS7_EERKSaIT_E
	.type	_ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEEC2IS7_EERKSaIT_E, @function
_ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEEC2IS7_EERKSaIT_E:
.LFB3040:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEEC2Ev
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3040:
	.size	_ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEEC2IS7_EERKSaIT_E, .-_ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEEC2IS7_EERKSaIT_E
	.weak	_ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEEC1IS7_EERKSaIT_E
	.set	_ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEEC1IS7_EERKSaIT_E,_ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEEC2IS7_EERKSaIT_E
	.section	.text._ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEED2Ev,"axG",@progbits,_ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEED5Ev,comdat
	.align 2
	.weak	_ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEED2Ev
	.type	_ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEED2Ev, @function
_ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEED2Ev:
.LFB3043:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEED2Ev
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3043:
	.size	_ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEED2Ev, .-_ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEED2Ev
	.weak	_ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEED1Ev
	.set	_ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEED1Ev,_ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEED2Ev
	.section	.text._ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE8allocateERSD_m,"axG",@progbits,_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE8allocateERSD_m,comdat
	.weak	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE8allocateERSD_m
	.type	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE8allocateERSD_m, @function
_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE8allocateERSD_m:
.LFB3045:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rcx, QWORD PTR [rbp-16]
	mov	rax, QWORD PTR [rbp-8]
	mov	edx, 0
	mov	rsi, rcx
	mov	rdi, rax
	call	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE8allocateEmPKv
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3045:
	.size	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE8allocateERSD_m, .-_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE8allocateERSD_m
	.section	.text._ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE9constructISC_IKS9_S7_EEEDTcl12_S_constructfp_fp0_spcl7forwardIT0_Efp1_EEERSD_PT_DpOSH_,"axG",@progbits,_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE9constructISC_IKS9_S7_EEEDTcl12_S_constructfp_fp0_spcl7forwardIT0_Efp1_EEERSD_PT_DpOSH_,comdat
	.weak	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE9constructISC_IKS9_S7_EEEDTcl12_S_constructfp_fp0_spcl7forwardIT0_Efp1_EEERSD_PT_DpOSH_
	.type	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE9constructISC_IKS9_S7_EEEDTcl12_S_constructfp_fp0_spcl7forwardIT0_Efp1_EEERSD_PT_DpOSH_, @function
_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE9constructISC_IKS9_S7_EEEDTcl12_S_constructfp_fp0_spcl7forwardIT0_Efp1_EEERSD_PT_DpOSH_:
.LFB3046:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	sub	rsp, 40
	.cfi_offset 3, -24
	mov	QWORD PTR [rbp-24], rdi
	mov	QWORD PTR [rbp-32], rsi
	mov	QWORD PTR [rbp-40], rdx
	mov	QWORD PTR [rbp-48], rcx
	mov	rax, QWORD PTR [rbp-48]
	mov	rdi, rax
	call	_ZSt7forwardISt12_Bind_simpleIFPFviEiEEEOT_RNSt16remove_referenceIS5_E4typeE
	mov	rbx, rax
	mov	rax, QWORD PTR [rbp-40]
	mov	rdi, rax
	call	_ZSt7forwardIKSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEOT_RNSt16remove_referenceISA_E4typeE
	mov	rdx, rax
	mov	rsi, QWORD PTR [rbp-32]
	mov	rax, QWORD PTR [rbp-24]
	mov	rcx, rbx
	mov	rdi, rax
	call	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE12_S_constructISC_IKS9_S7_EEENSt9enable_ifIXsrNSE_18__construct_helperIT_IDpT0_EEE5valueEvE4typeERSD_PSJ_DpOSK_
	add	rsp, 40
	pop	rbx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3046:
	.size	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE9constructISC_IKS9_S7_EEEDTcl12_S_constructfp_fp0_spcl7forwardIT0_Efp1_EEERSD_PT_DpOSH_, .-_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE9constructISC_IKS9_S7_EEEDTcl12_S_constructfp_fp0_spcl7forwardIT0_Efp1_EEERSD_PT_DpOSH_
	.weak	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE9constructISC_JKS9_S7_EEEDTcl12_S_constructfp_fp0_spcl7forwardIT0_Efp1_EEERSD_PT_DpOSH_
	.set	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE9constructISC_JKS9_S7_EEEDTcl12_S_constructfp_fp0_spcl7forwardIT0_Efp1_EEERSD_PT_DpOSH_,_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE9constructISC_IKS9_S7_EEEDTcl12_S_constructfp_fp0_spcl7forwardIT0_Efp1_EEERSD_PT_DpOSH_
	.section	.text._ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE10deallocateERSD_PSC_m,"axG",@progbits,_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE10deallocateERSD_PSC_m,comdat
	.weak	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE10deallocateERSD_PSC_m
	.type	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE10deallocateERSD_PSC_m, @function
_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE10deallocateERSD_PSC_m:
.LFB3047:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	QWORD PTR [rbp-24], rdx
	mov	rdx, QWORD PTR [rbp-24]
	mov	rcx, QWORD PTR [rbp-16]
	mov	rax, QWORD PTR [rbp-8]
	mov	rsi, rcx
	mov	rdi, rax
	call	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE10deallocateEPSC_m
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3047:
	.size	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE10deallocateERSD_PSC_m, .-_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE10deallocateERSD_PSC_m
	.section	.text._ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEEC2Ev,"axG",@progbits,_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEEC5Ev,comdat
	.align 2
	.weak	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEEC2Ev
	.type	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEEC2Ev, @function
_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEEC2Ev:
.LFB3049:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3049:
	.size	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEEC2Ev, .-_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEEC2Ev
	.weak	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEEC1Ev
	.set	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEEC1Ev,_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEEC2Ev
	.section	.text._ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEED2Ev,"axG",@progbits,_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEED5Ev,comdat
	.align 2
	.weak	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEED2Ev
	.type	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEED2Ev, @function
_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEED2Ev:
.LFB3052:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3052:
	.size	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEED2Ev, .-_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEED2Ev
	.weak	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEED1Ev
	.set	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEED1Ev,_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEED2Ev
	.section	.text._ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE8allocateEmPKv,"axG",@progbits,_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE8allocateEmPKv,comdat
	.align 2
	.weak	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE8allocateEmPKv
	.type	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE8allocateEmPKv, @function
_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE8allocateEmPKv:
.LFB3054:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	QWORD PTR [rbp-24], rdx
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZNK9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE8max_sizeEv
	cmp	rax, QWORD PTR [rbp-16]
	setb	al
	test	al, al
	je	.L185
	call	_ZSt17__throw_bad_allocv
.L185:
	mov	rax, QWORD PTR [rbp-16]
	sal	rax, 6
	mov	rdi, rax
	call	_Znwm
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3054:
	.size	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE8allocateEmPKv, .-_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE8allocateEmPKv
	.section	.text._ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE12_S_constructISC_IKS9_S7_EEENSt9enable_ifIXsrNSE_18__construct_helperIT_IDpT0_EEE5valueEvE4typeERSD_PSJ_DpOSK_,"axG",@progbits,_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE12_S_constructISC_IKS9_S7_EEENSt9enable_ifIXsrNSE_18__construct_helperIT_IDpT0_EEE5valueEvE4typeERSD_PSJ_DpOSK_,comdat
	.weak	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE12_S_constructISC_IKS9_S7_EEENSt9enable_ifIXsrNSE_18__construct_helperIT_IDpT0_EEE5valueEvE4typeERSD_PSJ_DpOSK_
	.type	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE12_S_constructISC_IKS9_S7_EEENSt9enable_ifIXsrNSE_18__construct_helperIT_IDpT0_EEE5valueEvE4typeERSD_PSJ_DpOSK_, @function
_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE12_S_constructISC_IKS9_S7_EEENSt9enable_ifIXsrNSE_18__construct_helperIT_IDpT0_EEE5valueEvE4typeERSD_PSJ_DpOSK_:
.LFB3055:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	sub	rsp, 40
	.cfi_offset 3, -24
	mov	QWORD PTR [rbp-24], rdi
	mov	QWORD PTR [rbp-32], rsi
	mov	QWORD PTR [rbp-40], rdx
	mov	QWORD PTR [rbp-48], rcx
	mov	rax, QWORD PTR [rbp-48]
	mov	rdi, rax
	call	_ZSt7forwardISt12_Bind_simpleIFPFviEiEEEOT_RNSt16remove_referenceIS5_E4typeE
	mov	rbx, rax
	mov	rax, QWORD PTR [rbp-40]
	mov	rdi, rax
	call	_ZSt7forwardIKSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEOT_RNSt16remove_referenceISA_E4typeE
	mov	rdx, rax
	mov	rsi, QWORD PTR [rbp-32]
	mov	rax, QWORD PTR [rbp-24]
	mov	rcx, rbx
	mov	rdi, rax
	call	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE9constructISC_IKSA_S8_EEEvPT_DpOT0_
	add	rsp, 40
	pop	rbx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3055:
	.size	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE12_S_constructISC_IKS9_S7_EEENSt9enable_ifIXsrNSE_18__construct_helperIT_IDpT0_EEE5valueEvE4typeERSD_PSJ_DpOSK_, .-_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE12_S_constructISC_IKS9_S7_EEENSt9enable_ifIXsrNSE_18__construct_helperIT_IDpT0_EEE5valueEvE4typeERSD_PSJ_DpOSK_
	.weak	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE12_S_constructISC_JKS9_S7_EEENSt9enable_ifIXsrNSE_18__construct_helperIT_JDpT0_EEE5valueEvE4typeERSD_PSJ_DpOSK_
	.set	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE12_S_constructISC_JKS9_S7_EEENSt9enable_ifIXsrNSE_18__construct_helperIT_JDpT0_EEE5valueEvE4typeERSD_PSJ_DpOSK_,_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE12_S_constructISC_IKS9_S7_EEENSt9enable_ifIXsrNSE_18__construct_helperIT_IDpT0_EEE5valueEvE4typeERSD_PSJ_DpOSK_
	.section	.text._ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE10deallocateEPSC_m,"axG",@progbits,_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE10deallocateEPSC_m,comdat
	.align 2
	.weak	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE10deallocateEPSC_m
	.type	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE10deallocateEPSC_m, @function
_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE10deallocateEPSC_m:
.LFB3056:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	QWORD PTR [rbp-24], rdx
	mov	rax, QWORD PTR [rbp-16]
	mov	rdi, rax
	call	_ZdlPv
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3056:
	.size	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE10deallocateEPSC_m, .-_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE10deallocateEPSC_m
	.section	.text._ZNK9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE8max_sizeEv,"axG",@progbits,_ZNK9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE8max_sizeEv,comdat
	.align 2
	.weak	_ZNK9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE8max_sizeEv
	.type	_ZNK9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE8max_sizeEv, @function
_ZNK9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE8max_sizeEv:
.LFB3057:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	movabs	rax, 288230376151711743
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3057:
	.size	_ZNK9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE8max_sizeEv, .-_ZNK9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE8max_sizeEv
	.section	.text._ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE9constructISC_IKSA_S8_EEEvPT_DpOT0_,"axG",@progbits,_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE9constructISC_IKSA_S8_EEEvPT_DpOT0_,comdat
	.align 2
	.weak	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE9constructISC_IKSA_S8_EEEvPT_DpOT0_
	.type	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE9constructISC_IKSA_S8_EEEvPT_DpOT0_, @function
_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE9constructISC_IKSA_S8_EEEvPT_DpOT0_:
.LFB3058:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA3058
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	r14
	push	r13
	push	r12
	push	rbx
	sub	rsp, 48
	.cfi_offset 14, -24
	.cfi_offset 13, -32
	.cfi_offset 12, -40
	.cfi_offset 3, -48
	mov	QWORD PTR [rbp-56], rdi
	mov	QWORD PTR [rbp-64], rsi
	mov	QWORD PTR [rbp-72], rdx
	mov	QWORD PTR [rbp-80], rcx
	mov	rax, QWORD PTR [rbp-72]
	mov	rdi, rax
	call	_ZSt7forwardIKSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEEOT_RNSt16remove_referenceISA_E4typeE
	mov	rdx, rax
	lea	rax, [rbp-33]
	mov	rsi, rdx
	mov	rdi, rax
	call	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC1ERKS7_
	lea	r13, [rbp-33]
	mov	rax, QWORD PTR [rbp-80]
	mov	rdi, rax
	call	_ZSt7forwardISt12_Bind_simpleIFPFviEiEEEOT_RNSt16remove_referenceIS5_E4typeE
	mov	r14, rax
	mov	r12, QWORD PTR [rbp-64]
	mov	rsi, r12
	mov	edi, 64
	call	_ZnwmPv
	mov	rbx, rax
	test	rbx, rbx
	je	.L193
	mov	rdx, r14
	mov	rsi, r13
	mov	rdi, rbx
.LEHB20:
	call	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEC1IIS6_EEES8_DpOT_
.LEHE20:
.L193:
	lea	rax, [rbp-33]
	mov	rdi, rax
	call	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED1Ev
	jmp	.L196
.L195:
	mov	r13, rax
	mov	rsi, r12
	mov	rdi, rbx
	call	_ZdlPvS_
	mov	rbx, r13
	lea	rax, [rbp-33]
	mov	rdi, rax
	call	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED1Ev
	mov	rax, rbx
	mov	rdi, rax
.LEHB21:
	call	_Unwind_Resume
.LEHE21:
.L196:
	add	rsp, 48
	pop	rbx
	pop	r12
	pop	r13
	pop	r14
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3058:
	.section	.gcc_except_table
.LLSDA3058:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE3058-.LLSDACSB3058
.LLSDACSB3058:
	.uleb128 .LEHB20-.LFB3058
	.uleb128 .LEHE20-.LEHB20
	.uleb128 .L195-.LFB3058
	.uleb128 0
	.uleb128 .LEHB21-.LFB3058
	.uleb128 .LEHE21-.LEHB21
	.uleb128 0
	.uleb128 0
.LLSDACSE3058:
	.section	.text._ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE9constructISC_IKSA_S8_EEEvPT_DpOT0_,"axG",@progbits,_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE9constructISC_IKSA_S8_EEEvPT_DpOT0_,comdat
	.size	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE9constructISC_IKSA_S8_EEEvPT_DpOT0_, .-_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE9constructISC_IKSA_S8_EEEvPT_DpOT0_
	.weak	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE9constructISC_JKSA_S8_EEEvPT_DpOT0_
	.set	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE9constructISC_JKSA_S8_EEEvPT_DpOT0_,_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE9constructISC_IKSA_S8_EEEvPT_DpOT0_
	.section	.text._ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ERKS7_,"axG",@progbits,_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC5ERKS7_,comdat
	.align 2
	.weak	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ERKS7_
	.type	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ERKS7_, @function
_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ERKS7_:
.LFB3060:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rdx, QWORD PTR [rbp-16]
	mov	rax, QWORD PTR [rbp-8]
	mov	rsi, rdx
	mov	rdi, rax
	call	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ERKS9_
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3060:
	.size	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ERKS7_, .-_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ERKS7_
	.weak	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC1ERKS7_
	.set	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC1ERKS7_,_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ERKS7_
	.section	.text._ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE5_ImplD2Ev,"axG",@progbits,_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE5_ImplD5Ev,comdat
	.align 2
	.weak	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE5_ImplD2Ev
	.type	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE5_ImplD2Ev, @function
_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE5_ImplD2Ev:
.LFB3064:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED2Ev
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3064:
	.size	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE5_ImplD2Ev, .-_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE5_ImplD2Ev
	.weak	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE5_ImplD1Ev
	.set	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE5_ImplD1Ev,_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE5_ImplD2Ev
	.section	.text._ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEC2IIS6_EEES8_DpOT_,"axG",@progbits,_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEC5IIS6_EEES8_DpOT_,comdat
	.align 2
	.weak	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEC2IIS6_EEES8_DpOT_
	.type	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEC2IIS6_EEES8_DpOT_, @function
_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEC2IIS6_EEES8_DpOT_:
.LFB3066:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA3066
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	sub	rsp, 56
	.cfi_offset 3, -24
	mov	QWORD PTR [rbp-40], rdi
	mov	QWORD PTR [rbp-48], rsi
	mov	QWORD PTR [rbp-56], rdx
	mov	rax, QWORD PTR [rbp-40]
	mov	rdi, rax
	call	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EEC2Ev
	mov	rax, QWORD PTR [rbp-40]
	mov	QWORD PTR [rax], OFFSET FLAT:_ZTVSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE+16
	mov	rdx, QWORD PTR [rbp-48]
	lea	rax, [rbp-17]
	mov	rsi, rdx
	mov	rdi, rax
	call	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC1ERKS7_
	mov	rax, QWORD PTR [rbp-40]
	lea	rdx, [rax+16]
	lea	rax, [rbp-17]
	mov	rsi, rax
	mov	rdi, rdx
	call	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE5_ImplC1ES8_
	lea	rax, [rbp-17]
	mov	rdi, rax
	call	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEED1Ev
	mov	rax, QWORD PTR [rbp-40]
	mov	QWORD PTR [rax+24], 0
	mov	QWORD PTR [rax+32], 0
	mov	QWORD PTR [rax+40], 0
	mov	QWORD PTR [rax+48], 0
	mov	QWORD PTR [rax+56], 0
	mov	rax, QWORD PTR [rbp-40]
	lea	rdx, [rax+24]
	mov	rax, QWORD PTR [rbp-40]
	mov	QWORD PTR [rax+16], rdx
	mov	rax, QWORD PTR [rbp-56]
	mov	rdi, rax
	call	_ZSt7forwardISt12_Bind_simpleIFPFviEiEEEOT_RNSt16remove_referenceIS5_E4typeE
	mov	rdx, rax
	mov	rax, QWORD PTR [rbp-40]
	mov	rcx, QWORD PTR [rax+16]
	mov	rax, QWORD PTR [rbp-48]
	mov	rsi, rcx
	mov	rdi, rax
.LEHB22:
	call	_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE9constructIS7_IS6_EEEDTcl12_S_constructfp_fp0_spcl7forwardIT0_Efp1_EEERS8_PT_DpOSB_
.LEHE22:
	jmp	.L203
.L202:
	mov	rbx, rax
	mov	rax, QWORD PTR [rbp-40]
	add	rax, 16
	mov	rdi, rax
	call	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE5_ImplD1Ev
	mov	rax, QWORD PTR [rbp-40]
	mov	rdi, rax
	call	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EED2Ev
	mov	rax, rbx
	mov	rdi, rax
.LEHB23:
	call	_Unwind_Resume
.LEHE23:
.L203:
	add	rsp, 56
	pop	rbx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3066:
	.section	.gcc_except_table
.LLSDA3066:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE3066-.LLSDACSB3066
.LLSDACSB3066:
	.uleb128 .LEHB22-.LFB3066
	.uleb128 .LEHE22-.LEHB22
	.uleb128 .L202-.LFB3066
	.uleb128 0
	.uleb128 .LEHB23-.LFB3066
	.uleb128 .LEHE23-.LEHB23
	.uleb128 0
	.uleb128 0
.LLSDACSE3066:
	.section	.text._ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEC2IIS6_EEES8_DpOT_,"axG",@progbits,_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEC5IIS6_EEES8_DpOT_,comdat
	.size	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEC2IIS6_EEES8_DpOT_, .-_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEC2IIS6_EEES8_DpOT_
	.weak	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEC2IJS6_EEES8_DpOT_
	.set	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEC2IJS6_EEES8_DpOT_,_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEC2IIS6_EEES8_DpOT_
	.weak	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEC1IIS6_EEES8_DpOT_
	.set	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEC1IIS6_EEES8_DpOT_,_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEC2IIS6_EEES8_DpOT_
	.weak	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEC1IJS6_EEES8_DpOT_
	.set	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEC1IJS6_EEES8_DpOT_,_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEC1IIS6_EEES8_DpOT_
	.section	.text._ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ERKS9_,"axG",@progbits,_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC5ERKS9_,comdat
	.align 2
	.weak	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ERKS9_
	.type	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ERKS9_, @function
_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ERKS9_:
.LFB3069:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3069:
	.size	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ERKS9_, .-_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ERKS9_
	.weak	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC1ERKS9_
	.set	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC1ERKS9_,_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ERKS9_
	.section	.text._ZNSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EEC2Ev,"axG",@progbits,_ZNSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EEC5Ev,comdat
	.align 2
	.weak	_ZNSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EEC2Ev
	.type	_ZNSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EEC2Ev, @function
_ZNSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EEC2Ev:
.LFB3073:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3073:
	.size	_ZNSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EEC2Ev, .-_ZNSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EEC2Ev
	.weak	_ZNSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EEC1Ev
	.set	_ZNSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EEC1Ev,_ZNSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EEC2Ev
	.section	.text._ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EEC2Ev,"axG",@progbits,_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EEC5Ev,comdat
	.align 2
	.weak	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EEC2Ev
	.type	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EEC2Ev, @function
_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EEC2Ev:
.LFB3075:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZNSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EEC2Ev
	mov	rax, QWORD PTR [rbp-8]
	mov	QWORD PTR [rax], OFFSET FLAT:_ZTVSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE+16
	mov	rax, QWORD PTR [rbp-8]
	mov	DWORD PTR [rax+8], 1
	mov	rax, QWORD PTR [rbp-8]
	mov	DWORD PTR [rax+12], 1
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3075:
	.size	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EEC2Ev, .-_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EEC2Ev
	.weak	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EEC1Ev
	.set	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EEC1Ev,_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EEC2Ev
	.section	.text._ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE5_ImplC2ES8_,"axG",@progbits,_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE5_ImplC5ES8_,comdat
	.align 2
	.weak	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE5_ImplC2ES8_
	.type	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE5_ImplC2ES8_, @function
_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE5_ImplC2ES8_:
.LFB3078:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rdx, QWORD PTR [rbp-16]
	mov	rax, QWORD PTR [rbp-8]
	mov	rsi, rdx
	mov	rdi, rax
	call	_ZNSaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEC2ERKS7_
	mov	rax, QWORD PTR [rbp-8]
	mov	QWORD PTR [rax], 0
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3078:
	.size	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE5_ImplC2ES8_, .-_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE5_ImplC2ES8_
	.weak	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE5_ImplC1ES8_
	.set	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE5_ImplC1ES8_,_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE5_ImplC2ES8_
	.section	.text._ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE9constructIS7_IS6_EEEDTcl12_S_constructfp_fp0_spcl7forwardIT0_Efp1_EEERS8_PT_DpOSB_,"axG",@progbits,_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE9constructIS7_IS6_EEEDTcl12_S_constructfp_fp0_spcl7forwardIT0_Efp1_EEERS8_PT_DpOSB_,comdat
	.weak	_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE9constructIS7_IS6_EEEDTcl12_S_constructfp_fp0_spcl7forwardIT0_Efp1_EEERS8_PT_DpOSB_
	.type	_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE9constructIS7_IS6_EEEDTcl12_S_constructfp_fp0_spcl7forwardIT0_Efp1_EEERS8_PT_DpOSB_, @function
_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE9constructIS7_IS6_EEEDTcl12_S_constructfp_fp0_spcl7forwardIT0_Efp1_EEERS8_PT_DpOSB_:
.LFB3080:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	QWORD PTR [rbp-24], rdx
	mov	rax, QWORD PTR [rbp-24]
	mov	rdi, rax
	call	_ZSt7forwardISt12_Bind_simpleIFPFviEiEEEOT_RNSt16remove_referenceIS5_E4typeE
	mov	rdx, rax
	mov	rcx, QWORD PTR [rbp-16]
	mov	rax, QWORD PTR [rbp-8]
	mov	rsi, rcx
	mov	rdi, rax
	call	_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE12_S_constructIS7_IS6_EEENSt9enable_ifIXsrNS9_18__construct_helperIT_IDpT0_EEE5valueEvE4typeERS8_PSD_DpOSE_
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3080:
	.size	_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE9constructIS7_IS6_EEEDTcl12_S_constructfp_fp0_spcl7forwardIT0_Efp1_EEERS8_PT_DpOSB_, .-_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE9constructIS7_IS6_EEEDTcl12_S_constructfp_fp0_spcl7forwardIT0_Efp1_EEERS8_PT_DpOSB_
	.weak	_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE9constructIS7_JS6_EEEDTcl12_S_constructfp_fp0_spcl7forwardIT0_Efp1_EEERS8_PT_DpOSB_
	.set	_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE9constructIS7_JS6_EEEDTcl12_S_constructfp_fp0_spcl7forwardIT0_Efp1_EEERS8_PT_DpOSB_,_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE9constructIS7_IS6_EEEDTcl12_S_constructfp_fp0_spcl7forwardIT0_Efp1_EEERS8_PT_DpOSB_
	.section	.text._ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE12_S_constructIS7_IS6_EEENSt9enable_ifIXsrNS9_18__construct_helperIT_IDpT0_EEE5valueEvE4typeERS8_PSD_DpOSE_,"axG",@progbits,_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE12_S_constructIS7_IS6_EEENSt9enable_ifIXsrNS9_18__construct_helperIT_IDpT0_EEE5valueEvE4typeERS8_PSD_DpOSE_,comdat
	.weak	_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE12_S_constructIS7_IS6_EEENSt9enable_ifIXsrNS9_18__construct_helperIT_IDpT0_EEE5valueEvE4typeERS8_PSD_DpOSE_
	.type	_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE12_S_constructIS7_IS6_EEENSt9enable_ifIXsrNS9_18__construct_helperIT_IDpT0_EEE5valueEvE4typeERS8_PSD_DpOSE_, @function
_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE12_S_constructIS7_IS6_EEENSt9enable_ifIXsrNS9_18__construct_helperIT_IDpT0_EEE5valueEvE4typeERS8_PSD_DpOSE_:
.LFB3081:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	QWORD PTR [rbp-24], rdx
	mov	rax, QWORD PTR [rbp-24]
	mov	rdi, rax
	call	_ZSt7forwardISt12_Bind_simpleIFPFviEiEEEOT_RNSt16remove_referenceIS5_E4typeE
	mov	rdx, rax
	mov	rcx, QWORD PTR [rbp-16]
	mov	rax, QWORD PTR [rbp-8]
	mov	rsi, rcx
	mov	rdi, rax
	call	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEE9constructIS8_IS7_EEEvPT_DpOT0_
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3081:
	.size	_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE12_S_constructIS7_IS6_EEENSt9enable_ifIXsrNS9_18__construct_helperIT_IDpT0_EEE5valueEvE4typeERS8_PSD_DpOSE_, .-_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE12_S_constructIS7_IS6_EEENSt9enable_ifIXsrNS9_18__construct_helperIT_IDpT0_EEE5valueEvE4typeERS8_PSD_DpOSE_
	.weak	_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE12_S_constructIS7_JS6_EEENSt9enable_ifIXsrNS9_18__construct_helperIT_JDpT0_EEE5valueEvE4typeERS8_PSD_DpOSE_
	.set	_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE12_S_constructIS7_JS6_EEENSt9enable_ifIXsrNS9_18__construct_helperIT_JDpT0_EEE5valueEvE4typeERS8_PSD_DpOSE_,_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE12_S_constructIS7_IS6_EEENSt9enable_ifIXsrNS9_18__construct_helperIT_IDpT0_EEE5valueEvE4typeERS8_PSD_DpOSE_
	.section	.text._ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEE9constructIS8_IS7_EEEvPT_DpOT0_,"axG",@progbits,_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEE9constructIS8_IS7_EEEvPT_DpOT0_,comdat
	.align 2
	.weak	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEE9constructIS8_IS7_EEEvPT_DpOT0_
	.type	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEE9constructIS8_IS7_EEEvPT_DpOT0_, @function
_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEE9constructIS8_IS7_EEEvPT_DpOT0_:
.LFB3082:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	sub	rsp, 40
	.cfi_offset 3, -24
	mov	QWORD PTR [rbp-24], rdi
	mov	QWORD PTR [rbp-32], rsi
	mov	QWORD PTR [rbp-40], rdx
	mov	rax, QWORD PTR [rbp-40]
	mov	rdi, rax
	call	_ZSt7forwardISt12_Bind_simpleIFPFviEiEEEOT_RNSt16remove_referenceIS5_E4typeE
	mov	rbx, rax
	mov	rax, QWORD PTR [rbp-32]
	mov	rsi, rax
	mov	edi, 40
	call	_ZnwmPv
	test	rax, rax
	je	.L210
	mov	rsi, rbx
	mov	rdi, rax
	call	_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEC1EOS5_
.L210:
	add	rsp, 40
	pop	rbx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3082:
	.size	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEE9constructIS8_IS7_EEEvPT_DpOT0_, .-_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEE9constructIS8_IS7_EEEvPT_DpOT0_
	.weak	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEE9constructIS8_JS7_EEEvPT_DpOT0_
	.set	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEE9constructIS8_JS7_EEEvPT_DpOT0_,_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEE9constructIS8_IS7_EEEvPT_DpOT0_
	.section	.text._ZNSt6thread10_Impl_baseC2Ev,"axG",@progbits,_ZNSt6thread10_Impl_baseC5Ev,comdat
	.align 2
	.weak	_ZNSt6thread10_Impl_baseC2Ev
	.type	_ZNSt6thread10_Impl_baseC2Ev, @function
_ZNSt6thread10_Impl_baseC2Ev:
.LFB3091:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	QWORD PTR [rax], OFFSET FLAT:_ZTVNSt6thread10_Impl_baseE+16
	mov	rax, QWORD PTR [rbp-8]
	mov	QWORD PTR [rax+8], 0
	mov	rax, QWORD PTR [rbp-8]
	mov	QWORD PTR [rax+16], 0
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3091:
	.size	_ZNSt6thread10_Impl_baseC2Ev, .-_ZNSt6thread10_Impl_baseC2Ev
	.weak	_ZNSt6thread10_Impl_baseC1Ev
	.set	_ZNSt6thread10_Impl_baseC1Ev,_ZNSt6thread10_Impl_baseC2Ev
	.section	.text._ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEC2EOS5_,"axG",@progbits,_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEC5EOS5_,comdat
	.align 2
	.weak	_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEC2EOS5_
	.type	_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEC2EOS5_, @function
_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEC2EOS5_:
.LFB3093:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZNSt6thread10_Impl_baseC2Ev
	mov	rax, QWORD PTR [rbp-8]
	mov	QWORD PTR [rax], OFFSET FLAT:_ZTVNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEE+16
	mov	rax, QWORD PTR [rbp-16]
	mov	rdi, rax
	call	_ZSt7forwardISt12_Bind_simpleIFPFviEiEEEOT_RNSt16remove_referenceIS5_E4typeE
	mov	rdx, QWORD PTR [rbp-8]
	add	rdx, 24
	mov	rsi, rax
	mov	rdi, rdx
	call	_ZNSt12_Bind_simpleIFPFviEiEEC1EOS3_
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3093:
	.size	_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEC2EOS5_, .-_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEC2EOS5_
	.weak	_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEC1EOS5_
	.set	_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEC1EOS5_,_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEC2EOS5_
	.weak	_ZTVSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE
	.section	.rodata._ZTVSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE,"aG",@progbits,_ZTVSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE,comdat
	.align 32
	.type	_ZTVSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE, @object
	.size	_ZTVSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE, 56
_ZTVSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE:
	.quad	0
	.quad	_ZTISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE
	.quad	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EED1Ev
	.quad	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EED0Ev
	.quad	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE10_M_disposeEv
	.quad	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv
	.quad	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info
	.weak	_ZTVNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEE
	.section	.rodata._ZTVNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEE,"aG",@progbits,_ZTVNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEE,comdat
	.align 32
	.type	_ZTVNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEE, @object
	.size	_ZTVNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEE, 40
_ZTVNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEE:
	.quad	0
	.quad	_ZTINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEE
	.quad	_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEED1Ev
	.quad	_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEED0Ev
	.quad	_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEE6_M_runEv
	.section	.text._ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEED2Ev,"axG",@progbits,_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEED5Ev,comdat
	.align 2
	.weak	_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEED2Ev
	.type	_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEED2Ev, @function
_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEED2Ev:
.LFB3096:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	QWORD PTR [rax], OFFSET FLAT:_ZTVNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEE+16
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZNSt6thread10_Impl_baseD2Ev
	mov	eax, 0
	test	eax, eax
	je	.L215
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZdlPv
.L215:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3096:
	.size	_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEED2Ev, .-_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEED2Ev
	.weak	_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEED1Ev
	.set	_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEED1Ev,_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEED2Ev
	.section	.text._ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEED0Ev,"axG",@progbits,_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEED0Ev,comdat
	.align 2
	.weak	_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEED0Ev
	.type	_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEED0Ev, @function
_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEED0Ev:
.LFB3098:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEED1Ev
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZdlPv
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3098:
	.size	_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEED0Ev, .-_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEED0Ev
	.weak	_ZTVNSt6thread10_Impl_baseE
	.section	.rodata._ZTVNSt6thread10_Impl_baseE,"aG",@progbits,_ZTVNSt6thread10_Impl_baseE,comdat
	.align 32
	.type	_ZTVNSt6thread10_Impl_baseE, @object
	.size	_ZTVNSt6thread10_Impl_baseE, 40
_ZTVNSt6thread10_Impl_baseE:
	.quad	0
	.quad	_ZTINSt6thread10_Impl_baseE
	.quad	_ZNSt6thread10_Impl_baseD1Ev
	.quad	_ZNSt6thread10_Impl_baseD0Ev
	.quad	__cxa_pure_virtual
	.weak	_ZTVSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE
	.section	.rodata._ZTVSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE,"aG",@progbits,_ZTVSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE,comdat
	.align 32
	.type	_ZTVSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE, @object
	.size	_ZTVSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE, 56
_ZTVSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE:
	.quad	0
	.quad	_ZTISt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE
	.quad	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EED1Ev
	.quad	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EED0Ev
	.quad	__cxa_pure_virtual
	.quad	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv
	.quad	__cxa_pure_virtual
	.weak	_ZTSSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE
	.section	.rodata._ZTSSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE,"aG",@progbits,_ZTSSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE,comdat
	.align 32
	.type	_ZTSSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE, @object
	.size	_ZTSSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE, 111
_ZTSSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE:
	.string	"St23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE"
	.weak	_ZTISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE
	.section	.rodata._ZTISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE,"aG",@progbits,_ZTISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE,comdat
	.align 16
	.type	_ZTISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE, @object
	.size	_ZTISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE, 24
_ZTISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE:
	.quad	_ZTVN10__cxxabiv120__si_class_type_infoE+16
	.quad	_ZTSSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE
	.quad	_ZTISt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE
	.weak	_ZTSSt19_Sp_make_shared_tag
	.section	.rodata._ZTSSt19_Sp_make_shared_tag,"aG",@progbits,_ZTSSt19_Sp_make_shared_tag,comdat
	.align 16
	.type	_ZTSSt19_Sp_make_shared_tag, @object
	.size	_ZTSSt19_Sp_make_shared_tag, 24
_ZTSSt19_Sp_make_shared_tag:
	.string	"St19_Sp_make_shared_tag"
	.weak	_ZTISt19_Sp_make_shared_tag
	.section	.rodata._ZTISt19_Sp_make_shared_tag,"aG",@progbits,_ZTISt19_Sp_make_shared_tag,comdat
	.align 16
	.type	_ZTISt19_Sp_make_shared_tag, @object
	.size	_ZTISt19_Sp_make_shared_tag, 16
_ZTISt19_Sp_make_shared_tag:
	.quad	_ZTVN10__cxxabiv117__class_type_infoE+16
	.quad	_ZTSSt19_Sp_make_shared_tag
	.weak	_ZTSNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEE
	.section	.rodata._ZTSNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEE,"aG",@progbits,_ZTSNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEE,comdat
	.align 32
	.type	_ZTSNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEE, @object
	.size	_ZTSNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEE, 46
_ZTSNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEE:
	.string	"NSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEE"
	.weak	_ZTINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEE
	.section	.rodata._ZTINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEE,"aG",@progbits,_ZTINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEE,comdat
	.align 16
	.type	_ZTINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEE, @object
	.size	_ZTINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEE, 24
_ZTINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEE:
	.quad	_ZTVN10__cxxabiv120__si_class_type_infoE+16
	.quad	_ZTSNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEE
	.quad	_ZTINSt6thread10_Impl_baseE
	.weak	_ZTSNSt6thread10_Impl_baseE
	.section	.rodata._ZTSNSt6thread10_Impl_baseE,"aG",@progbits,_ZTSNSt6thread10_Impl_baseE,comdat
	.align 16
	.type	_ZTSNSt6thread10_Impl_baseE, @object
	.size	_ZTSNSt6thread10_Impl_baseE, 24
_ZTSNSt6thread10_Impl_baseE:
	.string	"NSt6thread10_Impl_baseE"
	.weak	_ZTINSt6thread10_Impl_baseE
	.section	.rodata._ZTINSt6thread10_Impl_baseE,"aG",@progbits,_ZTINSt6thread10_Impl_baseE,comdat
	.align 16
	.type	_ZTINSt6thread10_Impl_baseE, @object
	.size	_ZTINSt6thread10_Impl_baseE, 16
_ZTINSt6thread10_Impl_baseE:
	.quad	_ZTVN10__cxxabiv117__class_type_infoE+16
	.quad	_ZTSNSt6thread10_Impl_baseE
	.weak	_ZTSSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE
	.section	.rodata._ZTSSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE,"aG",@progbits,_ZTSSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE,comdat
	.align 32
	.type	_ZTSSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE, @object
	.size	_ZTSSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE, 52
_ZTSSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE:
	.string	"St16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE"
	.weak	_ZTISt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE
	.section	.rodata._ZTISt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE,"aG",@progbits,_ZTISt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE,comdat
	.align 16
	.type	_ZTISt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE, @object
	.size	_ZTISt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE, 24
_ZTISt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE:
	.quad	_ZTVN10__cxxabiv120__si_class_type_infoE+16
	.quad	_ZTSSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE
	.quad	_ZTISt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE
	.text
	.type	_Z41__static_initialization_and_destruction_0ii, @function
_Z41__static_initialization_and_destruction_0ii:
.LFB3115:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	DWORD PTR [rbp-4], edi
	mov	DWORD PTR [rbp-8], esi
	cmp	DWORD PTR [rbp-4], 1
	jne	.L220
	cmp	DWORD PTR [rbp-8], 65535
	jne	.L220
	mov	edi, 84
	call	sysconf
	mov	DWORD PTR _ZL9num_cores[rip], eax
.L220:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3115:
	.size	_Z41__static_initialization_and_destruction_0ii, .-_Z41__static_initialization_and_destruction_0ii
	.section	.rodata
	.align 4
	.type	_ZN9__gnu_cxxL21__default_lock_policyE, @object
	.size	_ZN9__gnu_cxxL21__default_lock_policyE, 4
_ZN9__gnu_cxxL21__default_lock_policyE:
	.long	2
	.section	.text._ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EED2Ev,"axG",@progbits,_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EED5Ev,comdat
	.align 2
	.weak	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EED2Ev
	.type	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EED2Ev, @function
_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EED2Ev:
.LFB3117:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	QWORD PTR [rax], OFFSET FLAT:_ZTVSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE+16
	mov	rax, QWORD PTR [rbp-8]
	add	rax, 16
	mov	rdi, rax
	call	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE5_ImplD1Ev
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EED2Ev
	mov	eax, 0
	test	eax, eax
	je	.L222
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZdlPv
.L222:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3117:
	.size	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EED2Ev, .-_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EED2Ev
	.weak	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EED1Ev
	.set	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EED1Ev,_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EED2Ev
	.section	.text._ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EED0Ev,"axG",@progbits,_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EED0Ev,comdat
	.align 2
	.weak	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EED0Ev
	.type	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EED0Ev, @function
_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EED0Ev:
.LFB3119:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EED1Ev
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZdlPv
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3119:
	.size	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EED0Ev, .-_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EED0Ev
	.section	.text._ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE10_M_disposeEv,"axG",@progbits,_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE10_M_disposeEv,comdat
	.align 2
	.weak	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE10_M_disposeEv
	.type	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE10_M_disposeEv, @function
_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE10_M_disposeEv:
.LFB3120:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA3120
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	rax, QWORD PTR [rax+16]
	mov	rdx, QWORD PTR [rbp-8]
	add	rdx, 16
	mov	rsi, rax
	mov	rdi, rdx
	call	_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE7destroyIS7_EEvRS8_PT_
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3120:
	.section	.gcc_except_table
.LLSDA3120:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE3120-.LLSDACSB3120
.LLSDACSB3120:
.LLSDACSE3120:
	.section	.text._ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE10_M_disposeEv,"axG",@progbits,_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE10_M_disposeEv,comdat
	.size	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE10_M_disposeEv, .-_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE10_M_disposeEv
	.section	.text._ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv,"axG",@progbits,_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv,comdat
	.align 2
	.weak	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv
	.type	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv, @function
_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv:
.LFB3121:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA3121
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	mov	QWORD PTR [rbp-24], rdi
	mov	rax, QWORD PTR [rbp-24]
	lea	rdx, [rax+16]
	lea	rax, [rbp-1]
	mov	rsi, rdx
	mov	rdi, rax
	call	_ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEEC1IS7_EERKSaIT_E
	mov	rdx, QWORD PTR [rbp-24]
	lea	rax, [rbp-1]
	mov	rsi, rdx
	mov	rdi, rax
	call	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE7destroyISC_EEvRSD_PT_
	mov	rcx, QWORD PTR [rbp-24]
	lea	rax, [rbp-1]
	mov	edx, 1
	mov	rsi, rcx
	mov	rdi, rax
	call	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE10deallocateERSD_PSC_m
	lea	rax, [rbp-1]
	mov	rdi, rax
	call	_ZNSaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EEED1Ev
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3121:
	.section	.gcc_except_table
.LLSDA3121:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE3121-.LLSDACSB3121
.LLSDACSB3121:
.LLSDACSE3121:
	.section	.text._ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv,"axG",@progbits,_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv,comdat
	.size	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv, .-_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE10_M_destroyEv
	.section	.text._ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info,"axG",@progbits,_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info,comdat
	.align 2
	.weak	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info
	.type	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info, @function
_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info:
.LFB3122:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rax, QWORD PTR [rbp-16]
	mov	esi, OFFSET FLAT:_ZTISt19_Sp_make_shared_tag
	mov	rdi, rax
	call	_ZNKSt9type_infoeqERKS_
	test	al, al
	je	.L230
	mov	rax, QWORD PTR [rbp-8]
	add	rax, 24
	jmp	.L231
.L230:
	mov	eax, 0
.L231:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3122:
	.size	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info, .-_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EE14_M_get_deleterERKSt9type_info
	.section	.text._ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEE6_M_runEv,"axG",@progbits,_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEE6_M_runEv,comdat
	.align 2
	.weak	_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEE6_M_runEv
	.type	_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEE6_M_runEv, @function
_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEE6_M_runEv:
.LFB3123:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	add	rax, 24
	mov	rdi, rax
	call	_ZNSt12_Bind_simpleIFPFviEiEEclEv
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3123:
	.size	_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEE6_M_runEv, .-_ZNSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEE6_M_runEv
	.section	.text._ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE7destroyIS7_EEvRS8_PT_,"axG",@progbits,_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE7destroyIS7_EEvRS8_PT_,comdat
	.weak	_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE7destroyIS7_EEvRS8_PT_
	.type	_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE7destroyIS7_EEvRS8_PT_, @function
_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE7destroyIS7_EEvRS8_PT_:
.LFB3124:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rdx, QWORD PTR [rbp-16]
	mov	rax, QWORD PTR [rbp-8]
	mov	rsi, rdx
	mov	rdi, rax
	call	_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE10_S_destroyIS7_EENSt9enable_ifIXsrNS9_16__destroy_helperIT_EE5valueEvE4typeERS8_PSD_
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3124:
	.size	_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE7destroyIS7_EEvRS8_PT_, .-_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE7destroyIS7_EEvRS8_PT_
	.section	.text._ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE7destroyISC_EEvRSD_PT_,"axG",@progbits,_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE7destroyISC_EEvRSD_PT_,comdat
	.weak	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE7destroyISC_EEvRSD_PT_
	.type	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE7destroyISC_EEvRSD_PT_, @function
_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE7destroyISC_EEvRSD_PT_:
.LFB3125:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rdx, QWORD PTR [rbp-16]
	mov	rax, QWORD PTR [rbp-8]
	mov	rsi, rdx
	mov	rdi, rax
	call	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE10_S_destroyISC_EENSt9enable_ifIXsrNSE_16__destroy_helperIT_EE5valueEvE4typeERSD_PSI_
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3125:
	.size	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE7destroyISC_EEvRSD_PT_, .-_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE7destroyISC_EEvRSD_PT_
	.section	.text._ZNSt12_Bind_simpleIFPFviEiEEclEv,"axG",@progbits,_ZNSt12_Bind_simpleIFPFviEiEEclEv,comdat
	.align 2
	.weak	_ZNSt12_Bind_simpleIFPFviEiEEclEv
	.type	_ZNSt12_Bind_simpleIFPFviEiEEclEv, @function
_ZNSt12_Bind_simpleIFPFviEiEEclEv:
.LFB3126:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA3126
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 32
	mov	QWORD PTR [rbp-24], rdi
	mov	rax, QWORD PTR [rbp-24]
	mov	BYTE PTR [rsp], dl
	mov	rdi, rax
.LEHB24:
	call	_ZNSt12_Bind_simpleIFPFviEiEE9_M_invokeIILm0EEEEvSt12_Index_tupleIIXspT_EEE
.LEHE24:
	jmp	.L240
.L239:
	mov	rdi, rax
.LEHB25:
	call	_Unwind_Resume
.LEHE25:
.L240:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3126:
	.section	.gcc_except_table
.LLSDA3126:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE3126-.LLSDACSB3126
.LLSDACSB3126:
	.uleb128 .LEHB24-.LFB3126
	.uleb128 .LEHE24-.LEHB24
	.uleb128 .L239-.LFB3126
	.uleb128 0
	.uleb128 .LEHB25-.LFB3126
	.uleb128 .LEHE25-.LEHB25
	.uleb128 0
	.uleb128 0
.LLSDACSE3126:
	.section	.text._ZNSt12_Bind_simpleIFPFviEiEEclEv,"axG",@progbits,_ZNSt12_Bind_simpleIFPFviEiEEclEv,comdat
	.size	_ZNSt12_Bind_simpleIFPFviEiEEclEv, .-_ZNSt12_Bind_simpleIFPFviEiEEclEv
	.section	.text._ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE10_S_destroyIS7_EENSt9enable_ifIXsrNS9_16__destroy_helperIT_EE5valueEvE4typeERS8_PSD_,"axG",@progbits,_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE10_S_destroyIS7_EENSt9enable_ifIXsrNS9_16__destroy_helperIT_EE5valueEvE4typeERS8_PSD_,comdat
	.weak	_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE10_S_destroyIS7_EENSt9enable_ifIXsrNS9_16__destroy_helperIT_EE5valueEvE4typeERS8_PSD_
	.type	_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE10_S_destroyIS7_EENSt9enable_ifIXsrNS9_16__destroy_helperIT_EE5valueEvE4typeERS8_PSD_, @function
_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE10_S_destroyIS7_EENSt9enable_ifIXsrNS9_16__destroy_helperIT_EE5valueEvE4typeERS8_PSD_:
.LFB3127:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rdx, QWORD PTR [rbp-16]
	mov	rax, QWORD PTR [rbp-8]
	mov	rsi, rdx
	mov	rdi, rax
	call	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEE7destroyIS8_EEvPT_
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3127:
	.size	_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE10_S_destroyIS7_EENSt9enable_ifIXsrNS9_16__destroy_helperIT_EE5valueEvE4typeERS8_PSD_, .-_ZNSt16allocator_traitsISaINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEEE10_S_destroyIS7_EENSt9enable_ifIXsrNS9_16__destroy_helperIT_EE5valueEvE4typeERS8_PSD_
	.section	.text._ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE10_S_destroyISC_EENSt9enable_ifIXsrNSE_16__destroy_helperIT_EE5valueEvE4typeERSD_PSI_,"axG",@progbits,_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE10_S_destroyISC_EENSt9enable_ifIXsrNSE_16__destroy_helperIT_EE5valueEvE4typeERSD_PSI_,comdat
	.weak	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE10_S_destroyISC_EENSt9enable_ifIXsrNSE_16__destroy_helperIT_EE5valueEvE4typeERSD_PSI_
	.type	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE10_S_destroyISC_EENSt9enable_ifIXsrNSE_16__destroy_helperIT_EE5valueEvE4typeERSD_PSI_, @function
_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE10_S_destroyISC_EENSt9enable_ifIXsrNSE_16__destroy_helperIT_EE5valueEvE4typeERSD_PSI_:
.LFB3128:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rdx, QWORD PTR [rbp-16]
	mov	rax, QWORD PTR [rbp-8]
	mov	rsi, rdx
	mov	rdi, rax
	call	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE7destroyISC_EEvPT_
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3128:
	.size	_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE10_S_destroyISC_EENSt9enable_ifIXsrNSE_16__destroy_helperIT_EE5valueEvE4typeERSD_PSI_, .-_ZNSt16allocator_traitsISaISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS8_ELN9__gnu_cxx12_Lock_policyE2EEEE10_S_destroyISC_EENSt9enable_ifIXsrNSE_16__destroy_helperIT_EE5valueEvE4typeERSD_PSI_
	.section	.text._ZSt12__get_helperILm0EPFviEIiEENSt9__add_refIT0_E4typeERSt11_Tuple_implIXT_EIS3_DpT1_EE,"axG",@progbits,_ZSt12__get_helperILm0EPFviEIiEENSt9__add_refIT0_E4typeERSt11_Tuple_implIXT_EIS3_DpT1_EE,comdat
	.weak	_ZSt12__get_helperILm0EPFviEIiEENSt9__add_refIT0_E4typeERSt11_Tuple_implIXT_EIS3_DpT1_EE
	.type	_ZSt12__get_helperILm0EPFviEIiEENSt9__add_refIT0_E4typeERSt11_Tuple_implIXT_EIS3_DpT1_EE, @function
_ZSt12__get_helperILm0EPFviEIiEENSt9__add_refIT0_E4typeERSt11_Tuple_implIXT_EIS3_DpT1_EE:
.LFB3131:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZNSt11_Tuple_implILm0EIPFviEiEE7_M_headERS2_
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3131:
	.size	_ZSt12__get_helperILm0EPFviEIiEENSt9__add_refIT0_E4typeERSt11_Tuple_implIXT_EIS3_DpT1_EE, .-_ZSt12__get_helperILm0EPFviEIiEENSt9__add_refIT0_E4typeERSt11_Tuple_implIXT_EIS3_DpT1_EE
	.weak	_ZSt12__get_helperILm0EPFviEJiEENSt9__add_refIT0_E4typeERSt11_Tuple_implIXT_EJS3_DpT1_EE
	.set	_ZSt12__get_helperILm0EPFviEJiEENSt9__add_refIT0_E4typeERSt11_Tuple_implIXT_EJS3_DpT1_EE,_ZSt12__get_helperILm0EPFviEIiEENSt9__add_refIT0_E4typeERSt11_Tuple_implIXT_EIS3_DpT1_EE
	.section	.text._ZSt3getILm0EIPFviEiEENSt9__add_refINSt13tuple_elementIXT_ESt5tupleIIDpT0_EEE4typeEE4typeERS7_,"axG",@progbits,_ZSt3getILm0EIPFviEiEENSt9__add_refINSt13tuple_elementIXT_ESt5tupleIIDpT0_EEE4typeEE4typeERS7_,comdat
	.weak	_ZSt3getILm0EIPFviEiEENSt9__add_refINSt13tuple_elementIXT_ESt5tupleIIDpT0_EEE4typeEE4typeERS7_
	.type	_ZSt3getILm0EIPFviEiEENSt9__add_refINSt13tuple_elementIXT_ESt5tupleIIDpT0_EEE4typeEE4typeERS7_, @function
_ZSt3getILm0EIPFviEiEENSt9__add_refINSt13tuple_elementIXT_ESt5tupleIIDpT0_EEE4typeEE4typeERS7_:
.LFB3130:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZSt12__get_helperILm0EPFviEIiEENSt9__add_refIT0_E4typeERSt11_Tuple_implIXT_EIS3_DpT1_EE
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3130:
	.size	_ZSt3getILm0EIPFviEiEENSt9__add_refINSt13tuple_elementIXT_ESt5tupleIIDpT0_EEE4typeEE4typeERS7_, .-_ZSt3getILm0EIPFviEiEENSt9__add_refINSt13tuple_elementIXT_ESt5tupleIIDpT0_EEE4typeEE4typeERS7_
	.weak	_ZSt3getILm0EJPFviEiEENSt9__add_refINSt13tuple_elementIXT_ESt5tupleIJDpT0_EEE4typeEE4typeERS7_
	.set	_ZSt3getILm0EJPFviEiEENSt9__add_refINSt13tuple_elementIXT_ESt5tupleIJDpT0_EEE4typeEE4typeERS7_,_ZSt3getILm0EIPFviEiEENSt9__add_refINSt13tuple_elementIXT_ESt5tupleIIDpT0_EEE4typeEE4typeERS7_
	.section	.text._ZSt12__get_helperILm1EiIEENSt9__add_refIT0_E4typeERSt11_Tuple_implIXT_EIS1_DpT1_EE,"axG",@progbits,_ZSt12__get_helperILm1EiIEENSt9__add_refIT0_E4typeERSt11_Tuple_implIXT_EIS1_DpT1_EE,comdat
	.weak	_ZSt12__get_helperILm1EiIEENSt9__add_refIT0_E4typeERSt11_Tuple_implIXT_EIS1_DpT1_EE
	.type	_ZSt12__get_helperILm1EiIEENSt9__add_refIT0_E4typeERSt11_Tuple_implIXT_EIS1_DpT1_EE, @function
_ZSt12__get_helperILm1EiIEENSt9__add_refIT0_E4typeERSt11_Tuple_implIXT_EIS1_DpT1_EE:
.LFB3133:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZNSt11_Tuple_implILm1EIiEE7_M_headERS0_
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3133:
	.size	_ZSt12__get_helperILm1EiIEENSt9__add_refIT0_E4typeERSt11_Tuple_implIXT_EIS1_DpT1_EE, .-_ZSt12__get_helperILm1EiIEENSt9__add_refIT0_E4typeERSt11_Tuple_implIXT_EIS1_DpT1_EE
	.weak	_ZSt12__get_helperILm1EiJEENSt9__add_refIT0_E4typeERSt11_Tuple_implIXT_EJS1_DpT1_EE
	.set	_ZSt12__get_helperILm1EiJEENSt9__add_refIT0_E4typeERSt11_Tuple_implIXT_EJS1_DpT1_EE,_ZSt12__get_helperILm1EiIEENSt9__add_refIT0_E4typeERSt11_Tuple_implIXT_EIS1_DpT1_EE
	.section	.text._ZSt3getILm1EIPFviEiEENSt9__add_refINSt13tuple_elementIXT_ESt5tupleIIDpT0_EEE4typeEE4typeERS7_,"axG",@progbits,_ZSt3getILm1EIPFviEiEENSt9__add_refINSt13tuple_elementIXT_ESt5tupleIIDpT0_EEE4typeEE4typeERS7_,comdat
	.weak	_ZSt3getILm1EIPFviEiEENSt9__add_refINSt13tuple_elementIXT_ESt5tupleIIDpT0_EEE4typeEE4typeERS7_
	.type	_ZSt3getILm1EIPFviEiEENSt9__add_refINSt13tuple_elementIXT_ESt5tupleIIDpT0_EEE4typeEE4typeERS7_, @function
_ZSt3getILm1EIPFviEiEENSt9__add_refINSt13tuple_elementIXT_ESt5tupleIIDpT0_EEE4typeEE4typeERS7_:
.LFB3132:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	rax, QWORD PTR [rbp-8]
	mov	rdi, rax
	call	_ZSt12__get_helperILm1EiIEENSt9__add_refIT0_E4typeERSt11_Tuple_implIXT_EIS1_DpT1_EE
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3132:
	.size	_ZSt3getILm1EIPFviEiEENSt9__add_refINSt13tuple_elementIXT_ESt5tupleIIDpT0_EEE4typeEE4typeERS7_, .-_ZSt3getILm1EIPFviEiEENSt9__add_refINSt13tuple_elementIXT_ESt5tupleIIDpT0_EEE4typeEE4typeERS7_
	.weak	_ZSt3getILm1EJPFviEiEENSt9__add_refINSt13tuple_elementIXT_ESt5tupleIJDpT0_EEE4typeEE4typeERS7_
	.set	_ZSt3getILm1EJPFviEiEENSt9__add_refINSt13tuple_elementIXT_ESt5tupleIJDpT0_EEE4typeEE4typeERS7_,_ZSt3getILm1EIPFviEiEENSt9__add_refINSt13tuple_elementIXT_ESt5tupleIIDpT0_EEE4typeEE4typeERS7_
	.section	.text._ZNSt12_Bind_simpleIFPFviEiEE9_M_invokeIILm0EEEEvSt12_Index_tupleIIXspT_EEE,"axG",@progbits,_ZNSt12_Bind_simpleIFPFviEiEE9_M_invokeIILm0EEEEvSt12_Index_tupleIIXspT_EEE,comdat
	.align 2
	.weak	_ZNSt12_Bind_simpleIFPFviEiEE9_M_invokeIILm0EEEEvSt12_Index_tupleIIXspT_EEE
	.type	_ZNSt12_Bind_simpleIFPFviEiEE9_M_invokeIILm0EEEEvSt12_Index_tupleIIXspT_EEE, @function
_ZNSt12_Bind_simpleIFPFviEiEE9_M_invokeIILm0EEEEvSt12_Index_tupleIIXspT_EEE:
.LFB3129:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	push	rbx
	sub	rsp, 24
	.cfi_offset 3, -24
	mov	QWORD PTR [rbp-24], rdi
	mov	rax, QWORD PTR [rbp-24]
	mov	rdi, rax
	call	_ZSt3getILm0EIPFviEiEENSt9__add_refINSt13tuple_elementIXT_ESt5tupleIIDpT0_EEE4typeEE4typeERS7_
	mov	rdi, rax
	call	_ZSt7forwardIPFviEEOT_RNSt16remove_referenceIS2_E4typeE
	mov	rbx, QWORD PTR [rax]
	mov	rax, QWORD PTR [rbp-24]
	mov	rdi, rax
	call	_ZSt3getILm1EIPFviEiEENSt9__add_refINSt13tuple_elementIXT_ESt5tupleIIDpT0_EEE4typeEE4typeERS7_
	mov	rdi, rax
	call	_ZSt7forwardIiEOT_RNSt16remove_referenceIS0_E4typeE
	mov	eax, DWORD PTR [rax]
	mov	edi, eax
	call	rbx
	add	rsp, 24
	pop	rbx
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3129:
	.size	_ZNSt12_Bind_simpleIFPFviEiEE9_M_invokeIILm0EEEEvSt12_Index_tupleIIXspT_EEE, .-_ZNSt12_Bind_simpleIFPFviEiEE9_M_invokeIILm0EEEEvSt12_Index_tupleIIXspT_EEE
	.weak	_ZNSt12_Bind_simpleIFPFviEiEE9_M_invokeIJLm0EEEEvSt12_Index_tupleIJXspT_EEE
	.set	_ZNSt12_Bind_simpleIFPFviEiEE9_M_invokeIJLm0EEEEvSt12_Index_tupleIJXspT_EEE,_ZNSt12_Bind_simpleIFPFviEiEE9_M_invokeIILm0EEEEvSt12_Index_tupleIIXspT_EEE
	.section	.text._ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEE7destroyIS8_EEvPT_,"axG",@progbits,_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEE7destroyIS8_EEvPT_,comdat
	.align 2
	.weak	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEE7destroyIS8_EEvPT_
	.type	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEE7destroyIS8_EEvPT_, @function
_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEE7destroyIS8_EEvPT_:
.LFB3134:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rax, QWORD PTR [rbp-16]
	mov	rax, QWORD PTR [rax]
	mov	rax, QWORD PTR [rax]
	mov	rdx, QWORD PTR [rbp-16]
	mov	rdi, rdx
	call	rax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3134:
	.size	_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEE7destroyIS8_EEvPT_, .-_ZN9__gnu_cxx13new_allocatorINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEEE7destroyIS8_EEvPT_
	.section	.text._ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE7destroyISC_EEvPT_,"axG",@progbits,_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE7destroyISC_EEvPT_,comdat
	.align 2
	.weak	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE7destroyISC_EEvPT_
	.type	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE7destroyISC_EEvPT_, @function
_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE7destroyISC_EEvPT_:
.LFB3135:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	QWORD PTR [rbp-8], rdi
	mov	QWORD PTR [rbp-16], rsi
	mov	rax, QWORD PTR [rbp-16]
	mov	rdi, rax
	call	_ZNSt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS7_ELN9__gnu_cxx12_Lock_policyE2EED1Ev
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3135:
	.size	_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE7destroyISC_EEvPT_, .-_ZN9__gnu_cxx13new_allocatorISt23_Sp_counted_ptr_inplaceINSt6thread5_ImplISt12_Bind_simpleIFPFviEiEEEESaIS9_ELNS_12_Lock_policyE2EEE7destroyISC_EEvPT_
	.weak	_ZTSSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE
	.section	.rodata._ZTSSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE,"aG",@progbits,_ZTSSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE,comdat
	.align 32
	.type	_ZTSSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE, @object
	.size	_ZTSSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE, 47
_ZTSSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE:
	.string	"St11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE"
	.weak	_ZTISt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE
	.section	.rodata._ZTISt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE,"aG",@progbits,_ZTISt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE,comdat
	.align 16
	.type	_ZTISt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE, @object
	.size	_ZTISt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE, 16
_ZTISt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE:
	.quad	_ZTVN10__cxxabiv117__class_type_infoE+16
	.quad	_ZTSSt11_Mutex_baseILN9__gnu_cxx12_Lock_policyE2EE
	.text
	.type	_GLOBAL__sub_I_mutex, @function
_GLOBAL__sub_I_mutex:
.LFB3136:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	esi, 65535
	mov	edi, 1
	call	_Z41__static_initialization_and_destruction_0ii
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3136:
	.size	_GLOBAL__sub_I_mutex, .-_GLOBAL__sub_I_mutex
	.section	.init_array,"aw"
	.align 8
	.quad	_GLOBAL__sub_I_mutex
	.section	.rodata
	.align 8
	.type	_ZZL18__gthread_active_pvE20__gthread_active_ptr, @object
	.size	_ZZL18__gthread_active_pvE20__gthread_active_ptr, 8
_ZZL18__gthread_active_pvE20__gthread_active_ptr:
	.quad	_ZL28__gthrw___pthread_key_createPjPFvPvE
	.weakref	_ZL28__gthrw___pthread_key_createPjPFvPvE,__pthread_key_create
	.weakref	_ZL21__gthrw_pthread_equalmm,pthread_equal
	.ident	"GCC: (Ubuntu/Linaro 4.8.1-10ubuntu8) 4.8.1"
	.section	.note.GNU-stack,"",@progbits
