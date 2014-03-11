CC=g++
SC=gcc
CCFLAGS=-O2 # compiler flags
LDLAGS=-fgnu-tm -mrtm -lpthread -Wl,--no-as-needed # linker flags
SFLAGS=-S -masm=intel
SOURCES=type_size.cpp \
../../util.cpp
SOURCES_HLE=$(SOURCES) \
lock_functions.cpp
SOURCES_ATOMIC=$(SOURCES) \
lock_functions-atomic.cpp
EXECUTABLE=type_size
EXECUTABLE_ATOMIC=type_size-atomic

# time_cmp
$(EXECUTABLE): $(SOURCES_HLE)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_HLE) $(LDLAGS)
$(EXECUTABLE_ATOMIC): $(SOURCES_ATOMIC)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_ATOMIC) $(LDLAGS)
