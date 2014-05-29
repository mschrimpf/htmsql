#include <stdio.h>
#include "LockType.h"

//#include "pthread_lock.h"
#include "thread_lock.h"
//#include "boost_mutex_lock.h"
#include "atomic_exch_lock-busy.h"
#include "atomic_exch_lock-spec.h"
#include "atomic_tas_lock-busy.h"
#include "atomic_tas_lock-spec.h"
#include "atomic_exch_hle_lock-busy.h"
#include "atomic_exch_hle_lock-spec.h"
#include "atomic_tas_hle_lock-busy.h"
#include "atomic_tas_hle_lock-spec.h"
#include "hle_tas_lock-busy.h"
#include "hle_tas_lock-spec.h"
#include "hle_exch_lock-busy.h"
#include "hle_exch_lock-spec.h"
#include "hle_exch_lock-spec-checked.h"
#include "hle_asm_exch_lock-busy.h"
#include "hle_asm_exch_lock-spec.h"
#include "hle_asm_exch_lock-asm_spec.h"

LockType::LockType() {
	this->lock = this->unlock = NULL;
	this->type_lock_function = this->type_unlock_function = NULL;
}
LockType::LockType(LockType::EnumType enum_type) {
	this->init(enum_type);
}
void LockType::init(LockType::EnumType enum_type) {
	this->enum_type = enum_type;

	// assign lock-functions
	switch (this->enum_type) {
	case NONE:
		this->lock = &LockType::no_lock;
		this->unlock = &LockType::no_unlock;
		break;
	case PTHREAD:
		this->lock = &LockType::pthread_lock;
		this->unlock = &LockType::pthread_unlock;
		break;
//	case PTHREAD_HLE:
//		this->lock = &LockType::pthread_hle_lock;
//		this->unlock = &LockType::pthread_hle_unlock;
//		break;
	case RTM:
		this->lock = this->unlock = NULL;
		this->type_lock_function = this->type_unlock_function = NULL;
		break;
	case ATOMIC_EXCH_BUSY:
	case ATOMIC_EXCH_SPEC:
	case ATOMIC_EXCH_HLE_BUSY:
	case ATOMIC_EXCH_HLE_SPEC:
	case ATOMIC_TAS_BUSY:
	case ATOMIC_TAS_SPEC:
	case ATOMIC_TAS_HLE_BUSY:
	case ATOMIC_TAS_HLE_SPEC:
	case HLE_TAS_BUSY:
	case HLE_TAS_SPEC:
	case HLE_EXCH_BUSY:
	case HLE_EXCH_SPEC:
	case HLE_EXCH_SPEC_CHECKED:
	case HLE_ASM_EXCH_BUSY:
	case HLE_ASM_EXCH_SPEC:
	case HLE_ASM_EXCH_ASM_SPEC:
		this->lock = &LockType::type_lock;
		this->unlock = &LockType::type_unlock;
		break;
	}

	// assign type_(un)lock_function
	switch (this->enum_type) {
	case ATOMIC_EXCH_BUSY:
		this->type_lock_function = atomic_exch_lock_busy;
		this->type_unlock_function = atomic_exch_unlock_busy;
		break;
	case ATOMIC_EXCH_SPEC:
		this->type_lock_function = atomic_exch_lock_spec;
		this->type_unlock_function = atomic_exch_unlock_spec;
		break;
	case ATOMIC_TAS_BUSY:
		this->type_lock_function = atomic_tas_lock_busy;
		this->type_unlock_function = atomic_tas_unlock_busy;
		break;
	case ATOMIC_TAS_SPEC:
		this->type_lock_function = atomic_tas_lock_spec;
		this->type_unlock_function = atomic_tas_unlock_spec;
		break;
	case ATOMIC_EXCH_HLE_BUSY:
		this->type_lock_function = atomic_exch_hle_lock_busy;
		this->type_unlock_function = atomic_exch_hle_unlock_busy;
		break;
	case ATOMIC_EXCH_HLE_SPEC:
		this->type_lock_function = atomic_exch_hle_lock_spec;
		this->type_unlock_function = atomic_exch_hle_unlock_spec;
		break;
	case ATOMIC_TAS_HLE_BUSY:
		this->type_lock_function = atomic_tas_hle_lock_busy;
		this->type_unlock_function = atomic_tas_hle_unlock_busy;
		break;
	case ATOMIC_TAS_HLE_SPEC:
		this->type_lock_function = atomic_tas_hle_lock_spec;
		this->type_unlock_function = atomic_tas_hle_unlock_spec;
		break;
	case HLE_TAS_BUSY:
		this->type_lock_function = hle_tas_lock_busy;
		this->type_unlock_function = hle_tas_unlock_busy;
		break;
	case HLE_TAS_SPEC:
		this->type_lock_function = hle_tas_lock_spec;
		this->type_unlock_function = hle_tas_unlock_spec;
		break;
	case HLE_EXCH_BUSY:
		this->type_lock_function = hle_exch_lock_busy;
		this->type_unlock_function = hle_exch_unlock_busy;
		break;
	case HLE_EXCH_SPEC:
		this->type_lock_function = hle_exch_lock_spec;
		this->type_unlock_function = hle_exch_unlock_spec;
		break;
	case HLE_EXCH_SPEC_CHECKED:
		this->type_lock_function = hle_exch_lock_spec_checked;
		this->type_unlock_function = hle_exch_unlock_spec_checked;
		break;
	case HLE_ASM_EXCH_BUSY:
		this->type_lock_function = hle_asm_exch_lock_busy;
		this->type_unlock_function = hle_asm_exch_unlock_busy;
		break;
	case HLE_ASM_EXCH_SPEC:
		this->type_lock_function = hle_asm_exch_lock_spec;
		this->type_unlock_function = hle_asm_exch_unlock_spec;
		break;
	case HLE_ASM_EXCH_ASM_SPEC:
		this->type_lock_function = hle_asm_exch_lock_asm_spec;
		this->type_unlock_function = hle_asm_exch_unlock_asm_spec;
		break;
	}
}

