#include <stdio.h>
#include <stdlib.h>

#include <thread>
#include <xmmintrin.h> // mm_pause
#include <immintrin.h> // rtm
#include "../../util.h"

/**
 * @return 0 on success, 1 on failure
 */
int rtm_xabort() {
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		_xabort(0);
		_xend();
		return 0;
	} else {
		return 1;
	}
}

int main(int argc, char *argv[]) {
	usleep(1 * 1000000); // let perf catch up
	int loops = 10000;

	int failures = 0;
	for (int i = 0; i < loops; ++i) {
		failures += rtm_xabort();
	}
	float failure_rate = (float) failures / loops;
	printf("%d/%d failed (%.2f)\n", failures, loops, failure_rate);
}
