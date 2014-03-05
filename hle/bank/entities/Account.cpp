/*
 * Account.cpp
 *
 *  Created on: 04.11.2013
 *      Author: Martin
 */

#include "Account.h"

Account::Account(double balance) {
	this->init(balance);
}
void Account::init(double balance) {
	this->balance = balance;
}

double Account::deposit(double amount) {
	this->balance += amount;
	return this->balance;
}

double Account::payout(double amount) {
	this->balance -= amount;
	return this->balance;
}

double Account::getBalance() {
	return this->balance;
}
