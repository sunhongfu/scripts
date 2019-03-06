# ants registration from UNIDEN_COMBO to MNI_T1
# subject 01EG
t1=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii
t1_brain=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/t1_brain.nii.gz
BET_mask=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/BET_mask_adj.nii 
mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
qsm=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii
qsm_to_mni=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
r2sm=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj.nii
r2sm_to_mni=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_to_MNI.nii.gz
t1m=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/T1map/T1map_ave.nii
t1m_brain=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/T1map/T1map_ave_brain.nii.gz
t1m_to_mni=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/T1map/T1m_to_MNI.nii.gz
#
t1m1=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/T1map/T1map_c32_e1_padded.nii
t1m1_brain=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/T1map/T1map_e1_brain.nii.gz
t1m1_to_mni=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/T1map/T1m_e1_to_MNI.nii.gz
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
transformPrefix=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI
warpedImage=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
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

cd /scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/T1map
gunzip -f *.nii.gz
















































# subject 02SCOTT
t1=/home/hongfu/cj97/hongfu/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii
t1_brain=/home/hongfu/cj97/hongfu/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/t1_brain.nii.gz
BET_mask=/home/hongfu/cj97/hongfu/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/BET_mask_adj.nii 
mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
qsm=/home/hongfu/cj97/hongfu/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii
qsm_to_mni=/home/hongfu/cj97/hongfu/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
r2sm=/home/hongfu/cj97/hongfu/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj.nii
r2sm_to_mni=/home/hongfu/cj97/hongfu/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_to_MNI.nii.gz
t1m=/home/hongfu/cj97/hongfu/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/T1map/T1map_ave.nii
t1m_brain=/home/hongfu/cj97/hongfu/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/T1map/T1map_ave_brain.nii.gz
t1m_to_mni=/home/hongfu/cj97/hongfu/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/T1map/T1m_to_MNI.nii.gz
#
t1m1=/home/hongfu/cj97/hongfu/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/T1map/T1map_c32_e1_padded.nii
t1m1_brain=/home/hongfu/cj97/hongfu/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/T1map/T1map_e1_brain.nii.gz
t1m1_to_mni=/home/hongfu/cj97/hongfu/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/T1map/T1m_e1_to_MNI.nii.gz
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
transformPrefix=/home/hongfu/cj97/hongfu/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI
warpedImage=/home/hongfu/cj97/hongfu/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
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

cd /home/hongfu/cj97/hongfu/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/T1map
gunzip -f *.nii.gz















































# subject 03JK
t1=/home/hongfu/cj97/hongfu/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii
t1_brain=/home/hongfu/cj97/hongfu/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/t1_brain.nii.gz
BET_mask=/home/hongfu/cj97/hongfu/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/BET_mask_adj.nii 
mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
qsm=/home/hongfu/cj97/hongfu/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii
qsm_to_mni=/home/hongfu/cj97/hongfu/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
r2sm=/home/hongfu/cj97/hongfu/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj.nii
r2sm_to_mni=/home/hongfu/cj97/hongfu/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_to_MNI.nii.gz
t1m=/home/hongfu/cj97/hongfu/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/T1map/T1map_ave.nii
t1m_brain=/home/hongfu/cj97/hongfu/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/T1map/T1map_ave_brain.nii.gz
t1m_to_mni=/home/hongfu/cj97/hongfu/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/T1map/T1m_to_MNI.nii.gz
#
t1m1=/home/hongfu/cj97/hongfu/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/T1map/T1map_c32_e1_padded.nii
t1m1_brain=/home/hongfu/cj97/hongfu/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/T1map/T1map_e1_brain.nii.gz
t1m1_to_mni=/home/hongfu/cj97/hongfu/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/T1map/T1m_e1_to_MNI.nii.gz
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
transformPrefix=/home/hongfu/cj97/hongfu/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI
warpedImage=/home/hongfu/cj97/hongfu/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
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

cd /home/hongfu/cj97/hongfu/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/T1map
gunzip -f *.nii.gz













