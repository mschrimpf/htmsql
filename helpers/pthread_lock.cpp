#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include <immintrin.h>

int main(int argc, char *argv[]) {
	int i = 0;
	pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
	pthread_mutex_lock(&mutex);
	i += 5;
	pthread_mutex_unlock(&mutex);
	printf("i: %d\n", i);
}
