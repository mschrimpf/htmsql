#!/bin/bash
# ----------------------------------------------------------------------
# Copyright (C) 2007 iClaustron  AB
#   2008, 2012 Oracle Oracle and/or its affiliaties. All rights reserved.
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
  This program runs an automated benchmark with either sysbench or
  DBT2. It is driven by a configuration file autobench.conf which
  must be placed in the directory specified by the parameter
  --default-directory which is a mandatory parameter. The
  sysbench tarball, the MySQL tarball and the tarball with the
  scripts needed to run the test in the DBT2 tarball must be
  placed in the directory specified by the variable TARBALL_DIR in
  the autobench.conf file.

  There are 5 stages in this execution:
  1) Create config files for the various scripts used
  2) Build sysbench, DBT2 and MySQL locally
  3) Build MySQL remotely
  4) Execute test
  5) Cleanup after test

  Parameters:
  -----------
  --default-directory     : Directory where autobench.conf is placed, this
                            directory is also used to place builds, results
                            and other temporary storage needed to run the
                            test.
  --skip-build-local      : Skip building locally
  --skip-build-remote     : Skip building remotely
  --skip-test             : Skip running test completely
  --skip-run              : Skip execute test
  --skip-start            : Skip start/stop MySQL Server/Cluster
  --skip-stop             : Skip stop MySQL Server/Cluster
  --skip-cleanup          : Skip cleanup phase
  --generate-dbt2-data    : Generate load files for DBT2 benchmark, can only
                            be done in conjunction with build locally
  --kill-nodes            : Kill all nodes in the cluster after running
                            flexAsynch benchmark that failed in the middle
EOF
}

check_support_programs()
{
  TAR=`which gtar`
  if test "x$?" != "x0" ; then
    TAR=`which tar`
  fi
  MAKE=`which gmake`
  if test "x$?" != "x0" ; then
    MAKE=`which make`
  fi
}

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

#Method to execute any command and verify command was a success
exec_command()
{
  MSG="Executing $*"
  output_msg
  eval $*
  if test "x$?" != "x0" ; then
    MSG="Failed command $*"
    output_msg
    exit 1
  fi
}

create_dir()
{
  if ! test -d $CREATE_DIR ; then
    ${MKDIR} -p $CREATE_DIR
    if ! test -d $CREATE_DIR ; then
      if test "x$LOG_FILE_CREATED" = "xyes" ; then
        MSG="Failed to create $CREATE_DIR"
        output_msg
      else
        ${ECHO} "Failed to create $CREATE_DIR"
      fi
      exit 1
    fi
    if test "x$LOG_FILE_CREATED" = "xyes" ; then
      MSG="Successfully created $CREATE_DIR"
      output_msg
    else
      ${ECHO} "Successfully created $CREATE_DIR"
    fi
  fi
}

create_dirs()
{
  CREATE_DIR="${SRC_INSTALL_DIR}"
  create_dir
  CREATE_DIR="${BIN_INSTALL_DIR}"
  create_dir
}

# $1 is the node specification to which we are setting up SSH towards
setup_ssh_node()
{
  SSH_NODE="${1}"
  if test "x${SSH_USER}" = "x" ; then
    SSH_USER_HOST="${SSH_NODE}"
  else
    SSH_USER_HOST="${SSH_USER}@${SSH_NODE}"
  fi
  SSH_CMD="${SSH} -p ${SSH_PORT} ${SSH_USER_HOST}"
}

exec_ssh_command()
{
  LOCAL_CMD="$*"
  if test "x${SSH_NODE}" != "xlocalhost" && \
     test "x${SSH_NODE}" != "x127.0.0.1" ; then
    setup_ssh_node ${SSH_NODE}
    MSG="Executing $SSH_CMD '$LOCAL_CMD'"
    output_msg
    LOCAL_CMD="$SSH_CMD '$LOCAL_CMD'"
    eval $LOCAL_CMD
    if test "x$?" != "x0" && test "x$IGNORE_FAILURE" != "xyes"; then
      MSG="Failed command $*"
      output_msg
      exit 1
    fi
  else
    exec_command ${LOCAL_CMD}
  fi
}

create_remote_data_dir_base()
{
  SSH_NODE="${1}"
  echo "Create data dir on node $SSH_NODE"
  LOCAL_CMD="$CD $DATA_DIR_BASE; $MKDIR -p ndb; mkdir -p mysql-cluster"
  exec_ssh_command $LOCAL_CMD
}

unpack_tarball()
{
  TARBALL_NAME="$1"
  COMMAND="${CP} ${TARBALL_DIR}/${TARBALL_NAME}.tar.gz"
  COMMAND="${COMMAND} ${TARBALL_NAME}.tar.gz"
  exec_command ${COMMAND}
  COMMAND="${TAR} xfz ${TARBALL_NAME}.tar.gz"
  exec_command ${COMMAND}
  COMMAND="${RM} ${TARBALL_NAME}.tar.gz"
  exec_command ${COMMAND}
}

init_tarball_variables()
{
  if test "x${WINDOWS_REMOTE}" != "xyes" ; then
    if test "x${USE_DRIZZLE}" = "xyes" ; then
      DRIZZLE_TARBALL="${DRIZZLE_VERSION}_binary.tar.gz"
    else
      MYSQL_TARBALL="${MYSQL_VERSION}_binary.tar.gz"
    fi
  fi
}

#Unpack the source tarballs into the SRC_INSTALL_DIR
unpack_tarballs()
{
  exec_command ${CD} ${SRC_INSTALL_DIR}
  exec_command ${CD} ..
  exec_command ${RM} -rf ${SRC_INSTALL_DIR}
  exec_command ${MKDIR} ${SRC_INSTALL_DIR}
  exec_command ${CD} ${SRC_INSTALL_DIR}
  if test "x$USE_DRIZZLE" = "xyes" ; then
    unpack_tarball ${DRIZZLE_VERSION}
  else
    if test "x$USE_BINARY_MYSQL_TARBALL" = "xno" ; then
      unpack_tarball ${MYSQL_VERSION}
    fi
  fi
  if test "x${BENCHMARK_TO_RUN}" = "xsysbench" ; then
    unpack_tarball ${SYSBENCH_VERSION}
  fi
  unpack_tarball ${DBT2_VERSION}

  exec_command ${CD} ${DEFAULT_DIR}
}

execute_build()
{
  BUILD_VERSION="$1"
  exec_command ${CD} ${SRC_INSTALL_DIR}/${BUILD_VERSION}
  exec_command ${COMMAND}
  exec_command ${MAKE} -j 8
  exec_command ${MAKE} install
  MSG="Successfully built and installed ${BUILD_VERSION}"
  output_msg
}

build_local()
{
  if test "x${USE_DRIZZLE}" = "xyes" ; then
    if test "x${WINDOWS_REMOTE}" = "xyes" ; then
      MSG="Drizzle currently doesn't work on Windows"
      output_msg
    fi
    MSG="Building Drizzle version: ${DRIZZLE_VERSION}"
    output_msg
    CREATE_DIR=${BIN_INSTALL_DIR}/${DRIZZLE_VERSION}
    DRIZZLE_INSTALL_DIR=${CREATE_DIR}
    create_dir

    COMMAND="./configure --prefix=${DRIZZLE_INSTALL_DIR}"
    COMMAND="${COMMAND} ${WITH_DEBUG}"
    execute_build ${DRIZZLE_VERSION}
  else
    MYSQL_INSTALL_DIR=${BIN_INSTALL_DIR}/${MYSQL_VERSION}
    if test "x$USE_BINARY_MYSQL_TARBALL" = "xyes" ; then
      MSG="Building from binary MySQL version: ${MYSQL_VERSION}"
      output_msg
      exec_command ${CD} ${BIN_INSTALL_DIR}
      unpack_tarball ${MYSQL_VERSION}
    else
      MSG="Building from source MySQL version: ${MYSQL_VERSION}"
      output_msg

      CREATE_DIR=${MYSQL_INSTALL_DIR}
      create_dir

      exec_command ${CD} ${SRC_INSTALL_DIR}/${MYSQL_VERSION}
      if test "x$DEBUG_FLAG" = "xyes" ; then
        DEBUG_FLAG="--debug"
      else
        DEBUG_FLAG=
      fi
      if test "x$STATIC_LINKING_FLAG" = "xno" ; then
        STATIC_LINKING_FLAG="--no-static-linking"
      else
        STATIC_LINKING_FLAG=
      fi
      if test "x$USE_DBT2_BUILD" = "xyes" ||
         ! test -f BUILD/build_mccge.sh || \
         ! test -f BUILD/check-cpu ; then
        $CP $SRC_INSTALL_DIR/$DBT2_VERSION/scripts/build_mccge.sh BUILD/.
        $CP $SRC_INSTALL_DIR/$DBT2_VERSION/scripts/check-cpu BUILD/.
      fi
      exec_command BUILD/build_mccge.sh --prefix=${MYSQL_INSTALL_DIR} \
                                      ${WITH_DEBUG} \
                                      ${DEBUG_FLAG} \
                                      ${STATIC_LINKING_FLAG} \
                                      ${PACKAGE} ${FAST_FLAG} \
                                      ${COMPILER_FLAG} \
                                      ${LINK_TIME_OPTIMIZER_FLAG} \
                                      ${MSO_FLAG} \
                                      ${COMPILE_SIZE_FLAG} \
                                      ${WITH_FAST_MUTEXES_FLAG} \
                                      ${WITH_PERFSCHEMA_FLAG} \
                                      ${FEEDBACK_FLAG} \
                                      ${WITH_NDB_TEST_FLAG}
      exec_command ${MAKE} install
      MSG="Successfully built and installed ${MYSQL_VERSION}"
      output_msg
    fi
    exec_command ${CD} ${DEFAULT_DIR}
    if test "x${MYSQL_VERSION}" != "x${CLIENT_MYSQL_VERSION}" ; then
      MYSQL_DIR="$REMOTE_BIN_INSTALL_DIR/$CLIENT_MYSQL_VERSION"
    else
      MYSQL_DIR="$BIN_INSTALL_DIR/$MYSQL_VERSION"
    fi
    if test "x${BENCHMARK_TO_RUN}" = "xdbt2" ; then
      MSG="Building DBT2 version: ${DBT2_VERSION}"
      output_msg
      exec_command cd ${SRC_INSTALL_DIR}/${DBT2_VERSION}
      exec_command ./configure --with-mysql=${MYSQL_DIR}
      exec_command ${MAKE} 
    fi
  fi

  exec_command ${CD} ${DEFAULT_DIR}
  if test "x${BENCHMARK_TO_RUN}" = "xsysbench" ; then
    CREATE_DIR=${BIN_INSTALL_DIR}/${SYSBENCH_VERSION}
    SYSBENCH_INSTALL_DIR=${CREATE_DIR}
    create_dir

    exec_command ${CD} ${SRC_INSTALL_DIR}/${SYSBENCH_VERSION}
    if test "x${USE_DRIZZLE}" = "xyes" ; then
      MSG="Building drizzle-sysbench"
      output_msg
      COMMAND="./configure --without-mysql"
      COMMAND="${COMMAND} --prefix=${SYSBENCH_INSTALL_DIR}"
      COMMAND="${COMMAND} ${WITH_DEBUG}"
      COMMAND="${COMMAND} --with-drizzle=${DRIZZLE_INSTALL_DIR}"
    else
      MSG="Building sysbench"
      output_msg
      COMMAND="./configure --with-mysql=${MYSQL_DIR}"
      COMMAND="${COMMAND} --prefix=${SYSBENCH_INSTALL_DIR} ${WITH_DEBUG}"
    fi
    execute_build ${SYSBENCH_VERSION}
  fi
  exec_command ${CD} ${DEFAULT_DIR}
}

