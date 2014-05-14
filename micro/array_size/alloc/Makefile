CC=g++
LDFLAGS=-fgnu-tm -mrtm -lpthread

# Suite
SOURCES_SUITE = suite.cpp ../../../util.cpp
suite: $(SOURCES_SUITE)
	$(CC) -o $@ $(LDFLAGS) -O0 $(SOURCES_SUITE)