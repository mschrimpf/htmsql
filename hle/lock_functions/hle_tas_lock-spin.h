#ifndef HLE_TAS_LOCK_SPIN_H_
#define HLE_TAS_LOCK_SPIN_H_

#include "def.h"
void hle_tas_lock_spin(type *lock);
void hle_tas_unlock_spin(type *lock);

#endif /* HLE_TAS_LOCK_SPIN_H_ */
