load('/Volumes/LaCie/COSMOS_7T/01EG/extension/QSM_MEGE_7T/all_new.mat','dicom_info','imsize','vox');

imsize = imsize(1:3);

X = dicom_info.ImageOrientationPatient(1:3);
Y = dicom_info.ImageOrientationPatient(4:6);
Z = cross(X,Y);

% rotation matrix
% rot_mat = inv([X,Y,Z]);
rot_mat = ([X,Y,Z]);
rot_mat(1,3) = -rot_mat(1,3); % match DICOM with FSL
rot_mat(3,1) = -rot_mat(3,1); % match DICOM corrodinate to FSL

% translation in millimeter
tra_mat = (imsize'/2-rot_mat*imsize'/2).*vox';

% cat the matrices
xfm_mat = [rot_mat,tra_mat;[0 0 0 1]];

% save as ascii
save('xfm.mat','xfm_mat','-ascii');



% run Flirt apply transform

!/usr/local/fsl/bin/flirt -in /Volumes/LaCie/COSMOS_7T/01EG/extension/QSM_MEGE_7T/RESHARP/lfs_resharp_0_smvrad1_cgs_1e-06.nii -applyxfm -init xfm.mat -out test_rot_lfs.nii -paddingsize 0 -interp trilinear -ref /Volumes/LaCie/COSMOS_7T/01EG/extension/QSM_MEGE_7T/RESHARP/lfs_resharp_0_smvrad1_cgs_1e-06.nii






% recon resliced qsm
!gunzip -f test_rot_lfs.nii.gz
nii = load_nii('test_rot_lfs.nii');
lfs_rot = double(nii.img);
mask_rot = (lfs_rot ~= 0);

% run iLSQR
chi_iLSQR_0 = QSM_iLSQR(lfs_rot*(2.675e8*dicom_info.MagneticFieldStrength)/1e6,double(mask_rot),'H',[0 0 1],'voxelsize',vox,'niter',50,'TE',1000,'B0',dicom_info.MagneticFieldStrength);
nii = make_nii(chi_iLSQR_0,vox);
save_nii(nii,'chi_iLSQR_smvrad1.nii');




% inverse trans
/usr/local/fsl/bin/convert_xfm -omat xfm_inv.mat -inverse xfm.mat


% register to neutral
/usr/local/fsl/bin/flirt -in /Users/uqhsun8/Dropbox/anisotropy/left/chi_iLSQR_smvrad1.nii -ref /Users/uqhsun8/Dropbox/anisotropy/neutral/chi_iLSQR_smvrad1.nii -out /Users/uqhsun8/Dropbox/anisotropy/left/chi_iLSQR_smvrad1_to_neutral.nii -omat /Users/uqhsun8/Dropbox/anisotropy/left/chi_iLSQR_smvrad1_to_neutral.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear

/usr/local/fsl/bin/flirt -in /Users/uqhsun8/Dropbox/anisotropy/right/chi_iLSQR_smvrad1.nii -ref /Users/uqhsun8/Dropbox/anisotropy/neutral/chi_iLSQR_smvrad1.nii -out /Users/uqhsun8/Dropbox/anisotropy/right/chi_iLSQR_smvrad1_to_neutral.nii -omat /Users/uqhsun8/Dropbox/anisotropy/right/chi_iLSQR_smvrad1_to_neutral.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear

/usr/local/fsl/bin/flirt -in /Users/uqhsun8/Dropbox/anisotropy/flexion/chi_iLSQR_smvrad1.nii -ref /Users/uqhsun8/Dropbox/anisotropy/neutral/chi_iLSQR_smvrad1.nii -out /Users/uqhsun8/Dropbox/anisotropy/flexion/chi_iLSQR_smvrad1_to_neutral.nii -omat /Users/uqhsun8/Dropbox/anisotropy/flexion/chi_iLSQR_smvrad1_to_neutral.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear

/usr/local/fsl/bin/flirt -in /Users/uqhsun8/Dropbox/anisotropy/extension/chi_iLSQR_smvrad1.nii -ref /Users/uqhsun8/Dropbox/anisotropy/neutral/chi_iLSQR_smvrad1.nii -out /Users/uqhsun8/Dropbox/anisotropy/extension/chi_iLSQR_smvrad1_to_neutral.nii -omat /Users/uqhsun8/Dropbox/anisotropy/extension/chi_iLSQR_smvrad1_to_neutral.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear


% apply deep learning QSM results to neutral orientation
cd /Users/uqhsun8/Dropbox/anisotropy/extension
/usr/local/fsl/bin/flirt -in DeepQSM_extension_new.nii -applyxfm -init chi_iLSQR_smvrad1_to_neutral.mat -out DeepQSM_extension_new_to_neutral.nii -paddingsize 0.0 -interp trilinear -ref DeepQSM_extension_new.nii

