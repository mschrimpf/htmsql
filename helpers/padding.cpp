#include <stdio.h>
#include <stdlib.h>

#define PADDING 1

#include "../hle/lock_functions/LockType.h"
#include "../hle/shared_counter/ThreadsafeCounter.h"
#include "../hle/bank/entities/Account.h"
#include "../hle/bank/entities/ThreadsafeAccount.h"

int main(int argc, char * argv[]) {
	printf("L1 DCache size:         %d KByte\n", 32);
	printf("L1 Cache line size:     %d Byte\n", 64);
	printf("\n");

//	printf("LockType Size:          %lu Byte\n", sizeof(LockType));
//	printf("ThreadsafeCounter Size: %lu Byte\n", sizeof(ThreadsafeCounter));
//	printf("int Size:               %lu Byte\n", sizeof(int));
	printf("double Size:            %lu Byte\n", sizeof(double));
	printf("Account Size:           %lu Byte\n", sizeof(Account));
	Account a[1000];
	printf("Account[1000] Size:     %lu Byte\n", sizeof(a));
	printf("ThreadsafeAccount Size: %lu Byte\n", sizeof(ThreadsafeAccount));
}
