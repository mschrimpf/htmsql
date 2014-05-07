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
				"insertTail");
		exit(1);
	}
}

ListItem * ListRtm::findAndRemoveFromList(int data) {
	int failures = 0;
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		ListItem * item = List::findAndRemoveFromList(data);

// get
//		ListItem * item = this->first;
//		while (item) {
//			if (item->data == data)
//				break;
//			item = item->next;
//		}
//		// removefromlist
//		if (item != NULL) {
//			ListItem * prev = item->prev;
//			ListItem * next = item->next;
//
//			if (item == this->first)
//				this->first = next;
//			if (item == this->last)
//				this->last = prev;
//
//			if (next != NULL)
//				next->prev = prev;
//			if (prev != NULL)
//				prev->next = next;
//		}

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
