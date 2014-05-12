#ifndef ALIGNED_ALLOCATOR_H_
#define ALIGNED_ALLOCATOR_H_ 1

#include "Allocator.h"

class AlignedAllocator : public Allocator {
public:
	virtual ListItem* createListItem(int data, ListItem * prev,			ListItem * next);
	virtual void deleteListItem(ListItem * item);
};

#endif // ALIGNED_ALLOCATOR_H_
