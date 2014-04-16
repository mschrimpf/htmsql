#!/bin/bash
# 
#
# Author: Martin Schrimpf
# 	during the work on "HTM in MySQL" at the University of Sydney. 
# 	at the beginning of 2014.
#


# Logs both stdout and stderr to the file given as first argument. They 
# will still be displayed on the console.
function log_stdouterr {
	if [ "$1" == "" ]; then
		echo "No file-argument provided"
		exit 1
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
# executes the given command. If a second argument is provided, the 
# label will be echo'd as description. Also checks for the status and 
# exits if the program was unsuccessful.
# $1: cmd 
# $2: (optional) label - no prints will be made if empty
# $3: (optional) set to false to ignore errors
function execute_cmd {
	if [ "$1" == "" ]; then
		echo "Invalid function parameter: need at least 1 (command)"
		exit 1
	fi
	if [ "$2" != "" ]; then
		echo "$2: $1"
	fi
	
	#begin prompt
	_DO_PROMPT=false
	if [ "$_DO_PROMPT" = true ]; then
		echo ">> q to quit, any other key to execute"
		read _user_input
		if [ "$_user_input" == "q" ]; then
			echo "Quitting"
			exit
		fi
	fi
	#end prompt
	
	eval "$1"
	
	if [ "$3" != false ]; then
		exit_if_status_error
	fi
}

# Exits if the return status of the previous function is != 0.
function exit_if_status_error {
	_STATUS="${?}"
	if [ "$_STATUS" != 0 ]; then
		echo "Error status -> exit"
		exit "$_STATUS"
	fi
}

# Take care of special characters (such as / or &) in $2 and $3 
# and escape them with a \
# $1: path
# $2: old string
# $3: replace string
function replace_string_recursive {
	path="$1"
	oldstring="$2"
	newstring="$3"
	if [ "$path" == "" ] || [ "$oldstring" == "" ] || [ "$newstring" == "" ]; then
		echo "Not enough parameters provided - Usage: replace_string_recursive path oldstring newstring"
		return
	fi
	grep -rl "$oldstring" "$path" | xargs sed -i s/"$oldstring"/"$newstring"/g
}