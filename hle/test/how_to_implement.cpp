#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

#include "lib/tsx-cpuid.h"
#include "lib/hle-emulation.h"

#define type unsigned

//#define TEST_OP_FETCH(type, sz)						\
//	{								\
//		static type lock;					\
//		type res;						\
//		res = __hle_acquire_add_fetch##sz(&lock, 1);		\
//		assert(res == 1);				\
//		assert(lock == 1);				\
//		res = __hle_release_sub_fetch##sz(&lock, 1);	\
//		assert(res == 0);			\
//		assert(lock == 0);			\
//	}
//
// ## in macro definition concatenates both side of the operator

void compare_my_cmp_exch(type lock, type expected, type desired);

void tas() {
	printf("TEST AND SET\n");
	static type lock;
	type res;
	res = __hle_acquire_test_and_set4(&lock);
	// res = 0, lock = 1
	printf("[ACQ] res=%d, lock=%d\n", res, lock);
	res = __hle_acquire_test_and_set4(&lock);
	// res = 1, lock = 1
	printf("[ACQ] res=%d, lock=%d\n", res, lock);
	__hle_release_clear4(&lock);
	// 			lock = 0
	printf("[REL CLR]    lock=%d\n", lock);
	res = __hle_acquire_test_and_set4(&lock);
	// res = 0, lock = 1
	printf("[ACQ] res=%d, lock=%d\n", res, lock);
	res = __hle_release_test_and_set4(&lock);
	// res = 1, lock = 1
	printf("[REL] res=%d, lock=%d\n", res, lock);
	// TODO what does this method do? it does not change the values
	res = __hle_release_test_and_set4(&lock);
	// res = 1, lock = 1
	printf("[REL] res=%d, lock=%d\n", res, lock);
}
void exchg() {
	printf("EXCHANGE\n");
	static type lock;
	type res;
	res = __hle_acquire_exchange_n4(&lock, 1);
	printf("[ACQ] res=%d, lock=%d\n", res, lock);
	res = __hle_acquire_exchange_n4(&lock, 1);
	printf("[ACQ] res=%d, lock=%d\n", res, lock);
	res = __hle_acquire_exchange_n4(&lock, 0);
	printf("[ACQ] res=%d, lock=%d\n", res, lock);
	res = __hle_acquire_exchange_n4(&lock, 2);
	printf("[ACQ] res=%d, lock=%d\n", res, lock);
	res = __hle_acquire_exchange_n4(&lock, 1);
	printf("[ACQ] res=%d, lock=%d\n", res, lock);
	__hle_release_clear4(&lock);
	printf("[REL CLR]    lock=%d\n", lock);
}
void cmp_exchg() {
	printf("COMPARE EXCHANGE\n");
	static type lock;
	type oldv, newv;
	type res;

	// test all combinations
	for (int i = 0; i < 8; i++) {
		lock = (i & (1 << 2)) >> 2;
		oldv = (i & (1 << 1)) >> 1;
		newv = i & 1;
		printf("%d & %d & %d", lock, oldv, newv);
		res = __hle_acquire_compare_exchange_n4(&lock, &oldv, newv);
		printf(" & %d & %d & %d & %d \\\\\n", lock, oldv, newv, res);

		compare_my_cmp_exch(lock, oldv, newv);
	}
}

type __my_acquire_compare_exchange_n4(type *lock, type *oldv, type newv) {
	type res = *lock == *oldv;
	if(res) *lock = newv;
	else *oldv = *lock;
	return res;
}

void compare_my_cmp_exch(type lock, type oldv, type newv) {
	type lock1 = lock, lock2 = lock;
	type oldv1 = oldv, oldv2 = oldv;
	type newv1 = newv, newv2 = newv;

	type res1 = __hle_acquire_compare_exchange_n4(&lock1, &oldv1, newv1);
	type res2 = __my_acquire_compare_exchange_n4(&lock2, &oldv2, newv2);
	if (res1 == res2 && lock1 == lock2 && oldv1 == oldv2 && newv1 == newv2) {
//		printf("Equal!\n");
	} else {
		printf(
				"NOT Equal (res %d - %d, lock %d - %d, oldv %d - %d, newv %d - %d)\n",
				res1, res2, lock1, lock2, oldv1, oldv2, newv1, newv2);
	}
}

int main(int argc, char *argv[]) {
	printf("RTM: %s  |  ", cpu_has_rtm() ? "Yes" : "No");
	printf("HLE: %s\n", cpu_has_hle() ? "Yes" : "No");

	/* HLE emulation */
//	int foo = 0;
//	__hle_acquire_or_fetch4(&foo, 1);
	/* HLE */
//	TEST_OP_FETCH(type, 4);
//	tas();
//	exchg();
	cmp_exchg();

	return 0;
}

//	static type lock;
//	type res;
//	res = __hle_acquire_add_fetch4(&lock, 1); // OP_FETCH (operation first, fetch afterwards)
//	printf("res=%d, lock=%d\n", res, lock);
//	// res == 1, lock == 1
//
//	res = __hle_acquire_fetch_add4(&lock, 1); // FETCH_OP
//	printf("res=%d, lock=%d\n", res, lock);
//	// res == 1, lock == 2
