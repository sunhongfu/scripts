use strict;
use warnings;

#my @list = glob("/home/hongfu.sun/standalone/TIA/QSM_norm/*.pbs");
my @list = ("Norm160_Bd.pbs", "Norm273_Sh.pbs", "Norm279_Mt.pbs", "Norm281_Gv.pbs", "Norm282_Gy.pbs", "Norm299_L_M.pbs", "Norm300_Ms.pbs", "Norm301_Ac.pbs", "Norm312_Js.pbs", "Norm315_Kn.pbs", "Norm319_Sb.pbs", "Norm322_Rt.pbs", "Norm324_Dd.pbs", "Norm325_Aa.pbs", "Norm326_Jm.pbs", "Norm327_Jd.pbs", "Norm336_Vs.pbs", "Norm341_Kb.pbs", "Norm351_Ds.pbs");
foreach my $pbs (@list) {
	system("qsub -l nodes=1:ppn=4,walltime=72:00:00,mem=4gb $pbs");
}
