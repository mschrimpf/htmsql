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
	ListItem * item = this->first;
	while (item) {
		ListItem * next = item->next;
		delete item;
		item = next;
	}
	this->first = this->last = NULL;
}

ListItem* List::insert(int data) {
	return this->insertHead(data);
}
ListItem* List::insertHead(int data) {
	ListItem * item = new ListItem(data, NULL, this->first);
	this->first = item;
	if (this->last == NULL)
		this->last = item;
	return item;
}
ListItem* List::insertTail(int data) {
	ListItem * item = new ListItem(data, this->last, NULL);
	this->last = item;
	if (this->first == NULL)
		this->first = item;
	return item;
}

void List::remove(int data, int removeAll) {
	ListItem * prev = NULL;
	ListItem * item = this->first;
	while (item) {
		if (item->data == data) {
			if (prev == NULL) // item is start item
				this->first = item->next;
			else
				prev->next = item->next;
			delete item;
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

void List::print() {
	ListItem * item = this->first;
	while (item) {
		printf("%d ", item->data);
		item = item->next;
	}
	printf("\n");
}
