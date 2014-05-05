#ifndef THREADSAFE_LIST_RTM_H_
#define THREADSAFE_LIST_RTM_H_

#include "ThreadsafeList.h" // extend


class ThreadsafeListRtm : public List {
public:
	ThreadsafeListRtm();
	~ThreadsafeListRtm();

	ListItem * insertHead(ListItem * item);
//	ListItem * insertTail(ListItem * item);
	/**
	 * Removes the occurrences of data in the list.
	 * If removeAll is != 0, all occurrences are removed, otherwise only the first one.
	 * */
	void remove(int data, int removeAll = 0);
	/** @return 1 if data is contained, 0 if not */
	int contains(int data);
};

#endif /* THREADSAFE_LIST_RTM_H_ */