create_remote_src()
{
  SSH_NODE="${LOCAL_NODE}"
  exec_ssh_command $MKDIR -p ${LOCAL_DIR}
}

remote_copy()
{
  COPY_VERSION="$1"
  if test "x${LOCAL_NODE}" != "xlocalhost" && \
     test "x${LOCAL_NODE}" != "x127.0.0.1" ; then
    COMMAND="${SCP} -P $SSH_PORT ${TARBALL_DIR}/${COPY_VERSION}.tar.gz"
    if test "x${SSH_USER}" = "x" ; then
      COMMAND="$COMMAND ${LOCAL_NODE}:${LOCAL_DIR}"
    else
      COMMAND="$COMMAND ${SSH_USER}@${LOCAL_NODE}:${LOCAL_DIR}"
    fi
    exec_command $COMMAND
  else
    exec_command ${CP} ${TARBALL_DIR}/${COPY_VERSION}.tar.gz ${LOCAL_DIR}
  fi
}

build_remote_unix()
{
  LOCAL_NODE="$1"
  SSH_NODE="$LOCAL_NODE"
  LOCAL_DIR="$REMOTE_SRC_INSTALL_DIR"
  if test "x$REMOTE_SRC_INSTALL_DIR" = "x" ; then
    MSG="REMOTE_SRC_INSTALL_DIR is mandatory to set"
    output_msg
    exit 1
  fi
  MSG="Build binaries at $LOCAL_NODE in directory $LOCAL_DIR"
  output_msg

  create_remote_src

  if test "x${USE_DRIZZLE}" = "xyes" ; then
    remote_copy ${DRIZZLE_VERSION}
  else
    remote_copy ${MYSQL_VERSION}
  fi

  if test "x${USE_FAST_MYSQL}" = "xyes" ; then
    FAST_FLAG="--fast"
  else
    FAST_FLAG=""
  fi
 
# Generate build command on remote Unix machine
  SSH_NODE="$LOCAL_NODE"
  if test "x${USE_DRIZZLE}" = "xyes" ; then
    COMMAND="cd $LOCAL_DIR &&"
    COMMAND="${COMMAND} mkdir -p ${TMP_BASE} &&"
    COMMAND="${COMMAND} rm -rf ${DRIZZLE_VERSION} &&"
    COMMAND="${COMMAND} gtar xfz ${DRIZZLE_VERSION}.tar.gz &&"
    COMMAND="${COMMAND} rm ${DRIZZLE_VERSION}.tar.gz &&"
    COMMAND="${COMMAND} cd ${DRIZZLE_VERSION} &&"
    COMMAND="${COMMAND} ./configure"
    COMMAND="${COMMAND} --prefix=${REMOTE_BIN_INSTALL_DIR}/${DRIZZLE_VERSION} &&"
    COMMAND="${COMMAND} gmake -j 8 &&"
    COMMAND="${COMMAND} gmake install &&"
    COMMAND="${COMMAND} rm -rf ${LOCAL_DIR}/${DRIZZLE_VERSION}"
  else
    COMMAND="cd $LOCAL_DIR &&"
    COMMAND="${COMMAND} mkdir -p ${TMP_BASE} &&"
    COMMAND="${COMMAND} rm -rf ${MYSQL_VERSION} &&"
    COMMAND="${COMMAND} gtar xfz ${MYSQL_VERSION}.tar.gz &&"
    COMMAND="${COMMAND} rm ${MYSQL_VERSION}.tar.gz &&"
    COMMAND="${COMMAND} cd ${MYSQL_VERSION} &&"
    COMMAND="${COMMAND} BUILD/build_mccge.sh"
    COMMAND="${COMMAND} --prefix=${REMOTE_BIN_INSTALL_DIR}/${MYSQL_VERSION}"
    COMMAND="${COMMAND} ${WITH_DEBUG}"
    COMMAND="${COMMAND} ${FAST_FLAG}"
    COMMAND="${COMMAND} ${COMPILER_FLAG}"
    COMMAND="${COMMAND} ${LINK_TIME_OPTIMIZER_FLAG}"
    COMMAND="${COMMAND} ${MSO_FLAG}"
    COMMAND="${COMMAND} ${COMPILE_SIZE_FLAG}"
    COMMAND="${COMMAND} ${WITH_FAST_MUTEXES_FLAG}"
    COMMAND="${COMMAND} ${WITH_PERFSCHEMA_FLAG}"
    COMMAND="${COMMAND} ${PACKAGE}"
    COMMAND="${COMMAND} ${WITH_NDB_TEST_FLAG} &&"
    COMMAND="${COMMAND} gmake install &&"
    COMMAND="${COMMAND} rm -rf ${LOCAL_DIR}/${MYSQL_VERSION}"
  fi
  exec_ssh_command ${COMMAND}
  return 0
}

# $1 contains the NODE specification where to install the binaries
build_remote_windows()
{
  LOCAL_NODE="$1"
  LOCAL_DIR="$REMOTE_SRC_INSTALL_DIR"
  if test "x$REMOTE_SRC_INSTALL_DIR" = "x" ; then
    MSG="REMOTE_SRC_INSTALL_DIR is mandatory to set on Windows"
    output_msg
    exit 1
  fi
  MSG="Build binaries at $LOCAL_NODE in directory $LOCAL_DIR"
  output_msg

  create_remote_src
  remote_copy ${MYSQL_VERSION}

#Replace ; by spaces in CMAKE Generator
  CMAKE_GENERATOR=`${ECHO} ${CMAKE_GENERATOR} | ${SED} -e 's!\;! !g'`
# Generate build command on Windows
  COMMAND="cd $LOCAL_DIR &&"
  COMMAND="${COMMAND} mkdir -p ${TMP_BASE} &&"
  COMMAND="${COMMAND} rm -rf ${MYSQL_VERSION} &&"
  COMMAND="${COMMAND} tar xfz ${MYSQL_VERSION}.tar.gz &&"
  COMMAND="${COMMAND} rm ${MYSQL_VERSION}.tar.gz &&"
  COMMAND="${COMMAND} cd ${MYSQL_VERSION} &&"

  COMMAND="${COMMAND} cscript win/configure.js"
  COMMAND="${COMMAND} WITH_INNOBASE_STORAGE_ENGINE"
  COMMAND="${COMMAND} WITH_PARTITION_STORAGE_ENGINE"
  COMMAND="${COMMAND} WITH_ARCHIVE_STORAGE_ENGINE"
  COMMAND="${COMMAND} WITH_BLACKHOLE_STORAGE_ENGINE"
  COMMAND="${COMMAND} WITH_EXAMPLE_STORAGE_ENGINE"
  COMMAND="${COMMAND} WITH_FEDERATED_STORAGE_ENGINE"
  COMMAND="${COMMAND} WITH_NDBCLUSTER_STORAGE_ENGINE"
  COMMAND="${COMMAND} __NT__"
  COMMAND="${COMMAND} \"COMPILATION_COMMENT=${MYSQL_VERSION}\" &&"

  COMMAND="${COMMAND} cmake -G \"${CMAKE_GENERATOR}\" &&"
  COMMAND="${COMMAND} devenv.com mysql.sln /Build Release &&"
  COMMAND="${COMMAND} scripts/make_win_bin_dist ${MYSQL_VERSION} &&"
  COMMAND="${COMMAND} cp ${MYSQL_VERSION}.zip ${REMOTE_BIN_INSTALL_DIR} &&"
  COMMAND="${COMMAND} cd ..; rm -rf ${MYSQL_VERSION} &&"
  COMMAND="${COMMAND} cd ${REMOTE_BIN_INSTALL_DIR} &&"
  COMMAND="${COMMAND} rm -rf ${MYSQL_VERSION} &&"
  COMMAND="${COMMAND} unzip ${MYSQL_VERSION}.zip &&"
  COMMAND="${COMMAND} rm ${MYSQL_VERSION}.zip"
  SSH_NODE="${LOCAL_NODE}"
  exec_ssh_command ${COMMAND}
}

install_one_remote_binary()
{
  TARBALL_NAME="$1"
  TARBALL_VERSION="$2"
  SSH_NODE="${LOCAL_NODE}"
  exec_ssh_command $MKDIR -p ${LOCAL_DIR}

  exec_command cd $BIN_INSTALL_DIR
  if test "x${LOCAL_NODE}" != "xlocalhost" && \
     test "x${LOCAL_NODE}" != "x127.0.0.1" ; then
    COMMAND="${SCP} -P $SSH_PORT $TARBALL_NAME"
    COMMAND="$COMMAND ${SSH_USER_HOST}:${LOCAL_DIR}"
  else
    COMMAND="${CP} ${TARBALL_NAME} ${LOCAL_DIR}"
  fi
  exec_command $COMMAND

# Remove directory to avoid mixing old and new data
  COMMAND="cd ${LOCAL_DIR}; rm -rf ${TARBALL_VERSION}"
  SSH_NODE="${LOCAL_NODE}"
  exec_ssh_command $COMMAND

  COMMAND="$TAR xfz ${LOCAL_DIR}/${TARBALL_NAME} -C ${LOCAL_DIR}"
  SSH_NODE="${LOCAL_NODE}"
  exec_ssh_command $COMMAND
}

create_binary_tarballs()
{
#
# Now that we've successfully built the MySQL source code and a potential
# DBT2 source code we'll create compressed tar-files of the binaries for later
# distribution to other dependent nodes, sysbench will always run on the
# client, so no need to build sysbench binaries for distribution.
#
  if test "x${WINDOWS_REMOTE}" != "xyes" ; then
# Verify that pwd works before using it
    exec_command ${CD} ${BIN_INSTALL_DIR}
    MSG="Create compressed tar files of the installed binaries"
    output_msg
    if test "x${USE_DRIZZLE}" = "xyes" ; then
      COMMAND="${TAR} cfz ${DRIZZLE_TARBALL} ${DRIZZLE_VERSION}"
      exec_command ${COMMAND}
    else
      COMMAND="${TAR} cfz ${MYSQL_TARBALL} ${MYSQL_VERSION}"
      exec_command ${COMMAND}
    fi
  fi
}

# $1 is the node specification where to remove remote tarballs
remove_remote_binary_tar_files()
{
  LOCAL_NODE="$1"
  MSG="Remove remote tar files with binaries"
  output_msg
  SSH_NODE="${LOCAL_NODE}"
  if test "x$MYSQL_TARBALL" != "x" ; then
    exec_ssh_command rm ${REMOTE_BIN_INSTALL_DIR}/${MYSQL_TARBALL}
  fi
  if test "x$DRIZZLE_TARBALL" != "x" ; then
    exec_ssh_command rm ${REMOTE_BIN_INSTALL_DIR}/${DRIZZLE_TARBALL}
  fi
}

remove_local_binary_tar_files()
{
  if test "x${MYSQL_TARBALL}" != "x" ; then
    MSG="Remove tar files with binaries"
    output_msg
    exec_command ${RM} ${BIN_INSTALL_DIR}/${MYSQL_TARBALL}
  fi
  if test "x${DRIZZLE_TARBALL}" != "x" ; then
    MSG="Remove tar files with binaries"
    output_msg
    exec_command ${RM} ${BIN_INSTALL_DIR}/${DRIZZLE_TARBALL}
  fi
}

# $1 contains the NODE specification where to install the binaries
remote_install_binaries()
{
  LOCAL_NODE="$1"
  LOCAL_DIR="$REMOTE_BIN_INSTALL_DIR"

  MSG="Install binaries at $LOCAL_NODE in directory $LOCAL_DIR"
  output_msg

  if test "x$MYSQL_TARBALL" != "x" ; then
    install_one_remote_binary ${MYSQL_TARBALL} ${MYSQL_VERSION}
  fi
  if test "x$DRIZZLE_TARBALL" != "x" ; then
    install_one_remote_binary ${DRIZZLE_TARBALL} ${DRIZZLE_VERSION}
  fi
  remove_remote_binary_tar_files ${LOCAL_NODE}
}

