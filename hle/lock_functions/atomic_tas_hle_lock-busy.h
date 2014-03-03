#ifndef ATOMIC_TAS_HLE_LOCK_BUSY_H_
#define ATOMIC_TAS_HLE_LOCK_BUSY_H_

#include "def.h"
void atomic_tas_hle_lock_busy(type *lock);
void atomic_tas_hle_unlock_busy(type *lock);

#endif /* ATOMIC_TAS_HLE_LOCK_BUSY_H_ */
