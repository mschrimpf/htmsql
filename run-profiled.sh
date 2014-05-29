#!/bin/bash
function usage {
	echo "usage: $0 program -o output"
}

OUTPUT_FOLDER=
PROGRAM=

while [ "$1" != "" ]; do
	case $1 in
		-h | --help )
						usage
						exit
						;;
		-o | --output )
						shift
						OUTPUT_FOLDER="$1"
						;;
		*) 
						PROGRAM="$1"
						;;
	esac
	shift
done

if [ "$PROGRAM" == "" ]; then
	echo "No program set"
	usage
	exit
fi
if [ "$OUTPUT_FOLDER" == "" ]; then
	echo "No output set"
	usage
	exit
fi

PROGRAM_DIR=$(dirname "$PROGRAM")
OUTPUT_FOLDER="$PROGRAM_DIR/$OUTPUT_FOLDER"
echo "output: $OUTPUT_FOLDER"
mkdir "$OUTPUT_FOLDER" -p

###
own_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$own_path/profiling.sh"

# $1: program to run
function run_program {
	echo "RUNNING PROGRAM: $1"
	eval "$1" &
}

run_program "$PROGRAM"
PROGRAM_CALLER_PID=$!
PROGRAM_ARR=($PROGRAM)
PROGRAM_NAME=${PROGRAM_ARR[0]}
# sleep 1 # let the program sleep and thus wait for perf instead
PROGRAM_PID=$(pidof $PROGRAM_NAME)
echo "pid of $PROGRAM_NAME: $PROGRAM_PID"

profile_perf_stat "$PROGRAM_PID" "$OUTPUT_FOLDER" true &
profile_perf_stat_events "$PROGRAM_PID" "$OUTPUT_FOLDER" true &
profile_perf_stat_rtm_events "$PROGRAM_PID" "$OUTPUT_FOLDER" true &
# profile_perf_record_event "$PROGRAM_PID" "$OUTPUT_FOLDER" "tx-start" true &
# profile_perf_record_event "$PROGRAM_PID" "$OUTPUT_FOLDER" "el-start" true &
# profile_perf_record_aborts "$PROGRAM_PID" "$OUTPUT_FOLDER" true &
# profile_perf_record_rtm_aborts "$PROGRAM_PID" "$OUTPUT_FOLDER" true &


wait "$PROGRAM_CALLER_PID"
stop_profiling "$OUTPUT_FOLDER"


