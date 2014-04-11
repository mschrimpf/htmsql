CC=g++
SC=gcc
CCFLAGS=-std=c++0x -O0 # compiler flags
LDLAGS=-fgnu-tm -mrtm -pthread #-Wl,--no-as-needed # linker flags
SFLAGS=-S -masm=intel


benchmarker: benchmarker.cpp
	$(CC) $(CCFLAGS) -o $@ benchmarker.cpp $(LDLAGS)


SOURCES_NESTING=nesting.cpp \
../util.cpp ../Stats.cpp
nesting: $(SOURCES_NESTING)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_NESTING) $(LDLAGS)

SOURCES_METHOD_NESTING=method-nesting.cpp \
../util.cpp ../Stats.cpp
method-nesting: $(SOURCES_METHOD_NESTING)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_METHOD_NESTING) $(LDLAGS)

SOURCES_MEMORY=memory.cpp \
../util.cpp ../Stats.cpp
memory: $(SOURCES_MEMORY)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_MEMORY) $(LDLAGS)