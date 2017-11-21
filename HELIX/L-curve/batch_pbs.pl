use strict;
use warnings;

my @list = glob("/home/hongfu.sun/standalone/L-curve/*.pbs");

foreach my $pbs (@list) {
	system("qsub -l nodes=1:ppn=4,walltime=72:00:00,mem=4gb $pbs");
}
