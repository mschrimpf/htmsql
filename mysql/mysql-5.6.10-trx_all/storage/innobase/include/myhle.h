#ifndef _MYHLE_H
#define _MYHLE_H 1

#include "hle-emulation.h"
#include <xmmintrin.h> // _mm_pause

void hle_lock(volatile unsigned *lock);
void hle_unlock(volatile unsigned *lock);

#endif /* _MYHLE_H */
