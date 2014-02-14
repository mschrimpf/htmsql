#!/bin/bash
# ----------------------------------------------------------------------
# Copyright (C) 2007 Dolphin Interconnect Solutions ASA, iClaustron  AB
# 2008, 2012 Oracle and/or its affiliates. All rights reserved.
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


usage() {
  echo ""
  echo "./start_ndb.sh [--ndb_autoincrement_size SIZE] [--use_passwd] [--mysql_db DB] [--mysql] [--mysql_user] [--mysql_cmd] [--mysqld] [--mysqld_safe] [--ndbd] [--ndb_mgmd] [--ndb_mgm] [--mysqld_shutdown] [--backup] [--ndb_restore] [--mgm_cmd COMMAND] [--ndb_shutdown] [--version VERSION] [mysql-no NUM] [--ssocks] [--infiniband] [--binary] [--user USER] [--directory-user DIRECTORY_USER] [--ndb-connectstring connectstring] [--nodeid NODEID] [--initial] [--mgm_host HOSTNAME] [--mgm_port PORT] [--config-file FILE] [--tc_select VARIANT] [--enable-innodb] [--enable-grants] [--max-connections NUM_CONNECTIONS] [--taskset HEXNUMBER] [--no_force_send] [--use_exact_count] [--no-engine-pushdown] [--mysql_host HOSTNAME] [--mysql_port PORT] [hostname]"
  echo ""
  echo "hostname            : Node where binary is to be started"
  echo "Hostname is mandatory for ndbd, ndb_mgmd, mysqld, mysqld_safe,"
  echo "mysqld_shutdown, ndb_restore; backup, ndb_mgm, ndb_shutdown,"
  echo "mgm_cmd will always execute locally and anything on command line"
  echo "after it will be treated as the management command"
  echo "if provided"
  echo ""
  echo "Mandatory Section:"
  echo "------------------"
  echo "--ndbd              : Start ndbd process"
  echo "--ndb_mgmd          : Start ndb_mgmd process"
  echo "--ndb_mgm           : Start ndb_mgm process"
  echo "--drizzled          : Start drizzled process"
  echo "--mysqld            : Start mysqld process"
  echo "--mysqld_safe       : Start mysqld process using mysqld_safe"
  echo "--mysql_install_db  : Install MySQL database"
  echo "--drizzled_shutdown : Stop a drizzled process"
  echo "--backup            : Execute backup command"
  echo "--ndb_restore       : Restore data into cluster"
  echo "--mgm_cmd           : Execute management command"
  echo "--mysql             : Start mysql client"
  echo "--mysql_cmd         : Execute mysql command"
  echo "--ndb_shutdown      : Execute shutdown of cluster"
  echo "To set one and only one of these is mandatory"
  echo ""
  echo "Optional Section for all binaries:"
  echo "----------------------------------"
  echo "--version           : Version number to start (default 5.1.13-beta)"
  echo "--base-version      : Version 5.0 or 5.1"
  echo "--infiniband        : Ensure LD_PRELOAD for infiniband is used"
  echo "--ssocks            : Ensure LD_PRELOAD for SuperSockets is used"
  echo "--binary            : Use binaries from binary installation (default: source)"
  echo "--user              : User to login as (default current user)"
  echo "--ndb-connectstring : Connection to Management Server on the form host:port"
  echo "--nodeid            : Set nodeid of starting node"
  echo "--mgm_port          : Management Server port to c
onnect to"
  echo "--mgm_host          : Management Server host to connect to"
  echo "--verbose           : More output about what is performed"
  echo "--home_base         : Change to use other base than users home directory"
  echo "--cluster_id        : Id of cluster, default = 1"
  echo "Default path is HOME_BASE/mysql/MYSQL_VERSION"
  echo "--mysql_path        : Set MySQL installation path explicitly, will also be used as basedir"
  echo "--ssh_port          : SSH port to use when connecting"
  echo "--taskset           : Bind process to CPU's, e.g. 0x1 for CPU 0"
  echo ""
  echo "Optional Section for mysql:"
  echo "---------------------------"
  echo "--mysql_user        : MySQL user to log in as (default: root)"
  echo "--mysql_db          : Database to use when starting MySQL client"
  echo "--use_passwd        : Should password be provided"
  echo ""
  echo "Optional Section for ndbd:"
  echo "--------------------------"
  echo "--initial           : Initial Start (only interesting for start of ndbd)"
  echo ""
  echo "Optional Section for ndb_mgmd"
  echo "-----------------------------"
  echo "--config-file       : Place where configuration file is found (only for ndb_mgmd)"
  echo "Default placement of configuration file is HOME_BASE/.build/config.ini"
  echo "If cluster_id has been set the default is HOME_BASE/.build/config_c\"CLUSTER_ID\".ini"
  echo ""
  echo "Optional Section for ndb_mgm is empty:"
  echo "--------------------------------------"
  echo ""
  echo "Optional Section for mysqld and mysqld_safe (also drizzled):"
  echo "--------------------------------------------"
  echo "--tc_select         : Algorithm to select Transaction Coordinator from MySQL Server"
  echo "0: Old variant, round robin, 1: New variant, use local nodes more,"
  echo "2: New variant, use global variable"
  echo "--mysql-no          : Number of MySQL Server"
  echo "This is needed for multiple server per computer"
  echo "--enable-innodb     : Enable InnoDB storage engine"
  echo "--enable-grants     : Enable use of Grant Table"
  echo "--max-connections
   : Max number of client connections"
  echo "--ndb_autoincrement_size : Set autoincrement prefetch size in NDB"
  echo "--no_force_send     : Turn force send off"
  echo "--use_exact_count   : Use exact count"
  echo "--use_general_query_log : Use general query log"
  echo "--use_slow_query_log : Use slow query log"
  echo "--no-engine-pushdown: Don't use engine pushdown"
  echo "--mysql_port        : Port number mysqld will listen on"
  echo "--mysql_host        : Hostname mysqld will bind to (default is hostname used)"
  echo "--data_dir_base     : Set data directory base of MySQL Server"
  echo "                      Actual datadir will be:"
  echo "                      DATA_DIR_BASE/var_MYSQL_NO"
  echo "--tmp_base          : Change to use other base for pid-file and socket-file"
  echo "--start-slave       : We are starting a MySQL Slave"
  echo ""
  echo "Optional Section for backup is empty:"
  echo "-------------------------------------"
  echo "--backup runs a backup and moves the backup files to a central place assuming"
  echo "NFS-like services exist on the machines running nd
bd."
  echo ""
  echo "Optional Section for mysql_cmd:"
  echo "-------------------------------"
  echo "--mysql_db          : Database to use when starting MySQL client"
  echo ""
  echo "--mysql_cmd runs a generic MySQL command with localhost login"
  echo "as root user without password"
  echo ""
  echo "Optional Section for mgm_cmd is empty:"
  echo "--------------------------------------"
  echo "--mgm_cmd runs a generic management command, e.g. 3 stop"
  echo "This needs to be last parameter since rest of command line"
  echo "is treated as the command"
  echo ""
  echo "Optional Section for ndb_restore:"
  echo "---------------------------------"
  echo "--backup_id         : Backup id to restore"
  echo "--backup_node_id    : Restore data from this node id"
  echo "--backup-restore-meta : Restore meta data before restoring data"
  echo "--backup_path       : Path to backup files"
  echo ""
  echo "Optional Section for ndb_shutdown is empty:"
  echo "-------------------------------------------"
  echo "--ndb_shutdown runs a shutdown command that stops all ndb_mgmd's"

  echo "and ndbd's in the cluster, a mysqld is stoppped using --mysqld_shutdown"
  echo ""
  echo "Optional Section for mysqld_shutdown:"
  echo "-------------------------------------"
  echo "--mysqld_shutdown shuts down a mysqld by using mysqladmin"
  echo "--mysql_port        : Port number mysqladmin will connect to"
  echo "--mysql_host        : Hostname mysqladmin will bind to (default is hostname used)"
  echo ""
  echo "Optional Section for drizzled_shutdown:"
  echo "-------------------------------------"
  echo "--drizzled_shutdown shuts down a drizzled by using drizzle"
  echo "--mysql_port        : Port number drizzle will connect to"
  echo "--mysql_host        : Hostname drizzle will bind to (default is hostname used)"
  echo ""
}

validate_parameter()
{
  if test "x$2" != "x$3" ; then
    usage "wrong argument '$2' for parameter '-$1'"
    exit 1
  fi
}

add_set_ld_lib_path()
{
  if test "x$SET_LD_LIB_PATH" = "x" ; then
    SET_LD_LIB_PATH="$1"
  else
    SET_LD_LIB_PATH="$SET_LD_LIB_PATH:$1"
  fi
}

