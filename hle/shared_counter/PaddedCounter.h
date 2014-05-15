#ifndef PADDED_COUNTER_H_
#define PADDED_COUNTER_H_ 1

class PaddedCounter {
private:
	int counter[16]; // make counter the size of one cache line
public:
	PaddedCounter();
	virtual void increment();
	virtual int get();
};

#endif // PADDED_COUNTER_H_
