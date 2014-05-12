#ifndef _THREADSAFE_LIST_H_
#define _THREADSAFE_LIST_H_ 1

#include "List.h"
#include "../lock_functions/LockType.h"

class ThreadsafeList : public List {
protected:
	LockType locker;
	virtual ListItem * findAndRemoveFromList(int data);
	ListItem * get(int data);
public:
	ThreadsafeList(Allocator * allocator, LockType &locker);
	~ThreadsafeList();

	virtual void insertTail(ListItem * item);

	void print();
};

#endif // _THREADSAFE_LIST_H_
