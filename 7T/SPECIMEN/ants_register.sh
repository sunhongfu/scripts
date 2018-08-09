# ants
# 1
# its=10000x1111x5  #fast mode, medium reg quality
its=10000x111110x11110  #slow mode, high reg quality

src=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/1/QSM_MEGE_7T/src/mag_corr3_n4.nii

ref=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/6/QSM_MEGE_7T/src/mag_corr3_n4.nii

transformPrefix=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/1/QSM_MEGE_7T/src/mag_corr3_n4_ants_trans

warpedImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/1/QSM_MEGE_7T/src/mag_corr3_n4_ants.nii.gz

magImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/1/QSM_MEGE_7T/src/mag_corr3_n4.nii

lfsImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/1/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm.nii

magOutImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/1/QSM_MEGE_7T/src/mag_corr3_n4_applied_ants.nii

lfsOutImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/1/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm_ants.nii

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

antsApplyTransforms -d 3 -i $magImage -r $ref -o $magOutImage -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

antsApplyTransforms -d 3 -i $lfsImage -r $ref -o $lfsOutImage -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat


# 2
# its=10000x1111x5  #fast mode, medium reg quality
its=10000x111110x11110  #slow mode, high reg quality

src=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/2/QSM_MEGE_7T/src/mag_corr3_n4.nii

ref=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/6/QSM_MEGE_7T/src/mag_corr3_n4.nii

transformPrefix=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/2/QSM_MEGE_7T/src/mag_corr3_n4_ants_trans

warpedImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/2/QSM_MEGE_7T/src/mag_corr3_n4_ants.nii.gz

magImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/2/QSM_MEGE_7T/src/mag_corr3_n4.nii

lfsImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/2/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm.nii

magOutImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/2/QSM_MEGE_7T/src/mag_corr3_n4_applied_ants.nii

lfsOutImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/2/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm_ants.nii

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

antsApplyTransforms -d 3 -i $magImage -r $ref -o $magOutImage -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

antsApplyTransforms -d 3 -i $lfsImage -r $ref -o $lfsOutImage -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat



# 3
# its=10000x1111x5  #fast mode, medium reg quality
its=10000x111110x11110  #slow mode, high reg quality

src=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/3/QSM_MEGE_7T/src/mag_corr3_n4.nii

ref=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/6/QSM_MEGE_7T/src/mag_corr3_n4.nii

transformPrefix=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/3/QSM_MEGE_7T/src/mag_corr3_n4_ants_trans

warpedImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/3/QSM_MEGE_7T/src/mag_corr3_n4_ants.nii.gz

magImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/3/QSM_MEGE_7T/src/mag_corr3_n4.nii

lfsImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/3/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm.nii

magOutImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/3/QSM_MEGE_7T/src/mag_corr3_n4_applied_ants.nii

lfsOutImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/3/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm_ants.nii

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

antsApplyTransforms -d 3 -i $magImage -r $ref -o $magOutImage -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

antsApplyTransforms -d 3 -i $lfsImage -r $ref -o $lfsOutImage -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat



# 4
# its=10000x1111x5  #fast mode, medium reg quality
its=10000x111110x11110  #slow mode, high reg quality

src=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/4/QSM_MEGE_7T/src/mag_corr3_n4.nii

ref=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/6/QSM_MEGE_7T/src/mag_corr3_n4.nii

transformPrefix=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/4/QSM_MEGE_7T/src/mag_corr3_n4_ants_trans

warpedImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/4/QSM_MEGE_7T/src/mag_corr3_n4_ants.nii.gz

magImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/4/QSM_MEGE_7T/src/mag_corr3_n4.nii

lfsImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/4/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm.nii

magOutImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/4/QSM_MEGE_7T/src/mag_corr3_n4_applied_ants.nii

lfsOutImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/4/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm_ants.nii

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

antsApplyTransforms -d 3 -i $magImage -r $ref -o $magOutImage -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

antsApplyTransforms -d 3 -i $lfsImage -r $ref -o $lfsOutImage -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat



# 5
# its=10000x1111x5  #fast mode, medium reg quality
its=10000x111110x11110  #slow mode, high reg quality

src=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/5/QSM_MEGE_7T/src/mag_corr3_n4.nii

ref=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/6/QSM_MEGE_7T/src/mag_corr3_n4.nii

transformPrefix=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/5/QSM_MEGE_7T/src/mag_corr3_n4_ants_trans

warpedImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/5/QSM_MEGE_7T/src/mag_corr3_n4_ants.nii.gz

magImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/5/QSM_MEGE_7T/src/mag_corr3_n4.nii

lfsImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/5/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm.nii

magOutImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/5/QSM_MEGE_7T/src/mag_corr3_n4_applied_ants.nii

lfsOutImage=/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/5/QSM_MEGE_7T/fudge/RESHARP/lfs_resharp_0_smvrad3_lsqr_nm_ants.nii

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

antsApplyTransforms -d 3 -i $magImage -r $ref -o $magOutImage -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

antsApplyTransforms -d 3 -i $lfsImage -r $ref -o $lfsOutImage -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat
