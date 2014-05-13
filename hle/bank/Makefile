include ../lock_functions/Makefile.variables

CC=g++
SC=gcc
CCFLAGS=-std=c++0x -O2
LDLAGS=-fgnu-tm -mrtm -pthread -Wl,--no-as-needed
SFLAGS=-S -masm=intel
SOURCES=time_cmp.cpp \
entities/Account.cpp entities/ThreadsafeAccount.cpp \
$(SOURCES_LOCK) \
../../util.cpp \
../../Stats.cpp

OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=time_cmp

# time_cmp
$(EXECUTABLE): $(SOURCES)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES) $(LDLAGS)
.cpp.s:
	$(SC) $(SFLAGS) $(CCFLAGS) $< -o $@ $(LDLAGS)

#all: $(EXECUTABLE)

