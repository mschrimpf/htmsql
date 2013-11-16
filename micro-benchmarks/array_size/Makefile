# Test
test: test.cpp ../util.cpp
	g++ -o test -fgnu-tm -mrtm -O2 test.cpp ../util.cpp -lpthread

test.s: test.cpp ../util.cpp
	gcc -S -masm=intel -fgnu-tm -mrtm -O2 test.cpp ../util.cpp -lpthread
