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

#Ensure all messages are sent both to the log file and to the terminal
msg_to_log()
{
  if test "x$LOG_FILE" != "x" ; then
    ${ECHO} "$MSG" >> ${LOG_FILE}
    if test "x$?" != "x0" ; then
      ${ECHO} "Failure $? unable to write $* to ${LOG_FILE}"
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

set_ld_library_path()
{
  if test "x$USE_DRIZZLE" = "xyes" ; then
    ADD_LIB_PATH="${LIBDRIZZLE_PATH}/lib"
    SERVER_TYPE="Drizzle"
    SERVER_TYPE_NAME="drizzled"
  else
    ADD_LIB_PATH="${MYSQL_PATH}/lib/mysql:${MYSQL_PATH}/lib"
  fi
  if test "x$LD_LIBRARY_PATH" = "x" ; then
    LD_LIBRARY_PATH="$ADD_LIB_PATH"
  else
    LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$ADD_LIB_PATH"
  fi
  export LD_LIBRARY_PATH
}

stop_mysql()
{
  MSG="Stop ${SERVER_TYPE} Server"
  output_msg
  COMMAND="${DBT2_PATH}/scripts/mgm_cluster.sh"
  COMMAND="${COMMAND} --default-directory ${DEFAULT_DIR}"
  COMMAND="${COMMAND} --stop --${SERVER_TYPE_NAME}"
  COMMAND="${COMMAND} --cluster_id 1"
  COMMAND="${COMMAND} --conf-file ${DEFAULT_CLUSTER_CONFIG_FILE}"
  COMMAND="${COMMAND} ${VERBOSE_FLAG}"
  MSG="Executing ${COMMAND}"
  output_msg
  ${COMMAND}
  if test "x$?" != "x0" ; then
    MSG="Failed to stop ${SERVER_TYPE} Server"
    output_msg
  else
    ${SLEEP} ${AFTER_SERVER_STOP}
    MSG="Stopped ${SERVER_TYPE} Server"
    output_msg
  fi
}

start_mysql()
{
  MSG="Start ${SERVER_TYPE} Server"
  output_msg
  COMMAND="${DBT2_PATH}/scripts/mgm_cluster.sh"
  COMMAND="${COMMAND} --default-directory ${DEFAULT_DIR}"
  COMMAND="${COMMAND} --start --initial"
  COMMAND="${COMMAND} --${SERVER_TYPE_NAME} --cluster_id 1"
  COMMAND="${COMMAND} --conf-file ${DEFAULT_CLUSTER_CONFIG_FILE}"
  COMMAND="${COMMAND} ${VERBOSE_FLAG}"
  MSG="Executing ${COMMAND}"
  output_msg
  ${COMMAND}
  if test "x$?" != "x0" ; then
    MSG="Failed to start ${SERVER_TYPE}"
    output_msg
    exit 1
  fi
  ${SLEEP} ${AFTER_SERVER_START}
}

exit_func()
{
  stop_mysql
  exit 1
}

edit_pfs_synch()
{
  if test "x${USE_DRIZZLE}" != "xyes" ; then
    BASE_COMMAND="${MYSQL_PATH}/bin/mysql -h ${SERVER_HOST}"
    BASE_COMMAND="$BASE_COMMAND --port=${SERVER_PORT}"
    BASE_COMMAND="$BASE_COMMAND --protocol=tcp"
    BASE_COMMAND="$BASE_COMMAND --user=root"
    PFS_SYNCH_CMD="$BASE_COMMAND < ${DBT2_PATH}/scripts/PFS_synch.sql"
    if test "x${VERBOSE_FLAG}" != "x" ; then
      MSG="Executing ${PFS_SYNCH_CMD}"
      output_msg
    fi
    eval ${PFS_SYNCH_CMD}
    if test "x$?" = "x0" ; then
      MSG="Successfully changed to only tracking mutexes in PFS"
      output_msg
    fi
  fi
}

create_test_user()
{
  if test "x${USE_DRIZZLE}" != "xyes" ; then
    BASE_COMMAND="${MYSQL_PATH}/bin/mysql -h ${SERVER_HOST}"
    BASE_COMMAND="$BASE_COMMAND --port=${SERVER_PORT}"
    BASE_COMMAND="$BASE_COMMAND --protocol=tcp"
    BASE_COMMAND="$BASE_COMMAND --user=root"
    CREATE_TEST_USER_CMD="$BASE_COMMAND < ${DBT2_PATH}/scripts/create_user.sql"
    if test "x${VERBOSE_FLAG}" != "x" ; then
      MSG="Executing ${CREATE_TEST_USER_CMD}"
      output_msg
    fi
    eval ${CREATE_TEST_USER_CMD}
    if test "x$?" = "x0" ; then
      MSG="Successfully create test user dim identified by dimitri"
      output_msg
    fi
  fi
}

create_test_database()
{
  if test "x${USE_DRIZZLE}" = "xyes" ; then
    COMMAND="${DRIZZLE_PATH}/bin/drizzle -h ${SERVER_HOST} --port=${SERVER_PORT}"
    COMMAND="${COMMAND} -e 'drop database ${SYSBENCH_DB}'"
    DROP_DB_COMMAND="${COMMAND}"
    COMMAND="${DRIZZLE_PATH}/bin/drizzle -h ${SERVER_HOST} --port=${SERVER_PORT}"
    COMMAND="${COMMAND} -e 'create database ${SYSBENCH_DB}'"
    CREATE_DB_COMMAND="${COMMAND}"
  else
    BASE_COMMAND="${MYSQL_PATH}/bin/mysql -h ${SERVER_HOST}"
    BASE_COMMAND="$BASE_COMMAND --port=${SERVER_PORT}"
    BASE_COMMAND="$BASE_COMMAND --user=root"
    CREATE_DB_COMMAND="${BASE_COMMAND} --protocol=tcp -e 'create database ${SYSBENCH_DB}'"
    DROP_DB_COMMAND="${BASE_COMMAND} --protocol=tcp -e 'drop database ${SYSBENCH_DB}'"
  fi
  for ((i = 0; i < NUM_CREATE_DB_ATTEMPTS ; i+=1 ))
  do
    MSG="Checking if MySQL Server is started by drop+create of test db"
    output_msg
    if test "x${VERBOSE_FLAG}" != "x" ; then
      MSG="Executing ${DROP_DB_COMMAND}"
      output_msg
    fi
    eval ${DROP_DB_COMMAND}
    if test "x${VERBOSE_FLAG}" != "x" ; then
      MSG="Executing ${CREATE_DB_COMMAND}"
      output_msg
    fi
    eval ${CREATE_DB_COMMAND}
    if test "x$?" = "x0" ; then
      MSG="Successfully started ${SERVER_TYPE} Server, test db created"
      output_msg
      return 0
    fi
    ${SLEEP} ${BETWEEN_CREATE_DB_TEST}
  done
  MSG="Failed to create test database"
  output_msg
  exit_func
}

run_oltp_complex()
{
  SYSBENCH_COMMON="--num-threads=$THREADS"
  SYSBENCH_COMMON="$SYSBENCH_COMMON --max-time=${MAX_TIME}"
  SYSBENCH_COMMON="$SYSBENCH_COMMON --test=oltp"
  SYSBENCH_COMMON="$SYSBENCH_COMMON --max-requests=0"
  SYSBENCH_COMMON="$SYSBENCH_COMMON --intermediate-result-timer=3"
  if test "x${USE_DRIZZLE}" = "xyes" ; then
    SYSBENCH_COMMON="$SYSBENCH_COMMON --db-ps-mode=disable"
    SYSBENCH_COMMON="$SYSBENCH_COMMON --drizzle-user=root"
    SYSBENCH_COMMON="$SYSBENCH_COMMON --drizzle-db=${SYSBENCH_DB}"
    SYSBENCH_COMMON="$SYSBENCH_COMMON --drizzle-host=${SERVER_HOST}"
    SYSBENCH_COMMON="$SYSBENCH_COMMON --drizzle-port=${SERVER_PORT}"
    SYSBENCH_COMMON="$SYSBENCH_COMMON --drizzle-table-engine=${ENGINE}"
    SYSBENCH_COMMON="$SYSBENCH_COMMON --drizzle-engine-trx=yes"
  else
    SYSBENCH_COMMON="$SYSBENCH_COMMON --mysql-user=root"
    SYSBENCH_COMMON="$SYSBENCH_COMMON --mysql-db=${SYSBENCH_DB}"
    SYSBENCH_COMMON="$SYSBENCH_COMMON --mysql-host=${SERVER_HOST}"
    SYSBENCH_COMMON="$SYSBENCH_COMMON --mysql-port=${SERVER_PORT}"
    SYSBENCH_COMMON="$SYSBENCH_COMMON --mysql-table-engine=${ENGINE}"
    SYSBENCH_COMMON="$SYSBENCH_COMMON --mysql-engine-trx=${TRX_ENGINE}"
    if test "x${SERVER_HOST}" = "xlocalhost" || \
       test "x${SERVER_HOST}" = "x127.0.0.1" ; then
      SYSBENCH_COMMON="$SYSBENCH_COMMON --mysql-socket=${MYSQL_SOCKET}"
    fi
  fi
  SYSBENCH_COMMON="$SYSBENCH_COMMON --oltp-test-mode=complex"
  SYSBENCH_COMMON="$SYSBENCH_COMMON --oltp-dist-type=${SB_DIST_TYPE}"
  SYSBENCH_COMMON="$SYSBENCH_COMMON --oltp-table-size=${SYSBENCH_ROWS}"
  SYSBENCH_COMMON="$SYSBENCH_COMMON --oltp-auto-inc=${SB_USE_AUTO_INC}"

  SYSBENCH_COMMAND="${BENCH_TASKSET} ${SYSBENCH}"
  SYSBENCH_COMMAND="${SYSBENCH_COMMAND} ${SYSBENCH_COMMON}"
  if test "x$TEST" = "xoltp_complex_rw" ; then
    SYSBENCH_COMMAND="${SYSBENCH_COMMAND} --oltp-read-only=off"
  elif test "x${TEST}" = "xoltp_complex_rw_write_intensive" ; then
    SYSBENCH_COMMAND="${SYSBENCH_COMMAND} --oltp-read-only=off"
    SYSBENCH_COMMAND="${SYSBENCH_COMMAND} --oltp-index-updates=10"
  elif test "x${TEST}" = "xoltp_complex_ro" ; then
    if test "x$SB_USE_TRX" = "xyes" ; then
      SYSBENCH_COMMON="$SYSBENCH_COMMON --oltp-skip-trx=off"
    else
      SYSBENCH_COMMON="$SYSBENCH_COMMON --oltp-skip-trx=on"
    fi
    SYSBENCH_COMMAND="${SYSBENCH_COMMAND} --oltp-read-only=on"
  elif test "x${TEST}" = "xoltp_complex_rw_less_read" ; then
    SYSBENCH_COMMAND="${SYSBENCH_COMMAND} --oltp-read-only=off"
    SYSBENCH_COMMAND="${SYSBENCH_COMMAND} --oltp-point-selects=1"
    SYSBENCH_COMMAND="${SYSBENCH_COMMAND} --oltp-range-size=5"
  elif test "x${TEST}" = "xoltp_complex_write" ; then
    SYSBENCH_COMMAND="${SYSBENCH_COMMAND} --oltp-point-selects=0"
    SYSBENCH_COMMAND="${SYSBENCH_COMMAND} --oltp-simple-ranges=0"
    SYSBENCH_COMMAND="${SYSBENCH_COMMAND} --oltp-sum-ranges=0"
    SYSBENCH_COMMAND="${SYSBENCH_COMMAND} --oltp-order-ranges=0"
    SYSBENCH_COMMAND="${SYSBENCH_COMMAND} --oltp-distinct-ranges=0"
  else
    MSG="No test ${TEST}"
    output_msg
    exit_func
  fi
  if test "x${SB_USE_MYSQL_HANDLER}" = "xyes" ; then
    SYSBENCH_COMMAND="${SYSBENCH_COMMAND} --oltp-point-select-mysql-handler"
  fi
  if test "x${SB_USE_SECONDARY_INDEX}" = "xyes" ; then
    SYSBENCH_COMMAND="${SYSBENCH_COMMAND} --oltp-secondary"
  fi
  if test "x${SB_TX_RATE}" != "x" ; then
    SYSBENCH_COMMAND="${SYSBENCH_COMMAND} --tx-rate=${SB_TX_RATE}"
    if test "x${SB_TX_JITTER}" != "x" ; then
      SYSBENCH_COMMAND="${SYSBENCH_COMMAND} --tx-jitter=${SB_TX_JITTER}"
    fi
  fi
  if test "x${SB_NUM_PARTITIONS}" != "x0" ; then
    SYSBENCH_COMMAND="${SYSBENCH_COMMAND} --oltp-num-partitions=${SB_NUM_PARTITIONS}"
  fi
  if test "x${SB_NUM_TABLES}" != "x1" ; then
    SYSBENCH_COMMAND="${SYSBENCH_COMMAND} --oltp-num-tables=${SB_NUM_TABLES}"
  fi
  if test "x${SB_AVOID_DEADLOCKS}" = "xyes" ; then
    SYSBENCH_COMMAND="${SYSBENCH_COMMAND} --oltp-avoid-deadlocks=on"
  fi
  set_ld_library_path
  if test "x$USE_MALLOC_LIB" = "xyes" ; then
    MALLOC_FILE=`basename "${MALLOC_LIB}"`
    MALLOC_PATH=`dirname "${MALLOC_LIB}"`
    PRELOAD_COMMAND="export LD_PRELOAD=${MALLOC_FILE}"
    SET_LD_LIB_PATH_CMD="export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MALLOC_PATH}"
    PRELOAD_COMMAND="${SET_LD_LIB_PATH_CMD} ; ${PRELOAD_COMMAND} ;"
    SYSBENCH_COMMAND="${PRELOAD_COMMAND} ${SYSBENCH_COMMAND}"
  fi
  if test "x${MYSQL_CREATE_OPTIONS}" != "x" ; then
    if test "x${VERBOSE}" = "xyes" ; then 
       MSG="using mysql-create-option for create table ${MYSQL_CREATE_OPTIONS}"
       output_msg
    fi
    SYSBENCH_COMMAND="${SYSBENCH_COMMAND} --mysql-create-options=\"${MYSQL_CREATE_OPTIONS}\""
  fi

  SYSBENCH_COMMAND="${SYSBENCH_COMMAND} ${COMMAND} >> ${TEST_FILE}"

  MSG="Executing ${SYSBENCH_COMMAND}"
  output_msg
  eval ${SYSBENCH_COMMAND}
  if test "x$?" != "x0" ; then
    MSG="Failed sysbench ${TEST} test"
    output_msg
    exit_func
  fi
}

run_set_oltp()
{
  TEST_FILE="${RESULT_DIR}/${TEST}_${TEST_NO}.res"
  ${ECHO} "Starting $TEST test" > ${TEST_FILE}
  for i in ${THREAD_RUNS}
  do
    THREADS="$i"
    ${ECHO} "Running $TEST using $THREADS threads" >> ${TEST_FILE}
    COMMAND="prepare"
    run_oltp_complex
    ${SLEEP} ${BETWEEN_RUNS} 
    COMMAND="run"
    run_oltp_complex
    COMMAND="cleanup"
    run_oltp_complex
  done
}

initial_test()
{
  MSG="Run initial test that gives consistently low results"
  output_msg
  TEST="oltp_complex_rw"
  TEST_NO="1"
  TEST_FILE="${RESULT_DIR}/init_${TEST}_${TEST_NO}.res"
  THREADS="16"
  COMMAND="prepare"
  SAVE_MAX_TIME="$MAX_TIME"
  MAX_TIME="60"
  run_oltp_complex
  ${SLEEP} ${BETWEEN_RUNS} 
  COMMAND="run"
  run_oltp_complex
  COMMAND="cleanup"
  run_oltp_complex
  MAX_TIME="$SAVE_MAX_TIME"
  ${SLEEP} ${AFTER_INITIAL_RUN}
}

run_tests()
{
  for ((TEST_NO = 1 ; TEST_NO <= NUM_TEST_RUNS ; TEST_NO+=1 ))
  do
    if test "x${RUN_RW}" = "xyes" ; then
      MSG="Run Sysbench OLTP RW"
      output_msg
      TEST="oltp_complex_rw"
      run_set_oltp
    fi
    if test "x${RUN_RW_WRITE_INT}" = "xyes" ; then
      MSG="Run Sysbench OLTP RW Write Intensive"
      output_msg
      TEST="oltp_complex_rw_write_intensive"
      run_set_oltp
    fi
    if test "x${RUN_RO}" = "xyes" ; then
      MSG="Run Sysbench OLTP RO"
      output_msg
      TEST="oltp_complex_ro"
      run_set_oltp
    fi
    if test "x${RUN_RW_LESS_READ}" = "xyes" ; then
      MSG="Run Sysbench OLTP RW Less Read"
      output_msg
      TEST="oltp_complex_rw_less_read"
      run_set_oltp
    fi
    if test "x${RUN_WRITE}" = "xyes" ; then
      MSG="Run Sysbench OLTP Write"
      output_msg
      TEST="oltp_complex_write"
      run_set_oltp
    fi
  done
}

create_intermediate_result_files()
{
  for ((i = 1; i <= NUM_TEST_RUNS; i+= 1 ))
  do
    while read NUM_THREADS
    do
      TEST_FILE_NAME="${RESULT_DIR}/${TEST_NAME}_${i}.res"
      CAT_COMMAND="${CAT} ${TEST_FILE_NAME}"
      ${CAT_COMMAND} | grep "Intermediate results: ${NUM_THREADS} threads" | \
        ${NAWK} 'BEGIN{SEC=0}{SEC=SEC+3;printf "%d %d\n", SEC, $5}' > \
          ${RESULT_DIR}/${TEST_NAME}_intermediate_${i}_${NUM_THREADS}.res
    done < ${THREAD_FILE_NAME}
  done
}

handle_jpeg_run()
{
  PLOT_CMD_FILE="${RESULT_DIR}/tmp_gnuplot.input"
  INTERMED_JPEG_FILE="${RESULT_DIR}/${TEST_NAME}_gnuplot_${i}.jpg"
  FIRST_LOOP="1"
  ${ECHO} "set terminal jpeg large size 1024,768 \\" > $PLOT_CMD_FILE
  ${ECHO} "  xffffff x000000 x404040 \\" >> $PLOT_CMD_FILE
  ${ECHO} "  xff0000 x000000 x0000ff x00ff00 \\" >> $PLOT_CMD_FILE
  ${ECHO} "  x800080 x40aa00 x9500d3 xbbbb44" >> $PLOT_CMD_FILE
  ${ECHO} "set title \"${TEST_DESCRIPTION} test case ${TEST_NAME} test run ${i}\"" >> $PLOT_CMD_FILE
  ${ECHO} "set grid xtics ytics" >> $PLOT_CMD_FILE
  ${ECHO} "set xlabel \"Seconds\"" >> $PLOT_CMD_FILE
  ${ECHO} "set ylabel \"TPS\"" >> $PLOT_CMD_FILE
  ${ECHO} "set yrange [0:]" >> $PLOT_CMD_FILE
  ${ECHO} "set output \"${INTERMED_JPEG_FILE}\"" >> $PLOT_CMD_FILE
  ${ECHO} "plot \\" >> $PLOT_CMD_FILE
  while read NUM_THREADS
  do
    if test "x${FIRST_LOOP}" = "x0" ; then
      ${ECHO} ", \\" >> $PLOT_CMD_FILE
    fi
    INTERMED_FILE="${RESULT_DIR}/${TEST_NAME}_intermediate_${i}_${NUM_THREADS}.res"
    ${ECHO} "\"${INTERMED_FILE}\" using 1:2 title \\" >> $PLOT_CMD_FILE
    ${ECHO} "\"${NUM_THREADS} threads\" with linespoints \\" >> $PLOT_CMD_FILE
    FIRST_LOOP="0"
  done < ${THREAD_FILE_NAME}
  ${ECHO} "" >> $PLOT_CMD_FILE
  COMMAND="gnuplot $PLOT_CMD_FILE"
  $COMMAND
  #${RM} ${PLOT_CMD_FILE}
}

create_gnuplot_jpeg()
{
  CHECK_GNUPLOT=`which gnuplot`
  if test "x$CHECK_GNUPLOT" != "x" ; then
    for ((i = 1; i <= NUM_TEST_RUNS; i+= 1 ))
    do
      handle_jpeg_run
    done
  fi
}

analyze_results()
{
  ${ECHO} "Final results for this test run" > ${FINAL_RESULT_FILE}
  TESTS_TO_ANALYZE=""
  if test "x${RUN_RW}" = "xyes" ; then
    TESTS_TO_ANALYZE="${TESTS_TO_ANALYZE} oltp_complex_rw"
  fi
  if test "x${RUN_RW_WRITE_INT}" = "xyes" ; then
    TESTS_TO_ANALYZE="${TESTS_TO_ANALYZE} oltp_complex_rw_write_intensive"
  fi
  if test "x${RUN_RO}" = "xyes" ; then
    TESTS_TO_ANALYZE="${TESTS_TO_ANALYZE} oltp_complex_ro"
  fi
  if test "x${RUN_RW_LESS_READ}" = "xyes" ; then
    TESTS_TO_ANALYZE="${TESTS_TO_ANALYZE} oltp_complex_rw_less_read"
  fi
  if test "x${RUN_WRITE}" = "xyes" ; then
    TESTS_TO_ANALYZE="${TESTS_TO_ANALYZE} oltp_complex_write"
  fi
  ${ECHO} "Result file of sysbench runs" >> ${FINAL_RESULT_FILE}
  for TEST_NAME in ${TESTS_TO_ANALYZE}
  do
    MSG="Analyze test case ${TEST_NAME}"
    output_msg
    TEST_FILE_NAME="${RESULT_DIR}/${TEST_NAME}_1.res"
    ${CAT} ${TEST_FILE_NAME} | ${GREP} 'Number of threads:' | \
      ${NAWK} '{print $4}' > ${THREAD_FILE_NAME}
    for ((i = 1; i <= NUM_TEST_RUNS; i+= 1 ))
    do
      TEST_FILE_NAME="${RESULT_DIR}/${TEST_NAME}_${i}.res"
      RESULT_FILE_NAME="${RESULT_NAME}_${i}.txt"
      ${CAT} ${TEST_FILE_NAME} | ${GREP} 'transactions:' | ${SED} 's/ (/ /' | \
        ${NAWK} '{print $3}' | sed 's/\..*//' >> ${RESULT_FILE_NAME}
    done
    create_intermediate_result_files
    create_gnuplot_jpeg
#Prepare num_threads array
    ((j=0))
    while read NUM_THREADS
    do
      let NUM_THREADS_ARRAY[${j}]="${NUM_THREADS}"
      ((j+=1))
    done < ${THREAD_FILE_NAME}
    NUM_THREAD_RUNS_PER_TEST=${j}
    for ((i = 1; i <= NUM_TEST_RUNS; i+= 1 ))
    do
      RESULT_FILE_NAME="${RESULT_NAME}_${i}.txt"
      ((j=0))
      while read RESULT
      do
        ((index=i*NUM_THREAD_RUNS_PER_TEST+j))
        let RESULT_ARRAY[${index}]="${RESULT}"
        ((j+=1))
      done < ${RESULT_FILE_NAME}
    done
#
# Calculate the mean value and standard deviation per thread count
#
    for ((j = 0; j < NUM_THREAD_RUNS_PER_TEST ; j+= 1 ))
    do
      let TOTAL_TRANS="0"
      for ((i = 1; i <= NUM_TEST_RUNS ; i+= 1 ))
      do
        ((index=i*NUM_THREAD_RUNS_PER_TEST+j))
        ((TOTAL_TRANS+=RESULT_ARRAY[index]))
      done
      ((MEAN_TRANS[j]=TOTAL_TRANS/NUM_TEST_RUNS))
      ((TOTAL_SQUARE_TRANS = 0))
      for ((i = 1; i <= NUM_TEST_RUNS ; i+= 1 ))
      do
        ((index=i*NUM_THREAD_RUNS_PER_TEST+j))
        ((DIFF=RESULT_ARRAY[index] - MEAN_TRANS[j]))
        ((TOTAL_SQUARE_TRANS+=DIFF*DIFF))
      done
      ((TOTAL_SQUARE_TRANS_MEAN=TOTAL_SQUARE_TRANS/NUM_TEST_RUNS))
      STD=$(${ECHO} "sqrt(${TOTAL_SQUARE_TRANS_MEAN})" | ${BC} -l)
      STD_DEV[j]=`${ECHO} ${STD} | sed 's/\..*//'`
    done
    ${ECHO} "Results for ${TEST_NAME}" >> $FINAL_RESULT_FILE
    for ((j = 0; j < NUM_THREAD_RUNS_PER_TEST ; j+= 1 ))
    do
      ((NUM_THREADS=NUM_THREADS_ARRAY[j]))
      RESULT_LINE="Threads: $NUM_THREADS Results:"
      for ((i = 1; i <= NUM_TEST_RUNS ; i+= 1 ))
      do
        ((index=i*NUM_THREAD_RUNS_PER_TEST+j))
        ((RESULT = RESULT_ARRAY[index]))
        RESULT_LINE="$RESULT_LINE $RESULT"
      done
      ${ECHO} "$RESULT_LINE" >> $FINAL_RESULT_FILE
    done
    ${ECHO} "Mean value and standard deviation of results" >> $FINAL_RESULT_FILE
    for ((j = 0; j < NUM_THREAD_RUNS_PER_TEST ; j+= 1 ))
    do
      ((NUM_THREADS=NUM_THREADS_ARRAY[j]))
      ((MEAN=MEAN_TRANS[j]))
      ((STD=STD_DEV[j]))
      RESULT_LINE="Threads: $NUM_THREADS Mean: $MEAN StdDev: $STD"
      ${ECHO} "${RESULT_LINE}" >> $FINAL_RESULT_FILE
    done
    ${RM} ${THREAD_FILE_NAME}
    for ((j = 1; j <= NUM_TEST_RUNS ; j+= 1 ))
    do
      RESULT_FILE_NAME="${RESULT_NAME}_${j}.txt"
      ${RM} ${RESULT_FILE_NAME}
    done
  done
}

load_dbt2_database()
{
FILL_CMD="${DBT2_PATH}/scripts/dbt2.sh"
FILL_CMD="${FILL_CMD} --default-directory ${DEFAULT_DIR}"
FILL_CMD="${FILL_CMD} --cluster_id 1"
FILL_CMD="${FILL_CMD} --perform-all --partition HASH"
FILL_CMD="${FILL_CMD} --num-warehouses ${DBT2_WAREHOUSES}"
FILL_CMD="${FILL_CMD} --num-servers ${NUM_MYSQL_SERVERS}"
if test "x${VERBOSE_FLAG}" != "x" ; then
  FILL_CMD="${FILL_CMD} --verbose"
fi
MSG="${FILL_CMD}"
output_msg
eval ${FILL_CMD}
}

run_dbt2()
{
RUN_CMD="${DBT2_PATH}/scripts/dbt2.sh"
RUN_CMD="${RUN_CMD} --default-directory ${DEFAULT_DIR}"
RUN_CMD="${RUN_CMD} --run-test 1"
RUN_CMD="${RUN_CMD} --instance 1"
RUN_CMD="${RUN_CMD} --time ${DBT2_TIME}"
RUN_CMD="${RUN_CMD} --num-warehouses ${DBT2_WAREHOUSES}"
RUN_CMD="${RUN_CMD} --cluster_id 1"
if test "x$DBT2_SPREAD" != "x" ; then
  RUN_CMD="${RUN_CMD} ${DBT2_SPREAD}"
fi
if test "x${VERBOSE_FLAG}" != "x" ; then
  RUN_CMD="${RUN_CMD} --verbose"
fi
MSG="${RUN_CMD}"
output_msg
eval ${RUN_CMD}
}

set_pipe_command()
{
  FILE_PIPE="> $FA_FILE_NAME 2>&1"
  COMMAND="$COMMAND $FILE_PIPE"
}

set_file_name()
{
  FA_FILE_NAME="${DEFAULT_DIR}/flex_logs/flex_asynch_out_t${TABLE_NUM}_${TABLE_OP}.txt"
}

exec_command()
{
  MSG="Execute command: $COMMAND on host $LOCAL_API_HOST"
  output_msg
  eval $COMMAND
}

set_ssh_cmd()
{
  NDB_EXPORT_CMD="NDB_CONNECTSTRING=$NDB_CONNECTSTRING;"
  NDB_EXPORT_CMD="$NDB_EXPORT_CMD export NDB_CONNECTSTRING;"
  NDB_EXPORT_CMD="$NDB_EXPORT_CMD LD_LIBRARY_PATH=$LD_LIBRARY_PATH;"
  NDB_EXPORT_CMD="$NDB_EXPORT_CMD export LD_LIBRARY_PATH;"
  SSH_CMD="$SSH -p $SSH_PORT -n -l $SSH_USER $LOCAL_API_HOST"
}

execute_flex_asynch_sync()
{
  set_pipe_command
  if test "x$LOCAL_API_HOST" != "x127.0.0.1" && \
     test "x$LOCAL_API_HOST" != "xlocalhost" ; then
    set_ssh_cmd
    COMMAND="$SSH_CMD '$NDB_EXPORT_CMD $COMMAND'"
  else
    COMMAND="$COMMAND"
  fi
  exec_command
}

execute_flex_asynch_async()
{
  set_pipe_command
  if test "x$LOCAL_API_HOST" != "x127.0.0.1" && \
     test "x$LOCAL_API_HOST" != "xlocalhost" ; then
    set_ssh_cmd
    COMMAND="$SSH_CMD '$NDB_EXPORT_CMD $COMMAND'&"
  else
    COMMAND="$COMMAND &"
  fi
  exec_command
}

set_flex_asynch_taskset()
{
  LOC_TASKSET="$BENCH_TASKSET ${BENCHMARK_CPU_ARRAY[${INDEX}]}"
  ((INDEX+=1))
  FLEX_ASYNCH_TASKSET="$LOC_TASKSET $FLEX_ASYNCH_BIN"
}

run_flexAsynch()
{
  set_ld_library_path
  ${ECHO} "run_flexAsynch"
  export NDB_CONNECTSTRING
  ${MKDIR} -p ${DEFAULT_DIR}/flex_logs

  BENCHMARK_CPUS_LOC=`${ECHO} ${BENCHMARK_CPUS} | ${SED} -e 's!\;! !g'`
  INDEX="0"
  for CPU_LOC in ${BENCHMARK_CPUS_LOC}
  do
    BENCHMARK_CPU_ARRAY[${INDEX}]=${CPU_LOC}
    ((INDEX+=1))
  done

  FLEX_ASYNCH_BIN="$MYSQL_PATH/bin/flexAsynch"

  FLEX_ASYNCH_META="-a $FLEX_ASYNCH_NUM_ATTRIBUTES"
  FLEX_ASYNCH_META="$FLEX_ASYNCH_META -s $FLEX_ASYNCH_ATTRIBUTE_SIZE"

  FLEX_ASYNCH_OPS="-t $FLEX_ASYNCH_NUM_THREADS"
  FLEX_ASYNCH_OPS="$FLEX_ASYNCH_OPS -p $FLEX_ASYNCH_NUM_PARALLELISM"
  FLEX_ASYNCH_OPS="$FLEX_ASYNCH_OPS -o $FLEX_ASYNCH_EXECUTION_ROUNDS"
  FLEX_ASYNCH_OPS="$FLEX_ASYNCH_OPS -c $FLEX_ASYNCH_NUM_OPS_PER_TRANS"
  if test "x$FLEX_ASYNCH_NEW" != "x" ; then
    FLEX_ASYNCH_OPS="$FLEX_ASYNCH_OPS $FLEX_ASYNCH_NEW"
    FLEX_ASYNCH_OPS="$FLEX_ASYNCH_OPS -d $FLEX_ASYNCH_DEF_THREADS"
  fi
  if test "x$FLEX_ASYNCH_NO_LOGGING" = "xyes" ; then
    FLEX_ASYNCH_META="$FLEX_ASYNCH_META -temp"
  fi
  if test "x$FLEX_ASYNCH_NO_HINT" = "xyes" ; then
    FLEX_ASYNCH_OPS="$FLEX_ASYNCH_OPS -no_hint"
  fi
  if test "x$FLEX_ASYNCH_FORCE_FLAG" = "xforce" ; then
    FLEX_ASYNCH_OPS="$FLEX_ASYNCH_OPS -force"
  elif test "x$FLEX_ASYNCH_FORCE_FLAG" = "xadaptive" ; then
    FLEX_ASYNCH_OPS="$FLEX_ASYNCH_OPS -adaptive"
  elif test "x$FLEX_ASYNCH_FORCE_FLAG" = "xnon_adaptive" ; then
    FLEX_ASYNCH_OPS="$FLEX_ASYNCH_OPS -non_adaptive"
  fi
  if test "x$FLEX_ASYNCH_USE_WRITE" = "xyes" ; then
    FLEX_ASYNCH_OPS="$FLEX_ASYNCH_OPS -write"
  fi
  if test "x$FLEX_ASYNCH_USE_LOCAL" != "x0" ; then
    FLEX_ASYNCH_OPS="$FLEX_ASYNCH_OPS -local $FLEX_ASYNCH_USE_LOCAL"
  fi
  FLEX_ASYNCH_OPS="$FLEX_ASYNCH_OPS -con $FLEX_ASYNCH_NUM_MULTI_CONNECTIONS"
  FLEX_ASYNCH_OPS="$FLEX_ASYNCH_OPS -ndbrecord"

  FLEX_ASYNCH_TIMERS="-warmup_time $FLEX_ASYNCH_WARMUP_TIMER"
  FLEX_ASYNCH_TIMERS="$FLEX_ASYNCH_TIMERS -execution_time $FLEX_ASYNCH_EXECUTION_TIMER"
  FLEX_ASYNCH_TIMERS="$FLEX_ASYNCH_TIMERS -cooldown_time $FLEX_ASYNCH_COOLDOWN_TIMER"

  TABLE_NUM="0"
  FLEX_ASYNCH_API_NODES=`${ECHO} ${FLEX_ASYNCH_API_NODES} | ${SED} -e 's!\;! !g'`
  TABLE_OP="init"
  for LOCAL_API_HOST in $FLEX_ASYNCH_API_NODES
  do
    set_file_name
    ${ECHO} "flexAsynch table $TABLE_NUM" > $FA_FILE_NAME
    ((TABLE_NUM += 1))
  done
  MSG="Create tables"
  output_msg
  TABLE_NUM="0"
  TABLE_OP="create"
  INDEX="0"
  for LOCAL_API_HOST in $FLEX_ASYNCH_API_NODES
  do
    set_file_name
    set_flex_asynch_taskset
    COMMAND="$FLEX_ASYNCH_TASKSET $FLEX_ASYNCH_META -table $TABLE_NUM -create_table"
    ((TABLE_NUM += 1))
    execute_flex_asynch_sync
  done

  MSG="Insert into tables in parallel"
  output_msg
  TABLE_NUM="0"
  TABLE_OP="insert"
  INDEX="0"
  for LOCAL_API_HOST in $FLEX_ASYNCH_API_NODES
  do
    set_file_name
    set_flex_asynch_taskset
    COMMAND="$FLEX_ASYNCH_TASKSET $FLEX_ASYNCH_META"
    COMMAND="$COMMAND $FLEX_ASYNCH_OPS -table $TABLE_NUM -insert"
    ((TABLE_NUM += 1))
    execute_flex_asynch_async
  done
  MSG="Wait for all commands to complete"
  output_msg
  wait

  MSG="Update tables in parallel"
  output_msg
  TABLE_NUM="0"
  TABLE_OP="update"
  INDEX="0"
  for LOCAL_API_HOST in $FLEX_ASYNCH_API_NODES
  do
    set_file_name
    set_flex_asynch_taskset
    COMMAND="$FLEX_ASYNCH_TASKSET $FLEX_ASYNCH_META"
    COMMAND="$COMMAND $FLEX_ASYNCH_OPS -table $TABLE_NUM -update"
    COMMAND="$COMMAND $FLEX_ASYNCH_TIMERS"
    ((TABLE_NUM += 1))
    execute_flex_asynch_async
  done
  MSG="Wait for all commands to complete"
  output_msg
  wait

  MSG="Read tables in parallel"
  output_msg
  TABLE_NUM="0"
  TABLE_OP="read"
  INDEX="0"
  for LOCAL_API_HOST in $FLEX_ASYNCH_API_NODES
  do
    set_file_name
    set_flex_asynch_taskset
    COMMAND="$FLEX_ASYNCH_TASKSET $FLEX_ASYNCH_META"
    COMMAND="$COMMAND $FLEX_ASYNCH_OPS -table $TABLE_NUM -read"
    COMMAND="$COMMAND $FLEX_ASYNCH_TIMERS"
    ((TABLE_NUM += 1))
    execute_flex_asynch_async
  done
  MSG="Wait for all commands to complete"
  output_msg
  wait

  MSG="Delete from tables in parallel"
  output_msg
  TABLE_NUM="0"
  TABLE_OP="delete"
  INDEX="0"
  for LOCAL_API_HOST in $FLEX_ASYNCH_API_NODES
  do
    set_file_name
    set_flex_asynch_taskset
    COMMAND="$FLEX_ASYNCH_TASKSET $FLEX_ASYNCH_META"
    COMMAND="$COMMAND $FLEX_ASYNCH_OPS -table $TABLE_NUM -delete"
    ((TABLE_NUM += 1))
    execute_flex_asynch_async
  done
  MSG="Wait for all commands to complete"
  output_msg
  wait

  MSG="Drop tables"
  output_msg
  TABLE_NUM="0"
  TABLE_OP="drop"
  INDEX="0"
  for LOCAL_API_HOST in $FLEX_ASYNCH_API_NODES
  do
    set_file_name
    set_flex_asynch_taskset
    COMMAND="$FLEX_ASYNCH_TASKSET $FLEX_ASYNCH_META -table $TABLE_NUM -drop_table"
    ((TABLE_NUM += 1))
    execute_flex_asynch_sync
  done

  FINAL_RESULT_FILE="$DEFAULT_DIR/final_result.txt"
  INSERT_RESULT_FILE="${DEFAULT_DIR}/flex_logs/tmp_insert_result"
  DELETE_RESULT_FILE="${DEFAULT_DIR}/flex_logs/tmp_delete_result"
  READ_RESULT_FILE="${DEFAULT_DIR}/flex_logs/tmp_read_result"
  UPDATE_RESULT_FILE="${DEFAULT_DIR}/flex_logs/tmp_update_result"

  TABLE_NUM="0"
  ${RM} ${INSERT_RESULT_FILE}
  ${RM} ${DELETE_RESULT_FILE}
  ${RM} ${READ_RESULT_FILE}
  ${RM} ${UPDATE_RESULT_FILE}
  ${RM} ${FINAL_RESULT_FILE}

  for LOCAL_API_HOST in $FLEX_ASYNCH_API_NODES
  do
    TABLE_OP="insert"
    set_file_name
    ${CAT} ${FA_FILE_NAME} | ${GREP} 'Total transactions' | \
    ${NAWK} '{ print $5 }' >> ${INSERT_RESULT_FILE}
    TABLE_OP="delete"
    set_file_name
    ${CAT} ${FA_FILE_NAME} | ${GREP} 'Total transactions' | \
    ${NAWK} '{ print $5 }' >> ${DELETE_RESULT_FILE}
    TABLE_OP="read"
    set_file_name
    ${CAT} ${FA_FILE_NAME} | ${GREP} 'Total transactions' | \
    ${NAWK} '{ print $5 }' >> ${READ_RESULT_FILE}
    TABLE_OP="update"
    set_file_name
    ${CAT} ${FA_FILE_NAME} | ${GREP} 'Total transactions' | \
    ${NAWK} '{ print $5 }' >> ${UPDATE_RESULT_FILE}
    ((TABLE_NUM += 1))
  done
  TOTAL_INSERTS="0"
  TOTAL_DELETES="0"
  TOTAL_READS="0"
  TOTAL_UPDATES="0"

  while read NUM_INSERTS
  do
    ((TOTAL_INSERTS += NUM_INSERTS))
  done < ${INSERT_RESULT_FILE}

  while read NUM_DELETES
  do
    ((TOTAL_DELETES += NUM_DELETES))
  done < ${DELETE_RESULT_FILE}

  while read NUM_READS
  do
    ((TOTAL_READS += NUM_READS))
  done < ${READ_RESULT_FILE}

  while read NUM_UPDATES
  do
    ((TOTAL_UPDATES += NUM_UPDATES))
  done < ${UPDATE_RESULT_FILE}

  ${ECHO} "Total inserts per second are: $TOTAL_INSERTS" > $FINAL_RESULT_FILE
  ${ECHO} "Total deletes per second are: $TOTAL_DELETES" >> $FINAL_RESULT_FILE
  ${ECHO} "Total reads per second are: $TOTAL_READS" >> $FINAL_RESULT_FILE
  ${ECHO} "Total updates per second are: $TOTAL_UPDATES" >> $FINAL_RESULT_FILE
  ${CAT} ${FINAL_RESULT_FILE}

  ${RM} ${INSERT_RESULT_FILE}
  ${RM} ${DELETE_RESULT_FILE}
  ${RM} ${READ_RESULT_FILE}
  ${RM} ${UPDATE_RESULT_FILE}
}

CAT=cat
GREP=
SED=sed
BC=bc
ECHO=echo
RM=rm
SLEEP=sleep
MKDIR=mkdir
PWD=pwd
SSH=ssh
SSH_PORT="22"
SSH_USER=$USER
SERVER_TYPE="MySQL"
SERVER_TYPE_NAME="mysqld"
LOG_FILE=

#Sleep parameters for various sections
BETWEEN_RUNS="25"             # Time between runs to avoid checkpoints
AFTER_INITIAL_RUN="30"        # Time after initial run
AFTER_SERVER_START="60"       # Wait for Server to start
BETWEEN_CREATE_DB_TEST="15"   # Time between each attempt to create DB
NUM_CREATE_DB_ATTEMPTS="12"   # Max number of attempts before giving up
AFTER_SERVER_STOP="30"        # Time to wait after stopping Server

#Parameters normally configured
NUM_TEST_RUNS="3" # Number of loops to run tests in
MAX_TIME="60"     # Time to run each test
ENGINE="innodb"   # Engine used to run test
THREAD_COUNTS_TO_RUN="16;32;64;128;256" #Thread counts to use in runs

#Which tests should we run, default is to run all of them
RUN_RW="yes"             # Run Sysbench RW test or not
RUN_RW_WRITE_INT="no"    # Run Write Intensive RW test or not
RUN_RW_RW_LESS_READ="no" # Run RW test with less read or not
RUN_RO="yes"             # Run Sysbench RO test
RUN_WRITE="no"           # Run Sysbench Write only test

#Parameters specifying where MySQL/Drizzle Server is hosted
SERVER_HOST=           # Hostname of MySQL/Drizzle Server
SERVER_PORT=           # Port of MySQL/Drizzle Server to connect to

#Set both taskset and CPUS to blank if no binding to CPU is wanted
TASKSET=                      # Program to bind program to CPU's
CPUS=                         # CPU's to bind to

#Default configuration file
DEFAULT_DIR="${HOME}/.build"

#Paths to MySQL, Drizzle, DBT2 and Sysbench installation
LIBDRIZZLE_PATH=
DRIZZLE_PATH=
MYSQL_PATH=
DBT2_PATH=
SYSBENCH=

#Variables initialised
VERBOSE=
VERBOSE_FLAG=
SKIP_RUN=
SKIP_START=
SKIP_STOP=
SYSBENCH_DB="sbtest"
EXIT_FLAG=
MALLOC_LIB="/usr/lib64/libtcmalloc_minimal.so.0"
USE_MALLOC_LIB="no"
MYSQL_CREATE_OPTIONS=
PRELOAD_COMMAND=
MSG=
ONLY_INITIAL=

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

NAWK="nawk"
which nawk 2> /dev/null 1> /dev/null
if test "x$?" != "x0" ; then
  NAWK="awk"
fi

if test $# -gt 1 ; then
  case $1 in
    --default-directory )
      shift
      DEFAULT_DIR="$1"
      shift
      ;;
    *)
  esac
