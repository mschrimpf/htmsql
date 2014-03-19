/*
 * benchmark.cpp
 *
 *  Created on: 26.10.2013
 *      Author: Martin
 */
#include <stdlib.h>
#include <stdio.h>

#include "HashMap.h"
#include "LockException.h"
#include "util.h"

int main(int argc, char *argv[]) {
	// handle args
	int size = 10, inserts = 100, loops = 1000, variety = 0, print = 0;
	int *values[] = { &size, &inserts, &loops, &variety, &print };
	const char* identifier[] = { "-s", "-i", "-l", "-v", "-p" };
	handle_args(argc, argv, 5, values, identifier);

	if (variety > size) {
		fprintf(stderr, "The variety cannot be greater than the size!\n");
		return 1;
	}

	printf("size:    %d\n", size);
	printf("inserts: %d\n", inserts);
	printf("loops:   %d\n", loops);
	printf("variety: %d\n", variety);
	printf("____________\n");

	// run benchmark
	int attempts = 0;
	int failures = 0;

	for (int l = 0; l < loops; l++) {
		// initialize
		HashMap map(size);

		int insert_val = 0;
		int insert_val_increment = variety == 0 ? size : size / variety;
		for (int i = 0; i < inserts; i++) {
			insert_val += insert_val_increment;
			try {
				attempts++;
				map.insert(insert_val);
			} catch (const LockException& e) {
				failures++;
			}
		}

		if(print) {
			map.print();
		}
	}

	// print results
	printf("____________\n");
	printf("Attempts:   %d (%d inserts x %d loops)\n", attempts, inserts,
			loops);
	printf("Failures:   %d (Rate: % 5.2f%%)\n", failures,
			(float) failures * 100 / attempts);

	return 0;
}
