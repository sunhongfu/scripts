mag=/media/data/LN-QSM_atlas/19/nifti/mag1.nii
t1=/media/data/LN-QSM_atlas/19/nifti/t1.nii
mat_t1_to_mag=/media/data/LN-QSM_atlas/19/nifti/t1_to_mag.mat
t1_to_mag=/media/data/LN-QSM_atlas/19/nifti/t1_to_mag.nii
BET_mask=/media/data/LN-QSM_atlas/19/nifti/mask_brain.nii
t1_brain=/media/data/LN-QSM_atlas/19/nifti/t1_brain.nii.gz
mni_brain=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz


transformPrefix=/media/data/LN-QSM_atlas/19/nifti/ants_trans_T1_to_MNI
warpedImage=/media/data/LN-QSM_atlas/19/nifti/ants_trans_T1_to_MNI.nii.gz

## register T1 to mag
flirt -in $t1 -ref $mag -out $t1_to_mag -omat $mat_t1_to_mag -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear

# apply mag mask to registered T1
fslmaths $t1_to_mag -mas $BET_mask $t1_brain

## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality

src=$t1_brain
ref=$mni_brain

antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]



qsm=/media/data/LN-QSM_atlas/19/nifti/LN_brain.nii
qsm_to_mni=/media/data/LN-QSM_atlas/19/nifti/LN_brain_to_MNI.nii

# register QSM to MNI templete
antsApplyTransforms -d 3 -i $qsm -r $mni_brain -o $qsm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 



qsm=/media/data/LN-QSM_atlas/19/nifti/LN_ero0.nii
qsm_to_mni=/media/data/LN-QSM_atlas/19/nifti/LN_ero0_to_MNI.nii

# register QSM to MNI templete
antsApplyTransforms -d 3 -i $qsm -r $mni_brain -o $qsm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 



qsm=/media/data/LN-QSM_atlas/19/nifti/LN_ero2.nii
qsm_to_mni=/media/data/LN-QSM_atlas/19/nifti/LN_ero2_to_MNI.nii

# register QSM to MNI templete
antsApplyTransforms -d 3 -i $qsm -r $mni_brain -o $qsm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 



#######################################################################################
# create group average maps
mkdir /media/data/LN-QSM_atlas/group

% MATLAB scripts
nii = load_untouch_nii('/media/data/LN-QSM_atlas/11/nifti/LN_ero2_to_MNI.nii');
LN_ero2_to_MNI_all(:,:,:,1) = single(nii.img);
mask_ero2_to_MNI_all(:,:,:,1) = single(single(nii.img)~=0);
nii = load_untouch_nii('/media/data/LN-QSM_atlas/12/nifti/LN_ero2_to_MNI.nii');
LN_ero2_to_MNI_all(:,:,:,2) = single(nii.img);
mask_ero2_to_MNI_all(:,:,:,2) = single(single(nii.img)~=0);
nii = load_untouch_nii('/media/data/LN-QSM_atlas/13/nifti/LN_ero2_to_MNI.nii');
LN_ero2_to_MNI_all(:,:,:,3) = single(nii.img);
mask_ero2_to_MNI_all(:,:,:,3) = single(single(nii.img)~=0);
nii = load_untouch_nii('/media/data/LN-QSM_atlas/14/nifti/LN_ero2_to_MNI.nii');
LN_ero2_to_MNI_all(:,:,:,4) = single(nii.img);
mask_ero2_to_MNI_all(:,:,:,4) = single(single(nii.img)~=0);
nii = load_untouch_nii('/media/data/LN-QSM_atlas/15/nifti/LN_ero2_to_MNI.nii');
LN_ero2_to_MNI_all(:,:,:,5) = single(nii.img);
mask_ero2_to_MNI_all(:,:,:,5) = single(single(nii.img)~=0);
nii = load_untouch_nii('/media/data/LN-QSM_atlas/16/nifti/LN_ero2_to_MNI.nii');
LN_ero2_to_MNI_all(:,:,:,6) = single(nii.img);
mask_ero2_to_MNI_all(:,:,:,6) = single(single(nii.img)~=0);
nii = load_untouch_nii('/media/data/LN-QSM_atlas/17/nifti/LN_ero2_to_MNI.nii');
LN_ero2_to_MNI_all(:,:,:,7) = single(nii.img);
mask_ero2_to_MNI_all(:,:,:,7) = single(single(nii.img)~=0);
nii = load_untouch_nii('/media/data/LN-QSM_atlas/18/nifti/LN_ero2_to_MNI.nii');
LN_ero2_to_MNI_all(:,:,:,8) = single(nii.img);
mask_ero2_to_MNI_all(:,:,:,8) = single(single(nii.img)~=0);
nii = load_untouch_nii('/media/data/LN-QSM_atlas/19/nifti/LN_ero2_to_MNI.nii');
LN_ero2_to_MNI_all(:,:,:,9) = single(nii.img);
mask_ero2_to_MNI_all(:,:,:,9) = single(single(nii.img)~=0);


LN_ero2_to_MNI_mean = sum(LN_ero2_to_MNI_all,4)./sum(mask_ero2_to_MNI_all,4);
LN_ero2_to_MNI_mean(isinf(LN_ero2_to_MNI_mean)) = 0;
LN_ero2_to_MNI_mean(isnan(LN_ero2_to_MNI_mean)) = 0;
nii.img = LN_ero2_to_MNI_mean;
save_untouch_nii(nii,'/media/data/LN-QSM_atlas/group/LN_ero2_to_MNI_mean.nii');

mask_ero2_small = mean(mask_ero2_to_MNI_all,4);
mask_ero2_small(mask_ero2_small<1) = 0;

LN_ero2_to_MNI_mean_small = LN_ero2_to_MNI_mean.*mask_ero2_small;
nii.img = LN_ero2_to_MNI_mean_small;
save_untouch_nii(nii,'/media/data/LN-QSM_atlas/group/LN_ero2_to_MNI_mean_small.nii');






