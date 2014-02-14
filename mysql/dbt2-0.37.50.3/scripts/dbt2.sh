#!/bin/bash
# ----------------------------------------------------------------------
# Copyright (C) 2007 Dolphin Interconnect Solutions ASA, iClaustron  AB
#   2008, 2012 Oracle and/or its affiliates. All rights reserved.
# www.dolphinics.no
# www.iclaustron.com
# ----------------------------------------------------------------------
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; only version 2 of the License
#
# The GPL License is only valid with the above copyright notice retained.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

usage()
{
 cat <<EOF
  This program creates/loads the tables needed for the DBT2 benchmark.
  It can also run the DBT2 benchmark using a config file
  It will either create tables, create stored procedures or run tests or
  load data into tables, one and only one such activity can be performed
  It will use HOME_BASE/.build/dis_config.ini or DIS_CONFIG_FILE to find
  MySQL Servers.

  One can also invoke a variant that will invoke all activities. It will
  first create tables by invoking this script, then create stored procedures
  again using this script and finally load data, loading of data will be
  performed in parallel using a number of instances of this script. It will
  split loading of warehouses in parallel on those scripts.

  This program will not behave well using localhost as hostname since this
  hostname will be assumed to use socket communication which this script
  doesn't really attempt to set-up properly unless very careful management
  is provided if even possible. Thus real hostnames or IP addresses should
  be used instead.

  ACTIVITY:
  ---------
  --create_tables  : Perform only CREATE of the tables
  --create_sp      : Create stored procedures on all MySQL Servers
  --load_data      : Load data into tables
  --perform-all    : Initialise everything
  --run-test       : Run a number of DBT2 test runs as specified by config file

  PARAMETERS for all activities:
  ------------------------------
  --base_dir       : The directory where the DBT2 installation is found
  --version        : Version of MySQL to use
  --verbose        : Verbose output
  --cluster_id     : Use cluster id as provided here
  --ssh_port       : SSH port to use
  

  PARAMETERS for running DBT2 test:
  ---------------------------------
  --run-test       : Specify number of test, points to the config file in
                     HOME_BASE/.build/dbt2_run_1.conf (if 1 was provided)
                     or DEFAULT_DIR/dbt2_run_1.conf (if 1 provided and
                     DEFAULT_DIR set)
  --instance       : Number of instance of the run, points to run log directory
                     DEFAULT_DIR/dbt2_logs/dbt2_logs_c1/run_1/instance_1 where
                     cluster id was 1
                     the run test was 1 and instance was 1
  --time           : Time to run tests (default 300 secs)
  --num_warehouses : Number of warehouses in total in dbt2 database
  --first_client_port : First client port, default 30000
  --output-base    : Base directory for output directory
  --spread         : Spread between warehouses for a MySQL Server
  --ndb            : Use NDB API version of DBT2 test
  --debug          : Debug info for NDB API version

  PARAMETERS for create stored procedure:
  ----------------------------
  --mysql_node_id  : Node id of MySQL Server to use for creating stored procs

  PARAMETERS for create table:
  ----------------------------
  --mysql_node_id  : Node id of MySQL Server to use for loading/table create
  --data_dir       : The directory where all the files generated are placed
  --engine         : Storage engine to use
  --dont_use_hash  : Do not use USING HASH on tables
  --partition      : Set either PARTITION BY KEY or PARTITION BY HASH on tables

  PARAMETERS for load data
  ------------------------
  --mysql_node_id  : Node id of MySQL Server to use for loading/table create
  --data_dir       : The directory where all the files generated are placed
  --num_warehouses : Number of warehouses to create
  --first-warehouse: Number of first warehouse
 
  PARAMETERS for perform all
  -------------------------- 
  --data_dir       : The directory where all the files generated are placed
  --engine         : Storage engine to use
  --dont_use_hash  : Do not use USING HASH on tables
  --partition      : Set either PARTITION BY KEY or PARTITION BY HASH on tables
  --num_warehouses : Number of warehouses to create
  --num_servers    : Number of MySQL Servers to load from
EOF
}

#Ensure all messages are sent both to the log file and to the terminal
msg_to_log()
{
  if test "x$LOG_FILE" != "x" ; then
    echo "$MSG" >> ${LOG_FILE}
    if test "x$?" != "x0" ; then
      echo "Failed to write to ${LOG_FILE}"
      exit 1
    fi
  fi
}

#Method used to write any output to log what script is doing
output_msg()
{
  echo "$MSG"
  msg_to_log
}


validate_parameter()
{
  if test "x$2" != "x$3" ; then
    if test "$4" = "xno_exit" ; then
      MSG="wrong argument '$2' for parameter '-$1'"
      output_msg
      IGNORE_LINE="yes"
    else
      usage "wrong argument '$2' for parameter '-$1'"
      exit 1
    fi
  fi
}

execute_command()
{
  if test "x$VERBOSE_HERE" = "xyes" ; then
    MSG="Executing $EXEC_COMMAND"
    output_msg
    MSG="++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    output_msg
  fi
  $EXEC_COMMAND
  if test "x$VERBOSE_HERE" = "xyes" ; then
    MSG="------------------------------------------------------"
    output_msg
    MSG=""
    output_msg
  fi
}

