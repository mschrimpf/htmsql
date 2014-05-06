include ../lock_functions/Makefile.variables

CC=g++
SC=gcc
CCFLAGS=-std=c++0x -O2 # compiler flags
LDLAGS=-fgnu-tm -mrtm -pthread -Wl,--no-as-needed # linker flags
SFLAGS=-S -masm=intel
SOURCES_ALL=TimeCmp.cpp \
List.cpp \
PreAllocatedList.cpp \
ThreadsafeList.cpp \
ThreadsafePreAllocatedList.cpp \
ListRtm.cpp \
PreAllocatedListRtm.cpp \
$(SOURCES_LOCK) \
../../util.cpp \
../../Stats.cpp


SOURCES_PROB=probabilities.cpp \
$(SOURCES_ALL)
prob_cmp: $(SOURCES_PROB)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_PROB) $(LDLAGS)

SOURCES_REP=repeats.cpp \
$(SOURCES_ALL)
repeats_cmp: $(SOURCES_REP)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_REP) $(LDLAGS)

