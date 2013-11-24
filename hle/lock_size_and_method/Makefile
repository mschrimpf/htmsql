CC=g++
SC=gcc
CCFLAGS=-O2 # compiler flags
LDLAGS=-fgnu-tm -mrtm -lpthread -Wl,--no-as-needed # linker flags
SFLAGS=-S -masm=intel
SOURCES=lock_size_and_method.cpp \
lock_functions.cpp \
../../util.cpp
# ../boost_mutex_lock.cpp # Problems with includes
OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=lock_size_and_method

# time_cmp
$(EXECUTABLE): $(SOURCES)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES) $(LDLAGS)
$(EXECUTABLE).s: $(SOURCES)
	$(SC) $(SFLAGS) $(CCFLAGS) $(SOURCES) -o $@ $(LDLAGS)