#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <sys/time.h> // timeval
#include "../util.h"
//

int dummy = 0;
void busy_wait_nop() { // X
	int loops = 1000;
	for (int i = 0; i < loops; i++)
		for (int j = 0; j < loops; j++)
			dummy++;
}

void wait_nop_nop(int microseconds) { // <--
	for (int i = 0; i < microseconds * 800; ++i) {
		asm volatile("nop");
	}
}

int main(int argc, char *argv[]) {
	int duration = 1;
	int *values[] = { &duration };
	const char *identifier[] = { "-d" };
	handle_args(argc, argv, 1, values, identifier);

	//
	struct timeval start, end;
	gettimeofday(&start, NULL);

	wait_nop_nop(duration);

	gettimeofday(&end, NULL);
	long elapsed = (end.tv_sec - start.tv_sec) * 1000000 + end.tv_usec
			- start.tv_usec;
	printf("%ld microseconds elapsed\n", elapsed);
	printf("dummy: %d\n", dummy);
}
