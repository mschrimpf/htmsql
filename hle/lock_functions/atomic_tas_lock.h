#ifndef ATOMIC_TAS_LOCK_H_
#define ATOMIC_TAS_LOCK_H_

#include "def.h"
void atomic_tas_lock(type *lock);
void atomic_tas_unlock(type *lock);

#endif /* ATOMIC_TAS_LOCK_H_ */
