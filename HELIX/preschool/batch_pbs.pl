use strict;
use warnings;
use List::Util qw[min max];
use File::Basename;

my @list = glob("/home/hongfu.sun/standalone/preschool_PS15/*.pbs");

foreach my $pbs (@list) {
	system("qsub -l nodes=1:ppn=1,walltime=10:00:00,mem=4gb $pbs");
}
