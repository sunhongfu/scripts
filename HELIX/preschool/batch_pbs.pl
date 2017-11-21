use strict;
use warnings;

my @list = glob("/home/hongfu.sun/standalone/preschool/*.pbs");

foreach my $pbs (@list) {
	system("qsub -l nodes=1:ppn=1,walltime=48:00:00,mem=4gb $pbs");
}
