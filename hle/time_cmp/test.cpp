#include <stdio.h>
#include <thread>
#include "banking_account/ThreadsafeAccount.h"

#include "LockType.h"

void run(ThreadsafeAccount a[], int size) {
	printf("Inside run function\n");
}

int main() {
//	LockType *locker = new LockType(LockType::EnumType::PTHREAD);
//
//	(locker->*(locker->lock))();
//	printf("Yay I'm synchronized\n");
//	(locker->*(locker->unlock))();
//
//	delete locker;

	const int size = 0;
	ThreadsafeAccount account_pool[size];
	std::thread t(run, account_pool, size);
	t.join();

	return 0;
}
