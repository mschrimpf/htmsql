#ifndef ATOMIC_EXCH_HLE_LOCK_H_
#define ATOMIC_EXCH_HLE_LOCK_H_

#include "def.h"
void atomic_exch_hle_lock(type *lock);
void atomic_exch_hle_unlock(type *lock);

#endif /* ATOMIC_EXCH_HLE_LOCK_H_ */
