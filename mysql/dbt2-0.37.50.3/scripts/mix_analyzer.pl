#!/usr/bin/perl -w

#
# This file is released under the terms of the Artistic License.
# Please see the file LICENSE, included in this package, for details.
#
# Copyright (C) 2002 Mark Wong & Open Source Development Lab, Inc.
# Copyright (c) 2011, Oracle and/or its affiliates. All rights reserved
#
# Major rewrite of this file including:
# - Use Statistics::Descriptive instead of Descriptive
# - Changed --outdir to --outfile instead
# - Removed --verbose parameter
# - Removed writing of notpm.data, d_tran.data, n_tran.data, o_tran.data
#   p_tran.data, s_tran.data to minimize overhead for statistics reporting
# - Added counters for total_rollback_count and tps
# - Added handling of warmup/cooldown periods
# - Removed lots of statistical output mean, min, max, variance, stddev, median
# - Removed printouts of loads of statistical data, e.g. on Response Time
#   Distribution per transaction type.
# - Remove generation of gnuplot data
# - Added new output at completion of run of this program.
#
# 14 mar 2011
#

use strict;
use Getopt::Long;
#use Descriptive;
use POSIX qw(ceil floor);

my $mix_log;
my $help;
my $outfile="";

my @delivery_response_time = ();
my @new_order_response_time = ();
my @order_status_response_time = ();
my @payement_response_time = ();
my @stock_level_response_time = ();

my @transactions = ( "delivery", "new_order", "order_status",
	"payment", "stock_level" );
#
# I'm so lazy, and I really don't like perl...
#
my %transaction;
$transaction{ 'd' } = "Delivery";
$transaction{ 'n' } = "New Order";
$transaction{ 'o' } = "Order Status";
$transaction{ 'p' } = "Payment";
$transaction{ 's' } = "Stock Level";
my @xtran = ( "d_tran", "n_tran", "o_tran", "p_tran", "s_tran" );

my $sample_length = 60; # Seconds.

GetOptions(
	"help" => \$help,
	"infile=s" => \$mix_log,
	"outfile=s" => \$outfile
);

#
# Because of the way the math works out, and because we want to have 0's for
# the first datapoint, this needs to start at the first $sample_length,
# which is in minutes.
#
my $elapsed_time = 1;

#
# Isn't this bit lame?
#
if ( $help ) {
	print "usage: mix_analyzer.pl --infile <path>/mix.log --outfile <path>/analyzer.log\n";
	exit 1;
}

unless ( $mix_log ) {
	print "usage: mix_analyzer.pl --infile <path>/mix.log --outfile <logfile>/\n";
	exit 1;
}

#
# Open a file handle to mix.log.
#
open( FH, "<$mix_log")
	or die "Couldn't open $mix_log for reading: $!\n";


#
# Load mix.log into memory.  Hope perl doesn't choke...
#
my $line;
my %data;
my %last_time;
my %error_count;
my $errors = 0;

#
# Hashes to determine response time distributions.
#
my %d_distribution;
my %n_distribution;
my %o_distribution;
my %p_distribution;
my %s_distribution;

my %transaction_name;
$transaction_name{ "d" } = "delivery";
$transaction_name{ "n" } = "new order";
$transaction_name{ "o" } = "order status";
$transaction_name{ "p" } = "payment";
$transaction_name{ "s" } = "stock level";
$transaction_name{ "D" } = "delivery";
$transaction_name{ "N" } = "new order";
$transaction_name{ "O" } = "order status";
$transaction_name{ "P" } = "payment";
$transaction_name{ "S" } = "stock level";
$transaction_name{ "E" } = "unknown error";

my $current_time=0;
my $start_time=0;
my $steady_state_start_time = 0;
my $end_time = 0;
my $previous_time=0;
my $total_response_time=0;
my $total_transaction_count=0;
my $response_time=0;
my $total_rollback_count=0;
my $tps = 0;

my %current_transaction_count;
my %rollback_count;
my %transaction_count;
my %transaction_response_time;

$current_transaction_count{ 'd' } = 0;
$current_transaction_count{ 'n' } = 0;
$current_transaction_count{ 'o' } = 0;
$current_transaction_count{ 'p' } = 0;
$current_transaction_count{ 's' } = 0;

$rollback_count{ 'd' } = 0;
$rollback_count{ 'n' } = 0;
$rollback_count{ 'o' } = 0;
$rollback_count{ 'p' } = 0;
$rollback_count{ 's' } = 0;

#
# Transaction counts for the steady state portion of the test.
#
$transaction_count{ 'd' } = 0;
$transaction_count{ 'n' } = 0;
$transaction_count{ 'o' } = 0;
$transaction_count{ 'p' } = 0;
$transaction_count{ 's' } = 0;

