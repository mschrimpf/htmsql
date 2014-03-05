#ifndef ATOMIC_TAS_LOCK_SPEC_H_
#define ATOMIC_TAS_LOCK_SPEC_H_

#include "def.h"
void atomic_tas_lock_spec(type *lock);
void atomic_tas_unlock_spec(type *lock);

#endif /* ATOMIC_TAS_LOCK_SPEC_H_ */
