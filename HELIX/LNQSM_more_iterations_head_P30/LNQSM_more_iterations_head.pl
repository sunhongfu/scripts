#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;

my @subjects = ("/home/hongfu.sun/data/atlas/11","/home/hongfu.sun/data/atlas/12", "/home/hongfu.sun/data/atlas/13", "/home/hongfu.sun/data/atlas/14", "/home/hongfu.sun/data/atlas/15", "/home/hongfu.sun/data/atlas/16", "/home/hongfu.sun/data/atlas/17","/home/hongfu.sun/data/atlas/18", "/home/hongfu.sun/data/atlas/19");
my $subject_num = 0;

foreach my $subject (@subjects){
	$subject_num = $subject_num + 1;
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
./run_LNQSM_more_iterations_head.sh \$MCR $subject > mycode_\${PBS_JOBID}.out
echo \"Job finished at: `date`\"
";
		
	# write the pbs files
	open(my $fileHandle, '>', "/home/hongfu.sun/standalone/LNQSM_more_iterations_head_P30/${subject_num}.pbs");
    print $fileHandle $script;
    close $fileHandle;
}

