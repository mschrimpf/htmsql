#!/bin/bash
# ----------------------------------------------------------------------
# Copyright (C) 2007 Dolphin Interconnect Solutions ASA, iClaustron  AB
#  2008, 2012, Oracle and/or its affiliates. All rights reserved.
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

IFS='
 	'
usage() {
  echo ""
  echo "./mgm_cluster.sh [--config-file] [--start] [--stop] [--all] [--drizzled] [--mysqld] [--mysqld_safe] [--ndbd] [--ndb_mgmd] [--node] [--shutdown] [--help] [--flags FLAGS]"
  echo ""
  echo "This script is used start and stop nodes in an NDB Cluster. It can start"
  echo "all nodes, all management servers, all ndbd daemons, all MySQL Servers"
  echo "and it can start specific nodes. It can also in the same stop nodes in"
  echo "a similar fashion"
  echo ""
  echo "Another useful feature is to run a MySQL command on all MySQL Servers in the"
  echo "cluster. This can be useful to define things like GRANT permissions, VIEW's,"
  echo "TRIGGER's and other things which are local to a specific MySQL Server and thus"
  echo "must be defined in all MySQL Servers."
  echo ""
  echo "The script requires a configuration file, the default configuration file"
  echo "is placed in the .build directory of the user starting the script in the"
  echo "file dis_config.ini. The user can also specify the configuration file when"
  echo "starting the script."
  echo ""
  echo "Each node is actually started then by the script start_ndb.sh. This script"
  echo "will get the basic parameters from the configuration file NodeId, Type,"
  echo "Hostname. At the end of each line in the config file it is also possible to"
  echo "set a number of flags that are specific to a node. This could be e.g. mysqld"
  echo "port number to use, username on MySQL Server and specific parameters when"
  echo "starting a MySQL Server."
  echo ""
  echo "The parameters to the start_ndb.sh-script is built by first getting the basic"
  echo "parameters from the config file, then adding the specific ones from the config"
  echo "file. After that one adds any parameters set in an environment variable"
  echo "MGM_CLUSTER_PARAMETERS. Finally after that, any parameters added after the"
  echo "--flags are added to the parameters for the start_ndb.sh-script. All"
  echo "parameters can be specified except those in the mandatory section of the"
  echo "start_ndb.sh-script. These parameters are only interesting for start of"
  echo "nodes"
  echo ""
  echo "To understand more of the possible parameters in the start_ndb.sh-script please"
  echo "use ./start_ndb.sh --help"
  echo ""
  echo "Mandatory Section:"
  echo "------------------"
  echo "--start                   : Start a node or a set of processes in the cluster"
  echo "--stop                    : Stop a node or a set of processes in the cluster"
  echo "--mysql                   : Run a MySQL command on all MySQL Servers"
  echo "--rolling_upgrade         : Perform a rolling upgrade of the cluster"
  echo "                            This is not yet implemented"
  echo "Either --start, --stop or --rolling_upgrade must be provided and not both of"
  echo "them."
  echo ""
  echo "--all                     : Start/Stop all processes in the cluster"
  echo "--drizzled                : Start/Stop all Drizzle Servers using drizzled"
  echo "--mysqld                  : Start/Stop all MySQL Servers using mysqld"
  echo "--mysqld_safe             : Start/Stop all MySQL Servers using mysqld_safe"
  echo "--ndbd                    : Start/Stop all ndbd processes in the cluster"
  echo "--ndb-mgmd                : Start/Stop all ndb_mgmd processes in the cluster"
  echo "--node NODEID             : Start/Stop a specific node given its nodeid"
  echo "One and only one of the above parameters must also be specified"
  echo ""
  echo "Optional Section:"
  echo "-----------------"
  echo "--initial                 : Perform initial start of ndbd nodes and perform"
  echo "--cluster_id              : Cluster id to use, default = none"
  echo "                            mysql_install_db on MySQL nodes"
  echo "--flags FLAGS             : FLAGS is a set of flags passed on to the"
  echo "                            start_ndb.sh-script, this must be the last parameter"
  echo "--ssh_port PORT           : SSH port to use"
  echo ""
  echo "It's also possible to start Drizzle Servers now with this script"
  echo ""
}

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

