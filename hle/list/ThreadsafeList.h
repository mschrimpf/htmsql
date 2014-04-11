#ifndef _THREADSAFE_LIST_H_
#define _THREADSAFE_LIST_H_ 1

#include "List.h"
#include "../lock_functions/LockType.h"

class ThreadsafeList : public List {
protected:
	List * list;
	LockType locker;
public:
	ThreadsafeList(LockType &locker);
	~ThreadsafeList();

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

#endif // _THREADSAFE_LIST_H_