NDB_BACKUP_ID=
NDB_RESTORE_NODEID=
NDB_BACKUP_RESTORE_META=
NDB_BACKUP_PATH=
NDB_USER=$USER
MYSQL_VERSION="mysql-5.1.14-beta"
INITIAL=
NDB_CONNECTSTRING=
NDBD=
NDBD_SUBDIR=
MYSQLD_SUBDIR=
MYSQL_SCRIPTS_SUBDIR=
NDB_MGMD_SUBDIR=
NDB_MGM_SUBDIR=
PROCESS=
INNODB_OPTION=
GRANT_TABLE_OPTION="--skip-grant-tables"
JOIN_BUFFER_SIZE="--join_buffer_size=1000000"
MAX_CONNECTIONS="1000"
OPEN_FILES_LIMIT="--open-files-limit=4096"
ENGINE_CONDITION_PUSHDOWN_OPTION="--engine-condition-pushdown=1"
NDB_USE_EXACT_COUNT_OPTION="--ndb-use-exact-count=0"
NDB_USE_TRANSACTIONS_OPTION="--ndb-use-transactions=1"
NDB_FORCE_SEND_OPTION="--ndb-force-send=1"
NDB_MGMD_HOST=
NDB_MGMD_PORT="1186"
MYSQL_NO="1"
NDB_NODEID=
SSH_PORT=
NDB_CONFIG_FILE=
OPTIMIZED_NODE_SELECTION_OPTION=
MYSQL_HOST="127.0.0.1"
MYSQL_PORT="3306"
MYSQL_BASE="5.1"
DATA_DIR_BASE=
TMP_BASE="/tmp"
HOME_BASE="$HOME"
VERBOSE_FLAG="no"
PRELOAD_COMMAND=
USE_SSOCKS="no"
DRIZZLE_PATH=
ERROR_PIPE=
DRIZZLE_VERSION=
LIBDRIZZLE_PATH=
MYSQL_PATH=
NDB_CLUSTERID=
NDB_CLUSTERID_NAME=
DEFAULT_FILE=
CORE_FILE_USED=
CORE_FILE_OPTIONS=
GENERAL_QUERY_LOG=
SLOW_QUERY_LOG=
MYSQL_ARGS=
MYSQL_CMD=
MYSQL_USER="root"
USE_PASSWD=
START_SLAVE=
MYSQL_DB="test"
NDB_AUTOINCREMENT_OPTION="256"
SERVER_TASKSET=
NDB_ENABLED="yes"
INNODB_READ_IO_THREADS=
INNODB_WRITE_IO_THREADS=
INNODB_THREAD_CONCURRENCY=
INNODB_FLUSH_LOG_AT_TRX_COMMIT=
INNODB_LOG_FILE_SIZE=
INNODB_BUFFER_POOL_SIZE=
INNODB_LOG_BUFFER_SIZE=
INNODB_ADAPTIVE_HASH_INDEX=
INNODB_READ_AHEAD_THRESHOLD=
INNODB_FLUSH_METHOD=
INNODB_STATS_ON_MUTEXES=
INNODB_MONITOR=
USE_LARGE_PAGES=
LOCK_ALL=
KEY_BUFFER_SIZE=
MAX_HEAP_TABLE_SIZE=
TMP_TABLE_SIZE=
MAX_TMP_TABLES=
TABLE_CACHE_SIZE="400"
TABLE_CACHE_INSTANCES=""
TMP_PATH="/tmp"
MALLOC_LIB="/usr/lib64/libtcmalloc_minimal.so"
GREP=
DEFAULT_DIR="$HOME/.build"
USE_SUPERSOCKET=
USE_INFINIBAND=
PERFSCHEMA_FLAG=
WINDOWS_INSTALL="no"
MYSQL_INIT_ARGS=
TRANSACTION_ISOLATION=
MSG=
CLUSTER_HOME=

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
  if test -f "$DEFAULT_FILE" ; then
    . ${DEFAULT_FILE}
  fi


