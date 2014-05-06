#include "List.h"
#include <stdlib.h>
#include <stdio.h>

ListItem::ListItem(int data, ListItem * prev, ListItem * next) {
	this->data = data;
	this->prev = prev;
	this->next = next;
}

List::List() {
	this->first = this->last = NULL;
}
List::~List() {
	this->deleteAll(this->first);
	this->first = this->last = NULL;
}

ListItem* List::createListItem(int data, ListItem * prev, ListItem * next) {
	return new ListItem(data, prev, next);
}

void List::deleteListItem(ListItem * item) {
	delete item;
}

ListItem* List::insert(int data) {
	ListItem * item = createListItem(data, NULL, NULL);
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
	deleteListItem(item);
}

int List::contains(int data) {
	if (get(data) != NULL)
		return 1;
	return 0;
}

ListItem* List::get(int data) {
	ListItem * item = this->first;
	while (item) {
		if (item->data == data)
			return item;
		item = item->next;
	}
	return NULL;
}

void List::deleteAll(ListItem * list) {
	while (list) {
		ListItem * next = list->next;
		deleteListItem(list);
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
