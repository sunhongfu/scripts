# (1) try different QSM methods (iLSQR vs. MEDI etc.)
# (2) test on more subjects



# define file names
tracts_prob_25=/usr/local/fsl/data/atlases/JHU/JHU-ICBM-tracts-maxprob-thr25-1mm.nii.gz
tracts_prob_50=/usr/local/fsl/data/atlases/JHU/JHU-ICBM-tracts-maxprob-thr50-1mm.nii.gz
wm_labels=/usr/local/fsl/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz
mni=/usr/local/fsl/data/standard/MNI152_T1_1mm.nii.gz
mni_brain=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz

t1=/media/data/7T_reg/07JON/megre_dcm_c32_e4.nii
t1_brain=/media/data/7T_reg/07JON/t1_brain.nii.gz

cosmos=/media/data/7T_reg/07JON/cosmos_5_12DOF_cgs_smvrad1.nii
cosmos_to_t1=/media/data/7T_reg/07JON/cosmos_5_12DOF_cgs_smvrad1_to_t1.nii.gz
cosmos_to_mni=/media/data/7T_reg/07JON/cosmos_5_12DOF_cgs_smvrad1_to_mni.nii.gz

mag_neutral=/media/data/7T_reg/07JON/neutral/QSM_MEGE_7T/src/mag_corr1.nii
qsm_neutral=/media/data/7T_reg/07JON/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1.nii
mag_neutral_to_t1=/media/data/7T_reg/07JON/neutral/QSM_MEGE_7T/src/mag_corr1_to_T1.nii.gz
mat_neutral_to_t1=/media/data/7T_reg/07JON/neutral/QSM_MEGE_7T/src/mag_corr1_to_T1.mat
qsm_neutral_to_t1=/media/data/7T_reg/07JON/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1_to_T1.nii.gz
qsm_neutral_to_mni=/media/data/7T_reg/07JON/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1_to_MNI.nii.gz
BET_prefix=/media/data/7T_reg/07JON/neutral/QSM_MEGE_7T/src/T1_BET
BET_mask=/media/data/7T_reg/07JON/neutral/QSM_MEGE_7T/src/T1_BET_mask.nii.gz

qsm_left=/media/data/7T_reg/07JON/left/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1.nii
mat_left_to_neutral=/media/data/7T_reg/07JON/left/flirt_mag_12DOF.mat
qsm_left_to_neutral=/media/data/7T_reg/07JON/left/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1_flirt.nii.gz
qsm_left_to_t1=/media/data/7T_reg/07JON/left/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1_flirt_to_T1.nii.gz
qsm_left_to_mni=/media/data/7T_reg/07JON/left/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1_flirt_to_MNI.nii.gz

qsm_right=/media/data/7T_reg/07JON/right/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1.nii
mat_right_to_neutral=/media/data/7T_reg/07JON/right/flirt_mag_12DOF.mat
qsm_right_to_neutral=/media/data/7T_reg/07JON/right/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1_flirt.nii.gz
qsm_right_to_t1=/media/data/7T_reg/07JON/right/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1_flirt_to_T1.nii.gz
qsm_right_to_mni=/media/data/7T_reg/07JON/right/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1_flirt_to_MNI.nii.gz

qsm_flexion=/media/data/7T_reg/07JON/flexion/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1.nii
mat_flexion_to_neutral=/media/data/7T_reg/07JON/flexion/flirt_mag_12DOF.mat
qsm_flexion_to_neutral=/media/data/7T_reg/07JON/flexion/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1_flirt.nii.gz
qsm_flexion_to_t1=/media/data/7T_reg/07JON/flexion/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1_flirt_to_T1.nii.gz
qsm_flexion_to_mni=/media/data/7T_reg/07JON/flexion/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1_flirt_to_MNI.nii.gz

qsm_extension=/media/data/7T_reg/07JON/extension/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1.nii
mat_extension_to_neutral=/media/data/7T_reg/07JON/extension/flirt_mag_12DOF.mat
qsm_extension_to_neutral=/media/data/7T_reg/07JON/extension/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1_flirt.nii.gz
qsm_extension_to_t1=/media/data/7T_reg/07JON/extension/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1_flirt_to_T1.nii.gz
qsm_extension_to_mni=/media/data/7T_reg/07JON/extension/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad1_flirt_to_MNI.nii.gz


## register 4 tilted orientations to neutral
flirt -in $qsm_left -applyxfm -init $mat_left_to_neutral -out $qsm_left_to_neutral -paddingsize 0.0 -interp trilinear -ref $qsm_neutral
flirt -in $qsm_right -applyxfm -init $mat_right_to_neutral -out $qsm_right_to_neutral -paddingsize 0.0 -interp trilinear -ref $qsm_neutral
flirt -in $qsm_extension -applyxfm -init $mat_extension_to_neutral -out $qsm_extension_to_neutral -paddingsize 0.0 -interp trilinear -ref $qsm_neutral
flirt -in $qsm_flexion -applyxfm -init $mat_flexion_to_neutral -out $qsm_flexion_to_neutral -paddingsize 0.0 -interp trilinear -ref $qsm_neutral


