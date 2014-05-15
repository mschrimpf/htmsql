#ifndef _THREADSAFE_COUNTER_H
#define _THREADSAFE_COUNTER_H 1

#include "PaddedCounter.h"
#include "../lock_functions/LockType.h"

class ThreadsafeCounter : public PaddedCounter {
private:
	LockType locker;

	unsigned char padding[3 * 64 - 176];
public:
	ThreadsafeCounter();
	ThreadsafeCounter(LockType locker);
	void init(LockType locker);
	virtual void increment();
	virtual int get();
};

#endif // _THREADSAFE_COUNTER_H
