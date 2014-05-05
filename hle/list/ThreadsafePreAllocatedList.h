#ifndef _THREADSAFE_PRE_ALLOCATED_LIST_H_
#define _THREADSAFE_PRE_ALLOCATED_LIST_H_ 1

#include "PreAllocatedList.h"
#include "../lock_functions/LockType.h"

class ThreadsafePreAllocatedList : public PreAllocatedList {
protected:
	List * list;
	LockType locker;
public:
	ThreadsafePreAllocatedList(LockType &locker);
	~ThreadsafePreAllocatedList();

	ListItem * insert(int value);
	ListItem * insertHead(ListItem * item);
//	ListItem * insertTail(ListItem * item);
	/**
	 * Removes the occurrences of data in the list.
	 * If removeAll is != 0, all occurrences are removed, otherwise only the first one.
	 * */
	void remove(int data, int removeAll = 0);
	/** @return 1 if data is contained, 0 if not */
	int contains(int data);

	void print();
};

#endif // _THREADSAFE_PRE_ALLOCATED_LIST_H_
