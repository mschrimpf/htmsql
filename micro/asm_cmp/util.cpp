/*
 * util.cpp
 *
 *  Created on: 26.10.2013
 *      Author: Martin
 */

#include <string.h>
#include <stdlib.h>

void handle_args(int argc, char *argv[], int value_len, int **values, const char* identifier[]) {
	for (int a = 1; a < argc; a++) {
		for(int i=0; i<value_len; i++) {
			if(strcmp(argv[a], identifier[i]) == 0) {
				*values[i] = atoi(argv[++a]);
			}
		}
	}
}
