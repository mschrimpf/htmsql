#include <stdio.h>
#include "LockType.h"

//#include <immintrin.h> // RTM: _x
//#include "pthread_lock.h"
#include "thread_lock.h"
#include "atomic_exch_lock.h"
#include "atomic_exch_hle_lock.h"
#include "atomic_exch_hle_lock2.h"
#include "atomic_tas_lock.h"
#include "atomic_tas_hle_lock.h"
#include "hle_tas_lock.h"
#include "hle_exch_lock.h"
#include "hle_asm_exch_lock.h"

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
	case ATOMIC_EXCH:
		this->type_lock_function = atomic_exch_lock;
		this->type_unlock_function = atomic_exch_unlock;
		break;
	case ATOMIC_EXCH_HLE:
		this->type_lock_function = atomic_exch_hle_lock;
		this->type_unlock_function = atomic_exch_hle_unlock;
		break;
	case ATOMIC_EXCH_HLE2:
		this->type_lock_function = atomic_exch_hle_lock2;
		this->type_unlock_function = atomic_exch_hle_unlock2;
		break;
	case ATOMIC_TAS:
		this->type_lock_function = atomic_tas_lock;
		this->type_unlock_function = atomic_tas_unlock;
		break;
	case ATOMIC_TAS_HLE:
		this->type_lock_function = atomic_tas_hle_lock;
		this->type_unlock_function = atomic_tas_hle_unlock;
		break;
	case HLE_TAS:
		this->type_lock_function = hle_tas_lock;
		this->type_unlock_function = hle_tas_unlock;
		break;
	case HLE_EXCH:
		this->type_lock_function = hle_exch_lock;
		this->type_unlock_function = hle_exch_unlock;
		break;
	case HLE_ASM_EXCH:
		this->type_lock_function = hle_asm_exch_lock;
		this->type_unlock_function = hle_asm_exch_unlock;
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
	case RTM:
		this->lock = this->unlock = NULL;
		this->type_lock_function = this->type_unlock_function = NULL;
		break;
	case ATOMIC_EXCH:
	case ATOMIC_EXCH_HLE:
	case ATOMIC_EXCH_HLE2:
	case ATOMIC_TAS:
	case ATOMIC_TAS_HLE:
	case HLE_TAS:
	case HLE_EXCH:
	case HLE_ASM_EXCH:
		this->lock = &LockType::type_lock;
		this->unlock = &LockType::type_unlock;
		break;
	}
}

// pthread
void LockType::pthread_lock() {
//	pthread_lock(&this->p_mutex);
	pthread_mutex_lock(&this->p_mutex);
}
void LockType::pthread_unlock() {
	pthread_mutex_unlock(&this->p_mutex);
}
// cpp11
void LockType::cpp11_lock() {
	thread_lock(&this->cpp11_mutex);
}
void LockType::cpp11_unlock() {
	thread_unlock(&this->cpp11_mutex);
}
// type
void LockType::type_lock() {
//	printf("Attempting to lock %p (%d)\n", &this->type_mutex, this->type_mutex);
	(*this->type_lock_function)(&this->type_mutex);
}
void LockType::type_unlock() {
	(*this->type_unlock_function)(&this->type_mutex);
}

//const LockType LockType::PTHREAD = LockType(pthread_lock, pthread_unlock);
//const LockType LockType::CPP11MUTEX = LockType(thread_lock, thread_unlock);
//const LockType LockType::ATOMIC_EXCH = LockType(atomic_exch_lock,
//		atomic_exch_unlock);
//const LockType LockType::ATOMIC_EXCH_HLE = LockType(atomic_exch_hle_lock,
//		atomic_exch_hle_unlock);
//const LockType LockType::ATOMIC_EXCH_HLE2 = LockType(atomic_exch_hle_lock2,
//		atomic_exch_hle_unlock2);
//const LockType LockType::ATOMIC_TAS = LockType(atomic_tas_lock,
//		atomic_tas_unlock);
//const LockType LockType::ATOMIC_TAS_HLE = LockType(atomic_tas_hle_lock,
//		atomic_tas_hle_unlock);
//const LockType LockType::RTM = LockType(NULL, NULL);
//const LockType LockType::HLE_TAS = LockType(hle_tas_lock, hle_tas_unlock);
//const LockType LockType::HLE_EXCH = LockType(hle_exch_lock, hle_exch_unlock);

void LockType::printHeader(LockType *lockTypes[], int size, FILE *out) {
	printHeader(*lockTypes, size, out);
}

void LockType::printHeader(LockType lockTypes[], int size, FILE *out) {
	for (int t = 0; t < size; t++) {
		fprintf(out, "%s", LockType::getEnumText(lockTypes[t].enum_type));
		fprintf(out, "%s", t < size - 1 ? ";" : "\n");
	}
}

const char* LockType::getEnumText(LockType::EnumType e) {
	switch (e) {
	case PTHREAD:
		return "POSIX Thread";
	case CPP11MUTEX:
		return "CPP11 Mutex";
	case ATOMIC_EXCH:
		return "atomic_EXCH";
	case ATOMIC_EXCH_HLE:
		return "atomic_EXCH_HLE";
	case ATOMIC_EXCH_HLE2:
		return "atomic_EXCH_HLE2";
	case ATOMIC_TAS:
		return "atomic_TAS";
	case ATOMIC_TAS_HLE:
		return "atomic_TAS_HLE";
	case RTM:
		return "RTM";
	case HLE_TAS:
		return "HLE_TAS";
	case HLE_EXCH:
		return "HLE_EXCH";
	case HLE_ASM_EXCH:
		return "HLE_ASM_EXCH";
	}
}
