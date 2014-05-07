#include "ThreadsafePreAllocatedList.h"

ThreadsafePreAllocatedList::ThreadsafePreAllocatedList(LockType &locker) :
		PreAllocatedList() {
	this->locker = locker;
}
ThreadsafePreAllocatedList::~ThreadsafePreAllocatedList() {
}

void ThreadsafePreAllocatedList::insertTail(ListItem * item) {
	(this->locker.*(this->locker.lock))();
	List::insertTail(item);
	(this->locker.*(this->locker.unlock))();
}

ListItem* ThreadsafePreAllocatedList::createListItem(int data, ListItem * prev,
		ListItem * next) {
	(this->locker.*(this->locker.lock))();
	ListItem * result = PreAllocatedList::createListItem(data, prev, next);
	(this->locker.*(this->locker.unlock))();
	return result;
}

ListItem * ThreadsafePreAllocatedList::findAndRemoveFromList(int data) {
	(this->locker.*(this->locker.lock))();
	ListItem * item = PreAllocatedList::findAndRemoveFromList(data);
	(this->locker.*(this->locker.unlock))();
	return item;
}

void ThreadsafePreAllocatedList::print() {
	(this->locker.*(this->locker.lock))(); // pay attention when using RTM - this will never elide
	List::print();
	(this->locker.*(this->locker.unlock))();
}
