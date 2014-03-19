# benchmarker
benchmarker: benchmarker.cpp
	g++ -o benchmarker -fgnu-tm -mrtm -O2 benchmarker.cpp -lpthread

benchmarker.s: benchmarker
	gcc -S -masm=intel -fgnu-tm -mrtm -O2 benchmarker -lpthread
