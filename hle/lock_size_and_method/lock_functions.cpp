#ifndef LOCK_FUNCTIONS_H_
#define LOCK_FUNCTIONS_H_

#include "../lib/hle-emulation.h"
#include <xmmintrin.h> // _mm_pause

#define __HLE_EXCH_LOCK(size, type)\
	static void hle_exch_lock##size(type *lock) {\
		while(__hle_acquire_exchange_n##size(lock, 1)) {\
			_mm_pause();\
		}\
	}
#define __HLE_EXCH_SPECULATION_LOCK(size, type)\
	static void hle_exch_lock_spec##size(type *lock) {\
		while (__hle_acquire_exchange_n##size(lock, 1)) {\
			unsigned val;\
			/* Wait for lock to become free again before retrying. */\
			do {\
				_mm_pause();\
				/* Abort speculation */\
				__hle_acquire_store_n##size(lock, val);\
			} while (val == 1);\
		}\
	}

#define __HLE_EXCH_UNLOCK(size, type)\
	static void hle_unlock##size(type *lock) {\
		__hle_release_clear##size(lock);\
	}

#define __ALL_HLE_LOCKS(size, type)\
	__HLE_EXCH_LOCK(size, type)\
	__HLE_EXCH_SPECULATION_LOCK(size, type)\
	__HLE_EXCH_UNLOCK(size, type)


__ALL_HLE_LOCKS(8, unsigned long long)
__ALL_HLE_LOCKS(4, unsigned)
__ALL_HLE_LOCKS(2, unsigned short)
__ALL_HLE_LOCKS(1, unsigned char)

#endif // LOCK_FUNCTIONS_H_
