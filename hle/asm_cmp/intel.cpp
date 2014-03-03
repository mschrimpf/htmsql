#include "def.h"
#include "../lock_functions/hle_asm_exch_lock.h"

int main() {
	type lock = 0;
	hle_asm_exch_lock(&lock);
}