#
# Read the data directly from the log file and handle it on the fly.
#
while ( defined( $line = <FH> ) ) {
	chomp $line;
	my @word = split /,/, $line;

	if (scalar(@word) == 4) {
		#
		# Count transactions per second based on transaction type.
		#
		$current_time = $word[0];
		my $response_time = $word[2];
		#
		# Save the very first start time in the log.
		#
		unless ( $start_time ) {
			$start_time = $previous_time = $current_time;
		}
		if ( $current_time >= ( $previous_time + $sample_length ) ) {

			++$elapsed_time;
			$previous_time = $current_time;

			#
			# Reset counters for the next sample interval.
			#
			$current_transaction_count{'d'} = 0;
			$current_transaction_count{'n'} = 0;
			$current_transaction_count{'o'} = 0;
			$current_transaction_count{'p'} = 0;
			$current_transaction_count{'s'} = 0;
		}

		#
		# Determine response time distributions for each transaction
		# type.  Also determine response time for a transaction when
		# it occurs during the run.  Calculate response times for
		# each transaction;
		#
		my $time;
		$time = sprintf("%.2f", $response_time );
		my $x_time = ($word[ 0 ] - $start_time) / 60;
		if ( $word[ 1 ] eq 'd' ) {
			unless ($steady_state_start_time == 0) {
				++$transaction_count{ 'd' };
				$transaction_response_time{ 'd' } += $response_time;
				push @delivery_response_time, $response_time;
				++$current_transaction_count{ 'd' };
			}
			++$d_distribution{ $time };
		} elsif ( $word[ 1 ] eq 'n' ) {
			unless ($steady_state_start_time == 0) {
				++$transaction_count{ 'n' };
				$transaction_response_time{ 'n' } += $response_time;
				push @new_order_response_time, $response_time;
				++$current_transaction_count{ 'n' };
			}
			++$n_distribution{ $time };
		} elsif ( $word[ 1 ] eq 'o' ) {
			unless ($steady_state_start_time == 0) {
				++$transaction_count{ 'o' };
				$transaction_response_time{ 'o' } += $response_time;
				push @order_status_response_time, $response_time;
				++$current_transaction_count{ 'o' };
			}
			++$o_distribution{ $time };
		} elsif ( $word[ 1 ] eq 'p' ) {
			unless ($steady_state_start_time == 0) {
				++$transaction_count{ 'p' };
				$transaction_response_time{ 'p' } += $response_time;
				push @payement_response_time, $response_time;
				++$current_transaction_count{ 'p' };
			}
			++$p_distribution{ $time };
		} elsif ( $word[ 1 ] eq 's' ) {
			unless ($steady_state_start_time == 0) {
				++$transaction_count{ 's' };
				$transaction_response_time{ 's' } += $response_time;
				push @stock_level_response_time, $response_time;
				++$current_transaction_count{ 's' };
			}
			++$s_distribution{ $time };
		} elsif ( $word[ 1 ] eq 'D' ) {
			++$rollback_count{ 'd' } unless ($steady_state_start_time == 0);
		} elsif ( $word[ 1 ] eq 'N' ) {
			++$rollback_count{ 'n' } unless ($steady_state_start_time == 0);
		} elsif ( $word[ 1 ] eq 'O' ) {
			++$rollback_count{ 'o' } unless ($steady_state_start_time == 0);
		} elsif ( $word[ 1 ] eq 'P' ) {
			++$rollback_count{ 'p' } unless ($steady_state_start_time == 0);
		} elsif ( $word[ 1 ] eq 'S' ) {
			++$rollback_count{ 's' } unless ($steady_state_start_time == 0);
		} elsif ( $word[ 1 ] eq 'E' ) {
			++$errors;
			++$error_count{ $word[ 3 ] };
		}
		
		#
		# Count unknown errors.
		#
		unless ($word[ 1 ] eq 'E' ) {
			++$data{ $word[ 3 ] };
			$last_time{ $word[ 3 ] } = $word[ 0 ];
		}

		$total_response_time += $response_time;
		++$total_transaction_count;
	} elsif (scalar(@word) == 2) {
		#
		# Look for that 'START' marker to determine the end of the rampup time
		# and to calculate the average throughput from that point to the end
		# of the test.
		#
		$steady_state_start_time = $word[0];
	} elsif (scalar(@word) == 3) {
                #
                # Look for the 'END' marker to determine end of test and
                # to calculate cooldown period
                $end_time = $word[0];
        }
}
close( FH );

#
# Determine 90th percentile response times for each transaction.
#
@delivery_response_time = sort(@delivery_response_time);
@new_order_response_time = sort(@new_order_response_time);
@order_status_response_time = sort(@order_status_response_time);
@payement_response_time = sort(@payement_response_time);
@stock_level_response_time = sort(@stock_level_response_time);
#
# Get the index for the 90th percentile point.
#
my $delivery90index = $transaction_count{'d'} * 0.90;
my $new_order90index = $transaction_count{'n'} * 0.90;
my $order_status90index = $transaction_count{'o'} * 0.90;
my $payment90index = $transaction_count{'p'} * 0.90;
my $stock_level90index = $transaction_count{'s'} * 0.90;

my %response90th;

my $floor;
my $ceil;

