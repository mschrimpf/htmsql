#include "Stats.h"
#include <cmath>

Stats::Stats() {
	this->expectedValueSum = 0.0;
	this->varianceSum = 0.0;
	this->count = 0;
}
Stats::~Stats() {
}

void Stats::addValue(float val) {
	this->expectedValueSum += val;
	this->varianceSum += val * val;
	this->count++;
}

double Stats::getExpectedValue() {
	return this->expectedValueSum / this->count; // mu = p * sum(x_i);
}
double Stats::getVariance() {
	double expectedValue = this->getExpectedValue();
	return 1.0 / this->count * this->varianceSum - expectedValue * expectedValue; // var = p * sum(x_i^2) - mu^2
}
double Stats::getStandardDeviation() {
	double variance = this->getVariance();
	return sqrt(variance);
}
double Stats::getStandardError() {
	double stddev = this->getStandardDeviation();
	return stddev / sqrt(this->count);
}

double subtractStddev(double sd1, double sd2) {
	return sqrt(sd1 * sd1 + sd2 * sd2);
}
