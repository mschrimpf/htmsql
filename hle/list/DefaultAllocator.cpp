#include "DefaultAllocator.h"

const int cache_line_size = 64;

ListItem* DefaultAllocator::createListItem(int data, ListItem * prev,
		ListItem * next) {
	return new ListItem(data, prev, next);
}
void DefaultAllocator::deleteListItem(ListItem * item) {
	delete item;
}
