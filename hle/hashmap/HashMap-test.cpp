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
#include <thread>

#include "HashMap.h"


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

HLEBucket::HLEBucket(LinkedListItem *item, LockType locker) {
	init(item, locker);
}
HLEBucket::HLEBucket(LockType locker) {
	init(NULL, locker);
}
void HLEBucket::init(LinkedListItem *item, LockType locker) {
	this->item = item;
	this->locker = locker;
}
HLEBucket::~HLEBucket() {
	LinkedListItem* item = this->item;
	while (item) {
		LinkedListItem* old = item;
		item = item->successor;
		delete old;
	}
	this->item = NULL;
}

//
// HashMap
//
/**
 * Initializes an empty HashMap.
 */
HashMap::HashMap(int size, LockType locker) {
	this->size = size;
	this->map = (HLEBucket**) calloc(size, sizeof(HLEBucket*));
	for (int i = 0; i < size; i++) {
		this->map[i] = new HLEBucket(locker);
//		printf("Locker[%d]: %p | mutex: %p\n", i, &this->map[i]->locker, &this->map[i]->locker.type_mutex);
	}
}

HashMap::~HashMap() {
	for (int i = 0; i < this->size; i++) {
		delete map[i];
		map[i] = NULL;
	}
	free(this->map);
	this->map = NULL;
}

/**
 * Inserts the value at its hash position into the map.
 * This function is thread-safe, the return pointer however is not.
 * @return a pointer referencing the newly inserted LinkedListItem or a pointer to the LinkedListItem with the same value that has already been existent in the hash_map
 */
LinkedListItem* HashMap::insert(int value) {
	int h = hash(value);

	((map[h]->locker).*((map[h]->locker).lock))();

	LinkedListItem *prev_item = NULL;
	LinkedListItem *item_ptr = map[h]->item;
	while (item_ptr) { // move to last list item
		if (item_ptr->data == value) { // value already exists
			((map[h]->locker).*((map[h]->locker).unlock))();
			return item_ptr;
		}
		prev_item = item_ptr; // next
		item_ptr = item_ptr->successor;
	}
	LinkedListItem* insert_item = new LinkedListItem(value);
	if (prev_item) { // item(s) in list
		// -> link to new item from list
		prev_item->successor = insert_item;
	} else { // list is empty
		// -> link to new item from bucket
		map[h]->item = insert_item;
	}

	((map[h]->locker).*((map[h]->locker).unlock))();
	return insert_item;
}
/**
 * Removes the value from the map.
 * This function is thread-safe (note that the return value is related to the current state of the hashmap for the current thread).
 * @return 1 if the value has successfully been removed, 0 if the value could not be found
 * @throws exception if the lock could not be acquired
 */
int HashMap::remove(int value) {
	int h = hash(value);
//	std::thread::id thread_id = std::this_thread::get_id();
//	std::cout << "[Thread " << thread_id << "] ";
//	printf("Locking on locker %p | hash %d | value %d\n", &map[h]->locker, h,
//			value);
	LinkedListItem *prev_item = NULL;
	((map[h]->locker).*((map[h]->locker).lock))();
	LinkedListItem *item = map[h]->item;
	// search for item holding data
	while (item && item->data != value) {
		prev_item = item;
		item = item->successor;
	}
	if (item) { // value contained in map
//	    std::cout << "[Thread " << thread_id << "] ";
//		printf("Value %d found in map for item %p\n", value, item);
		if (prev_item) { // prev_item exists -> map[h] is set
			prev_item->successor = item->successor;
//			printf("delete item %p (prev_item) - ",  item);
		} else { // value we search for is at first list-position
			LinkedListItem* successor = item->successor;
			map[h]->item = successor;

		}
//	    std::cout << "[Thread " << thread_id << "] ";
//		printf("Deleting item %p\n",  item);
		delete item; // TODO leads to: double free or corruption (fasttop)
//		std::cout << "[Thread " << thread_id << "] unlocking\n";
		((map[h]->locker).*((map[h]->locker).unlock))();
		return 1;
	} else { // value does not exist in map
//		fprintf(/*stderr*/stdout, "Value %d not found in hash_map\n", value);
		((map[h]->locker).*((map[h]->locker).unlock))();
		return 0;
	}
}

/**
 * Returns 1 if the value is contained, 0 otherwise
 */
int HashMap::contains(int value) {
	int h = this->hash(value);

	((map[h]->locker).*((map[h]->locker).lock))();
	// search for item
	LinkedListItem* item_ptr = map[h]->item;
	while (item_ptr) {
		if (item_ptr->data == value) { // found it
			((map[h]->locker).*((map[h]->locker).unlock))();
			return 1;
		}
		item_ptr = item_ptr->successor;
	}
	((map[h]->locker).*((map[h]->locker).unlock))();
	return 0;
}
/**
 * Returns the amount of elements in this map
 */
int HashMap::countElements() {
	int count = 0;
	LinkedListItem *item_ptr;
	for (int i = 0; i < size; i++) {
		item_ptr = map[i]->item;
		while (item_ptr) {
			count++;
			item_ptr = item_ptr->successor;
		}
	}
	return count;
}

/**
 * Returns a hash-key for the value.
 */
int HashMap::hash(int value) {
	return value % size;
}

// printing

void HashMap::printLocks() {
	for (int i = 0; i < size; i++) {
//		printf("&map[%d] type: %p | p_mutex: %p\n", i, &map[i]->locker.type_mutex, &map[i]->locker.p_mutex);
	}
	printf("--\n");
}

/**
 * Prints all keys of a hash_map followed by their values.
 */
void HashMap::print() {
	printf("Map size: %d\n", size);
	int elements = 0;
	for (int i = 0; i < size; i++) {
		printf("[%d] => ", i);
		// printf("\t%d\n", map[i].data);
		((map[i]->locker).*((map[i]->locker).lock))();
		if (map[i]->item) {
			elements += printLinkedList(map[i]->item);
		} else {
			printf("\n");
		}
		((map[i]->locker).*((map[i]->locker).unlock))();
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
