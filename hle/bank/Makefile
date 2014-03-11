CC=g++
SC=gcc
CCFLAGS=-std=c++0x -O2
LDLAGS=-fgnu-tm -mrtm -pthread -Wl,--no-as-needed
SFLAGS=-S -masm=intel
SOURCES=time_cmp.cpp \
entities/Account.cpp entities/ThreadsafeAccount.cpp \
../lock_functions/pthread_lock.cpp ../lock_functions/thread_lock.cpp \
../lock_functions/atomic_exch_lock-busy.cpp ../lock_functions/atomic_exch_lock-spec.cpp \
../lock_functions/atomic_tas_lock-busy.cpp ../lock_functions/atomic_tas_lock-spec.cpp \
../lock_functions/atomic_exch_hle_lock-busy.cpp ../lock_functions/atomic_exch_hle_lock-spec.cpp \
../lock_functions/atomic_tas_hle_lock-busy.cpp ../lock_functions/atomic_tas_hle_lock-spec.cpp \
../lock_functions/hle_tas_lock-busy.cpp ../lock_functions/hle_tas_lock-spec.cpp \
../lock_functions/hle_exch_lock-busy.cpp ../lock_functions/hle_exch_lock-spec.cpp \
../lock_functions/hle_asm_exch_lock-busy.cpp ../lock_functions/hle_asm_exch_lock-spec.cpp \
../lock_functions/hle_asm_exch_lock-asm_spec.cpp \
../lock_functions/LockType.cpp \
../../util.cpp
# ../boost_mutex_lock.cpp # Problems with includes

OBJECTS=$(SOURCES:.cpp=.o)
ASM=$(SOURCES:.cpp=.s)
EXECUTABLE=time_cmp

# time_cmp
$(EXECUTABLE): $(SOURCES)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES) $(LDLAGS)
.cpp.s:
	$(SC) $(SFLAGS) $(CCFLAGS) $< -o $@ $(LDLAGS)

#all: $(EXECUTABLE)

#.cpp.o:
#	$(CC) $(CFLAGS) $< -o $@
