#ifndef RTM_LOCK_H_
#define RTM_LOCK_H_

#include "def.h"

void rtm_lock(type* mutex);
void rtm_unlock(type* mutex);

void rtm_lock_smart(type* mutex);
void rtm_unlock_smart(type* mutex);

#endif /* RTM_LOCK_H_ */
