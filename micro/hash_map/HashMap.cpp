/*
 * HashMap.cpp
 *
 *  Created on: 27.10.2013
 *      Author: Martin
 */

#include <stdio.h>
#include <stdlib.h>
#include <cstdlib>
#include <ctime>
#include <iostream>
#include <immintrin.h>

#include "HashMap.h"
#include "LockException.h"

LinkedListItem::LinkedListItem(int data, LinkedListItem *successor) {
	init(data, successor);
}
LinkedListItem::LinkedListItem(int data) {
	init(data, NULL);
}
void LinkedListItem::init(int data, LinkedListItem *successor) {
	this->data = data;
	this->successor = successor;
}

//
// HashMap
//
/**
 * Initializes an empty HashMap.
 */
HashMap::HashMap(int size) {
	this->size = size;
	this->map = (LinkedListItem**) calloc(size, sizeof(LinkedListItem*));
}

HashMap::~HashMap() {
	for (int i = 0; i < size; i++) {
		LinkedListItem* item = this->map[i];
		while (item) {
			LinkedListItem* old = item;
			item = item->successor;
			delete old;
		}
		map[i] = NULL;
	}
	free(this->map);
}

/**
 * Inserts the value at its hash position into the map
 * @return a pointer referencing the newly inserted LinkedListItem or a pointer to the LinkedListItem with the same value that has already been existent in the hash_map
 */
LinkedListItem* HashMap::insert(int value) {
	int h = hash(value);

	retry: if (_xbegin() == _XBEGIN_STARTED) {
		if (! map[h]) { // item not set
			map[h] = new LinkedListItem(value);
			_xend();
			return map[h];
		} else {
			// search for first non-set item
			LinkedListItem* last_item = map[h];
			LinkedListItem* item_ptr = map[h]->successor;
			if (last_item->data == value) { // item holding same data exists
//			fprintf(/*stderr*/stdout, "Value %d already exists in hash_map\n",value);
				_xend();
				return last_item;
			}
			while (item_ptr) {
				if (item_ptr->data == value) { // item holding same data exists
//				fprintf(/*stderr*/stdout, "Value %d already exists in hash_map\n", value);
					_xend();
					return item_ptr;
				}
				last_item = item_ptr;
				item_ptr = (*last_item).successor;
			}
			// insert new item after last item
			LinkedListItem* insert_item = new LinkedListItem(value);
			last_item->successor = insert_item;
			_xend();
			return insert_item;
		}
	} else {
		// goto retry;
		throw LockException();
	}
}
/**
 * Removes the value from the map.
 * @return 1 if the value has successfully been removed, 0 if the value could not be found
 * @throws exception if the lock could not be acquired
 */
int HashMap::remove(int value) {
	int h = hash(value);
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		LinkedListItem *prev_item = 0;
		LinkedListItem *item = map[h] ? map[h] : 0;
		// search for item holding data
		while (item && item->data != value) {
			prev_item = item;
			item = item->successor;
		}
		if (item && item->data == value) {
			if (prev_item) { // prev_item exists -> map[h] is set
				prev_item->successor = item->successor;
				delete item;
			} else { // searched value is at first list-position
				if (item->successor) {
					LinkedListItem* new_item = item->successor;
					delete item;
					map[h] = new_item;
				} else {
					delete map[h];
					map[h] = NULL;
				}
			}
			_xend();
			return 1;
		} else {
//		fprintf(/*stderr*/stdout, "Value %d not found in hash_map\n", value);
//			_xend();
			return 0;
		}
	} else {
		throw LockException();
	}
}

/**
 * Returns a hash-key for the value.
 */
int HashMap::hash(int value) {
	return value % size;
}

// printing
/**
 * Prints all keys of a hash_map followed by their values.
 */
void HashMap::print() {
	printf("Map size: %d\n", size);
	int elements = 0;
	for (int i = 0; i < size; i++) {
		printf("[%d] => ", i);
		// printf("\t%d\n", map[i].data);
		if (map[i]) {
			elements += printLinkedList(map[i]);
		} else {
			printf("\n");
		}
	}
	printf("Elements: %d\n", elements);
}
/**
 * Prints all data of a LinkedListItem*.
 * @return the size of the list
 */
int HashMap::printLinkedList(LinkedListItem* item) {
	int size = 0;
	while (1) {
		size++;
		printf("%d", item->data);
		LinkedListItem* successor = item->successor;
		if (successor) {
			printf(" -> ");
			item = successor;
		} else {
			printf("\n");
			return size;
		}
	}
}
