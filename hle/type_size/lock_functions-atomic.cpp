#ifndef LOCK_FUNCTIONS_H_
#define LOCK_FUNCTIONS_H_

// testing purposes only
#include <xmmintrin.h> // _mm_pause

#define __HLE_EXCH_LOCK_SPIN(size, type)\
	static void hle_exch_lock_spin##size(type *lock) {\
		while (__atomic_exchange_n(lock, 1, __ATOMIC_ACQUIRE)) {\
			_mm_pause();\
		}\
	}
#define __HLE_EXCH_LOCK_SPEC(size, type)\
	static void hle_exch_lock_spec##size(type *lock) {\
		while (__atomic_exchange_n(lock, 1, __ATOMIC_ACQUIRE)) {\
			type val;\
			do {\
				_mm_pause();\
				__atomic_load(lock, &val, __ATOMIC_CONSUME);\
			} while (val == 1);\
		}\
	}

#define __HLE_EXCH_UNLOCK(size, type)\
	static void hle_unlock##size(type *lock) {\
		__atomic_clear(lock, __ATOMIC_RELEASE);\
	}

#define __ALL_HLE_LOCKS(size, type)\
	__HLE_EXCH_LOCK_SPIN(size, type)\
	__HLE_EXCH_LOCK_SPEC(size, type)\
	__HLE_EXCH_UNLOCK(size, type)

__ALL_HLE_LOCKS(1, unsigned char)
__ALL_HLE_LOCKS(2, unsigned short)
__ALL_HLE_LOCKS(4, unsigned)
__ALL_HLE_LOCKS(8, unsigned long long)

#endif // LOCK_FUNCTIONS_H_
