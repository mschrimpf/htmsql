#include "ThreadsafeList.h"

ThreadsafeList::ThreadsafeList(LockType &locker) {
	this->list = new List();
	this->locker = locker;
}
ThreadsafeList::~ThreadsafeList() {
	(this->locker.*(this->locker.lock))();
	delete this->list;
	(this->locker.*(this->locker.unlock))();
}


ListItem* ThreadsafeList::insert(int data) {
	(this->locker.*(this->locker.lock))();
	ListItem * result = this->list->insert(data);
	(this->locker.*(this->locker.unlock))();
	return result;
}

void ThreadsafeList::remove(int data, int removeAll) {
	(this->locker.*(this->locker.lock))();
	this->list->remove(data, removeAll);
	(this->locker.*(this->locker.unlock))();
}

int ThreadsafeList::contains(int data) {
	(this->locker.*(this->locker.lock))();
	int result = this->list->contains(data);
	(this->locker.*(this->locker.unlock))();
	return result;
}

void ThreadsafeList::print() {
	(this->locker.*(this->locker.lock))(); // pay attention when using RTM - this will never elide
	this->list->print();
	(this->locker.*(this->locker.unlock))();
}
