#include "ThreadsafePreAllocatedListRtm.h"
#include <immintrin.h>
#include <stdio.h>

const int MAX_RETRIES = 10000000;

ThreadsafePreAllocatedListRtm::ThreadsafePreAllocatedListRtm() :
		PreAllocatedList() {
}
ThreadsafePreAllocatedListRtm::~ThreadsafePreAllocatedListRtm() {
}

ListItem* ThreadsafePreAllocatedListRtm::insertHead(ListItem * item) {
	int failures = 0;
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		ListItem * result = List::insertHead(item);
		_xend();
		return result;
	} else if (++failures < MAX_RETRIES) {
		goto retry;
	} else {
		fprintf(stderr, "Max failures %d reached in function %s\n", failures,
				"insertHead");
		exit(1);
	}
}

//ListItem* ThreadsafeListRtm::insertTail(ListItem * item) {
//	int failures = 0;
//	retry: if (_xbegin() == _XBEGIN_STARTED) {
//		ListItem * result = List::insertTail(item);
//		_xend();
//		return result;
//	} else if (++failures <= MAX_RETRIES) {
//		goto retry;
//	} else {
//		fprintf(stderr, "Max failures %d reached in function %s\n", failures,
//				"insertTail");
//		exit(1);
//	}
//}

void ThreadsafePreAllocatedListRtm::remove(int data, int removeAll) {
	ListItem * removeList = NULL; // build a list of items to be removed to remove them outside htm
	ListItem * prev = NULL;

	int failures = 0;
	retry: if (_xbegin() == _XBEGIN_STARTED) {
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
		_xend();
	} else if (++failures <= MAX_RETRIES) {
		goto retry;
	} else {
		fprintf(stderr, "Max failures %d reached in function %s\n", failures,
				"remove");
		exit(1);
	}

	// delete all items in the remove list
	this->deleteAll(removeList);
}

int ThreadsafePreAllocatedListRtm::contains(int data) {
	int failures = 0;
	retry: if (_xbegin() == _XBEGIN_STARTED) {
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
		return result;
	} else if (++failures <= MAX_RETRIES) {
		goto retry;
	} else {
		fprintf(stderr, "Max failures %d reached in function %s\n", failures,
				"contains");
		exit(1);
	}
}
