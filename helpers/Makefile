CC=g++
SC=gcc
CCFLAGS=-std=c++0x -O2
LDLAGS=-fgnu-tm -mrtm -lpthread -Wl,--no-as-needed # linker flags
SFLAGS=-S -masm=intel


# nop_wait
SOURCES_BUSYWAIT=busy_sleep.cpp ../util.cpp
busy_wait: $(SOURCES_BUSYWAIT)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_BUSYWAIT) $(LDLAGS)

# padding
SOURCES_PADDING=padding.cpp ../util.cpp \
../hle/bank/entities/Account.cpp \
../hle/lock_functions/LockType.cpp \
../hle/lock_functions/pthread_lock.cpp ../hle/lock_functions/thread_lock.cpp \
../hle/lock_functions/atomic_exch_lock-busy.cpp ../hle/lock_functions/atomic_exch_lock-spec.cpp \
../hle/lock_functions/atomic_tas_lock-busy.cpp ../hle/lock_functions/atomic_tas_lock-spec.cpp \
../hle/lock_functions/atomic_exch_hle_lock-busy.cpp ../hle/lock_functions/atomic_exch_hle_lock-spec.cpp \
../hle/lock_functions/atomic_tas_hle_lock-busy.cpp ../hle/lock_functions/atomic_tas_hle_lock-spec.cpp \
../hle/lock_functions/hle_tas_lock-busy.cpp ../hle/lock_functions/hle_tas_lock-spec.cpp \
../hle/lock_functions/hle_exch_lock-busy.cpp ../hle/lock_functions/hle_exch_lock-spec.cpp \
../hle/lock_functions/hle_asm_exch_lock-busy.cpp ../hle/lock_functions/hle_asm_exch_lock-spec.cpp \
../hle/lock_functions/hle_asm_exch_lock-asm_spec.cpp
padding: $(SOURCES_PADDING)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_PADDING) $(LDLAGS)

# cache_sizes
SOURCES_CACHE_SIZES=cache_sizes.cpp ../util.cpp
cache_sizes: $(SOURCES_CACHE_SIZES)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_CACHE_SIZES) $(LDLAGS)

# glibc
SOURCES_PTHREAD_LOCK=pthread_lock.cpp ../util.cpp
pthread_lock: $(SOURCES_PTHREAD_LOCK)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_PTHREAD_LOCK) $(LDLAGS)
	
SOURCES_PTHREAD_LOCK_GLIBC=pthread_lock.o util.o
DEBUG_FLAGS=-Og -ggdb
pthread_lock.o: pthread_lock.cpp
	$(CC) $(DEBUG_FLAGS) -c $(CCFLAGS) -o $@ pthread_lock.cpp $(LDLAGS)
util.o: ../util.cpp
	$(CC) $(DEBUG_FLAGS) -c $(CCFLAGS) -o $@ ../util.cpp $(LDLAGS)
pthread_lock_glibc: $(SOURCES_PTHREAD_LOCK_GLIBC)
	$(CC) $(DEBUG_FLAGS) -Wl,--rpath=/home/htmsql/develop/glibc/build/lib:/usr/lib:/lib -Wl,--dynamic-linker=/home/htmsql/develop/glibc/build/lib/ld-linux-x86-64.so.2 \
			-o $@ $(SOURCES_PTHREAD_LOCK_GLIBC) $(LDLAGS)
pthread_lock_glibc_nolinker: $(SOURCES_PTHREAD_LOCK_GLIBC)
	$(CC) $(DEBUG_FLAGS) -Wl,--rpath=/home/htmsql/develop/glibc/build/lib \
			-o $@ $(SOURCES_PTHREAD_LOCK_GLIBC) $(LDLAGS)



clean:
	rm *.o
