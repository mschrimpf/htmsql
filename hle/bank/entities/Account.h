/*
 * Account.h
 *
 *  Created on: 04.11.2013
 *      Author: Martin
 */

#ifndef ACCOUNT_H_
#define ACCOUNT_H_


class Account {
public:
	Account(double budget = 0);
	void init(double budget = 0);
	/**
	 * @return the new balance
	 */
	double deposit(double);
	/**
	 * @return the new balance
	 */
	double withdraw(double);
	/**
	 * @return the current balance
	 */
	double getBalance();
private:
	double balance;
};


#endif /* ACCOUNT_H_ */
