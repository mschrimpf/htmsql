/*
 * HashMap.h
 *
 *  Created on: 27.10.2013
 *      Author: Martin
 */

#ifndef HASHMAP_H_
#define HASHMAP_H_

class LinkedListItem {
public:
	LinkedListItem *successor;
	int data;
	LinkedListItem(int data);
	LinkedListItem(int data, LinkedListItem *successor);
private:
	void init(int data, LinkedListItem *successor);
};

class HashMap {
private:
	int size;
	LinkedListItem** map;
	int hash(int value);
	int printLinkedList(LinkedListItem* item);

public:
	HashMap(int size);
	~HashMap();
	LinkedListItem* insert(int value);
	int remove(int value);

	void print();
};

#endif /* HASHMAP_H_ */