while test $# -gt 0
do
  case $1 in
    --use-core-file | --use_core_file | -use-core-file | -use_core_file )
      CORE_FILE_USED="yes"
      ;;
    --home_base | -home_base | --home-base | -home-base )
      shift
      HOME_BASE="$1"
      ;;
    --use_slow_query_log )
      SLOW_QUERY_LOG="--log-slow-queries"
      ;;
    --use_general_query_log )
      GENERAL_QUERY_LOG="--log"
      ;;
    --tmp_base | -tmp_base | --tmp-base | -tmp-base )
      shift
      TMP_BASE="$1"
      ;;
    --taskset )
      shift
      SERVER_TASKSET="taskset $1"
      ;;
    --verbose | -verbose )
      VERBOSE_FLAG="yes"
      ;;
    --mysql-no | --mysql_no )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      MYSQL_NO="$1"
      ;;
      
    --innodb_thread_concurrency )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      INNODB_THREAD_CONCURRENCY="$1"
      ;;
      
    --innodb_read_io_threads )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      INNODB_READ_IO_THREADS="$1"
      ;;
      
    --innodb_write_io_threads )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      INNODB_WRITE_IO_THREADS="$1"
      ;;
      
    --innodb_buffer_pool_size )
      shift
      INNODB_BUFFER_POOL_SIZE="$1"
      ;;
      
    --innodb_flush_log_at_trx_commit )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      INNODB_FLUSH_LOG_AT_TRX_COMMIT="$1"
      ;;
      
    --innodb_log_file_size )
      shift
      INNODB_LOG_FILE_SIZE="$1"
      ;;
      
    --innodb_log_buffer_size )
      shift
      INNODB_LOG_BUFFER_SIZE="$1"
      ;;
      
    --key_buffer_size )
      shift
      KEY_BUFFER_SIZE="$1"
      ;;
      
    --max_heap_table_size )
      shift
      MAX_HEAP_TABLE_SIZE="$1"
      ;;
      
    --tmp_table_size )
      shift
      TMP_TABLE_SIZE="$1"
      ;;
      
    --max_tmp_tables )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      MAX_TMP_TABLES="$1"
      ;;
      
    --base-version | -base-version | --base_version | -base_version )
      shift
      MYSQL_BASE="$1"
      ;;
    --user | -user | -u )
      shift
      NDB_USER=$1
      ;;
    --version | --ver | -version | -ver | -v )
      shift
      MYSQL_VERSION=$1
      ;;
    --data_dir_base | -data_dir_base | --data-dir-base | -data-dir-base )
      shift
      DATA_DIR_BASE=$1
      ;;
    --initial | -initial | -init | --init | -i )
      INITIAL="--initial"
      ;;
    --tc_select | -tc_select | --tc-select | -tc-select )
      shift
      OPTIMIZED_NODE_SELECTION="--ndb-optimized-node-selection=$1"
      ;;
    --enable-innodb | --enable_innodb | -enable-innodb | -enable_innodb )
      INNODB_OPTION="--innodb"
      ;;
    --enable-grants | -enable-grants | --enable_grants | -enable_grants )
      GRANT_TABLE_OPTION=""
      ;;

    --mgm_host | -mgm_host | --mgm-host | -mgm-host )
      shift
      NDB_MGMD_HOST="$1"
      ;;
    --ndb_autoincrement_size )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      NDB_AUTOINCREMENT_OPTION="$1"
      ;;
    --mgm_port | -mgm_port | --mgm-port | -mgm-port )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      NDB_MGMD_PORT="$1"
      ;;
    --mysql_port | -mysql_port | --mysql-port | -mysql-port )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      MYSQL_PORT="$1"
      ;;
    --mysql_host | -mysql_host | --mysql-host | -mysql-host )
      shift
      MYSQL_HOST="$1"
      ;;
    --max-connections | -max-connections | --max_connections | -max_connections )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      MAX_CONNECTIONS="$1"
      ;;
    --use-exact-count | -use-exact-count | --use_exact_count | -use_exact_count )
      NDB_USE_EXACT_COUNT_OPTION="--ndb-use-exact-count=1"
      ;;
    --no-engine-pushdown | -no-engine-pushdown | --no_engine_pushdown | -no_engine_pushdown )
      ENGINE_CONDITION_PUSHDOWN_OPTION="--engine-condition-pushdown=0"
      ;;
    --no-force-send | --no_force_send | -no-force-send | -no_force_send )
      NDB_FORCE_SEND_OPTION="--ndb-force-send=0"
      ;;
    --backup_path | -backup_path | \
    --backup-path |  -backup-path )
      shift
      NDB_BACKUP_PATH=$1
      ;;
    --backup_restore_meta | -backup_restore_meta | \
    --backup-restore-meta | -backup-restore-meta )
      NDB_BACKUP_RESTORE_META="--restore-meta"
      ;;
    --backup_id | -backup_id | \
    --backup-id | -backup-id )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      NDB_BACKUP_ID=$1
      ;;
    --backup_nodeid | -backup_nodeid | \
    --backup-nodeid | -backup-nodeid | \
    --backup_node_id | -backup_node_id | \
    --backup-node-id | -backup-node-id )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      NDB_RESTORE_NODEID=$1
      ;;
    --clusterid | -clusterid | --cluster-id | -cluster-id | \
    --cluster_id | -cluster_id )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      NDB_CLUSTERID="$1"
      ;;
    --nodeid | -nodeid | --node-id | -node-id | --node_id | -node_id )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      NDB_NODEID=$1
      ;;
    --config-file | -config-file | --config_file | -config_file | --conf-file | \
    -conf-file | --conf_file | -conf_file | --configuration-file )
      shift
      NDB_CONFIG_FILE="${1}"
      ;;
    --binary | -binary )
      NDBD_SUBDIR="libexec"
      MYSQLD_SUBDIR="libexec"
      MYSQLD_SAFE_SUBDIR="bin"
      NDB_MGMD_SUBDIR="bin"
      ;;
    --ssh-port | --ssh_port )
      opt=$1
      shift
      TMP=`echo $1 | egrep "^[0-9]+$"`
      validate_parameter $opt $1 $TMP
      SSH_PORT="$1"
      ;;
    --ndb_shutdown | --ndb-shutdown | -ndb_shutdown | -ndb-shutdown )
      if test "x$PROCESS" = "x" ; then
        PROCESS="ndb_mgm"
        MGM_CMD="mgm_cmd"
        MGM_COMMAND="-e 'shutdown'"
      else
        MSG="NDB shutdown error"
        output_msg
        usage
        exit 1
      fi
      ;;
    --backup | -backup )
      if test "x$PROCESS" = "x" ; then
        PROCESS="ndb_mgm"
        MGM_CMD="backup"
      else
        MSG="Backup error"
        output_msg
        usage
        exit 1
      fi
      ;;
    --mgm_cmd | --mgm-cmd | -mgm_cmd | -mgm-cmd )
      shift
      if test "x$PROCESS" = "x" ; then
        PROCESS="ndb_mgm"
        MGM_CMD="mgm_cmd"
        MGM_COMMAND="-e"
        break;
      else
        MSG="Management Command error"
        output_msg
        usage
        exit 1
      fi
      ;;
    --mysql )
      if test "x$PROCESS" = "x" ; then
        PROCESS="mysql"
      else
        MSG="mysql error"
        output_msg
        usage
        exit 1
      fi
      ;;
    --mysql_user )
      shift
      MYSQL_USER=$1
      ;;
    --mysql_db )
      shift
      MYSQL_DB=$1
      ;;
    --use_passwd )
      USE_PASSWD="yes"
      ;;
    --start-slave )
      START_SLAVE="yes"
      ;;
    --mysql_cmd )
      shift
      if test "x$PROCESS" = "x" ; then
        PROCESS="mysql"
        MYSQL_CMD=""
        for i in "$@"
        do
          MYSQL_CMD="$MYSQL_CMD "$i""
        done
        break;
      else
        MSG="Trying to use mysql client, already defined another process"
        output_msg
        usage
        exit 1
      fi
      ;;
    --mysql_install_db | -mysql_install_db | \
    --mysql-install-db | -mysql-install-db )
      if test "x$PROCESS" = "x" ; then
        PROCESS="mysql_install_db"
      else
        MSG="mysql_install_db error"
        output_msg
        usage
        exit 1
      fi
      ;;
    --mysqld_safe | -mysqld_safe | --mysqld-safe | -mysqld-safe )
      if test "x$PROCESS" = "x" ; then
        PROCESS="mysqld_safe"
      else
        MSG="mysqld_safe error"
        output_msg
        usage
        exit 1
      fi
      ;;
    --ndbd | -ndbd )
      if test "x$PROCESS" = "x" ; then
        PROCESS="ndbd"
      else
        MSG="ndbd error"
        output_msg
        usage
        exit 1
      fi
      ;;
    --mysqld_shutdown | --mysqld-shutdown | -mysqld-shutdown | \
    -mysqld_shutdown )
      if test "x$PROCESS" = "x" ; then
        PROCESS="mysqld_shutdown"
      else
        MSG="mysqld_shutdown error"
        output_msg
        usage
        exit 1
      fi
      ;;
    --drizzled_shutdown )
      if test "x$PROCESS" = "x" ; then
        PROCESS="drizzled_shutdown"
      else
        MSG="drizzled_shutdown error"
        output_msg
        usage
        exit 1
      fi
      ;;
    --drizzled )
      if test "x$PROCESS" = "x" ; then
        PROCESS="drizzled"
      else
        MSG="drizzled error"
        output_msg
        usage
        exit 1
      fi
      ;;
    --mysqld | -mysqld )
      if test "x$PROCESS" = "x" ; then
        PROCESS="mysqld"
      else
        MSG="mysqld error"
        output_msg
        usage
        exit 1
      fi
      ;;
    --ndb_mgmd | -ndb_mgmd | -ndb-mgmd | --ndb-mgmd )
      if test "x$PROCESS" = "x" ; then
        PROCESS="ndb_mgmd"
      else
        MSG="ndb_mgmd error"
        output_msg
        usage
        exit 1
      fi
      ;;
    --ndb_mgm | -ndb_mgm | -ndb-mgm | --ndb-mgm )
      if test "x$PROCESS" = "x" ; then
        PROCESS="ndb_mgm"
      else
        MSG="ndb_mgm error"
        output_msg
        usage
        exit 1
      fi
      ;;
    --supersockets | -sci | -supersocket | --sci | --super_socket | \
    --super_sockets | -super_sockets | -super-sockets | --super-sockets | \
    -supersockets | --supersocket | -super_socket | --super-socket | \
    -super-socket | -ssocks | --ssocks )
      if test "x$USE_SSOCKS" = "xdont" ; then
        MSG="Already set infiniband"
        output_msg
        usage
        exit 1
      fi
      USE_SSOCKS="yes"
      USE_SUPERSOCKET="yes"
      ;;
    --infiniband | -infiniband )
      if test "x$USE_SSOCKS" = "xyes" ; then
        MSG="Already set Dolphin Supersockets"
        output_msg
        usage
        exit 1
      fi
      USE_SSOCKS="dont"
      USE_INFINIBAND="yes"
      ;;
    --ndb-connectstring | -ndb-connectstring | -connectstring | \
    --connectstring | --connect-string | --connect_string | \
    -connect-string | -connect_string )
      shift
      NDB_CONNECTSTRING="$1"
      ;;
    --mysql-path | --mysql_path | -mysql-path | -mysql_path )
      shift
      MYSQL_PATH="$1"
      ;;
    --help )
      usage
      exit 1
      ;;
    -* )
      MSG="Unrecognized option: $1"
      output_msg
      usage
      exit 1
      ;;
    * )
      break
      ;;
  esac
  shift
done

HOSTNAME_BINARY="$1"
if test "x$MGM_CMD" = "xmgm_cmd" && test "x$MGM_COMMAND" = "x-e" ; then
  MGM_COMMAND="$MGM_COMMAND '"
  for cmd in $@
  do
    MGM_COMMAND="$MGM_COMMAND $cmd"
  done
  MGM_COMMAND="$MGM_COMMAND '"
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
if test -f "$DEFAULT_FILE" ; then
  MSG="Sourcing defaults from $DEFAULT_FILE"
  output_msg
else
  MSG="No iclaustron.conf file found, using standard defaults"
  output_msg
fi

if test "x$USE_SUPERSOCKET" = "xyes" ; then
  PRELOAD_COMMAND="export LD_PRELOAD=libksupersockets.so"
  if test "x$SUPERSOCKET_LIB" != "x" ; then
    add_set_ld_lib_path $SUPERSOCKET_LIB
  fi
else
  if test "x$USE_INFINIBAND" = "xyes" ; then
    PRELOAD_COMMAND="export LD_PRELOAD=libsdp.so"
    if test "x$INFINIBAND_LIB" != "x" ; then
      add_set_ld_lib_path $INFINIBAND_LIB
    fi
  fi
fi

if test "x$DATA_DIR_BASE" = "x" ; then
  DATA_DIR_BASE="$HOME_BASE/mysql"
fi
if test "x$MYSQL_PATH" = "x" ; then
  MYSQL_PATH="$HOME_BASE/mysql/$MYSQL_VERSION"
  BASE_DIR="$HOME_BASE/mysql/$MYSQL_VERSION"
else
  BASE_DIR="$MYSQL_PATH"
