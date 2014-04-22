#include <stdio.h>
#include <stdlib.h>

#include <immintrin.h> // rtm
#include "../Stats.h"

class Base {
public:
	virtual int func() {
		return 1;
	}
};

class Derived: public Base {
public:
	/** @return 0 if ok, 1 if fail */
	int func() {
		retry: if (_xbegin() == _XBEGIN_STARTED) {
			int result = Base::func();
			_xend();
			return 0;
		} else {
			return 1;
		}
	}
};

int main(int argc, char *argv[]) {
	int loops = argc > 1 ? argv[1] : 100;

	Stats stats;
	for (int i = 0; i < loops; ++i) {
		Base * obj = new Derived();
		int fail = obj->func();
		delete obj;
		stats.addValue(fail);
	}
	printf("%.2f\n", stats.getExpectedValue());
}

//int func_inner() {
//	return 1;
//}
// // leads to 0 aborts
///** @return 0 if ok, 1 if fail */
//int rtm_func_outer() {
//	retry: if (_xbegin() == _XBEGIN_STARTED) {
//		int result = func_inner();
//		_xend();
//		printf("inner res: %d\n", result);
//		return 0;
//	} else {
//		return 1;
//	}
//}
