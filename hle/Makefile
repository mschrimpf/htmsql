# how_to_implement
how_to_implement: how_to_implement.cpp
	g++ -o how_to_implement -fgnu-tm -mrtm -O2 how_to_implement.cpp -lpthread

how_to_implement.s: how_to_implement
	gcc -S -masm=intel -fgnu-tm -mrtm -O2 how_to_implement -lpthread
	
# correct_test
correct_test: correct_test.cpp ../util.cpp
	g++ -std=c++0x -o correct_test -fgnu-tm -mrtm -O2 correct_test.cpp ../util.cpp -lpthread -Wl,--no-as-needed

correct_test.s: correct_test.cpp ../util.cpp
	gcc -std=c++0x -S -masm=intel -fgnu-tm -mrtm -O2 correct_test ../util.cpp -lpthread
