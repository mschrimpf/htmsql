#!/bin/bash

# 
# This file provides a unification for DBT2, DBTTools and grep.
# By running this tool, DBT2 will automatically be setup (stopping 
# the database before) or DBT2-data will be restored if already 
# existent.
# MySQL is then started again, the test is started and perf-stat 
# as well as perf-record will automatically be started with the 
# test-run.
# After the test, a test-report is generated using DBTTools and 
# the perf-record is processed (into a call-graph). The results 
# of the test can be found in the $_ROOTPATH/report-$_TYPE folder.
# 
# To add another MySQL-version, you need to define a new _TYPE
# and specify the location of the MySQL-version in the _MYSQL_PATHS 
# array.
#
# 
# This suite suggests a folder structure like this:
# ./
# 	|+mysql-{unmodified|alpha|...}
# 	| mysql-util.sh
# 	|-sysbench
# 	|	|-build
# 	|	|	|-bin
# 	|	|	|	| run_sysbench.sh
# 	|+report-{unmodified|alpha|...}
# ~/develop/profiling.sh
# ~/develop/util.sh
# 
#
#
# Author: Martin Schrimpf
# 	during the work on "HTM in MySQL" at the University of Sydney.
# 	Feb-Apr 2014.
#


trap 'echo "Run was interrupted by Control-C."; \
	killall sysbench perf; stop_profiling;' INT
trap 'echo "Run was interrupted. Got TERM signal."; \
	killall sysbench perf; stop_profiling;' TERM


source ../../../util-mysql.sh
source ~/develop/profiling.sh

function usage() {
	echo "usage: ./run_sysbench.sh output_type [options]"
	echo "	output_type: u|unmodified|a|alpha"
	echo "	options:"
	echo "		-c | --connections"
	echo "		-t | --time | -d | --duration"
	echo "		-w | --warehouses"
	echo "		-p | --profile"
	echo "             1=stat"
	echo "             2=stat-events"
	echo "             3=record"
	echo "             4=missing_locks"
}

# we use a leading underscore for all of our variables 
# to avoid interfering with other scripts
_CONNECTIONS=4
_TABLE_SIZE=50000
_MAX_REQUESTS=50000
_DURATION=150
_OUTPUT_TYPE=

_STDOUT_LOGFILENAME="stdout.log"
_FILENAME_PID_SUFFIX=".pid"
_FILENAME_CALLGRAPH="call-graph.txt"

_PROFILE_SELECTOR_STAT=1
_PROFILE_SELECTOR_EVENTS=2
_PROFILE_SELECTOR_RECORD=3
_PROFILE_SELECTOR_MISSING_LOCKS=4
_PROFILE_SELECTOR=




# options
while [ "$1" != "" ]; do
	case $1 in
		-s | --size | --tablesize ) 	shift
										_TABLE_SIZE=$1
										;;
		-c | --connections )			shift
										_CONNECTIONS=$1
										;;
		-r | --requests )				shift
										_MAX_REQUESTS=$1
										;;
		-t | --time | -d | --duration ) shift
										_DURATION=$1
										;;
		-p | --profile ) 				shift
										_PROFILE_SELECTOR=$1
										;;
		-h | --help ) 					usage
										exit
										;;
		* ) 							_OUTPUT_TYPE=$1
										;;
	esac
	shift
done


# handle args and build output_dir
get_full_type "$_OUTPUT_TYPE"
get_mysql_folder_from_type "$_OUTPUT_TYPE"
get_report_folder_from_type "$_OUTPUT_TYPE"

_DATETIME="$(date +'%Y%m%d_%H%M')"
get_run_number
_OUTPUT_DIR="${SYSBENCH_REPORTDIR}/${RUN_NUMBER}-${_DATETIME}-s${_TABLE_SIZE}-c${_CONNECTIONS}-d${_DURATION}"


# copy to log-file as well as stdout
_STDOUT_FILE="${SYSBENCH_REPORTDIR}/$_STDOUT_LOGFILENAME"
function mv_stdout_log {
	mv $_STDOUT_FILE "$_OUTPUT_DIR/$_STDOUT_LOGFILENAME"
}

# Redirect all script outputs to a logfile 
# but also keep their default output streams
log_stdouterr "$_STDOUT_FILE"

_NOW=$(date)
echo "Started on:   $_NOW"
# _APPROX_END=$(date --date="$_DURATION seconds")
# echo "Expected end: $_APPROX_END"

# status
# kills the scripts if needed
# returns the status-value (0 for ok, other values are an error code)
# the status-value is also saved in the $_STATUS variable
function check_status() {
	export _STATUS="${?}"
	if [ "$_STATUS" != 0 ]; then
		echo "Error executing script"
		stop_profiling
		
		mv_stdout_log
		exit
	fi
	
	return "$_STATUS"
}



# Profiles perf stat and perf record.
# Saves the corresponding pids in $PROFILE_PERF_STAT_PID and $_PROFILE_PERF_RECORD_PID
function profile {
	_MYSQL_PID=$(pidof mysqld)
	
	if [ "$_PROFILE_SELECTOR" == "$_PROFILE_SELECTOR_STAT" ]; then
		profile_perf_stat "$_MYSQL_PID" "$_OUTPUT_DIR" &
	elif [ "$_PROFILE_SELECTOR" == "$_PROFILE_SELECTOR_EVENTS" ]; then
		profile_perf_stat_events "$_MYSQL_PID" "$_OUTPUT_DIR" &
	elif [ "$_PROFILE_SELECTOR" == "$_PROFILE_SELECTOR_RECORD" ]; then
		profile_perf_record "$_MYSQL_PID" "$_OUTPUT_DIR" &
	elif [ "$_PROFILE_SELECTOR" == "$_PROFILE_SELECTOR_MISSING_LOCKS" ]; then
		profile_perf_missinglocks "$_MYSQL_PID" "$_OUTPUT_DIR" &
	else
		profile_all "$_MYSQL_PID" "$_OUTPUT_DIR"
	fi
}

#####
# Suite run
#####

# init
_EXEC_CMD="./sysbench prepare --test=oltp \
		--oltp-table-size=$_TABLE_SIZE \
		--mysql-socket=/tmp/mysql.sock --mysql-user=root"
execute_cmd "$_EXEC_CMD"  "INITIALIZING"


# run and profile
echo "output: $_OUTPUT_DIR"
mkdir "$_OUTPUT_DIR"

_EXEC_CMD="./sysbench run --test=oltp \
		--num-threads=$_CONNECTIONS --max-time=$_DURATION --oltp-table-size=$_TABLE_SIZE --max-requests=$_MAX_REQUESTS \
		--mysql-socket=/tmp/mysql.sock --mysql-user=root \
		> $_OUTPUT_DIR/result.txt"
execute_cmd "$_EXEC_CMD" "RUNNING SYSBENCH" &

_RUN_PID=$!
profile &

echo "waiting for run_pid $_RUN_PID"
wait "$_RUN_PID"
stop_profiling
process_perf_events
check_status

# stdout_log has not yet been moved (on error)
if [ "$_STATUS" == 0 ]; then
	mv_stdout_log
fi

_EXEC_CMD="./sysbench cleanup --test=oltp \
		--num-threads=$_CONNECTIONS --max-requests=$_MAX_REQUESTS \
		--mysql-socket=/tmp/mysql.sock --mysql-user=root"
execute_cmd "$_EXEC_CMD"  "CLEANING UP"