fi
if test "x${MYSQL_PATH_LOCAL}" = "x" ; then
  MYSQL_PATH_LOCAL="${MYSQL_PATH}"
fi
SOCKET_OPTION="--socket=${TMP_BASE}/mysql_$MYSQL_NO.sock"
DATA_DIR="$DATA_DIR_BASE/var_$MYSQL_NO"
PID_FILE="$TMP_BASE/mysqld_$MYSQL_NO.pid"
LOG_ERROR="--log-error=${DATA_DIR}/error.log"
TMP_DIR="--tmpdir=$TMP_BASE"

if test "x$MYSQL_BASE" = "x5.1" ; then
  if test "x$USE_BINARY_MYSQL_TARBALL" = "xno" ; then
    LANGUAGE_OPTION="--language=${BASE_DIR}/share/mysql/english"
  else
    LANGUAGE_OPTION="--language=${BASE_DIR}/share/english"
  fi
else
  LANGUAGE_OPTION="--lc-messages-dir=${BASE_DIR}/share"
  LANGUAGE_OPTION="--lc-messages=en_US"
fi

if test "x$NDB_CLUSTERID" != "x" ; then
  NDB_CLUSTERID_NAME="_c"$NDB_CLUSTERID""
fi
if test "x$NDB_CONFIG_FILE" = "x" ; then
  NDB_CONFIG_FILE="$HOME_BASE/.build/config"$NDB_CLUSTERID_NAME".ini"
fi
if test "x$USE_MALLOC_LIB" = "xyes" ; then
  MALLOC_FILE=`basename "${MALLOC_LIB}"`
  MALLOC_PATH=`dirname "${MALLOC_LIB}"`
  if test "x${PRELOAD_COMMAND}" = "x" ; then
    PRELOAD_COMMAND="export LD_PRELOAD=${MALLOC_FILE}"
  else
    PRELOAD_COMMAND="${PRELOAD_COMMAND} ${MALLOC_FILE}"
  fi
  add_set_ld_lib_path ${MALLOC_PATH}
fi
if test "x${PRELOAD_COMMAND}" != "x" ; then
  PRELOAD_COMMAND="${PRELOAD_COMMAND} ;"
  if test "x${SET_LD_LIB_PATH}" != "x" ; then
    PRELOAD_COMMAND="export LD_LIBRARY_PATH=${SET_LD_LIB_PATH} ;${PRELOAD_COMMAND}"
  fi
fi
NDB_INDEX_STAT_ENABLE_OPTION="--ndb-index-stat-enable=0"
if test "x$PROCESS" = "xndb_restore" ; then
  HOSTNAME_BINARY="ndb_restore"
fi
if test "x$HOSTNAME_BINARY" = "x" && test "x$PROCESS" != "xndb_mgm" ; then
  MSG="Binary error"
  output_msg
  usage
  exit 1
fi
if test "x$PROCESS" = "xndb_restore" && test "x$NDB_BACKUP_PATH" = "x" ; then
  MSG="ndb_restore requires a backup path"
  output_msg
  usage
  exit 1
fi
if test "x$NDB_NODEID" != "x" ; then
  NDB_NODEID="--ndb-nodeid=$NDB_NODEID"
fi
if test "x$PROCESS" = "x" ; then
  MSG="Process error"
  output_msg
  usage
  exit 1
fi
if test "x$NDB_MGMD_HOST" = "x" ; then
  NDB_MGMD_HOST="10.0.0.2"
fi
if test "x$NDB_CONNECTSTRING" = "x" ; then
  NDB_CONNECTSTRING="$NDB_MGMD_HOST:$NDB_MGMD_PORT"
fi
NDB_CONNECTSTRING="--ndb-connectstring=$NDB_CONNECTSTRING"

MYSQLD_BIN="mysqld"
if test "x$PROCESS" = "xmysqld_safe" ; then
  MYSQLD_BIN="mysqld_safe"
  MYSQLD_ARGS="$MYSQLD_ARGS --ledir=\$MYSQLD_SUBDIR"
  PROCESS="mysqld"
fi
#Need to find the mysqld binary on the remote side
MYSQLD_ARGS=""
MYSQLD_CMD="MYSQLD=\"\";"
MYSQLD_CMD="${MYSQLD_CMD}if test -f ${MYSQL_PATH}/bin/${MYSQLD_BIN} ; then"
MYSQLD_CMD="${MYSQLD_CMD}  MYSQLD=\"${SERVER_TASKSET} ${MYSQL_PATH}/bin/${MYSQLD_BIN}\";"
MYSQLD_CMD="${MYSQLD_CMD}  MYSQLD_SUBDIR=\"${MYSQL_PATH}/bin\";"
MYSQLD_CMD="${MYSQLD_CMD}fi;"
MYSQLD_CMD="${MYSQLD_CMD}if test -f ${MYSQL_PATH}/sbin/${MYSQLD_BIN} ; then"
MYSQLD_CMD="${MYSQLD_CMD}  MYSQLD=\"${SERVER_TASKSET} ${MYSQL_PATH}/sbin/${MYSQLD_BIN}\";"
MYSQLD_CMD="${MYSQLD_CMD}  MYSQLD_SUBDIR=\"${MYSQL_PATH}/sbin\";"
MYSQLD_CMD="${MYSQLD_CMD}fi;"
MYSQLD_CMD="${MYSQLD_CMD}if test -f ${MYSQL_PATH}/libexec/${MYSQLD_BIN} ; then"
MYSQLD_CMD="${MYSQLD_CMD}  MYSQLD=\"${SERVER_TASKSET} ${MYSQL_PATH}/libexec/${MYSQLD_BIN}\";"
MYSQLD_CMD="${MYSQLD_CMD}  MYSQLD_SUBDIR=\"${MYSQL_PATH}/libexec\";"
MYSQLD_CMD="${MYSQLD_CMD}fi;"
MYSQLD_CMD="${MYSQLD_CMD}if test \"x\${MYSQLD}\" = \"x\" ; then"
MYSQLD_CMD="${MYSQLD_CMD}  echo \"No mysqld binary in path\";"
MYSQLD_CMD="${MYSQLD_CMD}  exit 1;"
MYSQLD_CMD="${MYSQLD_CMD}fi;"
MYSQLD_CMD="${MYSQLD_CMD} echo \"Using binary from \${MYSQLD}\";"
DRIZZLED_CMD="DRIZZLED=\"\";"
DRIZZLED_CMD="${DRIZZLED_CMD}if test -f ${DRIZZLE_PATH}/sbin/drizzled ; then"
DRIZZLED_CMD="${DRIZZLED_CMD}  DRIZZLED=\"${SERVER_TASKSET} ${DRIZZLE_PATH}/sbin/drizzled\";"
DRIZZLED_CMD="${DRIZZLED_CMD}fi;"
DRIZZLED_CMD="${DRIZZLED_CMD}if test \"x\${DRIZZLED}\" = \"x\" ; then"
DRIZZLED_CMD="${DRIZZLED_CMD}  echo \"No drizzled binary in path\";"
DRIZZLED_CMD="${DRIZZLED_CMD}  exit 1;"
DRIZZLED_CMD="${DRIZZLED_CMD}fi;"
DRIZZLED_CMD="${DRIZZLED_CMD}if test \"x\${LD_LIBRARY_PATH}\" = \"x\" ; then"
DRIZZLED_CMD="${DRIZZLED_CMD}  export LD_LIBRARY_PATH=\"${LIBDRIZZLE_PATH}/lib\";"
DRIZZLED_CMD="${DRIZZLED_CMD}else"
DRIZZLED_CMD="${DRIZZLED_CMD}  export LD_LIBRARY_PATH=\"${LD_LIBRARY_PATH}:${LIBDRIZZLE_PATH}/lib\";"
DRIZZLED_CMD="${DRIZZLED_CMD}fi;"
DRIZZLED_CMD="${DRIZZLED_CMD}mkdir -p ${DATA_DIR};"
DRIZZLED_CMD="${DRIZZLED_CMD}if ! test -f ${DATA_DIR}/error.log ; then"
DRIZZLED_CMD="${DRIZZLED_CMD}  touch ${DATA_DIR}/error.log;"
DRIZZLED_CMD="${DRIZZLED_CMD}fi;"
DRIZZLED_CMD="${DRIZZLED_CMD}echo \"Using binary from \${DRIZZLED}\";"
DRIZZLED_CMD="${DRIZZLED_CMD}echo \"Using LD_LIBRARY_PATH = \${LD_LIBRARY_PATH}\";"
#Need to adapt to where language file is on Windows vs. others
MYSQL_LANG_CMD="LANG=\"\";"
if test "x$MYSQL_BASE" = "x5.5" || \
   test "x$MYSQL_BASE" = "x5.6" ; then
  MYSQL_LANG_CMD="${MYSQL_LANG_CMD} if test -d ${MYSQL_PATH}/share/mysql ; then"
  MYSQL_LANG_CMD="${MYSQL_LANG_CMD}   LANG=\"$MYSQL_PATH/share/mysql\";"
  MYSQL_LANG_CMD="${MYSQL_LANG_CMD} else"
  MYSQL_LANG_CMD="${MYSQL_LANG_CMD}   LANG=\"$MYSQL_PATH/share\";"
  MYSQL_LANG_CMD="${MYSQL_LANG_CMD} fi;"
  MYSQL_LANG_CMD="${MYSQL_LANG_CMD} echo \"Using error messages from \${LANG}\";"
  MYSQL_LANG_CMD="${MYSQL_LANG_CMD} LANG=\"--lc-messages-dir=\$LANG\";"
