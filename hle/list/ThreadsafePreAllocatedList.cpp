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

void ThreadsafePreAllocatedList::removeFromList(ListItem * item) {
	(this->locker.*(this->locker.lock))();
	PreAllocatedList::removeFromList(item);
	(this->locker.*(this->locker.unlock))();
}

ListItem * ThreadsafePreAllocatedList::get(int data) {
	(this->locker.*(this->locker.lock))();
	ListItem * result = PreAllocatedList::get(data);
	(this->locker.*(this->locker.unlock))();
	return result;
}

void ThreadsafePreAllocatedList::print() {
	(this->locker.*(this->locker.lock))(); // pay attention when using RTM - this will never elide
	List::print();
	(this->locker.*(this->locker.unlock))();
}
