/*
 * util.cpp
 *
 *  Created on: 26.10.2013
 *      Author: Martin
 */

#include <string.h>
#include <stdlib.h>
#include <vector>

void handle_args(int argc, char *argv[], int value_len, int **values,
		const char* identifier[]) {
	for (int a = 1; a < argc; a++) {
		for (int i = 0; i < value_len; i++) {
			if (strcmp(argv[a], identifier[i]) == 0) {
				*values[i] = atoi(argv[++a]);
			}
		}
	}
}

double average(std::vector<double> values) {
	double sum = 0;
	for (std::vector<double>::iterator it = values.begin(); it != values.end();
			it++) {
		sum += *it;
	}
	return sum / values.size();
}

// print fptr
//printf("Function address: ");
//unsigned char *p = (unsigned char *) &this->type_lock_function;
//for (int i = 0; i < sizeof(this->type_lock_function); i++) {
//	printf("%02x ", p[i]);
//}
//printf("\n");
