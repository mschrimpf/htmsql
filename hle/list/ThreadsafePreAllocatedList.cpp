#include "ThreadsafePreAllocatedList.h"

ThreadsafePreAllocatedList::ThreadsafePreAllocatedList(LockType &locker) :
		PreAllocatedList() {
	this->locker = locker;
}
ThreadsafePreAllocatedList::~ThreadsafePreAllocatedList() {
}

ListItem* ThreadsafePreAllocatedList::insert(int data) {
	// TODO: this leads to lots of RTM aborts
	if (this->contains(data))
		return NULL;
	ListItem * item = createListItem(data, NULL, NULL);
	return this->insertHead(item);
}
ListItem* ThreadsafePreAllocatedList::insertHead(ListItem * item) {
	(this->locker.*(this->locker.lock))();
	ListItem * result = List::insertHead(item);
	(this->locker.*(this->locker.unlock))();
	return result;
}
//ListItem* ThreadsafePreAllocatedList::insertTail(ListItem * item) {
//	(this->locker.*(this->locker.lock))();
//	ListItem * result = List::insertTail(item);
//	(this->locker.*(this->locker.unlock))();
//	return result;
//}

void ThreadsafePreAllocatedList::remove(int data, int removeAll) {
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

int ThreadsafePreAllocatedList::contains(int data) {
	// TODO lots of aborts here
	(this->locker.*(this->locker.lock))();
	int result = 0; // 100% fails if executed with List::contains
	ListItem * item = this->first;
	while (item) { // jne amounts for most aborts
		if (item->data == data) {
			result = 1;
			break;
		}
		item = item->next;
	}
	(this->locker.*(this->locker.unlock))();
	return result;
}

void ThreadsafePreAllocatedList::print() {
	(this->locker.*(this->locker.lock))(); // pay attention when using RTM - this will never elide
	List::print();
	(this->locker.*(this->locker.unlock))();
}
