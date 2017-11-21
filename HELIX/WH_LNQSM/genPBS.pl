#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;

my @TV_weights = ("0.00001", "0.0001", "0.0005", "0.001", "0.005", "0.01", "0.1");
my @Tik_weights = ("0.0001", "0.001", "0.01", "0.1", "1", "10");

foreach my $Tik_weight (@Tik_weights){
	foreach my $TV_weight (@TV_weights){
		my $outputname = "out_TV_${TV_weight}_Tik_${Tik_weight}";
		my $script =
"#!/bin/bash
#PBS -S /bin/bash

# Choose the MCR directory according to the compiler version used
MCR=/home/hongfu.sun/MATLAB_runtime/v901/

# If running on Grex, uncomment the following line to set MCR_CACHE_ROOT:
# module load mcr/mcr

echo \"Running on host: `hostname`\"
cd \$PBS_O_WORKDIR 
echo \"Current working directory is `pwd`\"

echo \"Starting run at: `date`\" 
./run_WH_LNQSM_helix.sh \$MCR $Tik_weight $TV_weight $outputname.mat> mycode_\${PBS_JOBID}.out
echo \"Job finished at: `date`\"
";
		
		# write the pbs files
		open(my $fileHandle, '>', "/home/hongfu.sun/standalone/WH_LNQSM/$outputname.pbs");
        print $fileHandle $script;
        close $fileHandle
	}


}

