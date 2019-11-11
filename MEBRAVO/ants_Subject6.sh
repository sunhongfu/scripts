# ANTs does not run in zsh, switch to bash environment
bash

# ants registration
## register ME to MNI (ants)
t1_brain=/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/BET.nii
mni_brain=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
qsm=/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/RESHARP/chi_iLSQR_smvrad3.nii
qsm_to_mni=/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
r2sm=/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/R2.nii
r2sm_to_mni=/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/R2_adj_to_MNI.nii.gz


# reorient the NIFTI to axial
fslswapdim $t1_brain -z x -y /Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/t1_brain_swapped.nii.gz
gunzip /Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/t1_brain_swapped.nii.gz

/Applications/MRIcroGL/dcm2niix /Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/DICOMs_mag_sos

% matlab code
nii_coord_adj('/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/t1_brain_swapped.nii', '/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/DICOMs_mag_sos/DICOMs_mag_sos_NOT_DIAGNOSTIC__desp_20191104173331_1000_e1.nii')


t1_brain=/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/t1_brain_swapped_adj.nii
## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=$t1_brain
ref=$mni_brain
transformPrefix=/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/ants_trans_T1_to_MNI
warpedImage=/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/ants_trans_T1_to_MNI.nii.gz
############################################################################

~/bin/ants/bin/antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]


# register QSM to MNI templete
# reorient the NIFTI to axial
fslswapdim $qsm -z x -y /Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/RESHARP/chi_iLSQR_smvrad3_swapped.nii.gz
gunzip /Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/RESHARP/chi_iLSQR_smvrad3_swapped.nii.gz

% matlab code
nii_coord_adj('/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/RESHARP/chi_iLSQR_smvrad3_swapped.nii', '/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/DICOMs_mag_sos/DICOMs_mag_sos_NOT_DIAGNOSTIC__desp_20191104173331_1000_e1.nii')

qsm=/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/RESHARP/chi_iLSQR_smvrad3_swapped_adj.nii

antsApplyTransforms -d 3 -i $qsm -r $mni_brain -o $qsm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 


# register R2* map to MNI templete
r2sm=/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/R2.nii
fslswapdim $r2sm -z x -y /Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/R2_swapped.nii.gz
gunzip /Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/R2_swapped.nii.gz


% matlab code
nii_coord_adj('/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/R2_swapped.nii', '/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/DICOMs_mag_sos/DICOMs_mag_sos_NOT_DIAGNOSTIC__desp_20191104173331_1000_e1.nii')

r2sm=/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/R2_swapped_adj.nii

antsApplyTransforms -d 3 -i $r2sm -r $mni_brain -o $r2sm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 



############################################################################
############################################################################
############################################################################
############################################################################
############################################################################
# register ME-GRE QSM to MNI space

# (1) FLIRT first
mag_spgr=/Users/uqhsun8/DATA/MEBRAVO/Subject6/Sub5/QSM_SPGR_GE/src/mag1.nii
mag_bravo=/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/src/mag_corr1.nii
spgr2bravo=/Users/uqhsun8/DATA/MEBRAVO/Subject6/Sub5/QSM_SPGR_GE/spgr2bravo

qsm_spgr=/Users/uqhsun8/DATA/MEBRAVO/Subject6/Sub5/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad3.nii
qsm_r2sm=/Users/uqhsun8/DATA/MEBRAVO/Subject6/Sub5/QSM_SPGR_GE/R2.nii

qsm_spgr2bravo=/Users/uqhsun8/DATA/MEBRAVO/Subject6/Sub5/QSM_SPGR_GE/chi_iLSQR_smvrad3_spgr2bravo.nii
r2sm_spgr2bravo=/Users/uqhsun8/DATA/MEBRAVO/Subject6/Sub5/QSM_SPGR_GE/R2_spgr2bravo.nii

/usr/local/fsl/bin/flirt -in $mag_spgr -ref $mag_bravo -out ${spgr2bravo} -omat ${spgr2bravo}.mat -bins 256 -cost mutualinfo -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 12  -interp trilinear

/usr/local/fsl/bin/flirt -in $qsm_spgr -applyxfm -init ${spgr2bravo}.mat -out $qsm_spgr2bravo -paddingsize 0.0 -interp trilinear -ref ${spgr2bravo}.nii.gz
/usr/local/fsl/bin/flirt -in $qsm_r2sm -applyxfm -init ${spgr2bravo}.mat -out $r2sm_spgr2bravo -paddingsize 0.0 -interp trilinear -ref ${spgr2bravo}.nii.gz

gunzip -f ${qsm_spgr2bravo}.gz
gunzip -f ${r2sm_spgr2bravo}.gz


