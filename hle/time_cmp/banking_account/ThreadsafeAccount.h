/*
 * ThreadsafeAccount.h
 *
 *  Created on: 04.11.2013
 *      Author: Martin
 */

#ifndef THREADSAFEACCOUNT_H_
#define THREADSAFEACCOUNT_H_

//#include "Account.h"
#include "../../lock_functions/LockType.h"

class ThreadsafeAccount {
public:
//	ThreadsafeAccount(void (*lock)(), void (*unlock)(), double balance = 0);
	ThreadsafeAccount(LockType locker, double balance = 0);
	ThreadsafeAccount();
	void init(LockType locker, double balance = 0);

	~ThreadsafeAccount();
	/**
	 * @return the new balance
	 */
	void deposit(double);
	/**
	 * @return the new balance
	 */
	void payout(double);
	/**
	 * @return the current balance
	 */
	double getBalance();
private:
	double balance;
	LockType locker;
//	void (*lock)();
//	void (*unlock)();
};

#endif /* THREADSAFEACCOUNT_H_ */
