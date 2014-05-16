#ifndef _GLOBAL_THREADSAFE_COUNTER_H
#define _GLOBAL_THREADSAFE_COUNTER_H 1

#include "PaddedCounter.h"
#include "../lock_functions/LockType.h"

class GlobalThreadsafeCounter : public PaddedCounter {
private:
//	LockType locker; // global in .cpp

	unsigned char padding[3 * 64 - 176];
public:
//	GlobalThreadsafeCounter();
	GlobalThreadsafeCounter(LockType& locker);
	void init(LockType& locker);
	virtual void increment();
	virtual int get();
};

#endif // _GLOBAL_THREADSAFE_COUNTER_H
