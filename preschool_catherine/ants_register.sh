# BiasField correction
N4BiasFieldCorrection -i /Users/hongfusun/DATA/EPI_REG/PS14_001/dti_b0.nii -o /Users/hongfusun/DATA/EPI_REG/PS14_001/dti_b0_n4.nii
N4BiasFieldCorrection -i /Users/hongfusun/DATA/EPI_REG/PS14_001/mag1_RAS_masked.nii -o /Users/hongfusun/DATA/EPI_REG/PS14_001/mag1_RAS_masked_n4.nii
N4BiasFieldCorrection -i /Users/hongfusun/DATA/EPI_REG/PS14_001/PS14_001_T1w.nii -o /Users/hongfusun/DATA/EPI_REG/PS14_001/PS14_001_T1w.nii_n4.nii

# BET mask the T1
bet2 /Users/hongfusun/DATA/EPI_REG/PS14_001/PS14_001_T1w.nii_n4.nii /Users/hongfusun/DATA/EPI_REG/PS14_001/BET_T1 -f 0.6 -m
bet2 /Users/hongfusun/DATA/EPI_REG/PS14_001/PS14_001_T1w.nii_n4.nii /Users/hongfusun/DATA/EPI_REG/PS14_001/BET_T1 -f 0.85 -m


/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/EPI_REG/PS14_001/mag1_RAS.nii -ref /Users/hongfusun/DATA/EPI_REG/PS14_001/PS14_001_T1w.nii_n4.nii -out /Users/hongfusun/DATA/EPI_REG/PS14_001/mag1_RAS_2T1.nii -omat /Users/hongfusun/DATA/EPI_REG/PS14_001/mag1_RAS_2T1.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear

/usr/local/fsl/bin/flirt -in /Users/hongfusun/DATA/EPI_REG/PS14_001/BET_mask_RAS.nii -applyxfm -init /Users/hongfusun/DATA/EPI_REG/PS14_001/mag1_RAS_2T1.mat -out /Users/hongfusun/DATA/EPI_REG/PS14_001/BET_mask_RAS_2T1.nii -paddingsize 0.0 -interp trilinear -ref /Users/hongfusun/DATA/EPI_REG/PS14_001/PS14_001_T1w.nii_n4.nii

fslmaths /Users/hongfusun/DATA/EPI_REG/PS14_001/BET_mask_RAS_2T1.nii.gz -thr 0.9 -bin /Users/hongfusun/DATA/EPI_REG/PS14_001/BET_mask_RAS_2T1_mask.nii

fslmaths /Users/hongfusun/DATA/EPI_REG/PS14_001/PS14_001_T1w.nii_n4.nii -mul /Users/hongfusun/DATA/EPI_REG/PS14_001/BET_mask_RAS_2T1_mask.nii /Users/hongfusun/DATA/EPI_REG/PS14_001/PS14_001_T1w_n4_brain.nii

fslmaths /Users/hongfusun/DATA/EPI_REG/PS14_001/Ps14_001_mask.nii.gz -thr 0 -bin /Users/hongfusun/DATA/EPI_REG/PS14_001/Ps14_001_mask_thr.nii

fslmaths /Users/hongfusun/DATA/EPI_REG/PS14_001/PS14_001_T1w.nii_n4.nii -mul /Users/hongfusun/DATA/EPI_REG/PS14_001/Ps14_001_mask_thr.nii /Users/hongfusun/DATA/EPI_REG/PS14_001/PS14_001_T1w_n4_brain.nii

# (1) try FAST + EPI_REG(BBR)
epi_reg --epi=dti_fa.nii --t1=PS14_001_T1w_n4.nii --t1brain=PS14_001_T1w_n4_brain.nii --out=fa2t1_erp_reg

# (2) try ANTs
# ants
# 1
# its=10000x1111x5  #fast mode, medium reg quality
its=10000x111110x11110  #slow mode, high reg quality

src=/Users/hongfusun/DATA/EPI_REG/PS14_001/dti_b0_n4.nii

ref=/Users/hongfusun/DATA/EPI_REG/PS14_001/mag1_RAS_masked_n4.nii

transformPrefix=/Users/hongfusun/DATA/EPI_REG/PS14_001/ants_trans_T2

warpedImage=/Users/hongfusun/DATA/EPI_REG/PS14_001/dti_b0_n4_ants_to_T2.nii.gz

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# antsApplyTransforms -d 3 -i $magImage -r $ref -o $magOutImage -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

# antsApplyTransforms -d 3 -i $lfsImage -r $ref -o $lfsOutImage -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat


# 2
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality

# src=/Users/hongfusun/DATA/EPI_REG/PS14_001/dti_b0.nii
src=/Users/hongfusun/DATA/EPI_REG/PS14_001/dti_b0_n4.nii

# ref=/Users/hongfusun/DATA/EPI_REG/PS14_001/mag1_RAS_masked.nii.gz
ref=/Users/hongfusun/DATA/EPI_REG/PS14_001/PS14_001_T1w_n4_brain.nii.gz

transformPrefix=/Users/hongfusun/DATA/EPI_REG/PS14_001/ants_trans_T1

warpedImage=/Users/hongfusun/DATA/EPI_REG/PS14_001/dti_b0_n4_ants_to_T1.nii.gz

# magImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/1/QSM_MEGE_7T/src/mag_corr3_n4.nii

# lfsImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/1/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm.nii

# magOutImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/1/QSM_MEGE_7T/src/mag_corr3_n4_applied_ants.nii

# lfsOutImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/1/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm_ants.nii

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# antsApplyTransforms -d 3 -i $magImage -r $ref -o $magOutImage -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

# antsApplyTransforms -d 3 -i $lfsImage -r $ref -o $lfsOutImage -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat



# 3
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality

ref=/media/data/preschool_examples/ANTs/PS14_001/dti_b0_n4.nii

src=/media/data/preschool_examples/ANTs/PS14_001/mag1_RAS_masked_n4.nii

qsmImage=/media/data/preschool_examples/QSM/QSM_SPGR_GE_halfpi/LBV/chi_iLSQR_peel1_RAS.nii
qsmOutImage=/media/data/preschool_examples/QSM/QSM_SPGR_GE_halfpi/LBV/chi_iLSQR_peel1_RAS_2dti.nii

transformPrefix=/media/data/preschool_examples/ANTs/PS14_001/ants_invtrans_T2

warpedImage=/media/data/preschool_examples/ANTs/PS14_001/T2_n4_ants_to_dtib0.nii.gz

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# antsApplyTransforms -d 3 -i $magImage -r $ref -o $magOutImage -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

antsApplyTransforms -d 3 -i $qsmImage -r $ref -o $qsmOutImage -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat
