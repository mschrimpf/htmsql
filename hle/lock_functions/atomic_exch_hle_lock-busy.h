#ifndef ATOMIC_EXCH_HLE_LOCK_BUSY_H_
#define ATOMIC_EXCH_HLE_LOCK_BUSY_H_

#include "def.h"
void atomic_exch_hle_lock_busy(type *lock);
void atomic_exch_hle_unlock_busy(type *lock);

#endif /* ATOMIC_EXCH_HLE_LOCK_BUSY_H_ */