# (2) ANTs second
fslswapdim $qsm_spgr2bravo -z x -y /Users/uqhsun8/DATA/MEBRAVO/Subject6/Sub5/QSM_SPGR_GE/chi_iLSQR_smvrad3_spgr2bravo_swapped.nii.gz
fslswapdim $r2sm_spgr2bravo -z x -y /Users/uqhsun8/DATA/MEBRAVO/Subject6/Sub5/QSM_SPGR_GE/R2_spgr2bravo_swapped.nii.gz
gunzip -f /Users/uqhsun8/DATA/MEBRAVO/Subject6/Sub5/QSM_SPGR_GE/chi_iLSQR_smvrad3_spgr2bravo_swapped.nii.gz
gunzip -f /Users/uqhsun8/DATA/MEBRAVO/Subject6/Sub5/QSM_SPGR_GE/R2_spgr2bravo_swapped.nii.gz

% matlab code
nii_coord_adj('/Users/uqhsun8/DATA/MEBRAVO/Subject6/Sub5/QSM_SPGR_GE/chi_iLSQR_smvrad3_spgr2bravo_swapped.nii', '/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/DICOMs_mag_sos/DICOMs_mag_sos_NOT_DIAGNOSTIC__desp_20191104173331_1000_e1.nii')
nii_coord_adj('/Users/uqhsun8/DATA/MEBRAVO/Subject6/Sub5/QSM_SPGR_GE/R2_spgr2bravo_swapped.nii', '/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/DICOMs_mag_sos/DICOMs_mag_sos_NOT_DIAGNOSTIC__desp_20191104173331_1000_e1.nii')

qsm_spgr2bravo=/Users/uqhsun8/DATA/MEBRAVO/Subject6/Sub5/QSM_SPGR_GE/chi_iLSQR_smvrad3_spgr2bravo_swapped_adj.nii
r2sm_spgr2bravo=/Users/uqhsun8/DATA/MEBRAVO/Subject6/Sub5/QSM_SPGR_GE/R2_spgr2bravo_swapped_adj.nii

qsm_spgr2bravo_to_mni=/Users/uqhsun8/DATA/MEBRAVO/Subject6/Sub5/QSM_SPGR_GE/chi_iLSQR_smvrad3_spgr2bravo_swapped_adj_to_MNI.nii.gz
r2sm_spgr2bravo_to_mni=/Users/uqhsun8/DATA/MEBRAVO/Subject6/Sub5/QSM_SPGR_GE/R2_spgr2bravo_swapped_adj_to_MNI.nii.gz

antsApplyTransforms -d 3 -i $qsm_spgr2bravo -r $mni_brain -o $qsm_spgr2bravo_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
antsApplyTransforms -d 3 -i $r2sm_spgr2bravo -r $mni_brain -o $r2sm_spgr2bravo_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 




############################################################################
############################################################################
############################################################################
############################################################################
############################################################################
# register SE-BRAVO to MNI space
/Applications/MRIcroGL/dcm2niix /Users/uqhsun8/DATA/MEBRAVO/Subject6/Sub5/SAG_FSPGR_BRAVO_0


# reorient the NIFTI to axial of the mask from ME-BRAVO
fslswapdim /Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/BET_mask.nii -z x -y /Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/BET_mask_swapped.nii.gz
gunzip /Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/BET_mask_swapped.nii.gz

nii_coord_adj('/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/BET_mask_swapped.nii', '/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/DICOMs_mag_sos/DICOMs_mag_sos_NOT_DIAGNOSTIC__desp_20191104173331_1000_e1.nii')

se_bravo=/Users/uqhsun8/DATA/MEBRAVO/Subject6/Sub5/SAG_FSPGR_BRAVO_0/SAG_FSPGR_BRAVO_0_SAG_FSPGR_BRAVO_20191104173331_2.nii
me_bravo=/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/DICOMs_mag_sos/DICOMs_mag_sos_NOT_DIAGNOSTIC__desp_20191104173331_1000_e1.nii
se2me=/Users/uqhsun8/DATA/MEBRAVO/Subject6/Sub5/SAG_FSPGR_BRAVO_0/se2me
se2me_to_mni=/Users/uqhsun8/DATA/MEBRAVO/Subject6/Sub5/SAG_FSPGR_BRAVO_0/se2me_to_mni.nii.gz
se2me_brain=/Users/uqhsun8/DATA/MEBRAVO/Subject6/Sub5/SAG_FSPGR_BRAVO_0/se2me_brain.nii.gz
me_mask=/Users/uqhsun8/DATA/MEBRAVO/Subject6/recon_uncombined/QSM_BRAVO_UNCOMBINED/BET_mask_swapped_adj.nii

/usr/local/fsl/bin/flirt -in $se_bravo -ref $me_bravo -out ${se2me} -omat ${se2me}.mat -bins 256 -cost corratio -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 12  -interp trilinear

fslmaths ${se2me}.nii.gz -mul $me_mask $se2me_brain

antsApplyTransforms -d 3 -i ${se2me_brain} -r $mni_brain -o $se2me_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 