set_compiler_flags()
{
#   Compiler directives, which compiler to use and which optimizations
  if test "x${USE_FAST_MYSQL}" = "xyes" ; then
    FAST_FLAG="--fast"
  fi
  if test "x${LINK_TIME_OPTIMIZER_FLAG}" = "xyes" ; then
    LINK_TIME_OPTIMIZER_FLAG="--with-link-time-optimizer"
  fi
  if test "x$COMPILER" != "x" ; then
    COMPILER_FLAG="--compiler=$COMPILER"
  fi
  if test "x$MSO_FLAG" = "xyes" ; then
    MSO_FLAG="--with-mso"
  else
    MSO_FLAG=
  fi
  if test "x$WITH_FAST_MUTEXES_FLAG" = "xyes" ; then
    WITH_FAST_MUTEXES_FLAG="--with-fast-mutexes"
  else
    WITH_FAST_MUTEXES_FLAG=
  fi
  if test "x$WITH_PERFSCHEMA_FLAG" = "xno" ; then
    if test "x$MYSQL_BASE" = "x5.1" ; then
      WITH_PERFSCHEMA_FLAG=
    else
      WITH_PERFSCHEMA_FLAG="--without-perfschema"
    fi
  else
    WITH_PERFSCHEMA_FLAG=
  fi
  if test "x$ENGINE" != "xndb" ; then
    PACKAGE="--package=pro"
  fi
  if test "x$BENCHMARK_TO_RUN" = "xflexAsynch" ; then
    WITH_NDB_TEST_FLAG="--with-flags --with-ndb-test"
  fi
  if test "x$COMPILE_SIZE_FLAG" = "x32" ; then
    COMPILE_SIZE_FLAG="--32"
  elif test "x$COMPILE_SIZE_FLAG" = "x64" ; then
    COMPILE_SIZE_FLAG="--64"
  else
    COMPILE_SIZE_FLAG=
  fi
}

read_autobench_conf()
{
  if test "x${CONFIG_FILE}" = "x" ; then
    ${ECHO} "No autobench.conf provided, cannot continue"
    exit 1
  fi
  ${ECHO} "Sourcing defaults from ${CONFIG_FILE}"
  . ${CONFIG_FILE}
}

write_conf()
{
  if test "x${VERBOSE}" = "xyes" ; then
    ${ECHO} "$*"
  fi
  ${ECHO} "$*" >> ${CONF_FILE}
  if test "x$?" != "x0" ; then
    ${ECHO} "Failed to write $* to ${CONF_FILE}"
    exit 1
  fi
}

remove_generated_files()
{
  CONF_FILE="${DEFAULT_DIR}/iclaustron.conf"
  exec_command ${RM} ${CONF_FILE}

  CONF_FILE="${DEFAULT_DIR}/dbt2.conf"
  exec_command ${RM} ${CONF_FILE}

  if test "x${BENCHMARK_TO_RUN}" = "xdbt2" ; then
    CONF_FILE="${DEFAULT_DIR}/dbt2_run_1.conf"
    exec_command ${RM} ${CONF_FILE}
  fi

  if test "x${BENCHMARK_TO_RUN}" = "xsysbench" ; then
    CONF_FILE="${DEFAULT_DIR}/sysbench.conf"
    exec_command ${RM} ${CONF_FILE}
  fi

  CONF_FILE="${DEFAULT_DIR}/dis_config_c1.ini"
  exec_command ${RM} ${CONF_FILE}
}

write_iclaustron_conf()
{
  MSG="Writing iclaustron.conf"
  output_msg
  CONF_FILE="${DEFAULT_DIR}/iclaustron.conf"
  ${ECHO} "#iClaustron configuration file used to drive start/stop of MySQL programs" \
          > ${CONF_FILE}
  write_conf "MYSQL_PATH_LOCAL=\"${BIN_INSTALL_DIR}/${MYSQL_VERSION}\""
  write_conf "MYSQL_PATH=\"${REMOTE_BIN_INSTALL_DIR}/${MYSQL_VERSION}\""
  write_conf "DRIZZLE_PATH=\"${REMOTE_BIN_INSTALL_DIR}/${DRIZZLE_VERSION}\""
  if test "x$DATA_DIR_BASE" = "x" ; then
    write_conf "DATA_DIR_BASE=\"${DEFAULT_DIR}/data\""
  else
    write_conf "DATA_DIR_BASE=\"${DATA_DIR_BASE}\""
  fi
  if test "x$MALLOC_LIB" != "x" ; then
    write_conf "MALLOC_LIB=\"${MALLOC_LIB}\""
  fi
  if test "x$SUPERSOCKET_LIB" != "x" ; then
    write_conf "SUPERSOCKET_LIB=\"${SUPERSOCKET_LIB}\""
  fi
  if test "x$INFINIBAND_LIB" != "x" ; then
    write_conf "INFINIBAND_LIB=\"${INFINIBAND_LIB}\""
  fi
  if test "x$PERFSCHEMA_FLAG" = "xyes" ; then
    if test "x$MYSQL_BASE" = "x5.6" ; then
      write_conf "PERFSCHEMA_FLAG=\"--performance_schema --performance_schema_instrument='%=on'\""
    else
      write_conf "PERFSCHEMA_FLAG=\"--performance_schema\""
    fi
  else
    if test "x$MYSQL_BASE" = "x5.6" ; then
      write_conf "PERFSCHEMA_FLAG=\"--performance_schema=off\""
    fi
  fi
  if test "x$WINDOWS_REMOTE" = "xyes" ; then
    write_conf "WINDOWS_INSTALL=\"yes\""
  fi
  write_conf "CLUSTER_HOME=\"${CLUSTER_HOME}\""
  write_conf "SERVER_TASKSET=\"${SERVER_TASKSET}\""
  write_conf "USE_INFINIBAND=\"${USE_INFINIBAND}\""
  write_conf "USE_SUPERSOCKET=\"${USE_SUPERSOCKET}\""
  write_conf "LOG_FILE=\"${LOG_FILE}\""
  write_conf "TMP_BASE=\"${TMP_BASE}\""
  write_conf "MYSQL_BASE=\"${MYSQL_BASE}\""
  write_conf "TRANSACTION_ISOLATION=\"${TRANSACTION_ISOLATION}\""
  write_conf "TABLE_CACHE_SIZE=\"${TABLE_CACHE_SIZE}\""
  write_conf "TABLE_CACHE_INSTANCES=\"${TABLE_CACHE_INSTANCES}\""
  write_conf "USE_LARGE_PAGES=\"${USE_LARGE_PAGES}\""
  write_conf "LOCK_ALL=\"${LOCK_ALL}\""
  write_conf "USE_BINARY_MYSQL_TARBALL=\"${USE_BINARY_MYSQL_TARBALL}\""

  write_conf "ENGINE=\"${ENGINE}\""
  if test "x${ENGINE}" = "xinnodb" ; then
    write_conf "INNODB_OPTION=\"--innodb\""
    write_conf "INNODB_BUFFER_POOL_INSTANCES=\"${INNODB_BUFFER_POOL_INSTANCES}\""
    write_conf "INNODB_BUFFER_POOL_SIZE=\"${INNODB_BUFFER_POOL_SIZE}\""
    write_conf "INNODB_READ_IO_THREADS=\"${INNODB_READ_IO_THREADS}\""
    write_conf "INNODB_WRITE_IO_THREADS=\"${INNODB_WRITE_IO_THREADS}\""
    write_conf "INNODB_THREAD_CONCURRENCY=\"${INNODB_THREAD_CONCURRENCY}\""
    write_conf "INNODB_LOG_FILE_SIZE=\"${INNODB_LOG_FILE_SIZE}\""
    write_conf "INNODB_LOG_BUFFER_SIZE=\"${INNODB_LOG_BUFFER_SIZE}\""
    write_conf "INNODB_FLUSH_LOG_AT_TRX_COMMIT=\"${INNODB_FLUSH_LOG_AT_TRX_COMMIT}\""
    write_conf "INNODB_ADAPTIVE_HASH_INDEX=\"${INNODB_ADAPTIVE_HASH_INDEX}\""
    write_conf "INNODB_READ_AHEAD_THRESHOLD=\"${INNODB_READ_AHEAD_THRESHOLD}\""
    write_conf "INNODB_IO_CAPACITY=\"${INNODB_IO_CAPACITY}\""
    write_conf "INNODB_MAX_IO_CAPACITY=\"${INNODB_MAX_IO_CAPACITY}\""
    write_conf "INNODB_LOG_DIR=\"${INNODB_LOG_DIR}\""
    write_conf "INNODB_MAX_PURGE_LAG=\"${INNODB_MAX_PURGE_LAG}\""
    write_conf "INNODB_SUPPORT_XA=\"${INNODB_SUPPORT_XA}\""
    write_conf "INNODB_FLUSH_METHOD=\"${INNODB_FLUSH_METHOD}\""
    write_conf "INNODB_USE_PURGE_THREAD=\"${INNODB_USE_PURGE_THREAD}\""
    write_conf "INNODB_FILE_PER_TABLE=\"${INNODB_FILE_PER_TABLE}\""
    write_conf "INNODB_DIRTY_PAGES_PCT=\"${INNODB_DIRTY_PAGES_PCT}\""
    write_conf "INNODB_OLD_BLOCKS_PCT=\"${INNODB_OLD_BLOCKS_PCT}\""
    write_conf "INNODB_SPIN_WAIT_DELAY=\"${INNODB_SPIN_WAIT_DELAY}\""
    write_conf "INNODB_SYNC_SPIN_LOOPS=\"${INNODB_SYNC_SPIN_LOOPS}\""
    write_conf "INNODB_STATS_ON_METADATA=\"${INNODB_STATS_ON_METADATA}\""
    write_conf "INNODB_STATS_ON_MUTEXES=\"${INNODB_STATS_ON_MUTEXES}\""
    write_conf "INNODB_CHANGE_BUFFERING=\"${INNODB_CHANGE_BUFFERING}\""
    write_conf "INNODB_DOUBLEWRITE=\"${INNODB_DOUBLEWRITE}\""
    write_conf "INNODB_FILE_FORMAT=\"${INNODB_FILE_FORMAT}\""
    write_conf "INNODB_MONITOR=\"${INNODB_MONITOR}\""
    write_conf "INNODB_FLUSH_NEIGHBOURS=\"${INNODB_FLUSH_NEIGHBOURS}\""
  fi

  if test "x${ENGINE}" = "xndb" ; then
    write_conf "NDB_ENABLED=\"yes\""
    NDB_CONFIG_FILE="$DEFAULT_DIR/config_c1.ini"
    write_conf "NDB_CONFIG_FILE=\"${NDB_CONFIG_FILE}\""
    write_conf "USE_NDBMTD=\"${USE_NDBMTD}\""
    write_conf "NDB_MULTI_CONNECTION=\"${NDB_MULTI_CONNECTION}\""

    NUM_NDB_MGMD_NODES="0"
    NDB_MGMD_NODES_LOC=`${ECHO} ${NDB_MGMD_NODES} | ${SED} -e 's!\;! !g'`
    for NDB_MGMD_NODE in $NDB_MGMD_NODES_LOC
    do
      ((NUM_NDB_MGMD_NODES+= 1))
      if test "x$NUM_NDB_MGMD_NODES" = "x1" ; then
        write_conf "NDB_CONNECTSTRING=\"${NDB_MGMD_NODE}:1186\""
      fi
    done
  else
    write_conf "NDB_ENABLED=\"no\""
  fi
  write_conf "USE_MALLOC_LIB=\"${USE_MALLOC_LIB}\""
  write_conf "KEY_BUFFER_SIZE=\"${KEY_BUFFER_SIZE}\""
  write_conf "MAX_HEAP_TABLE_SIZE=\"${MAX_HEAP_TABLE_SIZE}\""
  write_conf "SORT_BUFFER_SIZE=\"${SORT_BUFFER_SIZE}\""
  write_conf "TMP_TABLE_SIZE=\"${TMP_TABLE_SIZE}\""
  write_conf "MAX_TMP_TABLES=\"${MAX_TMP_TABLES}\""
  write_conf "THREADPOOL_SIZE=\"${THREADPOOL_SIZE}\""
  write_conf "THREADPOOL_ALGORITHM=\"${THREADPOOL_ALGORITHM}\""
  write_conf "THREADPOOL_STALL_LIMIT=\"${THREADPOOL_STALL_LIMIT}\""
  write_conf "THREADPOOL_PRIO_KICKUP_TIMER=\"${THREADPOOL_PRIO_KICKUP_TIMER}\""
  write_conf "SSH_PORT=\"${SSH_PORT}\""
  write_conf "MAX_CONNECTIONS=\"${MAX_CONNECTIONS}\""
  write_conf "CORE_FILE_USED=\"${CORE_FILE_USED}\""
  write_conf "BINLOG=\"${BINLOG}\""
  write_conf "SYNC_BINLOG=\"${SYNC_BINLOG}\""
  write_conf "BINLOG_ORDER_COMMITS=\"${BINLOG_ORDER_COMMITS}\""
  write_conf "SLAVE_HOST=\"${SLAVE_HOST}\""
  write_conf "SLAVE_PORT=\"${SLAVE_PORT}\""
  write_conf "RELAY_LOG=\"${RELAY_LOG}\""
}