# subject 05SG
t1=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii
t1_brain=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/t1_brain.nii.gz
BET_mask=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/BET_mask_adj.nii 
mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
qsm=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii
qsm_to_mni=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
r2sm=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj.nii
r2sm_to_mni=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_to_MNI.nii.gz
t1m=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/T1map/T1map_ave.nii
t1m_brain=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/T1map/T1map_ave_brain.nii.gz
t1m_to_mni=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/T1map/T1m_to_MNI.nii.gz
#
t1m1=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/T1map/T1map_c32_e1_padded.nii
t1m1_brain=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/T1map/T1map_e1_brain.nii.gz
t1m1_to_mni=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/T1map/T1m_e1_to_MNI.nii.gz
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
transformPrefix=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI
warpedImage=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
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

cd /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/T1map
gunzip -f *.nii.gz












































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
t1=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_H451/UNIDEN_comboecho/20171004_135402mp2rage0p75BiPlos4TEVariedBWs011a4001.nii
t1_brain=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_H451/UNIDEN_comboecho/t1_brain.nii.gz
BET_mask=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_H451/QSM_MEMP2RAGE_7T/BET_mask_adj.nii 
mni_brain=/usr/local/fsl/5.0.9/data/standard/MNI152_T1_1mm_brain.nii.gz
qsm=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_H451/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii
qsm_to_mni=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_H451/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
r2sm=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_H451/QSM_MEMP2RAGE_7T/R2_I2_adj.nii
r2sm_to_mni=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_H451/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii.gz
t1m=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_H451/T1map/t1_ave.nii
t1m_to_mni=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_H451/T1map/T1m_to_MNI.nii.gz

# apply BET mask to T1
fslmaths $t1 -mas $BET_mask $t1_brain


## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=$t1_brain
ref=$mni_brain
transformPrefix=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_H451/UNIDEN_comboecho/ants_trans_T1_to_MNI
warpedImage=/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_H451/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# register QSM to MNI templete
antsApplyTransforms -d 3 -i $qsm -r $mni_brain -o $qsm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

# register R2* map to MNI templete
antsApplyTransforms -d 3 -i $r2sm -r $mni_brain -o $r2sm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

# register T1 map to MNI templete
antsApplyTransforms -d 3 -i $t1m -r $mni_brain -o $t1m_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 












# ants registration from UNIDEN_COMBO to MNI_T1
t1=/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/UNIDEN_comboecho/20171031_141844mp2rage0p75BiPlos4TEVariedBWtx220s015a4001.nii
t1_brain=/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/UNIDEN_comboecho/t1_brain.nii.gz
BET_mask=/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/BET_mask_adj.nii 
mni_brain=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
qsm=/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj.nii
qsm_to_mni=/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
r2sm=/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/R2_I2_adj.nii
r2sm_to_mni=/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii.gz
t1m=/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/T1map/t1_ave.nii
t1m_to_mni=/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/T1map/T1m_to_MNI.nii.gz
#
t1m1_brain=/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/T1map/t1_te1.nii
t1m1_to_mni=/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/T1map/T1m_e1_to_MNI.nii.gz
#

# apply BET mask to T1
fslmaths $t1 -mas $BET_mask $t1_brain


## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=$t1_brain
ref=$mni_brain
transformPrefix=/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/UNIDEN_comboecho/ants_trans_T1_to_MNI
warpedImage=/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# register QSM to MNI templete
antsApplyTransforms -d 3 -i $qsm -r $mni_brain -o $qsm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

# register R2* map to MNI templete
antsApplyTransforms -d 3 -i $r2sm -r $mni_brain -o $r2sm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

# register T1 map to MNI templete
antsApplyTransforms -d 3 -i $t1m -r $mni_brain -o $t1m_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

#
antsApplyTransforms -d 3 -i $t1m1_brain -r $mni_brain -o $t1m1_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
#

cd /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/T1map
gunzip -f *.nii.gz



