#ifndef HLE_ASM_EXCH_LOCK_SPIN_H_
#define HLE_ASM_EXCH_LOCK_SPIN_H_

#include "def.h"
void hle_asm_exch_lock_spin(type *lock);
void hle_asm_exch_unlock_spin(type *lock);

#endif /* HLE_ASM_EXCH_LOCK_SPIN_H_ */