output_msg()
{
  echo "$MSG"
  msg_to_log
}

validate_parameter()
{
  if test "x${2}" != "x${3}" ; then
    #usage "wrong argument '$2' for parameter '-$1'"
    MSG="wrong argument '${2}' for parameter '-${1}'"
    output_msg
    IGNORE_LINE="yes"
    if test "x${4}" = "xexit" ; then
      exit 1
    fi
  fi
}

execute_command()
{
  if test "x${VERBOSE_HERE}" = "xyes" ; then
    MSG="Executing ${EXEC_SCRIPT}"
    output_msg
    MSG="++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    output_msg
  fi
  $EXEC_SCRIPT "$MYSQL_CMD"
  RET_CODE="$?"
  if test "x${VERBOSE_HERE}" = "xyes" ; then
    MSG="------------------------------------------------------"
    output_msg
    MSG=""
    output_msg
  fi
  if test "x${RET_CODE}" != "x0" ; then
    MSG="Failed with script $EXEC_SCRIPT using parameters $MYSQL_CMD"
    output_msg
    exit 1
  fi
}

start_stop_ndbd()
{
  NDBD_NODE="${1}"
  NDBD_HOST="${2}"
  EXEC_SCRIPT="${START_NDB_SCRIPT}"
  MSG="${COMMAND_TYPE} ndbd node ${NDBD_NODE} on host ${NDBD_HOST}"
  output_msg
  if test "x${COMMAND_TYPE}" = "xStart" ; then
    EXEC_SCRIPT="${EXEC_SCRIPT} --home-base ${HOME_BASE}"
    EXEC_SCRIPT="${EXEC_SCRIPT} --ndbd"
    if test "x${INITIAL}" = "xyes" ; then
      EXEC_SCRIPT="${EXEC_SCRIPT} --initial"
    fi
    EXEC_SCRIPT="${EXEC_SCRIPT} --nodeid ${NDBD_NODE}"
    EXEC_SCRIPT="${EXEC_SCRIPT} ${MGM_CLUSTER_PARAMETERS}"
    EXEC_SCRIPT="${EXEC_SCRIPT} ${LINE_FLAGS}"
    EXEC_SCRIPT="${EXEC_SCRIPT} ${COMMAND_LINE_FLAGS}"
    EXEC_SCRIPT="${EXEC_SCRIPT} ${NDBD_HOST}"
  else
    EXEC_SCRIPT="${EXEC_SCRIPT} --home-base ${HOME_BASE}"
    EXEC_SCRIPT="$EXEC_SCRIPT --mgm_cmd ${NDBD_NODE} stop"
  fi
  execute_command
}

start_stop_ndb_mgmd()
{
  MGMD_NODE="${1}"
  MGMD_HOST="${2}"
  EXEC_SCRIPT="${START_NDB_SCRIPT}"
  MSG="${COMMAND_TYPE} ndb_mgmd node ${MGMD_NODE} on host ${MGMD_HOST}"
  output_msg
  if test "x${COMMAND_TYPE}" = "xStart" ; then
    EXEC_SCRIPT="${EXEC_SCRIPT} --home-base ${HOME_BASE}"
    EXEC_SCRIPT="${EXEC_SCRIPT} --ndb_mgmd"
    EXEC_SCRIPT="${EXEC_SCRIPT} --nodeid ${MGMD_NODE}"
    if test "x${INITIAL}" = "xyes" ; then
      EXEC_SCRIPT="${EXEC_SCRIPT} --initial"
    fi
    EXEC_SCRIPT="${EXEC_SCRIPT} ${LINE_FLAGS}"
    EXEC_SCRIPT="${EXEC_SCRIPT} ${COMMAND_LINE_FLAGS}"
    EXEC_SCRIPT="${EXEC_SCRIPT} ${MGMD_HOST}"
  else
    EXEC_SCRIPT="${EXEC_SCRIPT} --home-base ${HOME_BASE}"
    EXEC_SCRIPT="${EXEC_SCRIPT} --mgm_cmd ${MGMD_NODE} stop"
  fi
  execute_command
# Give management server a few seconds to start up
  sleep 2
}

