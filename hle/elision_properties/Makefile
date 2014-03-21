CC=g++
SC=gcc
CCFLAGS=-std=c++0x -O2 # compiler flags
LDLAGS=-fgnu-tm -mrtm -pthread -Wl,--no-as-needed # linker flags
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
	