#include <immintrin.h> // RTM
#include <xmmintrin.h> // _mm_pause
#include "sync0sync.h"

void rtm_lock(ib_mutex_t* mutex, const char* file_name, ulint line) {
	// ignore if the mutex is set already, only data important
	int failures = 0, max_retries = 10;

//	while (mutex_get_lock_word(mutex) != 0) {
//		_mm_pause();
//	}

	int code;
	while ((code = _xbegin()) != _XBEGIN_STARTED) {
		if (
//			((code & 1) == 1 || (code & 2) == 2 || (code & 4) == 4)
//			((code & 2) == 2)
//			((code & 7) > 0) // caused by either 0: xabort (ourselves), 1: may succeed on retry or 2: data conflict
//			&&
		(++failures <= max_retries) // retries available
		) {
			_mm_pause();
		} else { // no retries left
			mutex_enter_func(mutex, file_name, line);
			return;
		}
	}
	// elided execution
	if (mutex_get_lock_word(mutex) != 0) { // mutex set already (also adds it to read-set)
		_xabort(0);
	}
}
void rtm_unlock(ib_mutex_t* mutex) {
	if (_xtest()) // speculative run
		_xend();
	else
		mutex_exit_func(mutex);
}