start_stop_mysqld()
{
  EXEC_SCRIPT="${START_NDB_SCRIPT}"
  MYSQLD_TYPE="${1}"
  MYSQLD_NODE_ID="${2}"
  MYSQLD_HOST="${3}"
  MYSQLD_PORT="${4}"
  if test "x${MYSQLD_TYPE}" = "xDRIZZLED" ; then
    MYSQLD_TYPE="drizzled"
  fi
  if test "x${MYSQLD_TYPE}" = "xMYSQLD" ; then
    MYSQLD_TYPE="mysqld"
  fi
  if test "x${MYSQLD_TYPE}" = "xMYSQLD_SLAVE" ; then
    MYSQLD_TYPE="mysqld"
    EXEC_SCRIPT="$EXEC_SCRIPT --start-slave"
  fi
  if test "x${MYSQLD_TYPE}" = "xMYSQLD_SAFE" ; then
    MYSQLD_TYPE="mysqld_safe"
  fi
  MSG="${COMMAND_TYPE} ${MYSQLD_TYPE} node ${MYSQLD_NODE_ID} on host ${MYSQLD_HOST} with port ${MYSQLD_PORT}"
  output_msg
  if test "x${MYSQLD_TYPE}" != "xdrizzled" ; then
    if test "x${INITIAL}" = "xyes" && test "x${COMMAND_TYPE}" = "xStart" ; then
      MSG="Perform mysql_install_db first"
      output_msg
      EXEC_SCRIPT="${EXEC_SCRIPT} --home-base ${HOME_BASE}"
      EXEC_SCRIPT="${EXEC_SCRIPT} --mysql_install_db"
      EXEC_SCRIPT="${EXEC_SCRIPT} --mysql_no ${MYSQLD_NODE_ID}"
      EXEC_SCRIPT="${EXEC_SCRIPT} --mysql_port ${MYSQLD_PORT}"
      EXEC_SCRIPT="${EXEC_SCRIPT} ${MYSQLD_HOST}"
      execute_command
      EXEC_SCRIPT="${START_NDB_SCRIPT}"
    fi
  fi
  if test "x${COMMAND_TYPE}" = "xStart" ; then
    EXEC_SCRIPT="${EXEC_SCRIPT} --home-base ${HOME_BASE}"
    EXEC_SCRIPT="${EXEC_SCRIPT} --${MYSQLD_TYPE}"
    EXEC_SCRIPT="${EXEC_SCRIPT} --mysql_no ${MYSQLD_NODE_ID}"
    EXEC_SCRIPT="${EXEC_SCRIPT} --mysql_port ${MYSQLD_PORT}"
    EXEC_SCRIPT="${EXEC_SCRIPT} ${LINE_FLAGS}"
    EXEC_SCRIPT="${EXEC_SCRIPT} ${COMMAND_LINE_FLAGS}"
    EXEC_SCRIPT="${EXEC_SCRIPT} --mysql_host ${MYSQLD_HOST}"
    EXEC_SCRIPT="${EXEC_SCRIPT} ${MYSQLD_HOST}"
  else
    EXEC_SCRIPT="${EXEC_SCRIPT} --home-base ${HOME_BASE}"
    if test "x${MYSQLD_TYPE}" = "xdrizzled" ; then
      EXEC_SCRIPT="${EXEC_SCRIPT} --drizzled_shutdown"
    else
      EXEC_SCRIPT="${EXEC_SCRIPT} --mysqld_shutdown"
    fi
    EXEC_SCRIPT="${EXEC_SCRIPT} --mysql_port ${MYSQLD_PORT}"
    EXEC_SCRIPT="${EXEC_SCRIPT} --mysql_host ${MYSQLD_HOST}"
    EXEC_SCRIPT="${EXEC_SCRIPT} ${MYSQLD_HOST}"
  fi
  execute_command
}

