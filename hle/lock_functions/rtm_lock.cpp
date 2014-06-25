#include "hle_tas_lock-spec.h"
#include <immintrin.h> // rtm
#include <xmmintrin.h> // _mm_pause
#include "rtm_lock.h"
#include "atomic_exch_lock-spec.h"

/* naive */
void rtm_lock(type* mutex) {
	int code;
	while ((code = _xbegin()) != _XBEGIN_STARTED) {
		_mm_pause();
	}
}
void rtm_unlock(type* mutex) {
	_xend();
}

/* smart */
void rtm_lock_smart(type* mutex) {
	int failures = 0, max_retries = 0;

	int code;
	while ((code = _xbegin()) != _XBEGIN_STARTED) {
		if (
		//			((code & 1) == 1 || (code & 2) == 2 || (code & 4) == 4)
		//			((code & 2) == 2)
		((code & 7) > 0) // caused by either 0: xabort (ourselves), 1: may succeed on retry or 2: data conflict
		&& (++failures <= max_retries) // retries available
				) {
			_mm_pause();
		} else { // no retries left
			atomic_exch_lock_spec(mutex); // use default function
			return;
		}
	}
	// elided execution
	if (mutex != 0) { // mutex set already (it is also added to the read-set with this call)
		_xabort(0);
	}
}

void rtm_unlock_smart(type* mutex) {
	if (_xtest()) { // speculative run
		_xend();
	} else {
		// non-speculative, used default mutex_enter_func previously
		atomic_exch_unlock_spec(mutex);
	}
}