verify_line_run()
{
  IGNORE_LINE="no"
  if test -z "$LINE_NUM_SERVERS" ; then
    IGNORE_LINE="yes"
  fi
  COMMENT=`echo $LINE_NUM_SERVERS | grep "#" `
  if test "x$COMMENT" != "x" ; then
    IGNORE_LINE="yes"
  fi
  if test "x$IGNORE_LINE" = "xno" ; then
    opt=$LINE_NUM_SERVERS
    TMP=`echo $LINE_NUM_SERVERS | egrep "^[0-9]+$"`
    validate_parameter $opt $LINE_NUM_SERVERS $TMP "no_exit"
    opt=$LINE_NUM_WARES
    TMP=`echo $LINE_NUM_WARES | egrep "^[0-9]+$"`
    validate_parameter $opt $LINE_NUM_WARES $TMP "no_exit"
    opt=$LINE_TERMINALS
    TMP=`echo $LINE_TERMINALS | egrep "^[0-9]+$"`
    validate_parameter $opt $LINE_TERMINALS $TMP "no_exit"
  fi
}

verify_line()
{
  IGNORE_LINE="no"
  if test -z "$LINE_NODE_ID" ; then
    IGNORE_LINE="yes"
  fi
  COMMENT=`echo $LINE_NODE_ID | grep "#" `
  if test "x$COMMENT" != "x" ; then
    IGNORE_LINE="yes"
  fi
  if test "x$IGNORE_LINE" = "xno" ; then
    opt=$LINE_NODE_ID
    TMP=`echo $LINE_NODE_ID | egrep "^[0-9]+$"`
    validate_parameter $opt $LINE_NODE_ID $TMP "no_exit"
    if test "x$LINE_NODE_TYPE" != "xNDBD" && \
       test "x$LINE_NODE_TYPE" != "xNDB_MGMD" && \
       test "x$LINE_NODE_TYPE" != "xMYSQLD" && \
       test "x$LINE_NODE_TYPE" != "xMYSQLD_SAFE" ; then
      MSG="Only NODE_TYPE = NDBD, NDB_MGMD, MYSQLD and MYSQLD_SAFE are allowed"
      output_msg
      IGNORE_LINE="yes"
    fi
  fi
  if test "x$IGNORE_LINE" = "xno" ; then
    if test "x$LINE_PORT" = "x" ; then
      LINE_PORT="3306"
    else
      opt=$LINE_PORT
      TMP=`echo $LINE_PORT | egrep "^[0-9]+$"`
      validate_parameter $opt $LINE_PORT $TMP "no_exit"
    fi
  fi
}

perform_all_activity()
{
  COMMAND="bash $DIS_BASE_DIR/dbt2.sh"
  COMMAND="$COMMAND --default-directory ${DEFAULT_DIR}"
  COMMAND="$COMMAND --home-base $HOME_BASE"
  if test "x$SSH_PORT" != "x" ; then
    COMMAND="$COMMAND --ssh_port $SSH_PORT"
  fi
  COMMAND="$COMMAND --base_dir $BASE_DIR"
  if test "x$VERBOSE_HERE" = "xyes" ; then
    COMMAND="$COMMAND --verbose"
  fi
  COMMAND="$COMMAND --version $MYSQL_VERSION"
  if test "x$NDB_CLUSTERID" != "x" ; then
    COMMAND="$COMMAND --cluster_id $NDB_CLUSTERID"
  fi

  EXEC_COMMAND="$COMMAND --create_tables"
  EXEC_COMMAND="$EXEC_COMMAND $DBT2_PARTITION_FLAG"
  if test "x$USING_HASH_FLAG" = "x" ; then
    EXEC_COMMAND="$EXEC_COMMAND --dont_use_hash"
  fi
  EXEC_COMMAND="$EXEC_COMMAND --mysql_node_id ${MYSQLD_NODE_ID[0]}"
  EXEC_COMMAND="$EXEC_COMMAND --engine $STORAGE_ENGINE"
  EXEC_COMMAND="$EXEC_COMMAND --data-dir $DBT2_DATA_DIR"
  MSG="$EXEC_COMMAND"
  output_msg
  execute_command

  sleep 5

  EXEC_COMMAND="$COMMAND --create_sp"
  execute_command

  FIRST_WARE="1"
  if test "x$NUM_SERVERS" = "x" ; then
    NUM_SERVERS="$NUM_MYSQLDS"
  fi
  if test "x$NUM_SERVERS" = "x0" ; then
    NUM_SERVERS="1"
  fi
  if [ $NUM_SERVERS -gt $NUM_MYSQLDS ] ; then
    NUM_SERVERS="$NUM_MYSQLDS"
  fi
# Use parallel loaders per MySQL servers to speed up loading
  ((NUM_PARALLEL = NUM_SERVERS * DBT2_LOADERS))
  if [ $NUM_PARALLEL -gt $NUM_WAREHOUSES ] ; then
    NUM_PARALLEL="$NUM_WAREHOUSES"
  fi 
  ((NUM_WARE = NUM_WAREHOUSES / NUM_PARALLEL))
  ((NUM_WARE_REM = NUM_WAREHOUSES % NUM_PARALLEL))
  for ((i = 0; i < $NUM_PARALLEL ; i += 1))
  do
    ((node_id = i % NUM_SERVERS))
    EXEC_COMMAND="$COMMAND --mysql_node_id ${MYSQLD_NODE_ID[node_id]}"
    EXEC_COMMAND="$EXEC_COMMAND --load_data"
    EXEC_COMMAND="$EXEC_COMMAND --data-dir $DBT2_DATA_DIR"
    EXEC_COMMAND="$EXEC_COMMAND --first_warehouse $FIRST_WARE"
    if [ $i -lt $NUM_WARE_REM ] ; then
      ((NUM_WARES_USED = NUM_WARE + 1))
    else
      NUM_WARES_USED="$NUM_WARE"
    fi
    if test "x$NUM_WARES_USED" != "x0" ; then
      EXEC_COMMAND="$EXEC_COMMAND --num_warehouses $NUM_WARES_USED"
      ((FIRST_WARE = FIRST_WARE + NUM_WARES_USED))
      MSG="Parallel start of $EXEC_COMMAND"
      output_msg
      MSG="Log written to "$DBT2_LOG_FILE"_$i.log"
      output_msg
      $EXEC_COMMAND > ""$DBT2_LOG_FILE"_$i.log" &
    fi
  done
  MSG="Wait for all parallel load table activities to complete"
  output_msg
  wait
}

