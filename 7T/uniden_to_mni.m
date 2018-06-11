
# ants registration from UNIDEN_COMBO to MNI_T1
t1=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/UNIDEN_comboecho/20170228_124116mp2rage0p75mmisoBipolarPloss046a4001.nii
t1_brain=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/UNIDEN_comboecho/t1_brain.nii.gz
BET_mask=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/BET_mask_adj.nii 
mni_brain=/usr/local/fsl/5.0.9/data/standard/MNI152_T1_1mm_brain.nii.gz
qsm=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii
qsm_to_mni=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
r2sm=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/R2_I2_adj.nii
r2sm_to_mni=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii.gz
t1m=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/T1map/t1_ave.nii
t1m_to_mni=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/T1map/T1m_to_MNI.nii.gz


# apply BET mask to T1
fslmaths $t1 -mas $BET_mask $t1_brain


## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=$t1_brain
ref=$mni_brain
transformPrefix=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/UNIDEN_comboecho/ants_trans_T1_to_MNI
warpedImage=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# register QSM to MNI templete
antsApplyTransforms -d 3 -i $qsm -r $mni_brain -o $qsm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

# register R2* map to MNI templete
antsApplyTransforms -d 3 -i $r2sm -r $mni_brain -o $r2sm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

# register T1 map to MNI templete
antsApplyTransforms -d 3 -i $t1m -r $mni_brain -o $t1m_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 









# ants registration from UNIDEN_COMBO to MNI_T1
t1=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/UNIDEN_comboecho/20170927_105246mp2rage0p75BiPlos4TEVariedBWtx220s008a4001.nii
t1_brain=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/UNIDEN_comboecho/t1_brain.nii.gz
BET_mask=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T/BET_mask_adj.nii 
mni_brain=/usr/local/fsl/5.0.9/data/standard/MNI152_T1_1mm_brain.nii.gz
qsm=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii
qsm_to_mni=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
r2sm=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T/R2_I2_adj.nii
r2sm_to_mni=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii.gz
t1m=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/T1map/t1_ave.nii
t1m_to_mni=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/T1map/T1m_to_MNI.nii.gz

# apply BET mask to T1
fslmaths $t1 -mas $BET_mask $t1_brain


## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=$t1_brain
ref=$mni_brain
transformPrefix=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/UNIDEN_comboecho/ants_trans_T1_to_MNI
warpedImage=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# register QSM to MNI templete
antsApplyTransforms -d 3 -i $qsm -r $mni_brain -o $qsm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

# register R2* map to MNI templete
antsApplyTransforms -d 3 -i $r2sm -r $mni_brain -o $r2sm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

# register T1 map to MNI templete
antsApplyTransforms -d 3 -i $t1m -r $mni_brain -o $t1m_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 













# ants registration from UNIDEN_COMBO to MNI_T1
t1=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/UNIDEN_comboecho/20170927_141928mp2rage0p75BiPlos4TEVariedBWtx213s012a4001.nii
t1_brain=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/UNIDEN_comboecho/t1_brain.nii.gz
BET_mask=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/BET_mask_adj.nii 
mni_brain=/usr/local/fsl/5.0.9/data/standard/MNI152_T1_1mm_brain.nii.gz
qsm=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii
qsm_to_mni=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
r2sm=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/R2_I2_adj.nii
r2sm_to_mni=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii.gz
t1m=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/T1map/t1_ave.nii
t1m_to_mni=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/T1map/T1m_to_MNI.nii.gz

# apply BET mask to T1
fslmaths $t1 -mas $BET_mask $t1_brain


## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=$t1_brain
ref=$mni_brain
transformPrefix=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/UNIDEN_comboecho/ants_trans_T1_to_MNI
warpedImage=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# register QSM to MNI templete
antsApplyTransforms -d 3 -i $qsm -r $mni_brain -o $qsm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

# register R2* map to MNI templete
antsApplyTransforms -d 3 -i $r2sm -r $mni_brain -o $r2sm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

# register T1 map to MNI templete
antsApplyTransforms -d 3 -i $t1m -r $mni_brain -o $t1m_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 












# ants registration from UNIDEN_COMBO to MNI_T1
t1=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/UNIDEN_comboecho/20171004_135402mp2rage0p75BiPlos4TEVariedBWs011a4001.nii
t1_brain=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/UNIDEN_comboecho/t1_brain.nii.gz
BET_mask=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/QSM_MEMP2RAGE_7T/BET_mask_adj.nii 
mni_brain=/usr/local/fsl/5.0.9/data/standard/MNI152_T1_1mm_brain.nii.gz
qsm=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii
qsm_to_mni=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
r2sm=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/QSM_MEMP2RAGE_7T/R2_I2_adj.nii
r2sm_to_mni=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii.gz
t1m=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/T1map/t1_ave.nii
t1m_to_mni=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/T1map/T1m_to_MNI.nii.gz

