#ifndef PTHREAD_LOCK_H_
#define PTHREAD_LOCK_H_

#include "def.h"
void pthread_lock(type *lock);
void pthread_unlock(type *lock);

#endif /* PTHREAD_LOCK_H_ */
