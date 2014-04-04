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

# self abort
SOURCES_SELF_ABORT=self-abort.cpp \
../../util.cpp
self-abort: $(SOURCES_SELF_ABORT)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_SELF_ABORT) $(LDLAGS)

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

# nesting
SOURCES_NESTING=nesting.cpp \
../../util.cpp ../../Stats.cpp
nesting: $(SOURCES_NESTING)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_NESTING) $(LDLAGS)

# nesting multiple
SOURCES_NESTING_MULTIPLE=nesting-multiple.cpp \
../../util.cpp ../../Stats.cpp
nesting-multiple: $(SOURCES_NESTING_MULTIPLE)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_NESTING_MULTIPLE) $(LDLAGS)