fi
if test $# -gt 1 ; then
  case $1 in
    --benchmark )
      shift
      BENCHMARK="$1"
      shift
      ;;
    *)
  esac
fi

#
# Set up configuration files references to the default directory used
#
DEFAULT_FILE="${DEFAULT_DIR}/iclaustron.conf"
if test -f "$DEFAULT_FILE" ; then
  . ${DEFAULT_FILE}
fi
if test "x${BENCHMARK}" = "xsysbench" ; then
  DEFAULT_FILE="${DEFAULT_DIR}/sysbench.conf"
else
  DEFAULT_FILE="${DEFAULT_DIR}/dbt2.conf"
fi
#Read configuration parameters
if test -f "$DEFAULT_FILE" ; then
  . ${DEFAULT_FILE}
fi

while test $# -gt 0
do
  case $1 in
  --database )
    shift
    SYSBENCH_DB="$1"
    ;;
  --verbose )
    VERBOSE="yes"
    VERBOSE_FLAG="--verbose"
    ;;
  --skip-run )
    SKIP_RUN="yes"
    ;;
  --skip-start )
    SKIP_START="yes"
    ;;
  --skip-stop )
    SKIP_STOP="yes"
    ;;
  --only-initial )
    ONLY_INITIAL="yes"
    ;;
  *)
    MSG="No such option $1"
    output_msg
    exit 1
  esac
  shift
