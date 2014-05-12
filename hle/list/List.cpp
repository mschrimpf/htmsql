#include "List.h"
#include <stdlib.h>
#include <stdio.h>

List::List(Allocator * allocator) {
	this->allocator = allocator;
	this->first = this->last = NULL;
}
List::~List() {
	this->deleteAll(this->first);
	this->first = this->last = NULL;
}

ListItem* List::insert(int data) {
	ListItem * item = allocator->createListItem(data, NULL, NULL);
	this->insertTail(item);
	return item;
}

void List::insertTail(ListItem * item) {
	item->prev = this->last;
	if (this->last != NULL)
		this->last->next = item;
	this->last = item;
	if (this->first == NULL)
		this->first = item;
}

void List::removeFromList(ListItem * item) {
	if (item == NULL)
		return;

	ListItem * prev = item->prev;
	ListItem * next = item->next;

	if (item == this->first)
		this->first = next;
	if (item == this->last)
		this->last = prev;

	if (next != NULL)
		next->prev = prev;
	if (prev != NULL)
		prev->next = next;
}

void List::remove(ListItem * item) {
	if (item == NULL)
		return;
	removeFromList(item);
	this->allocator->deleteListItem(item);
}

void List::remove(int data) {
	ListItem * item = findAndRemoveFromList(data);
	this->allocator->deleteListItem(item);
}

ListItem * List::findAndRemoveFromList(int data) {
	// when get is protected, rewrite the logic of this function
	ListItem * item = get(data);
	removeFromList(item);
	return item;
}

int List::contains(int data) {
	if (get(data) != NULL)
		return 1;
	return 0;
}

ListItem* List::get(int data) {
	ListItem * item = this->first;
	while (item) {
		if (item->data == data) // 83.78% * 43.46% = 36.41% of aborts
			return item;
		item = item->next;
	}
	return NULL;
}

void List::deleteAll(ListItem * list) {
	while (list) {
		ListItem * next = list->next;
		this->allocator->deleteListItem(list);
		list = next;
	}
}

int List::size() {
	int count = 0;
	ListItem * item = this->first;
	while (item) {
		count++;
		item = item->next;
	}
	return count;
}

void List::print() {
	ListItem * item = this->first;
	while (item) {
		printf("%d ", item->data);
		item = item->next;
	}
}