get_run_number()
{
# Determine run number for selecting an output directory
  RUN_NUMBER=0
  if [ -f "${TMP_BASE}/.run_number" ]; then  
    read RUN_NUMBER < ${TMP_BASE}/.run_number
  fi
# Update the run number for the next test.
  NEW_RUN_NUMBER=`expr $RUN_NUMBER + 1`
  echo $NEW_RUN_NUMBER > ${TMP_BASE}/.run_number
}

run_one_test()
{
  ((TMP_NUM_LAPS = LINE_NUM_SERVERS + SPREAD))
  ((TMP_NUM_LAPS -= 1))
  ((TMP_NUM_LAPS /= SPREAD))
  ((TMP_OFFSET = TMP_NUM_LAPS * SPREAD))
  ((TMP_OFFSET -= LINE_NUM_SERVERS))
  ((TOT_WARES = TMP_NUM_LAPS * SPREAD * LINE_NUM_WARES))
  ((TOT_WARES -= TMP_OFFSET))
  if [ $NUM_WAREHOUSES -ge $TOT_WARES ] ; then
    FIRST_WARE="1"
    COMMAND="bash $BASE_DIR/scripts/run_mysql.sh"
    COMMAND="$COMMAND --default-directory $DEFAULT_DIR"
    COMMAND="$COMMAND --log-file $LOG_FILE"
    COMMAND="$COMMAND $DEBUG_INFO"
    if test "x$VERBOSE_HERE" = "xyes" ;then
      COMMAND="$COMMAND --verbose"
    fi
    COMMAND="$COMMAND --zero-delay"
    ((CONNECTIONS = NUM_WAREHOUSES * LINE_TERMINALS))
    COMMAND="$COMMAND --connections $CONNECTIONS"
    COMMAND="$COMMAND --warehouses $NUM_WAREHOUSES"
    COMMAND="$COMMAND --spread $SPREAD"
    COMMAND="$COMMAND --time $RUN_TIME"
    COMMAND="$COMMAND --terminals $LINE_TERMINALS"
    COMMAND="$COMMAND --intermediate_timer_resolution $DBT2_INTERMEDIATE_TIMER_RESOLUTION"
    COMMAND="$COMMAND --lib-client-path $MYSQL_PATH/lib"
    COMMAND="$COMMAND --lib-client-path $MYSQL_PATH/lib/mysql"
    COMMAND="$COMMAND --output-base $OUTPUT_BASE"
    SPREAD_STEP_COUNT="0"
    SPREAD_COUNT="0"
    for ((i = 0; i < $LINE_NUM_SERVERS; i += 1))
    do
      ((LAST_WARE = (LINE_NUM_WARES - 1) * SPREAD))
      ((LAST_WARE += FIRST_WARE))
      ((EXTRA_WARMUP = LINE_NUM_SERVERS - i))
      ((EXTRA_WARMUP += 14))
      EXEC_COMMAND="$COMMAND --host ${MYSQLD_HOSTS[$i]}"
      EXEC_COMMAND="$EXEC_COMMAND --port ${MYSQLD_PORTS[$i]}"
      EXEC_COMMAND="$EXEC_COMMAND --client_port $CLIENT_PORT"
      EXEC_COMMAND="$EXEC_COMMAND --first-warehouse $FIRST_WARE"
      EXEC_COMMAND="$EXEC_COMMAND --last-warehouse $LAST_WARE"
      EXEC_COMMAND="$EXEC_COMMAND --extra-warmup $EXTRA_WARMUP"
      DBT2_RUN_LOG_FILE="$DBT2_RUN_LOG_DIR/line_"$LINE_NO"_server_"${MYSQLD_NODE_ID[$i]}".log"
      get_run_number
      EXEC_COMMAND="$EXEC_COMMAND --run-number $RUN_NUMBER"
      RUN_MYSQL_COMMAND[$i]="$EXEC_COMMAND"
      RUN_MYSQL_LOG[$i]="$DBT2_RUN_LOG_FILE"
      ((CLIENT_PORT = CLIENT_PORT + 1))
      ((SPREAD_COUNT += 1))
      if test "x$SPREAD_COUNT" = "x$SPREAD" ; then
        ((SPREAD_COUNT = 0))
        ((SPREAD_STEP_COUNT += 1))
        ((FIRST_WARE = SPREAD * LINE_NUM_WARES * SPREAD_STEP_COUNT))
      fi
      ((FIRST_WARE += 1))
    done
    MSG="Initialisation of new test started"
    output_msg
    for ((i = 0; i < $LINE_NUM_SERVERS; i += 1))
    do
# Prepare run phase, create all files and start client
      EXEC_COMMAND="${RUN_MYSQL_COMMAND[i]} --pre-run"
      MSG="Execute $EXEC_COMMAND"
      output_msg
      $EXEC_COMMAND > ${RUN_MYSQL_LOG[i]} &
    done
    MSG="Initialisation completed, now starting test"
    output_msg
    wait
    for ((i = 0; i < $LINE_NUM_SERVERS; i += 1))
    do
# Execute test now
      EXEC_COMMAND="${RUN_MYSQL_COMMAND[i]} --only-run"
      MSG="Execute $EXEC_COMMAND"
      output_msg
      $EXEC_COMMAND >> ${RUN_MYSQL_LOG[i]} &
      sleep 1
    done
    MSG="Test is running"
    output_msg
  else
    MSG="Line $LINE_NO tries to run with too many warehouses, ignores line"
    output_msg
  fi
}

