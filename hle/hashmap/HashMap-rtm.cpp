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
#include <immintrin.h> // RTM
#include "HashMap-rtm.h"
#include "../lock_functions/LockType.h"

const int MAX_RETRIES = 1000000;

LockType rtm_locker(LockType::NONE);

HashMapRtm::HashMapRtm(int size) :
		HashMap(size, rtm_locker) {
}
HashMapRtm::~HashMapRtm() {
}

/**
 * Inserts the value at its hash position into the map.
 * This function is thread-safe, the return pointer however is not.
 * @return a pointer referencing the newly inserted LinkedListItem or a pointer to the LinkedListItem with the same value that has already been existent in the hash_map
 */
LinkedListItem* HashMapRtm::insert(int value) {
	int h = hash(value);

	int failures = 0;
	LinkedListItem* insert_item = new LinkedListItem(value);
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		LinkedListItem *prev_item = NULL;
		LinkedListItem *item_ptr = map[h]->item;
		while (item_ptr) { // move to last list item
			if (item_ptr->data == value) { // value already exists
				_xend();
				delete insert_item;
				return item_ptr;
			}
			prev_item = item_ptr; // next
			item_ptr = item_ptr->successor;
		}
		if (prev_item) { // list not empty
			// -> link to new item from list
			prev_item->successor = insert_item;
		} else { // list is empty
			// -> link to new item from bucket
			map[h]->item = insert_item;
		}

		_xend();
		return insert_item;
	} else {
		if (++failures < MAX_RETRIES)
			goto retry;
		else {
			this->maxRetries("insert", value);
			exit(1);
		}
	}
}
/**
 * Removes the value from the map.
 * This function is thread-safe (note that the return value is related to the current state of the hashmap for the current thread).
 * @return 1 if the value has successfully been removed, 0 if the value could not be found
 * @throws exception if the lock could not be acquired
 */
int HashMapRtm::remove(int value) {
	int h = hash(value);
	LinkedListItem *prev_item = NULL;
	int failures = 0;
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		LinkedListItem *item = map[h]->item;
		// search for item holding data
		while (item && item->data != value) {
			prev_item = item;
			item = item->successor;
		}
		if (item) { // value contained in map
			if (prev_item) { // prev_item exists -> map[h] is set
				prev_item->successor = item->successor;
			} else { // value we search for is at first list-position
				LinkedListItem* successor = item->successor;
				map[h]->item = successor;
			}
			_xend();
			delete item;
			return 1;
		} else { // value does not exist in map
			_xend();
			return 0;
		}
	} else {
		if (++failures < MAX_RETRIES)
			goto retry;
		else {
			this->maxRetries("remove", value);
			exit(1);
		}
	}
}

/**
 * Checks whether the given value is contained in this Hashmap.
 * @return 1 if the value is contained, 0 otherwise
 */
int HashMapRtm::contains(int value) {
	int h = this->hash(value);

	int failures = 0;
	retry: if (_xbegin() == _XBEGIN_STARTED) {
		// search for item
		LinkedListItem* item_ptr = map[h]->item;
		while (item_ptr) {
			if (item_ptr->data == value) { // found it
				_xend();
				return 1;
			}
			item_ptr = item_ptr->successor;
		}
		_xend();
		return 0;
	} else {
		if (++failures < MAX_RETRIES)
			goto retry;
		else {
			this->maxRetries("contains", value);
			exit(1);
		}
	}
}

void HashMapRtm::maxRetries(const char *function_name, int value) {
	this->print();
	fprintf(stderr, "Max retries reached for %s %d\n", function_name, value);
}
