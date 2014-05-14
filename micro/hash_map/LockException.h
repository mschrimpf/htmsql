/*
 * lock_exception.h
 *
 *  Created on: 26.10.2013
 *      Author: Martin
 */

#ifndef LOCK_EXCEPTION_H_
#define LOCK_EXCEPTION_H_

#include <iostream>

class LockException: public std::exception {
	virtual const char* what() const throw () {
		return "Could not acquire lock";
	}
};

#endif /* LOCK_EXCEPTION_H_ */