verify_line()
{
  IGNORE_LINE="no"
  if test -z "${LINE_NODE_ID}" ; then
    IGNORE_LINE="yes"
  fi
  COMMENT=`echo ${LINE_NODE_ID} | $GREP "#" `
  if test "x${COMMENT}" != "x" ; then
    IGNORE_LINE="yes"
  fi
  if test "x${IGNORE_LINE}" = "xno" ; then
    opt=${LINE_NODE_ID}
    TMP=`echo ${LINE_NODE_ID} | egrep "^[0-9]+$"`
    validate_parameter $opt ${LINE_NODE_ID} ${TMP} "no_exit"
    if test "x${LINE_NODE_TYPE}" != "xNDBD" && \
       test "x${LINE_NODE_TYPE}" != "xNDB_MGMD" && \
       test "x${LINE_NODE_TYPE}" != "xDRIZZLED" && \
       test "x${LINE_NODE_TYPE}" != "xMYSQLD" && \
       test "x${LINE_NODE_TYPE}" != "xMYSQLD_SAFE" ; then
      MSG="Only NODE_TYPE = NDBD, NDB_MGMD, DRIZZLED, MYSQLD and MYSQLD_SAFE are allowed"
      output_msg
      IGNORE_LINE="yes"
    fi
  fi
  if test "x${IGNORE_LINE}" = "xno" ; then
    if test "x${LINE_PORT}" = "x" ; then
      LINE_PORT="3306"
    else
      opt=${LINE_PORT}
      TMP=`echo ${LINE_PORT} | egrep "^[0-9]+$"`
      validate_parameter ${opt} ${LINE_PORT} ${TMP} "no_exit"
    fi
  fi
}

start_stop_ndbd_nodes()
{
  cat ${DIS_CONFIG_FILE} | \
  while read LINE_NODE_ID LINE_NODE_TYPE LINE_HOST_NAME LINE_PORT LINE_FLAGS
  do
    verify_line
    if test "x${IGNORE_LINE}" = "xyes" ; then
      continue
    fi
    if test "x${LINE_NODE_TYPE}" = "xNDBD" ; then
      NDB_CLUSTER_START="y"
      start_stop_ndbd ${LINE_NODE_ID} ${LINE_HOST_NAME}
    fi
  done
}

start_stop_ndb_mgmd_nodes()
{
  cat ${DIS_CONFIG_FILE} | \
  while read LINE_NODE_ID LINE_NODE_TYPE LINE_HOST_NAME LINE_PORT LINE_FLAGS
  do
    verify_line
    if test "x${IGNORE_LINE}" = "xyes" ; then
      continue
    fi
    if test "x${LINE_NODE_TYPE}" = "xNDB_MGMD" ; then
      NDB_CLUSTER_START="yes"
      start_stop_ndb_mgmd ${LINE_NODE_ID} ${LINE_HOST_NAME}
    fi
  done
}

start_stop_mysqld_nodes()
{
  cat ${DIS_CONFIG_FILE} | \
  while read LINE_NODE_ID LINE_NODE_TYPE LINE_HOST_NAME LINE_PORT LINE_FLAGS
  do
    verify_line
    if test "x${IGNORE_LINE}" = "xyes" ; then
      continue
    fi
    if test "x${LINE_NODE_TYPE}" = "xMYSQLD" || \
       test "x${LINE_NODE_TYPE}" = "xMYSQLD_SAFE" || \
       test "x${LINE_NODE_TYPE}" = "xDRIZZLED" ; then
      sleep 2
      start_stop_mysqld ${LINE_NODE_TYPE} ${LINE_NODE_ID} ${LINE_HOST_NAME} ${LINE_PORT}
    fi
  done
}

