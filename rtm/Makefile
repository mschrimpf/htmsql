CC=g++
SC=gcc
CCFLAGS=-std=c++0x -O0 # compiler flags
LDLAGS=-fgnu-tm -mrtm -pthread #-Wl,--no-as-needed # linker flags
SFLAGS=-S -masm=intel


# benchmarker
benchmarker: benchmarker.cpp
	$(CC) $(CCFLAGS) -o $@ benchmarker.cpp $(LDLAGS)


# nesting
SOURCES_NESTING=nesting.cpp \
../util.cpp ../Stats.cpp
nesting: $(SOURCES_NESTING)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_NESTING) $(LDLAGS)