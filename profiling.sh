#!/bin/bash

source ~/develop/util.sh

declare -A _HARDWARE_EVENTS
# TX
# _HARDWARE_EVENTS[TX_MEM.ABORT_CONFLICT]=0154
# _HARDWARE_EVENTS[TX_MEM.ABORT_CAPACITY_WRITE]=0254
# _HARDWARE_EVENTS[TX_MEM.ABORT_HLE_STORE_TO_ELIDED_LOCK]=0454
# _HARDWARE_EVENTS[TX_MEM.ABORT_HLE_ELISION_BUFFER_NOT_EMPTY]=0854
# _HARDWARE_EVENTS[TX_MEM.ABORT_HLE_ELISION_BUFFER_NOT_EMPTY]=1054
# _HARDWARE_EVENTS[TX_MEM.ABORT_HLE_ELISION_BUFFER_UNSUPPORTED_ALIGNMENT]=2054
# _HARDWARE_EVENTS[TX_MEM.HLE_ELISION_BUFFER_FULL]=4054
# HLE
_HARDWARE_EVENTS[HLE_RETIRED.START]=01C8
_HARDWARE_EVENTS[HLE_RETIRED.COMMIT]=02C8
_HARDWARE_EVENTS[HLE_RETIRED.ABORTED]=04C8
_HARDWARE_EVENTS[HLE_RETIRED.ABORTED_MISC1]=08C8
_HARDWARE_EVENTS[HLE_RETIRED.ABORTED_MISC2]=10C8
_HARDWARE_EVENTS[HLE_RETIRED.ABORTED_MISC3]=20C8
_HARDWARE_EVENTS[HLE_RETIRED.ABORTED_MISC4]=40C8
_HARDWARE_EVENTS[HLE_RETIRED.ABORTED_MISC5]=80C8
# RTM - amounts to zero in our case
# _HARDWARE_EVENTS[RTM_RETIRED.START]=01C9
# _HARDWARE_EVENTS[RTM_RETIRED.COMMIT]=02C9
# _HARDWARE_EVENTS[RTM_RETIRED.ABORTED]=04C9
# _HARDWARE_EVENTS[RTM_RETIRED.ABORTED_MISC1]=08C9
# _HARDWARE_EVENTS[RTM_RETIRED.ABORTED_MISC2]=10C9
# _HARDWARE_EVENTS[RTM_RETIRED.ABORTED_MISC3]=20C9
# _HARDWARE_EVENTS[RTM_RETIRED.ABORTED_MISC4]=40C9
# _HARDWARE_EVENTS[RTM_RETIRED.ABORTED_MISC5]=80C9

declare -A _HTM_LOCKS_EVENTS
_HTM_LOCKS_EVENTS[HLE_RETIRED.START]=01C8
_HTM_LOCKS_EVENTS[MEM_UOPS_RETIRED.LOCK_LOADS]=21D0
_HTM_LOCKS_EVENTS[CYCLES]=cycles


_FILENAME_PERF_STAT="perf.stat"
_FILENAME_PERF_STAT_EVENTS="perf.stat.events"
_FILENAME_PERF_STAT_MISSINGLOCKS_EVENTS="perf-missinglocks.stat.events"
_FILENAME_PERF_RECORD="perf.data"