$floor = floor($delivery90index);
$ceil = ceil($delivery90index);
if ($floor == $ceil) {
	$response90th{'d'} = $delivery_response_time[$delivery90index];
} else {
	$response90th{'d'} = ($delivery_response_time[$floor] +
			$delivery_response_time[$ceil]) / 2;
}

$floor = floor($new_order90index);
$ceil = ceil($new_order90index);
if ($floor == $ceil) {
	$response90th{'n'} = $new_order_response_time[$new_order90index];
} else {
	$response90th{'n'} = ($new_order_response_time[$floor] +
			$new_order_response_time[$ceil]) / 2;
}

$floor = floor($order_status90index);
$ceil = ceil($order_status90index);
if ($floor == $ceil) {
	$response90th{'o'} = $order_status_response_time[$order_status90index];
} else {
	$response90th{'o'} = ($order_status_response_time[$floor] +
			$order_status_response_time[$ceil]) / 2;
}

$floor = floor($payment90index);
$ceil = ceil($payment90index);
if ($floor == $ceil) {
	$response90th{'p'} = $payement_response_time[$payment90index];
} else {
	$response90th{'p'} = ($payement_response_time[$floor] +
			$payement_response_time[$ceil]) / 2;
}

$floor = floor($stock_level90index);
$ceil = ceil($stock_level90index);
if ($floor == $ceil) {
	$response90th{'s'} = $stock_level_response_time[$stock_level90index];
} else {
	$response90th{'s'} = ($stock_level_response_time[$floor] +
			$stock_level_response_time[$ceil]) / 2;
}

#
# Calculate the actual mix of transactions.
#
printf("                         Response Time (s)\n");
printf(" Transaction      %%    Average :    90th %%        Total        Rollbacks      %%\n");
printf("------------  -----  ---------------------  -----------  ---------------  -----\n");
foreach my $idx ('d', 'n', 'o', 'p', 's') {
	if ($transaction_count{$idx} == 0) {
		printf("%12s   0.00          N/A                      0  %15d  100.00\n", $transaction{$idx}, $rollback_count {$idx});
	} else {
		printf("%12s  %5.2f  %9.3f : %9.3f  %11d  %15d  %5.2f\n",
			$transaction{$idx},
			($transaction_count{$idx} + $rollback_count{$idx}) /
				$total_transaction_count * 100.0,
			$transaction_response_time{$idx} / $transaction_count{$idx},
			$response90th{$idx},
			$transaction_count{$idx} + $rollback_count{$idx},
			$rollback_count{$idx},
			$rollback_count{$idx} /
				($rollback_count{$idx} + $transaction_count{$idx}) *
			100.0);
	}
}

#
# Calculated the number of transactions per second.
#
if ( $current_time == $start_time ) {
  $tps = 0; }
else {
  $tps = $transaction_count{'n'} / ($current_time - $start_time); }
$total_rollback_count = $rollback_count{'d'} + $rollback_count{'n'} + $rollback_count{'o'} + $rollback_count{'p'} + $rollback_count{'s'} ;
printf("\n");
printf("%0.2f new-order transactions per minute (NOTPM)\n", $tps * 60);
printf("%0.1f minute duration\n", ($current_time - $start_time) / 60.0);
printf("%d total unknown errors\n", $errors);
printf("%0.2f rollback transactions\n", $total_rollback_count );
printf("%d second(s) ramping up\n", $steady_state_start_time - $start_time);
printf("\n");



if ( 'x'.$outfile ne 'x' ) {
open( OF, ">$outfile");
printf(OF "                         Response Time (s)\n");
printf(OF " Transaction      %%    Average :    90th %%        Total        Rollbacks      %%\n");
printf(OF "------------  -----  ---------------------  -----------  ---------------  -----\n");
foreach my $idx ('d', 'n', 'o', 'p', 's') {
	if ($transaction_count{$idx} == 0) {
		printf(OF "%12s   0.00          N/A                      0  %15d  100.00\n", $transaction{$idx}, $rollback_count {$idx});
	} else {
		printf(OF "%12s  %5.2f  %9.3f : %9.3f  %11d  %15d  %5.2f\n",
				$transaction{$idx},
				($transaction_count{$idx} + $rollback_count{$idx}) /
						$total_transaction_count * 100.0,
				$transaction_response_time{$idx} / $transaction_count{$idx},
				$response90th{$idx},
				$transaction_count{$idx} + $rollback_count{$idx},
				$rollback_count{$idx},
				$rollback_count{$idx} /
						($rollback_count{$idx} + $transaction_count{$idx}) *
						100.0);
	}
}

#
# Calculated the number of transactions per second.
#
printf(OF "\n");
printf(OF "%0.2f new-order transactions per minute (NOTPM)\n", $tps * 60);
printf(OF "%0.1f minute duration\n", ($current_time - $start_time) / 60.0);
printf(OF "%d total unknown errors\n", $errors);
printf(OF "%0.2f rollback transactions\n", $total_rollback_count );
printf(OF "%d second(s) ramping up\n", $start_time - $steady_state_start_time);
printf(OF "%d second(s) cooling down\n", $end_time - $current_time);
printf(OF "\n");
close (OF);
}
