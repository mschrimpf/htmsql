#include "def.h"
#include "../lock_functions/hle_asm_exch_lock2.h"

int main() {
	type lock = 0;
	hle_asm_exch_lock2(&lock);
}
