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


_TYPE_ALL=(unmodified all all-byte glibc mutexlock_glibc global_lock global_lock_hle lock_word lock_word-extra system trx_all trx_lock_func trx_lock_func-rtm)



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
	
	echo "Error: Type has to be one of: $available_types"
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
	
	#export DBT2_REPORTDIR="${_TYPES_REPORTDIRS[${_TYPE}]}"
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
		--innodb_flush_log_at_trx_commit=2"
		#--max_connections=1000 \
		#--innodb_buffer_pool_size=21474836480
_MYSQL_CMD_SHUTDOWN="mysqladmin --no-defaults -u root shutdown"


# Retrieves the folder for the given type.
# The mysql-root-folder will be stored in $DBT2_MYSQLPATH.
# The install/bin folder will be stored in $DBT2_MYSQLBINDIR.
function get_mysql_folder_from_type {
	get_full_type "$1"
	exit_if_status_error
	export DBT2_MYSQLPATH="${_MYSQLDIRS_ROOTPATH}/$_MYSQLDIR_PREFIX$_TYPE"
	#export DBT2_MYSQLBINDIR="${_TYPES_MYSQLBINDIRS[${_TYPE}]}"
	export DBT2_MYSQLBINDIR="$DBT2_MYSQLPATH/$_MYSQL_PATH_INSTALL/$_MYSQL_PATH_BIN"
}

# Asynchronous start of MySQL located in $DBT2_MYSQLBINDIR.
function start_mysql {
	ulimit -Sn 4096
	#read -p "Start MySQL, then press enter"
	_EXEC_CMD="$DBT2_MYSQLBINDIR/$_MYSQL_CMD_START"
	execute_cmd "$_EXEC_CMD" "STARTING DATABASE" &
	sleep 5
}
# Synchronous stop of running MySQL instance.
function stop_mysql {
	#read -p "Stop MySQL, then press enter"
	_EXEC_CMD="$DBT2_MYSQLBINDIR/$_MYSQL_CMD_SHUTDOWN"
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
