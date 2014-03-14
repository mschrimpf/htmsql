#ifndef _THREADSAFE_COUNTER_H
#define _THREADSAFE_COUNTER_H 1

#include "../lock_functions/LockType.h"

class ThreadsafeCounter {
private:
	int counter;
	LockType locker;
public:
	ThreadsafeCounter(LockType locker);
	void increment();
	int get();
};

#endif // _THREADSAFE_COUNTER_H