else
  MYSQL_LANG_CMD="${MYSQL_LANG_CMD} if test -d ${MYSQL_PATH}/share/english ; then"
  MYSQL_LANG_CMD="${MYSQL_LANG_CMD}   LANG=\"$MYSQL_PATH/share/english\";"
  MYSQL_LANG_CMD="${MYSQL_LANG_CMD} else"
  MYSQL_LANG_CMD="${MYSQL_LANG_CMD}   LANG=\"$MYSQL_PATH/share/mysql/english\";"
  MYSQL_LANG_CMD="${MYSQL_LANG_CMD} fi;"
  MYSQL_LANG_CMD="${MYSQL_LANG_CMD} echo \"Using error messages from \${LANG}\";"
  MYSQL_LANG_CMD="${MYSQL_LANG_CMD} LANG=\"--language=\$LANG\";"
fi
#Need to find ndbd/ndbmtd binary on remote node
NDBD_BIN="ndbd"
if test "x${USE_NDBMTD}" = "xyes" ; then
  NDBD_BIN="ndbmtd"
fi
NDBD_CMD=
if test "x$CLUSTER_HOME" != "x" ; then
  NDBD_CMD="NDB_HOME=\"${CLUSTER_HOME}\";export NDB_HOME;"
fi
NDBD_CMD="${NDBD_CMD}NDBD=\"\";"
NDBD_CMD="${NDBD_CMD}if test -f ${MYSQL_PATH}/bin/${NDBD_BIN} ; then"
NDBD_CMD="${NDBD_CMD}  NDBD=\"${MYSQL_PATH}/bin/${NDBD_BIN}\";"
NDBD_CMD="${NDBD_CMD}fi;"
NDBD_CMD="${NDBD_CMD}if test -f ${MYSQL_PATH}/libexec/${NDBD_BIN} ; then"
NDBD_CMD="${NDBD_CMD}  NDBD=\"${MYSQL_PATH}/libexec/${NDBD_BIN}\";"
NDBD_CMD="${NDBD_CMD}fi;"

#Need to find ndb_mgmd binary on remote node
NDB_MGMD_CMD=
if test "x$CLUSTER_HOME" != "x" ; then
  NDB_MGMD_CMD="NDB_HOME=\"${CLUSTER_HOME}\";export NDB_HOME;"
fi
NDB_MGMD_CMD="${NDB_MGMD_CMD}NDB_MGMD=\"\";"
NDB_MGMD_CMD="${NDB_MGMD_CMD}if test -f ${MYSQL_PATH}/bin/ndb_mgmd ; then"
NDB_MGMD_CMD="${NDB_MGMD_CMD}  NDB_MGMD=\"${MYSQL_PATH}/bin/ndb_mgmd\";"
NDB_MGMD_CMD="${NDB_MGMD_CMD}fi;"
NDB_MGMD_CMD="${NDB_MGMD_CMD}if test -f ${MYSQL_PATH}/libexec/ndb_mgmd ; then"
NDB_MGMD_CMD="${NDB_MGMD_CMD}  NDB_MGMD=\"${MYSQL_PATH}/libexec/ndb_mgmd\";"
NDB_MGMD_CMD="${NDB_MGMD_CMD}fi;"

if test "x$NDB_ENABLED" = "xyes" ; then
  NDBD_CMD="${NDBD_CMD}if test \"x\${NDBD}\" = \"x\" ; then"
  NDBD_CMD="${NDBD_CMD}  echo \"No ${NDBD_BINARY} binary in path\";"
  NDBD_CMD="${NDBD_CMD}  exit 1;"
  NDBD_CMD="${NDBD_CMD}fi;"
  NDBD_CMD="${NDBD_CMD}\${NDBD}"
  NDB_MGMD_CMD="${NDB_MGMD_CMD}if test \"x\${NDB_MGMD}\" = \"x\" ; then"
  NDB_MGMD_CMD="${NDB_MGMD_CMD}  echo \"No ndb_mgmd binary in path\";"
  NDB_MGMD_CMD="${NDB_MGMD_CMD}  exit 1;"
  NDB_MGMD_CMD="${NDB_MGMD_CMD}fi;"
  NDB_MGMD_CMD="${NDB_MGMD_CMD}\${NDB_MGMD} $NDB_NODEID"
  NDB_MGMD_CMD="${NDB_MGMD_CMD} $NDB_CONNECTSTRING"
  NDB_MGMD_CMD="${NDB_MGMD_CMD} --config-file=$NDB_CONFIG_FILE"
  NDB_MGMD_CMD="${NDB_MGMD_CMD} $INITIAL --skip-config-cache"
  NDB_MGM="$MYSQL_PATH_LOCAL/bin/ndb_mgm"
  if test ! -f "$NDB_MGM" ; then
    MSG="No ndb_mgm binary in $MYSQL_PATH"
    output_msg
    exit 1
  fi
fi

NDB_RESTORE="$MYSQL_PATH_LOCAL/bin/ndb_restore"
MYSQLD_SHUTDOWN="$MYSQL_PATH/bin/mysqladmin"
DRIZZLED_SHUTDOWN="${DRIZZLE_PATH}/bin/drizzle"
if test "x$CORE_FILE_USED" = "xyes" ; then
  CORE_FILE_OPTIONS="--core-file"
  if test "x$PROCESS" = "xmysqld_safe" ; then
    CORE_FILE_OPTIONS="$CORE_FILE_OPTIONS --core-file-size=unlimited"
  fi
fi
if test "x$PROCESS" = "xndbd" ; then
  if test "x${HOSTNAME_BINARY}" != "xlocalhost" && \
     test "x${HOSTNAME_BINARY}" != "x127.0.0.1" ; then
    COMMAND="'ulimit -c unlimited; $PRELOAD_COMMAND $NDBD_CMD $NDB_CONNECTSTRING $INITIAL $NDB_NODEID $CORE_FILE_OPTIONS'"
  else
    COMMAND="ulimit -c unlimited; $PRELOAD_COMMAND $NDBD_CMD $NDB_CONNECTSTRING $INITIAL $NDB_NODEID $CORE_FILE_OPTIONS"
  fi
fi
if test "x$PROCESS" = "xmysqld_shutdown" ; then
  COMMAND="$MYSQLD_SHUTDOWN --no-defaults --protocol=TCP"
  COMMAND="${COMMAND} --port=$MYSQL_PORT --host=$MYSQL_HOST -u root shutdown"
fi
if test "x$PROCESS" = "xdrizzled_shutdown" ; then
  COMMAND="if test \"x\${LD_LIBRARY_PATH}\" = \"x\" ; then"
  COMMAND="${COMMAND}  export LD_LIBRARY_PATH=\"${LIBDRIZZLE_PATH}/lib\";"
  COMMAND="${COMMAND}else"
  COMMAND="${COMMAND}  export LD_LIBRARY_PATH=\"${LD_LIBRARY_PATH}:${LIBDRIZZLE_PATH}/lib\";"
  COMMAND="${COMMAND}fi;"
  COMMAND="${COMMAND} ${DRIZZLED_SHUTDOWN} --no-defaults --port=${MYSQL_PORT}"
  COMMAND="${COMMAND} --host=${MYSQL_HOST} --shutdown"
