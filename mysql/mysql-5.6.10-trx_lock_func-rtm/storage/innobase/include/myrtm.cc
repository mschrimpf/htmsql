#include <immintrin.h> // RTM
#include <xmmintrin.h> // _mm_pause
#include <stdio.h>     // print
#include "sync0sync.h"

void rtm_lock(ib_mutex_t* mutex, const char* file_name, ulint line) {
	int failures = 0, failures_max = 100;
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		// checking the mutex should not be necessary since we're not about the mutex but about the data
		return;
//		// check lock word (also adds it to the read-set!)
//		if (mutex->lock_word)
//			mutex_enter_func(mutex, file_name, line);
	} else if (++failures <= failures_max) {
		goto retry;
	} else {
//		printf("Max failure count (%d) reached\n", failures);
//		exit(1);

		mutex_enter_func(mutex, file_name, line);
	}
}
void rtm_unlock(ib_mutex_t* mutex) {
	if (mutex->lock_word)
		mutex_exit_func(mutex);
	else
		_xend();
}
