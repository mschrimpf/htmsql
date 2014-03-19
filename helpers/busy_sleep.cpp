#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <sys/time.h> // timeval
//

void busy_sleep() {
	for (int i = 0; i < 255; i++)
		for (int j = 0; j < 255; j++)
			;
}

int main(int argc, char *argv[]) {
	struct timeval start, end;
	gettimeofday(&start, NULL);

	busy_sleep();

	gettimeofday(&end, NULL);
	double elapsed = ((end.tv_sec - start.tv_sec) * 1000)
			+ (end.tv_usec / 1000 - start.tv_usec / 1000);
	printf("%2.2d\n", elapsed);
}
