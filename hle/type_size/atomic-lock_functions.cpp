#ifndef ATOMIC_LOCK_FUNCTIONS_H_
#define ATOMIC_LOCK_FUNCTIONS_H_

#include <xmmintrin.h> // _mm_pause
#define __ATOMIC_EXCH_LOCK_SPEC(size, type)\
	static void atomic_exch_lock_spec(type *lock) {\
		while (__atomic_exchange_n(lock, 1, __ATOMIC_ACQUIRE)) {\
			/* Wait for lock to become free again before retrying. */\
			type val;\
			do {\
				_mm_pause();\
				/* Abort speculation */\
				__atomic_load(lock, &val, __ATOMIC_CONSUME);\
			}while (val == 1);\
		}\
	}

#define __ATOMIC_TAS_LOCK_SPEC(size, type)\
	static void atomic_tas_lock_spec(type *lock) {\
		while (__atomic_test_and_set(lock, __ATOMIC_ACQUIRE)) {\
			/* Wait for lock to become free again before retrying. */\
			type val;\
			do {\
				_mm_pause();\
				/* Abort speculation */\
				__atomic_load(lock, &val, __ATOMIC_CONSUME);\
			} while (val == 1);\
		}\
	}

#define __ATOMIC_EXCH_UNLOCK(size, type)\
	static void atomic_unlock##size(type *lock) {\
		__atomic_clear(lock, __ATOMIC_RELEASE);\
	}

#define __ALL_ATOMIC_LOCKS(size, type)\
	__ATOMIC_EXCH_LOCK_SPEC(size, type)\
	__ATOMIC_TAS_LOCK_SPEC(size, type)\
	__ATOMIC_EXCH_UNLOCK(size, type)

__ALL_ATOMIC_LOCKS(1, unsigned char)
__ALL_ATOMIC_LOCKS(2, unsigned short)
__ALL_ATOMIC_LOCKS(4, unsigned)
__ALL_ATOMIC_LOCKS(8, unsigned long long)

#endif // ATOMIC_LOCK_FUNCTIONS_H_
