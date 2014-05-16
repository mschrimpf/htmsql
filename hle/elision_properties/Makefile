CC=g++
SC=gcc
CCFLAGS=-std=c++0x -O0 # compiler flags
LDLAGS=-fgnu-tm -mrtm -pthread #-Wl,--no-as-needed # linker flags
SFLAGS=-S -masm=intel

# locked
SOURCES_LOCKED=locked_elision.cpp \
../../util.cpp
EXECUTABLE_LOCKED=locked_elision

$(EXECUTABLE_LOCKED): $(SOURCES_LOCKED)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_LOCKED) $(LDLAGS)

# retried
SOURCES_RETRIED=retried_elision.cpp \
../../util.cpp
EXECUTABLE_RETRIED=retried_elision

$(EXECUTABLE_RETRIED): $(SOURCES_RETRIED)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_RETRIED) $(LDLAGS)

# mutual abort
SOURCES_ABORT=mutual_abort.cpp \
../../util.cpp
mutual_abort: $(SOURCES_ABORT)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_ABORT) $(LDLAGS)

# hle
SOURCES_READ_ELISION=read-second_elision.cpp \
../../util.cpp
EXECUTABLE_READ_ELISION=read-second_elision

$(EXECUTABLE_READ_ELISION): $(SOURCES_READ_ELISION)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_READ_ELISION) $(LDLAGS)

# 
SOURCES_UNFRIENDLY_INSTRUCTIONS=unfriendly_instructions.cpp \
../../util.cpp ../../Stats.cpp
unfriendly_instructions: $(SOURCES_UNFRIENDLY_INSTRUCTIONS)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_UNFRIENDLY_INSTRUCTIONS) $(LDLAGS)

# 
SOURCES_DATA_CONFLICT=data_conflict.cpp \
../../util.cpp ../../Stats.cpp
data_conflict: $(SOURCES_DATA_CONFLICT)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_DATA_CONFLICT) $(LDLAGS)