run_test_activity()
{
  LINE_NO="1"
  if test "x${DBT2_RESULTS_DIR}" = "x" ; then
    DIR="$HOME/dbt2_results"
  else
    DIR="${DBT2_RESULTS_DIR}"
  fi
  if test ! -d ${DIR} ; then
    mkdir ${DIR}
  fi
  LOOKHOST=${MYSQLD_HOSTS[0]}
  MYSQLD_MACHINES="1"
  for ((i = 1; i < NUM_MYSQLDS; i += 1))
  do
    if test "${MYSQLD_HOSTS[$i]}" = "${LOOKHOST}"; then
      ((MYSQLD_MACHINES = MYSQLD_MACHINES + 1))
    fi
  done 
  let MYSQLD_MACHINES=NUM_MYSQLDS/MYSQLD_MACHINES
  LOOKHOST=${NDBD_HOSTS[0]}
  NDBD_MACHINES="1"
  for ((i = 1; i < NUM_NDBDS; i += 1))
  do
    if test "${NDBD_HOSTS[$i]}" = "${LOOKHOST}"; then
      ((NDBD_MACHINES = NDBD_MACHINES + 1))
    fi
  done 
  let NDBD_MACHINES=NUM_NDBDS/NDBD_MACHINES
  if test "x${DBT2_SCI}" != "x" ; then
    if test "x${LOOKHOST}" != "xlocalhost" && \
       test "x${LOOKHOST}" != "x127.0.0.1" ; then
      SSOCKS=`$SSH root@${LOOKHOST} /opt/DIS/bin/dis_ssocks_stat -G | \
              $GREP STREAM | $NAWK '{print $2}'`
    else
      SSOCKS=`/opt/DIS/bin/dis_ssocks_stat -G | \
              $GREP STREAM | $NAWK '{print $2}'`
    fi
    if test "x${SSOCKS}" = "x"; then
      SSOCKS="0";
    fi 
    USING_TRANSPORT="SSOCKS"
    if test ${SSOCKS} = "0" ; then
      USING_TRANSPORT="GigE"
    fi
  else
    USING_TRANSPORT="GigE"
  fi
  BENCHMARK_SUMMARY_LOGFILE=`mktemp ${DIR}/summary_${MYSQL_VERSION}_NDB${NUM_NDBDS}_NDBN${NDBD_MACHINES}_SQLN${MYSQLD_MACHINES}_${USING_TRANSPORT}.log_XXXXXX`
  echo " " > ${BENCHMARK_SUMMARY_LOGFILE}
  RUN_DATETIME=`date +%Y%m%d%H%M%S`
  echo "Cluster ID : ${NDB_CLUSTERID}" > ${BENCHMARK_SUMMARY_LOGFILE}
  echo "Run test   : ${RUN_TEST}" >> ${BENCHMARK_SUMMARY_LOGFILE}
  echo "Instance   : ${RUN_INSTANCE}" >> ${BENCHMARK_SUMMARY_LOGFILE}
  echo "Time:      : ${RUN_TIME}" >> ${BENCHMARK_SUMMARY_LOGFILE}
  echo "Warehouses : ${NUM_WAREHOUSES}" >> ${BENCHMARK_SUMMARY_LOGFILE}
  echo " " >> ${BENCHMARK_SUMMARY_LOGFILE}
  while read LINE_NUM_SERVERS LINE_NUM_WARES LINE_TERMINALS
  do
    verify_line_run
    if test "x$IGNORE_LINE" = "xyes" ; then
      continue
    fi
    printf "Num MySQLs: %7d NumWares: %5d NumTerms: %5d\n" $LINE_NUM_SERVERS $LINE_NUM_WARES $LINE_TERMINALS >>$BENCHMARK_SUMMARY_LOGFILE

    CLIENT_PORT="$FIRST_CLIENT_PORT"
    MSG="Run test with $LINE_NUM_SERVERS MySQL Servers, $LINE_NUM_WARES warehouses per server and $LINE_TERMINALS terminals"
    output_msg
    if test -f ${TMP_BASE}/.run_number ; then
      read RUN_NUMBER_START < ${TMP_BASE}/.run_number
    else
      RUN_NUMBER_START="0"
      echo ${RUN_NUMBER_START} > ${TMP_BASE}/.run_number
    fi
    KILL_CMD="killall -u $USER -q client "
    $KILL_CMD >/dev/null 2>/dev/null
    run_one_test
    wait
    $KILL_CMD >/dev/null 2>/dev/null
    NOTPM="0" 
    NOROLLBACK="0" 
    RESPONSETIME="0" 
    if test -f ${TMP_BASE}/.run_number ; then
      read RUN_NUMBER_END < ${TMP_BASE}/.run_number
    else
      MSG="${TMP_BASE}/.run_number not found!"
      output_msg
      RUN_NUMBER_END="0"
    fi
    NO_LINES="0"
    for ((i = $RUN_NUMBER_START; i < $RUN_NUMBER_END; i +=1 ))
    do
      ((NO_LINES++))
      RUN_NOTPM="0";
      RUN_ROLLBACK="0";
      RUN_RT="0";
      if test -f "$OUTPUT_BASE/output/$i/driver/statistics.log"; then
        RUN_NOTPM=`cat $OUTPUT_BASE/output/$i/driver/statistics.log | $NAWK '{if (match ($0,"NOTPM"))  print substr($1,1,index($1,".")-1)}'`
        RUN_ROLLBACK=`cat $OUTPUT_BASE/output/$i/driver/statistics.log | $NAWK '{if (match ($0,"rollback transactions"))  print substr($1,1,index($1,".")-1)}'`
        RUN_RT=`cat $OUTPUT_BASE/output/$i/driver/statistics.log | $NAWK '{if (match ($0,"New Order"))  print $4 }'`
        if test "x$RUN_NOTPM" = "x"; then
          RUN_NOTPM="0"
        fi
        if test "x$RUN_ROLLBACK" = "x"; then
          RUN_ROLLBACK="0"
        fi
        if test "x$RUN_RT" = "x"; then
          RUN_RT="0"
        fi
        if test "x$RUN_RT" = "xN/A"; then
          RUN_RT="0"
        fi
      fi
      RUN_RT=`echo "(1000*$RUN_RT)/1"|bc`
      RESPONSETIME=`echo "$RUN_RT + $RESPONSETIME"|bc`
      printf "Line: %5d TPM: %7d Rollbacks: %9d Responsetime: %4d milliseconds\n" $i $RUN_NOTPM $RUN_ROLLBACK $RUN_RT
      printf "%5d %7d %9d %9d\n" $i $RUN_NOTPM $RUN_ROLLBACK $RUN_RT>>$BENCHMARK_SUMMARY_LOGFILE
      ((NOTPM= NOTPM + RUN_NOTPM))
      ((NOROLLBACK= NOROLLBACK + RUN_ROLLBACK))
    done
    ((LINE_NO = LINE_NO + 1))
    if test "x$NO_LINES" != "x0" ; then
      RESPONSETIME=`echo "$RESPONSETIME/$NO_LINES"|bc`
    fi
    printf "Total TPM: %7d Rollbacks: %6d Average Resp Time: %4d milliseconds\n" $NOTPM $NOROLLBACK $RESPONSETIME
    printf "Total TPM: %7d Rollbacks: %9d Average Resp Time: %4d milliseconds\n" $NOTPM $NOROLLBACK $RESPONSETIME>>$BENCHMARK_SUMMARY_LOGFILE
  done < $DBT2_RUN_CONFIG_FILE
  if test "x${DEFAULT_DIR}" != "x" ; then
    cat ${BENCHMARK_SUMMARY_LOGFILE} > ${DEFAULT_DIR}/final_result.txt
  fi
}

