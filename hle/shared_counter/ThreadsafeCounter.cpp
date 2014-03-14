/*
 * HashMap.cpp
 *
 *  Created on: 14.03.2014
 *      Author: Martin
 */

#include "ThreadsafeCounter.h"
#include "../lock_functions/LockType.h"


ThreadsafeCounter::ThreadsafeCounter(LockType locker) {
	this->counter = 0;
	this->locker = locker;
}

void ThreadsafeCounter::increment() {
	(this->locker.*(this->locker.lock))();
	this->counter++;
	(this->locker.*(this->locker.unlock))();
}

int ThreadsafeCounter::get() {
	(this->locker.*(this->locker.lock))();
	int result = this->counter;
	(this->locker.*(this->locker.unlock))();
	return result;
}
