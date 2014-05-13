/*
 * HashMap.cpp
 *
 *  Created on: 14.03.2014
 *      Author: Martin
 */

#include "ThreadsafeCounter.h"
#include "../lock_functions/LockType.h"

ThreadsafeCounter::ThreadsafeCounter() {
	this->counter[0] = 0;
	// need to call argument-constructor afterwards
}

ThreadsafeCounter::ThreadsafeCounter(LockType locker) {
	init(locker);
}

void ThreadsafeCounter::init(LockType locker) {
	this->counter[0] = 0;
	this->locker = locker;
}

void ThreadsafeCounter::increment() {
	(this->locker.*(this->locker.lock))();
	this->counter[0]++;
	(this->locker.*(this->locker.unlock))();
}

int ThreadsafeCounter::get() {
	(this->locker.*(this->locker.lock))();
	int result = this->counter[0];
	(this->locker.*(this->locker.unlock))();
	return result;
}
