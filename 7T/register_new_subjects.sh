
## register ME to MNI (ants)
t1=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181128110350_11_padded.nii
t1_brain=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/t1_brain.nii.gz
BET_mask=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/BET_mask_adj.nii 
mni_brain=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
qsm=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/chi_iLSQR_smvrad2_adj.nii
qsm_to_mni=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
r2sm=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/R2_adj.nii
r2sm_to_mni=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/R2_adj_to_MNI.nii.gz
t1m=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/T1map_ave.nii
t1m_brain=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/T1map_ave_brain.nii.gz
t1m_to_mni=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/T1m_to_MNI.nii.gz
#
t1m1=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181128110350_5_e1_padded.nii
t1m1_brain=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/T1map_e1_brain.nii.gz
t1m1_to_mni=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/T1m_e1_to_MNI.nii.gz
#

# apply BET mask to T1 and T1map_ave
fslmaths $t1 -mas $BET_mask $t1_brain
fslmaths $t1m -mas $BET_mask $t1m_brain
#
fslmaths $t1m1 -mas $BET_mask $t1m1_brain
#
## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=$t1_brain
ref=$mni_brain
transformPrefix=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/ants_trans_T1_to_MNI
warpedImage=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]
# register QSM to MNI templete
antsApplyTransforms -d 3 -i $qsm -r $mni_brain -o $qsm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
# register R2* map to MNI templete
antsApplyTransforms -d 3 -i $r2sm -r $mni_brain -o $r2sm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
# register T1 map to MNI templete
antsApplyTransforms -d 3 -i $t1m_brain -r $mni_brain -o $t1m_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
#
antsApplyTransforms -d 3 -i $t1m1_brain -r $mni_brain -o $t1m1_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
#
cd /Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75
gunzip -f *.nii.gz


## register BI to ME (flirt)
qsm_bi='/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/BI-QSM_0p75/chi_iLSQR_smvrad2_adj.nii'
qsm_memp2rage='/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/chi_iLSQR_smvrad2_adj.nii'
qsm_bi_to_memp2rage='/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/BI-QSM_0p75/chi_iLSQR_smvrad2_adj_bi2memp2rage.nii.gz'
mat_bi_to_memp2rage='/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/BI-QSM_0p75/qsm_bi2memp2rage_12DOF_normcorr_adj.mat'
r2s_bi='/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/BI-QSM_0p75/R2_adj.nii'
r2s_bi_to_memp2rage='/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/BI-QSM_0p75/R2_adj_bi2memp2rage.nii.gz'
qsm_bi_to_MNI='/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/BI-QSM_0p75/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii.gz'
r2s_bi_to_MNI='/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/BI-QSM_0p75/R2_adj_bi2memp2rage_to_MNI.nii.gz'
flirt -in $qsm_bi -ref $qsm_memp2rage -out $qsm_bi_to_memp2rage -omat $mat_bi_to_memp2rage -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in $r2s_bi -applyxfm -init $mat_bi_to_memp2rage -out $r2s_bi_to_memp2rage -paddingsize 0.0 -interp trilinear -ref $qsm_memp2rage
mni_brain=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
transformPrefix=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $qsm_bi_to_memp2rage -r $mni_brain -o $qsm_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $r2s_bi_to_memp2rage -r $mni_brain -o $r2s_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

cd /Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/BI-QSM_0p75
gunzip -f *.nii.gz



## register SE to ME to MNI
mv /Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/SE-MP2RAGE_0p75/dicom_series_mp2rage-wip944_0p75iso_7T_SE_20181128110350_18.nii /Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/SE-MP2RAGE_0p75/UNIDEN_c32.nii
mv /Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/SE-MP2RAGE_0p75/dicom_series_mp2rage-wip944_0p75iso_7T_SE_20181128110350_17.nii /Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/SE-MP2RAGE_0p75/T1map_c32.nii

