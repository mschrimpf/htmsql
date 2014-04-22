#include <immintrin.h> // RTM
#include <xmmintrin.h> // _mm_pause

int rtm_lock() {
	int failures = 0, failures_max = 100;
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		return 0;
	} else if (++failures <= failures_max) {
		goto retry;
	} else {
//		printf("Max failure count (%d) reached\n", failures);
//		exit(1);
		return 1;
	}
}
void rtm_unlock() {
	_xend();
}