write_dbt2_conf()
{
  MSG="Writing dbt2.conf"
  output_msg
  export DBT2_DEFAULT_FILE="${DEFAULT_DIR}/dbt2.conf"
  CONF_FILE="${DEFAULT_DIR}/dbt2.conf"
  ${ECHO} "#DBT2 configuration used to drive DBT2 benchmarks" > ${CONF_FILE}
  write_conf "MYSQL_BASE=\"${MYSQL_BASE}\""
  write_conf "DBT2_PATH=\"${SRC_INSTALL_DIR}/${DBT2_VERSION}\""
  write_conf "BASE_DIR=\"${SRC_INSTALL_DIR}/${DBT2_VERSION}\""
  write_conf "DIS_CONFIG_FILE=\"${DEFAULT_DIR}/dis_config_c1.ini\""
  write_conf "MYSQL_VERSION=\"${MYSQL_VERSION}\""
  write_conf "USE_DRIZZLE=\"${USE_DRIZZLE}\""
  write_conf "DBT2_LOADERS=\"${DBT2_LOADERS}\""
  write_conf "DBT2_DATA_DIR=\"${DBT2_DATA_DIR}\""
  write_conf "DBT2_WAREHOUSES=\"${DBT2_WAREHOUSES}\""
  write_conf "DBT2_RESULTS_DIR=\"${DEFAULT_DIR}/dbt2_results\""
  write_conf "DBT2_OUTPUT_DIR=\"${DEFAULT_DIR}/dbt2_output\""
  write_conf "DBT2_LOG_BASE=\"${DEFAULT_DIR}/dbt2_logs\""
  write_conf "DBT2_RUN_CONFIG_FILE=\"${DEFAULT_DIR}/dbt2_run_1.conf\""
  write_conf "DBT2_PARTITION_FLAG=\"${DBT2_PARTITION_FLAG}\""
  write_conf "DBT2_NUM_PARTITIONS=\"${DBT2_NUM_PARTITIONS}\""
  write_conf "DBT2_INTERMEDIATE_TIMER_RESOLUTION=\"${DBT2_INTERMEDIATE_TIMER_RESOLUTION}\""
  write_conf "USING_HASH_FLAG=\"${DBT2_PK_USING_HASH_FLAG}\""
  write_conf "FIRST_CLIENT_PORT=\"${FIRST_CLIENT_PORT}\""
  write_conf "SERVER_HOST=\"${FIRST_SERVER_HOST}\""
  write_conf "SERVER_PORT=\"${FIRST_SERVER_PORT}\""
  write_conf "BETWWEEN_RUNS=\"${BETWEEN_RUNS}\""
  write_conf "AFTER_INITIAL_RUN=\"${AFTER_INITIAL_RUN}\""
  write_conf "AFTER_SERVER_START=\"${AFTER_SERVER_START}\""
  write_conf "BETWEEN_CREATE_DB_TEST=\"${BETWEEN_CREATE_DB_TEST}\""
  write_conf "NUM_CREATE_DB_ATTEMPTS=\"${NUM_CREATE_DB_ATTEMPTS}\""
  write_conf "AFTER_SERVER_STOP=\"${AFTER_SERVER_STOP}\""
  write_conf "TEST_DESCRIPTION=\"${TEST_DESCRIPTION}\""
  write_conf "USE_MALLOC_LIB=\"${USE_MALLOC_LIB}\""
  if test "x$MALLOC_LIB" != "x" ; then
    write_conf "MALLOC_LIB=\"${MALLOC_LIB}\""
  fi
  write_conf "BENCH_TASKSET=\"${BENCH_TASKSET}\""
  write_conf "BENCHMARK_CPUS=\"${BENCHMARK_CPUS}\""
  write_conf "LOG_FILE=\"${LOG_FILE}\""
  write_conf "ENGINE=\"${ENGINE}\""
  if test "x${ENGINE}" = "xinnodb" ; then
    write_conf "STORAGE_ENGINE=\"INNODB\""
  elif test "x${ENGINE}" = "xndb" ; then
    write_conf "STORAGE_ENGINE=\"NDB\""
  elif test "x${ENGINE}" = "myisam" ; then
    write_conf "STORAGE_ENGINE=\"MYISAM\""
  fi
  if test "x${USE_DRIZZLE}" = "xyes" ; then
    write_conf "DRIZZLE_PATH=\"${BIN_INSTALL_DIR}/${DRIZZLE_VERSION}\""
  else
    write_conf "MYSQL_PATH=\"${BIN_INSTALL_DIR}/${MYSQL_VERSION}\""
    write_conf "MYSQL_SOCKET=\"${TMP_BASE}/mysql_1.sock\""
  fi
  if test "x${DBT2_SPREAD}" != "x" ; then
    DBT2_SPREAD="--spread ${DBT2_SPREAD}"
  fi
  if test "x${DBT2_SCI}" != "x" ; then
    DBT2_SCI="--sci"
  fi
  if test "x${BENCHMARK_TO_RUN}" = "xdbt2" ; then
    write_conf "DBT2_NUM_SERVERS=\"${DBT2_NUM_SERVERS}\""
    write_conf "DBT2_SCI=\"${DBT2_SCI}\""
    write_conf "DBT2_SPREAD=\"${DBT2_SPREAD}\""
    write_conf "DBT2_TIME=\"${DBT2_TIME}\""
    write_conf "NUM_MYSQL_SERVERS=\"${NUM_MYSQL_SERVERS}\""
    write_conf "USE_MYISAM_FOR_ITEM=\"${USE_MYISAM_FOR_ITEM}\""
    CONF_FILE="${DEFAULT_DIR}/dbt2_run_1.conf"
    if ! test -f $CONF_FILE ; then
      ${ECHO} "#DBT2 run configuration, number of servers, wares and terminals" > ${CONF_FILE}
      DBT2_RUN_WAREHOUSES=`${ECHO} ${DBT2_RUN_WAREHOUSES} | ${SED} -e 's!\;! !g'`
      write_conf "#NUM_SERVERS NUM_WAREHOUSES NUM_TERMINALS"
      for RUN_WAREHOUSES in ${DBT2_RUN_WAREHOUSES}
      do
        if test ${RUN_WAREHOUSES} -gt ${DBT2_WAREHOUSES} ; then
          ${ECHO} "Not allowed to use more in DBT2_RUN_WAREHOUSES than DBT2_WAREHOUSES"
          exit 1
        fi
        CONFIG_LINE="1 ${RUN_WAREHOUSES} ${DBT2_TERMINALS}"
        write_conf ${CONFIG_LINE}
      done
    fi
  else
    write_conf "FLEX_ASYNCH_API_NODES=\"${FLEX_ASYNCH_API_NODES}\""
    write_conf "FLEX_ASYNCH_NUM_THREADS=\"${FLEX_ASYNCH_NUM_THREADS}\""
    write_conf "FLEX_ASYNCH_NUM_PARALLELISM=\"${FLEX_ASYNCH_NUM_PARALLELISM}\""
    write_conf "FLEX_ASYNCH_NUM_OPS_PER_TRANS=\"${FLEX_ASYNCH_NUM_OPS_PER_TRANS}\""
    write_conf "FLEX_ASYNCH_EXECUTION_ROUNDS=\"${FLEX_ASYNCH_EXECUTION_ROUNDS}\""
    write_conf "FLEX_ASYNCH_NUM_ATTRIBUTES=\"${FLEX_ASYNCH_NUM_ATTRIBUTES}\""
    write_conf "FLEX_ASYNCH_ATTRIBUTE_SIZE=\"${FLEX_ASYNCH_ATTRIBUTE_SIZE}\""
    write_conf "FLEX_ASYNCH_NO_LOGGING=\"${FLEX_ASYNCH_NO_LOGGING}\""
    write_conf "FLEX_ASYNCH_FORCE_FLAG=\"${FLEX_ASYNCH_FORCE_FLAG}\""
    write_conf "FLEX_ASYNCH_USE_WRITE=\"${FLEX_ASYNCH_USE_WRITE}\""
    write_conf "FLEX_ASYNCH_USE_LOCAL=\"${FLEX_ASYNCH_USE_LOCAL}\""
    write_conf "FLEX_ASYNCH_NUM_MULTI_CONNECTIONS=\"${FLEX_ASYNCH_NUM_MULTI_CONNECTIONS}\""
    write_conf "FLEX_ASYNCH_WARMUP_TIMER=\"${FLEX_ASYNCH_WARMUP_TIMER}\""
    write_conf "FLEX_ASYNCH_EXECUTION_TIMER=\"${FLEX_ASYNCH_EXECUTION_TIMER}\""
    write_conf "FLEX_ASYNCH_COOLDOWN_TIMER=\"${FLEX_ASYNCH_COOLDOWN_TIMER}\""
    write_conf "FLEX_ASYNCH_NEW=\"${FLEX_ASYNCH_NEW}\""
    write_conf "FLEX_ASYNCH_DEF_THREADS=\"${FLEX_ASYNCH_DEF_THREADS}\""
    CONF_FILE="${DEFAULT_DIR}/dbt2_run_1.conf"
    write_conf "#Empty set of MySQL Servers to start"
  fi
}

