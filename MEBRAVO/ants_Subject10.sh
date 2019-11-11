# ANTs does not run in zsh, switch to bash environment
bash

# ants registration
## register ME to MNI (ants)
t1_brain=/Users/uqhsun8/DATA/MEBRAVO/Subject10/recon_uncombined/QSM_BRAVO_UNCOMBINED/BET.nii
mni_brain=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
qsm=/Users/uqhsun8/DATA/MEBRAVO/Subject10/recon_uncombined/QSM_BRAVO_UNCOMBINED/RESHARP/chi_iLSQR_smvrad3.nii
qsm_to_mni=/Users/uqhsun8/DATA/MEBRAVO/Subject10/recon_uncombined/QSM_BRAVO_UNCOMBINED/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
r2sm=/Users/uqhsun8/DATA/MEBRAVO/Subject10/recon_uncombined/QSM_BRAVO_UNCOMBINED/R2.nii
r2sm_to_mni=/Users/uqhsun8/DATA/MEBRAVO/Subject10/recon_uncombined/QSM_BRAVO_UNCOMBINED/R2_adj_to_MNI.nii.gz


/Applications/MRIcroGL/dcm2niix /Users/uqhsun8/DATA/MEBRAVO/Subject10/recon_uncombined/DICOMs_mag_sos

% matlab code
nii_coord_adj('/Users/uqhsun8/DATA/MEBRAVO/Subject10/recon_uncombined/QSM_BRAVO_UNCOMBINED/BET.nii', '/Users/uqhsun8/DATA/MEBRAVO/Subject10/recon_uncombined/DICOMs_mag_sos/DICOMs_mag_sos_NOT_DIAGNOSTIC__desp_20191104162517_1000_e1.nii')


t1_brain=/Users/uqhsun8/DATA/MEBRAVO/Subject10/recon_uncombined/QSM_BRAVO_UNCOMBINED/BET_adj.nii
## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=$t1_brain
ref=$mni_brain
transformPrefix=/Users/uqhsun8/DATA/MEBRAVO/Subject10/recon_uncombined/QSM_BRAVO_UNCOMBINED/ants_trans_T1_to_MNI
warpedImage=/Users/uqhsun8/DATA/MEBRAVO/Subject10/recon_uncombined/QSM_BRAVO_UNCOMBINED/ants_trans_T1_to_MNI.nii.gz
############################################################################

~/bin/ants/bin/antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]


# register QSM to MNI templete

% matlab code
nii_coord_adj('/Users/uqhsun8/DATA/MEBRAVO/Subject10/recon_uncombined/QSM_BRAVO_UNCOMBINED/RESHARP/chi_iLSQR_smvrad3.nii', '/Users/uqhsun8/DATA/MEBRAVO/Subject10/recon_uncombined/DICOMs_mag_sos/DICOMs_mag_sos_NOT_DIAGNOSTIC__desp_20191104162517_1000_e1.nii')

qsm=/Users/uqhsun8/DATA/MEBRAVO/Subject10/recon_uncombined/QSM_BRAVO_UNCOMBINED/RESHARP/chi_iLSQR_smvrad3_adj.nii

antsApplyTransforms -d 3 -i $qsm -r $mni_brain -o $qsm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 


# register R2* map to MNI templete
r2sm=/Users/uqhsun8/DATA/MEBRAVO/Subject10/recon_uncombined/QSM_BRAVO_UNCOMBINED/R2.nii


% matlab code
nii_coord_adj('/Users/uqhsun8/DATA/MEBRAVO/Subject10/recon_uncombined/QSM_BRAVO_UNCOMBINED/R2.nii', '/Users/uqhsun8/DATA/MEBRAVO/Subject10/recon_uncombined/DICOMs_mag_sos/DICOMs_mag_sos_NOT_DIAGNOSTIC__desp_20191104162517_1000_e1.nii')

r2sm=/Users/uqhsun8/DATA/MEBRAVO/Subject10/recon_uncombined/QSM_BRAVO_UNCOMBINED/R2_adj.nii

antsApplyTransforms -d 3 -i $r2sm -r $mni_brain -o $r2sm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
