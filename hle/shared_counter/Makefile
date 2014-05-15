include ../lock_functions/Makefile.variables

CC=g++
SC=gcc
CCFLAGS=-std=c++0x -O2 # compiler flags
LDLAGS=-fgnu-tm -mrtm -lpthread -Wl,--no-as-needed # linker flags
SFLAGS=-S -masm=intel
SOURCES=time_cmp.cpp \
PaddedCounter.cpp ThreadsafeCounter.cpp RtmCounter.cpp \
$(SOURCES_LOCK) \
../../util.cpp \
../../Stats.cpp
OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=time_cmp

# time_cmp
$(EXECUTABLE): $(SOURCES)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES) $(LDLAGS)
$(EXECUTABLE).s: $(SOURCES)
	$(SC) $(SFLAGS) $(CCFLAGS) $(SOURCES) -o $@ $(LDLAGS)

#all: $(SOURCES) $(EXECUTABLE)

#.cpp.o:
#	$(CC) $(CFLAGS) $< -o $@

## time_cmp
#time_cmp: time_cmp.cpp hle_lock.cpp thread_lock.cpp pthread_lock.cpp atomic_lock.cpp ../../util.cpp
#	g++ -std=c++0x -o time_cmp -fgnu-tm -mrtm -O2 time_cmp.cpp thread_lock.cpp pthread_lock.cpp ../../util.cpp -lpthread -Wl,--no-as-needed
#
#time_cmp.s: time_cmp.cpp hle_lock.cpp thread_lock.cpp pthread_lock.cpp atomic_lock.cpp ../../util.cpp
#	gcc -std=c++0x -S -masm=intel -fgnu-tm -mrtm -O2 time_cmp.cpp hle_lock.cpp thread_lock.cpp pthread_lock.cpp atomic_lock.cpp ../../util.cpp -lpthread -Wl,--no-as-needed
