#include "ListRtm.h"
#include <immintrin.h>
#include <stdio.h>

const int MAX_RETRIES = 1000 * 1000 * 1000;

ListRtm::ListRtm(Allocator * allocator) :
		List(allocator) {
}
ListRtm::~ListRtm() {
}

void ListRtm::insertTail(ListItem * item) {
	int failures = 0;
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		List::insertTail(item);
		_xend();
	} else if (++failures < MAX_RETRIES) {
		goto retry;
	} else {
		fprintf(stderr, "Max failures %d reached in function %s\n", failures,
				"insertTail");
		exit(1);
	}
}

ListItem * ListRtm::get(int data) {
	int failures = 0;
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		ListItem * item = List::get(data);
		_xend();
		return item;
	} else if (++failures < MAX_RETRIES) {
		goto retry;
	} else {
		fprintf(stderr, "Max failures %d reached in function %s\n", failures,
				"get");
		exit(1);
	}
}

ListItem * ListRtm::findAndRemoveFromList(int data) {
	int failures = 0;
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		ListItem * item = this->List::get(data);
		this->List::removeFromList(item);
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
