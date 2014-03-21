CC=g++
SC=gcc
CCFLAGS=-std=c++0x -O2
LDLAGS=-fgnu-tm -mrtm -lpthread -Wl,--no-as-needed # linker flags
SOURCES_RAND=rand.cpp ../../util.cpp

# rand
rand: $(SOURCES_RAND)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_RAND) $(LDLAGS)
