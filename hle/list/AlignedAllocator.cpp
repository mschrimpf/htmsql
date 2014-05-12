#include "AlignedAllocator.h"
#include <stdlib.h>
#include <stdio.h>

const int cache_line_size = 64;

ListItem* AlignedAllocator::createListItem(int data, ListItem * prev,
		ListItem * next) {
	ListItem * item = (ListItem *) aligned_alloc(cache_line_size, sizeof(ListItem));
	item->data = data;
	item->prev = prev;
	item->next = next;
	return item;
}
void AlignedAllocator::deleteListItem(ListItem * item) {
	delete item;
}
