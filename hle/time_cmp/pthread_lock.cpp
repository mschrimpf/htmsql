#include "pthread.h"

//static pthread_mutex_t p_mutex = PTHREAD_MUTEX_INITIALIZER;
void pthread_lock(pthread_mutex_t *p_mutex) {
	pthread_mutex_lock(p_mutex);
}
void pthread_unlock(pthread_mutex_t *p_mutex) {
	pthread_mutex_unlock(p_mutex);
}
