#include "hle_tas_lock-spec.h"
#include <immintrin.h> // rtm
#include <xmmintrin.h> // _mm_pause
#include "rtm_lock.h"

void rtm_lock() {
	int code;
	while ((code = _xbegin()) != _XBEGIN_STARTED) {
		_mm_pause();
	}
}
void rtm_unlock() {
	_xend();
}
