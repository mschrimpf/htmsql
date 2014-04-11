#include "ThreadsafeList.h"

ThreadsafeList::ThreadsafeList(LockType &locker) :
		List() {
	this->list = new List();
	this->locker = locker;
}
ThreadsafeList::~ThreadsafeList() {
	(this->locker.*(this->locker.lock))();
	delete this->list;
	(this->locker.*(this->locker.unlock))();
}

ListItem* ThreadsafeList::insertHead(ListItem * item) {
	(this->locker.*(this->locker.lock))();
	ListItem * result = List::insertHead(item);
	(this->locker.*(this->locker.unlock))();
	return result;
}
//ListItem* ThreadsafeList::insertTail(ListItem * item) {
//	(this->locker.*(this->locker.lock))();
//	ListItem * result = List::insertTail(item);
//	(this->locker.*(this->locker.unlock))();
//	return result;
//}

void ThreadsafeList::remove(int data, int removeAll) {
	ListItem * removeList = NULL; // build a list of items to be removed to remove them outside htm
	ListItem * prev = NULL;
	(this->locker.*(this->locker.lock))();
	ListItem * item = this->first;
	while (item) {
		if (item->data == data) {
			if (prev == NULL) // item is start item
				this->first = item->next;
			else
				prev->next = item->next;
			// add to remove list
			item->prev = NULL;
			item->next = removeList;
			if (!removeList) {
				removeList = item;
			}
			// stop if one item suffices
			if (!removeAll)
				break;
		}
		prev = item;
		item = item->next;
	}
	(this->locker.*(this->locker.unlock))();

	// delete all items in the remove list
	this->deleteAll(removeList);
}

int ThreadsafeList::contains(int data) {
	(this->locker.*(this->locker.lock))();
	int result = 0; // 100% fails if executed with List::contains
	ListItem * item = this->first;
	while (item) {
		if (item->data == data) {
			result = 1;
			break;
		}
		item = item->next;
	}
	(this->locker.*(this->locker.unlock))();
	return result;
}

void ThreadsafeList::print() {
	(this->locker.*(this->locker.lock))(); // pay attention when using RTM - this will never elide
	List::print();
	(this->locker.*(this->locker.unlock))();
}
