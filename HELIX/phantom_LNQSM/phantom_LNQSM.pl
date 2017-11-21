#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;

#my @TV_weights = ("10.0000e-006", "18.3298e-006", "33.5982e-006", "61.5848e-006", "112.8838e-006", "206.9138e-006", "379.2690e-006", "695.1928e-006", "1.2743e-003", "2.3357e-003", "4.2813e-003", "7.8476e-003", "14.3845e-003", "26.3665e-003", "48.3293e-003", "88.5867e-003", "162.3777e-003", "297.6351e-003", "545.5595e-003", "1.0000e+000");
my @Tik_weights = ("10.0000e-006", "18.3298e-006", "33.5982e-006", "61.5848e-006", "112.8838e-006", "206.9138e-006", "379.2690e-006", "695.1928e-006", "1.2743e-003", "2.3357e-003", "4.2813e-003", "7.8476e-003", "14.3845e-003", "26.3665e-003", "48.3293e-003", "88.5867e-003", "162.3777e-003", "297.6351e-003", "545.5595e-003", "1.0000e+000");

my @TV_weights = ("1e-4","2e-4","3e-4","4e-4","5e-4");
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
./run_phantom_LNQSM_helix.sh \$MCR $Tik_weight $TV_weight> mycode_\${PBS_JOBID}.out
echo \"Job finished at: `date`\"
";
		
		# write the pbs files
		open(my $fileHandle, '>', "/home/hongfu.sun/standalone/phantom_LNQSM/Tik_${Tik_weight}_TV_${TV_weight}.pbs");
        print $fileHandle $script;
        close $fileHandle
	}


}

