#!/bin/bash

# run_mysql_test.sh
#
# This file is released under the terms of the Artistic License.  Please see
# the file LICENSE, included in this package, for details.
#
# Copyright (C) 2002 Mark Wong & Open Source Development Lab, Inc.
# Copyright (C) 2004 Alexey Stroganov & MySQL AB.
# Copyright (tC) 2006 iClaustron AB & Dolphin ICS ASA
# Copyright (C) 2008, 2011 Oracle and/or its affiliates. All rights reserved.
#
# Changes by Mikael Ronstrom, 2008
# Introduced a possibility to run a pre-run of the script to
# to set-up things for several parallel instances running clients
# and drivers.
# Introduced a pre_run_mysql_test.sh to ensure smooth start of many
# parallel clients.
#
# Changes Oracle 2011
# - Log all messages to terminal also to a log file
# - Changed all script input parameters to be --name instead of -c where c
#   can be any character to make test input more digestable.
# - Removed use of sysstat.sh
# - New methods to check driver and client and whether they are alive.
# - New method to generate run number
# - Added new parameters to have first warehouse and last warehouse specified,
#   spread between warehouses, specifying client library path, specifying
#   client port, output base, real run or pre run, run number. Made it
#   possible to set extra warmup time, cooldown time, intermediate timer
#   resolution through a dbt2.conf file. Specified defaults of all parameters
#   and updated some defaults as well.
# - Changed from using if [".." == ".."] to if test ".." == ".." instead
# - Changed indentation of script code
# - Adapted script code to handle new parameters and other comments above.
# - Improved handling of LD_LIBRARY_PATH
#
# Script is now adapted for running by overlay script and not really intended
# for run as standalone script.
#
# 14 mar 2011
#

#Ensure all messages are sent both to the log file and to the terminal
msg_to_log()
{
  if test "x$LOG_FILE" != "x" ; then
    ${ECHO} "$MSG" >> ${LOG_FILE}
    if test "x$?" != "x0" ; then
      ${ECHO} "Failed to write to ${LOG_FILE}"
      exit 1
    fi
  fi
}

#Method used to write any output to log what script is doing
output_msg()
{
  ${ECHO} "$MSG"
  msg_to_log
}

abs_top_srcdir=/home/htmsql/develop/mysql/dbt2-0.37.50.3

#Install signals handlers
trap 'echo "Test was interrupted by Control-C."; \
      killall client; killall driver; killall sar; killall sadc; killall vmstat; killall iostat' INT 

trap 'echo "Test was interrupted. Got TERM signal."; \
      killall client; killall driver;  killall sar; killall sadc; killall vmstat; killall iostat ' TERM

EXIT_OK=0

usage() {

  echo ''
  echo 'Mandatory options:'
  echo '------------------'
  echo '       --connections          <number of database connections>'
  echo '       --time                 <duration of test in seconds, minimum 60>'
  echo '       --warehouses           <number of warehouses in database>'
  echo ''
  echo 'Configuration options:'
  echo '----------------------'
  echo '       --database             <database name. (default dbt2)>'
  echo '       --host                 <database host name. (default localhost)>'
  echo '       --port                 <database port number> (default 3306)'
  echo '       --socket               <database socket> (default not used)'
  echo '       --user                 <database user> (default root)'
  echo '       --password             <database password> (default not specified)'
  echo ''
  echo 'Runtime options:'
  echo '----------------'
  echo '       --thread-start-delay   <delay of starting of new thread in milliseconds'
  echo '                              (default 300)>'
  echo '       --stack-size           <stack size. (default 256k)>'
  echo '       --terminals            <terminals per warehouse. [1..10] (default 10)>'
  echo '       --first-warehouse      <first warehouse in test. (default 1)>'
  echo '       --last-warehouse       <last warehouse in test.'
  echo '                               (default number of warehouses in database)>'
  echo '       --comment              <comments for the test in result>'
  echo '       --zero-delay           <enable zero delays for test (default no)>'
  echo '       --client-port          <Enable several clients on one computer (default 30000)>'
  echo '       --lib-client-path      <Path to MySQL client library'
  echo '                               (default /usr/local/mysql/lib/mysql)'
  echo '       --output-base          <Base for output directory>'
  echo '       --verbose              <verbose output>'
  echo '       --run-number           <User supplied run number>'
  echo '       --only-run             <Skip all preparations>'
  echo '       --pre-run              <Perform only preparations>'
  echo ''
  echo 'Example: sh run_mysql.sh --connections 20 --time 300 --warehouses 10'
  echo 'Test will be run for 300 seconds with 20 database connections and scale factor(num of warehouses) 10'
  echo ''

  if [ "$1" != "" ]; then 
    echo ''
    echo "error: $1"
  fi
  
}


