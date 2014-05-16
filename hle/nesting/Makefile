CC=g++
SC=gcc
CCFLAGS=-std=c++0x -O0 # compiler flags
LDLAGS=-fgnu-tm -mrtm -pthread #-Wl,--no-as-needed # linker flags
SFLAGS=-S -masm=intel


# nesting
SOURCES_NESTING=nesting.cpp \
../../util.cpp ../../Stats.cpp
nesting: $(SOURCES_NESTING)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_NESTING) $(LDLAGS)

# nesting multiple
SOURCES_NESTING_MULTIPLE=multiple.cpp \
../../util.cpp ../../Stats.cpp
multiple: $(SOURCES_NESTING_MULTIPLE)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_NESTING_MULTIPLE) $(LDLAGS)

# nesting multiple reverseunlock
SOURCES_NESTING_MULTIPLE_REVERSE=multiple-reverseunlock.cpp \
../../util.cpp ../../Stats.cpp
multiple-reverseunlock: $(SOURCES_NESTING_MULTIPLE_REVERSE)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_NESTING_MULTIPLE_REVERSE) $(LDLAGS)

# nesting method
SOURCES_NESTING_METHOD=nesting-method.cpp \
../../util.cpp ../../Stats.cpp
nesting-method: $(SOURCES_NESTING_METHOD)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_NESTING_METHOD) $(LDLAGS)
