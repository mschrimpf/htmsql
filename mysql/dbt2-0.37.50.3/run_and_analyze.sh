#!/bin/bash

function usage() {
	echo "usage: run_and_analyze.sh output_base [options]"
	echo "	options:"
	echo "		-c | --connections"
	echo "		-t | --time | --duration"
	echo "		-w | --warehouses"
}
function checked_run() {
	$1
	
	STATUS="${?}"
	if [ "$STATUS" != 0 ]; then
		echo "Error executing script $1"
		exit
	fi
}

CONNECTIONS=20
DURATION=300
WAREHOUSES=30
OUTPUT_BASE=

PERF_FILENAME=perf.txt

# options
while [ "$1" != "" ]; do
	case $1 in
		-c | --connections )		shift
									CONNECTIONS=$1
									;;
		-t | --time | --duration ) 	shift
									DURATION=$1
									;;
		-w | --warehouses ) 		shift
									WAREHOUSES=$1
									;;
		-h | --help ) 				usage
									exit
									;;
		* ) 						OUTPUT_BASE=$1
									;;
	esac
	shift
done

if [ "$OUTPUT_BASE" = "" ]; then
	echo "output_base is not defined"
	usage
	exit
fi

echo "output_base: $OUTPUT_BASE"

NOW=$(date)
echo "Started on:   $NOW"
APPROX_END=$(date --date="$DURATION seconds")
echo "Expected end: $APPROX_END"

# run
function run() {
	echo "RUNNING TEST: ./scripts/run_mysql.sh 
		--connections $CONNECTIONS 
		--time $DURATION 
		--warehouses $WAREHOUSES 
		--output-base $OUTPUT_BASE"
	./scripts/run_mysql.sh \
		--connections $CONNECTIONS \
		--time $DURATION \
		--warehouses $WAREHOUSES \
		--output-base $OUTPUT_BASE
}

# Finds the output_folder of this test if it has not been retrieved before.
function get_output_folder() {
	if [ "$OUTPUT_FOLDER" = "" ]; then
		FOLDER=$(ls -t $OUTPUT_BASE | head -1)
		OUTPUT_FOLDER=$OUTPUT_BASE$FOLDER
	fi
}

function profile() {
	MYSQL_PID=$(pidof mysqld)
	STARTUP_TIME=$(echo "($CONNECTIONS * 0.3 * 1.5) / 1" | bc)
	echo "Waiting for $STARTUP_TIME seconds to profile"
	sleep $STARTUP_TIME
	
	get_output_folder
	echo "PROFILING PERF: perf stat -T -p $MYSQL_PID sleep $DURATION &>$OUTPUT_FOLDER/$PERF_FILENAME"
	perf stat -T -p $MYSQL_PID sleep $DURATION &>$OUTPUT_FOLDER/$PERF_FILENAME
}

run &
runpid=$!
profile &
profilepid=$!

wait $runpid
STATUS="${?}"
if [ "$STATUS" != 0 ]; then
	echo "Error executing script"
	echo "Killing PERF"
	kill $profilepid
	exit
fi

wait $profilepid

# analyze
get_output_folder

echo "ANALYZING RESULTS: python dbttools/bin/dbt2-generate-report \
	--dbms mysql \
	--i $OUTPUT_FOLDER"
python dbttools/bin/dbt2-generate-report \
	--dbms mysql \
	--i $OUTPUT_FOLDER

STATUS="${?}"
if [ "$STATUS" != 0 ]; then
	echo "Error executing script"
	exit
fi