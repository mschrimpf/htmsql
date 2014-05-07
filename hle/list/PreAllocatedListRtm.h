#ifndef PRE_ALLOCATED_LIST_RTM_H_
#define PRE_ALLOCATED_LIST_RTM_H_

#include "PreAllocatedList.h" // extend

class PreAllocatedListRtm: public PreAllocatedList {
protected:
	virtual ListItem * findAndRemoveFromList(int data);
public:
	PreAllocatedListRtm();
	~PreAllocatedListRtm();

	void insertTail(ListItem * item);
	ListItem * createListItem(int data,
			ListItem * prev, ListItem * next);
};

#endif /* PRE_ALLOCATED_LIST_RTM_H_ */
