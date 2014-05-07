#ifndef _THREADSAFE_PRE_ALLOCATED_LIST_H_
#define _THREADSAFE_PRE_ALLOCATED_LIST_H_ 1

#include "PreAllocatedList.h"
#include "../lock_functions/LockType.h"

class ThreadsafePreAllocatedList: public PreAllocatedList {
protected:
	List * list;
	LockType locker;
	virtual ListItem * findAndRemoveFromList(int data);
public:
	ThreadsafePreAllocatedList(LockType &locker);
	~ThreadsafePreAllocatedList();

	virtual void insertTail(ListItem * item);
	ListItem * createListItem(int data, ListItem * prev, ListItem * next);

	void print();
};

#endif // _THREADSAFE_PRE_ALLOCATED_LIST_H_
