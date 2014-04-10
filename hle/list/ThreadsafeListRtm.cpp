#include "ThreadsafeListRtm.h"
#include <immintrin.h>
#include <stdio.h>

const int MAX_RETRIES = 10000000;
LockType rtm_locker(LockType::NONE);

ThreadsafeListRtm::ThreadsafeListRtm() :
		ThreadsafeList(rtm_locker) {
}
ThreadsafeListRtm::~ThreadsafeListRtm() {
}

ListItem* ThreadsafeListRtm::insert(int data) {
	int failures = 0;
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		ListItem * result = this->list->insert(data);
		_xend();
		return result;
	} else if (++failures <= MAX_RETRIES) {
		goto retry;
	} else {
		fprintf(stderr, "Max failures %d reached in function %s\n", failures, "insert");
		exit(1);
	}
}

void ThreadsafeListRtm::remove(int data, int removeAll) {
	int failures = 0;
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		this->list->remove(data, removeAll);
		_xend();
	} else if (++failures <= MAX_RETRIES) {
		goto retry;
	} else {
		fprintf(stderr, "Max failures %d reached in function %s\n", failures, "remove");
		exit(1);
	}
}

int ThreadsafeListRtm::contains(int data) {
	int failures = 0;
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		int result = this->list->contains(data);
		_xend();
		return result;
	} else if (++failures <= MAX_RETRIES) {
		goto retry;
	} else {
		fprintf(stderr, "Max failures %d reached in function %s\n", failures, "contains");
		exit(1);
	}
}
