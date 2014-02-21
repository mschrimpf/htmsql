#!/usr/bin/env bash

input=$1
output="./output/${input/.data/}.ps"

mkdir -p ./output

title=$2

inputsplit=(${input//_/ })

x=${inputsplit[0]}
y=${inputsplit[2]}

xlabel=`sed 's/.\/\(.*\)$/\1/' <<< $x`

if [ "$y" == "TPM" ]
then 
	ylabel="Txns/min (x10^{3})"
	gnuplot -e "v_input='$input'; v_output='$output'; v_title='$title'; v_xlabel='$xlabel'; v_ylabel='$ylabel'" ~/scripts/gnuplot/TPM.plt
elif [ "$y" == "ABORT" ]
then
    ylabel="Abort rate"
    gnuplot -e "v_input='$input'; v_output='$output'; v_title='$title'; v_xlabel='$xlabel'; v_ylabel='$ylabel'" ~/scripts/gnuplot/ABORT.plt
else
    ylabel="Serialization retries"
    gnuplot -e "v_input='$input'; v_output='$output'; v_title='$title'; v_xlabel='$xlabel'; v_ylabel='$ylabel'" ~/scripts/gnuplot/SERRET.plt
fi
