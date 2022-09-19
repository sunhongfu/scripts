use strict;
use warnings;
use List::Util qw[min max];
use File::Basename;


# generate a .pbs file for each subject
# extract the subject number. e.g. Ps16_075_PRESCHOOL__PS16_075.pbs
foreach my $sub_no (1 .. 105){


	my $script = 
"#!/bin/bash
#
#PBS -A UQ-EAIT-ITEE
#
#PBS -l select=1:ncpus=1:mem=8GB
#PBS -l walltime=08:00:00

module load matlab 

cd /scratch/user/uqhsun8/AHEAD_v2
matlab  -nodisplay -nojvm -nosplash -singleCompThread -r \"recon_all_data($sub_no)\" 
";



	# print "$fields[0]\n";
	open(my $fileHandle, '>', "/home/uqhsun8/AHEAD_v2/$sub_no.pbs");  
	print $fileHandle $script;
	close $fileHandle
}






