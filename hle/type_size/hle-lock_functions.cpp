#ifndef HLE_LOCK_FUNCTIONS_H_
#define HLE_LOCK_FUNCTIONS_H_

#include "../lib/hle-emulation.h"
#include <xmmintrin.h> // _mm_pause

#define __HLE_EXCH_LOCK_SPIN(size, type)\
	static void hle_exch_lock_spin##size(void *mutex) {\
		type* lock = (type*) mutex;\
		while(__hle_acquire_exchange_n##size(lock, 1)) {\
			_mm_pause();\
		}\
	}
#define __HLE_EXCH_LOCK_SPEC(size, type)\
	static void hle_exch_lock_spec##size(void *mutex) {\
		type* lock = (type*) mutex;\
		while (__hle_acquire_exchange_n##size(lock, 1)) {\
			type val;\
			do {\
				_mm_pause();\
				__atomic_load(lock, &val, __ATOMIC_CONSUME);\
			} while (val == 1);\
		}\
	}
#define __HLE_EXCH_LOCK_SPEC_NOLOAD(size, type)\
	static void hle_exch_lock_spec_noload##size(void *mutex) {\
		type* lock = (type*) mutex;\
		while (__hle_acquire_exchange_n##size(lock, 1)) {\
			type val;\
			do {\
				_mm_pause();\
				val = *lock;\
			} while (val == 1);\
		}\
	}

#define __HLE_TAS_LOCK_SPIN(size, type)\
	static void hle_tas_lock_spin##size(void *mutex) {\
		type* lock = (type*) mutex;\
		while(__hle_acquire_test_and_set##size(lock)) {\
			_mm_pause();\
		}\
	}
#define __HLE_TAS_LOCK_SPEC(size, type)\
	static void hle_tas_lock_spec##size(void *mutex) {\
		type* lock = (type*) mutex;\
		while (__hle_acquire_test_and_set##size(lock)) {\
			type val;\
			do {\
				_mm_pause();\
				__atomic_load(lock, &val, __ATOMIC_CONSUME);\
			} while (val == 1);\
		}\
	}

#define __HLE_EXCH_UNLOCK(size, type)\
	static void hle_unlock##size(void *mutex) {\
		type* lock = (type*) mutex;\
		__hle_release_clear##size(lock);\
	}

#define __ALL_HLE_LOCKS(size, type)\
	__HLE_EXCH_LOCK_SPIN(size, type)\
	__HLE_EXCH_LOCK_SPEC(size, type)\
	__HLE_EXCH_LOCK_SPEC_NOLOAD(size, type)\
	__HLE_TAS_LOCK_SPIN(size, type)\
	__HLE_TAS_LOCK_SPEC(size, type)\
	__HLE_EXCH_UNLOCK(size, type)

__ALL_HLE_LOCKS(1, unsigned char)
__ALL_HLE_LOCKS(2, unsigned short)
__ALL_HLE_LOCKS(4, unsigned)
__ALL_HLE_LOCKS(8, unsigned long long)

#endif // HLE_LOCK_FUNCTIONS_H_
