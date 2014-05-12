#ifndef PRE_ALLOCATOR_H_
#define PRE_ALLOCATOR_H_ 1

#include "Allocator.h"
#include <vector>

class PreAllocator: public Allocator {
private:
	// items marked with -1 are free to use
	std::vector<ListItem> allocations;
	/** last slot an item has been allocated from */
	int last_allocation_slot = -1;
public:
	PreAllocator();
	ListItem* createListItem(int data, ListItem * prev, ListItem * next);
	void deleteListItem(ListItem * item);
};

#endif // PRE_ALLOCATOR_H_