start_stop_specific_node()
{
  cat ${DIS_CONFIG_FILE} | \
  while read LINE_NODE_ID LINE_NODE_TYPE LINE_HOST_NAME LINE_PORT LINE_FLAGS
  do
    verify_line
    if test "x${IGNORE_LINE}" = "xyes" ; then
      continue
    fi
    if test "x${LINE_NODE_ID}" = "x${NODEID}" ; then
      if test "x${LINE_NODE_TYPE}" = "xNDB_MGMD" ; then
        start_stop_ndb_mgmd ${LINE_NODE_ID} ${LINE_HOST_NAME}
      fi
      if test "x${LINE_NODE_TYPE}" = "xNDBD" ; then
        start_stop_ndbd ${LINE_NODE_ID} ${LINE_HOST_NAME}
      fi
      if test "x${LINE_NODE_TYPE}" = "xMYSQLD" || \
         test "x${LINE_NODE_TYPE}" = "xMYSQLD_SAFE" || \
         test "x${LINE_NODE_TYPE}" = "xDRIZZLED" ; then
        start_stop_mysqld ${LINE_NODE_TYPE} ${LINE_NODE_ID} ${LINE_HOST_NAME} ${LINE_PORT}
      fi
    fi
  done
}

stop_cluster()
{
  if test "x${ENGINE}" = "xndb" ; then
    EXEC_SCRIPT="${START_NDB_SCRIPT}"
    EXEC_SCRIPT="${EXEC_SCRIPT} --home-base ${HOME_BASE}"
    EXEC_SCRIPT="${EXEC_SCRIPT} --ndb_shutdown"
    execute_command
  fi
}

run_mysql_cmd()
{
  cat ${DIS_CONFIG_FILE} | \
  while read LINE_NODE_ID LINE_NODE_TYPE LINE_HOST_NAME LINE_PORT LINE_FLAGS
  do
    verify_line
    if test "x${IGNORE_LINE}" = "xyes" ; then
      continue
    fi
    if test "x${LINE_NODE_TYPE}" = "xDRIZZLED" || \
       test "x${LINE_NODE_TYPE}" = "MYSQLD" || \
       test "x${LINE_NODE_TYPE}" = "xMYSQLD_SAFE" ; then
      EXEC_SCRIPT="${START_NDB_SCRIPT}"
      EXEC_SCRIPT="${EXEC_SCRIPT} --home-base ${HOME_BASE}"
      EXEC_SCRIPT="${EXEC_SCRIPT} --mysql-no $LINE_NODE_ID"
      EXEC_SCRIPT="${EXEC_SCRIPT} --mysql_port $LINE_PORT"
      EXEC_SCRIPT="$EXEC_SCRIPT --mysql_host $LINE_HOST_NAME"
      EXEC_SCRIPT="${EXEC_SCRIPT} --mysql_cmd "
      execute_command
    fi
  done
}

