#ifndef _THREADSAFE_COUNTER_H
#define _THREADSAFE_COUNTER_H 1

#include "../lock_functions/LockType.h"

class ThreadsafeCounter {
protected:
	int counter[16]; // avoid having counter and mutex in same cache line
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
