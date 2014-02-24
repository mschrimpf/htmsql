#!/usr/bin/env bash

cd $1

echo "run;totaltrans;totalrollback;totalserretries;totalavgrestime;ttpm;errors;duration" > report_summary.txt

find . -name report.txt -exec gawk -v PATH="{}" '
BEGIN {OFS=";"}
/Delivery|Payment/ {totalavgrestime+=$3; totaltrans+=$6; totalrollback+=$7; totalserretries+=$9}
/New Order|Order Status|Stock Level|Credit Check/ {totalavgrestime+=$4; totaltrans+=$7; totalrollback+=$8; totalserretries+=$10}
/\(TTPM\)$/ {ttpm=$1}
/total unknown errors$/ {errors=$1}
/minute duration$/ {duration=$1}
END { print gensub(/.*\/([^\/]*?)\/report\.txt$/, "\\1", "g", PATH), totaltrans, totalrollback, totalserretries, totalavgrestime, ttpm, errors, duration}
' {} \; >> report_summary.txt