LOG_FILE=""
PROCESS=""
DIS_CONFIG_FILE=""
START_NDB_SCRIPT=""
NODEID=""
COMMAND_TYPE=""
EXEC_SCRIPT=""
INITIAL="no"
VERBOSE_HERE="no"
COMMAND_LINE_FLAGS=""
FLAG_VERBOSE=""
NDB_CLUSTERID=""
NDB_CLUSTERID_NAME=""
HOME_BASE="${HOME}"
DIS_BASE_DIR=`dirname ${0}`
SSH_PORT=""
NDB_CLUSTER_START="no"
DEFAULT_DIR="$HOME/.build"
GREP=
MSG=

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

  DEFAULT_FILE="${DEFAULT_DIR}/iclaustron.conf"
  if test -f "${DEFAULT_FILE}" ; then
    . ${DEFAULT_FILE}
  fi

  if test "x$SSH_PORT" != "x" ; then
    SSH_PORT="--ssh_port $SSH_PORT"
  fi

  while test $# -gt 0
  do
    case ${1} in
      --home_base | -home_base | --home-base | -home-base )
        shift 
        HOME_BASE="${1}"
        ;;
      --clusterid | -clusterid | --cluster-id | -cluster-id | \
      --cluster_id | -cluster_id )
        opt=${1}
        shift
        TMP=`echo ${1} | egrep "^[0-9]+$"`
        validate_parameter ${opt} ${1} ${TMP}
        NDB_CLUSTERID="${1}"
        ;;
    --drizzled | -drizzled )
      if test "x${PROCESS}" = "x" ; then
        PROCESS="drizzled"
      else
        MSG="drizzled error"
        output_msg
        usage
        exit 1
      fi
      ;;
      --verbose | -verbose )
        VERBOSE_HERE="yes"
        FLAG_VERBOSE="--verbose"
        ;;
      --start | -start )
        COMMAND_TYPE="Start"
        ;;
      --stop | -stop )
        COMMAND_TYPE="Stop"
        ;;
      --rolling_upgrade | --rolling-upgrade | -rolling_upgrade | -rolling-upgrade )
        COMMAND_TYPE="rolling_upgrade"
        ;;
      --mysqld_safe | -mysqld_safe | --mysqld-safe | -mysqld-safe )
        if test "x${PROCESS}" = "x" ; then
          PROCESS="mysqld_safe"
        else
          MSG="mysqld_safe error"
          output_msg
          usage
          exit 1
        fi
      ;;
    --initial | -initial | --init | -init )
      INITIAL="yes"
      ;;
    --mysql)
      shift
      if test "x${PROCESS}" = "x" ; then
        COMMAND_TYPE="mysql"
        PROCESS="mysql"
        MYSQL_CMD="$1"
      else
        MSG="mysql error"
        output_msg
        usage
        exit 1
      fi
      ;;
    --mysqld | -mysqld )
      if test "x${PROCESS}" = "x" ; then
        PROCESS="mysqld"
      else
        MSG="mysqld error"
        output_msg
        usage
        exit 1
      fi
      ;;
    --ndbd | -ndbd )
      if test "x${PROCESS}" = "x" ; then
        PROCESS="ndbd"
      else
        MSG="ndbd error"
        output_msg
        usage
        exit 1
      fi
      ;;
    --ndb_mgmd | -ndb_mgmd | -ndb-mgmd | --ndb-mgmd )
      if test "x${PROCESS}" = "x" ; then
        PROCESS="ndb_mgmd"
      else
        MSG="ndb_mgmd error"
        output_msg
        usage
        exit 1
      fi
      ;;
    --all | -all )
      if test "x${PROCESS}" = "x" ; then
        PROCESS="all"
      else
        MSG="all cannot be combined with other process types"
        output_msg
        usage
        exit 1
      fi
      ;;
    --nodeid | -nodeid | --node-id | -node-id | --node_id | -node_id | \
    --node | -node | --nodes | -nodes )
      if test "x${PROCESS}" != "x" ; then
        MSG="--node_id cannot be combined with specifying process type"
        output_msg
        usage
        exit 1
      fi
      PROCESS="use_node_id"
      opt=${1}
      shift
      TMP=`echo ${1} | egrep "^[0-9]+$"`
      validate_parameter ${opt} ${1} ${TMP} "exit"
      NODEID=${1}
      ;;
    --ssh-port | --ssh_port )
      opt=${1}
      shift
      TMP=`echo ${1} | egrep "^[0-9]+$"`
      validate_parameter ${opt} ${1} ${TMP} "exit"
      SSH_PORT="--ssh_port ${1}"
      ;;
    --config-file | -config-file | --config_file | -config_file | --conf-file | \
    -conf-file | --conf_file | -conf_file | --configuration-file )
      shift
      DIS_CONFIG_FILE="${1}"
      ;;
    --flags | -flags | --flag | -flag )
      shift
      break
      ;;
    --help )
      usage
      exit 1
      ;;
    -* )
      MSG="Unrecognized option: ${1}"
      output_msg
      usage
      exit 1
      ;;
  esac
  shift
