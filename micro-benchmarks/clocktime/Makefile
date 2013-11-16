# Average time
clocktime_avg: clocktime_avg.cpp
	g++ -o clocktime_avg -fgnu-tm -mrtm -O2 clocktime_avg.cpp -lpthread

clocktime_avg.s: clocktime_avg.cpp
	gcc -S -masm=intel -fgnu-tm -mrtm -O2 clocktime_avg.cpp -lpthread

# Faiure Rate
clocktime_rate: clocktime_rate.cpp
	g++ -o clocktime_rate -fgnu-tm -mrtm -O2 clocktime_rate.cpp -lpthread

clocktime_rate.s: clocktime_rate.cpp
	gcc -S -masm=intel -fgnu-tm -mrtm -O2 clocktime_rate.cpp -lpthread

# Faiure Rate Busy
clocktime_rate_busy: clocktime_rate_busy.cpp util.cpp
	g++ -o clocktime_rate_busy -fgnu-tm -mrtm clocktime_rate_busy.cpp util.cpp -lpthread # without -O2 

clocktime_rate_busy.s: clocktime_rate_busy.cpp util.cpp
	gcc -S -masm=intel -fgnu-tm -mrtm clocktime_rate_busy.cpp util.cpp -lpthread # without -O2 

# Faiure Rate Busy with time measurement
clocktime_rate_busy_ms: clocktime_rate_busy_ms.cpp util.cpp
	g++ -o clocktime_rate_busy_ms -fgnu-tm -mrtm clocktime_rate_busy_ms.cpp util.cpp -lpthread # without -O2 

clocktime_rate_busy_ms.s: clocktime_rate_busy_ms.cpp util.cpp
	gcc -S -masm=intel -fgnu-tm -mrtm clocktime_rate_busy_ms.cpp util.cpp -lpthread # without -O2 

# Sleep
clocktime_sleep: clocktime_sleep.cpp
	g++ -o clocktime_sleep -fgnu-tm -mrtm -O2 clocktime_sleep.cpp -lpthread

clocktime_sleep.s: clocktime_sleep.cpp
	gcc -S -masm=intel -fgnu-tm -mrtm -O2 clocktime_sleep.cpp -lpthread