# profile
# $1: pid
# $2: output
# $3: (optional) silent
function profile_perf_stat {
	_EXEC_CMD="perf stat \
		-T \
		-p $1 \
		&>$2/$_FILENAME_PERF_STAT"
	if [ "$3" == true ]; then
		execute_cmd "$_EXEC_CMD"
	else
		execute_cmd "$_EXEC_CMD" "PROFILING PERF STAT"
	fi
}
# Builds the events string for the perf stat cmd
# Associative array argument has to be passed in the following way:
# 	profile_perf_stat_events_build_eventstring "$(declare -p assoc_array)"
# Result is in $_PERF_STAT_EVENTS
function profile_perf_stat_events_build_eventstring {
	eval "declare -A _array="${1#*=}
	if [ ${#_array[@]} -eq 0 ]; then
		echo "No array provided"
		exit 1
	fi
	_PERF_STAT_EVENTS="-e '{"
	for _event_label in "${!_array[@]}"
	do
		if [ "${_array[$_event_label]}" != "${_array[@]:0:1}" ]; then
			_PERF_STAT_EVENTS="${_PERF_STAT_EVENTS}," # add a comma for all items except the first one
		fi
		if [[ "${_array[$_event_label]}" =~ ^[0-9].* ]]; then
			_PERF_STAT_EVENTS="${_PERF_STAT_EVENTS}r" # add a comma for unmask-vals/event-nums
		fi
		_PERF_STAT_EVENTS="${_PERF_STAT_EVENTS}${_array[$_event_label]}"
	done
	export _PERF_STAT_EVENTS="$_PERF_STAT_EVENTS}'"
}
# $1: pid
# $2: output-dir
# $3: (optional) silent
function profile_perf_stat_events {
	profile_perf_stat_events_build_eventstring "$(declare -p _HARDWARE_EVENTS)"
	_EXEC_CMD="perf stat \
			$_PERF_STAT_EVENTS \
			-p $1 \
			&>$2/$_FILENAME_PERF_STAT_EVENTS"
	if [ "$3" == true ]; then
		execute_cmd "$_EXEC_CMD"
	else
		execute_cmd "$_EXEC_CMD" "PROFILING PERF STAT EVENTS"
	fi
}
# Profile for abort causes
# $1: pid
# $2: output-dir
# $3: (optional) silent
function profile_perf_record {
	_EXEC_CMD="perf record \
				-e cpu/el-abort/pp \
				-g \
				--transaction \
				--weight \
				-p $1 \
				-o $2/$_FILENAME_PERF_RECORD"
	if [ "$3" == true ]; then
		execute_cmd "$_EXEC_CMD"
	else
		execute_cmd "$_EXEC_CMD" "PROFILING PERF RECORD"
	fi
}
# $1: pid
# $2: output-dir
# $3: (optional) silent
function profile_perf_missinglocks {
	profile_perf_stat_events_build_eventstring "$(declare -p _HTM_LOCKS_EVENTS)"
	_EXEC_CMD="perf stat \
			$_PERF_STAT_EVENTS \
			-p $1 \
			&>$2/$_FILENAME_PERF_STAT_MISSINGLOCKS_EVENTS"
	if [ "$3" == true ]; then
		execute_cmd "$_EXEC_CMD"
	else
		execute_cmd "$_EXEC_CMD" "PROFILING PERF STAT EVENTS missing locks"
	fi
}

# $1: pid
# $2: output-dir
# $3: (optional) silent
function profile_all {
	profile_perf_stat "$1" "$2" "$3" &
	profile_perf_stat_events "$1" "$2" "$3" &
	profile_perf_record "$1" "$2" "$3" &
	profile_perf_missinglocks "$1" "$2" "$3" &
}


# Stops the perf processes (as defined by their pids) if they exist.
function stop_profiling {
	# _PERF_PROCESSES_BEFORE=$(pidof -x perf | wc -w) 
	# _PID_FILE="$_OUTPUT_DIR/$_FILENAME_PERF_STAT$_FILENAME_PID_SUFFIX" 
	# if [ -f "$_PID_FILE" ]; then
		# echo "Stopping perf stat"
		# read _PROFILE_PERF_STAT_PID < "$_PID_FILE"
		# kill -INT "$_PROFILE_PERF_STAT_PID"
		# rm "$_PID_FILE"
	# fi 
	# _PID_FILE="$_OUTPUT_DIR/$_PERF_RECORD_FILENAME$_FILENAME_PID_SUFFIX" 
	# if [ -f "$_PID_FILE" ]; then
		# read _PROFILE_PERF_RECORD_PID < "$_PID_FILE" 
		# echo "Stopping perf record"
		# kill -INT "$_PROFILE_PERF_RECORD_PID"
		# rm "$_PID_FILE"
	# fi
	
	# _PERF_PROCESSES=$(pidof -x perf | wc -w)
	# # no profile processes have been killed and they were active
	# if [ "$_PERF_PROCESSES_BEFORE" == "$_PERF_PROCESSES" ] && [ "$_PERF_PROCESSES_BEFORE" != "0" ]; then
		# echo ">> Perf processes could not be stopped - using pkill (FIXME)"
		pkill -INT perf
	# fi
	
	echo "Profiling stopped"
}
