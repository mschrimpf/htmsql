#ifndef ALLOCATOR_H_
#define ALLOCATOR_H_ 1

#include "ListItem.h"

class Allocator {
public:
	virtual ListItem* createListItem(int data, ListItem * prev,
			ListItem * next) = 0;
	virtual void deleteListItem(ListItem * item) = 0;
};

#endif // ALLOCATOR_H_
