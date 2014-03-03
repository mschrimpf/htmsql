#ifndef _MY_HLE_H
#define _MY_HLE_H 1

/**
 This file is a simplification of the "hle-emulation" header provided by Intel.
 It contains only two methods, hle_lock and hle_unlock.
 There is no need to know more about these two methods.
 */

void hle_lock(type *lock);
void hle_unlock(type *lock);

#endif // _MY_HLE_H