done


#
# Set up configuration files references to the default directory used
#
if test "x${BENCHMARK}" = "xsysbench" ; then
  MSG="Starting Sysbench benchmark using directory ${DEFAULT_DIR}"
  output_msg
  DEFAULT_FILE="${DEFAULT_DIR}/sysbench.conf"
  RESULT_DIR="${DEFAULT_DIR}/sysbench_results"
  STATS_DIR="${DEFAULT_DIR}/statistics_logs"
  THREAD_FILE_NAME="${RESULT_DIR}/tmp_threads.txt"
  RESULT_NAME="${RESULT_DIR}/tmp_res_file"
  FINAL_RESULT_FILE="${DEFAULT_DIR}/final_result.txt"
else
  DEFAULT_FILE="${DEFAULT_DIR}/dbt2.conf"
  if test "x${BENCHMARK}" = "flexAsynch" ; then
    MSG="Starting flexAsynch benchmark using directory ${DEFAULT_DIR}"
  else
    MSG="Starting DBT2 benchmark using directory ${DEFAULT_DIR}"
  fi
  output_msg
fi
if test -f "$DEFAULT_FILE" ; then
  MSG="Sourcing defaults from $DEFAULT_FILE"
  output_msg
else
  MSG="No $DEFAULT_FILE found, using standard defaults"
  output_msg