UNI_SE='/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/SE-MP2RAGE_0p75/UNIDEN_c32.nii'
UNI_ME='/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181128110350_11_padded.nii'
UNI_SE_to_ME='/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/SE-MP2RAGE_0p75/UNIDEN_c32_SE_to_ME.nii.gz'
mat_UNI_SE_to_ME='/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/SE-MP2RAGE_0p75/UNI_SE_to_ME_12DOF_normcorr_adj.mat'
UNI_SE_to_ME_brain='/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/SE-MP2RAGE_0p75/UNIDEN_c32_SE_to_ME_brain.nii.gz'
T1_SE='/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/SE-MP2RAGE_0p75/T1map_c32.nii'
T1_SE_to_ME='/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/SE-MP2RAGE_0p75/T1map_c32_SE_to_ME.nii.gz'
T1_SE_to_ME_brain='/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/SE-MP2RAGE_0p75/T1map_c32_SE_to_ME_brain.nii.gz'
UNI_SE_to_MNI='/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/SE-MP2RAGE_0p75/UNIDEN_c32_SE_to_ME_to_MNI.nii.gz'
T1_SE_to_MNI='/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/SE-MP2RAGE_0p75/T1map_c32_SE_to_ME_to_MNI.nii.gz'
flirt -in $UNI_SE -ref $UNI_ME -out $UNI_SE_to_ME -omat $mat_UNI_SE_to_ME -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in $T1_SE -applyxfm -init $mat_UNI_SE_to_ME -out $T1_SE_to_ME -paddingsize 0.0 -interp trilinear -ref $UNI_ME
mni_brain=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
transformPrefix=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/ants_trans_T1_to_MNI
# skull stripping of UNIDEN and T1m
BET_mask=/Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75/BET_mask_adj.nii 
fslmaths $UNI_SE_to_ME -mas $BET_mask $UNI_SE_to_ME_brain
fslmaths $T1_SE_to_ME -mas $BET_mask $T1_SE_to_ME_brain
antsApplyTransforms -d 3 -i $UNI_SE_to_ME_brain -r $mni_brain -o $UNI_SE_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $T1_SE_to_ME_brain -r $mni_brain -o $T1_SE_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 


cd /Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/SE-MP2RAGE_0p75
gunzip -f *.nii.gz























## register ME to MNI (ants)
t1=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181127102251_11_padded.nii
t1_brain=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/t1_brain.nii.gz
BET_mask=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/BET_mask_adj.nii 
mni_brain=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
qsm=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/chi_iLSQR_smvrad2_adj.nii
qsm_to_mni=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
r2sm=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/R2_adj.nii
r2sm_to_mni=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/R2_adj_to_MNI.nii.gz
t1m=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/T1map_ave.nii
t1m_brain=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/T1map_ave_brain.nii.gz
t1m_to_mni=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/T1m_to_MNI.nii.gz
#
t1m1=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181127102251_7_e1_padded.nii
t1m1_brain=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/T1map_e1_brain.nii.gz
t1m1_to_mni=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/T1m_e1_to_MNI.nii.gz
#

# apply BET mask to T1 and T1map_ave
fslmaths $t1 -mas $BET_mask $t1_brain
fslmaths $t1m -mas $BET_mask $t1m_brain
#
fslmaths $t1m1 -mas $BET_mask $t1m1_brain
#
## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=$t1_brain
ref=$mni_brain
transformPrefix=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/ants_trans_T1_to_MNI
warpedImage=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]
# register QSM to MNI templete
antsApplyTransforms -d 3 -i $qsm -r $mni_brain -o $qsm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
# register R2* map to MNI templete
antsApplyTransforms -d 3 -i $r2sm -r $mni_brain -o $r2sm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
# register T1 map to MNI templete
antsApplyTransforms -d 3 -i $t1m_brain -r $mni_brain -o $t1m_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
#
antsApplyTransforms -d 3 -i $t1m1_brain -r $mni_brain -o $t1m1_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
#
cd /Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75
gunzip -f *.nii.gz


## register BI to ME (flirt)
qsm_bi='/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/BI-QSM_0p75/chi_iLSQR_smvrad2_adj.nii'
qsm_memp2rage='/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/chi_iLSQR_smvrad2_adj.nii'
qsm_bi_to_memp2rage='/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/BI-QSM_0p75/chi_iLSQR_smvrad2_adj_bi2memp2rage.nii.gz'
mat_bi_to_memp2rage='/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/BI-QSM_0p75/qsm_bi2memp2rage_12DOF_normcorr_adj.mat'
r2s_bi='/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/BI-QSM_0p75/R2_adj.nii'
r2s_bi_to_memp2rage='/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/BI-QSM_0p75/R2_adj_bi2memp2rage.nii.gz'
qsm_bi_to_MNI='/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/BI-QSM_0p75/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii.gz'
r2s_bi_to_MNI='/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/BI-QSM_0p75/R2_adj_bi2memp2rage_to_MNI.nii.gz'
flirt -in $qsm_bi -ref $qsm_memp2rage -out $qsm_bi_to_memp2rage -omat $mat_bi_to_memp2rage -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in $r2s_bi -applyxfm -init $mat_bi_to_memp2rage -out $r2s_bi_to_memp2rage -paddingsize 0.0 -interp trilinear -ref $qsm_memp2rage
mni_brain=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
transformPrefix=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/ants_trans_T1_to_MNI
antsApplyTransforms -d 3 -i $qsm_bi_to_memp2rage -r $mni_brain -o $qsm_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $r2s_bi_to_memp2rage -r $mni_brain -o $r2s_bi_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

