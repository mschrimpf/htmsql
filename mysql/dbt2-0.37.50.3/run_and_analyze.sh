#!/bin/bash

source ./util.sh

function usage() {
	echo "usage: run_and_analyze.sh output_base [options]"
	echo "	output_base: path to the folder containing all report-files"
	echo "	options:"
	echo "		-c | --connections"
	echo "		-t | --time | --duration"
	echo "		-w | --warehouses"
}

# we use a leading underscore for all of our variables 
# to avoid interfering with other scripts
_CONNECTIONS=20
_DURATION=300
_WAREHOUSES=30
_OUTPUT_BASE=

_STDOUT_LOGFILENAME="stdout.log"
_PERF_FILENAME="perf.txt"

# options
while [ "$1" != "" ]; do
	case $1 in
		-c | --connections )		shift
									_CONNECTIONS=$1
									;;
		-t | --time | --duration ) 	shift
									_DURATION=$1
									;;
		-w | --warehouses ) 		shift
									_WAREHOUSES=$1
									;;
		-h | --help ) 				usage
									exit
									;;
		* ) 						_OUTPUT_BASE=$1
									;;
	esac
	shift
done

if [ "$_OUTPUT_BASE" = "" ]; then
	echo "output_base is not defined"
	usage
	exit
fi

# copy to log-file as well as stdout
_STDOUT_FILE="$_OUTPUT_BASE/$_STDOUT_LOGFILENAME" # use tmp-file first, copy to actual folder later

# Redirect all script output to a logfile as well as 
# their normal locations
source ./util.sh
log_stdouterr "$_STDOUT_FILE"

# run info
echo "output_base: $_OUTPUT_BASE"

_NOW=$(date)
echo "Started on:   $_NOW"
_APPROX_END=$(date --date="$_DURATION seconds")
echo "Expected end: $_APPROX_END"

function mv_stdout_log() {
	mv $_STDOUT_FILE "$_OUTPUT_FOLDER/$_STDOUT_LOGFILENAME"
}
# status
# kills the scripts if needed
# returns the status-value (0 for ok, other values are an error code)
# the status-value is also saved in the $_STATUS variable
function check_status() {
	_STATUS="${?}"
	if [ "$_STATUS" != 0 ]; then
		echo "Error executing script"
		# kill perf
		if [ "$_PROFILE_PID" != 0 ]; then
			echo "Killing PERF"
			kill $_PROFILE_PID
		fi
		# move log-file
		mv_stdout_log
		exit
	fi
	
	return "$_STATUS"
}

# run
function run() {
	_EXEC_CMD="./scripts/run_mysql.sh \
		--connections $_CONNECTIONS \
		--time $_DURATION \
		--warehouses $_WAREHOUSES \
		--output-base $_OUTPUT_BASE"
	echo "RUNNING TEST: $_EXEC_CMD"
	eval $_EXEC_CMD
}

# Finds the output_folder of this test if it has not been retrieved before.
function get_output_folder() {
	if [ "$_OUTPUT_FOLDER" = "" ]; then
		_OUTPUT_FOLDER=$(ls -td $_OUTPUT_BASE/*/ | head -1)
	fi
}

function profile() {
	_MYSQL_PID=$(pidof mysqld)
	# _STARTUP_TIME=$(echo "($_CONNECTIONS * 0.3 * 1.5) / 1" | bc) # approximation
	_SLEEPY=300
	_STARTUP_SLEEP=$(( ((1+$_CONNECTIONS)*$_SLEEPY)/1000+1 )) # from run_mysql.sh.in ("sleep for .. to start .. database connections")
	echo "Waiting for $_STARTUP_SLEEP sec before profiling"
	sleep $_STARTUP_SLEEP
	
	get_output_folder
	_PERF_DURATION=$(echo "$_DURATION - 5" | bc)
	_EXEC_CMD="perf stat -T -p $_MYSQL_PID sleep $_PERF_DURATION &>$_OUTPUT_FOLDER/$_PERF_FILENAME"
	echo "PROFILING PERF: $_EXEC_CMD"
	eval $_EXEC_CMD
}

run &
_RUN_PID=$!
profile &
_PROFILE_PID=$!

wait $_RUN_PID
check_status
wait $_PROFILE_PID

# analyze
get_output_folder

_EXEC_CMD="python dbttools/bin/dbt2-generate-report \
	--dbms mysql \
	--i $_OUTPUT_FOLDER"
echo "ANALYZING RESULTS: $_EXEC_CMD"
eval $_EXEC_CMD

check_status
# stdout_log has not yet been moved (on error)
if [ "$_STATUS" == 0 ]; then
	mv_stdout_log
fi