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
	killall run perf; stop_profiling;' INT
trap 'echo "Run was interrupted. Got TERM signal."; \
	killall run perf; stop_profiling;' TERM


source ~/develop/mysql/util-mysql.sh
source ~/develop/profiling.sh

function usage() {
	echo "usage: ./run_txbench.sh output_type [options]"
	echo "	output_type: ${_TYPE_ALL[@]}"
	echo "	options:"
	echo "		-c | --connections"
	echo "		-t | --time | -d | --duration"
	echo "		-w | --warehouses"
	echo "		-pr_r"
	echo "		-pr_u"
	echo "		-p | --profile"
	echo "             1=stat"
	echo "             2=stat-events"
	echo "             3=record"
	echo "             4=missing_locks"
}

# we use a leading underscore for all of our variables 
# to avoid interfering with other scripts
_CONNECTIONS=4
_PR_READ=75
_PR_UPDATE=25

_TABLE_SIZE=50000
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
		-pr_r ) 						shift
										_PR_READ=$1
										;;
		-pr_u ) 						shift
										_PR_UPDATE=$1
										;;
		-c | --connections )			shift
										_CONNECTIONS=$1
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
_OUTPUT_DIR="${TXBENCH_REPORTDIR}/${RUN_NUMBER}-${_DATETIME}-pr_r${_PR_READ}_u${_PR_UPDATE}-t${_CONNECTIONS}-d${_DURATION}"


# copy to log-file as well as stdout
_STDOUT_FILE="${TXBENCH_REPORTDIR}/$_STDOUT_LOGFILENAME"
function mv_stdout_log {
	mv $_STDOUT_FILE "$_OUTPUT_DIR/$_STDOUT_LOGFILENAME"
}

# Redirect all script outputs to a logfile 
# but also keep their default output streams
log_stdouterr "$_STDOUT_FILE"

_NOW=$(date)
echo "Started on:   $_NOW"

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



# Compile

_EXEC_CMD="javac *.java"
execute_cmd "$_EXEC_CMD"  "COMPILING"

#####
# Suite run
#####

echo "Type is: $_TYPE"

#start_mysql
execute_on_haswell "source ~/develop/mysql/util-mysql.sh; 
	start_mysql $_TYPE ;" &
sleep 10 # wait until MySQL started
execute_on_haswell "./$MYSQLBINDIR/mysql --no-defaults -u root -e 'USE mysql; INSERT IGNORE INTO user (Host, Select_priv, Insert_priv, Update_priv, Delete_priv, Create_priv, Drop_priv, Reload_priv, Shutdown_priv, Process_priv, File_priv, Grant_priv, References_priv, Index_priv, Alter_priv, Show_db_priv, Super_priv, Create_tmp_table_priv, Lock_tables_priv, Execute_priv, Repl_slave_priv, Repl_client_priv, Create_view_priv, Show_view_priv, Create_routine_priv, Alter_routine_priv, Create_user_priv, Event_priv, Trigger_priv) VALUES (\"dbkemper4.informatik.tu-muenchen.de\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\", \"Y\");'"

# init
_EXEC_CMD="java -Dconfigure=./config.txt -cp .:./mysql-connector-java-5.1.11-bin.jar DBGen"
execute_cmd "$_EXEC_CMD"  "INITIALIZING"


# run and profile
echo "output: $_OUTPUT_DIR"
mkdir "$_OUTPUT_DIR"

_EXEC_CMD="java -Dconfigure=./config.txt -cp .:./mysql-connector-java-5.1.11-bin.jar SibenchClient $_CONNECTIONS $_PR_READ $_PR_UPDATE S2PL $_DURATION > $_OUTPUT_DIR/result.txt"
execute_cmd "$_EXEC_CMD" "RUNNING TXBENCH" &

_RUN_PID=$!

# wait until almost finished
sleep $(($_DURATION - 10))
#profile_mysql "$_TYPE" "$_OUTPUT_DIR" &
execute_on_haswell "source ~/develop/mysql/util-mysql.sh;
	profile_mysql $_TYPE $_OUTPUT_DIR;" &

echo "waiting for run_pid $_RUN_PID"
wait "$_RUN_PID"
#stop_profiling "$_OUTPUT_DIR"
execute_on_haswell "source ~/develop/profiling.sh;
	stop_profiling $_OUTPUT_DIR;"

# download profiling results
_EXEC_CMD="scp -r ${HASWELL_SERVER_USER}@${HASWELL_SERVER_ADDRESS}:$_OUTPUT_DIR $_OUTPUT_DIR"
execute_cmd "$_EXEC_CMD Downloading profiling results"

# copy profiling contents to result
echo "" >> "$_OUTPUT_DIR/result.txt" # blankline as separator
cat "$_OUTPUT_DIR/$_FILENAME_MY_PERF_STAT" >> "$_OUTPUT_DIR/result.txt"

check_status

_EXEC_CMD="java -Dconfigure=./config.txt -cp .:./mysql-connector-java-5.1.11-bin.jar Cleanup"
execute_cmd "$_EXEC_CMD" "CLEANING DATABASE"

#stop_mysql
execute_on_haswell "source ~/develop/mysql/util-mysql.sh;
	stop_mysql $_TYPE;"

# stdout_log has not yet been moved (on error)
if [ "$_STATUS" == 0 ]; then
	mv_stdout_log
fi

echo "Contents of $_OUTPUT_DIR/result.txt"
cat "$_OUTPUT_DIR/result.txt"