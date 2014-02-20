#!/bin/bash

source ./util.sh

function usage() {
	echo "usage: setup.sh type"
	echo "	type: u|unmodified|a|alpha"
}


# we use a leading underscore for all of our variables 
# to avoid interfering with other scripts
_SETUP_LOGFILENAME="setup.log"


_SETUP_TYPE=
_SETUP_CMD=

# options
while [ "$1" != "" ]; do
	case $1 in
		-h | --help ) 				usage
									exit
									;;
		* ) 						_SETUP_TYPE=$1
									;;
	esac
	shift
done

if [ "$_SETUP_TYPE" = "" ]; then
	usage
	exit
else
	check_type "$_SETUP_TYPE"
	exit_if_status_error
fi


# Redirect all script output to a logfile as well as 
# their normal locations
get_report_folder_from_type "$_SETUP_TYPE"
log_stdouterr "$DBT2_REPORTDIR/$_SETUP_LOGFILENAME"

_SETUP_START=$(date)
echo "Setup started on: $_SETUP_START"
echo "Setup type:       $_SETUP_TYPE"
get_mysql_folder_from_type "$_SETUP_TYPE"
echo "MySQL-Folder:     $DBT2_MYSQLBINDIR"


# setup tables
_SETUP_CMD="./scripts/mysql/mysql_load_db.sh \
		--socket /tmp/mysql.sock \
		--path /tmp/dbt2_data \
		--mysql-path $DBT2_MYSQLBINDIR/$_MYSQL_FILE_MYSQL"
execute_cmd "$_SETUP_CMD" "LOADING TABLES"

# setup stored procedures
_SETUP_CMD="./scripts/mysql/mysql_load_sp.sh \
		--database dbt2 \
		--socket /tmp/mysql.sock \
		--sp-path storedproc/mysql \
		--client-path $DBT2_MYSQLBINDIR"
execute_cmd "$_SETUP_CMD" "LOADING STORED PROCEDURES"