#include "boost_mutex_lock.h"

void boost_mutex_lock(boost::mutex *lock) {
	lock->lock();
}
void boost_mutex_unlock(boost::mutex *lock) {
	lock->unlock();
}
