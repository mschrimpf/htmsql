#include <pthread.h>

static pthread_mutex_t p_mutex = PTHREAD_MUTEX_INITIALIZER;
void method() {
	pthread_mutex_lock(&p_mutex); // enter critical section
	// do something
	pthread_mutex_unlock(&p_mutex); // exit critical section
}

int main() {
	pthread_t t;

	int ret = pthread_create(&t1, NULL, method);
	pthread_join(t1, NULL); // wait for thread

	return 0;
}
