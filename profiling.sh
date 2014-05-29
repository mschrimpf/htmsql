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
_HARDWARE_EVENTS[HLE_RETIRED.ABORTED_MISC5]=80C8
_HARDWARE_EVENTS[HLE_RETIRED.ABORTED_MISC4]=40C8
# RTM
declare -A _HARDWARE_EVENTS_RTM
_HARDWARE_EVENTS_RTM[RTM_RETIRED.START]=01C9
_HARDWARE_EVENTS_RTM[RTM_RETIRED.COMMIT]=02C9
_HARDWARE_EVENTS_RTM[RTM_RETIRED.ABORTED]=04C9
_HARDWARE_EVENTS_RTM[RTM_RETIRED.ABORTED_MISC1]=08C9
_HARDWARE_EVENTS_RTM[RTM_RETIRED.ABORTED_MISC2]=10C9
_HARDWARE_EVENTS_RTM[RTM_RETIRED.ABORTED_MISC3]=20C9
_HARDWARE_EVENTS_RTM[RTM_RETIRED.ABORTED_MISC4]=40C9
_HARDWARE_EVENTS_RTM[RTM_RETIRED.ABORTED_MISC5]=80C9

declare -A _HTM_LOCKS_EVENTS
_HTM_LOCKS_EVENTS[HLE_RETIRED.START]=01C8
_HTM_LOCKS_EVENTS[MEM_UOPS_RETIRED.LOCK_LOADS]=21D0
_HTM_LOCKS_EVENTS[CYCLES]=cycles



_OUTPUT_FOLDER=

_FILENAME_PERF_STAT="perf.stat"
_FILENAME_MY_PERF_STAT="my-perf.stat"
_FILENAME_PERF_STAT_EVENTS="perf.stat.events"
_FILENAME_PERF_STAT_EVENTS_RTM="perf.stat.rtm-events"
_FILENAME_PERF_STAT_MISSINGLOCKS_EVENTS="perf-missinglocks.stat.events"
_FILENAME_PERF_RECORD="perf.data"
_FILENAME_PERF_RECORD_ABORTS="perf-aborts.data"
_FILENAME_PERF_RECORD_RTM_ABORTS="perf-rtm_aborts.data"


