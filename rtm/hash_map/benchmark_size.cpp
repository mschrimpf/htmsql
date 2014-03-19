/*
 * benchmark_maxins.cpp
 *
 *  Created on: 26.10.2013
 *      Author: Martin
 */
#include <stdlib.h>
#include <stdio.h>
#include <vector>

#include "HashMap.h"
#include "LockException.h"
#include "util.h"

double average(std::vector<int> v);

int main(int argc, char *argv[]) {
	// handle args
	int size = 10, loops = 1000, variety = -1, print = 0;
	int *values[] = { &size, &loops, &variety, &print };
	const char* identifier[] = { "-s", "-l", "-v", "-p" };
	handle_args(argc, argv, 4, values, identifier);

	if (variety < 0) {
		variety = size;
	} else if (variety > size) {
		fprintf(stderr, "The variety cannot be greater than the size!\n");
		return 1;
	}

	printf("size:    %d\n", size);
	printf("loops:   %d\n", loops);
	printf("variety: %d\n", variety);

	// run benchmark
	std::vector<int> sizes;

	int ten_percent = loops / 10, last_loop = 0;
	for (int l = 0; l < loops; l++) {
		// status print
		if (l > last_loop + ten_percent) {
			printf("=");
			std::cout.flush();
			last_loop = l;
		}

		// initialize
		HashMap map(size);

		int insert_val = 0;
		int insert_val_increment = variety == 0 ? size : size / variety;
		for (int i = 0;; i++) {
			insert_val += insert_val_increment;
			try {
				map.insert(insert_val);
			} catch (const LockException& e) {
				sizes.push_back(i);
				break;
			}
		}

		if (print) {
			map.print();
		}
	}

	// print results
	printf("\n");
	double avg_size = average(sizes);
	printf("Average failure after %.2f inserts\n", avg_size);

	return 0;
}

double average(std::vector<int> v) {
	double sum = 0;
	for (std::vector<int>::iterator it = v.begin(); it != v.end(); it++) {
		sum += *it;
	}
	return sum / v.size();
}