# apply BET mask to T1
fslmaths $t1 -mas $BET_mask $t1_brain


## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=$t1_brain
ref=$mni_brain
transformPrefix=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/UNIDEN_comboecho/ants_trans_T1_to_MNI
warpedImage=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# register QSM to MNI templete
antsApplyTransforms -d 3 -i $qsm -r $mni_brain -o $qsm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

# register R2* map to MNI templete
antsApplyTransforms -d 3 -i $r2sm -r $mni_brain -o $r2sm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

# register T1 map to MNI templete
antsApplyTransforms -d 3 -i $t1m -r $mni_brain -o $t1m_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 












# ants registration from UNIDEN_COMBO to MNI_T1
t1=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/UNIDEN_comboecho/20171031_141844mp2rage0p75BiPlos4TEVariedBWtx220s015a4001.nii
t1_brain=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/UNIDEN_comboecho/t1_brain.nii.gz
BET_mask=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/BET_mask_adj.nii 
mni_brain=/usr/local/fsl/5.0.9/data/standard/MNI152_T1_1mm_brain.nii.gz
qsm=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii
qsm_to_mni=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
r2sm=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/R2_I2_adj.nii
r2sm_to_mni=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii.gz
t1m=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/T1map/t1_ave.nii
t1m_to_mni=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/T1map/T1m_to_MNI.nii.gz

# apply BET mask to T1
fslmaths $t1 -mas $BET_mask $t1_brain


## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=$t1_brain
ref=$mni_brain
transformPrefix=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/UNIDEN_comboecho/ants_trans_T1_to_MNI
warpedImage=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# register QSM to MNI templete
antsApplyTransforms -d 3 -i $qsm -r $mni_brain -o $qsm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

# register R2* map to MNI templete
antsApplyTransforms -d 3 -i $r2sm -r $mni_brain -o $r2sm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

# register T1 map to MNI templete
antsApplyTransforms -d 3 -i $t1m -r $mni_brain -o $t1m_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 








% generate the group average maps for QSM, T1, R2*
% create group average maps
mkdir /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/group

% MATLAB scripts
% R2* maps
!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,1) = single(nii.img);
mask_to_MNI_all(:,:,:,1) = single(single(nii.img)~=0);

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,2) = single(nii.img);
mask_to_MNI_all(:,:,:,2) = single(single(nii.img)~=0);

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,3) = single(nii.img);
mask_to_MNI_all(:,:,:,3) = single(single(nii.img)~=0);

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,4) = single(nii.img);
mask_to_MNI_all(:,:,:,4) = single(single(nii.img)~=0);

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,5) = single(nii.img);
mask_to_MNI_all(:,:,:,5) = single(single(nii.img)~=0);


R2s_to_MNI_mean = sum(R2s_to_MNI_all,4)./sum(mask_to_MNI_all,4);
R2s_to_MNI_mean(isinf(R2s_to_MNI_mean)) = 0;
R2s_to_MNI_mean(isnan(R2s_to_MNI_mean)) = 0;
nii.img = R2s_to_MNI_mean;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/group/R2s_to_MNI_mean.nii');

mask_small = mean(mask_to_MNI_all,4);
mask_small(mask_small<1) = 0;

R2s_to_MNI_mean_small = R2s_to_MNI_mean.*mask_small;
nii.img = R2s_to_MNI_mean_small;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/group/R2s_to_MNI_mean_small.nii');





% MATLAB scripts
% QSM
mkdir /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/group

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,1) = single(nii.img);
mask_to_MNI_all(:,:,:,1) = single(single(nii.img)~=0);

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,2) = single(nii.img);
mask_to_MNI_all(:,:,:,2) = single(single(nii.img)~=0);

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,3) = single(nii.img);
mask_to_MNI_all(:,:,:,3) = single(single(nii.img)~=0);

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,4) = single(nii.img);
mask_to_MNI_all(:,:,:,4) = single(single(nii.img)~=0);

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,5) = single(nii.img);
mask_to_MNI_all(:,:,:,5) = single(single(nii.img)~=0);


QSM_to_MNI_mean = sum(QSM_to_MNI_all,4)./sum(mask_to_MNI_all,4);
QSM_to_MNI_mean(isinf(QSM_to_MNI_mean)) = 0;
QSM_to_MNI_mean(isnan(QSM_to_MNI_mean)) = 0;
nii.img = QSM_to_MNI_mean;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/group/QSM_to_MNI_mean.nii');

mask_small = mean(mask_to_MNI_all,4);
mask_small(mask_small<1) = 0;

QSM_to_MNI_mean_small = QSM_to_MNI_mean.*mask_small;
nii.img = QSM_to_MNI_mean_small;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/group/QSM_to_MNI_mean_small.nii');




