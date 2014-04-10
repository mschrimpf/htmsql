#ifndef _THREADSAFE_LIST_H_
#define _THREADSAFE_LIST_H_ 1

#include "List.h"
#include "../lock_functions/LockType.h"

class ThreadsafeList {
protected:
	List * list;
	LockType locker;
public:
	/** @see #insertHead(int data) */
	virtual ListItem * insert(int data);
	/**
	 * Removes the occurrences of data in the list.
	 * If removeAll is != 0, all occurrences are removed, otherwise only the first one.
	 * */
	virtual void remove(int data, int removeAll = 0);
	/** @return 1 if data is contained, 0 if not */
	virtual int contains(int data);

	void print();

	ThreadsafeList(LockType &locker);
	~ThreadsafeList();
};

#endif // _THREADSAFE_LIST_H_
