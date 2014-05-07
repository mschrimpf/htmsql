#include "PreAllocatedListRtm.h"
#include <immintrin.h>
#include <stdio.h>

const int MAX_RETRIES = 100000;

PreAllocatedListRtm::PreAllocatedListRtm() :
		PreAllocatedList() {
}
PreAllocatedListRtm::~PreAllocatedListRtm() {
}

void PreAllocatedListRtm::insertTail(ListItem * item) {
	int failures = 0;
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		PreAllocatedList::insertTail(item);
		_xend();
	} else if (++failures < MAX_RETRIES) {
		goto retry;
	} else {
		fprintf(stderr, "Max failures %d reached in function %s\n", failures,
				"insertTail");
		exit(1);
	}
}

ListItem* PreAllocatedListRtm::createListItem(int data,
		ListItem * prev, ListItem * next) {
	int failures = 0;
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		ListItem * result = PreAllocatedList::createListItem(data, prev, next);
		_xend();
		return result;
	} else if (++failures < MAX_RETRIES) {
		goto retry;
	} else {
		fprintf(stderr, "Max failures %d reached in function %s\n", failures,
				"createListItem");
		exit(1);
	}
}

ListItem * PreAllocatedListRtm::findAndRemoveFromList(int data) {
	int failures = 0;
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		ListItem * item = this->List::findAndRemoveFromList(data);
		_xend();
		return item;
	} else if (++failures < MAX_RETRIES) {
		goto retry;
	} else {
		fprintf(stderr, "Max failures %d reached in function %s\n", failures,
				"findAndRemoveFromList");
		exit(1);
	}
}
