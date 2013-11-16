#ifndef ATOMIC_TAS_HLE_LOCK_H_
#define ATOMIC_TAS_HLE_LOCK_H_

#include "def.h"
void atomic_tas_hle_lock(type *lock);
void atomic_tas_hle_unlock(type *lock);

#endif /* ATOMIC_TAS_HLE_LOCK_H_ */