cd /Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/BI-QSM_0p75
gunzip -f *.nii.gz





## register SE to ME to MNI
mv /Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/SE-MP2RAGE_0p75/dicom_series_mp2rage-wip944_0p75iso_7T_SE_FSnormal_20181127102251_44.nii /Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/SE-MP2RAGE_0p75/UNIDEN_c32.nii
mv /Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/SE-MP2RAGE_0p75/dicom_series_mp2rage-wip944_0p75iso_7T_SE_FSnormal_20181127102251_43.nii /Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/SE-MP2RAGE_0p75/T1map_c32.nii

UNI_SE='/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/SE-MP2RAGE_0p75/UNIDEN_c32.nii'
UNI_ME='/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181127102251_11_padded.nii'
UNI_SE_to_ME='/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/SE-MP2RAGE_0p75/UNIDEN_c32_SE_to_ME.nii.gz'
mat_UNI_SE_to_ME='/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/SE-MP2RAGE_0p75/UNI_SE_to_ME_12DOF_normcorr_adj.mat'
UNI_SE_to_ME_brain='/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/SE-MP2RAGE_0p75/UNIDEN_c32_SE_to_ME_brain.nii.gz'
T1_SE='/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/SE-MP2RAGE_0p75/T1map_c32.nii'
T1_SE_to_ME='/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/SE-MP2RAGE_0p75/T1map_c32_SE_to_ME.nii.gz'
T1_SE_to_ME_brain='/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/SE-MP2RAGE_0p75/T1map_c32_SE_to_ME_brain.nii.gz'
UNI_SE_to_MNI='/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/SE-MP2RAGE_0p75/UNIDEN_c32_SE_to_ME_to_MNI.nii.gz'
T1_SE_to_MNI='/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/SE-MP2RAGE_0p75/T1map_c32_SE_to_ME_to_MNI.nii.gz'
flirt -in $UNI_SE -ref $UNI_ME -out $UNI_SE_to_ME -omat $mat_UNI_SE_to_ME -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in $T1_SE -applyxfm -init $mat_UNI_SE_to_ME -out $T1_SE_to_ME -paddingsize 0.0 -interp trilinear -ref $UNI_ME
mni_brain=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
transformPrefix=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/ants_trans_T1_to_MNI
# skull stripping of UNIDEN and T1m
BET_mask=/Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75/BET_mask_adj.nii 
fslmaths $UNI_SE_to_ME -mas $BET_mask $UNI_SE_to_ME_brain
fslmaths $T1_SE_to_ME -mas $BET_mask $T1_SE_to_ME_brain
antsApplyTransforms -d 3 -i $UNI_SE_to_ME_brain -r $mni_brain -o $UNI_SE_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $T1_SE_to_ME_brain -r $mni_brain -o $T1_SE_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 


cd /Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/SE-MP2RAGE_0p75
gunzip -f *.nii.gz























## register ME to MNI (ants)
t1=/Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75/dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_R-L_20181126131256_71_padded.nii
t1_brain=/Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75/t1_brain.nii.gz
BET_mask=/Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75/BET_mask_adj.nii 
mni_brain=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
qsm=/Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75/chi_iLSQR_smvrad2_adj.nii
qsm_to_mni=/Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
r2sm=/Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75/R2_adj.nii
r2sm_to_mni=/Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75/R2_adj_to_MNI.nii.gz
t1m=/Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75/T1map_ave.nii
t1m_brain=/Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75/T1map_ave_brain.nii.gz
t1m_to_mni=/Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75/T1m_to_MNI.nii.gz
#
t1m1=/Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75/dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_R-L_20181126131256_64_e1_padded.nii
t1m1_brain=/Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75/T1map_e1_brain.nii.gz
t1m1_to_mni=/Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75/T1m_e1_to_MNI.nii.gz
#

