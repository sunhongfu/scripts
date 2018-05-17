use strict;
use warnings;

my @list = glob("/home/hongfu.sun/standalone/phantom_LNQSM_brain/*.pbs");

foreach my $pbs (@list) {
	system("qsub -l nodes=1:ppn=8,walltime=72:00:00,mem=1gb $pbs");
}
