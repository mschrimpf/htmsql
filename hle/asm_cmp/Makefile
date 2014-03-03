# $< first dependency
# $@ targetname

CC=g++
SC=gcc
CCFLAGS=-std=c++0x -O2 # compiler flags
LDLAGS=-fgnu-tm -mrtm # linker flags
SFLAGS=-S -masm=intel
VPATH=../lock_functions # add to search path
SOURCES=hle_asm_exch_lock-intel_store.cpp hle_asm_exch_lock2.cpp
BUILD_DIR=.
OBJECTS=$(SOURCES:%.cpp=$(BUILD_DIR)/%.o)

all: $(OBJECTS)

.cpp.o:
	$(SC) $(SFLAGS) $(CCFLAGS) $< -o $@

clean:
	@echo scc is $(SC) sflags are $(SFLAGS)
	rm -f $(OBJECTS)