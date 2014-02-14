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

usage()
{
 cat <<EOF
  This program creates the data files needed to insert the records into
  the DBT2 tables. It starts by creating one directory per warehouse.
  Next step is generate the files for each of those warehouses.

  --data_dir       : The directory where all the files generated are placed
  --base_dir       : The directory where the DBT2 installation is found
  --num_warehouses : Number of warehouses to create
  --first-warehouse: Number of first warehouse
EOF
}

validate_parameter()
{
  if test "x${2}" != "x${3}" ; then
    usage "wrong argument '${2}' for parameter '-${1}'"
    exit 1
  fi
}

DEFAULT_DIR="${HOME}/.build"
DATA_DIR="${HOME}/dbt2-data"
BASE_DIR="${HOME}/dest_build_dir/dbt2-0.37.50"
FIRST_WAREHOUSE="1"
NUM_WAREHOUSES="16"
MYSQL_LIB_PATH=
LOG_FILE=
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

DEFAULT_FILE="${DEFAULT_DIR}/dbt2.conf"
if test -f "${DEFAULT_FILE}" ; then
  . ${DEFAULT_FILE}
fi

while test $# -gt 0
do
  case ${1} in
    --data_dir | --data-dir )
      shift
      DATA_DIR="${1}"
      ;;
    --base_dir | --base-dir )
      shift
      BASE_DIR="${1}"
      ;;
    --first_warehouse | --first-warehouse )
      opt=${1}
      shift
      TMP=`echo ${1} | egrep "^[0-9]+$"`
      validate_parameter ${opt} ${1} ${TMP}
      FIRST_WAREHOUSE="${1}"
      ;;
    --num_warehouses | --num-warehouses )
      opt=${1}
      shift
      TMP=`echo ${1} | egrep "^[0-9]+$"`
      validate_parameter ${opt} ${1} ${TMP}
      NUM_WAREHOUSES="${1}"
      ;;
    --help )
      usage
      exit 0
      ;;
    *)
      MSG="Unrecognized option: ${1}"
      output_msg
      usage
      exit 1
      ;;
  esac
  shift
done

if test -f "${DEFAULT_FILE}" ; then
  MSG="Sourcing defaults from ${DEFAULT_FILE}"
  output_msg
else
  MSG="No ${DEFAULT_FILE} found, using standard defaults"
  output_msg
fi

if test "x$MYSQL_BASE" = "x5.1" ; then
  MYSQL_LIB_PATH="$MYSQL_PATH/lib/mysql"
else
  MYSQL_LIB_PATH="$MYSQL_PATH/lib"
fi
if test "x$LD_LIBRARY_PATH" = "x" ; then
  LD_LIBRARY_PATH=$MYSQL_LIB_PATH
else
  LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MYSQL_LIB_PATH
fi
export LD_LIBRARY_PATH

MSG="Using DATA_DIR = ${DATA_DIR}, BASE_DIR = ${BASE_DIR}"
output_msg
MSG="FIRST_WAREHOUSE = ${FIRST_WAREHOUSE}, NUM_WAREHOUSES = ${NUM_WAREHOUSES}"
output_msg
((LAST_WAREHOUSE=FIRST_WAREHOUSE+NUM_WAREHOUSES))
for ((i=FIRST_WAREHOUSE; i<LAST_WAREHOUSE; i++))
do
  MSG="Create warehouse ${i}"
  output_msg
  /bin/mkdir -p ${DATA_DIR}/dbt2-w${i}
  ${BASE_DIR}/src/datagen -w 1 -d ${DATA_DIR}/dbt2-w${i} -m ${i} --mysql
done
exit 0