write_sysbench_conf()
{
  MSG="Writing sysbench.conf"
  output_msg
  CONF_FILE="${DEFAULT_DIR}/sysbench.conf"
  ${ECHO} "#Sysbench configuration used to drive sysbench benchmarks" > ${CONF_FILE}
  write_conf "MYSQL_BASE=\"${MYSQL_BASE}\""
  write_conf "SYSBENCH=\"${BIN_INSTALL_DIR}/${SYSBENCH_VERSION}/bin/sysbench\""
  write_conf "DBT2_PATH=\"${SRC_INSTALL_DIR}/${DBT2_VERSION}\""
  write_conf "USE_DRIZZLE=\"${USE_DRIZZLE}\""
  write_conf "SERVER_HOST=\"${FIRST_SERVER_HOST}\""
  write_conf "SERVER_PORT=\"${SERVER_PORT}\""
  if test "x${USE_DRIZZLE}" = "xyes" ; then
    write_conf "DRIZZLE_PATH=\"${BIN_INSTALL_DIR}/${DRIZZLE_VERSION}\""
  else
    write_conf "MYSQL_PATH=\"${BIN_INSTALL_DIR}/${MYSQL_VERSION}\""
    write_conf "MYSQL_SOCKET=\"${TMP_BASE}/mysql_1.sock\""
  fi
  write_conf "RUN_RW=\"${RUN_RW}\""
  write_conf "RUN_RW_WRITE_INT=\"${RUN_RW_WRITE_INT}\""
  write_conf "RUN_RW_LESS_READ=\"${RUN_RW_LESS_READ}\""
  write_conf "RUN_RO=\"${RUN_RO}\""
  write_conf "RUN_WRITE=\"${RUN_WRITE}\""
  write_conf "SB_USE_SECONDARY_INDEX=\"${SB_USE_SECONDARY_INDEX}\""
  write_conf "SB_USE_MYSQL_HANDLER=\"${SB_USE_MYSQL_HANDLER}\""
  write_conf "SB_NUM_PARTITIONS=\"${SB_NUM_PARTITIONS}\""
  write_conf "SB_NUM_TABLES=\"${SB_NUM_TABLES}\""
  write_conf "THREAD_COUNTS_TO_RUN=\"${THREAD_COUNTS_TO_RUN}\""
  write_conf "ENGINE=\"${ENGINE}\""
  write_conf "SB_AVOID_DEADLOCKS=\"${SB_AVOID_DEADLOCKS}\""
  if test "x$ENGINE" = "xndb" ; then
    TRX_ENGINE="yes"
  fi
  if test "x$ENGINE" = "xinnodb" ; then
    TRX_ENGINE="yes"
  fi
  if test "x$ENGINE" = "xmyisam" ; then
    TRX_ENGINE="no"
  fi
  if test "x$ENGINE" = "xheap" ; then
    TRX_ENGINE="no"
  fi
  if test "x$ENGINE" = "xmemory" ; then
    TRX_ENGINE="no"
  fi
  if test "x$SB_USE_TRX" = "x" ; then
    SB_USE_TRX="$TRX_ENGINE"
  fi
  write_conf "SB_USE_TRX=\"${SB_USE_TRX}\""
  write_conf "SB_DIST_TYPE=\"${SB_DIST_TYPE}\""
  write_conf "TRX_ENGINE=\"${TRX_ENGINE}\""
  if test "x$SB_USE_AUTO_INC" = "xyes" ; then
    SB_USE_AUTO_INC="on"
  else
    SB_USE_AUTO_INC="off"
  fi
  write_conf "SB_USE_AUTO_INC=\"${SB_USE_AUTO_INC}\""
  write_conf "MAX_TIME=\"${MAX_TIME}\""
  write_conf "NUM_TEST_RUNS=\"${NUM_TEST_RUNS}\""
  write_conf "SB_TX_RATE=\"${SB_TX_RATE}\""
  write_conf "SB_TX_JITTER=\"${SB_TX_JITTER}\""
  write_conf "SYSBENCH_ROWS=\"${SYSBENCH_ROWS}\""
  write_conf "TEST_DESCRIPTION=\"${TEST_DESCRIPTION}\""
  write_conf "USE_MALLOC_LIB=\"${USE_MALLOC_LIB}\""
  if test "x$MALLOC_LIB" != "x" ; then
    write_conf "MALLOC_LIB=\"${MALLOC_LIB}\""
  fi
  write_conf "BENCH_TASKSET=\"${BENCH_TASKSET}\""
  write_conf "BENCHMARK_CPUS=\"${BENCHMARK_CPUS}\""
  write_conf "BETWWEEN_RUNS=\"${BETWEEN_RUNS}\""
  write_conf "AFTER_INITIAL_RUN=\"${AFTER_INITIAL_RUN}\""
  write_conf "AFTER_SERVER_START=\"${AFTER_SERVER_START}\""
  write_conf "BETWEEN_CREATE_DB_TEST=\"${BETWEEN_CREATE_DB_TEST}\""
  write_conf "NUM_CREATE_DB_ATTEMPTS=\"${NUM_CREATE_DB_ATTEMPTS}\""
  write_conf "AFTER_SERVER_STOP=\"${AFTER_SERVER_STOP}\""
  write_conf "LOG_FILE=\"${LOG_FILE}\""
  if test "x${MYSQL_CREATE_OPTIONS}" != "x" ; then
    write_conf "MYSQL_CREATE_OPTIONS=\"${MYSQL_CREATE_OPTIONS}\""
  fi
}

add_remote_node()
{
  LOCAL_ADD_NODE="$1"
  LOCAL_FLAG="0"
  for LOCAL_NODE in $REMOTE_NODES
  do
    if test "x$LOCAL_NODE" = "x$LOCAL_ADD_NODE" ; then
      LOCAL_FLAG="1"
    fi
  done
  if test "x$LOCAL_FLAG" = "x0" ; then
    ${ECHO} "Added $LOCAL_ADD_NODE to list of remote nodes"
    REMOTE_NODES="$REMOTE_NODES $LOCAL_ADD_NODE"
  fi
}

