#!/bin/sh

#
# This file is released under the terms of the Artistic License.
# Please see the file LICENSE, included in this package, for details.
#
# Copyright (C) 2002 Mark Wong & Open Source Development Lab, Inc.
#

SAROUTPUT=$1
SAMPLE_LENGTH=$2
OUTPUTDIR=$3

# Prepare processor utilization data.
 -f $SAROUTPUT -u | /bin/grep all | /bin/grep -v Average | \
	gawk '{ print (NR - 1) * '$SAMPLE_LENGTH', $4 + $5 + $6 }' > $OUTPUTDIR/cpu_all.out
 -f $SAROUTPUT -u | /bin/grep all | /bin/grep -v Average | \
	gawk '{ print (NR - 1) * '$SAMPLE_LENGTH', $4 }' > $OUTPUTDIR/cpu_user.out
 -f $SAROUTPUT -u | /bin/grep all | /bin/grep -v Average | \
	gawk '{ print (NR - 1) * '$SAMPLE_LENGTH', $5 }' > $OUTPUTDIR/cpu_nice.out
 -f $SAROUTPUT -u | /bin/grep all | /bin/grep -v Average | \
	gawk '{ print (NR - 1) * '$SAMPLE_LENGTH', $6 }' > $OUTPUTDIR/cpu_system.out
cp -p cpu.input $OUTPUTDIR
cd $OUTPUTDIR
 cpu.input
cd -
