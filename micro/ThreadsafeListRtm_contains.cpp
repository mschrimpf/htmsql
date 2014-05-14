#include <stdio.h>
#include <stdlib.h>
#include <immintrin.h> // rtm
#include "../Stats.h"

// header
class ListItem {
public:
	ListItem * prev;
	ListItem * next;
	int data;
	ListItem(int data, ListItem * prev, ListItem * next);
};

class List {
protected:
	ListItem * first;
	ListItem * last;
public:
	List();
	~List();

	/** @see #insertHead(int data) */
	ListItem * insert(int data);
	virtual ListItem * insertHead(ListItem * item);
	/** @return 1 if data is contained, 0 if not */
	virtual int contains(int data);
	/** Deletes the whole list, defined as consecutive list->nexts */
	virtual void deleteAll(ListItem * list);

	virtual void print();
};

class ThreadsafeListRtm: public List {
public:
	ThreadsafeListRtm();
	~ThreadsafeListRtm();

	/** @return 1 on failure, 0 otherwise */
	int contains(int data);
	/** @return 1 on failure, 0 otherwise */
	int containsRtm(int data);
};

// implementations

ListItem::ListItem(int data, ListItem * prev, ListItem * next) {
	this->data = data;
	this->prev = prev;
	this->next = next;
}

// list

List::List() {
	this->first = this->last = NULL;
}
List::~List() {
	this->deleteAll(this->first);
	this->first = this->last = NULL;
}

void List::deleteAll(ListItem * list) {
	while (list) {
		ListItem * next = list->next;
		delete list;
		list = next;
	}
}

ListItem* List::insert(int data) {
	return this->insertHead(new ListItem(data, NULL, NULL));
}
ListItem* List::insertHead(ListItem * item) {
	item->next = this->first;
	this->first = item;
	if (this->last == NULL)
		this->last = item;
	return item;
}

int List::contains(int data) {
	ListItem * item = this->first;
	while (item) {
		if (item->data == data)
			return 1;
		item = item->next;
	}
	return 0;
}
void List::print() {
	ListItem * item = this->first;
	while (item) {
		printf("%d ", item->data);
		item = item->next;
	}
}

// rtm

ThreadsafeListRtm::ThreadsafeListRtm() :
		List() {
}
ThreadsafeListRtm::~ThreadsafeListRtm() {
}

int ThreadsafeListRtm::contains(int data) {
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		int result = List::contains(data);
		_xend();
		return 0;
	} else {
		return 1;
	}
}
int ThreadsafeListRtm::containsRtm(int data) {
	if (_xbegin() == _XBEGIN_STARTED) {
		int result = 0; // 100% fails if executed with List::contains
		ListItem * item = this->first;
		while (item) {
			if (item->data == data) {
				result = 1;
				break;
			}
			item = item->next;
		}
		_xend();
		return 0;
	} else {
		return 1;
	}
}

int main(int argc, char *argv[]) {
	int loops = argc > 1 ? atoi(argv[1]) : 100;
	int baseInsertsStep = argc > 2 ? atoi(argv[2]) : 5000;
	printf(
			"Base inserts;Failure rate base contains;Failure rate derived contains\n");

	for (int baseInserts = 0; baseInserts <= 15000; baseInserts +=
			baseInsertsStep) {
		printf("%d", baseInserts);
		Stats baseStats;
		Stats derivedStats;
		for (int l = 0; l < loops; l++) {
			// base
			ThreadsafeListRtm * list1 = new ThreadsafeListRtm();
			for (int bi = 0; bi < baseInserts; bi++)
				list1->insert(bi);
			baseStats.addValue(list1->contains(0));
			// derived
			ThreadsafeListRtm * list2 = new ThreadsafeListRtm();
			for (int bi = 0; bi < baseInserts; bi++)
				list2->insert(bi);
			derivedStats.addValue(list2->containsRtm(0));
		}
		printf(";%.2f;%.2f\n", baseStats.getExpectedValue(),
				derivedStats.getExpectedValue());
	}
}
