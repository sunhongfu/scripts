# to list the directories of the QSM scans
# some has 0, some has more than 1

use strict;
use warnings;
use List::Util qw[min max];
use File::Basename;

my @list = glob("/home/hongfu.sun/data/preschool/*");
# print @list;
my @finalList;
my $last;
my $imageSet;
my $firstDicom;
foreach my $dir (@list){
        my @sublist = glob("$dir/*");
#print @sublist;
        next if (@sublist == 0);
#print "$dir\n";
        # regular expression to extract the last scan
        # rule: the largest of the last number in the folder names
        my $previousLastDigit = 0;
        foreach my $subdir (@sublist){
                $subdir =~ /(\D*)(\d*)$/;
                my $lastDigit = $2;
                if ($lastDigit > $previousLastDigit){
                        $last = $subdir;
                }
                $previousLastDigit = $lastDigit;

        }
        # only copy the last set of images
        # e.g. IM-0263***.dcm
        my $firstDicom = "";
        opendir(my $dh, $last);
        while (my $file = readdir($dh)) {

                next if $file eq "." or $file eq "..";
                $firstDicom = $file;
                last;
        }
        closedir $dh;

        # print ("$last\n");
        # print ("$firstDicom\n");
        $firstDicom =~ /(IM\-\d*)(\D.*)$/;
        my $imageSet = $1;
#print "$last\n";
        # system("cp -r --parent \"$last\"/$imageSet\* /media/data/tmp");

        push @finalList, $last;
}

# print "$_\n" for @finalList;


# generate a .pbs file for each subject
# extract the subject number. e.g. Ps16_075_PRESCHOOL__PS16_075.pbs
foreach my $dicom (@finalList){
	my @fields = split /\//, $dicom;
	my $dicom_parent = dirname($dicom);
#print $dicom_parent;
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
./run_qsm_spgr_ge_catherine_fit_filter.sh \$MCR \"$dicom\" \"$dicom_parent\" > mycode_\${PBS_JOBID}.out
echo \"Job finished at: `date`\"
";



	 print "$fields[5]\n";
	open(my $fileHandle, '>', "/home/hongfu.sun/standalone/preschool_fit_filter/$fields[5].pbs");  
	print $fileHandle $script;
	close $fileHandle
}










