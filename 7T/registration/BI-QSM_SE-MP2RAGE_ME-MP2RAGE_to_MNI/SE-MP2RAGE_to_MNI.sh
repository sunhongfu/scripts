# ants registration from UNIDEN_COMBO to MNI_T1 for SE-MP2RAGE directly
# subject 01EG
t1=/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32.nii
# t1_brain=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/t1_brain.nii.gz
# BET_mask=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/BET_mask_adj.nii 
# mni=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
mni=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm.nii.gz
t1m=/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/T1/T1map_c32.nii
t1m_to_mni=/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/T1/T1map_c32_to_MNI.nii.gz

# # apply BET mask to T1 and T1map_ave
# fslmaths $t1 -mas $BET_mask $t1_brain
# fslmaths $t1m -mas $BET_mask $t1m

## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=$t1
ref=$mni
transformPrefix=/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/UNI-DEN/ants_trans_T1_to_MNI
warpedImage=/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/UNI-DEN/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# register T1 map to MNI templete
antsApplyTransforms -d 3 -i $t1m -r $mni -o $t1m_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 








# ants registration from UNIDEN_COMBO to MNI_T1 for SE-MP2RAGE directly
# subject 02SCOTT
t1=/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32.nii
# t1_brain=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/t1_brain.nii.gz
# BET_mask=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/BET_mask_adj.nii 
# mni=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
mni=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm.nii.gz
t1m=/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/T1/T1map_c32.nii
t1m_to_mni=/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/T1/T1map_c32_to_MNI.nii.gz

# # apply BET mask to T1 and T1map_ave
# fslmaths $t1 -mas $BET_mask $t1_brain
# fslmaths $t1m -mas $BET_mask $t1m

## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=$t1
ref=$mni
transformPrefix=/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/UNI-DEN/ants_trans_T1_to_MNI
warpedImage=/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/UNI-DEN/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# register T1 map to MNI templete
antsApplyTransforms -d 3 -i $t1m -r $mni -o $t1m_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 









# ants registration from UNIDEN_COMBO to MNI_T1 for SE-MP2RAGE directly
# subject 03JK
t1=/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32.nii
# t1_brain=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/t1_brain.nii.gz
# BET_mask=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/BET_mask_adj.nii 
# mni=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
mni=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm.nii.gz
t1m=/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/T1/T1map_c32.nii
t1m_to_mni=/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/T1/T1map_c32_to_MNI.nii.gz

# # apply BET mask to T1 and T1map_ave
# fslmaths $t1 -mas $BET_mask $t1_brain
# fslmaths $t1m -mas $BET_mask $t1m

## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=$t1
ref=$mni
transformPrefix=/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/UNI-DEN/ants_trans_T1_to_MNI
warpedImage=/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/UNI-DEN/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# register T1 map to MNI templete
antsApplyTransforms -d 3 -i $t1m -r $mni -o $t1m_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 










# ants registration from UNIDEN_COMBO to MNI_T1 for SE-MP2RAGE directly
# subject 05SG
t1=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32.nii
# t1_brain=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/t1_brain.nii.gz
# BET_mask=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/BET_mask_adj.nii 
# mni=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
mni=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm.nii.gz
t1m=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/T1/T1map_c32.nii
t1m_to_mni=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/T1/T1map_c32_to_MNI.nii.gz

# # apply BET mask to T1 and T1map_ave
# fslmaths $t1 -mas $BET_mask $t1_brain
# fslmaths $t1m -mas $BET_mask $t1m

## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=$t1
ref=$mni
transformPrefix=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/UNI-DEN/ants_trans_T1_to_MNI
warpedImage=/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/UNI-DEN/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# register T1 map to MNI templete
antsApplyTransforms -d 3 -i $t1m -r $mni -o $t1m_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 












# ants registration from UNIDEN_COMBO to MNI_T1 for SE-MP2RAGE directly
# subject 07JON
t1=/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/UNI-DEN/UNIDEN_c32.nii
# t1_brain=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/t1_brain.nii.gz
# BET_mask=/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/BET_mask_adj.nii 
# mni=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
mni=/usr/local/fsl/5.0.11/fsl/data/standard/MNI152_T1_1mm.nii.gz
t1m=/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/T1/T1map_c32.nii
t1m_to_mni=/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/T1/T1map_c32_to_MNI.nii.gz

# # apply BET mask to T1 and T1map_ave
# fslmaths $t1 -mas $BET_mask $t1_brain
# fslmaths $t1m -mas $BET_mask $t1m

## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=$t1
ref=$mni
transformPrefix=/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/UNI-DEN/ants_trans_T1_to_MNI
warpedImage=/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/UNI-DEN/ants_trans_T1_to_MNI.nii.gz
############################################################################

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# register T1 map to MNI templete
antsApplyTransforms -d 3 -i $t1m -r $mni -o $t1m_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 