validate_parameter()
{
  if [ "$2" != "$3" ]; then
    usage
    MSG="wrong argument '$2' for parameter '-$1'"
    output_msg
    exit 1
  fi
}

check_client()
{
  if [ -f "$CLIENT_OUTPUT_DIR/dbt2_client.pid" ]; then
    CLIENT_PID=`cat $CLIENT_OUTPUT_DIR/dbt2_client.pid`;
  else
    CLIENT_PID=""
  fi
}

check_client_alive()
{
  if [ -f "$CLIENT_OUTPUT_DIR/dbt2_client.pid" ]; then
    CLIENT_PID=`cat $CLIENT_OUTPUT_DIR/dbt2_client.pid`;
  else
    MSG="ERROR: Client was not started. Please look at $OUTPUT_DIR/client.out and $CLIENT_OUTPUT_DIR/error.log for details."
    output_msg
    exit 15
  fi
}

check_driver()
{
  if [ -f "$DRIVER_OUTPUT_DIR/dbt2_driver.pid" ]; then
    DRIVER_PID=`cat $DRIVER_OUTPUT_DIR/dbt2_driver.pid`;
  else
    DRIVER_PID=""
  fi
}

check_driver_alive()
{
  if [ -f "$DRIVER_OUTPUT_DIR/dbt2_driver.pid" ]; then
    DRIVER_PID=`cat $DRIVER_OUTPUT_DIR/dbt2_driver.pid`;
  else
    MSG="ERROR: Driver was not started."
    output_msg
    exit 15
  fi
}

get_run_number()
{
# Determine run number for selecting an output directory
  if [ "x$RUN_NUMBER" = "x" ] ; then
    RUN_NUMBER=-1
    if [ -f "/tmp/.run_number" ]; then 
      read RUN_NUMBER < /tmp/.run_number
    fi
    if [ $RUN_NUMBER -eq -1 ]; then
      RUN_NUMBER=0
    fi
# Update the run number for the next test.
    NEW_RUN_NUMBER=`expr $RUN_NUMBER + 1`
    echo $NEW_RUN_NUMBER > /tmp/.run_number
  fi
}

DBCONN=""
DB_USER="root"
DB_PASSWORD=""
DB_PORT="3306"
DB_SOCKET=""
DURATION=""
WAREHOUSES=""
VERBOSE=""
ZERO_DELAY=""
FIRST_WAREHOUSE="1"
LAST_WAREHOUSE=""
SPREAD="1"
LIB_CLIENT_PATH="/usr/local/mysql/lib/mysql"

STACKSIZE=256
DB_NAME="dbt2"
DB_HOST="127.0.0.1"

TPW=10
SLEEPY=300
CLIENT_PORT="30000"
OUTPUT_BASE="$HOME"
REAL_RUN="yes"
PRE_RUN="yes"
RUN_NUMBER=
NEW_RUN_NUMBER=
EXTRA_WARMUP=0
COOLDOWN_TIME=20
KILL_CMD=
KILL_CLIENT_CMD=
KILL_DRIVER_CMD=
DEFAULT_DIR=
LOG_FILE=
ECHO=echo
INTERMEDIATE_TIMER_RESOLUTION="0"

if test $# -gt 0 ; then
  case $1 in
    --default-directory )
      shift
      DEFAULT_DIR="$1"
      shift
      ;;
    *)
  esac
fi

if test "x$DEFAULT_DIR" != "x" ; then
  DEFAULT_DBT2="${DEFAULT_DIR}/dbt2.conf"
  if test -f ${DEFAULT_DBT2} ; then
    . ${DEFAULT_DBT2}
  fi
fi

while test $# -gt 0
do
  case $1 in
    --only-run )
      REAL_RUN="yes"
      PRE_RUN="no"
      ;;
    --pre-run )
      REAL_RUN="no"
      PRE_RUN="yes"
      ;;
    --run-number )
      opt=$1
      shift
      RUN_NUMBER=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $RUN_NUMBER
      ;;
    --intermediate_timer_resolution )
      opt=$1
      shift
      INTERMEDIATE_TIMER_RESOLUTION=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $INTERMEDIATE_TIMER_RESOLUTION
      ;;
    --extra-warmup )
      opt=$1
      shift
      EXTRA_WARMUP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $EXTRA_WARMUP
      ;;
    --client-port | -client-port | --client_port | -client_port )
      opt=$1
      shift
      CLIENT_PORT=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $CLIENT_PORT
      ;;
    --spread )
      opt=$1
      shift
      SPREAD=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $SPREAD
      ;;
    --first-warehouse | first-warehouse | -first_warehouse | --first_warehouse )
      opt=$1
      shift
      FIRST_WAREHOUSE=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $FIRST_WAREHOUSE
      ;;
    --last-warehouse | -last-warehouse | -last_warehouse | --last_warehouse )
      opt=$1
      shift
      LAST_WAREHOUSE=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $LAST_WAREHOUSE
      ;;
    --connections | -connections | -c )
      opt=$1
      shift
      DBCON=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $DBCON 
      ;;
    --zero-delay | -zero-delay | --zero_delay | -zero_delay )
      ZERO_DELAY=1
      ;;
    --lib-client-path | --lib_client_path | -lib-client-path | -lib_client_path )
      shift
      LIB_CLIENT_PATH="$1:${LIB_CLIENT_PATH}"
      ;;
    --host | -host | -h )
      shift
      DB_HOST=$1
      ;;
    --stack-size | -stack-size | -stack_size | --stack_size )
      opt=$1
      shift
      STACKSIZE=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $STACKSIZE
      ;;
    --port | -port | -p )
      opt=$1
      shift
      DB_PORT=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $DB_PORT
      ;;
    --terminals | -terminals )
      opt=$1
      shift
      TPW=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TPW
      ;;
    --database | -database | -d )
      shift
      DB_NAME=$1
      ;;
    --socket | -s | -socket )
      shift
      DB_SOCKET=$1
      ;;
    --password | --pwd | -password | -passwd | --passwd )
      shift
      DB_PASSWORD=$1
      ;;
    --thread-start-delay | --thread_start_delay | -thread-start-delay | \
    -thread_start_delay )
      opt=$1
      shift
      SLEEPY=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $SLEEPY
      ;;
    --time | -t | -time )
      opt=$1
      shift
      DURATION=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $DURATION
      ;;
    --user | -user | -u )
      shift
      DB_USER=$1
      ;;
    --verbose | -verbose | -v )
      VERBOSE=1
      ;;
    --warehouses | -w | -warehouses )
      opt=$1
      shift
      WAREHOUSES=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $WAREHOUSES
      ;;
    --comment | -comment | -c )
      shift
      COMMENT=$1
      ;;
    --help | -help | ?  | -h )
      usage
      exit 1
      ;;
    --output-base | --output_base )
      shift
      OUTPUT_BASE="$1"
      ;;
    --log-file )
      shift
      LOG_FILE="$1"
      ;;
    * )
      usage
      MSG="$1 not found"
      output_msg
      exit 1
      ;;
  esac
  shift
done

if test "x$LD_LIBRARY_PATH" = "x" ; then
  LD_LIBRARY_PATH="$LIB_CLIENT_PATH"
else
  LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$LIB_CLIENT_PATH"
fi
export LD_LIBRARY_PATH

# Check parameters.

if test "$DBCON" == ""
then
    MSG="specify the number of database connections using --connections #"
    output_msg
    exit 1;
fi

if test "$DURATION" == ""
then
    MSG="specify the duration of the test in seconds using --time #"
    output_msg
    exit 1;
fi

if test "$WAREHOUSES" == ""
then
    MSG="specify the number of warehouses using --warehouses #"
    output_msg
    exit 1;
fi

if test $(( $DURATION*1 )) -lt 60
then 
  MSG="Time of benchmark should be larger than 60 secs. Please specify correct value"
  output_msg
  exit 1;
fi

if test $(( $TPW*1 )) -lt 1 -o $(( $TPW*1 )) -gt 10
then 
  MSG="TPW value should be in range [1..10]. Please specify correct value"
  output_msg
  exit 1;
fi

if test $(( $FIRST_WAREHOUSE*1 )) -lt 1
then
  MSG="First warehouse must be at least 1"
  output_msg
  exit 1;
fi

if test "$LAST_WAREHOUSE" == ""
then
  LAST_WAREHOUSE="$WAREHOUSES"
fi

SAMPLE_LENGTH=60
THREADS=$(( $WAREHOUSES*$TPW ))
WARMUPTIME=$(( 1+(($THREADS+$TPW)*$SLEEPY)/1000 ))
((WARMUPTIME += EXTRA_WARMUP))
SLEEPYTIME=$(( $WARMUPTIME+$DURATION ))
((SLEEPYTIME += COOLDOWN_TIME))
THREADS=$(( $WAREHOUSES*$TPW ))

# Determine the output directory for storing data.
DATE="$(date +'%Y%m%d_%H%M')"
get_run_number
#OUTPUT_DIR=$OUTPUT_BASE/output/$RUN_NUMBER
OUTPUT_DIR="${OUTPUT_BASE}/${RUN_NUMBER}_${DATE}-c_${DBCON}-w_${WAREHOUSES}"
CLIENT_OUTPUT_DIR=$OUTPUT_DIR/client
DRIVER_OUTPUT_DIR=$OUTPUT_DIR/driver
DB_OUTPUT_DIR=$OUTPUT_DIR/db

if [ "x$PRE_RUN" = "xyes" ] ; then

# Create the directories we will need.
  mkdir -p $OUTPUT_DIR
  mkdir -p $CLIENT_OUTPUT_DIR
  mkdir -p $DRIVER_OUTPUT_DIR
  mkdir -p $DB_OUTPUT_DIR


# Create a readme file in the output directory and date it.
  date >> $OUTPUT_DIR/readme.txt
  echo "$COMMENT" >> $OUTPUT_DIR/readme.txt
  uname -a >> $OUTPUT_DIR/readme.txt

