#ifndef THREADSAFE_PRE_ALLOCATED_LIST_RTM_H_
#define THREADSAFE_PRE_ALLOCATED_LIST_RTM_H_

#include "ThreadsafePreAllocatedList.h" // extend


class ThreadsafePreAllocatedListRtm : public PreAllocatedList {
public:
	ThreadsafePreAllocatedListRtm();
	~ThreadsafePreAllocatedListRtm();

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

#endif /* THREADSAFE_PRE_ALLOCATED_LIST_RTM_H_ */
