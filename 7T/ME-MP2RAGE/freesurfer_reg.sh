# convert to mgz for freesurfer
bi_mag_qsm=/Users/hongfusun/DATA/freesurfer/03JK_QSM/BI-QSM_0p75/mag_corr1_n4_adj.nii
bi_mag_qsm_mgz=/Users/hongfusun/DATA/freesurfer/03JK_QSM/BI-QSM_0p75/mag_corr1_n4_adj.mgz
bi_qsm=/Users/hongfusun/DATA/freesurfer/03JK_QSM/BI-QSM_0p75/chi_iLSQR_smvrad2_adj.nii
bi_qsm_mgz=/Users/hongfusun/DATA/freesurfer/03JK_QSM/BI-QSM_0p75/chi_iLSQR_smvrad2_adj.mgz

mri_convert -vs 0.75 0.75 0.75 $bi_mag_qsm $bi_mag_qsm_mgz
mri_convert -vs 0.75 0.75 0.75 $bi_qsm $bi_qsm_mgz



# convert to mgz for freesurfer
mp2_mag_qsm=/Users/hongfusun/DATA/freesurfer/03JK_QSM/ME-MP2RAGE_0p75/mag_corr1_n4_adj.nii
mp2_mag_qsm_mgz=/Users/hongfusun/DATA/freesurfer/03JK_QSM/ME-MP2RAGE_0p75/mag_corr1_n4_adj.mgz
mp2_qsm=/Users/hongfusun/DATA/freesurfer/03JK_QSM/ME-MP2RAGE_0p75/chi_iLSQR_smvrad2_adj.nii
mp2_qsm_mgz=/Users/hongfusun/DATA/freesurfer/03JK_QSM/ME-MP2RAGE_0p75/chi_iLSQR_smvrad2_adj.mgz

mri_convert -vs 0.75 0.75 0.75 $mp2_mag_qsm $mp2_mag_qsm_mgz
mri_convert -vs 0.75 0.75 0.75 $mp2_qsm $mp2_qsm_mgz


temp=/Users/hongfusun/DATA/freesurfer/03JK_QSM/mag_mean.mgz
temp_nii=/Users/hongfusun/DATA/freesurfer/03JK_QSM/mag_mean.nii
bi_lta=/Users/hongfusun/DATA/freesurfer/03JK_QSM/bi_lta.lta
mp2_lta=/Users/hongfusun/DATA/freesurfer/03JK_QSM/mp2_lta.lta
bi_to_mean=/Users/hongfusun/DATA/freesurfer/03JK_QSM/bi_to_mean.mgz
mp2_to_mean=/Users/hongfusun/DATA/freesurfer/03JK_QSM/mp2_to_mean.mgz

bi_to_mean_nii=/Users/hongfusun/DATA/freesurfer/03JK_QSM/bi_to_mean.nii
mp2_to_mean_nii=/Users/hongfusun/DATA/freesurfer/03JK_QSM/mp2_to_mean.nii

bi_qsm_to_mean=/Users/hongfusun/DATA/freesurfer/03JK_QSM/BI-QSM_0p75/qsm_to_mean.mgz
mp2_qsm_to_mean=/Users/hongfusun/DATA/freesurfer/03JK_QSM/ME-MP2RAGE_0p75/qsm_to_mean.mgz

bi_qsm_to_mean_nii=/Users/hongfusun/DATA/freesurfer/03JK_QSM/BI-QSM_0p75/qsm_to_mean.nii
mp2_qsm_to_mean_nii=/Users/hongfusun/DATA/freesurfer/03JK_QSM/ME-MP2RAGE_0p75/qsm_to_mean.nii

# register the two mag
mri_robust_template --mov $bi_mag_qsm_mgz $mp2_mag_qsm_mgz --template $temp --lta $bi_lta $mp2_lta  --mapmov $bi_to_mean $mp2_to_mean  --average 0 --iscale --satit

# apply transformation to qsm
mri_convert -at $bi_lta $bi_qsm_mgz $bi_qsm_to_mean
mri_convert -at $mp2_lta $mp2_qsm_mgz $mp2_qsm_to_mean

# convert mgz to nii
mri_convert $bi_to_mean $bi_to_mean_nii
mri_convert $mp2_to_mean $mp2_to_mean_nii

# convert mgz to nii
mri_convert $temp $temp_nii
mri_convert $bi_qsm_to_mean $bi_qsm_to_mean_nii
mri_convert $mp2_qsm_to_mean $mp2_qsm_to_mean_nii




######################################################################
######################################################################





# convert to mgz for freesurfer
bi_mag_r2s=/Users/hongfusun/DATA/freesurfer/01EG_R2s/BI-QSM_0p75/mag_corr1_n4_adj.nii
bi_mag_r2s_mgz=/Users/hongfusun/DATA/freesurfer/01EG_R2s/BI-QSM_0p75/mag_corr1_n4_adj.mgz
bi_r2s=/Users/hongfusun/DATA/freesurfer/01EG_R2s/BI-QSM_0p75/R2_adj.nii
bi_r2s_mgz=/Users/hongfusun/DATA/freesurfer/01EG_R2s/BI-QSM_0p75/R2_adj.mgz

