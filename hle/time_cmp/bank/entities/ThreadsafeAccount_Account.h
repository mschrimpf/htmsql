/*
 * ThreadsafeAccount.h
 *
 *  Created on: 04.11.2013
 *      Author: Martin
 */

#ifndef THREADSAFEACCOUNT_H_
#define THREADSAFEACCOUNT_H_

#include "Account.h"

class ThreadsafeAccount {
public:
	ThreadsafeAccount(void (*lock)(), void (*unlock)(), double balance = 0);
	~ThreadsafeAccount();
	/**
	 * @return the new balance
	 */
	double deposit(double);
	/**
	 * @return the new balance
	 */
	double payout(double);
	/**
	 * @return the current balance
	 */
	double getBalance();
private:
	Account* account;
	void (*lock)();
	void (*unlock)();
};

#endif /* THREADSAFEACCOUNT_H_ */