write_dis_config_ini()
{
  MSG="Writing dis_config_c1.ini"
  output_msg
  CONF_FILE="${DEFAULT_DIR}/dis_config_c1.ini"
  ${ECHO} "#NODE_ID NODE_TYPE HOSTNAME PORT FLAGS" > ${CONF_FILE}
  if test "x${ENGINE}" = "xndb" ; then
    NODEID="0"
    NUM_NDB_MGMD_NODES="0"
    NDB_MGMD_NODES=`${ECHO} ${NDB_MGMD_NODES} | ${SED} -e 's!\;! !g'`
    for NDB_MGMD_NODE in $NDB_MGMD_NODES
    do
      ((NODEID+= 1))
      ((NUM_NDB_MGMD_NODES+= 1))
      CONFIG_LINE="$NODEID NDB_MGMD  $NDB_MGMD_NODE 0"
      write_conf $CONFIG_LINE
      add_remote_node $NDB_MGMD_NODE
    done
    NDBD_NODES=`${ECHO} ${NDBD_NODES} | ${SED} -e 's!\;! !g'`
    NUM_NDBD_NODES="0"
    for NDBD_NODE in $NDBD_NODES
    do
      ((NODEID+= 1))
      ((NUM_NDBD_NODES+= 1))
      CONFIG_LINE="$NODEID NDBD      $NDBD_NODE 0"
      write_conf $CONFIG_LINE
      add_remote_node $NDBD_NODE
    done
    if test "x$BENCHMARK_TO_RUN" != "xflexAsynch" ; then
      SERVER_HOST=`${ECHO} ${SERVER_HOST} | ${SED} -e 's!\;! !g'`
      NUM_MYSQL_SERVERS="0"
      for MYSQL_SERVER in $SERVER_HOST
      do
        MYSQL_SERVER_HOST[$NUM_MYSQL_SERVERS]=${MYSQL_SERVER}
        ((NUM_MYSQL_SERVERS+= 1))
      done
      SERVER_PORT=`${ECHO} ${SERVER_PORT} | ${SED} -e 's!\;! !g'`
      NUM_PORTS="0"
      for PORT_NUMBER in $SERVER_PORT
      do
        MYSQL_SERVER_PORT[$NUM_PORTS]=${PORT_NUMBER}
        ((NUM_PORTS+=1))
      done
      if test "x${NUM_PORTS}" = "x1" ; then
        for ((i= 0; i < $NUM_MYSQL_SERVERS ; i += 1))
        do
          MYSQL_SERVER_PORT[${i}]=${PORT_NUMBER}
        done
      else
        if test "x$NUM_PORTS" != "x$NUM_MYSQL_SERVERS" ; then
          echo "Error number of SERVER_PORT's must be either 1 or same as number of SERVER_HOST's"
          exit 1
        fi
      fi
      if test "x$SERVER_CPUS" != "x" ; then
        SERVER_CPUS=`${ECHO} ${SERVER_CPUS} | ${SED} -e 's!\;! !g'`
        NUM_CPU_SETS="0"
        for CPU_SET in $SERVER_CPUS
        do
          MYSQL_SERVER_CPUS[${NUM_CPU_SETS}]=${CPU_SET}
          ((NUM_CPU_SETS+=1))
        done 
        if test "x$NUM_CPU_SETS" = "x1" ; then
          for ((i= 0; i < $NUM_MYSQL_SERVERS ; i += 1))
          do
            MYSQL_SERVER_CPUS[${i}]=$CPU_SET
          done
        else
          if test "x$NUM_CPU_SETS" != "x$NUM_MYSQL_SERVERS" ; then
            echo "Error number of SERVER_CPUS's must be either 1 or same as number of SERVER_HOST's"
            exit 1
          fi
        fi
      fi
      INDEX="0"
      for MYSQL_SERVER in $SERVER_HOST
      do
        ((NODEID+= 1))
        if test "x${USE_DRIZZLE}" = "xyes" ; then
          CONFIG_LINE="$NODEID       DRIZZLED   "
        else
          CONFIG_LINE="$NODEID       MYSQLD   "
        fi
        CONFIG_LINE="$CONFIG_LINE ${MYSQL_SERVER_HOST[${INDEX}]}"
        CONFIG_LINE="$CONFIG_LINE ${MYSQL_SERVER_PORT[${INDEX}]}"
        if test "x${SERVER_CPUS}" != "x" ; then
          CONFIG_LINE="${CONFIG_LINE} --taskset ${MYSQL_SERVER_CPUS[${INDEX}]}"
        fi
        write_conf $CONFIG_LINE
        add_remote_node ${MYSQL_SERVER_HOST[${INDEX}]}
        ((INDEX+=1))
      done
    fi
# Also write NDB configuration file
    CONF_FILE="${DEFAULT_DIR}/config_c1.ini"
    echo "#Auto-generated config" > $CONF_FILE
    CONFIG_LINE="[TCP DEFAULT]"
    write_conf $CONFIG_LINE
    CONFIG_LINE="SendBufferMemory=$NDB_SEND_BUFFER_MEMORY"
    write_conf $CONFIG_LINE
    CONFIG_LINE="TCP_SND_BUF_SIZE=$NDB_TCP_SEND_BUFFER_MEMORY"
    write_conf $CONFIG_LINE
    CONFIG_LINE="TCP_RCV_BUF_SIZE=$NDB_TCP_RECEIVE_BUFFER_MEMORY"
    write_conf $CONFIG_LINE

    CONFIG_LINE="[MYSQLD DEFAULT]"
    write_conf $CONFIG_LINE
    CONFIG_LINE="BatchSize=128"
    write_conf $CONFIG_LINE
    CONFIG_LINE="DefaultOperationRedoProblemAction=queue"
    write_conf $CONFIG_LINE

    CONFIG_LINE="[NDBD DEFAULT]"
    write_conf $CONFIG_LINE
    CONFIG_LINE="BatchSizePerLocalScan=128"
    write_conf $CONFIG_LINE
    CONFIG_LINE="MaxNoOfConcurrentTransactions=$NDB_MAX_NO_OF_CONCURRENT_TRANSACTIONS"
    write_conf $CONFIG_LINE
    CONFIG_LINE="MaxNoOfConcurrentOperations=$NDB_MAX_NO_OF_CONCURRENT_OPERATIONS"
    write_conf $CONFIG_LINE
    CONFIG_LINE="MaxNoOfConcurrentScans=$NDB_MAX_NO_OF_CONCURRENT_SCANS"
    write_conf $CONFIG_LINE
    CONFIG_LINE="MaxNoOfLocalScans=$NDB_MAX_NO_OF_LOCAL_SCANS"
    write_conf $CONFIG_LINE
    CONFIG_LINE="NoOfFragmentLogFiles=$NDB_NO_OF_FRAGMENT_LOG_FILES"
    write_conf $CONFIG_LINE
    CONFIG_LINE="FragmentLogFileSize=256M"
    write_conf $CONFIG_LINE
    CONFIG_LINE="DiskSyncSize=16M"
    write_conf $CONFIG_LINE
    CONFIG_LINE="DiskCheckpointSpeed=$DISK_CHECKPOINT_SPEED"
    write_conf $CONFIG_LINE
    CONFIG_LINE="DiskCheckpointSpeedInRestart=100M"
    write_conf $CONFIG_LINE
    CONFIG_LINE="DataDir=$DATA_DIR_BASE/ndb"
    write_conf $CONFIG_LINE
    CONFIG_LINE="RedoBuffer=$NDB_REDO_BUFFER"
    write_conf $CONFIG_LINE
    CONFIG_LINE="TransactionDeadlockDetectionTimeout=10000"
    write_conf $CONFIG_LINE
    CONFIG_LINE="LongMessageBuffer=32M"
    write_conf $CONFIG_LINE
    CONFIG_LINE="InitFragmentLogFiles=full"
    write_conf $CONFIG_LINE
    CONFIG_LINE="RedoOverCommitLimit=45"
    write_conf $CONFIG_LINE
    if test "x$NDB_DISKLESS" = "xyes" ; then
      CONFIG_LINE="Diskless=1"
      write_conf $CONFIG_LINE
    fi
    if test "x$USE_NDB_O_DIRECT" = "xyes" ; then
      CONFIG_LINE="ODirect=1"
      write_conf $CONFIG_LINE
    fi
    if test "x$NDB_DISK_IO_THREADPOOL" != "x" ; then
      CONFIG_LINE="DiskIOThreadPool=$NDB_DISK_IO_THREADPOOL"
      write_conf $CONFIG_LINE
    fi
    if test "x$MYSQL_BASE" = "x5.5" || test "x$MYSQL_BASE" = "x5.6" ; then
      CONFIG_LINE="ExtraSendBufferMemory=$NDB_EXTRA_SEND_BUFFER_MEMORY"
      write_conf $CONFIG_LINE
      if test "x$NDB_NO_OF_FRAGMENT_LOG_PARTS" != "x" ; then
        CONFIG_LINE="NoOfFragmentLogParts=$NDB_NO_OF_FRAGMENT_LOG_PARTS"
        write_conf $CONFIG_LINE
      fi
    fi
    CONFIG_LINE="NoOfReplicas=$NDB_REPLICAS"
    write_conf $CONFIG_LINE
    CONFIG_LINE="DataMemory=$NDB_DATA_MEMORY"
    write_conf $CONFIG_LINE
    CONFIG_LINE="IndexMemory=$NDB_INDEX_MEMORY"
    write_conf $CONFIG_LINE

    NODEID="0"
    for NDB_MGMD_NODE in $NDB_MGMD_NODES
    do
      ((NODEID+= 1))
      CONFIG_LINE="[NDB_MGMD]"
      write_conf $CONFIG_LINE
      CONFIG_LINE="DataDir=$DATA_DIR_BASE/ndb"
      write_conf $CONFIG_LINE
      CONFIG_LINE="HostName=$NDB_MGMD_NODE"
      write_conf $CONFIG_LINE
      CONFIG_LINE="PortNumber=1186"
      write_conf $CONFIG_LINE
      CONFIG_LINE="NodeId=$NODEID"
      write_conf $CONFIG_LINE
    done

    NUM_NDB_NODES="0"
    for NDBD_NODE in $NDBD_NODES
    do
      ((NUM_NDB_NODES+= 1))
    done
    if test "x${NDB_EXECUTE_CPU}" != "x" ; then
      NDB_EXECUTE_CPU_LOC=(`${ECHO} ${NDB_EXECUTE_CPU} | ${SED} -e 's!\;! !g'`)
      if test "x${#NDB_EXECUTE_CPU_LOC[*]}" = "x1" ; then
        for ((i = 0; i < NUM_NDB_NODES; i += 1))
        do
          NDB_EXECUTE_CPU_LOC[${i}]=$NDB_EXECUTE_CPU
        done
      else
        if test "x${#NDB_EXECUTE_CPU_LOC[*]}" != "x$NUM_NDB_NODES" ; then
          echo "NDB_EXECUTE_CPU need as many parameters as there are NDB nodes or 1 parameter"
          exit 1
        fi
      fi
    fi
    if test "x${NDB_MAINT_CPU}" != "x" ; then
      NDB_MAINT_CPU_LOC=(`${ECHO} ${NDB_MAINT_CPU} | ${SED} -e 's!\;! !g'`)
      if test "x${#NDB_MAINT_CPU_LOC[*]}" = "x1" ; then
        for ((i = 0; i < NUM_NDB_NODES; i += 1))
        do
          NDB_MAINT_CPU_LOC[${i}]=$NDB_MAINT_CPU
        done
      else
        if test "x${#NDB_MAINT_CPU_LOC[*]}" != "x$NUM_NDB_NODES" ; then
          echo "NDB_MAINT_CPU need as many parameters as there are NDB nodes or 1 parameter"
          exit 1
        fi
      fi
    fi
    if test "x${NDB_THREAD_CONFIG}" != "x" ; then
      NDB_THREAD_CONFIG_LOC=(`${ECHO} ${NDB_THREAD_CONFIG} | ${SED} -e 's!\;! !g'`)
      if test "x${#NDB_THREAD_CONFIG_LOC[*]}" = "x1" ; then
        for ((i = 0; i < NUM_NDB_NODES; i += 1))
        do
          NDB_THREAD_CONFIG_LOC[${i}]=${NDB_THREAD_CONFIG}
        done
      else
        if test "x${#NDB_THREAD_CONFIG_LOC[*]}" != "x$NUM_NDB_NODES" ; then
          echo "NDB_THREAD_CONFIG need as many parameters as there are NDB nodes or 1 parameter"
          exit 1
        fi
      fi
    fi
    if test "x${NDB_MAX_NO_OF_EXECUTION_THREADS}" != "x" ; then
      NDB_MAX_NO_OF_EXECUTION_THREADS_LOC=(`${ECHO} ${NDB_MAX_NO_OF_EXECUTION_THREADS} | ${SED} -e 's!\;! !g'`)
      if test "x${#NDB_MAX_NO_OF_EXECUTION_THREADS_LOC[*]}" = "x1" ; then
        for ((i = 0; i < NUM_NDB_NODES; i += 1))
        do
          NDB_MAX_NO_OF_EXECUTION_THREADS_LOC[${i}]=$NDB_MAX_NO_OF_EXECUTION_THREADS
        done
      else
        if test "x${#NDB_MAX_NO_OF_EXECUTION_THREADS_LOC[*]}" != "x$NUM_NDB_NODES" ; then
          echo "NDB_MAX_NO_OF_EXECUTION_THREADS need as many parameters as there are NDB nodes or 1 parameter"
          exit 1
        fi
      fi
    fi
    INDEX="0"
    for NDBD_NODE in $NDBD_NODES
    do
      ((NODEID+= 1))
      CONFIG_LINE="[NDBD]"
      write_conf $CONFIG_LINE
      CONFIG_LINE="NodeId=$NODEID"
      write_conf $CONFIG_LINE
      if test "x${NDB_EXECUTE_CPU}" != "x" ; then
        CONFIG_LINE="LockExecuteThreadToCPU=${NDB_EXECUTE_CPU_LOC[${INDEX}]}"
        write_conf $CONFIG_LINE
      fi
      if test "x${NDB_MAINT_CPU}" != "x" ; then
        CONFIG_LINE="LockMaintThreadsToCPU=${NDB_MAINT_CPU_LOC[${INDEX}]}"
        write_conf $CONFIG_LINE
      fi
      if test "x$USE_NDBMTD" != "x" ; then
        if test "x${NDB_MAX_NO_OF_EXECUTION_THREADS}" != "x" ; then
          CONFIG_LINE="MaxNoOfExecutionThreads=${NDB_MAX_NO_OF_EXECUTION_THREADS_LOC[${INDEX}]}"
          write_conf $CONFIG_LINE
        fi
        if test "x$NDB_THREAD_CONFIG" != "x" ; then
          CONFIG_LINE="ThreadConfig=${NDB_THREAD_CONFIG_LOC[${INDEX}]}"
          write_conf $CONFIG_LINE
        fi
      fi
      if test "x${NDB_REALTIME_SCHEDULER}" = "xyes" ; then
        CONFIG_LINE="RealtimeScheduler=1"
        write_conf $CONFIG_LINE
      fi
      CONFIG_LINE="HostName=$NDBD_NODE"
      write_conf $CONFIG_LINE
      ((INDEX+= 1))
    done

    if test "x$BENCHMARK_TO_RUN" = "xflexAsynch" ; then
      FLEX_API_HOSTS=`$ECHO $FLEX_ASYNCH_API_NODES | $SED -e 's!\;! !g'`
      for LOCAL_API_NODE in $FLEX_API_HOSTS
      do
        CONFIG_LINE="[MYSQLD]"
        if test "x${FLEX_ASYNCH_NUM_MULTI_CONNECTIONS}" = "x" ; then
          write_conf $CONFIG_LINE
        else
          for ((i = 0; i < FLEX_ASYNCH_NUM_MULTI_CONNECTIONS; i += 1))
          do
            write_conf $CONFIG_LINE
          done
        fi
      done
    else
      for MYSQL_SERVER in $SERVER_HOST
      do
        ((NODEID+= 1))
        CONFIG_LINE="[MYSQLD]"
        if test "x${NDB_MULTI_CONNECTION}" = "x" ; then
          write_conf $CONFIG_LINE
          CONFIG_LINE="NodeId=$NODEID"
          write_conf $CONFIG_LINE
        else
          for ((i = 0; i < NDB_MULTI_CONNECTION; i += 1))
          do
            write_conf $CONFIG_LINE
          done
        fi
      done
    fi
    #Provide an extra API node id for debug usage
    CONFIG_LINE="[MYSQLD]"
    write_conf $CONFIG_LINE
  else
# Non-NDB storage engine => 1 MySQL Server only, no other nodes"
    if test "x${USE_DRIZZLE}" = "xyes" ; then
      CONFIG_LINE="1       DRIZZLED   "
    else
      CONFIG_LINE="1       MYSQLD   "
    fi
    CONFIG_LINE="${CONFIG_LINE} ${SERVER_HOST}"
    CONFIG_LINE="${CONFIG_LINE} ${SERVER_PORT}"
    write_conf ${CONFIG_LINE}
    add_remote_node ${SERVER_HOST}
    if test "x$SLAVE_HOST" != "x" ; then
#We run with replication enabled, so need a slave host as well
      CONFIG_LINE="2       MYSQLD_SLAVE   "
      CONFIG_LINE="${CONFIG_LINE} ${SLAVE_HOST}"
      CONFIG_LINE="${CONFIG_LINE} ${SLAVE_PORT}"
      write_conf ${CONFIG_LINE}
      add_remote_node ${SLAVE_HOST}
    fi
  fi
}

