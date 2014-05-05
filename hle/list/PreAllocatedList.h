#ifndef _PRE_ALLOCATED_LIST_H_
#define _PRE_ALLOCATED_LIST_H_ 1

#include "List.h"
#include <vector>

class PreAllocatedList: public List {
private:
	// items marked with -1 are free to use
	std::vector<ListItem> allocations;
	/** last slot an item has been allocated from */
	int last_allocation_slot = -1;

public:
	PreAllocatedList();
	~PreAllocatedList();


	virtual ListItem* createListItem(int data, ListItem * prev, ListItem * next);
	virtual void deleteListItem(ListItem * item);
};

#endif // _PRE_ALLOCATED_LIST_H_
