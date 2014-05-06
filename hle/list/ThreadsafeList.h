#ifndef _THREADSAFE_LIST_H_
#define _THREADSAFE_LIST_H_ 1

#include "List.h"
#include "../lock_functions/LockType.h"

class ThreadsafeList : public List {
protected:
	LockType locker;
public:
	ThreadsafeList(LockType &locker);
	~ThreadsafeList();

	virtual void insertTail(ListItem * item);
	virtual void removeFromList(ListItem * item);
	/**
	 * @return the list item holding the specified data or NULL if no such item exists
	 */
	virtual ListItem * get(int data);

	void print();
};

#endif // _THREADSAFE_LIST_H_
