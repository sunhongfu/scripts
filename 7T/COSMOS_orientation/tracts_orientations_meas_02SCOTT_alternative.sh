
# define file names
tracts_prob_25=/usr/local/fsl/5.0.9/data/atlases/JHU/JHU-ICBM-tracts-maxprob-thr25-1mm.nii.gz
tracts_prob_50=/usr/local/fsl/5.0.9/data/atlases/JHU/JHU-ICBM-tracts-maxprob-thr50-1mm.nii.gz
wm_labels=/usr/local/fsl/5.0.9/data/atlases/JHU/JHU-ICBM-labels-1mm.nii.gz
mni=/usr/local/fsl/5.0.9/data/standard/MNI152_T1_1mm.nii.gz
mni_brain=/usr/local/fsl/5.0.9/data/standard/MNI152_T1_1mm_brain.nii.gz
mni_highres=/usr/local/fsl/5.0.9/data/standard/MNI152_T1_0.5mm.nii.gz

t1=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/t1/co20170828_093953mp2ragep9mmisoipat4T1700T2700TR4900s046a1001.nii.gz
t1_brain=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/t1/t1_brain.nii.gz
# t1_brain_flirt=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/t1_brain_flirt.nii.gz
# mat_t1_brain_flirt=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/t1_brain_flirt.mat
t1_to_mag_neutral=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/t1/T1_to_mag_corr1_n4_adj.nii.gz
mat_t1_to_neutral=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/t1/T1_to_mag_corr1_n4_adj.mat

# cosmos=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/cosmos_5_6DOF_rad1.nii
# cosmos_to_t1_flirt=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/cosmos_5_6DOF_rad1_to_t1_flirt.nii.gz
# cosmos_to_mni=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/cosmos_5_6DOF_rad1_to_mni.nii.gz

mag_neutral=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/neutral/QSM_MEGE_7T/src/mag_corr1_n4_adj.nii
qsm_neutral=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii
# qsm_neutral_to_t1_flirt=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_to_T1_flirt.nii.gz
qsm_neutral_to_mni=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
BET_mask=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/neutral/QSM_MEGE_7T/BET_mask_adj.nii

qsm_left=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/left/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii
mat_left_to_neutral=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/left/qsm_l2n_12DOF_normcorr_adj.mat
qsm_left_to_neutral=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/left/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_l2n.nii.gz
# qsm_left_to_t1_flirt=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/left/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_flirt_to_T1_flirt.nii.gz
qsm_left_to_mni=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/left/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_l2n_to_MNI.nii.gz

qsm_right=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/right/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii
mat_right_to_neutral=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/right/qsm_r2n_12DOF_normcorr_adj.mat
qsm_right_to_neutral=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/right/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_r2n.nii.gz
# qsm_right_to_t1_flirt=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/right/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_flirt_to_T1_flirt.nii.gz
qsm_right_to_mni=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/right/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_r2n_to_MNI.nii.gz

qsm_flexion=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/flexion/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii
mat_flexion_to_neutral=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/flexion/qsm_f2n_12DOF_normcorr_adj.mat
qsm_flexion_to_neutral=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/flexion/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_f2n.nii.gz
# qsm_flexion_to_t1_flirt=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/flexion/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_flirt_to_T1_flirt.nii.gz
qsm_flexion_to_mni=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/flexion/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_f2n_to_MNI.nii.gz

qsm_extension=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/extension/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii
mat_extension_to_neutral=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/extension/qsm_e2n_12DOF_normcorr_adj.mat
qsm_extension_to_neutral=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/extension/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_e2n.nii.gz
# qsm_extension_to_t1_flirt=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/extension/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_flirt_to_T1_flirt.nii.gz
qsm_extension_to_mni=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/extension/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_e2n_to_MNI.nii.gz





# register 4 titled chi_adj to neutral

flirt -in $qsm_left -ref $qsm_neutral -out $qsm_left_to_neutral -omat $mat_left_to_neutral -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in $qsm_right -ref $qsm_neutral -out $qsm_right_to_neutral -omat $mat_right_to_neutral -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in $qsm_extension -ref $qsm_neutral -out $qsm_extension_to_neutral -omat $mat_extension_to_neutral -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear
flirt -in $qsm_flexion -ref $qsm_neutral -out $qsm_flexion_to_neutral -omat $mat_flexion_to_neutral -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear



# ## register 4 tilted orientations to neutral
# flirt -in $qsm_left -applyxfm -init $mat_left_to_neutral -out $qsm_left_to_neutral -paddingsize 0.0 -interp trilinear -ref $qsm_neutral
# flirt -in $qsm_right -applyxfm -init $mat_right_to_neutral -out $qsm_right_to_neutral -paddingsize 0.0 -interp trilinear -ref $qsm_neutral
# flirt -in $qsm_extension -applyxfm -init $mat_extension_to_neutral -out $qsm_extension_to_neutral -paddingsize 0.0 -interp trilinear -ref $qsm_neutral
# flirt -in $qsm_flexion -applyxfm -init $mat_flexion_to_neutral -out $qsm_flexion_to_neutral -paddingsize 0.0 -interp trilinear -ref $qsm_neutral


## register T1 to neutral mag
flirt -in $t1 -ref $mag_neutral -out $t1_to_mag_neutral -omat $mat_t1_to_neutral -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear


# apply mag mask to registered T1
fslmaths $t1_to_mag_neutral -mas $BET_mask $t1_brain



## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=$t1_brain
ref=$mni_brain
mkdir /home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/ants_brain
transformPrefix=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/ants_brain/ants_trans_T1_to_MNI
warpedImage=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT//ants_brain/ants_trans_T1_to_MNI.nii.gz
############################################################################
# src=$t1
# ref=$mni
# mkdir /home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/ants_head
# transformPrefix=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT/ants_head/ants_trans_T1_to_MNI
# warpedImage=/home/hongfu/NCIgb5_scratch/hongfu/COSMOS/02SCOTT//ants_head/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# antsApplyTransforms -d 3 -i $magImage -r $ref -o $magOutImage -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

# antsApplyTransforms -d 3 -i $lfsImage -r $ref -o $lfsOutImage -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat


# register QSM to MNI templete
antsApplyTransforms -d 3 -i $qsm_left_to_neutral -r $mni_brain -o $qsm_left_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $qsm_right_to_neutral -r $mni_brain -o $qsm_right_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $qsm_extension_to_neutral -r $mni_brain -o $qsm_extension_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $qsm_flexion_to_neutral -r $mni_brain -o $qsm_flexion_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $qsm_neutral -r $mni_brain -o $qsm_neutral_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 


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
flirt -in $cosmos -applyxfm -init $mat_t1_brain_flirt -out $cosmos_to_t1_flirt -paddingsize 0.0 -interp trilinear -ref $t1_brain_flirt
antsApplyTransforms -d 3 -i $cosmos_to_t1_flirt -r $mni_brain -o $cosmos_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

