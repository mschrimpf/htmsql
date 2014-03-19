CC=g++
SC=gcc
CCFLAGS=-std=c++0x -O2
LDLAGS=-fgnu-tm -mrtm -lpthread -Wl,--no-as-needed # linker flags
SFLAGS=-S -masm=intel

# time_cmp
busy_sleep: busy_sleep.cpp
	$(CC) $(CCFLAGS) -o $@ busy_sleep.cpp $(LDLAGS)
