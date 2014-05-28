#include <immintrin.h> // RTM
#include <xmmintrin.h> // _mm_pause
#include "sync0sync.h"

void rtm_lock(ib_mutex_t* mutex, const char* file_name, ulint line) {
	// ignore if the mutex is set already, only data important
	int failures = 0, failures_max = 1000;
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		return;
	} else if (++failures <= failures_max) {
		goto retry;
	} else {
		mutex_enter_func(mutex, file_name, line);
	}
}
void rtm_unlock(ib_mutex_t* mutex) {
	if (_xtest()) // speculative run
		_xend();
	else
		mutex_exit_func(mutex);
}
