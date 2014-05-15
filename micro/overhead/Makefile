CC=g++
SC=gcc
CCFLAGS=-std=c++0x -O0 # compiler flags
LDLAGS=-fgnu-tm -mrtm -pthread #-Wl,--no-as-needed # linker flags
SFLAGS=-S -masm=intel


SOURCES_OVERHEAD=overhead.cpp \
../../util.cpp ../../Stats.cpp \
../../hle/lock_functions/atomic_exch_lock-spec.cpp ../../hle/lock_functions/hle_exch_lock-spec.cpp
overhead: $(SOURCES_OVERHEAD)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_OVERHEAD) $(LDLAGS)