done
  for flag in "$@"
  do
    COMMAND_LINE_FLAGS="${COMMAND_LINE_FLAGS} ${flag}"
  done

  MSG="++++++++++ Running MySQL Cluster start/stop scripts +++++++++++"
  output_msg
  MSG=""
  output_msg
  if test -f "${DEFAULT_FILE}" ; then
    MSG="Sourcing defaults from ${DEFAULT_FILE}"
    output_msg
  else
    MSG="No ${DEFAULT_FILE} found, using standard defaults"
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
    $GREP --version
    if test "x$?" != "x0" ; then
      MSG="Didn't find a proper grep binary"
      output_msg
      exit 1
    fi
  fi

  START_NDB_SCRIPT="${DIS_BASE_DIR}/start_ndb.sh"
  START_NDB_SCRIPT="${START_NDB_SCRIPT} --default-directory ${DEFAULT_DIR}"
  START_NDB_SCRIPT="${START_NDB_SCRIPT} ${FLAG_VERBOSE}"
  START_NDB_SCRIPT="${START_NDB_SCRIPT} ${SSH_PORT}"
  if test "x${NDB_CLUSTERID}" != "x" ; then
    NDB_CLUSTERID_NAME="_c${NDB_CLUSTERID}"
    START_NDB_SCRIPT="${START_NDB_SCRIPT} --cluster_id ${NDB_CLUSTERID}"
  fi
  if test "x${DIS_CONFIG_FILE}" = "x" ; then
    DIS_CONFIG_FILE="${HOME_BASE}/.build/dis_config${NDB_CLUSTERID_NAME}.ini"
  fi
  if test "x${PROCESS}" = "x" ; then
    MSG="At least one process type or node_id or all need to be given"
    output_msg
    usage
    exit 1
  fi
  if test "x${COMMAND_TYPE}" = "x" ; then
    MSG="Need to specify if it is start or stop which is required"
    output_msg
    usage
    exit 1
  fi
  if test "x${COMMAND_TYPE}" = "xrolling_upgrade" ; then
    MSG="Rolling upgrade not yet implemented"
    output_msg
    usage
    exit 1
  fi
  if test "x${PROCESS}" = "xndbd" ; then
    start_stop_ndbd_nodes
  fi
  if test "x${PROCESS}" = "xndb_mgmd" ; then
    start_stop_ndb_mgmd_nodes
  fi
  if test "x${PROCESS}" = "xmysqld" || \
     test "x${PROCESS}" = "xmysqld_safe" || \
     test "x${PROCESS}" = "xdrizzled" ; then
    start_stop_mysqld_nodes
  fi
  if test "x${PROCESS}" = "xall" ; then
    if test "x${COMMAND_TYPE}" = "xStart" ; then
      start_stop_ndb_mgmd_nodes
      start_stop_ndbd_nodes
      if test "x${NDB_CLUSTER_START}" = "xyes" ; then
        STATUS_COMMAND="${START_NDB_SCRIPT} --home-base $HOME_BASE"
        STATUS_COMMAND="${STATUS_COMMAND} --mgm_cmd all status"
        MAX_WAIT="0"
        MSG="Waiting for cluster start"
        output_msg
        sleep 45
        while [ `${STATUS_COMMAND} | $GREP started | wc -l ` -lt 1 ] ;
        do
          sleep 5
          ((MAX_WAIT = MAX_WAIT + 1))
          if test "x${MAX_WAIT}" = "x200" ; then
            MSG="Ndb Cluster didn't start in 1000 seconds"
            output_msg
            exit 1
          fi
        done
      fi
      start_stop_mysqld_nodes
    else
      start_stop_mysqld_nodes
      stop_cluster
      if test "x${NDB_CLUSTER_START}" = "xyes" ; then
        MSG="We're hanging here for 5 seconds to ensure stop is completed"
        output_msg
        sleep 5
      fi
      exit 0
    fi
  fi
  if test "x${PROCESS}" = "xuse_node_id" ; then
    start_stop_specific_node
  fi
  if test "x$COMMAND_TYPE" = "xmysql" ; then
    run_mysql_cmd
  fi
  exit 0