fi
if test "x$PROCESS" = "xmysql_install_db" ; then
  if test -f "$MYSQL_PATH/bin/mysql_install_db" ; then
    MYSQL_INIT_ARGS="$MYSQL_PATH/bin/mysql_install_db"
  fi
  if test -f "$MYSQL_PATH/scripts/mysql_install_db" ; then
    MYSQL_INIT_ARGS="$MYSQL_PATH/scripts/mysql_install_db"
  fi
  if test "x$MYSQL_INIT_ARGS" = "x" ; then
    echo "Found no mysql_install_db in $MYSQL_PATH, neither in bin or scripts directory"
    exit 1
  fi
  if test "x$INNODB_LOG_DIR" != "x" ; then
    MYSQL_INIT_ARGS="$MYSQL_INIT_ARGS --innodb_log_group_home_dir=$INNODB_LOG_DIR"
    RM_DIR="$INNODB_LOG_DIR/*"
    if test "x$INNODB_LOG_DIR" != "x$DATA_DIR" ; then
      rm -rf $RM_DIR
    fi
  fi
  if test "x$INNODB_FILE_FORMAT" != "x" ; then
    MYSQL_INIT_ARGS="$MYSQL_INIT_ARGS --innodb_file_format=$INNODB_FILE_FORMAT"
  fi
  if test "x$INNODB_LOG_FILE_SIZE" != "x" ; then
    MYSQL_INIT_ARGS="$MYSQL_INIT_ARGS --innodb-log-file-size=$INNODB_LOG_FILE_SIZE"
  fi
  MYSQL_INIT_ARGS="$MYSQL_INIT_ARGS --no-defaults"
  MYSQL_INIT_ARGS="$MYSQL_INIT_ARGS --basedir=${BASE_DIR}"
  MYSQL_INIT_ARGS="$MYSQL_INIT_ARGS --datadir=${DATA_DIR}"
  MYSQL_INIT_ARGS="$MYSQL_INIT_ARGS --pid-file=${PID_FILE}"
  MYSQL_INIT_ARGS="$MYSQL_INIT_ARGS --bind-address=${MYSQL_HOST}"
  MYSQL_INIT_ARGS="$MYSQL_INIT_ARGS --port=$MYSQL_PORT"
  MYSQL_INIT_ARGS="$MYSQL_INIT_ARGS --user=$NDB_USER"
  MYSQL_INIT_ARGS="$MYSQL_INIT_ARGS $SOCKET_OPTION"
  MYSQL_INIT_ARGS="$MYSQL_INIT_ARGS $LANGUAGE_OPTION"
  CMD=""
  if test "x$WINDOWS_INSTALL" = "xyes" ; then
    CMD="$CMD if test -d ${MYSQL_PATH}/data; then"
# On Windows we'll use the prepared data directory in the binary dist
    CMD="$CMD   test -d "$DATA_DIR" &&"
    CMD="$CMD   cd $DATA_DIR &&"
    CMD="$CMD   rm -rf *;"
    CMD="$CMD   test ! -d "$DATA_DIR" &&"
    CMD="$CMD   mkdir -p $DATA_DIR;"
    CMD="$CMD   cp -r ${MYSQL_PATH}/data/mysql ${DATA_DIR};"
    CMD="$CMD   cp -r ${MYSQL_PATH}/data/test ${DATA_DIR};"
    CMD="$CMD else"
# On non-Windows we can use the mysql_install_db script
    CMD="$CMD   ${MYSQL_INIT_ARGS};"
    CMD="$CMD fi;"
  else
    CMD="$CMD ${MYSQL_INIT_ARGS};"
  fi
  if test "x$HOSTNAME_BINARY" != "xlocalhost" && \
     test "x$HOSTNAME_BINARY" != "x127.0.0.1" ; then
    COMMAND="'$CMD'"
  else
    COMMAND="$CMD"
  fi
fi
if test "x${PROCESS}" = "xmysqld" || \
   test "x${PROCESS}" = "xdrizzled" ; then
  MYSQLD_ARGS="--no-defaults $MYSQLD_ARGS"
  MYSQLD_ARGS="$MYSQLD_ARGS $INNODB_OPTION"
  if test "x$INNODB_OPTION" != "x" ; then
    if test "x$MYSQL_BASE" != "x5.1" ; then
      if test "x$INNODB_USE_PURGE_THREAD" = "xyes" ; then
        MYSQLD_ARGS="$MYSQLD_ARGS --innodb_purge_threads=1"
      fi
      if test "x$INNODB_FILE_FORMAT" != "x" ; then
        MYSQLD_ARGS="$MYSQLD_ARGS --innodb_file_format=$INNODB_FILE_FORMAT"
      fi
    fi
    if test "x$INNODB_BUFFER_POOL_SIZE" != "x" ; then
      MYSQLD_ARGS="$MYSQLD_ARGS --innodb-buffer-pool-size=$INNODB_BUFFER_POOL_SIZE"
    fi
    if test "x$INNODB_LOG_DIR" != "x" ; then
      MYSQLD_ARGS="$MYSQLD_ARGS --innodb_log_group_home_dir=$INNODB_LOG_DIR"
      RM_DIR="$INNODB_LOG_DIR/*"
      if test "x$INNODB_LOG_DIR" != "x$DATA_DIR" ; then
        rm -rf $RM_DIR
      fi
    fi
    if test "x$INNODB_MAX_PURGE_LAG" != "x" ; then
      MYSQLD_ARGS="$MYSQLD_ARGS --innodb_max_purge_lag=$INNODB_MAX_PURGE_LAG"
    fi
    if test "x$INNODB_SUPPORT_XA" = "x" ; then
      MYSQLD_ARGS="$MYSQLD_ARGS --innodb_support_xa=FALSE"
    else
      MYSQLD_ARGS="$MYSQLD_ARGS --innodb_support_xa=$INNODB_SUPPORT_XA"
    fi
    if test "x$INNODB_DIRTY_PAGES_PCT" != "x" ; then
      MYSQLD_ARGS="$MYSQLD_ARGS --innodb_dirty_pages_pct=$INNODB_DIRTY_PAGES_PCT"
    fi
    if test "x$INNODB_OLD_BLOCKS_PCT" != "x" ; then
      MYSQLD_ARGS="$MYSQLD_ARGS --innodb_old_blocks_pct=$INNODB_OLD_BLOCKS_PCT"
    fi
    if test "x$INNODB_FLUSH_METHOD" != "x" ; then
      MYSQLD_ARGS="$MYSQLD_ARGS --innodb_flush_method=$INNODB_FLUSH_METHOD"
    fi
    if test "x$INNODB_FILE_PER_TABLE" != "x" ; then
      MYSQLD_ARGS="$MYSQLD_ARGS --innodb_file_per_table"
    fi
    if test "x$INNODB_THREAD_CONCURRENCY" != "x" ; then
      MYSQLD_ARGS="$MYSQLD_ARGS --innodb-thread-concurrency=$INNODB_THREAD_CONCURRENCY"
    fi
    if test "x$INNODB_FLUSH_LOG_AT_TRX_COMMIT" != "x" ; then
      MYSQLD_ARGS="$MYSQLD_ARGS --innodb-flush-log-at-trx-commit=$INNODB_FLUSH_LOG_AT_TRX_COMMIT"
    fi
    if test "x$INNODB_LOG_FILE_SIZE" != "x" ; then
      MYSQLD_ARGS="$MYSQLD_ARGS --innodb-log-file-size=$INNODB_LOG_FILE_SIZE"
    fi
    if test "x$INNODB_LOG_BUFFER_SIZE" != "x" ; then
      MYSQLD_ARGS="$MYSQLD_ARGS --innodb-log-buffer-size=$INNODB_LOG_BUFFER_SIZE"
    fi
    if test "x$MYSQL_BASE" != "x5.1" ; then
      if test "x${INNODB_IO_CAPACITY}" != "x" ; then
        MYSQLD_ARGS="$MYSQLD_ARGS --innodb-io-capacity=$INNODB_IO_CAPACITY"
      fi
    fi
    if test "x$MYSQL_BASE" = "x5.6" ; then
      if test "x${INNODB_MAX_IO_CAPACITY}" != "x" ; then
        MYSQLD_ARGS="$MYSQLD_ARGS --innodb-io-capacity-max=$INNODB_MAX_IO_CAPACITY"
      fi
      if test "x${INNODB_FLUSH_NEIGHBOURS}" = "xno" ; then
        MYSQLD_ARGS="$MYSQLD_ARGS --innodb-flush-neighbors=0"
      fi
      if test "x${INNODB_SYNC_ARRAY_SIZE}" != "x" ; then
        MYSQLD_ARGS="$MYSQLD_ARGS --innodb-sync-array-size=$INNODB_SYNC_ARRAY_SIZE"
      fi
    fi
    if test "x${INNODB_DOUBLEWRITE}" != "xyes" ; then
      MYSQLD_ARGS="$MYSQLD_ARGS --skip-innodb_doublewrite"
    fi
    if test "x$MYSQL_BASE" != "x5.1" ; then
      if test "x$INNODB_ADAPTIVE_HASH_INDEX" = "x0" ; then
        MYSQLD_ARGS="$MYSQLD_ARGS --skip-innodb-adaptive-hash-index"
      fi
      if test "x$INNDOB_READ_AHEAD_THRESHOLD" != "x" ; then
        MYSQLD_ARGS="$MYSQLD_ARGS --innodb-read-ahead-threshold=$INNODB_READ_AHEAD_THRESHOLD"
      fi
      if test "x$INNODB_READ_IO_THREADS" != "x" ; then
        MYSQLD_ARGS="$MYSQLD_ARGS --innodb-read-io-threads=$INNODB_READ_IO_THREADS"
      fi
      if test "x$INNODB_WRITE_IO_THREADS" != "x" ; then
        MYSQLD_ARGS="$MYSQLD_ARGS --innodb-write-io-threads=$INNODB_WRITE_IO_THREADS"
      fi
      if test "x$INNODB_CHANGE_BUFFERING" != "x" ; then
        MYSQLD_ARGS="$MYSQLD_ARGS --innodb_change_buffering=$INNODB_CHANGE_BUFFERING"
      fi
      if test "x$INNODB_SPIN_WAIT_DELAY" != "x" ; then
        MYSQLD_ARGS="$MYSQLD_ARGS --innodb_spin_wait_delay=$INNODB_SPIN_WAIT_DELAY"
      fi
      if test "x$INNODB_SYNC_SPIN_LOOPS" != "x" ; then
        MYSQLD_ARGS="$MYSQLD_ARGS --innodb_sync_spin_loops=$INNODB_SYNC_SPIN_LOOPS"
      fi
      if test "x$INNODB_STATS_ON_METADATA" != "x" ; then
        MYSQLD_ARGS="$MYSQLD_ARGS --innodb_stats_on_metadata=$INNODB_STATS_ON_METADATA"
      fi
      if test "x$INNODB_STATS_ON_MUTEXES" != "x" ; then
        MYSQLD_ARGS="$MYSQLD_ARGS --innodb_stats_on_mutexes=$INNODB_STATS_ON_MUTEXES"
      fi
      if test "x$INNODB_BUFFER_POOL_INSTANCES" != "x" ; then
        MYSQLD_ARGS="$MYSQLD_ARGS --innodb-buffer-pool-instances=$INNODB_BUFFER_POOL_INSTANCES"
      fi
      if test "x$INNODB_MONITOR" = "xyes" ; then
        MYSQLD_ARGS="$MYSQLD_ARGS --innodb-monitor-enable='%'"
      fi
    fi
  fi
  if test "x${PROCESS}" = "xmysqld" ; then
    MYSQLD_ARGS="$MYSQLD_ARGS $GRANT_TABLE_OPTION"
    if test "x$MAX_TMP_TABLES" != "x" ; then
      MYSQLD_ARGS="$MYSQLD_ARGS --max_tmp_tables=$MAX_TMP_TABLES"
    fi
    if test "x${TRANSACTION_ISOLATION}" != "x" ; then
      MYSQLD_ARGS="$MYSQLD_ARGS --transaction-isolation=${TRANSACTION_ISOLATION}"
    fi
    MYSQLD_ARGS="$MYSQLD_ARGS $PERFSCHEMA_FLAG"
    MYSQLD_ARGS="$MYSQLD_ARGS --query_cache_size=0"
    MYSQLD_ARGS="$MYSQLD_ARGS --query_cache_type=0"
    MYSQLD_ARGS="$MYSQLD_ARGS --max_connections=$MAX_CONNECTIONS"
    MYSQLD_ARGS="$MYSQLD_ARGS --max_prepared_stmt_count=1048576"
    MYSQLD_ARGS="$MYSQLD_ARGS --sort_buffer_size=$SORT_BUFFER_SIZE"
    MYSQLD_ARGS="$MYSQLD_ARGS $SOCKET_OPTION"
    MYSQLD_ARGS="$MYSQLD_ARGS \$LANG"
    MYSQLD_ARGS="$MYSQLD_ARGS $SLOW_QUERY_LOG"
    MYSQLD_ARGS="$MYSQLD_ARGS $GENERAL_QUERY_LOG"
    MYSQLD_ARGS="$MYSQLD_ARGS $LOG_ERROR"
    MYSQLD_ARGS="$MYSQLD_ARGS --bind-address=${MYSQL_HOST}"
  else
