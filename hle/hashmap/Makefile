CC=g++
SC=gcc
CCFLAGS=-std=c++0x -O2 # compiler flags
LDLAGS=-fgnu-tm -mrtm -pthread -Wl,--no-as-needed # linker flags
SFLAGS=-S -masm=intel
SOURCES_ALL=time_cmp.cpp \
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
../../util.cpp \
../../Stats.cpp

SOURCES_BUCKET=HashMap.cpp \
HashMap-rtm.cpp \
$(SOURCES_ALL)

SOURCES_GLOBAL=HashMap-global.cpp \
HashMap-rtm.cpp \
$(SOURCES_ALL)

OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=time_cmp

# time_cmp
$(EXECUTABLE)-bucket: $(SOURCES_BUCKET)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_BUCKET) $(LDLAGS)
$(EXECUTABLE)-global: $(SOURCES_GLOBAL)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_GLOBAL) $(LDLAGS)

# test
SOURCES_TEST=test_hashmap.cpp \
HashMap.cpp \
../lock_functions/pthread_lock.cpp ../lock_functions/thread_lock.cpp \
../lock_functions/atomic_exch_lock.cpp ../lock_functions/atomic_exch_hle_lock.cpp ../lock_functions/atomic_tas_lock.cpp ../lock_functions/atomic_tas_hle_lock.cpp ../lock_functions/atomic_exch_hle_lock2.cpp \
../lock_functions/hle_tas_lock-busy.cpp ../lock_functions/hle_tas_lock-spec.cpp \
../lock_functions/hle_exch_lock-busy.cpp ../lock_functions/hle_exch_lock-spec.cpp \
../lock_functions/hle_asm_exch_lock-busy.cpp ../lock_functions/hle_asm_exch_lock-spec.cpp \
../lock_functions/hle_asm_exch_lock-asm_spec.cpp \
../lock_functions/LockType.cpp \
../../util.cpp
test: $(SOURCES_TEST)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_TEST) $(LDLAGS)
