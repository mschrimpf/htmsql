/*
 *  Created on: 08.04.2014
 *      Author: Martin
 */

#include "RtmCounter.h"
#include <immintrin.h> // RTM: _x
#define RTM_MAX_RETRIES 1000000

RtmCounter::RtmCounter() {
}

void RtmCounter::increment() {
	int failures = 0;
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		this->counter++;
		_xend();
	} else {
		if (failures++ < RTM_MAX_RETRIES)
			goto retry;
		else
			fprintf(stderr, "Max retry count reached\n");
	}
}

int RtmCounter::get() {
	int failures = 0;
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		int res = this->counter;
		_xend();
		return res;
	} else {
		if (failures++ < RTM_MAX_RETRIES)
			goto retry;
		else
			fprintf(stderr, "Max retry count reached\n");
	}
}
