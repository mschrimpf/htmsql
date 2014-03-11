/*
 * ThreadsafeAccount.cpp
 *
 *  Created on: 04.11.2013
 *      Author: Martin
 */

#include "ThreadsafeAccount.h"

ThreadsafeAccount::ThreadsafeAccount() {
}
ThreadsafeAccount::ThreadsafeAccount(LockType locker, double balance) {
	this->init(locker, balance);
}
void ThreadsafeAccount::init(LockType locker,
//		void (*lock)(), void (*unlock)(),
		double balance) {
	this->balance = balance;
	this->locker = locker;
//	this->lock = lock;
//	this->unlock = unlock;
}
ThreadsafeAccount::~ThreadsafeAccount() {
}

void ThreadsafeAccount::deposit(double money) {
//	(*lock)();
	(locker.*(locker.lock))();
	this->balance += money;
	(locker.*(locker.unlock))();
//	(*unlock)();
}

void ThreadsafeAccount::withdraw(double money) {
//	(*lock)();
	(locker.*(locker.lock))();
	this->balance -= money;
	(locker.*(locker.unlock))();
//	(*unlock)();
}

double ThreadsafeAccount::getBalance() {
//	(*lock)();
	(locker.*(locker.lock))();
	double b = this->balance;
	(locker.*(locker.unlock))();
//	(*unlock)();
	return b;
}
