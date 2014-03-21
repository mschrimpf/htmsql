CCFLAGS=-fgnu-tm -mrtm -O2

# Average time
clocktime_avg: clocktime_avg.cpp
	g++ -o clocktime_avg $(CCFLAGS) clocktime_avg.cpp -lpthread

clocktime_avg.s: clocktime_avg.cpp
	gcc -S -masm=intel $(CCFLAGS) clocktime_avg.cpp -lpthread
	
# Nop
SOURCES_CLOCKTIME_NOP=clocktime_nop.cpp ../../util.cpp
clocktime_nop: $(SOURCES_CLOCKTIME_NOP)
	g++ -o $@ $(CCFLAGS) $(SOURCES_CLOCKTIME_NOP)

# Sleep
clocktime_sleep: clocktime_sleep.cpp
	g++ -o clocktime_sleep $(CCFLAGS) clocktime_sleep.cpp -lpthread

clocktime_sleep.s: clocktime_sleep.cpp
	gcc -S -masm=intel $(CCFLAGS) clocktime_sleep.cpp -lpthread