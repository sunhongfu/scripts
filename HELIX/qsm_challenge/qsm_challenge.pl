#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;

my @Tik_weights = ("0", "1e-6","1e-5", "1e-4", "1e-3");  
my @TV_weights = ("2e-4","5e-4","8e-4");
foreach my $Tik_weight (@Tik_weights){
	foreach my $TV_weight (@TV_weights){
#		my $outputname = "out_TV_${TV_weight}_Tik_${Tik_weight}";
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
./run_qsm_challenge_helix.sh \$MCR $Tik_weight $TV_weight> mycode_\${PBS_JOBID}.out
echo \"Job finished at: `date`\"
";
		
		# write the pbs files
		open(my $fileHandle, '>', "/home/hongfu.sun/standalone/qsm_challenge/Tik_${Tik_weight}_TV_${TV_weight}.pbs");
        print $fileHandle $script;
        close $fileHandle
	}


}

