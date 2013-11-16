/*
 * ThreadsafeAccount.cpp
 *
 *  Created on: 04.11.2013
 *      Author: Martin
 */


#include "ThreadsafeAccount.h"
#include "Account.h"

ThreadsafeAccount::ThreadsafeAccount(void (*lock)(), void (*unlock)(), double balance) {
	this->account = new Account(balance);
	this->lock = lock;
	this->unlock = unlock;
}
ThreadsafeAccount::~ThreadsafeAccount() {
	delete this->account;
}

double ThreadsafeAccount::deposit(double money) {
	// lock
	return this->account->deposit(money);
	// unlock
}

double ThreadsafeAccount::payout(double money) {
	// lock
	return this->account->payout(money);
	// unlock
}

double ThreadsafeAccount::getBalance() {
	// lock
	return this->account->getBalance();
	// unlock
}
