#include <stdio.h>
#include "LockType.h"

//#include "pthread_lock.h"
#include "thread_lock.h"
//#include "boost_mutex_lock.h"
#include "atomic_exch_lock-busy.h"
#include "atomic_exch_lock-spin.h"
#include "atomic_tas_lock-busy.h"
#include "atomic_tas_lock-spin.h"
#include "atomic_exch_hle_lock-busy.h"
#include "atomic_exch_hle_lock-spin.h"
#include "atomic_tas_hle_lock-busy.h"
#include "atomic_tas_hle_lock-spin.h"
#include "hle_tas_lock-busy.h"
#include "hle_tas_lock-spin.h"
#include "hle_exch_lock-busy.h"
#include "hle_exch_lock-spin.h"
#include "hle_asm_exch_lock-busy.h"
#include "hle_asm_exch_lock-spin.h"
#include "hle_asm_exch_lock-asm_spin.h"

LockType::LockType() {
	this->lock = this->unlock = NULL;
	this->type_lock_function = this->type_unlock_function = NULL;
}
LockType::LockType(LockType::EnumType enum_type) {
	this->init(enum_type);
}
void LockType::init(LockType::EnumType enum_type) {
	this->enum_type = enum_type;
	// assign type_(un)lock_function
	switch (this->enum_type) {
	case ATOMIC_EXCH_BUSY:
		this->type_lock_function = atomic_exch_lock_busy;
		this->type_unlock_function = atomic_exch_unlock_busy;
		break;
	case ATOMIC_EXCH_SPIN:
		this->type_lock_function = atomic_exch_lock_spin;
		this->type_unlock_function = atomic_exch_unlock_spin;
		break;
	case ATOMIC_TAS_BUSY:
		this->type_lock_function = atomic_tas_lock_busy;
		this->type_unlock_function = atomic_tas_unlock_busy;
		break;
	case ATOMIC_TAS_SPIN:
		this->type_lock_function = atomic_tas_lock_spin;
		this->type_unlock_function = atomic_tas_unlock_spin;
		break;
	case ATOMIC_EXCH_HLE_BUSY:
		this->type_lock_function = atomic_exch_hle_lock_busy;
		this->type_unlock_function = atomic_exch_hle_unlock_busy;
		break;
	case ATOMIC_EXCH_HLE_SPIN:
		this->type_lock_function = atomic_exch_hle_lock_spin;
		this->type_unlock_function = atomic_exch_hle_unlock_spin;
		break;
	case ATOMIC_TAS_HLE_BUSY:
		this->type_lock_function = atomic_tas_hle_lock_busy;
		this->type_unlock_function = atomic_tas_hle_unlock_busy;
		break;
	case ATOMIC_TAS_HLE_SPIN:
		this->type_lock_function = atomic_tas_hle_lock_spin;
		this->type_unlock_function = atomic_tas_hle_unlock_spin;
		break;
	case HLE_TAS_BUSY:
		this->type_lock_function = hle_tas_lock_busy;
		this->type_unlock_function = hle_tas_unlock_busy;
		break;
	case HLE_TAS_SPIN:
		this->type_lock_function = hle_tas_lock_spin;
		this->type_unlock_function = hle_tas_unlock_spin;
		break;
	case HLE_EXCH_BUSY:
		this->type_lock_function = hle_exch_lock_busy;
		this->type_unlock_function = hle_exch_unlock_busy;
		break;
	case HLE_EXCH_SPIN:
		this->type_lock_function = hle_exch_lock_spin;
		this->type_unlock_function = hle_exch_unlock_spin;
		break;
	case HLE_ASM_EXCH_BUSY:
		this->type_lock_function = hle_asm_exch_lock_busy;
		this->type_unlock_function = hle_asm_exch_unlock_busy;
		break;
	case HLE_ASM_EXCH_SPIN:
		this->type_lock_function = hle_asm_exch_lock_spin;
		this->type_unlock_function = hle_asm_exch_unlock_spin;
		break;
	case HLE_ASM_EXCH_ASM_SPIN:
		this->type_lock_function = hle_asm_exch_lock_asm_spin;
		this->type_unlock_function = hle_asm_exch_unlock_asm_spin;
		break;
	}

	// assign (un)lock
	switch (this->enum_type) {
	case PTHREAD:
		this->lock = &LockType::pthread_lock;
		this->unlock = &LockType::pthread_unlock;
		break;
	case CPP11MUTEX:
		this->lock = &LockType::cpp11_lock;
		this->unlock = &LockType::cpp11_unlock;
		break;
	case BOOST_MUTEX:
		this->lock = &LockType::boost_mutex_lock;
		this->unlock = &LockType::boost_mutex_unlock;
		break;
	case RTM:
		this->lock = this->unlock = NULL;
		this->type_lock_function = this->type_unlock_function = NULL;
		break;
	case ATOMIC_EXCH_BUSY:
	case ATOMIC_EXCH_SPIN:
	case ATOMIC_EXCH_HLE_BUSY:
	case ATOMIC_EXCH_HLE_SPIN:
	case ATOMIC_TAS_BUSY:
	case ATOMIC_TAS_SPIN:
	case ATOMIC_TAS_HLE_BUSY:
	case ATOMIC_TAS_HLE_SPIN:
	case HLE_TAS_BUSY:
	case HLE_TAS_SPIN:
	case HLE_EXCH_BUSY:
	case HLE_EXCH_SPIN:
	case HLE_ASM_EXCH_BUSY:
	case HLE_ASM_EXCH_SPIN:
	case HLE_ASM_EXCH_ASM_SPIN:
		this->lock = &LockType::type_lock;
		this->unlock = &LockType::type_unlock;
		break;
	}
}

