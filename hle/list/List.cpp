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
	if (this->contains(data))
		return NULL;
	ListItem * item = createListItem(data, NULL, NULL);
	return this->insertHead(item);
}
ListItem* List::insertHead(ListItem * item) {
	item->next = this->first;
	this->first = item;
	if (this->last == NULL)
		this->last = item;
	return item;
}
//ListItem* List::insertTail(ListItem * item) {
//	item->prev = this->last;
//	this->last = item;
//	if (this->first == NULL)
//		this->first = item;
//	return item;
//}

void List::remove(int data, int removeAll) {
	ListItem * prev = NULL;
	ListItem * item = this->first;
	while (item) {
		if (item->data == data) {
			if (prev == NULL) // item == this->first
				this->first = item->next;
			else
				prev->next = item->next;
			deleteListItem(item);
			if (!removeAll)
				break;
		}
		prev = item;
		item = item->next;
	}
}

int List::contains(int data) {
	ListItem * item = this->first;
	while (item) {
		if (item->data == data)
			return 1;
		item = item->next;
	}
	return 0;
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