# profile
# $1: pid
# $2: output-dir
# $3: (optional) silent
function profile_perf_stat {
	_OUTPUT_FOLDER="$2"
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
			_PERF_STAT_EVENTS="${_PERF_STAT_EVENTS}r" # add an r for unmask-vals/event-nums
		fi
		_PERF_STAT_EVENTS="${_PERF_STAT_EVENTS}${_array[$_event_label]}"
	done
	export _PERF_STAT_EVENTS="$_PERF_STAT_EVENTS}'"
}
# $1: pid
# $2: output-dir
# $3: (optional) silent
function profile_perf_stat_events {
	_OUTPUT_FOLDER="$2"
	profile_perf_stat_events_build_eventstring "$(declare -p _HARDWARE_EVENTS)"
	_EXEC_CMD="perf stat \
			$_PERF_STAT_EVENTS \
			-p $1 \
			&>$2/$_FILENAME_PERF_STAT_EVENTS"
	if [ "$3" == true ]; then
		execute_cmd "$_EXEC_CMD"
	else
		execute_cmd "$_EXEC_CMD" "PROFILING PERF STAT EVENTS RTM"
	fi
}
# $1: pid
# $2: output-dir
# $3: (optional) silent
function profile_perf_stat_rtm_events {
	_OUTPUT_FOLDER="$2"
	profile_perf_stat_events_build_eventstring "$(declare -p _HARDWARE_EVENTS_RTM)"
	_EXEC_CMD="perf stat \
			$_PERF_STAT_EVENTS \
			-p $1 \
			&>$2/$_FILENAME_PERF_STAT_EVENTS_RTM"
	if [ "$3" == true ]; then
		execute_cmd "$_EXEC_CMD"
	else
		execute_cmd "$_EXEC_CMD" "PROFILING PERF STAT EVENTS"
	fi
}
# Profile for HLE abort causes
# $1: pid
# $2: output-dir
# $3: (optional) silent
function profile_perf_record_aborts {
	_OUTPUT_FOLDER="$2"
	profile_perf_record_event "$1" "$2" "cpu/el-abort/pp" "$3"
}
# Profile for RTM abort causes
# $1: pid
# $2: output-dir
# $3: (optional) silent
function profile_perf_record_rtm_aborts {
	_OUTPUT_FOLDER="$2"
	profile_perf_record_event "$1" "$2" "cpu/tx-abort/pp" "$3"
}
# Profile a specific event
# $1: pid
# $2: output-dir
# $3: event descriptor
# $4: (optional) silent
function profile_perf_record_event {
	record_filename=$(echo $3 | sed 's,/,_,g')
	record_filename="perf-$record_filename.data"
	_EXEC_CMD="perf record \
				-e $3 \
				-g \
				--transaction \
				--weight \
				-p $1 \
				-o $2/$record_filename"
	if [ "$4" == true ]; then
		execute_cmd "$_EXEC_CMD"
	else
		execute_cmd "$_EXEC_CMD" "PROFILING PERF RECORD $3"
	fi
}
# Profile everything
# $1: pid
# $2: output-dir
# $3: (optional) silent
function profile_perf_record {
	_OUTPUT_FOLDER="$2"
	_EXEC_CMD="perf record \
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
	_OUTPUT_FOLDER="$2"
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


# Stops the perf processes (as defined by their pids) if they exist.
# $1: output-folder
function stop_profiling {
	_OUTPUT_FOLDER="$1"

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
		pkill -INT -u $(id -u) perf # only kill processes of own user
	# fi
	
	echo "Profiling stopped"
	
	process_perf_stat "$_OUTPUT_FOLDER"
	process_perf_events "$_OUTPUT_FOLDER"
}

# Outputs the perf stat results with more accurate cycles-t and cycles-abort relative to cycles-t
# $1: directory containing the perf file
function process_perf_stat {
	if [ -f "$1/$_FILENAME_PERF_STAT" ]; then
		# sed without -E flag does not support the quantifiers + and ?
		# extract variables
		cycles=$(sed -ne "s/\([0-9\.,]*\) cycles.*GHz.*/\1/p" $1/$_FILENAME_PERF_STAT)
		cycles_t=$(sed -ne "s/\([0-9\.,]*\) *cpu\/cycles-t.*/\1/p" $1/$_FILENAME_PERF_STAT)
		cycles_ct=$(sed -ne "s/\([0-9\.,]*\) *cpu\/cycles-ct.*/\1/p" $1/$_FILENAME_PERF_STAT)
		# remove the dots/commas (commas occur with a different exported LC_NUMERIC)
		cycles=$(echo $cycles | sed 's/[\.,]*//g')
		cycles_t=$(echo $cycles_t | sed 's/[\.,]*//g')
		cycles_ct=$(echo $cycles_ct | sed 's/[\.,]*//g')
		# calculate vals
		share_cycles_transactional=$(bc -l <<< "($cycles_t / $cycles) * 100") # percentage
		share_cycles_abort=$(bc -l <<< "(1 - $cycles_ct / $cycles_t) * 100") # percentage
		cycles_aborted=$(bc -l <<< "$cycles_t - $cycles_ct")
		# output
		out_filename="$1/$_FILENAME_MY_PERF_STAT"
		
		export LC_NUMERIC="en_US.UTF-8" # use dots to separate floats
		
		printf -- 'Total cycles:         %15d\n' "$cycles"         > "$out_filename"
		printf -- 'Transactional cycles: %15d\n' "$cycles_t"       >> "$out_filename"
		printf -- 'Committed cycles:     %15d\n' "$cycles_ct"      >> "$out_filename"
		printf -- 'Aborted cycles:       %15d\n' "$cycles_aborted" >> "$out_filename"
		
		printf -- 'Transactional cycles relative to total:   %f%%\n' "$share_cycles_transactional"      >> "$out_filename"
		printf -- 'Aborted cycles relative to transactional: %f%%\n' "$share_cycles_abort"      >> "$out_filename"
		
		# echo "total cycles:         $cycles" 											> "$out_filename"
		# echo "transactional cycles: $cycles_t" 											>> "$out_filename"
		# echo "committed cycles:     $cycles_ct" 										>> "$out_filename"
		# echo "aborted cycles:       $cycles_aborted" 									>> "$out_filename"
		# echo "transactional cycles relative to total:   $share_cycles_transactional%" 	>> "$out_filename"
		# echo "aborted cycles relative to transactional: $share_cycles_abort%" 			>> "$out_filename"
	else
		echo "File $1/$_FILENAME_PERF_STAT does not exist"
	fi
}

# Adds labels to the event-desciprots of the perf-stat-events output-file
# $1: output-folder
function process_perf_events {
	#hle
	if [ -f "$1/$_FILENAME_PERF_STAT_EVENTS" ]; then
		for _event_label in "${!_HARDWARE_EVENTS[@]}"
		do
			sed -i "s/${_HARDWARE_EVENTS[$_event_label]}/${_HARDWARE_EVENTS[$_event_label]} ($_event_label)/g" "$1/$_FILENAME_PERF_STAT_EVENTS"
		done
	else
		echo "File $1/$_FILENAME_PERF_STAT_EVENTS does not exist"
	fi
	#rtm
	if [ -f "$1/$_FILENAME_PERF_STAT_EVENTS_RTM" ]; then
		for _event_label in "${!_HARDWARE_EVENTS_RTM[@]}"
		do
			sed -i "s/${_HARDWARE_EVENTS_RTM[$_event_label]}/${_HARDWARE_EVENTS_RTM[$_event_label]} ($_event_label)/g" "$1/$_FILENAME_PERF_STAT_EVENTS_RTM"
		done
	else
		echo "File $1/$_FILENAME_PERF_STAT_EVENTS_RTM does not exist"
	fi
}