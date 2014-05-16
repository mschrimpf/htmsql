/*
 *  Created on: 14.03.2014
 *      Author: Martin
 */

#include "GlobalThreadsafeCounter.h"
#include "../lock_functions/LockType.h"

LockType globalLock;

GlobalThreadsafeCounter::GlobalThreadsafeCounter(LockType& locker) :
		PaddedCounter() {
	init(locker);
}

void GlobalThreadsafeCounter::init(LockType& locker) {
	globalLock = locker;
}

void GlobalThreadsafeCounter::increment() {
	(globalLock.*(globalLock.lock))();
	this->PaddedCounter::increment();
	(globalLock.*(globalLock.unlock))();
}

int GlobalThreadsafeCounter::get() {
	(globalLock.*(globalLock.lock))();
	int result = this->PaddedCounter::get();
	(globalLock.*(globalLock.unlock))();
	return result;
}
