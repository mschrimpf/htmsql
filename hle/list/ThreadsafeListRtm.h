#ifndef THREADSAFE_LIST_RTM_H_
#define THREADSAFE_LIST_RTM_H_

#include "ThreadsafeList.h" // extend


class ThreadsafeListRtm : public ThreadsafeList {
public:
	ThreadsafeListRtm();
	~ThreadsafeListRtm();
	ListItem* insert(int data);
	void remove(int data, int removeAll = 0);
	int contains(int data);
};

#endif /* THREADSAFE_LIST_RTM_H_ */