% MATLAB scripts
% T1W
mkdir /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/group

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,1) = single(nii.img);
mask_to_MNI_all(:,:,:,1) = single(single(nii.img)~=0);

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,2) = single(nii.img);
mask_to_MNI_all(:,:,:,2) = single(single(nii.img)~=0);

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,3) = single(nii.img);
mask_to_MNI_all(:,:,:,3) = single(single(nii.img)~=0);

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,4) = single(nii.img);
mask_to_MNI_all(:,:,:,4) = single(single(nii.img)~=0);

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,5) = single(nii.img);
mask_to_MNI_all(:,:,:,5) = single(single(nii.img)~=0);


UNIDEN_to_MNI_mean = sum(UNIDEN_to_MNI_all,4)./sum(mask_to_MNI_all,4);
UNIDEN_to_MNI_mean(isinf(UNIDEN_to_MNI_mean)) = 0;
UNIDEN_to_MNI_mean(isnan(UNIDEN_to_MNI_mean)) = 0;
nii.img = UNIDEN_to_MNI_mean;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/group/UNIDEN_to_MNI_mean.nii');

mask_small = mean(mask_to_MNI_all,4);
mask_small(mask_small<1) = 0;

UNIDEN_to_MNI_mean_small = UNIDEN_to_MNI_mean.*mask_small;
nii.img = UNIDEN_to_MNI_mean_small;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/group/UNIDEN_to_MNI_mean_small.nii');






% MATLAB scripts
% T1 mapping
mkdir /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/group

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,1) = single(nii.img);
mask_to_MNI_all(:,:,:,1) = single(single(nii.img)~=0);

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,2) = single(nii.img);
mask_to_MNI_all(:,:,:,2) = single(single(nii.img)~=0);

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,3) = single(nii.img);
mask_to_MNI_all(:,:,:,3) = single(single(nii.img)~=0);

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,4) = single(nii.img);
mask_to_MNI_all(:,:,:,4) = single(single(nii.img)~=0);

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,5) = single(nii.img);
mask_to_MNI_all(:,:,:,5) = single(single(nii.img)~=0);


UNIDEN_to_MNI_mean = sum(UNIDEN_to_MNI_all,4)./sum(mask_to_MNI_all,4);
UNIDEN_to_MNI_mean(isinf(UNIDEN_to_MNI_mean)) = 0;
UNIDEN_to_MNI_mean(isnan(UNIDEN_to_MNI_mean)) = 0;
nii.img = UNIDEN_to_MNI_mean;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/group/UNIDEN_to_MNI_mean.nii');

mask_small = mean(mask_to_MNI_all,4);
mask_small(mask_small<1) = 0;

UNIDEN_to_MNI_mean_small = UNIDEN_to_MNI_mean.*mask_small;
nii.img = UNIDEN_to_MNI_mean_small;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/group/UNIDEN_to_MNI_mean_small.nii');






% MATLAB scripts
% T1 mapping
mkdir /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/group

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/T1map/T1m_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/T1map/T1m_to_MNI.nii');
T1m_to_MNI_all(:,:,:,1) = single(nii.img);
mask_to_MNI_all(:,:,:,1) = single(single(nii.img)~=0);

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/T1map/T1m_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/T1map/T1m_to_MNI.nii');
T1m_to_MNI_all(:,:,:,2) = single(nii.img);
mask_to_MNI_all(:,:,:,2) = single(single(nii.img)~=0);

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/T1map/T1m_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/T1map/T1m_to_MNI.nii');
T1m_to_MNI_all(:,:,:,3) = single(nii.img);
mask_to_MNI_all(:,:,:,3) = single(single(nii.img)~=0);

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/T1map/T1m_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/T1map/T1m_to_MNI.nii');
T1m_to_MNI_all(:,:,:,4) = single(nii.img);
mask_to_MNI_all(:,:,:,4) = single(single(nii.img)~=0);

!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/T1map/T1m_to_MNI.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/T1map/T1m_to_MNI.nii');
T1m_to_MNI_all(:,:,:,5) = single(nii.img);
mask_to_MNI_all(:,:,:,5) = single(single(nii.img)~=0);


T1m_to_MNI_mean = sum(T1m_to_MNI_all,4)./sum(mask_to_MNI_all,4);
T1m_to_MNI_mean(isinf(T1m_to_MNI_mean)) = 0;
T1m_to_MNI_mean(isnan(T1m_to_MNI_mean)) = 0;
nii.img = T1m_to_MNI_mean;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/group/T1m_to_MNI_mean.nii');

mask_small = mean(mask_to_MNI_all,4);
mask_small(mask_small<1) = 0;

T1m_to_MNI_mean_small = T1m_to_MNI_mean.*mask_small;
nii.img = T1m_to_MNI_mean_small;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/group/T1m_to_MNI_mean_small.nii');

