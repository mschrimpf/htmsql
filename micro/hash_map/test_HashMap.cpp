/*
 * test_HashMap.cpp
 *
 *  Created on: 27.10.2013
 *      Author: Martin
 */

#include <stdio.h>
#include <stdlib.h>

#include "HashMap.h"

int main(int argc, char *argv[]) {
	int size = argc > 1 ? atoi(argv[1]) : 10;
	HashMap map(size);

	// save inserts
	LinkedListItem* inserted_values; // start pointer
	LinkedListItem* inserted_values_ptr = NULL; // index pointer
	// insert data
	int inserts = argc > 2 ? atoi(argv[2]) : 10;
//	srand(time(NULL)); // set initial random value dependent on time
	for (int i = 0; i < inserts; i++) {
		int insert_val = rand(); // % 100;
//		printf("Inserting %d\n", insert_val);
		map.insert(insert_val);
		// save
		LinkedListItem* new_insert = new LinkedListItem(insert_val);
		if (inserted_values_ptr) {
			inserted_values_ptr->successor = new_insert;
		} else {
			inserted_values = new_insert;
		}
		inserted_values_ptr = new_insert;
	}
	map.print();

	// delete some of the data
	inserted_values_ptr = inserted_values;
	int removals = 0;
	while (inserted_values_ptr) {
		if (rand() % 2 == 0) {
			printf("remove %d\n", inserted_values_ptr->data);
			removals += map.remove(inserted_values_ptr->data);
		}
		inserted_values_ptr = inserted_values_ptr->successor;
	}
//	printf("Removals: %d\n", removals);
	map.print();

	// clean up
	LinkedListItem* item = inserted_values;
	while (item) {
		LinkedListItem* old = item;
		item = item->successor;
		delete old;
	}
	inserted_values = inserted_values_ptr = NULL;
	printf("Done\n");

	return 0;
}
