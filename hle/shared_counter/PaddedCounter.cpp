#include "PaddedCounter.h"

PaddedCounter::PaddedCounter() {
	this->counter[0] = 0;
}

void PaddedCounter::increment() {
	this->counter[0]++;
}
int PaddedCounter::get() {
	return this->counter[0];
}
