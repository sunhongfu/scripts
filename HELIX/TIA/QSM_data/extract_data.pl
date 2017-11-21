#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;

my @list = system('find . -name Ax_3D_QSM*');
chop @list;
@list = grep(/\S/,@list);
foreach my $dicom_dir (@list){
	# extract the subject name and the year
	my @fields = split(/\//,$dicom_dir);
	my $parent_dir = dirname($dicom_dir);
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
./run_qsm_spgr_ge_edm.sh \$MCR \"/home/hongfu.sun/data/TIA/QSM_data/$dicom_dir\" \"/home/hongfu.sun/data/TIA/QSM_data/$parent_dir\" > mycode_\${PBS_JOBID}.out
echo \"Job finished at: `date`\"
";

print "fields[0]\n";

        # print "$fields[0]\n";
        open(my $fileHandle, '>', "/media/helix/standalone/TIA/QSM_data/$fields[0]_1yr.pbs");
        print $fileHandle $script;
        close $fileHandle
}



