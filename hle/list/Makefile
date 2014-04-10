include ../lock_functions/Makefile.variables

CC=g++
SC=gcc
CCFLAGS=-std=c++0x -O2 # compiler flags
LDLAGS=-fgnu-tm -mrtm -pthread -Wl,--no-as-needed # linker flags
SFLAGS=-S -masm=intel
SOURCES=time_cmp.cpp \
List.cpp \
ThreadsafeList.cpp \
ThreadsafeListRtm.cpp \
$(SOURCES_LOCK) \
../../util.cpp \
../../Stats.cpp

# time_cmp
time_cmp: $(SOURCES)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES) $(LDLAGS)
