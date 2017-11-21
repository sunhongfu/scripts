#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;

my @list = `find . -name Ax*| grep QSM_1yr`;
chomp @list;
foreach my $dicom_dir (@list){
	# extract the subject name and the year
	my @fields = split /\//, $dicom_dir;
	my $dicom_parent = dirname($dicom_dir);
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
./run_qsm_spgr_ge_edm.sh \$MCR \"/home/hongfu.sun/data/TIA/QSM_data/$dicom_dir\" \"/home/hongfu.sun/data/TIA/QSM_data/$dicom_parent\" > mycode_\${PBS_JOBID}.out
echo \"Job finished at: `date`\"
";



        print "$fields[1]\n";
        open(my $fileHandle, '>', "/home/hongfu.sun/standalone/TIA/QSM_data/$fields[1]_QSM_1yr.pbs");
        print $fileHandle $script;
        close $fileHandle
}




