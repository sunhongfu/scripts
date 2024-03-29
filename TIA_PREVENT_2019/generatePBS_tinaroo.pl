use strict;
use warnings;
use List::Util qw[min max];
use File::Basename;


#my @input_dir_list = ("TIA/prevent_sorted/Prevent_246/Prevent_Bl(Pb_Fmc_Prevnt_01_12509) - 12509/Ax_3D_QSM_9", "TIA/prevent_sorted/Prevent_303/Prevent_Bl - 13949/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_304/Prevent_Bl - 14037/Ax_3D_QSM_7", "TIA/prevent_sorted/Prevent_306/Prevent_Bl - 14160/Ax_3D_QSM_9", "TIA/prevent_sorted/Prevent_307/Prevent_Bl - 14190/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_308/Prevent_Bl - 14180/Ax_3D_QSM_9", "TIA/prevent_sorted/Prevent_309/Prevent_Bl - 14212/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_310/Prevent_Bl - 14358/Ax_3D_QSM_9", "TIA/prevent_sorted/Prevent_311/Prevent_Bl - 14374/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_313/Prevent_Bl - 14415/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_314/Prevent_Bl - 14453/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_316/Prevent_Bl - 14495/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_317/Prevent_Bl - 14569/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_318/Prevent_Bl - 14616/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_319/Prevent_Bl - 14662/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_320/Prevent_Bl - 14685/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_321/Prevent_Bl - 14708/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_322/Prevent_Bl - 14758/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_323/Prevent_Bl - 14801/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_324/Prevent_Bl - 14829/Ax_3D_QSM_9", "TIA/prevent_sorted/Prevent_326/Prevent_Bl - 15090/Ax_3D_QSM_7", "TIA/prevent_sorted/Prevent_327/Prevent_Bl - 14912/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_328/Prevent_Bl - 14974/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_329/Prevent_Bl - 14973/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_330/Prevent_Bl - 15004/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_331/Prevent_Baseline - 15131/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_335/Prevent_Baseline - 15458/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_336/Prevent_Baseline - 15532/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_337/Prevent_Baseline - 15549/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_338/Prevent_Bl - 15705/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_340/Prevent_Baseline - 15751/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_341/Prevent_Baseline - 15773/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_342/Prevent_Baseline - 15874/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_344/Prevent_Baseline - 16087/Ax_3D_QSM_8");

#my @input_dir_list = ("TIA/prevent_sorted/Prevent_333/Prevent_Bl - 15181/Ax_3D_QSM_8", "TIA/prevent_sorted/Prevent_339/Prevent_Baseline - 15738/Ax_3D_QSM_9");
my @input_dir_list = ("PREVENT_089/study/series", "PREVENT_051/study/series", "PREVENT_082/study/series", "PREVENT_096/study/series", "PREVENT_056/study/series", "PREVENT_073/study/series", "PREVENT_058/study/series", "PREVENT_070/study/series", "PREVENT_076/study/series", "PREVENT_065/study", "PREVENT_093/study/series", "PREVENT_090/study/series", "PREVENT_087/study/series", "PREVENT_099/study/series", "PREVENT_053/study/series", "PREVENT_088/study/series", "PREVENT_077/study/series", "PREVENT_075/study/series", "PREVENT_061/study", "PREVENT_097/study/series", "PREVENT_079/study/series", "PREVENT_055/study/series", "PREVENT_059/study", "PREVENT_063/study", "PREVENT_067/study/series", "PREVENT_066/study", "PREVENT_060/study", "PREVENT_078/study/series");

# generate a .pbs file for each subject
# extract the subject number. e.g. Ps16_075_PRESCHOOL__PS16_075.pbs
foreach my $dicom (@input_dir_list){
	my @fields = split /\//, $dicom;
	my $dicom_parent = dirname($dicom);

	my $script = 
"#!/bin/bash
#
#PBS -A UQ-EAIT-ITEE
#
#PBS -l select=1:ncpus=1:mem=8GB
#PBS -l walltime=08:00:00

module load matlab 

cd $ENV{TMPDIR}/QSMpatients_51_100_unsorted
matlab  -nodisplay -nojvm -nosplash -singleCompThread -r \"qsm_spgr_ge_prevent(\'$dicom\', \'$dicom_parent\')\" 
";



	# print "$fields[0]\n";
	open(my $fileHandle, '>', "$ENV{TMPDIR}/QSMpatients_51_100_unsorted/$fields[0].pbs");  
	print $fileHandle $script;
	close $fileHandle
}






