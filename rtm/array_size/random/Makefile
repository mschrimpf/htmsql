UTIL=../../../util.cpp

# Random
array_size_random: array_size_random.cpp $(UTIL)
	g++ -o array_size_random -fgnu-tm -mrtm -O2 array_size_random.cpp $(UTIL) -lpthread

array_size_random.s: array_size_random.cpp $(UTIL)
	gcc -S -masm=intel -fgnu-tm -mrtm -O2 array_size_random.cpp $(UTIL) -lpthread

# Random Suite
array_size_random_measure_suite: array_size_random_measure_suite.cpp $(UTIL)
	g++ -o array_size_random_measure_suite -fgnu-tm -mrtm -O2 array_size_random_measure_suite.cpp $(UTIL) -lpthread

array_size_random_measure_suite.s: array_size_random_measure_suite.cpp $(UTIL)
	gcc -S -masm=intel -fgnu-tm -mrtm -O2 array_size_random_measure_suite.cpp $(UTIL) -lpthread

# Random Suite Print
array_size_random_measure_print: array_size_random_measure_print.cpp $(UTIL)
	g++ -o array_size_random_measure_print -fgnu-tm -mrtm -O2 array_size_random_measure_print.cpp $(UTIL) -lpthread

array_size_random_measure_print.s: array_size_random_measure_print.cpp $(UTIL)
	gcc -S -masm=intel -fgnu-tm -mrtm -O2 array_size_random_measure_print.cpp $(UTIL) -lpthread
