#!/bin/bash

# Logs both stdout and stderr to the file given as first argument.
# They will still be displayed on the console.
function log_stdouterr {
	if [ "$1" == "" ]; then
		echo "No file-argument provided"
		exit
	fi
	
	pipe1="/tmp/dbt2-pipe1.$$"
	pipe2="/tmp/dbt2-pipe2.$$"
	trap 'rm "$pipe1" "$pipe2"' EXIT
	mkfifo "$pipe1"
	mkfifo "$pipe2"
	tee -a "$1" < "$pipe1" &
	tee -a "$1" >&2 < "$pipe2" &

	exec >"$pipe1"
	exec 2>"$pipe2"
}

# executes the given command.
# If a second argument is provided, the label will be echo'd as description.
# Also checks for the status and exits if the program was unsuccessful
# $1: cmd
# $2: (optional) label
function execute_cmd {
	if [ "$1" == "" ]; then
		echo "Invalid function parameter: need at least 1 (command)"
		exit
	fi

	if [ "$2" != "" ]; then
		echo "$2: $1"
	fi
	eval $1
	
	exit_if_status_error
}

# Checks whether the given argument is a valid type
# Returns 
# 	0 if a valid type was provided, 
# 	1 if the type is not valid and 
# 	2 if nothing was provided
function check_type {
	if [ "$1" == "" ]; then
		echo "Error: No type-argument provided"
		return 2
	elif [ "$1" != "u" ] && [ "$1" != "unmodified" ] \
		&& [ "$1" != "a" ] && [ "$1" != "alpha" ]; then
		echo "Error: Type has to be one of: u|unmodified|a|alpha"
		return 1
	fi
	return 0
}

# Exits if the return status of the previous function is != 0.
function exit_if_status_error {
	_STATUS="${?}"
	if [ "$_STATUS" != 0 ]; then
		echo "Error status -> exit"
		exit
	fi
}

declare -A _TYPES_REPORTDIRS
_TYPES_REPORTDIRS["u"]="../report-unmodified"
_TYPES_REPORTDIRS["unmodified"]="${_TYPES_REPORTDIRS[u]}"
_TYPES_REPORTDIRS["a"]="../report-alpha"
_TYPES_REPORTDIRS["alpha"]="${_TYPES_REPORTDIRS[a]}"
# Retrieves the report folder for the given type (u|unmofidied|a|alpha).
# The folder will be stored in $DBT2_REPORTDIR.
function get_report_folder_from_type {
	check_type "$1"
	exit_if_status_error
	DBT2_REPORTDIR="${_TYPES_REPORTDIRS[${1}]}"
}


_MYSQL_PATH_UNMOFIDIED="../mysql-5.6.10-unmodified"
_MYSQL_PATH_ALPHA="../mysql-5.6.10-alpha"
_MYSQL_PATH_INSTALL="install"
_MYSQL_PATH_BIN="bin"
_MYSQL_FILE_MYSQL="mysql"
declare -A _TYPES_MYSQLBINDIRS
_TYPES_MYSQLBINDIRS["u"]="$_MYSQL_PATH_UNMOFIDIED/$_MYSQL_PATH_INSTALL/$_MYSQL_PATH_BIN"
_TYPES_MYSQLBINDIRS["unmodified"]="${_TYPES_MYSQLBINDIRS[u]}"
_TYPES_MYSQLBINDIRS["a"]="$_MYSQL_PATH_ALPHA/$_MYSQL_PATH_INSTALL/$_MYSQL_PATH_BIN"
_TYPES_MYSQLBINDIRS["alpha"]="${_TYPES_MYSQLBINDIRS[a]}"
# Retrieves the folder for the given type.
# The folder will be stored in $DBT2_MYSQLBINDIR.
function get_mysql_folder_from_type {
	check_type "$1"
	exit_if_status_error
	DBT2_MYSQLBINDIR="${_TYPES_MYSQLBINDIRS[${1}]}"
}