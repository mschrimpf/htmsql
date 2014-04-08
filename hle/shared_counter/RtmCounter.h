#ifndef _RTM_COUNTER_H
#define _RTM_COUNTER_H 1

#include "ThreadsafeCounter.h"

class RtmCounter : public ThreadsafeCounter {
public:
	RtmCounter();
	void increment();
	int get();
};

#endif // _RTM_COUNTER_H
