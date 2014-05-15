include ../hle/lock_functions/Makefile.variables

CC=g++
SC=gcc
CCFLAGS=-std=c++0x -O2
LDLAGS=-fgnu-tm -mrtm -pthread -Wl,--no-as-needed # linker flags
SFLAGS=-S -masm=intel


# nop_wait
SOURCES_BUSYWAIT=busy_sleep.cpp ../util.cpp
busy_wait: $(SOURCES_BUSYWAIT)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_BUSYWAIT) $(LDLAGS)

# padding
SOURCES_PADDING=padding.cpp ../util.cpp \
../hle/bank/entities/Account.cpp \
$(SOURCES_LOCK)
padding: $(SOURCES_PADDING)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_PADDING) $(LDLAGS)

# cache_sizes
SOURCES_CACHE_SIZES=cache_sizes.cpp ../util.cpp
cache_sizes: $(SOURCES_CACHE_SIZES)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_CACHE_SIZES) $(LDLAGS)

# cycles
SOURCES_COUNT_CYCLES=count-cycles.cpp ../util.cpp ../Stats.cpp
count-cycles: $(SOURCES_COUNT_CYCLES)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_COUNT_CYCLES) $(LDLAGS)

# cache miss cycles
SOURCES_CACHE_MISS_CYCLES=cache-miss-cycles.cpp ../util.cpp ../Stats.cpp
cache-miss-cycles: $(SOURCES_CACHE_MISS_CYCLES)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_CACHE_MISS_CYCLES) $(LDLAGS)

# glibc
SOURCES_PTHREAD_LOCK=pthread_lock.cpp ../util.cpp
pthread_lock: $(SOURCES_PTHREAD_LOCK)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_PTHREAD_LOCK) $(LDLAGS)
	
SOURCES_PTHREAD_LOCK_GLIBC=pthread_lock.o util.o
GLIBC=/home/htmsql/develop/glibc-elision
pthread_lock.o: pthread_lock.cpp
	$(CC) -c $(CCFLAGS) -o $@ pthread_lock.cpp $(LDLAGS)
util.o: ../util.cpp
	$(CC) -c $(CCFLAGS) -o $@ ../util.cpp $(LDLAGS)
pthread_lock_glibc: $(SOURCES_PTHREAD_LOCK_GLIBC)
	$(CC) \
			-Wl,--rpath=$(GLIBC)/build/lib:/usr/lib/x86_64-linux-gnu:/lib/x86_64-linux-gnu -Wl,--dynamic-linker=$(GLIBC)/build/lib/ld-linux-x86-64.so.2 \
			-o $@ $(SOURCES_PTHREAD_LOCK_GLIBC) $(LDLAGS) --enable-lock-elision=yes
			
			
clean:
	rm *.o
