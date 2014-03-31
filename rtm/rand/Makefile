CC=g++
SC=gcc
CCFLAGS=-std=c++0x -O2
LDLAGS=-fgnu-tm -mrtm -lpthread -Wl,--no-as-needed # linker flags

# 
SOURCES_RAND=rand.cpp ../../util.cpp
rand: $(SOURCES_RAND)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_RAND) $(LDLAGS)

# 
SOURCES_RAND_ARRAY_COMBINED=rand_array_combined.cpp ../../util.cpp
rand_array_combined: $(SOURCES_RAND_ARRAY_COMBINED)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_RAND_ARRAY_COMBINED) $(LDLAGS)