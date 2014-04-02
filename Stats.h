#ifndef STATS_H_
#define STATS_H_

#include <vector>

class Stats {
private:
	int count;
	double expectedValueSum;
	double varianceSum;
public:
	Stats();
	~Stats();

	void addValue(float val);

	double getExpectedValue();
	double getVariance();
	double getStandardDeviation();
	double getStandardError();
};

#endif // STATS_H_