## register neutral QSM-mag to T1
flirt -in $mag_neutral -ref $t1 -out $mag_neutral_to_t1 -omat $mat_neutral_to_t1 -bins 256 -cost corratio -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 6  -interp trilinear


## extract mag_neutral_to_t1 brain, apply the mask to T1
bet2 $mag_neutral_to_t1 $BET_prefix -f 0.3 -m
fslmaths $t1 -mas $BET_mask $t1_brain

## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=$t1_brain
ref=$mni_brain
mkdir /media/data/7T_reg/07JON/ants_brain
transformPrefix=/media/data/7T_reg/07JON/ants_brain/ants_trans_T1_to_MNI
warpedImage=/media/data/7T_reg/07JON//ants_brain/ants_trans_T1_to_MNI.nii.gz
############################################################################
# src=$t1
# ref=$mni
# mkdir /media/data/7T_reg/07JON/ants_head
# transformPrefix=/media/data/7T_reg/07JON/ants_head/ants_trans_T1_to_MNI
# warpedImage=/media/data/7T_reg/07JON//ants_head/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# antsApplyTransforms -d 3 -i $magImage -r $ref -o $magOutImage -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

# antsApplyTransforms -d 3 -i $lfsImage -r $ref -o $lfsOutImage -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat


# register QSM to T1
flirt -in $qsm_left_to_neutral -applyxfm -init $mat_neutral_to_t1 -out $qsm_left_to_t1 -paddingsize 0.0 -interp trilinear -ref $t1_brain
flirt -in $qsm_right_to_neutral -applyxfm -init $mat_neutral_to_t1 -out $qsm_right_to_t1 -paddingsize 0.0 -interp trilinear -ref $t1_brain
flirt -in $qsm_extension_to_neutral -applyxfm -init $mat_neutral_to_t1 -out $qsm_extension_to_t1 -paddingsize 0.0 -interp trilinear -ref $t1_brain
flirt -in $qsm_flexion_to_neutral -applyxfm -init $mat_neutral_to_t1 -out $qsm_flexion_to_t1 -paddingsize 0.0 -interp trilinear -ref $t1_brain
flirt -in $qsm_neutral -applyxfm -init $mat_neutral_to_t1 -out $qsm_neutral_to_t1 -paddingsize 0.0 -interp trilinear -ref $t1_brain


# register QSM to MNI templete
antsApplyTransforms -d 3 -i $qsm_left_to_t1 -r $mni -o $qsm_left_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $qsm_right_to_t1 -r $mni -o $qsm_right_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $qsm_extension_to_t1 -r $mni -o $qsm_extension_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $qsm_flexion_to_t1 -r $mni -o $qsm_flexion_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $qsm_neutral_to_t1 -r $mni -o $qsm_neutral_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 


# do the measurements on the tracts (max prob 25)
fslstats -K $tracts_prob_25 $qsm_neutral_to_mni -M
fslstats -K $tracts_prob_25 $qsm_left_to_mni -M
fslstats -K $tracts_prob_25 $qsm_right_to_mni -M
fslstats -K $tracts_prob_25 $qsm_flexion_to_mni -M
fslstats -K $tracts_prob_25 $qsm_extension_to_mni -M

# do the measurements on the tracts (max prob 50)
fslstats -K $tracts_prob_50 $qsm_neutral_to_mni -M
fslstats -K $tracts_prob_50 $qsm_left_to_mni -M
fslstats -K $tracts_prob_50 $qsm_right_to_mni -M
fslstats -K $tracts_prob_50 $qsm_flexion_to_mni -M
fslstats -K $tracts_prob_50 $qsm_extension_to_mni -M

# do the measurements on the labels
fslstats -K $wm_labels $qsm_neutral_to_mni -M
fslstats -K $wm_labels $qsm_left_to_mni -M
fslstats -K $wm_labels $qsm_right_to_mni -M
fslstats -K $wm_labels $qsm_flexion_to_mni -M
fslstats -K $wm_labels $qsm_extension_to_mni -M

# register COSMOS to MNI space
flirt -in $cosmos -applyxfm -init $mat_neutral_to_t1 -out $cosmos_to_t1 -paddingsize 0.0 -interp trilinear -ref $t1_brain
antsApplyTransforms -d 3 -i $cosmos_to_t1 -r $mni -o $cosmos_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 


###########
# try other options
# (1) ants, BET T1 first, then register with MNI_brain atlas without skull
#  if BET doesn't work well on T1, do it on the registered QSM_mag
# (2) FNIRT, try with or w/o skull
# (3) test ants with Dimitriis python code
# (4) try xiang's ANTS with slow mode


