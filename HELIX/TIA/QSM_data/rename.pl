# to list the directories of the QSM scans
# some has 0, some has more than 1

use strict;
use warnings;
use List::Util qw[min max];
use File::Basename;

my @list = glob("/media/data/TIA/QSM_data/*QSM*");
# print @list;

foreach my $dir (@list){
	print "$dir\n";
	$dir =~ /(.*)(_)(.*)/;
	system("mv $dir $1_QSM");
	print "$1\n";
}


