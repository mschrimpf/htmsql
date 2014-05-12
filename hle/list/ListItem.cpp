#include "ListItem.h"


ListItem::ListItem(int data, ListItem * prev, ListItem * next) {
	this->data = data;
	this->prev = prev;
	this->next = next;
}
