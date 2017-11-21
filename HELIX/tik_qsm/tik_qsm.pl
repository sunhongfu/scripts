#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;

my @subjects = ("/home/hongfu.sun/data/atlas/11","/home/hongfu.sun/data/atlas/12","/home/hongfu.sun/data/atlas/13","/home/hongfu.sun/data/atlas/14","/home/hongfu.sun/data/atlas/15","/home/hongfu.sun/data/atlas/hongfu");

my @erosions = ("0","1","2","3");
foreach my $sub (@subjects){
	foreach my $ero (@erosions){
		my @sub_num = split /\//, $sub;
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
./run_tik_qsm_helix.sh \$MCR $sub $ero > mycode_\${PBS_JOBID}.out
echo \"Job finished at: `date`\"
";
		
		# write the pbs files
		open(my $fileHandle, '>', "/home/hongfu.sun/standalone/tik_qsm/tik_qsm_$sub_num[-1]_TV_${ero}.pbs");
        print $fileHandle $script;
        close $fileHandle
	}


}