fi

DEFAULT_CLUSTER_CONFIG_FILE="${DEFAULT_DIR}/dis_config_c1.ini"

set_ld_library_path
if test "x$ENGINE" = "xndb" ; then
  SERVER_TYPE="All"
  SERVER_TYPE_NAME="all"
fi
if test "x${BENCHMARK}" = "xsysbench" ; then
  THREAD_COUNTS_TO_RUN=`${ECHO} $THREAD_COUNTS_TO_RUN | sed -e 's!\;! !g'`
#Current directory is our run directory
#Create result directory for temporary results
#Final results is placed in run directory
  ${MKDIR} -p ${RESULT_DIR}
fi

if test "x${SKIP_START}" != "xyes" ; then
  start_mysql
  if test "x${BENCHMARK}" != "xflexAsynch" ; then
    create_test_database
    create_test_user
    edit_pfs_synch
  fi
fi
if test "x${BENCHMARK}" = "xsysbench" ; then
  if test "x${SKIP_RUN}" != "xyes" ; then
    if test "x$ENGINE" = "xinnodb" ; then
      initial_test
    fi
    THREAD_RUNS="${THREAD_COUNTS_TO_RUN}"
    run_tests
    analyze_results
  elif test "x$ONLY_INITIAL" = "xyes" ; then
    initial_test
  fi
else
  if test "x${BENCHMARK}" = "xflexAsynch" ; then
    run_flexAsynch
  else
    if test "x${SKIP_RUN}" != "xyes" ; then
      load_dbt2_database
      run_dbt2
    fi
  fi
fi

if test "x${SKIP_START}" != "xyes" && \
   test "x${SKIP_STOP}" != "xyes" ; then
  stop_mysql
fi
exit 0
