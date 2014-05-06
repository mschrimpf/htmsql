#ifndef _THREADSAFE_PRE_ALLOCATED_LIST_H_
#define _THREADSAFE_PRE_ALLOCATED_LIST_H_ 1

#include "PreAllocatedList.h"
#include "../lock_functions/LockType.h"

class ThreadsafePreAllocatedList: public PreAllocatedList {
protected:
	List * list;
	LockType locker;
public:
	ThreadsafePreAllocatedList(LockType &locker);
	~ThreadsafePreAllocatedList();

	virtual void insertTail(ListItem * item);
	ListItem * createListItem(int data, ListItem * prev, ListItem * next);
	/**
	 * Removes the given item from list structure only, not from memory.
	 */
	virtual void removeFromList(ListItem * item);
	/**
	 * @return the list item holding the specified data or NULL if no such item exists
	 */
	virtual ListItem * get(int data);

	void print();
};

#endif // _THREADSAFE_PRE_ALLOCATED_LIST_H_