// unsynchronized
void LockType::no_lock() {
//	printf("Doing nothing\n");
}
void LockType::no_unlock() {
}
// pthread
void LockType::pthread_lock() {
	pthread_mutex_lock(&this->p_mutex);
}
void LockType::pthread_unlock() {
	pthread_mutex_unlock(&this->p_mutex);
}
// pthread hle
//void LockType::pthread_hle_lock() {
//	pthread_mutex_lock(&this->p_mutex_hle);
//}
//void LockType::pthread_hle_unlock() {
//	pthread_mutex_unlock(&this->p_mutex_hle);
//}
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
void LockType::printHeader(LockType *lockTypes[], int size, const char *appendings[],
		int appendings_length, FILE *out) {
	printHeader(*lockTypes, size, appendings, appendings_length, out);
}
void LockType::printHeader(LockType lockTypes[], int size, const char *appendings[],
		int appendings_length, FILE *out) {
	printHeaderRange(lockTypes, 0, size, appendings, appendings_length, out);
}
void LockType::printHeaderRange(LockType lockTypes[], int from, int to,
		const char *appendings[], int appendings_length, FILE *out) {
	for (int t = from; t < to; t++) {
		for (int a = 0; a < appendings_length; a++) {
			fprintf(out, "%s", LockType::getEnumText(lockTypes[t].enum_type));
			fprintf(out, " %s", appendings[a]);
			fprintf(out, "%s",
					a < appendings_length - 1 || t < to - 1 ? ";" : "\n");
		}
	}
}

const char* LockType::getEnumText(LockType::EnumType e) {
	switch (e) {
	case NONE:
		return "No synchronization";
	case PTHREAD:
		return "POSIX Thread";
//	case PTHREAD_HLE:
//		return "POSIX Thread HLE";
	case ATOMIC_EXCH_BUSY:
		return "atomic_EXCH_BUSY";
	case ATOMIC_EXCH_SPEC:
		return "atomic_EXCH_SPEC";
	case ATOMIC_EXCH_HLE_BUSY:
		return "atomic_EXCH_HLE-busy";
	case ATOMIC_EXCH_HLE_SPEC:
		return "atomic_EXCH_HLE-spec";
	case ATOMIC_TAS_BUSY:
		return "atomic_TAS_BUSY";
	case ATOMIC_TAS_SPEC:
		return "atomic_TAS_SPEC";
	case ATOMIC_TAS_HLE_BUSY:
		return "atomic_TAS_HLE_BUSY";
	case ATOMIC_TAS_HLE_SPEC:
		return "atomic_TAS_HLE_SPEC";
	case RTM:
		return "RTM";
	case HLE_TAS_BUSY:
		return "HLE_TAS_BUSY";
	case HLE_TAS_SPEC:
		return "HLE_TAS_SPEC";
	case HLE_EXCH_BUSY:
		return "HLE_EXCH_BUSY";
	case HLE_EXCH_SPEC:
		return "HLE_EXCH_SPEC";
	case HLE_EXCH_SPEC_CHECKED:
		return "HLE_EXCH_SPEC_CHECKED";
	case HLE_ASM_EXCH_BUSY:
		return "HLE_ASM_EXCH-busy";
	case HLE_ASM_EXCH_SPEC:
		return "HLE_ASM_EXCH-spec";
	case HLE_ASM_EXCH_ASM_SPEC:
		return "HLE_ASM_EXCH-asm_spec";
	}
}
