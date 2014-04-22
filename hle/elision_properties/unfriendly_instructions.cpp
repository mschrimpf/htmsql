#include <stdio.h>
#include <stdlib.h>

#include <thread>
#include <xmmintrin.h> // mm_pause
#include <immintrin.h> // rtm
#include "../../util.h"

/**
 * @return 0 on success, 1 on failure
 */
int rtm_pause() {
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		_mm_pause();
		_xend();
		return 0;
	} else {
		return 1;
	}
}

int main(int argc, char *argv[]) {
	usleep(1 * 100000); // let perf catch up
	int loops = 100;

	int failures = 0;
	for (int i = 0; i < loops; ++i) {
		failures += rtm_pause();
	}
	float failure_rate = (float) failures / loops;
	printf("%d/%d failed (%.2f)\n", failures, loops, failure_rate);
}