// pthread
void LockType::pthread_lock() {
//	pthread_lock(&this->p_mutex); // perform immediate call
	pthread_mutex_lock(&this->p_mutex);
}
void LockType::pthread_unlock() {
	pthread_mutex_unlock(&this->p_mutex);
}
// cpp11
void LockType::cpp11_lock() {
//	thread_lock(&this->cpp11_mutex);
}
void LockType::cpp11_unlock() {
//	thread_unlock(&this->cpp11_mutex);
}
void LockType::boost_mutex_lock() {
//	boost_mutex_lock(&this->boost_mutex);
}
void LockType::boost_mutex_unlock() {
//	boost_mutex_unlock(&this->boost_mutex);
}
// type
void LockType::type_lock() {
//	printf("Attempting to lock %p (%d)\n", &this->type_mutex, this->type_mutex);
	(*this->type_lock_function)(&this->type_mutex);
}
void LockType::type_unlock() {
	(*this->type_unlock_function)(&this->type_mutex);
}

void LockType::printHeader(LockType *lockTypes[], int size, FILE *out) {
	printHeader(*lockTypes, size, out);
}
void LockType::printHeader(LockType lockTypes[], int size, FILE *out) {
	printHeaderRange(lockTypes, 0, size, out);
}
void LockType::printHeaderRange(LockType lockTypes[], int from, int to,
		FILE *out) {
	for (int t = from; t < to; t++) {
		fprintf(out, "%s", LockType::getEnumText(lockTypes[t].enum_type));
		fprintf(out, "%s", t < to - 1 ? ";" : "\n");
	}
}

const char* LockType::getEnumText(LockType::EnumType e) {
	switch (e) {
	case PTHREAD:
		return "POSIX Thread";
	case CPP11MUTEX:
		return "CPP11 Mutex";
	case BOOST_MUTEX:
		return "BOOST_MUTEX";
	case ATOMIC_EXCH_BUSY:
		return "atomic_EXCH_BUSY";
	case ATOMIC_EXCH_SPIN:
		return "atomic_EXCH_SPIN";
	case ATOMIC_EXCH_HLE_BUSY:
		return "atomic_EXCH_HLE-busy";
	case ATOMIC_EXCH_HLE_SPIN:
		return "atomic_EXCH_HLE-spin";
	case ATOMIC_TAS_BUSY:
		return "atomic_TAS_BUSY";
	case ATOMIC_TAS_SPIN:
		return "atomic_TAS_SPIN";
	case ATOMIC_TAS_HLE_BUSY:
		return "atomic_TAS_HLE_BUSY";
	case ATOMIC_TAS_HLE_SPIN:
		return "atomic_TAS_HLE_SPIN";
	case RTM:
		return "RTM";
	case HLE_TAS_BUSY:
		return "HLE_TAS_BUSY";
	case HLE_TAS_SPIN:
		return "HLE_TAS_SPIN";
	case HLE_EXCH_BUSY:
		return "HLE_EXCH_BUSY";
	case HLE_EXCH_SPIN:
		return "HLE_EXCH_SPIN";
	case HLE_ASM_EXCH_BUSY:
		return "HLE_ASM_EXCH-busy";
	case HLE_ASM_EXCH_SPIN:
		return "HLE_ASM_EXCH-spin";
	case HLE_ASM_EXCH_ASM_SPIN:
		return "HLE_ASM_EXCH-asm_spin";
	}
}
