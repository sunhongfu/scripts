% ME-BRAVO script

% (1) generate DICOMs from p-files
pfilePath = 'p-files/P38912.7';
calibrationPfile = 'p-files/P37888.7';
kacq_file = 'kacq_yz.txt.1024150629';
outputDir = 'recon';

recon_arc_asset2(pfilePath, calibrationPfile, kacq_file, outputDir);
% recon_arc_asset2(pfilePath, calibrationPfile, [], outputDir);

% (2) generate QSM
realDicomsDir = [outputDir '/DICOMs_real'];
imagDicomsDir = [outputDir '/DICOMs_imag'];
path_out = outputDir;

qsm_bravo(realDicomsDir, imagDicomsDir, path_out);

% (3) generate R2* map
% MATLAB script for computing R2* map from multi-echo BRAVO sequence
load('all.mat','mag','TE','mask','imsize','vox');
[R2, T2, amp] = r2imgfit2(double(mag),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');

% (4) perform SWI
cd /Users/hongfusun/DATA/MEBRAVO/HONGFU2/recon_kacq/QSM_BRAVO/src
# generate mnc files from nii
rm ../*.mnc
nii2mnc ../BET_mask.nii
rm *.mnc
nii2mnc mag1.nii
nii2mnc mag2.nii
nii2mnc mag3.nii
nii2mnc mag4.nii
nii2mnc ph_corr1.nii
nii2mnc ph_corr2.nii
nii2mnc ph_corr3.nii
nii2mnc ph_corr4.nii

% in matlab
cd /Users/hongfusun/DATA/MEBRAVO/HONGFU2/recon_kacq/QSM_BRAVO/src
do_unwrap_swi('mag1.mnc', 'ph_corr1.mnc', 'swi_unwrap_echo_1_of_4.mnc', 'phase_unwrap_echo_1_of_4.mnc', '../BET_mask.mnc', 0.2, 1, 4, 1);
do_unwrap_swi('mag2.mnc', 'ph_corr2.mnc', 'swi_unwrap_echo_2_of_4.mnc', 'phase_unwrap_echo_2_of_4.mnc', '../BET_mask.mnc', 0.25, 1, 4, 1);
do_unwrap_swi('mag3.mnc', 'ph_corr3.mnc', 'swi_unwrap_echo_3_of_4.mnc', 'phase_unwrap_echo_3_of_4.mnc', '../BET_mask.mnc', 0.3, 1, 4, 1);
do_unwrap_swi('mag4.mnc', 'ph_corr4.mnc', 'swi_unwrap_echo_4_of_4.mnc', 'phase_unwrap_echo_4_of_4.mnc', '../BET_mask.mnc', 0.35, 1, 4, 1);
unix('./multi_echo_swi_unwrapped.pl mag ph_corr ../BET_mask.mnc 4 combined_unwrap_swi.mnc');

cd /Users/hongfusun/DATA/MEBRAVO/HONGFU2/recon_kacq/QSM_BRAVO/src
mkdir p1
mv *.mnc p1
# convert mnc results to nii
cd /Users/hongfusun/DATA/MEBRAVO/HONGFU2/recon_kacq/QSM_BRAVO/src/p1
for minc_file in *.mnc
do
	mnc2nii $minc_file
done


% ants registration

## register ME to MNI (ants)
t1=/Users/hongfusun/DATA/MEBRAVO/HONGFU2/recon_kacq/QSM_BRAVO/iMag.nii
t1_brain=/Users/hongfusun/DATA/MEBRAVO/HONGFU2/recon_kacq/QSM_BRAVO/t1_brain.nii.gz
BET_mask=/Users/hongfusun/DATA/MEBRAVO/HONGFU2/recon_kacq/QSM_BRAVO/BET_mask.nii
mni_brain=/usr/local/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz
qsm=/Users/hongfusun/DATA/MEBRAVO/HONGFU2/recon_kacq/QSM_BRAVO/RESHARP/chi_iLSQR_smvrad3.nii
qsm_to_mni=/Users/hongfusun/DATA/MEBRAVO/HONGFU2/recon_kacq/QSM_BRAVO/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
r2sm=/Users/hongfusun/DATA/MEBRAVO/HONGFU2/recon_kacq/QSM_BRAVO/R2.nii
r2sm_to_mni=/Users/hongfusun/DATA/MEBRAVO/HONGFU2/recon_kacq/QSM_BRAVO/R2_adj_to_MNI.nii.gz


# apply BET mask to T1 and T1map_ave
fslmaths $t1 -mas $BET_mask $t1_brain

# reorient the NIFTI to axial
fslswapdim $t1_brain -z x -y /Users/hongfusun/DATA/MEBRAVO/HONGFU2/recon_kacq/QSM_BRAVO/t1_brain_swapped.nii.gz
t1_brain=/Users/hongfusun/DATA/MEBRAVO/HONGFU2/recon_kacq/QSM_BRAVO/t1_brain_swapped.nii.gz
gunzip /Users/hongfusun/DATA/MEBRAVO/HONGFU2/recon_kacq/QSM_BRAVO/t1_brain_swapped.nii.gz

% matlab code
nii_coord_adj('/Users/hongfusun/DATA/MEBRAVO/HONGFU2/recon_kacq/QSM_BRAVO/t1_brain_swapped.nii', '/Users/hongfusun/DATA/MEBRAVO/HONGFU2/recon_kacq/DICOMs_mag/DICOMs_mag_NOT_DIAGNOSTIC__desp_20191024145551_1000_e1.nii')

#
#
t1_brain=/Users/hongfusun/DATA/MEBRAVO/HONGFU2/recon_kacq/QSM_BRAVO/t1_brain_swapped_adj.nii
## register T1 to MNI-atlas
# (1) try on 1 mm MNI template
its=10000x1111x5  #fast mode, medium reg quality
# its=10000x111110x11110  #slow mode, high reg quality
############################################################################
src=$t1_brain
ref=$mni_brain
transformPrefix=/Users/hongfusun/DATA/MEBRAVO/HONGFU2/recon_kacq/QSM_BRAVO/ants_trans_T1_to_MNI
warpedImage=/Users/hongfusun/DATA/MEBRAVO/HONGFU2/recon_kacq/QSM_BRAVO/ants_trans_T1_to_MNI.nii.gz
############################################################################

/Users/hongfusun/bin/ants/bin/antsRegistration -d 3 -r [ $ref , $src  ,1] -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t translation[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 6x4x2 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t rigid[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 1 , 32, regular, 0.25 ] -t affine[ 0.1 ] -c [$its, 1.e-8, 20] -s 4x2x1vox -f 3x2x1 -l 1 -m mattes[ $ref , $src , 0.5 , 32 ] -m cc[ $ref , $src , 0.5 , 4 ] -t SyN[ .20, 3, 0 ] -c [ 100x100x50, -0.01, 5 ] -s 1x0.5x0vox -f 4x2x1 -l 1 -u 1 -z 1 -o [$transformPrefix, $warpedImage]

# register QSM to MNI templete
antsApplyTransforms -d 3 -i $qsm -r $mni_brain -o $qsm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 
# register R2* map to MNI templete
antsApplyTransforms -d 3 -i $r2sm -r $mni_brain -o $r2sm_to_mni -n Linear -t ${transformPrefix}1Warp.nii.gz -t ${transformPrefix}0GenericAffine.mat 



%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%
% new subject
cd /Users/hongfusun/DATA/MEBRAVO/HONGFU_PRODUCTION_1/Subject1
% (1) generate DICOMs from p-files
pfilePath = 'p-files/P02560.7';
calibrationPfile = 'p-files/P02048.7';
% kacq_file = 'kacq_yz.txt.1024150629';
outputDir = 'recon';

% recon_arc_asset2(pfilePath, calibrationPfile, kacq_file, outputDir);
recon_arc_asset2(pfilePath, calibrationPfile, [], outputDir);

% (2) generate QSM
realDicomsDir = [outputDir '/DICOMs_real'];
imagDicomsDir = [outputDir '/DICOMs_imag'];
path_out = outputDir;

qsm_bravo(realDicomsDir, imagDicomsDir, path_out);

% (3) generate R2* map
% MATLAB script for computing R2* map from multi-echo BRAVO sequence
load('all.mat','mag','TE','mask','imsize','vox');
[R2, T2, amp] = r2imgfit2(double(mag),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');





%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%
% new subject
cd /Users/hongfusun/DATA/MEBRAVO/HONGFU_PRODUCTION_1/Subject2
% (1) generate DICOMs from p-files
pfilePath = 'p-files/P54272.7';
calibrationPfile = 'p-files/P53248.7';
% kacq_file = 'kacq_yz.txt.1024150629';
outputDir = 'recon';

% recon_arc_asset2(pfilePath, calibrationPfile, kacq_file, outputDir);
recon_arc_asset2(pfilePath, calibrationPfile, [], outputDir);

% (2) generate QSM
realDicomsDir = [outputDir '/DICOMs_real'];
imagDicomsDir = [outputDir '/DICOMs_imag'];
path_out = outputDir;

qsm_bravo(realDicomsDir, imagDicomsDir, path_out);

% (3) generate R2* map
% MATLAB script for computing R2* map from multi-echo BRAVO sequence
load('all.mat','mag','TE','mask','imsize','vox');
[R2, T2, amp] = r2imgfit2(double(mag),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');
