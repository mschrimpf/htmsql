# No includes
array_size_sequential: array_size_sequential.cpp
	g++ -o array_size_sequential -fgnu-tm -mrtm -O2 array_size_sequential.cpp -lpthread

array_size_sequential.s: array_size_sequential.cpp
	gcc -S -masm=intel -fgnu-tm -mrtm -O2 array_size_sequential.cpp -lpthread

# Include sstm and fstm
array_size_sequential_include: array_size_sequential_include.cpp
	g++ -o array_size_sequential_include -fgnu-tm -mrtm -O2 array_size_sequential_include.cpp -lpthread

array_size_sequential_include.s: array_size_sequential_include.cpp
	gcc -S -masm=intel -fgnu-tm -mrtm -O2 array_size_sequential_include.cpp -lpthread
	