cd /Users/uqhsun8/Dropbox/anisotropy/flexion
/usr/local/fsl/bin/flirt -in DeepQSM_flexion_new.nii -applyxfm -init chi_iLSQR_smvrad1_to_neutral.mat -out DeepQSM_flexion_new_to_neutral.nii -paddingsize 0.0 -interp trilinear -ref DeepQSM_flexion_new.nii

cd /Users/uqhsun8/Dropbox/anisotropy/left
/usr/local/fsl/bin/flirt -in DeepQSM_left_new.nii -applyxfm -init chi_iLSQR_smvrad1_to_neutral.mat -out DeepQSM_left_new_to_neutral.nii -paddingsize 0.0 -interp trilinear -ref DeepQSM_left_new.nii

cd /Users/uqhsun8/Dropbox/anisotropy/right
/usr/local/fsl/bin/flirt -in DeepQSM_right_new.nii -applyxfm -init chi_iLSQR_smvrad1_to_neutral.mat -out DeepQSM_right_new_to_neutral.nii -paddingsize 0.0 -interp trilinear -ref DeepQSM_right_new.nii


% qsmnet+
cd /Users/uqhsun8/Dropbox/anisotropy/extension
/usr/local/fsl/bin/flirt -in qsmnet+_extension_new.nii -applyxfm -init chi_iLSQR_smvrad1_to_neutral.mat -out qsmnet+_extension_new_to_neutral.nii -paddingsize 0.0 -interp trilinear -ref qsmnet+_extension_new.nii

cd /Users/uqhsun8/Dropbox/anisotropy/flexion
/usr/local/fsl/bin/flirt -in qsmnet+_flexion_new.nii -applyxfm -init chi_iLSQR_smvrad1_to_neutral.mat -out qsmnet+_flexion_new_to_neutral.nii -paddingsize 0.0 -interp trilinear -ref qsmnet+_flexion_new.nii

cd /Users/uqhsun8/Dropbox/anisotropy/left
/usr/local/fsl/bin/flirt -in qsmnet+_left_new.nii -applyxfm -init chi_iLSQR_smvrad1_to_neutral.mat -out qsmnet+_left_new_to_neutral.nii -paddingsize 0.0 -interp trilinear -ref qsmnet+_left_new.nii

cd /Users/uqhsun8/Dropbox/anisotropy/right
/usr/local/fsl/bin/flirt -in qsmnet+_right_new.nii -applyxfm -init chi_iLSQR_smvrad1_to_neutral.mat -out qsmnet+_right_new_to_neutral.nii -paddingsize 0.0 -interp trilinear -ref qsmnet+_right_new.nii



% xqsm_syn
cd /Users/uqhsun8/Dropbox/anisotropy/extension
/usr/local/fsl/bin/flirt -in xqsm_syn_extension_new.nii -applyxfm -init chi_iLSQR_smvrad1_to_neutral.mat -out xqsm_syn_extension_new_to_neutral.nii -paddingsize 0.0 -interp trilinear -ref xqsm_syn_extension_new.nii

cd /Users/uqhsun8/Dropbox/anisotropy/flexion
/usr/local/fsl/bin/flirt -in xqsm_syn_flexion_new.nii -applyxfm -init chi_iLSQR_smvrad1_to_neutral.mat -out xqsm_syn_flexion_new_to_neutral.nii -paddingsize 0.0 -interp trilinear -ref xqsm_syn_flexion_new.nii

cd /Users/uqhsun8/Dropbox/anisotropy/left
/usr/local/fsl/bin/flirt -in xqsm_syn_left_new.nii -applyxfm -init chi_iLSQR_smvrad1_to_neutral.mat -out xqsm_syn_left_new_to_neutral.nii -paddingsize 0.0 -interp trilinear -ref xqsm_syn_left_new.nii

cd /Users/uqhsun8/Dropbox/anisotropy/right
/usr/local/fsl/bin/flirt -in xqsm_syn_right_new.nii -applyxfm -init chi_iLSQR_smvrad1_to_neutral.mat -out xqsm_syn_right_new_to_neutral.nii -paddingsize 0.0 -interp trilinear -ref xqsm_syn_right_new.nii



% xqsm_invivo
cd /Users/uqhsun8/Dropbox/anisotropy/extension
/usr/local/fsl/bin/flirt -in xqsm_invivo_extension_new.nii -applyxfm -init chi_iLSQR_smvrad1_to_neutral.mat -out xqsm_invivo_extension_new_to_neutral.nii -paddingsize 0.0 -interp trilinear -ref xqsm_invivo_extension_new.nii

