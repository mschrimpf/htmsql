#!/bin/sh

#
# This file is released under the terms of the Artistic License.
# Please see the file LICENSE, included in this package, for details.
#
# Copyright (C) 2002 Mark Wong & Open Source Development Lab, Inc.
#

while getopts "o:" opt; do
	case $opt in
	o)
		OUTPUT_DIR=$OPTARG
		;;
	esac
done

# I don't think capturing error messages is important here.
/sbin/sysctl -a 2> /dev/null | sort > $OUTPUT_DIR/proc.out
