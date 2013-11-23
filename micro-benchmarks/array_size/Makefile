CC=g++
LDFLAGS=-fgnu-tm -mrtm -lpthread

# Test
test: test.cpp ../util.cpp
	g++ -o test -fgnu-tm -mrtm -O2 test.cpp ../util.cpp -lpthread

test.s: test.cpp ../util.cpp
	gcc -S -masm=intel -fgnu-tm -mrtm -O2 test.cpp ../util.cpp -lpthread

# Suite
SOURCES_SUITE = suite.cpp ../../util.cpp
suite: $(SOURCES_SUITE)
	$(CC) -o $@ $(LDFLAGS) -O0 $(SOURCES_SUITE)