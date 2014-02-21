#!/usr/bin/env bash

# mpls="1 8 16 32 64 128"
# iterations=5
# isolations="si ssi"
# cpu_configs="1,1 4,4 8,1 16,4 32,4"

mpls="1 8 16 32 64 128"
iterations=2
isolations="si ssi"
cpu_configs="1,1 4,4 8,1 16,4 32,4"

run_runtime=`date +%F_%T`

run_dir=/home/pgssi/dbt2results/${run_runtime}
mkdir -p $run_dir
cd $run_dir

for iteration in `seq 1 $iterations`
do
    for cpu_config in $cpu_configs
    do
        ssh -t db17 "sudo ~/scripts/setup_core_config.py '${cpu_config}'"
    
        for isolation in $isolations
        do
            for mpl in $mpls
            do 
           
                runtime=`date +%F_%T`
            
                echo "
#########################################################
mpl    isolation   cpu    iteration   time
${mpl}    ${isolation}        ${cpu_config}    ${iteration}    ${runtime}
#########################################################
                "
                
                # reload dbdata and isolation
                ssh db17 "~/scripts/reload_dbdata.sh"
                ssh db17 "~/scripts/setup_db_isolation.sh ${isolation}"

                param=${mpl}_${isolation}_${cpu_config}_${iteration}_${runtime}

                connections=$mpl
                duration=300
                warehouses=150
                outputdir=$run_dir/$param
                host=db17
                port=6086
                delay=50 #delay between starting client threads in ms
                comment=$param
                threadsperwarehouse=1

                switches="-n -q"
                # -n for no thinking time
                # -q for oprofile

                ## transaction percentages ##
                #ro
                orderstatus=0.375
                stocklevel=0.375
                #rw
                delivery=0.04
                creditcheck=0.04
                payment=0.08
                # neworder=rest

                MIX="-q $payment -r $orderstatus -e $delivery -t $stocklevel"

                (
                echo
                echo "  Run: " dbt2-run-workload -a pgsql -c $connections -d $duration -w $warehouses -o $outputdir -H $host -l $port -s $delay $switches -z "${comment}" -t $threadsperwarehouse -M "${MIX}" -C $creditcheck

                dbt2-run-workload -a pgsql -c $connections -d $duration -w $warehouses -o $outputdir -H $host -l $port -s $delay $switches -z "${comment}" -t $threadsperwarehouse -M "${MIX}" -C $creditcheck
                ) 2>&1 | tee $param.log

                ssh db17 "cpuoverview" > $outputdir/cpuoverview.out 2>/dev/null

                mv $param.log $outputdir/run-dbt2.out
    
            done #mpl
        done #isolation
    done #cpu_config
ssh bthe6086@ucpu0.ug.it.usyd.edu.au "echo 'Finished $iteration' | mail -s 'Run $iteration complete' brent.thew@gmail.com"
done #iteration

