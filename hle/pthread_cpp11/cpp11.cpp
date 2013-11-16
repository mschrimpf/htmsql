#include <thread>

static std::mutex mutex;
void method() {
	mutex.lock(); // enter critical section
	// do something
	mutex.unlock(); // exit critical section
}

int main() {
	std::thread t(method); // create a thread t that executes method
	t.join(); // wait for thread

	return 0;
}