bi_r2s_4echo=/Users/hongfusun/DATA/freesurfer/01EG_R2s/BI-QSM_0p75/R2_4echo_adj.nii
bi_r2s_4echo_mgz=/Users/hongfusun/DATA/freesurfer/01EG_R2s/BI-QSM_0p75/R2_4echo_adj.mgz


mri_convert -vs 0.75 0.75 0.75 $bi_mag_r2s $bi_mag_r2s_mgz
mri_convert -vs 0.75 0.75 0.75 $bi_r2s $bi_r2s_mgz

mri_convert -vs 0.75 0.75 0.75 $bi_r2s_4echo $bi_r2s_4echo_mgz



# convert to mgz for freesurfer
mp2_mag_r2s=/Users/hongfusun/DATA/freesurfer/01EG_R2s/ME-MP2RAGE_0p75/mag_corr1_n4_adj.nii
mp2_mag_r2s_mgz=/Users/hongfusun/DATA/freesurfer/01EG_R2s/ME-MP2RAGE_0p75/mag_corr1_n4_adj.mgz
mp2_r2s=/Users/hongfusun/DATA/freesurfer/01EG_R2s/ME-MP2RAGE_0p75/R2_adj.nii
mp2_r2s_mgz=/Users/hongfusun/DATA/freesurfer/01EG_R2s/ME-MP2RAGE_0p75/R2_adj.mgz

mri_convert -vs 0.75 0.75 0.75 $mp2_mag_r2s $mp2_mag_r2s_mgz
mri_convert -vs 0.75 0.75 0.75 $mp2_r2s $mp2_r2s_mgz


temp=/Users/hongfusun/DATA/freesurfer/01EG_R2s/mag_mean.mgz
temp_nii=/Users/hongfusun/DATA/freesurfer/01EG_R2s/mag_mean.nii
bi_lta=/Users/hongfusun/DATA/freesurfer/01EG_R2s/bi_lta.lta
mp2_lta=/Users/hongfusun/DATA/freesurfer/01EG_R2s/mp2_lta.lta
bi_to_mean=/Users/hongfusun/DATA/freesurfer/01EG_R2s/bi_to_mean.mgz
mp2_to_mean=/Users/hongfusun/DATA/freesurfer/01EG_R2s/mp2_to_mean.mgz

bi_to_mean_nii=/Users/hongfusun/DATA/freesurfer/01EG_R2s/bi_to_mean.nii
mp2_to_mean_nii=/Users/hongfusun/DATA/freesurfer/01EG_R2s/mp2_to_mean.nii

bi_r2s_to_mean=/Users/hongfusun/DATA/freesurfer/01EG_R2s/BI-QSM_0p75/r2s_to_mean.mgz
mp2_r2s_to_mean=/Users/hongfusun/DATA/freesurfer/01EG_R2s/ME-MP2RAGE_0p75/r2s_to_mean.mgz
bi_r2s_4echo_to_mean=/Users/hongfusun/DATA/freesurfer/01EG_R2s/BI-QSM_0p75/r2s_4echo_to_mean.mgz

bi_r2s_to_mean_nii=/Users/hongfusun/DATA/freesurfer/01EG_R2s/BI-QSM_0p75/r2s_to_mean.nii
mp2_r2s_to_mean_nii=/Users/hongfusun/DATA/freesurfer/01EG_R2s/ME-MP2RAGE_0p75/r2s_to_mean.nii
bi_r2s_4echo_to_mean_nii=/Users/hongfusun/DATA/freesurfer/01EG_R2s/BI-QSM_0p75/r2s_4echo_to_mean.nii

# register the two mag
mri_robust_template --mov $bi_mag_r2s_mgz $mp2_mag_r2s_mgz --template $temp --lta $bi_lta $mp2_lta  --mapmov $bi_to_mean $mp2_to_mean  --average 0 --iscale --satit

# apply transformation to r2s
mri_convert -at $bi_lta $bi_r2s_mgz $bi_r2s_to_mean
mri_convert -at $mp2_lta $mp2_r2s_mgz $mp2_r2s_to_mean

mri_convert -at $bi_lta $bi_r2s_4echo_mgz $bi_r2s_4echo_to_mean


# convert mgz to nii
mri_convert $bi_to_mean $bi_to_mean_nii
mri_convert $mp2_to_mean $mp2_to_mean_nii

mri_convert $bi_r2s_4echo_to_mean $bi_r2s_4echo_to_mean_nii


# convert mgz to nii
mri_convert $temp $temp_nii
mri_convert $bi_r2s_to_mean $bi_r2s_to_mean_nii
mri_convert $mp2_r2s_to_mean $mp2_r2s_to_mean_nii

