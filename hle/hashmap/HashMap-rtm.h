/*
 * HashMap-rtm.h
 *
 *  Created on: 01.04.2014
 *      Author: Martin
 */

#ifndef HASHMAP_RTM_H_
#define HASHMAP_RTM_H_

#include "HashMap.h" // extend


class HashMapRtm : public HashMap {
public:
	HashMapRtm(int size);
	~HashMapRtm();
	LinkedListItem* insert(int value);
	int remove(int value);
	int contains(int value);

	void print();
};

#endif /* HASHMAP_RTM_H_ */