# Drizzle specific arguments
    MYSQLD_ARGS="${MYSQLD_ARGS} --multi-thread-max-threads=1000"
    ERROR_PIPE=">> ${DATA_DIR}/error.log 2>&1 " 
  fi
  MYSQLD_ARGS="${MYSQLD_ARGS} --table_open_cache=$TABLE_CACHE_SIZE"
  MYSQLD_ARGS="${MYSQLD_ARGS} --table_definition_cache=$TABLE_CACHE_SIZE"
  if test "x$MYSQL_BASE" = "x5.6" ; then
    if test "x$TABLE_CACHE_INSTANCES" != "x" ; then
      MYSQLD_ARGS="${MYSQLD_ARGS} --table_open_cache_instances=$TABLE_CACHE_INSTANCES"
    fi
  fi
  if test "x$USE_LARGE_PAGES" != "x" ; then
    MYSQLD_ARGS="$MYSQLD_ARGS --large-pages"
  fi
  if test "x$LOCK_ALL" != "x" ; then
    MYSQLD_ARGS="$MYSQLD_ARGS --memlock"
  fi
  if test "x$TMP_TABLE_SIZE" != "x" ; then
    MYSQLD_ARGS="$MYSQLD_ARGS --tmp_table_size=$TMP_TABLE_SIZE"
  fi
  if test "x$MAX_HEAP_TABLE_SIZE" != "x" ; then
    MYSQLD_ARGS="$MYSQLD_ARGS --max_heap_table_size=$MAX_HEAP_TABLE_SIZE"
  fi
  if test "x$KEY_BUFFER_SIZE" != "x" ; then
    MYSQLD_ARGS="$MYSQLD_ARGS --key_buffer_size=$KEY_BUFFER_SIZE"
  fi
  MYSQLD_ARGS="$MYSQLD_ARGS --server-id=$MYSQL_NO"
  if test "x$START_SLAVE" = "xyes" ; then
    MYSQLD_ARGS="$MYSQLD_ARGS --relay-log='$RELAY_LOG'"
  else
    if test "x$BINLOG" != "x" ; then
      MYSQLD_ARGS="$MYSQLD_ARGS --log-bin='$BINLOG'"
      MYSQLD_ARGS="$MYSQLD_ARGS --sync-binlog=$SYNC_BINLOG"
      if test "x$BINLOG_ORDER_COMMITS" != "x" ; then
        MYSQLD_ARGS="$MYSQLD_ARGS --binlog-order-commits=$BINLOG_ORDER_COMMITS"
      fi
    fi
  fi
  MYSQLD_ARGS="$MYSQLD_ARGS $JOIN_BUFFER_SIZE"
  if test "x$NDB_ENABLED" = "xyes" ; then
    MYSQLD_ARGS="$MYSQLD_ARGS --ndb_autoincrement_prefetch_sz=$NDB_AUTOINCREMENT_OPTION"
    MYSQLD_ARGS="$MYSQLD_ARGS $ENGINE_CONDITION_PUSHDOWN_OPTION"
    MYSQLD_ARGS="$MYSQLD_ARGS $NDB_USE_EXACT_COUNT_OPTION"
    MYSQLD_ARGS="$MYSQLD_ARGS $NDB_FORCE_SEND_OPTION"
    MYSQLD_ARGS="$MYSQLD_ARGS $NDB_INDEX_STAT_ENABLE_OPTION"
    MYSQLD_ARGS="$MYSQLD_ARGS $OPTIMIZED_NODE_SELECTION_OPTION"
    MYSQLD_ARGS="$MYSQLD_ARGS --ndbcluster"
    MYSQLD_ARGS="$MYSQLD_ARGS --ndb-extra-logging=0"
    MYSQLD_ARGS="$MYSQLD_ARGS --new"
    if test "x$NDB_MULTI_CONNECTION" != "x" ; then
      MYSQLD_ARGS="${MYSQLD_ARGS} --ndb-cluster-connection-pool=${NDB_MULTI_CONNECTION}"
    else
      MYSQLD_ARGS="$MYSQLD_ARGS $NDB_NODEID"
    fi
    MYSQLD_ARGS="$MYSQLD_ARGS $NDB_CONNECTSTRING"
  fi
  MYSQLD_ARGS="$MYSQLD_ARGS $CORE_FILE_OPTIONS"
  MYSQLD_ARGS="$MYSQLD_ARGS $TMP_DIR"
  MYSQLD_ARGS="$MYSQLD_ARGS --datadir=${DATA_DIR}"
  MYSQLD_ARGS="$MYSQLD_ARGS --basedir=${BASE_DIR}"
  MYSQLD_ARGS="$MYSQLD_ARGS --pid-file=${PID_FILE}"
  MYSQLD_ARGS="$MYSQLD_ARGS --port=$MYSQL_PORT"
  if test "x$NDB_USER" = "xroot" ; then
    MYSQLD_ARGS="$MYSQLD_ARGS --user=$NDB_USER"
  fi
  if test "x${THREADPOOL_SIZE}" != "x" || \
     test "x${THREADPOOL_ALGORITHM}" != "x" || \
     test "x${THREADPOOL_STALL_LIMIT}" != "x" || \
     test "x${THREADPOOL_PRIO_KICKUP_TIMER}" != "x" ; then
    MYSQLD_ARGS="$MYSQLD_ARGS \"--plugin_load=thread_pool=thread_pool.so;"
    MYSQLD_ARGS="${MYSQLD_ARGS}TP_THREAD_STATE=thread_pool.so;"
    MYSQLD_ARGS="${MYSQLD_ARGS}TP_THREAD_GROUP_STATE=thread_pool.so;"
    MYSQLD_ARGS="${MYSQLD_ARGS}TP_THREAD_GROUP_STATS=thread_pool.so\""
    if test "x$THREADPOOL_ALGORITHM" != "x" ; then
      MYSQLD_ARGS="${MYSQLD_ARGS} --thread_pool_algorithm=$THREADPOOL_ALGORITHM"
    fi
    if test "x$THREADPOOL_STALL_LIMIT" != "x" ; then
      MYSQLD_ARGS="${MYSQLD_ARGS} --thread_pool_stall_limit=$THREADPOOL_STALL_LIMIT"
    fi
    if test "x$THREADPOOL_PRIO_KICKUP_TIMER" != "x" ; then
      MYSQLD_ARGS="${MYSQLD_ARGS} --thread_pool_prio_kickup_timer=$THREADPOOL_PRIO_KICKUP_TIMER"
    fi
    if test "x$THREADPOOL_SIZE" != "x" ; then
      MYSQLD_ARGS="$MYSQLD_ARGS --thread_pool_size=${THREADPOOL_SIZE}"
    fi
  fi
  
  if test "x${PROCESS}" = "xmysqld" ; then
      COMMAND="ulimit -c unlimited; $PRELOAD_COMMAND \$MYSQLD $MYSQLD_ARGS"
    if test "x${HOSTNAME_BINARY}" != "xlocalhost" && \
       test "x${HOSTNAME_BINARY}" != "x127.0.0.1" ; then
      COMMAND="'${MYSQLD_CMD} ${MYSQL_LANG_CMD} $COMMAND'&"
    else
      COMMAND="${MYSQLD_CMD} ${MYSQL_LANG_CMD} $COMMAND &"
    fi
  else
    COMMAND="ulimit -c unlimited; $PRELOAD_COMMAND \$DRIZZLED $MYSQLD_ARGS"
    if test "x${HOSTNAME_BINARY}" != "xlocalhost" && \
       test "x${HOSTNAME_BINARY}" != "x127.0.0.1" ; then
      COMMAND="'${DRIZZLED_CMD} ${COMMAND} ${ERROR_PIPE}'&"
    else
      COMMAND="${DRIZZLED_CMD} ${COMMAND} ${ERROR_PIPE} &"
    fi
  fi
