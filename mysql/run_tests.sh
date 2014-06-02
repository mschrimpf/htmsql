#!/bin/bash

#
# Requires a folder structure so that the txbench directory
# is a sub directory of the directory this shell is located in.
# 
# Author: Martin Schrimpf
# 	during the work on "HTM in MySQL" at the University of Sydney.
# 	Feb-Apr 2014.
#


source ~/develop/mysql/util-mysql.sh

# vars
read_probabilities=(100 75)

threads=(1 2 4 8 16 32 64)

# warmup=10
duration=150

types=${_TYPE_ALL[*]} #(unmodified syslock syslock-rtm glibc) #

benchmarks=(txbench) #dbt2 sysbench)
declare -A benchmark_paths
benchmark_paths[txbench]="txbench"
declare -A benchmark_exes
benchmark_exes[txbench]="run_txbench.sh"


export LC_NUMERIC="en_US.UTF-8" # use dots to separate floats

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

_DATETIME="$(date +'%Y%m%d_%H%M')"
benchmark_directory="$DIR/benchmarks"
target_directory="$benchmark_directory/$_DATETIME"
log_file="$target_directory/benchmarks.log"

#
# Funcs
#

# $1: the file to print the header to
function print_header {
	printf -- 'Threads' > "$1"
	
	for type in ${types[@]}; do
		header_labels=("tx/ms" "Standard deviation" "transactional cycles [%]" "aborted cycles [%]")
		for header_label in "${header_labels[@]}"; do
			printf -- ';%s' "$type $header_label" >> "$1"
		done
	done
	
	printf -- '\n' >> "$1"
}

# $1: the file to extract from
# $2: the pattern
# $3: the file to write to
function extract_and_write {
	val=$(sed -ne "s/$2/\1/p" "$1")
	printf -- ';%f' "$val" >> "$3"
}

#
# info
#
echo "Running the following benchmarks: "
printf -- ' * %s\n' "${benchmarks[@]}" # print as list

echo ""

echo "Benchmarking the following types: "
printf -- ' * %s\n' "${types[@]}" # print as list

echo ""

echo "Read-Probabilities are: "
printf -- ' * %3d%%\n' "${read_probabilities[@]}" # print as list

echo ""

# echo "Warmup of each run:   $warmup"
echo "Duration of each run: $duration"

echo ""
echo ""




# run
mkdir -p "$benchmark_directory"
mkdir -p "$target_directory"

for benchmark in ${benchmarks[@]}; do
	printf -- '_%s_\n' "$benchmark"
	cd "$DIR/${benchmark_paths[$benchmark]}"
	
	for read_probability in ${read_probabilities[@]}; do
		readupdate_probability=$(bc -l <<< "100 - $read_probability")
		printf -- '%3d%% read | %3d%% read-update\n' "$read_probability" "$readupdate_probability"
		
		file_out="$target_directory/$benchmark-r${read_probability}_ru${readupdate_probability}-$_DATETIME.csv"
		echo "Writing to $file_out"
		print_header "$file_out"

		for num_threads in ${threads[@]}; do
			printf -- '%3d threads\n' "$num_threads"
			printf -- '%d' "${num_threads}" >> "$file_out"
		
			for type in ${types[@]}; do
				echo "    Benchmarking $type"
				"./${benchmark_exes[$benchmark]}" "$type" -c "$num_threads" -pr_r "$read_probability" -pr_u "$readupdate_probability" -d "$duration" >> "$log_file"

				# save result
				report_root_dir="$DIR/report-$type-$benchmark"
				report_dir=$(ls -tr "$report_root_dir" | tail -1)
				report_dir="$report_root_dir/$report_dir"
				result_file="$report_dir/result.txt"
				
				extract_and_write "$result_file" "Total transactions:[^0-9\.]*\([0-9\.]*\).*" "$file_out"
				extract_and_write "$result_file" "Standard deviation:[^0-9\.]*\([0-9\.]*\).*" "$file_out"
				extract_and_write "$result_file" "Transactional cycles relative to total:[^0-9\.]*\([0-9\.]*\).*" "$file_out"
				extract_and_write "$result_file" "Aborted cycles relative to transactional:[^0-9\.]*\([0-9\.]*\).*" "$file_out"
				
				# move report directory to handled files
				handled_dir="$benchmark_directory/handled_benchmarks/report-$type-$benchmark"
				mkdir -p "$handled_dir" # create if not exists
				mv "$report_dir" "$handled_dir"
			done
			
			printf -- '\n' >> "$file_out"
		done
		
		echo "Results written to $file_out"
		echo ""
	done
done