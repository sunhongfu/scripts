use strict;
use warnings;

my @list = glob("/home/hongfu.sun/standalone/LNQSM_more_iterations_head_P1/*.pbs");

foreach my $pbs (@list) {
	system("qsub -l nodes=1:ppn=8,walltime=48:00:00,mem=4gb $pbs");
}
