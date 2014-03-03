/*
 * HashMap.h
 *
 *  Created on: 27.10.2013
 *      Author: Martin
 */

#ifndef HASHMAP_H_
#define HASHMAP_H_

#include "../lock_functions/LockType.h"

class LinkedListItem {
public:
	LinkedListItem *successor;
	int data;
	LinkedListItem(int data);
	LinkedListItem(int data, LinkedListItem *successor);
private:
	void init(int data, LinkedListItem *successor);
};

class HLEBucket {
public:
	LinkedListItem *item;
	LockType locker; // could make this a reference member: LockType &locker
	HLEBucket(LockType locker);
	HLEBucket(LinkedListItem *item, LockType locker);
	~HLEBucket();
private:
	void init(LinkedListItem *item, LockType locker);
};

class HashMap {
private:
	int size;
	HLEBucket** map;
	int hash(int value);
	int printLinkedList(LinkedListItem* item);

public:
	HashMap(int size, LockType locker);
	~HashMap();
	LinkedListItem* insert(int value);
	int remove(int value);
	int contains(int value);
	int countElements();

	void print();
	void printLocks();
};

#endif /* HASHMAP_H_ */
