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
     This program runs an instance of the DBT2 test, including starting
     the cluster, filling the DBT2 initial data and finally running a set
     of tests. After completing the tests the cluster is shut down.
   PARAMETERS
   ----------
   --instance          : Instance number
   --run_number        : Run number of DBT2 tests (used in --run-test)
   --time              : Time for each DBT2 test
   --num-warehouses    : Number of warehouses loaded and used in test
   --cluster_id        : Cluster id used in test
   --num-servers       : Number of servers to use in loading
   --spread            : Spread between warehouses in a MySQL Server
   --ssocks            : Use Dolphin SuperSockets in test
   --verbose           : Verbose output
   --ndb               : Use NDB API version of DBT2 test
   --debug             : Debug info for NDB API version of DBT2 test

  It is also possible to change behaviour by setting a configuration
  parameter in the iclaustron.conf configuration file which is normally
  placed in the $HOME/.build directory.

  One such parameter that can be set is
  USE_MYISAM_FOR_ITEM="yes"
  When this is set the ITEM table will be in MyISAM and it will be stored
  in all MySQL Servers of the cluster. Thus it becomes a local resource
  fully replicated between the MySQL Servers.
  Another parameter is SSH_PORT which can be used when the servers involved
  doesn't use the standard port 22 for SSH traffic.
EOF
  echo "${1}"
}
validate_parameter()
{
  if test "x${2}" != "x${3}" ; then
    usage "wrong argument for '${2}' for parameter '${1}'"
    exit 1
  fi
}

INSTANCE="1"
CLUSTER_ID="1"
TIME="120"
NUM_WAREHOUSES="18"
RUN_NUMBER="1"
NUM_SERVERS="2"
SSOCKS=
VERBOSE=
BASE_DIR=`dirname ${0}`
DEBUG_INFO=
SPREAD="1"
HOME_BASE=$HOME
DEFAULT_DIR=
SKIP_RUN=
SKIP_START=
SKIP_STOP=

while test $# -gt 0
do
  case $1 in
  --debug )
    DEBUG_INFO="--debug"
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
  --verbose | -verbose )
    VERBOSE="--verbose"
    ;;
  --spread )
    opt=${1}
    shift
    TMP=`echo ${1} | egrep "^[0-9]+$"`
    validate_parameter ${opt} ${1} ${TMP}
    SPREAD="${1}"
    ;;
  --instance | -instance )
    opt=${1}
    shift
    TMP=`echo ${1} | egrep "^[0-9]+$"`
    validate_parameter ${opt} ${1} ${TMP}
    INSTANCE="${1}"
    ;;
  --run-number | --run_number | -run-number | -run_number )
    opt=${1}
    shift
    TMP=`echo ${1} | egrep "^[0-9]+$"`
    validate_parameter ${opt} ${1} ${TMP}
    RUN_NUMBER="${1}"
    ;;
  --num-warehouses | num-warehouses | --num_warehouses | -num_warehouses )
    opt=${1}
    shift
    TMP=`echo ${1} | egrep "^[0-9]+$"`
    validate_parameter ${opt} ${1} ${TMP}
    NUM_WAREHOUSES="${1}"
    ;;
  --cluster_id | --cluster-id | -cluster_id | -cluster-id )
    opt=${1}
    shift
    TMP=`echo ${1} | egrep "^[0-9]+$"`
    validate_parameter ${opt} ${1} ${TMP}
    CLUSTER_ID="${1}"
    ;;
  --time | -time )
    opt=${1}
    shift
    TMP=`echo ${1} | egrep "^[0-9]+$"`
    validate_parameter ${opt} ${1} ${TMP}
    TIME="${1}"
    ;;
  --num-servers | -num-servers | --num_servers | -num_servers )
    opt=${1}
    shift
    TMP=`echo ${1} | egrep "^[0-9]+$"`
    validate_parameter ${opt} ${1} ${TMP}
    NUM_SERVERS="${1}"
    ;;
  --sci | -sci | --supersockets | --supersocket | -supersocket | \
  -supersockets | -ssocks | --ssocks)
    SSOCKS="--ssocks"
    ;;
  --home_base | -home_base | --home-base | -home-base )
    shift 
    HOME_BASE="${1}"
    ;;
  --default-directory )
    shift 
    DEFAULT_DIR="${1}"
    ;;
  --help | -help )
    usage ""
    exit 0
    ;;
  *)
    usage "Wrong parameter format"
    exit 1
    ;;
  esac
  shift
