# P1 (lightweight)
p1: p1.cpp
	g++ -o p1 -fgnu-tm -mrtm -O2 p1.cpp -lpthread

p1.s: p1.cpp
	gcc -S -masm=intel -fgnu-tm -mrtm -O2 p1.cpp -lpthread
	
# P2
p2: p2.cpp util.cpp
	g++ -o p2 -fgnu-tm -mrtm -O2 p2.cpp util.cpp -lpthread

p2.s: p2.cpp util.cpp
	gcc -S -masm=intel -fgnu-tm -mrtm -O2 p2.cpp util.cpp -lpthread

# P2-1
p2-1: p2-1.cpp util.cpp
	g++ -o p2-1 -fgnu-tm -mrtm -O2 p2-1.cpp util.cpp -lpthread

p2-1.s: p2-1.cpp util.cpp
	gcc -S -masm=intel -fgnu-tm -mrtm -O2 p2-1.cpp util.cpp -lpthread

# P2-2
p2-2: p2-2.cpp util.cpp
	g++ -o p2-2 -fgnu-tm -mrtm -O2 p2-2.cpp util.cpp -lpthread

p2-2.s: p2-2.cpp util.cpp
	gcc -S -masm=intel -fgnu-tm -mrtm -O2 p2-2.cpp util.cpp -lpthread