# apply BET mask to T1 and T1map_ave
fslmaths $t1 -mas $BET_mask $t1_brain
fslmaths $t1m -mas $BET_mask $t1m_brain
#
fslmaths $t1m1 -mas $BET_mask $t1m1_brain
#
## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=$t1_brain
ref=$mni_brain
transformPrefix=/Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75/ants_trans_T1_to_MNI
warpedImage=/Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]
# register QSM to MNI templete
antsApplyTransforms -d 3 -i $qsm -r $mni_brain -o $qsm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
# register R2* map to MNI templete
antsApplyTransforms -d 3 -i $r2sm -r $mni_brain -o $r2sm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
# register T1 map to MNI templete
antsApplyTransforms -d 3 -i $t1m_brain -r $mni_brain -o $t1m_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
#
antsApplyTransforms -d 3 -i $t1m1_brain -r $mni_brain -o $t1m1_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
#
cd /Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75
gunzip -f *.nii.gz





## register SE to ME to MNI
mv /Users/hongfusun/DATA/paper_revision/registration/Wu_524/SE-MP2RAGE_0p75/dicom_series_mp2rage-wip944_0p75iso_7T_SINGLEECHO_20181126131256_79.nii /Users/hongfusun/DATA/paper_revision/registration/Wu_524/SE-MP2RAGE_0p75/UNIDEN_c32.nii
mv /Users/hongfusun/DATA/paper_revision/registration/Wu_524/SE-MP2RAGE_0p75/dicom_series_mp2rage-wip944_0p75iso_7T_SINGLEECHO_20181126131256_78.nii /Users/hongfusun/DATA/paper_revision/registration/Wu_524/SE-MP2RAGE_0p75/T1map_c32.nii

UNI_SE='/Users/hongfusun/DATA/paper_revision/registration/Wu_524/SE-MP2RAGE_0p75/UNIDEN_c32.nii'
UNI_ME='/Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75/dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_R-L_20181126131256_71_padded.nii'
UNI_SE_to_ME='/Users/hongfusun/DATA/paper_revision/registration/Wu_524/SE-MP2RAGE_0p75/UNIDEN_c32_SE_to_ME.nii.gz'
mat_UNI_SE_to_ME='/Users/hongfusun/DATA/paper_revision/registration/Wu_524/SE-MP2RAGE_0p75/UNI_SE_to_ME_12DOF_normcorr_adj.mat'
UNI_SE_to_ME_brain='/Users/hongfusun/DATA/paper_revision/registration/Wu_524/SE-MP2RAGE_0p75/UNIDEN_c32_SE_to_ME_brain.nii.gz'
T1_SE='/Users/hongfusun/DATA/paper_revision/registration/Wu_524/SE-MP2RAGE_0p75/T1map_c32.nii'
T1_SE_to_ME='/Users/hongfusun/DATA/paper_revision/registration/Wu_524/SE-MP2RAGE_0p75/T1map_c32_SE_to_ME.nii.gz'
T1_SE_to_ME_brain='/Users/hongfusun/DATA/paper_revision/registration/Wu_524/SE-MP2RAGE_0p75/T1map_c32_SE_to_ME_brain.nii.gz'
UNI_SE_to_MNI='/Users/hongfusun/DATA/paper_revision/registration/Wu_524/SE-MP2RAGE_0p75/UNIDEN_c32_SE_to_ME_to_MNI.nii.gz'
T1_SE_to_MNI='/Users/hongfusun/DATA/paper_revision/registration/Wu_524/SE-MP2RAGE_0p75/T1map_c32_SE_to_ME_to_MNI.nii.gz'
flirt -in $UNI_SE -ref $UNI_ME -out $UNI_SE_to_ME -omat $mat_UNI_SE_to_ME -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in $T1_SE -applyxfm -init $mat_UNI_SE_to_ME -out $T1_SE_to_ME -paddingsize 0.0 -interp trilinear -ref $UNI_ME
mni_brain=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
transformPrefix=/Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75/ants_trans_T1_to_MNI
# skull stripping of UNIDEN and T1m
BET_mask=/Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75/BET_mask_adj.nii 
fslmaths $UNI_SE_to_ME -mas $BET_mask $UNI_SE_to_ME_brain
fslmaths $T1_SE_to_ME -mas $BET_mask $T1_SE_to_ME_brain
antsApplyTransforms -d 3 -i $UNI_SE_to_ME_brain -r $mni_brain -o $UNI_SE_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $T1_SE_to_ME_brain -r $mni_brain -o $T1_SE_to_MNI -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

cd /Users/hongfusun/DATA/paper_revision/registration/Wu_524/SE-MP2RAGE_0p75
gunzip -f *.nii.gz



