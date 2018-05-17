use strict;
use warnings;

my @list = glob("/home/hongfu.sun/standalone/Gd_phantom_LNQSM/*.pbs");

foreach my $pbs (@list) {
	system("qsub -l nodes=1:ppn=8,walltime=24:00:00,mem=4gb $pbs");
}
