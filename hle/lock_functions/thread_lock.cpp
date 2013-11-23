#include "thread_lock.h"

void thread_lock(std::mutex *lock) {
	lock->lock();
}
void thread_unlock(std::mutex *lock) {
	lock->unlock();
}