done

if test "x${DEFAULT_DIR}" = "x" ; then
  DEFAULT_DIR="${HOME}/.build"
fi
export DBT2_DEFAULT_FILE="${DEFAULT_DIR}/dbt2.conf"
export IC_DEFAULT_FILE="${DEFAULT_DIR}/iclaustron.conf"
CLUSTER_CONFIG_FILE="${DEFAULT_DIR}/dis_config_c${CLUSTER_ID}.ini"

#Start the cluster to start with
START_CLUSTER_CMD="${BASE_DIR}/mgm_cluster.sh ${VERBOSE}"
START_CLUSTER_CMD="${START_CLUSTER_CMD} --cluster_id ${CLUSTER_ID}"
START_CLUSTER_CMD="${START_CLUSTER_CMD} --home-base ${HOME_BASE}"
START_CLUSTER_CMD="${START_CLUSTER_CMD} --start --all --initial"
START_CLUSTER_CMD="${START_CLUSTER_CMD} --conf-file ${CLUSTER_CONFIG_FILE}"
if test "x${SSOCKS}" != "x" ; then
  START_CLUSTER_CMD="${START_CLUSTER_CMD} --flags --ssocks"
fi

#Next step is to fill the database with data
FILL_CMD="${BASE_DIR}/dbt2.sh ${VERBOSE}"
FILL_CMD="${FILL_CMD} --home-base ${HOME_BASE}"
FILL_CMD="${FILL_CMD} --cluster_id ${CLUSTER_ID}"
FILL_CMD="${FILL_CMD} --perform-all --partition HASH"
FILL_CMD="${FILL_CMD} --num-warehouses ${NUM_WAREHOUSES}"
FILL_CMD="${FILL_CMD} --num-servers ${NUM_SERVERS}"

#Now we can start the test run
RUN_CMD="$BASE_DIR/dbt2.sh ${VERBOSE}"
RUN_CMD="${RUN_CMD} --home-base ${HOME_BASE}"
RUN_CMD="${RUN_CMD} --run-test ${RUN_NUMBER}"
RUN_CMD="${RUN_CMD} --instance ${INSTANCE}"
RUN_CMD="${RUN_CMD} --time ${TIME}"
RUN_CMD="${RUN_CMD} --num-warehouses ${NUM_WAREHOUSES}"
RUN_CMD="${RUN_CMD} --spread ${SPREAD}"
RUN_CMD="${RUN_CMD} --cluster_id ${CLUSTER_ID}"
RUN_CMD="${RUN_CMD} $DEBUG_INFO"

#Shutdown cluster after tests
STOP_CMD="${BASE_DIR}/mgm_cluster.sh ${VERBOSE}"
STOP_CMD="${STOP_CMD} --home_base ${HOME_BASE}"
STOP_CMD="${STOP_CMD} --cluster_id ${CLUSTER_ID}"
STOP_CMD="${STOP_CMD} --stop --all"
STOP_CMD="${STOP_CMD} --conf-file ${CLUSTER_CONFIG_FILE}"

echo "Executing: ${START_CLUSTER_CMD}"
if test "x${SKIP_START}" != "xyes" ; then
  ${START_CLUSTER_CMD}
#Sleep an extra minute just in case
  sleep 120
  echo "Cluster Started"
fi
if test "x${SKIP_RUN}" != "xyes" ; then
  sleep 15
  echo "Executing: ${FILL_CMD}"
  ${FILL_CMD}
  echo "Cluster loaded"

  sleep 10
  echo "Executing: ${RUN_CMD}"
  ${RUN_CMD}
fi
if test "x${SKIP_START}" != "xyes" && \
   test "x${SKIP_STOP}" != "xyes" ; then
  echo "Cluster test completed, closing down cluster"
  ${STOP_CMD}
fi
exit 0