DEFAULT_FILE_DBT2=""
DEFAULT_FILE_IC=""
DBT2_DATA_DIR=""
BASE_DIR=""
MYSQL_VERSION=""
DBT2_PARTITION_FLAG=""
DBT2_NUM_PARTITIONS=""
USING_HASH_FLAG="--using-hash"
STORAGE_ENGINE="NDB"
SSH="ssh -n"
MYSQL_PATH=""
HOME_BASE="$HOME"
DIS_CONFIG_FILE=""
ONLY_CREATE_FLAG=""
VERBOSE_HERE=""
FIRST_WAREHOUSE="1"
NUM_WAREHOUSES="1"
PROCESS=""
NUM_MYSQLDS="0"
NDB_CLUSTERID=""
NDB_CLUSTERID_NAME=""
MYSQL_NODE_ID=
MYSQLD_HOSTS=
MYSQLD_PORTS=
NDBD_HOSTS=
FIRST_CLIENT_PORT="30000"
NUM_SERVERS=""
DIS_BASE_DIR=`dirname $0`
OUTPUT_BASE=""
DEBUG_INFO=""
SSH_PORT=""
SPREAD="1"
SPREAD_COUNT="0"
TMP_NUM_LAPS=""
TMP_OFFSET=""
SPREAD_STEP_COUNT="0"
NAWK="nawk"
RUN_NUMBER=
NEW_RUN_NUMBER=
RUN_NUMBER_START=
RUN_NUMBER_END=
EXTRA_WARMUP=""
DEFAULT_DIR="$HOME/.build"
DBT2_LOADERS="8"
DBT2_INTERMEDIATE_TIMER_RESOLUTION="0"

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

  DEFAULT_FILE_IC="${DEFAULT_DIR}/iclaustron.conf"
  if test -f "$DEFAULT_FILE_IC" ; then
    . ${DEFAULT_FILE_IC}
  fi
  DEFAULT_FILE_DBT2="${DEFAULT_DIR}/dbt2.conf"
  if test -f "$DEFAULT_FILE_DBT2" ; then
    . ${DEFAULT_FILE_DBT2}
  fi

  while test $# -gt 0
  do
    case $1 in
    --num-servers | --num_servers | -num-servers | -num_servers )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      NUM_SERVERS="$1"
      ;;
    --first-client-port | --first_client_port | -first-client-port | \
    -first_client_port )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      FIRST_CLIENT_PORT="$1"
      ;;
    --spread )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      SPREAD="$1"
      ;;
    --clusterid | -clusterid | --cluster-id | -cluster-id | \
    --cluster_id | -cluster_id )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      NDB_CLUSTERID="$1"
      ;;
    --debug )
      DEBUG_INFO="--debug"
      ;;
    --home-base | --home_base )
      shift
      HOME_BASE="$1"
      ;;
    --output-base | --output_base )
      shift
      OUTPUT_BASE="$1"
      ;;
    --data_dir | --data-dir )
      shift
      DBT2_DATA_DIR="$1"
      ;;
    --base_dir | --base-dir )
      shift
      BASE_DIR="$1"
      ;;
    --partition )
      shift
      DBT2_PARTITION_FLAG="$1"
      ;;
    --create_tables | --create-tables )
      if test "x$PROCESS" != "x" ; then
        MSG="Activity already defined"
        output_msg
        usage
        exit 1
      fi
      PROCESS="create_tables"
      ;;
    --load_data | --load-data )
      if test "x$PROCESS" != "x" ; then
        MSG="Activity already defined"
        output_msg
        usage
        exit 1
      fi
      PROCESS="load_data"
      ;;
    --create_sp | --create-sp )
      if test "x$PROCESS" != "x" ; then
        MSG="Activity already defined"
        output_msg
        usage
        exit 1
      fi
      PROCESS="create_sp"
      ;;
    --perform-all | --perform_all )
      if test "x$PROCESS" != "x" ; then
        MSG="Activity already defined"
        output_msg
        usage
        exit 1
      fi
      PROCESS="perform_all"
      ;;
    --run-test | --run_test | -run-test | -run_test )
      if test "x$PROCESS" != "x" ; then
        MSG="Activity already defined"
        output_msg
        usage
        exit 1
      fi
      PROCESS="run_test"
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      RUN_TEST="$1"
      ;;
    --verbose )
      VERBOSE_HERE="yes"
      ;;
    --dont_use_hash | --dont-use-hash )
      USING_HASH_FLAG=""
      ;;
    --version )
      shift
      MYSQL_VERSION="$1"
      ;;
    --engine )
      shift
      STORAGE_ENGINE="$1"
      ;;
    --mysql_path | --mysql-path )
      shift
      MYSQL_PATH="$1"
      ;;
    --ssh-port | --ssh_port )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      SSH_PORT="$1"
      ;;
    --mysql_node_id | --mysql-node-id )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      MYSQL_NODE_ID="$1"
      ;;
    --first_warehouse | --first-warehouse )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      FIRST_WAREHOUSE="$1"
      ;;
    --num_warehouses | --num-warehouses )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      NUM_WAREHOUSES="$1"
      ;;
    --instance )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      RUN_INSTANCE="$1"
      ;;
    --time )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      RUN_TIME="$1"
      ;;
    --help )
      usage
      exit 0
      ;;
    *)
      MSG="Unrecognized option: $1"
      output_msg
      usage
      exit 1
      ;;
    esac
    shift
  done

  if test "x$PROCESS" = "x" ; then
    MSG="No activity defined"
    ouput_msg
    usage
    exit 1
  fi
  if test -f "$DEFAULT_FILE_IC" ; then
    MSG="Sourcing iclaustron defaults from $DEFAULT_FILE_IC"
    output_msg
  else
    MSG="No $DEFAULT_FILE_IC found, using standard defaults"
    output_msg
  fi
  if test -f "$DEFAULT_FILE_DBT2" ; then
    MSG="Sourcing DBT2 defaults from $DEFAULT_FILE_DBT2"
    output_msg
  else
    MSG="No $DEFAULT_FILE_DBT2 found, using standard defaults"
    output_msg
  fi

  grep --version 2> /dev/null 1> /dev/null
  if test "x$?" = "x0" ; then
    GREP=grep
  else
    GREP=/usr/gnu/bin/grep
    if ! test -d $GREP ; then
      GREP=ggrep
    fi
    $GREP --version 2> /dev/null 1> /dev/null
    if test "x$?" != "x0" ; then
      MSG="Didn't find a proper grep binary"
      output_msg
      exit 1
    fi
  fi

  which nawk 2> /dev/null 1> /dev/null
  if test "x$?" != "x0" ; then
    NAWK="awk"
  fi

  if test "x${OUTPUT_BASE}" = "x" ; then
    if test "x${DBT2_OUTPUT_DIR}" != "x" ; then
      OUTPUT_BASE="${DBT2_OUTPUT_DIR}"
    else
      OUTPUT_BASE="${HOME}"
    fi
  fi
  if test "x$SSH_PORT" != "x" ; then
    SSH="$SSH -p $SSH_PORT"
  fi
  if test "x$DBT2_DATA_DIR" = "x" ; then
    DBT2_DATA_DIR="$HOME_BASE/dbt2-data"
  fi
  if test "x$BASE_DIR" = "x" ; then
    BASE_DIR="$HOME_BASE/dest_build_dir/dbt2-0.37.48"
  fi
  if test "x$DBT2_PARTITION_FLAG" != "x" ; then
    DBT2_PARTITION_FLAG="--partition $DBT2_PARTITION_FLAG"
  fi
  if test "x$NDB_CLUSTERID" != "x" ; then
    NDB_CLUSTERID_NAME="_c"$NDB_CLUSTERID""
  fi
  if test "x${DBT2_LOG_BASE}" = "x" ; then
    DBT2_LOG_BASE="${HOME_BASE}/dbt2_logs"
  fi
  if test ! -d "${DBT2_LOG_BASE}" ; then
    MSG="Create dbt2 log directory: ${DBT2_LOG_BASE}"
    output_msg
    mkdir "${DBT2_LOG_BASE}"
  fi
  DBT2_LOG_DIR="$DBT2_LOG_BASE/dbt2_logs"$NDB_CLUSTERID_NAME""
  if test ! -d "$DBT2_LOG_DIR" ; then
    MSG="Create dbt2 log directory: $DBT2_LOG_DIR"
    output_msg
    mkdir "$DBT2_LOG_DIR"
  fi
  if test "x$PROCESS" = "xrun_test" ; then
    if test "${DBT2_RUN_CONFIG_FILE}" = "x" ; then
      DBT2_RUN_CONFIG_FILE="$HOME_BASE/.build/dbt2_run_"$RUN_TEST".conf"
    fi
    if test ! -f "$DBT2_RUN_CONFIG_FILE" ; then
      MSG="No run file in $DBT2_RUN_CONFIG_FILE"
      output_msg
      exit 1
    fi
    DBT2_RUN_LOG_DIR="$DBT2_LOG_DIR/run_"$RUN_TEST""
    if test ! -d "$DBT2_RUN_LOG_DIR" ; then
      MSG="Create dbt2 run log directory: $DBT2_RUN_LOG_DIR"
      output_msg
      mkdir "$DBT2_RUN_LOG_DIR"
    fi
    DBT2_RUN_LOG_DIR="$DBT2_RUN_LOG_DIR/instance_"$RUN_INSTANCE""
    if test ! -d "$DBT2_RUN_LOG_DIR" ; then
      MSG="Create dbt2 run log instance directory: $DBT2_RUN_LOG_DIR"
      output_msg
      mkdir "$DBT2_RUN_LOG_DIR"
    fi
  fi
  if test "x$DIS_CONFIG_FILE" = "x" ; then
    DIS_CONFIG_FILE="$HOME_BASE/.build/dis_config"$NDB_CLUSTERID_NAME".ini"
  fi
  if test "x$VERBOSE_HERE" = "xyes" ; then
    MSG="Using DIS_CONFIG_FILE = $DIS_CONFIG_FILE"
    output_msg
  fi
  DBT2_LOG_FILE="$DBT2_LOG_DIR/load_data"
  if test "x$MYSQL_VERSION" = "x" ; then
    MSG="MYSQL_VERSION is mandatory to set"
    output_msg
    exit 1
  fi
  if test "x$MYSQL_PATH" = "x" ; then
    MYSQL_PATH="$HOME_BASE/mysql/$MYSQL_VERSION"
  fi
  if test "x$PROCESS" = "xcreate_sp" ; then
    COMMAND="bash $BASE_DIR/scripts/mysql/mysql_load_sp.sh"
  else
    COMMAND="bash $BASE_DIR/scripts/mysql/mysql_load_db.sh"
  fi
  if test "x$LD_LIBRARY_PATH" = "x" ; then
    LD_LIBRARY_PATH="$MYSQL_PATH/lib/mysql"
  else
    LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$MYSQL_PATH/lib/mysql"
  fi
  LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$MYSQL_PATH/lib"
  export LD_LIBRARY_PATH
  while read LINE_NODE_ID LINE_NODE_TYPE LINE_HOST_NAME LINE_PORT LINE_FLAGS
  do
    verify_line
    if test "x$IGNORE_LINE" = "xyes" ; then
      continue
    fi
    if test "x$LINE_NODE_TYPE" = "xNDBD" ; then
      NDBD_HOSTS[$NUM_NDBDS]="$LINE_HOST_NAME"
      ((NUM_NDBDS = NUM_NDBDS + 1))
    fi
    if test "x$LINE_NODE_TYPE" = "xMYSQLD" || \
       test "x$LINE_NODE_TYPE" = "xMYSQLD_SAFE" ; then
      MYSQLD_NODE_ID[$NUM_MYSQLDS]="$LINE_NODE_ID"
      MYSQLD_HOSTS[$NUM_MYSQLDS]="$LINE_HOST_NAME"
      MYSQLD_PORTS[$NUM_MYSQLDS]="$LINE_PORT"
      ((NUM_MYSQLDS = NUM_MYSQLDS + 1))
      EXEC_COMMAND="$COMMAND --host $LINE_HOST_NAME"
      EXEC_COMMAND="$EXEC_COMMAND --port $LINE_PORT"
      if test "x$PROCESS" = "xcreate_sp" ; then
        EXEC_COMMAND="$EXEC_COMMAND --client-path $MYSQL_PATH/bin"
        EXEC_COMMAND="$EXEC_COMMAND --sp-path $BASE_DIR/storedproc/mysql"
        if test "x$MYSQL_NODE_ID" = "x" || \
           test "x$LINE_NODE_ID" = "x$MYSQL_NODE_ID" ; then
          execute_command
        fi
      fi
      EXEC_COMMAND="$EXEC_COMMAND --mysql-path $MYSQL_PATH/bin/mysql"
      if test "x$PROCESS" = "xcreate_tables" ; then
        if test "x$USE_MYISAM_FOR_ITEM" = "xyes" ; then
          EXEC_COMMAND="$EXEC_COMMAND --item-use-myisam"
          if test "x$LINE_NODE_ID" != "x$MYSQL_NODE_ID" ; then
            EXEC_COMMAND="$EXEC_COMMAND --only-item"
          fi
          CALL_MYSQL_LOAD_DB="yes"
        else
          if test "x$LINE_NODE_ID" = "x$MYSQL_NODE_ID" ; then
            CALL_MYSQL_LOAD_DB="yes"
          else
            CALL_MYSQL_LOAD_DB="no"
          fi
        fi
        if test "x$CALL_MYSQL_LOAD_DB" = "xyes" ; then
          EXEC_COMMAND="$EXEC_COMMAND --path $DBT2_DATA_DIR/dbt2-w1"
          EXEC_COMMAND="$EXEC_COMMAND $DBT2_PARTITION_FLAG"
          if test "x$DBT2_NUM_PARTITIONS" != "x" ; then
            EXEC_COMMAND="$EXEC_COMMAND --num-partitions $DBT2_NUM_PARTITIONS"
          fi
          EXEC_COMMAND="$EXEC_COMMAND $USING_HASH_FLAG"
          EXEC_COMMAND="$EXEC_COMMAND --engine $STORAGE_ENGINE"
          EXEC_COMMAND="$EXEC_COMMAND --only-create"
          if test "x${LINE_HOST_NAME}" != "xlocalhost" && \
             test "x${LINE_HOST_NAME}" != "x127.0.0.1" ; then
            EXEC_COMMAND="$SSH $LINE_HOST_NAME $EXEC_COMMAND"
          fi
          execute_command
        fi
      fi
      if test "x$LINE_NODE_ID" = "x$MYSQL_NODE_ID" ; then
        if test "x$PROCESS" = "xload_data" ; then
          EXEC_COMMAND="$EXEC_COMMAND --parallel-load"
          SAVE_COMMAND="$EXEC_COMMAND --engine $STORAGE_ENGINE"
          for ((i = $FIRST_WAREHOUSE; i < $FIRST_WAREHOUSE + $NUM_WAREHOUSES; i += 1))
          do
            if test "x${LINE_HOST_NAME}" != "xlocalhost" && \
               test "x${LINE_HOST_NAME}" != "x127.0.0.1" ; then
              EXEC_COMMAND="$SSH $LINE_HOST_NAME $SAVE_COMMAND"
            else
              EXEC_COMMAND="$SAVE_COMMAND"
            fi
            EXEC_COMMAND="$EXEC_COMMAND --path $DBT2_DATA_DIR/dbt2-w$i"
            execute_command
          done
        fi
      fi
    fi
  done < $DIS_CONFIG_FILE
  if test "x$PROCESS" = "xperform_all" && \
     test "x$NUM_MYSQLDS" != "x0" ; then
    perform_all_activity
  fi
  if test "x$PROCESS" = "xrun_test" && \
     test "x$NUM_MYSQLDS" != "x0" ; then
    run_test_activity
  fi
  exit 0
