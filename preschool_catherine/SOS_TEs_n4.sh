cd /media/data/project_preschool/recon/halfPi

shopt -s dotglob
shopt -s nullglob
array=(*)

for dir in "${array[@]}"
do
	cd "/media/data/project_preschool/recon/halfPi/$dir"
	echo "/media/data/project_preschool/recon/halfPi/$dir"
	mv megre_dcm.nii megre_dcm_e1.nii
	mv megre_dcm.json megre_dcm_e1.json
	fslmaths megre_dcm_e1.nii -mul megre_dcm_e1.nii megre_dcm_e1_squares.nii.gz
	fslmaths megre_dcm_e2.nii -mul megre_dcm_e2.nii megre_dcm_e2_squares.nii.gz
	fslmaths megre_dcm_e3.nii -mul megre_dcm_e3.nii megre_dcm_e3_squares.nii.gz
	fslmaths megre_dcm_e4.nii -mul megre_dcm_e4.nii megre_dcm_e4_squares.nii.gz
	fslmaths megre_dcm_e5.nii -mul megre_dcm_e5.nii megre_dcm_e5_squares.nii.gz
	fslmaths megre_dcm_e6.nii -mul megre_dcm_e6.nii megre_dcm_e6_squares.nii.gz
	fslmaths megre_dcm_e1_squares.nii.gz -add megre_dcm_e2_squares.nii.gz -add megre_dcm_e3_squares.nii.gz -add megre_dcm_e4_squares.nii.gz -add megre_dcm_e5_squares.nii.gz -add megre_dcm_e6_squares.nii.gz megre_dcm_squares_sum.nii.gz
	fslsplit megre_dcm_squares_sum.nii.gz mag_sos_

	fslmaths mag_sos_0000.nii.gz -mul QSM_SPGR_GE*/BET_mask_RAS.nii mag_sos_RAS_masked.nii.gz
	gunzip -f mag_sos_RAS_masked.nii.gz
	rm mag_sos_0000.nii.gz mag_sos_0001.nii.gz megre_dcm_e1_squares.nii.gz megre_dcm_e2_squares.nii.gz megre_dcm_e3_squares.nii.gz megre_dcm_e4_squares.nii.gz megre_dcm_e5_squares.nii.gz megre_dcm_e6_squares.nii.gz megre_dcm_squares_sum.nii.gz

	N4BiasFieldCorrection -i mag_sos_RAS_masked.nii -o mag_sos_RAS_masked_n4.nii

done




cd /media/data/project_preschool/recon/pi

shopt -s dotglob
shopt -s nullglob
array=(*)

for dir in "${array[@]}"
do
	cd "/media/data/project_preschool/recon/pi/$dir"
	echo "/media/data/project_preschool/recon/pi/$dir"
	mv megre_dcm.nii megre_dcm_e1.nii
	mv megre_dcm.json megre_dcm_e1.json
	fslmaths megre_dcm_e1.nii -mul megre_dcm_e1.nii megre_dcm_e1_squares.nii.gz
	fslmaths megre_dcm_e2.nii -mul megre_dcm_e2.nii megre_dcm_e2_squares.nii.gz
	fslmaths megre_dcm_e3.nii -mul megre_dcm_e3.nii megre_dcm_e3_squares.nii.gz
	fslmaths megre_dcm_e4.nii -mul megre_dcm_e4.nii megre_dcm_e4_squares.nii.gz
	fslmaths megre_dcm_e5.nii -mul megre_dcm_e5.nii megre_dcm_e5_squares.nii.gz
	fslmaths megre_dcm_e6.nii -mul megre_dcm_e6.nii megre_dcm_e6_squares.nii.gz
	fslmaths megre_dcm_e1_squares.nii.gz -add megre_dcm_e2_squares.nii.gz -add megre_dcm_e3_squares.nii.gz -add megre_dcm_e4_squares.nii.gz -add megre_dcm_e5_squares.nii.gz -add megre_dcm_e6_squares.nii.gz megre_dcm_squares_sum.nii.gz
	fslsplit megre_dcm_squares_sum.nii.gz mag_sos_

	fslmaths mag_sos_0000.nii.gz -mul QSM_SPGR_GE*/BET_mask_RAS.nii mag_sos_RAS_masked.nii.gz
	gunzip -f mag_sos_RAS_masked.nii.gz
	rm mag_sos_0000.nii.gz mag_sos_0001.nii.gz megre_dcm_e1_squares.nii.gz megre_dcm_e2_squares.nii.gz megre_dcm_e3_squares.nii.gz megre_dcm_e4_squares.nii.gz megre_dcm_e5_squares.nii.gz megre_dcm_e6_squares.nii.gz megre_dcm_squares_sum.nii.gz

	N4BiasFieldCorrection -i mag_sos_RAS_masked.nii -o mag_sos_RAS_masked_n4.nii

done




cd /media/data/project_preschool/recon/no_echo1

shopt -s dotglob
shopt -s nullglob
array=(*)

for dir in "${array[@]}"
do
	cd "/media/data/project_preschool/recon/no_echo1/$dir"
	echo "/media/data/project_preschool/recon/no_echo1/$dir"
	mv megre_dcm.nii megre_dcm_e1.nii
	mv megre_dcm.json megre_dcm_e1.json
	fslmaths megre_dcm_e1.nii -mul megre_dcm_e1.nii megre_dcm_e1_squares.nii.gz
	fslmaths megre_dcm_e2.nii -mul megre_dcm_e2.nii megre_dcm_e2_squares.nii.gz
	fslmaths megre_dcm_e3.nii -mul megre_dcm_e3.nii megre_dcm_e3_squares.nii.gz
	fslmaths megre_dcm_e4.nii -mul megre_dcm_e4.nii megre_dcm_e4_squares.nii.gz
	fslmaths megre_dcm_e5.nii -mul megre_dcm_e5.nii megre_dcm_e5_squares.nii.gz
	fslmaths megre_dcm_e6.nii -mul megre_dcm_e6.nii megre_dcm_e6_squares.nii.gz
	fslmaths megre_dcm_e1_squares.nii.gz -add megre_dcm_e2_squares.nii.gz -add megre_dcm_e3_squares.nii.gz -add megre_dcm_e4_squares.nii.gz -add megre_dcm_e5_squares.nii.gz -add megre_dcm_e6_squares.nii.gz megre_dcm_squares_sum.nii.gz
	fslsplit megre_dcm_squares_sum.nii.gz mag_sos_

	fslmaths mag_sos_0000.nii.gz -mul QSM_SPGR_GE*/BET_mask_RAS.nii mag_sos_RAS_masked.nii.gz
	gunzip -f mag_sos_RAS_masked.nii.gz
	rm mag_sos_0000.nii.gz mag_sos_0001.nii.gz megre_dcm_e1_squares.nii.gz megre_dcm_e2_squares.nii.gz megre_dcm_e3_squares.nii.gz megre_dcm_e4_squares.nii.gz megre_dcm_e5_squares.nii.gz megre_dcm_e6_squares.nii.gz megre_dcm_squares_sum.nii.gz

	N4BiasFieldCorrection -i mag_sos_RAS_masked.nii -o mag_sos_RAS_masked_n4.nii

done
