#ifndef DEFAULT_ALLOCATOR_H_
#define DEFAULT_ALLOCATOR_H_ 1

#include "Allocator.h"

class DefaultAllocator : public Allocator {
public:
	virtual ListItem* createListItem(int data, ListItem * prev,			ListItem * next);
	virtual void deleteListItem(ListItem * item);
};

#endif // DEFAULT_ALLOCATOR_H_
