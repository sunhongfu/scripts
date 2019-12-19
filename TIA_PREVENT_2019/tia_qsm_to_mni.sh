mni=/usr/local/fsl/data/standard/MNI152_T1_1mm.nii.gz
t1=/Users/uqhsun8/Desktop/001_bl_T1.nii.gz
qsm_mag=/Users/uqhsun8/Desktop/001_mag1.nii
qsm_mag_to_t1=/Users/uqhsun8/Desktop/mag1_to_T1.nii.gz
qsm_mag_to_t1_mat=/Users/uqhsun8/Desktop/mag1_to_T1.mat
qsm_mag_to_t1_to_mni=/Users/uqhsun8/Desktop/mag1_to_T1_to_MNI.nii.gz


/usr/local/fsl/bin/flirt -in $qsm_mag -ref $t1 -out $qsm_mag_to_t1 -omat $qsm_mag_to_t1_mat -bins 256 -cost corratio -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 12  -interp trilinear

# ants registration
## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=$t1
ref=$mni
transformPrefix=/Users/uqhsun8/Desktop/ants_trans_T1_to_MNI
warpedImage=/Users/uqhsun8/Desktop/ants_trans_T1_to_MNI.nii.gz
############################################################################

~/bin/ants/bin/antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# apply to magnitude from QSM sequence
antsApplyTransforms -d 3 -i $qsm_mag_to_t1 -r $mni -o $qsm_mag_to_t1_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

