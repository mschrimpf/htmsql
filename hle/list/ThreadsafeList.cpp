#include "ThreadsafeList.h"

ThreadsafeList::ThreadsafeList(LockType &locker) :
		List() {
	this->locker = locker;
}
ThreadsafeList::~ThreadsafeList() {
}

void ThreadsafeList::insertTail(ListItem * item) {
	(this->locker.*(this->locker.lock))();
	List::insertTail(item);
	(this->locker.*(this->locker.unlock))();
}

void ThreadsafeList::removeFromList(ListItem * item) {
	(this->locker.*(this->locker.lock))();
	List::removeFromList(item);
	(this->locker.*(this->locker.unlock))();
}

ListItem * ThreadsafeList::get(int data)  {
	(this->locker.*(this->locker.lock))();
	ListItem * result = List::get(data);
	(this->locker.*(this->locker.unlock))();
	return result;
}

void ThreadsafeList::print() {
	(this->locker.*(this->locker.lock))(); // pay attention when using RTM - this will never elide
	List::print();
	(this->locker.*(this->locker.unlock))();
}