set_up_taskset()
{
#Set-up SERVER_TASKSET
  if test "x$SERVER_TASKSET" = "x" ; then
    SERVER_TASKSET="$TASKSET"
  fi
  if test "x${SERVER_TASKSET}" != "x" ; then
    if test "x${SERVER_TASKSET}" = "xtaskset" ; then
      if test "x${SERVER_CPUS}" != "x" ; then
        SERVER_TASKSET="${SERVER_TASKSET} ${SERVER_CPUS}"
      fi
    elif test "x${SERVER_TASKSET}" = "xnumactl" ; then
#Set-up TASKSET variable properly for start_ndb.sh-script
      if test "x${SERVER_BIND}" != "x" ; then
        if test "x${SERVER_MEM_POLICY}" = "xinterleaved" ; then
          SERVER_TASKSET="${SERVER_TASKSET} --interleave=${SERVER_BIND}"
        else
          SERVER_TASKSET="${SERVER_TASKSET} --membind=${SERVER_BIND}"
        fi
        if test "x${SERVER_CPUS}" != "x" ; then
          SERVER_TASKSET="${SERVER_TASKSET} --physcpubind=${SERVER_CPUS}"
        else
          SERVER_TASKSET="${SERVER_TASKSET} --cpunodebind=${SERVER_BIND}"
        fi
      fi
    else
      echo "TASKSET supports taskset and numactl only at the moment"
      exit 1
    fi
  fi

#Set-up BENCH_TASKSET
  if test "x$BENCH_TASKSET" = "x" ; then
    BENCH_TASKSET="$TASKSET"
  fi
  if test "x${BENCH_TASKSET}" != "x" && \
     test "x$BENCHMARK_TO_RUN" = "xsysbench" ; then
    if test "x${BENCH_TASKSET}" = "xtaskset" ; then
      if test "x${BENCHMARK_CPUS}" != "x" ; then
        BENCH_TASKSET="${BENCH_TASKSET} ${BENCHMARK_CPUS}"
      fi
    elif test "x${BENCH_TASKSET}" = "xnumactl" ; then
#Set-up TASKSET variable properly for start_ndb.sh-script
      if test "x${BENCHMARK_BIND}" != "x" ; then
        if test "x${SERVER_MEM_POLICY}" = "xinterleaved" ; then
          BENCH_TASKSET="${BENCH_TASKSET} --interleave=${BENCHMARK_BIND}"
        else
          BENCH_TASKSET="${BENCH_TASKSET} --membind=${BENCHMARK_BIND}"
        fi
        if test "x${BENCHMARK_CPUS}" != "x" ; then
          BENCH_TASKSET="${BENCH_TASKSET} --physcpubind=${BENCHMARK_CPUS}"
        else
          BENCH_TASKSET="${BENCH_TASKSET} --cpunodebind=${BENCHMARK_BIND}"
        fi
      fi
    else
      echo "TASKSET supports taskset and numactl only at the moment"
      exit 1
    fi
  fi
}

clean_up_local_src()
{
  exec_command ${RM} -rf ${SRC_INSTALL_DIR}
}

clean_up_local_bin()
{
  exec_command ${RM} -rf ${BIN_INSTALL_DIR}
}

kill_nodes()
{
  IGNORE_FAILURE="yes"
  SSH_NODE="$1"
  exec_ssh_command killall -q flexAsynch mysqld ndbd ndbmtd ndb_mgm ndb_mgmd
}
  
init_clean_up()
{
  SSH_NODE="$1"
  exec_ssh_command rm -rf ${DATA_DIR_BASE}/ndb
  exec_ssh_command rm -rf ${DATA_DIR_BASE}/mysql-cluster
  exec_ssh_command rm -rf ${DATA_DIR_BASE}/var*
}

clean_up_remote_bin()
{
  SSH_NODE="$1"
  COMMAND="cd ${REMOTE_BIN_INSTALL_DIR} &&"
  if test "x${USE_DRIZZLE}" = "xyes" ; then
    COMMAND="${COMMAND} rm -rf ${DRIZZLE_VERSION}"
  else
    COMMAND="${COMMAND} rm -rf ${MYSQL_VERSION}"
  fi
  exec_ssh_command $COMMAND
  init_clean_up ${SSH_NODE}
}

clean_up_output()
{
  exec_command ${RM} -rf ${DEFAULT_DIR}/dbt2_output
}

set_first_server_host()
{
  FIRST_SERVER_HOST=
  for LOC_SERVER_HOST in ${SERVER_HOST}
  do
    if test "x$FIRST_SERVER_HOST" = "x" ; then
      FIRST_SERVER_HOST="$LOC_SERVER_HOST"
    fi
  done
}

set_first_server_port()
{
  FIRST_SERVER_PORT=
  for LOC_SERVER_PORT in ${SERVER_PORT}
  do
    if test "x$FIRST_SERVER_PORT" = "x" ; then
      FIRST_SERVER_PORT="$LOC_SERVER_PORT"
    fi
  done
}

PWD=pwd
CD=cd
RM=rm
SCP=scp
MKDIR=mkdir
SSH=ssh
TAR=
ECHO=echo
CP=cp
SED=sed
MAKE=

#Sleep parameters for sysbench
BETWEEN_RUNS="25"             # Time between runs to avoid checkpoints
AFTER_INITIAL_RUN="30"        # Time after initial run
AFTER_SERVER_START="60"       # Wait for MySQL Server to start
BETWEEN_CREATE_DB_TEST="15"   # Time between each attempt to create DB
NUM_CREATE_DB_ATTEMPTS="12"   # Max number of attempts before giving up
AFTER_SERVER_STOP="30"        # Time to wait after stopping MySQL Server

#Parameters normally configured for sysbench/iclaustron
NUM_TEST_RUNS="1" # Number of loops to run tests in
MAX_TIME="260"    # Time to run each test
ENGINE="innodb"   # Engine used to run test
THREAD_COUNTS_TO_RUN="16;32;64;128;256" #Thread counts to use in runs

#Which tests should we run, default is to run all of them (sysbench)
RUN_RW="yes"             # Run Sysbench RW test or not
RUN_RO="no"              # Run Sysbench RO test
RUN_RW_WRITE_INT="no"    # Run Write Intensive RW test or not
RUN_RW_RW_LESS_READ="no" # Run RW test with less read or not
RUN_WRITE="no"           # Run Sysbench Write test

#NDB Default Config values
NDB_MAX_NO_OF_CONCURRENT_TRANSACTIONS="65536"
NDB_MAX_NO_OF_CONCURRENT_OPERATIONS="131072"
NDB_MAX_NO_OF_CONCURRENT_SCANS="500"
NDB_MAX_NO_OF_LOCAL_SCANS="8000"
NDB_NO_OF_FRAGMENT_LOG_FILES="15"
DISK_CHECKPOINT_SPEED="10M"
NDB_REPLICAS="2"
NDB_DATA_MEMORY="3G"
NDB_INDEX_MEMORY="300M"
USE_NDBMTD="yes"
NDB_EXECUTE_CPU=
NDB_MAINT_CPU=
NDB_EXTRA_SEND_BUFFER_MEMORY="16M"
NDB_SEND_BUFFER_MEMORY="2M"
NDB_TCP_SEND_BUFFER_MEMORY="256k"
NDB_TCP_RECEIVE_BUFFER_MEMORY="256k"
NDB_REDO_BUFFER="64M"
NDB_THREAD_CONFIG=
NDB_MAX_NO_OF_EXECUTION_THREADS=""
NDB_REALTIME_SCHEDULER=
CLUSTER_HOME=
NDB_DISK_IO_THREADPOOL=
NDB_NO_OF_FRAGMENT_LOG_PARTS=
USE_NDB_O_DIRECT=
CORE_FILE_USED="no"

#Sysbench parameters
SB_USE_SECONDARY_INDEX="no" # Use secondary index in Sysbench test
SB_USE_MYSQL_HANDLER="no" # Use MySQL Handler statements for point selects
SB_NUM_PARTITIONS="0"    # Number of partitions to use in Sysbench test table
SB_NUM_TABLES="1"        # Number of test tables
SB_USE_FAST_GCC="yes"    # If set to "y" will use -O3 and -m64 in compiling
SB_TX_RATE=              # Use fixed transaction rate
SB_TX_JITTER=            # Use jitter of transaction rate
SB_AVOID_DEADLOCKS="yes" # Avoid update orders that can cause deadlocks

#Parameters specifying where MySQL Server is hosted
SERVER_HOST="127.0.0.1"        # Hostname of MySQL Server
SERVER_PORT="3306"             # Port of MySQL Server to connect to

#Set taskset to blank if no binding to CPU and memory is wanted
TASKSET=                      # Program to bind program to CPU's
                              # Currently taskset and numactl suported
BENCH_TASKSET=
SERVER_TASKSET=
SERVER_CPUS=                  # CPU's to bind for MySQL Server
SERVER_BIND=                  # Bind to NUMA nodes when TASKSET=numactl
SERVER_MEM_POLICY="interleaved" # Use interleaved/local memory policy with numactl
#Same parameters for benchmark program
BENCHMARK_CPUS=
BENCHMARK_BIND=
BENCHMARK_MEM_POLICY="local"

#Compiler to use, default is gcc
COMPILER=""
USE_DBT2_BUILD="yes"

#Defaults for DBT2 parameters
DBT2_PARTITION_FLAG="HASH"
DBT2_NUM_PARTITIONS=""
DBT2_PK_USING_HASH="--using-hash"
DBT2_INTERMEDIATE_TIMER_RESOLUTION="3"
FIRST_CLIENT_PORT="30000"
DBT2_WAREHOUSES="10"
DBT2_TERMINALS="1"
DBT2_RUN_WAREHOUSES="1;2;4"
DBT2_NUM_SERVERS="1"
DBT2_TIME="90"
DBT2_SCI=
DBT2_SPREAD=
DBT2_LOADERS="8"
GENERATE_DBT2_DATA=

#Defaults for iClaustron
DATA_DIR_BASE=
TMP_BASE="/tmp"
MYSQL_BASE="5.5"
USE_MALLOC_LIB="yes"
MALLOC_LIB="/usr/lib64/libtcmalloc_minimal.so.0"
INNODB_BUFFER_POOL_INSTANCES="12"
INNODB_LOG_DIR=""
INNODB_DIRTY_PAGES_PCT=""
INNODB_OLD_BLOCKS_PCT=""
INNODB_SPIN_WAIT_DELAY=""
INNODB_STATS_ON_METADATA="off"
INNODB_STATS_ON_MUTEXES=
INNODB_MAX_PURGE_LAG=""
INNODB_SUPPORT_XA=""
INNODB_FILE_FORMAT="barracuda"
INNODB_READ_AHEAD_THRESHOLD="63"
INNODB_ADAPTIVE_HASH_INDEX="0"
INNODB_READ_IO_THREADS="8"
INNODB_WRITE_IO_THREADS="8"
INNODB_THREAD_CONCURRENCY="0"
INNODB_BUFFER_POOL_SIZE="8192M"
INNODB_LOG_FILE_SIZE="2000M"
INNODB_LOG_BUFFER_SIZE="256M"
INNODB_FLUSH_LOG_AT_TRX_COMMIT="2"
INNODB_IO_CAPACITY="200"
INNODB_MAX_IO_CAPACITY=""
INNODB_FLUSH_METHOD=""
INNODB_USE_PURGE_THREAD="yes"
INNODB_FILE_PER_TABLE=""
INNODB_CHANGE_BUFFERING="all"
INNODB_DOUBLEWRITE="yes"
INNODB_MONITOR="no"
INNODB_FLUSH_NEIGHBOURS="no"
USE_LARGE_PAGES=""
LOCK_ALL=""
SORT_BUFFER_SIZE="32768"
KEY_BUFFER_SIZE="50M"
MAX_HEAP_TABLE_SIZE="1000M"
TMP_TABLE_SIZE="100M"
MAX_TMP_TABLES="100"
TABLE_CACHE_SIZE="400"
TABLE_CACHE_INSTANCES="16"
USE_SUPERSOCKET=
USE_INFINIBAND=
SUPERSOCKET_LIB=
INFINIBAND_LIB=
TRANSACTION_ISOLATION=
BINLOG=
SYNC_BINLOG="0"
BINLOG_ORDER_COMMITS=

