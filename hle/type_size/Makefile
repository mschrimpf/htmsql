CC=g++
SC=gcc
CCFLAGS=-std=c++0x -O2
LDLAGS=-fgnu-tm -mrtm -lpthread -Wl,--no-as-needed # linker flags
SFLAGS=-S -masm=intel
SOURCES=type_size.cpp \
hle-lock_functions.cpp \
atomic-lock_functions.cpp \
../../util.cpp
EXECUTABLE=type_size
EXECUTABLE_ATOMIC=type_size-atomic

# time_cmp
$(EXECUTABLE): $(SOURCES)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES) $(LDLAGS)
