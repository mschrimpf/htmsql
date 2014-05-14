# testing
test_HashMap: HashMap.cpp test_HashMap.cpp
	g++ -o test_HashMap -fgnu-tm -mrtm -O2 HashMap.cpp test_HashMap.cpp -lpthread

test_HashMap.s: HashMap.cpp test_HashMap.cpp
	gcc -S -masm=intel -fgnu-tm -mrtm -O2 HashMap.cpp test_HashMap.cpp -lpthread

# benchmarking - failures
benchmark_failures: HashMap.cpp benchmark_failures.cpp util.cpp
	g++ -o benchmark_failures -fgnu-tm -mrtm -O2 HashMap.cpp benchmark_failures.cpp util.cpp -lpthread

benchmark_failures.s: HashMap.cpp benchmark_failures.cpp
	gcc -S -masm=intel -fgnu-tm -mrtm -O2 HashMap.cpp benchmark_failures.cpp util.cpp -lpthread

# benchmarking - max size
benchmark_size: HashMap.cpp benchmark_size.cpp util.cpp
	g++ -o benchmark_size -fgnu-tm -mrtm -O2 HashMap.cpp benchmark_size.cpp util.cpp -lpthread

benchmark_size.s: HashMap.cpp benchmark_size.cpp
	gcc -S -masm=intel -fgnu-tm -mrtm -O2 HashMap.cpp benchmark_size.cpp util.cpp -lpthread
	