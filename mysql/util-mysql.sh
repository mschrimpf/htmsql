#!/bin/bash

# 
# This file provides utilities for running mysql and storing benchmark results.
# 
#
# To add another MySQL-version, you need to add its name to the $_TYPE_ALL array.
# The corresponding MySQL-version has to be located in 
# ${_MYSQLDIRS_ROOTPATH}/$_MYSQLDIR_PREFIX$_TYPE where _TYPE is your added type.
#
#
# Author: Martin Schrimpf
# 	during the work on "HTM in MySQL" at the University of Sydney.
# 	at the beginning of 2014.
#

source ~/develop/util.sh
source ~/develop/profiling.sh


# make sure the values in this array are ordered from shortest to longest, 
# otherwise e.g. "abc" would be matched even though one wanted "ab"
_TYPE_ALL=(unmodified all smartall glibc mutexlock_glibc global_latch global_hle_latch lock_word syslock syslock-rtm trx_all trx_lock_func trx_lock_func-rtm)



# Determine run number for selecting an output directory
function get_run_number {
	if [ "x$RUN_NUMBER" = "x" ] ; then
		RUN_NUMBER=-1
		if [ -f "/tmp/.run_number" ]; then 
			read RUN_NUMBER < /tmp/.run_number
		fi
		if [ "$RUN_NUMBER" -eq -1 ]; then
			RUN_NUMBER=1
		fi
		# Update the run number for the next test.
		NEW_RUN_NUMBER=$(expr $RUN_NUMBER + 1)
		echo "$NEW_RUN_NUMBER" > /tmp/.run_number
	fi
}


# Checks whether the given argument is a valid type 
# and saves the full type in $_TYPE
# Returns 
# 	0 if a valid type was provided, 
# 	1 if the type is not valid and 
# 	2 if nothing was provided
function get_full_type {
	if [ "$1" == "" ]; then
		echo "Error: No type-argument provided"
		return 2
	fi
		
	available_types="" # collect available settings on the fly
	
	for type in "${_TYPE_ALL[@]}"
	do
		# starts with
		pattern="$1"*
		if [[ "$type" == $pattern ]]; then
			export _TYPE=$type
			return 0
		fi
		available_types="$available_types|$type"
	done
	
	echo "Error: Type '$1' has to be one of: $available_types"
	return 1
}


_REPORTDIR_PREFIX="report-"
# declare -A _TYPES_REPORTDIRS
# _TYPES_REPORTDIRS[$_TYPE_UNMODIFIED]="${_MYSQLDIRS_ROOTPATH}/report-unmodified"
# _TYPES_REPORTDIRS[$_TYPE_ALPHA]="${_MYSQLDIRS_ROOTPATH}/report-alpha"
# _TYPES_REPORTDIRS[$_TYPE_SSSI]="${_MYSQLDIRS_ROOTPATH}/$_REPORTDIR_PREFIX-sssi"

# Retrieves the report folder for the given type (u|unmofidied|a|alpha).
# The folder will be stored in $DBT2_REPORTDIR as well as $SYSBENCH_REPORTDIR.
function get_report_folder_from_type {
	get_full_type "$1"
	exit_if_status_error
	
	if [ ! -d "$_MYSQLDIRS_ROOTPATH" ]; then
		echo "Error: mysql directories root $_MYSQLDIRS_ROOTPATH does not exist"
		return 1
	fi
	
	export DBT2_REPORTDIR="$_MYSQLDIRS_ROOTPATH/${_REPORTDIR_PREFIX}${_TYPE}-dbt2"
	export SYSBENCH_REPORTDIR="$_MYSQLDIRS_ROOTPATH/${_REPORTDIR_PREFIX}${_TYPE}-sysbench"
	export TXBENCH_REPORTDIR="$_MYSQLDIRS_ROOTPATH/${_REPORTDIR_PREFIX}${_TYPE}-txbench"
	
	if [ ! -d "$TXBENCH_REPORTDIR" ]; then
		mkdir "$TXBENCH_REPORTDIR"
	fi
}


_MYSQLDIRS_ROOTPATH="/home/htmsql/develop/mysql"
_MYSQLDIR_PREFIX="mysql-5.6.10-"
export _MYSQL_PATH_INSTALL="install"
export _MYSQL_PATH_BIN="bin"
export _MYSQL_FILE_MYSQL="mysql"

export _MYSQL_CNF="my.cnf"
export _MYSQL_DATA="$_MYSQL_PATH_INSTALL/data"
export _BACKUP_SUFFIX=".backup"

_MYSQL_CMD_START="mysqld --no-defaults \
		--max_connections=1000 \
		--performance_schema=OFF \
		--table_open_cache_instances=32 \
		--query_cache_type=0 \
		--query_cache_size=0 \
		--innodb_buffer_pool_size=2684354560 \
		--innodb_log_file_size=268435456 \
		--innodb_log_buffer_size=16777216 \
		--innodb_flush_method=fsync \
		--innodb_flush_log_at_trx_commit=2 \
		--tmpdir=/db/mysqltmpfs \
		--log-error"
		#--max_connections=1000 \
		#--innodb_buffer_pool_size=21474836480