cd /Users/uqhsun8/Dropbox/anisotropy/flexion
/usr/local/fsl/bin/flirt -in xqsm_invivo_flexion_new.nii -applyxfm -init chi_iLSQR_smvrad1_to_neutral.mat -out xqsm_invivo_flexion_new_to_neutral.nii -paddingsize 0.0 -interp trilinear -ref xqsm_invivo_flexion_new.nii

cd /Users/uqhsun8/Dropbox/anisotropy/left
/usr/local/fsl/bin/flirt -in xqsm_invivo_left_new.nii -applyxfm -init chi_iLSQR_smvrad1_to_neutral.mat -out xqsm_invivo_left_new_to_neutral.nii -paddingsize 0.0 -interp trilinear -ref xqsm_invivo_left_new.nii

cd /Users/uqhsun8/Dropbox/anisotropy/right
/usr/local/fsl/bin/flirt -in xqsm_invivo_right_new.nii -applyxfm -init chi_iLSQR_smvrad1_to_neutral.mat -out xqsm_invivo_right_new_to_neutral.nii -paddingsize 0.0 -interp trilinear -ref xqsm_invivo_right_new.nii




% xqsm_invivo_noisy
/usr/local/fsl/bin/flirt -in /Volumes/DEEPMRI-Q1041/anisotropy_0p6mm/01EG/xQSM_invivo_noise_orientations_new/xQSM_invivo_NoisyTrain_extension.nii -applyxfm -init /Volumes/DEEPMRI-Q1041/anisotropy_0p6mm/01EG/extension/chi_iLSQR_smvrad1_to_neutral.mat -out /Volumes/DEEPMRI-Q1041/anisotropy_0p6mm/01EG/xQSM_invivo_noise_orientations_new/xQSM_invivo_NoisyTrain_extension_to_neutral.nii -paddingsize 0.0 -interp trilinear -ref /Volumes/DEEPMRI-Q1041/anisotropy_0p6mm/01EG/xQSM_invivo_noise_orientations_new/xQSM_invivo_NoisyTrain_extension.nii

/usr/local/fsl/bin/flirt -in /Volumes/DEEPMRI-Q1041/anisotropy_0p6mm/01EG/xQSM_invivo_noise_orientations_new/xQSM_invivo_NoisyTrain_flexion.nii -applyxfm -init /Volumes/DEEPMRI-Q1041/anisotropy_0p6mm/01EG/flexion/chi_iLSQR_smvrad1_to_neutral.mat -out /Volumes/DEEPMRI-Q1041/anisotropy_0p6mm/01EG/xQSM_invivo_noise_orientations_new/xQSM_invivo_NoisyTrain_flexion_to_neutral.nii -paddingsize 0.0 -interp trilinear -ref /Volumes/DEEPMRI-Q1041/anisotropy_0p6mm/01EG/xQSM_invivo_noise_orientations_new/xQSM_invivo_NoisyTrain_flexion.nii

/usr/local/fsl/bin/flirt -in /Volumes/DEEPMRI-Q1041/anisotropy_0p6mm/01EG/xQSM_invivo_noise_orientations_new/xQSM_invivo_NoisyTrain_left.nii -applyxfm -init /Volumes/DEEPMRI-Q1041/anisotropy_0p6mm/01EG/left/chi_iLSQR_smvrad1_to_neutral.mat -out /Volumes/DEEPMRI-Q1041/anisotropy_0p6mm/01EG/xQSM_invivo_noise_orientations_new/xQSM_invivo_NoisyTrain_left_to_neutral.nii -paddingsize 0.0 -interp trilinear -ref /Volumes/DEEPMRI-Q1041/anisotropy_0p6mm/01EG/xQSM_invivo_noise_orientations_new/xQSM_invivo_NoisyTrain_left.nii

/usr/local/fsl/bin/flirt -in /Volumes/DEEPMRI-Q1041/anisotropy_0p6mm/01EG/xQSM_invivo_noise_orientations_new/xQSM_invivo_NoisyTrain_right.nii -applyxfm -init /Volumes/DEEPMRI-Q1041/anisotropy_0p6mm/01EG/right/chi_iLSQR_smvrad1_to_neutral.mat -out /Volumes/DEEPMRI-Q1041/anisotropy_0p6mm/01EG/xQSM_invivo_noise_orientations_new/xQSM_invivo_NoisyTrain_right_to_neutral.nii -paddingsize 0.0 -interp trilinear -ref /Volumes/DEEPMRI-Q1041/anisotropy_0p6mm/01EG/xQSM_invivo_noise_orientations_new/xQSM_invivo_NoisyTrain_right.nii
