/*
 * HashMap.cpp
 *
 *  Created on: 14.03.2014
 *      Author: Martin
 */

#include "ThreadsafeCounter.h"
#include "../lock_functions/LockType.h"

ThreadsafeCounter::ThreadsafeCounter() :
		PaddedCounter() {
	// need to call argument-constructor afterwards
}

ThreadsafeCounter::ThreadsafeCounter(LockType locker) :
		PaddedCounter() {
	init(locker);
}

void ThreadsafeCounter::init(LockType locker) {
	this->locker = locker;
}

void ThreadsafeCounter::increment() {
	(this->locker.*(this->locker.lock))();
	this->PaddedCounter::increment();
	(this->locker.*(this->locker.unlock))();
}

int ThreadsafeCounter::get() {
	(this->locker.*(this->locker.lock))();
	int result = this->PaddedCounter::get();
	(this->locker.*(this->locker.unlock))();
	return result;
}
