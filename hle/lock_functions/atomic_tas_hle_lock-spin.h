#ifndef ATOMIC_TAS_HLE_LOCK_SPIN_H_
#define ATOMIC_TAS_HLE_LOCK_SPIN_H_

#include "def.h"
void atomic_tas_hle_lock_spin(type *lock);
void atomic_tas_hle_unlock_spin(type *lock);

#endif /* ATOMIC_TAS_HLE_LOCK_SPIN_H_ */