#Defaults for flexAsynch
FLEX_ASYNCH_API_NODES=
FLEX_ASYNCH_NUM_THREADS="16"
FLEX_ASYNCH_NUM_PARALLELISM="32"
FLEX_ASYNCH_NUM_OPS_PER_TRANS="1"
FLEX_ASYNCH_EXECUTION_ROUNDS="500"
FLEX_ASYNCH_NUM_ATTRIBUTES="25"
FLEX_ASYNCH_ATTRIBUTE_SIZE="1"
FLEX_ASYNCH_NO_LOGGING="no"
FLEX_ASYNCH_FORCE_FLAG="force"
FLEX_ASYNCH_USE_WRITE="no"
FLEX_ASYNCH_USE_LOCAL="0"
FLEX_ASYNCH_NUM_MULTI_CONNECTIONS="1"
FLEX_ASYNCH_WARMUP_TIMER="10"
FLEX_ASYNCH_EXECUTION_TIMER="30"
FLEX_ASYNCH_COOLDOWN_TIMER="10"
FLEX_ASYNCH_NEW="-new"
FLEX_ASYNCH_DEF_THREADS="3"

#Defaults for this build script
SSH_PORT="22"
SSH_USER=
WINDOWS_REMOTE="no"
BUILD_REMOTE="no"
CMAKE_GENERATOR="Visual;Studio;9;2008;Win64"
USE_FAST_MYSQL="yes"
TEST_DESCRIPTION=""
SYSBENCH_ROWS="1000000"

#Variable Declarations
REMOTE_BIN_INSTALL_DIR=
REMOTE_SRC_INSTALL_DIR=
BIN_INSTALL_DIR=
USE_BINARY_MYSQL_TARBALL="yes"
SRC_INSTALL_DIR=
CONFIG_FILE=
LOG_FILE=
SSH_CMD=

REMOTE_NODES=
DEFAULT_DIR=
VERBOSE=
VERBOSE_FLAG=
BUILD_LOCAL="yes"
BUILD_REMOTE_FLAG="yes"
EXECUTE_TEST="yes"
PERFORM_CLEANUP="yes"
SKIP_RUN=
SKIP_START=
SKIP_STOP=
PERFSCHEMA_FLAG=
SB_USE_TRX=
SB_DIST_TYPE="uniform"
TRX_ENGINE=
SB_USE_AUTO_INC=
NUM_MYSQL_SERVERS="1"
USE_MYISAM_FOR_ITEM=
MSG=
WITH_DEBUG=
DEBUG_FLAG="no"
STATIC_LINKING_FLAG="no"
PACKAGE=
FAST_FLAG=
WITH_FAST_MUTEXES_FLAG="yes"
WITH_PERFSCHEMA_FLAG="yes"
WITH_NDB_TEST_FLAG=""
LINK_TIME_OPTIMIZER_FLAG=
MSO_FLAG=
COMPILER_FLAG=
CLIENT_MYSQL_VERSION=
FEEDBACK_FLAG=
FEEDBACK_COMPILATION=
THREADPOOL_SIZE=
THREADPOOL_ALGORITHM=
THREADPOOL_STALL_LIMIT=
THREADPOOL_PRIO_KICKUP_TIMER=
MAX_CONNECTIONS="1000"
KILL_NODES="no"

check_support_programs

while test $# -gt 0
do
  case $1 in
  --default-directory )
    shift
    DEFAULT_DIR="$1"
    ;;
  --verbose )
    VERBOSE="yes"
    VERBOSE_FLAG="--verbose"
    ;;
  --skip-cleanup )
    PERFORM_CLEANUP="no"
    ;;
  --skip-build-local )
    BUILD_LOCAL="no"
    ;;
  --skip-build-remote )
    BUILD_REMOTE_FLAG="no"
    ;;
  --skip-run )
    SKIP_RUN="--skip-run"
    ;;
  --skip-start )
    SKIP_START="--skip-start"
    ;;
  --skip-stop )
    SKIP_STOP="--skip-stop"
    ;;
  --skip-test )
    EXECUTE_TEST="no"
    ;;
  --kill-nodes )
    KILL_NODES="yes"
    ;;
  --generate-dbt2-data )
    GENERATE_DBT2_DATA="yes"
    ;;
  *)
    ${ECHO} "No such option $1, only default-directory can be provided"
    usage
    exit 1
  esac
  shift
done


CONFIG_FILE="${DEFAULT_DIR}/autobench.conf"
BIN_INSTALL_DIR="${DEFAULT_DIR}/basedir"
SRC_INSTALL_DIR="${DEFAULT_DIR}/src"
LOG_FILE="${DEFAULT_DIR}/build_prepare.log"
if test "x${REMOTE_BIN_INSTALL_DIR}" = "x" ; then
  REMOTE_BIN_INSTALL_DIR="${BIN_INSTALL_DIR}"
fi
${ECHO} "Starting automated benchmark suite" > ${LOG_FILE}
#
# The user specified configuration information is placed in autobench.conf
# in a directory specified by the user. We use this information to write
# the iclaustron.conf-file that drives the management script that starts
# and stops NDB and MySQL programs this also includes the dis_config_c1.ini
# file, we also use it to write dbt2.conf that
# is used to drive the execution of the DBT2 benchmark and finally we use
# the information to write the sysbench.conf which is used to drive the
# sysbench benchmark. The autobench.conf also contains other parameters
# used by this script to build and copy binaries to remote nodes.
#
read_autobench_conf
set_compiler_flags
write_dis_config_ini
set_first_server_host
set_first_server_port
set_up_taskset
write_iclaustron_conf
write_dbt2_conf
if test "x${BENCHMARK_TO_RUN}" = "xsysbench" ; then
  write_sysbench_conf
fi
#For non-gcc compilers it's a good idea to still use gcc-compiled library
#for benchmark programs
if test "x$CLIENT_MYSQL_VERSION" = "x" ; then
  CLIENT_MYSQL_VERSION="$MYSQL_VERSION"
fi

if test "x$KILL_NODES" = "xyes" ; then
  for NODE in ${REMOTE_NODES}
  do
    kill_nodes ${NODE}
  done
  if test "x${BENCHMARK_TO_RUN}" = "xflexAsynch" ; then
    FLEX_API_HOSTS=`$ECHO $FLEX_ASYNCH_API_NODES | $SED -e 's!\;! !g'`
    for LOCAL_API_NODE in $FLEX_API_HOSTS
    do
      kill_nodes ${LOCAL_API_NODE}
    done
  fi
  exit 0
fi

for NODE in ${REMOTE_NODES}
do
  init_clean_up ${NODE}
done
init_tarball_variables
create_dirs
if test "x${BUILD_LOCAL}" = "xyes" ; then
  unpack_tarballs
  if test "x${FEEDBACK_COMPILATION}" = "xyes" ; then
    FEEDBACK_FLAG="--generate-feedback $DEFAULT_DIR/feedback_dir"
  fi
  build_local
  if test "x${FEEDBACK_COMPILATION}" = "xyes" && \
     test "x${USE_BINARY_MYSQL_TARBALL}" = "xno" ; then
    create_binary_tarballs
    remote_install_binaries ${FIRST_SERVER_HOST}
    remove_local_binary_tar_files
    exec_command ${SRC_INSTALL_DIR}/${DBT2_VERSION}/scripts/run_oltp.sh \
         --default-directory ${DEFAULT_DIR} \
         --benchmark sysbench --skip-run --only-initial
    FEEDBACK_FLAG="--use-feedback $DEFAULT_DIR/feedback_dir"
    clean_up_local_bin
    clean_up_remote_bin ${FIRST_SERVER_HOST}
    clean_up_local_src
    create_dirs
    unpack_tarballs
    build_local
  fi
  if test "x${BENCHMARK_TO_RUN}" = "xdbt2" ; then
    if test "x${GENERATE_DBT2_DATA}" = "xyes" ; then
      COMMAND="${SRC_INSTALL_DIR}/${DBT2_VERSION}/scripts/create_dbt2_files.sh"
      COMMAND="${COMMAND} --default-directory ${DEFAULT_DIR}"
      COMMAND="${COMMAND} --data_dir ${DBT2_DATA_DIR}"
      COMMAND="${COMMAND} --base_dir ${SRC_INSTALL_DIR}/${DBT2_VERSION}"
      COMMAND="${COMMAND} --num_warehouses ${DBT2_WAREHOUSES}"
      COMMAND="${COMMAND} --first-warehouse 1"
      exec_command ${COMMAND}
    fi
  fi
fi
if test "x${BUILD_REMOTE_FLAG}" = "xyes" ; then
  if test "x${WINDOWS_REMOTE}" = "xyes" ; then
    for NODE in ${REMOTE_NODES}
    do
      build_remote_windows ${NODE}
    done
  elif test "x${BUILD_REMOTE}" = "xyes" ; then
    for NODE in ${REMOTE_NODES}
    do
      build_remote_unix ${NODE}
    done
  else
    create_binary_tarballs
    for NODE in ${REMOTE_NODES}
    do
      remote_install_binaries ${NODE}
    done
    remove_local_binary_tar_files
  fi
fi
for NODE in ${REMOTE_NODES}
do
  create_remote_data_dir_base ${NODE}
done
if test "x${EXECUTE_TEST}" = "xyes" ; then
  if test "x$INNODB_LOG_DIR" != "x" ; then
    $MKDIR -p $INNODB_LOG_DIR
  fi
  if test "x${BENCHMARK_TO_RUN}" = "xsysbench" ; then
#Run Sysbench execution script
    if test "x$VERBOSE" = "xyes" ; then
      echo "sysbench for ${DEFAULT_DIR}/autobench.conf with ${SKIP_RUN} ${SKIP_START} ${SKIP_STOP}"
    fi
    exec_command ${SRC_INSTALL_DIR}/${DBT2_VERSION}/scripts/run_oltp.sh \
         --default-directory ${DEFAULT_DIR} \
         --benchmark sysbench \
         ${VERBOSE_FLAG} ${SKIP_RUN} ${SKIP_START} ${SKIP_STOP}
  elif test "x${BENCHMARK_TO_RUN}" = "xdbt2" ; then
    if test "x$VERBOSE" = "xyes" ; then
      echo "dbt2 ${DEFAULT_DIR}/autobench.conf with ${SKIP_RUN} ${SKIP_START} ${SKIP_STOP}"
    fi
    $MKDIR -p $DEFAULT_DIR/dbt2_output
    exec_command ${SRC_INSTALL_DIR}/${DBT2_VERSION}/scripts/run_oltp.sh \
         --default-directory ${DEFAULT_DIR} \
         --benchmark dbt2 \
         ${VERBOSE_FLAG} ${SKIP_RUN} ${SKIP_START} ${SKIP_STOP}
  elif test "x${BENCHMARK_TO_RUN}" = "xflexAsynch" ; then
    exec_command ${SRC_INSTALL_DIR}/${DBT2_VERSION}/scripts/run_oltp.sh \
         --default-directory ${DEFAULT_DIR} \
         --benchmark flexAsynch \
         ${VERBOSE_FLAG} ${SKIP_RUN} ${SKIP_START} ${SKIP_STOP}
  fi
fi
if test "x${PERFORM_CLEANUP}" = "xyes" ; then
  clean_up_local_bin
  for NODE in ${REMOTE_NODES}
  do
    clean_up_remote_bin ${NODE}
  done
  if test "x${BENCHMARK_TO_RUN}" = "xdbt2" ; then
    clean_up_output
  fi
  clean_up_local_src
  remove_generated_files
fi
exit 0
