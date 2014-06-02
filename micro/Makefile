CC=g++
SC=gcc
CCFLAGS=-std=c++0x -O0 # compiler flags
LDLAGS=-fgnu-tm -mrtm -pthread #-Wl,--no-as-needed # linker flags
SFLAGS=-S -masm=intel


benchmarker: benchmarker.cpp
	$(CC) $(CCFLAGS) -o $@ benchmarker.cpp $(LDLAGS)


SOURCES_NESTING=nesting.cpp \
../util.cpp ../Stats.cpp
nesting: $(SOURCES_NESTING)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_NESTING) $(LDLAGS)

SOURCES_METHOD_NESTING=method-nesting.cpp \
../util.cpp ../Stats.cpp
method-nesting: $(SOURCES_METHOD_NESTING)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_METHOD_NESTING) $(LDLAGS)

SOURCES_MEMORY=memory.cpp \
../util.cpp ../Stats.cpp
memory: $(SOURCES_MEMORY)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_MEMORY) $(LDLAGS)

SOURCES_FUNC_RET=inner-function-return.cpp \
../util.cpp ../Stats.cpp
inner_function_return: $(SOURCES_FUNC_RET)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_FUNC_RET) $(LDLAGS)

SOURCES_LIST_RTM=ThreadsafeListRtm_contains.cpp \
../util.cpp ../Stats.cpp
list_rtm: $(SOURCES_LIST_RTM)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_LIST_RTM) $(LDLAGS)

SOURCES_ABORT_COSTS=abort-costs.cpp \
../util.cpp ../Stats.cpp
abort-costs: $(SOURCES_ABORT_COSTS)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_ABORT_COSTS) $(LDLAGS)

SOURCES_SET_ASSOCIATIVITY=set-associativity.cpp \
../util.cpp ../Stats.cpp
set-associativity: $(SOURCES_SET_ASSOCIATIVITY)
	$(CC) $(CCFLAGS) -O2 -o $@ $(SOURCES_SET_ASSOCIATIVITY) $(LDLAGS)

SOURCES_SET_ASSOCIATIVITY_DYNAMIC=set-associativity-dynamic.cpp \
../util.cpp ../Stats.cpp
set-associativity-dynamic: $(SOURCES_SET_ASSOCIATIVITY_DYNAMIC)
	$(CC) $(CCFLAGS) -O2 -o $@ $(SOURCES_SET_ASSOCIATIVITY_DYNAMIC) $(LDLAGS)

SOURCES_DATA_CONFLICT=data-conflict.cpp \
../util.cpp ../Stats.cpp
data-conflict: $(SOURCES_DATA_CONFLICT)
	$(CC) $(CCFLAGS) -O2 -o $@ $(SOURCES_DATA_CONFLICT) $(LDLAGS)

SOURCES_RTM_ABORT_FLAGS=rtm-abort_flags.cpp \
../util.cpp ../Stats.cpp
rtm-abort_flags: $(SOURCES_RTM_ABORT_FLAGS)
	$(CC) $(CCFLAGS) -o $@ $(SOURCES_RTM_ABORT_FLAGS) $(LDLAGS)
