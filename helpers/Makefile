CC=g++
SC=gcc
CCFLAGS=-std=c++0x -O2
LDLAGS=-fgnu-tm -mrtm -lpthread -Wl,--no-as-needed # linker flags
SFLAGS=-S -masm=intel

SOURCES_BUSYSLEEP=busy_sleep.cpp ../util.cpp

# time_cmp
busy_sleep: $(SOURCES_BUSYSLEEP)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_BUSYSLEEP) $(LDLAGS)
