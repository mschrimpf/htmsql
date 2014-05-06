#ifndef PRE_ALLOCATED_LIST_RTM_H_
#define PRE_ALLOCATED_LIST_RTM_H_

#include "PreAllocatedList.h" // extend

class PreAllocatedListRtm: public PreAllocatedList {
public:
	PreAllocatedListRtm();
	~PreAllocatedListRtm();

	void insertTail(ListItem * item);
	ListItem * createListItem(int data,
			ListItem * prev, ListItem * next);
	virtual void removeFromList(ListItem * item);
	/**
	 * @return the list item holding the specified data or NULL if no such item exists
	 */
	virtual ListItem * get(int data);
};

#endif /* PRE_ALLOCATED_LIST_RTM_H_ */
