#ifndef _THREADSAFE_COUNTER_H
#define _THREADSAFE_COUNTER_H 1

#include "../lock_functions/LockType.h"

class ThreadsafeCounter {
protected:
	int counter = 0;
private:
	LockType locker;

	unsigned char padding[2 * 64 - 120];
public:
	ThreadsafeCounter();
	ThreadsafeCounter(LockType locker);
	void init(LockType locker);
	virtual void increment();
	virtual int get();
};

#endif // _THREADSAFE_COUNTER_H
