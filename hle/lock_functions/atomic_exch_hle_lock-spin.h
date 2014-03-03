#ifndef ATOMIC_EXCH_HLE_LOCK_SPIN_H_
#define ATOMIC_EXCH_HLE_LOCK_SPIN_H_

#include "def.h"
void atomic_exch_hle_lock_spin(type *lock);
void atomic_exch_hle_unlock_spin(type *lock);

#endif /* ATOMIC_EXCH_HLE_LOCK_SPIN_H_ */