_MYSQL_CMD_SHUTDOWN="mysqladmin --no-defaults -u root shutdown"


# Retrieves the folder for the given type.
# The mysql-root-folder will be stored in $MYSQLPATH.
# The install/bin folder will be stored in $MYSQLBINDIR.
function get_mysql_folder_from_type {
	get_full_type "$1"
	exit_if_status_error
	export MYSQLPATH="${_MYSQLDIRS_ROOTPATH}/$_MYSQLDIR_PREFIX$_TYPE"
	#export MYSQLBINDIR="${_TYPES_MYSQLBINDIRS[${_TYPE}]}"
	export MYSQLBINDIR="$MYSQLPATH/$_MYSQL_PATH_INSTALL/$_MYSQL_PATH_BIN"
}

# $1 type (ignored if $MYSQLBINDIR are already set)
function set_mysql_type_if_not_set {
	if [[ -z "$MYSQLBINDIR" ]]; then # type not yet set globally
		if [[ -z "$1" ]]; then # no type argument provided
			echo "Error: neither MYSQLBINDIR set nor type argument provided"
			return 1
		else
			get_mysql_folder_from_type "$1"
		fi
	fi
}

# Asynchronous start of MySQL located in $MYSQLBINDIR.
# $1 type (ignored if $MYSQLBINDIR is set)
function start_mysql {
	set_mysql_type_if_not_set "$1"
	exit_if_status_error
	ulimit -Sn 4096
	#read -p "Start MySQL, then press enter"
	_EXEC_CMD="$MYSQLBINDIR/$_MYSQL_CMD_START"
	execute_cmd "$_EXEC_CMD" "STARTING DATABASE" &
	sleep 5
}
# Synchronous stop of running MySQL instance.
# $1 type (ignored if $MYSQLBINDIR is set)
function stop_mysql {
	set_mysql_type_if_not_set "$1"
	exit_if_status_error
	#read -p "Stop MySQL, then press enter"
	_EXEC_CMD="$MYSQLBINDIR/$_MYSQL_CMD_SHUTDOWN"
	execute_cmd "$_EXEC_CMD" "STOPPING DATABASE" false
}

# Deletes the data in $DBT2_MYSQLPATH/$_MYSQL_DATA.
function delete_mysql_data {
	if [ -d "$DBT2_MYSQLPATH/$_MYSQL_DATA" ]; then
		rm -rf "$DBT2_MYSQLPATH/$_MYSQL_DATA"
	fi
	if [ -f "$DBT2_MYSQLPATH/$_MYSQL_PATH_INSTALL/$_MYSQL_CNF" ]; then
		rm "$DBT2_MYSQLPATH/$_MYSQL_PATH_INSTALL/$_MYSQL_CNF"
	fi
}



# Profiles MySQL
# $1: type
# $2: output dir
# $3: set to perf record instead of stat
function profile_mysql {
	if [[ -z "$1" ]]; then
		echo "Error: Type argument (1) not provided"
		return 1
	else
		export _TYPE="$1"
	fi
	if [[ -z "$2" ]]; then
		echo "Error: OutputDir argument (2) not provided"
		return 1
	else
		export _OUTPUT_DIR="$2"
		if [ ! -d "$_OUTPUT_DIR" ]; then
			echo "Creating output dir: $_OUTPUT_DIR"
			mkdir -p "$_OUTPUT_DIR"
		fi
	fi
	
	_MYSQL_PID=$(pidof mysqld)
	
	type_is_hle=true
	if [ "$_TYPE" == "glibc" ] || [ "$_TYPE" == "mutexlock_glibc" ] || [ "$_TYPE" == "trx_lock_func-rtm" ] || [ "$_TYPE" == "syslock-rtm" ]; then # rtm events
		type_is_hle=false
	fi
	
	if [ "$3" == 1 ] || [ "$3" == true ]; then # record
		if [ "$type_is_hle" == true ]; then
			profile_perf_record_event "$_MYSQL_PID" "$_OUTPUT_DIR" "tx-start" &
			profile_perf_record_event "$_MYSQL_PID" "$_OUTPUT_DIR" "cpu/tx-abort/pp" &
		else # hle events
			profile_perf_record_event "$_MYSQL_PID" "$_OUTPUT_DIR" "el-start" &
			profile_perf_record_event "$_MYSQL_PID" "$_OUTPUT_DIR" "cpu/el-abort/pp" &
		fi
	else # stat
		profile_perf_stat "$_MYSQL_PID" "$_OUTPUT_DIR" &
		if [ "$type_is_hle" == true ]; then
			profile_perf_stat_rtm_events "$_MYSQL_PID" "$_OUTPUT_DIR" &
		else # hle events
			profile_perf_stat_events "$_MYSQL_PID" "$_OUTPUT_DIR" &
		fi
	fi
}