fi
if test "x$PROCESS" = "xndb_mgmd" ; then
  if test "x${HOSTNAME_BINARY}" != "xlocalhost" && \
     test "x${HOSTNAME_BINARY}" != "x127.0.0.1" ; then
    COMMAND="'${NDB_MGMD_CMD}'"
  else
    COMMAND="${NDB_MGMD_CMD}"
  fi
fi
if test "x$SSH_PORT" != "x" ; then
  SSH_PORT="-p $SSH_PORT"
fi
SSH="ssh $SSH_PORT -n -l $NDB_USER $HOSTNAME_BINARY"
if test "x$PROCESS" = "xndb_mgm" ; then
  COMMAND="$PRELOAD_COMMAND $NDB_MGM $NDB_NODEID $NDB_CONNECTSTRING"
#ndb_mgm will always execute locally
  SSH=""
fi
if test "x$PROCESS" = "xmysql" ; then
  if test "x$MYSQL_CMD" != "x" ; then
    SSH="ssh $SSH_PORT -n -l $NDB_USER $MYSQL_HOST"
    MYSQL_ARGS="-u root $SOCKET_OPTION --port=$MYSQL_PORT $MYSQL_ARGS"
    MYSQL_ARGS="$MYSQL_ARGS -e \"$MYSQL_CMD\""
    COMMAND="$MYSQL_PATH/bin/mysql $MYSQL_ARGS $MYSQL_DB"
  else
    if test "x$USE_PASSWD" = "xyes" ; then
      MYSQL_ARGS="-p $MYSQL_ARGS"
    fi
    MYSQL_ARGS="--port=$MYSQL_PORT $MYSQL_ARGS"
    MYSQL_ARGS="--host=$MYSQL_HOST $MYSQL_ARGS"
    MYSQL_ARGS="--protocol=tcp $MYSQL_ARGS"
    MYSQL_ARGS="--user=$MYSQL_USER $MYSQL_ARGS"
    SSH=""
    COMMAND="$MYSQL_PATH_LOCAL/bin/mysql $MYSQL_ARGS $MYSQL_DB"
  fi
# This must be the last line since we need to add options backwards
# for MySQL commands to remain at the end of the line
fi

if test "x$PROCESS" = "xndb_restore" ; then
  COMMAND="$NDB_RESTORE $NDB_CONNECTSTRING $NDB_NODEID"
  COMMAND="$COMMAND --backupid=$NDB_BACKUP_ID"
  COMMAND="$COMMAND --nodeid=$NDB_RESTORE_NODEID"
  COMMAND="$COMMAND --restore-data"
  COMMAND="$COMMAND $NDB_BACKUP_RESTORE_META"
  COMMAND="$COMMAND $NDB_BACKUP_PATH"
fi

if test "x$MGM_CMD" = "xbackup" ; then
  COMMAND="$COMMAND -e 'start backup wait completed'"
fi

if test "x$PROCESS" = "xmysqld_shutdown" || \
   test "x$PROCESS" = "xmysql" || \
   test "x$PROCESS" = "xndbd" || \
   test "x$PROCESS" = "xndb_mgmd" || \
   test "x$PROCESS" = "xmysqld" || \
   test "x$PROCESS" = "xdrizzled" || \
   test "x$PROCESS" = "xmysql_install_db" ; then
  if test "x${HOSTNAME_BINARY}" != "xlocalhost" && \
     test "x${HOSTNAME_BINARY}" != "x127.0.0.1" ; then
    COMMAND="$SSH "$COMMAND""
  fi
fi

if test "x$MGM_CMD" = "xmgm_cmd" ; then
  COMMAND="$COMMAND $MGM_COMMAND"
fi

MSG="$COMMAND"
output_msg

if test "x$MGM_CMD" != "xbackup" ; then
  eval $COMMAND
  if test "x$?" = "x0" ; then
    exit 0
  else
    exit 1
  fi
else
  START_GCP_ID=""
  eval $COMMAND |
  while read LINE1 LINE2 LINE3 LINE4 LINE5; do
    BACKUP_MSG=""
    if test "x$LINE1" = "xNode" ; then
      BACKUP_MSG="Not yet"
      BACKUP_ID="$LINE4"
    fi
    if test "x$LINE1" = "xStartGCP:" ; then
      BACKUP_MSG="Not yet"
      START_GCP_ID="$LINE2"
      STOP_GCP_ID="$LINE4"
    fi
    if test "x$LINE1" = "x#Records:" ; then
      BACKUP_MSG="Not yet"
      RECORDS="$LINE2"
      LOG_RECORDS="$LINE4"
    fi
    if test "x$LINE1" = "xConnected" || test "x$LINE1" = "xWaiting" ; then
      BACKUP_MSG="Not yet"
    fi
    if test "x$LINE1" = "xData:" ; then
      BACKUP_MSG="Not yet"
      DATA_SIZE="$LINE2"
      LOG_SIZE="$LINE4"
      BACKUP_MSG="BACKUP SUCCESS: BACKUP_ID $BACKUP_ID START_GCP $START_GCP_ID STOP_GCP_ID $STOP_GCP_ID RECORDS $RECORDS LOG_RECORDS $LOG_RECORDS DATA_SIZE $DATA_SIZE LOG_SIZE $LOG_SIZE"
      MSG="$BACKUP_MSG"
      output_msg
      exit 0
    fi
    if test "x$BACKUP_MSG" = "x" ; then
      MSG="$LINE1"
      output_msg
      MSG="BACKUP FAILED"
      output_msg
      exit 1
    fi
  done
fi
