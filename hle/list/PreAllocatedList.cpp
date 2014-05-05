#include "PreAllocatedList.h"
#include <stdlib.h>
#include <stdio.h>

const int allocations_size = 1000;

PreAllocatedList::PreAllocatedList() {
	allocations.reserve(allocations_size); //  reserve the memory upfront
	for (int i = 0; i < allocations_size; ++i)
		allocations.push_back(ListItem(-1, NULL, NULL)); // ith element is a copy of this
}
PreAllocatedList::~PreAllocatedList() {
	this->first = this->last = NULL;
}

ListItem* PreAllocatedList::createListItem(int data, ListItem * prev,
		ListItem * next) {
	// find free item to allocate
	int allocation_slot_begin = last_allocation_slot;
	do {
		last_allocation_slot = (last_allocation_slot + 1) % allocations_size;
		ListItem * item = &(allocations[last_allocation_slot]);
		if (item->data == -1) {
			item->data = data;
			item->prev = prev;
			item->next = next;
			return item;
		}
	} while (last_allocation_slot != allocation_slot_begin);
	fprintf(stderr, "Error: no space in pre-allocated list items available\n");
	exit(1);
}
void PreAllocatedList::deleteListItem(ListItem * item) {
	item->data = -1; // indicate as free
	item->prev = NULL;
	item->next = NULL;
}
