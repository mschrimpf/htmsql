CC=g++
LDFLAGS=-fgnu-tm -mrtm -lpthread

# Sequential
array_size_sequential: array_size_sequential.cpp
	g++ -o array_size_sequential -fgnu-tm -mrtm -O2 array_size_sequential.cpp -lpthread

array_size_sequential.s: array_size_sequential.cpp
	gcc -S -masm=intel -fgnu-tm -mrtm -O2 array_size_sequential.cpp -lpthread

# Suite
SOURCES_SUITE = suite.cpp ../../../util.cpp
suite: $(SOURCES_SUITE)
	$(CC) -o $@ $(LDFLAGS) -O0 $(SOURCES_SUITE)