# Output run information into the readme.txt.
  echo "Database Scale Factor: $WAREHOUSES warehouses" >> $OUTPUT_DIR/readme.txt
  echo "Test Duration: $DURATION seconds" >> $OUTPUT_DIR/readme.txt
  echo "Database Connections: $DBCON" >> $OUTPUT_DIR/readme.txt

  echo "ulimit -s $STACKSIZE" >> $OUTPUT_DIR/readme.txt

  echo "************************************************************************"
  echo "*                     DBT2 test for MySQL  started                     *"
  echo "*                                                                      *"
  echo "*            Results can be found in output/$RUN_NUMBER directory               *"
  echo "************************************************************************"
  echo "*                                                                      *"
  echo "*  Test consists of 4 stages:                                          *"
  echo "*                                                                      *"
  echo "*  1. Start of client to create pool of databases connections          *"
  echo "*  2. Start of driver to emulate terminals and transactions generation *"
  echo "*  3. Test                                                             *"     
  echo "*  4. Processing of results                                            *"
  echo "*                                                                      *"
  echo "************************************************************************"

  echo ""
  echo "DATABASE NAME:                $DB_NAME"
  echo "DATABASE USER:                $DB_USER"
  echo "CLIENT PORT:                  $CLIENT_PORT"
  echo "DATABASE HOST:                $DB_HOST"
  echo "DATABASE PORT:                $DB_PORT"

  if [ -n "$DB_PASSWORD" ]; then 
    echo "DATABASE PASSWORD:            *******" 
  fi 

  if [ -n "$DB_SOCKET" ]; then 
    echo "DATABASE SOCKET:              $DB_SOCKET"
  fi 

  echo "DATABASE CONNECTIONS:         $DBCON"
  echo "TERMINAL THREADS:             $THREADS"
  echo "SCALE FACTOR(WAREHOUSES):     $WAREHOUSES"
  echo "FIRST WAREHOUSE:              $FIRST_WAREHOUSE"
  echo "LAST WAREHOUSE:               $LAST_WAREHOUSE"
  echo "SPREAD                        $SPREAD"
  echo "TERMINALS PER WAREHOUSE:      $TPW"
  echo "DURATION OF TEST(in sec):     $DURATION"
  echo "SLEEPY in (msec)              $SLEEPY"
  echo "ZERO DELAYS MODE:             $ZERO_DELAY"
  echo ""

  CLIENT_COMMAND_ARGS="$CLIENT_COMMAND_ARGS -u $DB_USER"
  CLIENT_COMMAND_ARGS="$CLIENT_COMMAND_ARGS -l $DB_PORT"
  CLIENT_COMMAND_ARGS="$CLIENT_COMMAND_ARGS -p $CLIENT_PORT"
  CLIENT_COMMAND_ARGS="$CLIENT_COMMAND_ARGS -h $DB_HOST"
  CLIENT_COMMAND_ARGS="$CLIENT_COMMAND_ARGS -d $DB_NAME"
  CLIENT_COMMAND_ARGS="$CLIENT_COMMAND_ARGS -c $DBCON"
  CLIENT_COMMAND_ARGS="$CLIENT_COMMAND_ARGS -s $SLEEPY"
  CLIENT_COMMAND_ARGS="$CLIENT_COMMAND_ARGS -o $CLIENT_OUTPUT_DIR"
  CLIENT_COMMAND_ARGS="$CLIENT_COMMAND_ARGS -f"
  if [ -n "$DB_PASSWORD" ]; then 
    CLIENT_COMMAND_ARGS="$CLIENT_COMMAND_ARGS -a $DB_PASSWORD"
  fi 
  if [ -n "$DB_SOCKET" ]; then 
    CLIENT_COMMAND_ARGS="$CLIENT_COMMAND_ARGS -t $DB_SOCKET"
  fi 
  ulimit -s $STACKSIZE

# Start the client.
  echo ''
  echo "Stage 1. Starting up client..."

  CLIENT_COMMAND="$abs_top_srcdir/src/client $CLIENT_COMMAND_ARGS"
  CLIENT_COMMAND="${TASKSET} ${CPUS} ${CLIENT_COMMAND}"

  MSG="STARTING CLIENT CONNECTIONS: $CLIENT_COMMAND"
  output_msg
  
  nohup $CLIENT_COMMAND > $OUTPUT_DIR/client.out 2>&1 &

# Sleep long enough for all the client database connections to be established.
  CLIENT_SLEEP_TIME=$(( ((1+$DBCON)*$SLEEPY)/1000+1 ))
  echo "Delay for each thread - $SLEEPY msec. Will sleep for $CLIENT_SLEEP_TIME sec to start $DBCON database connections"
  sleep $CLIENT_SLEEP_TIME
  check_client_alive

  echo "Number of threads = $THREADS"
  echo "WARMUPTIME = $WARMUPTIME"
  echo "Sleepytime = $SLEEPYTIME"

