#include "ListRtm.h"
#include <immintrin.h>
#include <stdio.h>

const int MAX_RETRIES = 10000000;

ListRtm::ListRtm() :
		List() {
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
				"insertHead");
		exit(1);
	}
}

void ListRtm::removeFromList(ListItem * item) {
	int failures = 0;
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		List::removeFromList(item);
		_xend();
	} else if (++failures <= MAX_RETRIES) {
		goto retry;
	} else {
		fprintf(stderr, "Max failures %d reached in function %s\n", failures,
				"remove");
		exit(1);
	}
}

ListItem * ListRtm::get(int data) {
	int failures = 0;
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		ListItem * result = List::get(data);
		_xend();
		return result;
	} else if (++failures < MAX_RETRIES) {
		goto retry;
	} else {
		fprintf(stderr, "Max failures %d reached in function %s\n", failures,
				"contains");
		exit(1);
	}
}
