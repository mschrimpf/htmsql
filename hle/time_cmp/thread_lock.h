#ifndef THREAD_LOCK_H_
#define THREAD_LOCK_H_

#include <mutex>
void thread_lock(std::mutex *lock);
void thread_unlock(std::mutex *lock);

#endif /* THREAD_LOCK_H_ */