# Start the driver.
  echo ''
  echo "Stage 2. Starting up driver..."
  echo "Delay for each thread - $SLEEPY msec. Will sleep for $WARMUPTIME sec to start $THREADS terminal threads"
  echo ""
  echo "Stage 3. Starting of the test. Duration of the test $DURATION sec" 

fi
if [ "x$REAL_RUN" = "xyes" ] ; then
  if [ -n "$ZERO_DELAY" ]; then
    DRIVER_ARGS="-ktd 0 -ktn 0 -kto 0 -ktp 0 -kts 0 -ttd 0 -ttn 0 -tto 0 -ttp 0 -tts 0"
  fi

  DRIVER_COMMAND_ARGS="-d 127.0.0.1 -l"
  DRIVER_COMMAND_ARGS="$DRIVER_COMMAND_ARGS $DURATION -wmin"
  DRIVER_COMMAND_ARGS="$DRIVER_COMMAND_ARGS $FIRST_WAREHOUSE -wmax"
  DRIVER_COMMAND_ARGS="$DRIVER_COMMAND_ARGS $LAST_WAREHOUSE -spread"
  DRIVER_COMMAND_ARGS="$DRIVER_COMMAND_ARGS $SPREAD -w $WAREHOUSES"
  DRIVER_COMMAND_ARGS="$DRIVER_COMMAND_ARGS -sleep $SLEEPY"
  DRIVER_COMMAND_ARGS="$DRIVER_COMMAND_ARGS -tpw $TPW"
  DRIVER_COMMAND_ARGS="$DRIVER_COMMAND_ARGS -outdir $DRIVER_OUTPUT_DIR"
  DRIVER_COMMAND_ARGS="$DRIVER_COMMAND_ARGS -p $CLIENT_PORT"
  DRIVER_COMMAND_ARGS="$DRIVER_COMMAND_ARGS -warmup $EXTRA_WARMUP"
  DRIVER_COMMAND_ARGS="$DRIVER_COMMAND_ARGS -cooldown $COOLDOWN_TIME"
  DRIVER_COMMAND_ARGS="$DRIVER_COMMAND_ARGS -intermediate_timer_resolution $INTERMEDIATE_TIMER_RESOLUTION"
  DRIVER_COMMAND="$abs_top_srcdir/src/driver $DRIVER_COMMAND_ARGS $DRIVER_ARGS"
  DRIVER_COMMAND="${TASKSET} ${CPUS} ${DRIVER_COMMAND}"

  MSG="STARTING DRIVER COMMAND: $DRIVER_COMMAND"
  output_msg

  nohup $DRIVER_COMMAND > $OUTPUT_DIR/driver.out 2>&1 &

  sleep 1
  check_driver_alive

# Sleep for the duration of the run, including driver rampup time and cooldown time
  sleep $SLEEPYTIME

  KILL_CMD="kill -9"
# Client doesn't go away by itself like the driver does and I nohup it.
  check_client
  if [ "x$CLIENT_PID" != "x" ]; then 
    echo "Shutdown clients. Send TERM signal to $CLIENT_PID."
    KILL_CLIENT_CMD="$KILL_CMD $CLIENT_PID"
    $KILL_CLIENT_CMD
  fi

  check_driver
  if [ "x$DRIVER_PID" != "x" ]; then 
    echo "Waiting for driver (pid $DRIVER_PID)"
    wait $DRIVER_PID
    #echo "Shutdown driver. Send TERM signal to $DRIVER_PID."
    #KILL_DRIVER_CMD="$KILL_CMD $DRIVER_PID"
    #$KILL_DRIVER_CMD
  fi

# Run some post processing analysese.
  echo ''
  echo "Stage 4. Processing of results..."

  perl $abs_top_srcdir/scripts/mix_analyzer.pl --infile $DRIVER_OUTPUT_DIR/mix.log --outfile $DRIVER_OUTPUT_DIR/statistics.log

  echo "Test completed."
fi
EXIT_OK=1
exit 0
