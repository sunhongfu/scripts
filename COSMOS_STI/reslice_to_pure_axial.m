load /Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/all_new.mat

imsize = imsize(1:3);

X = dicom_info.ImageOrientationPatient(1:3);
Y = dicom_info.ImageOrientationPatient(4:6);
Z = cross(X,Y);

% rotation matrix
rot_mat = inv([X,Y,Z]);

% translation in millimeter
tra_mat = (imsize'/2-rot_mat*imsize'/2).*vox';

% cat the matrices
xfm_mat = [rot_mat,tra_mat;[0 0 0 1]];

% save as ascii
save('xfm.mat','xfm_mat','-ascii');



% run Flirt apply transform

!/usr/local/fsl/bin/flirt -in /Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/RESHARP/lfs_resharp_0_smvrad1_cgs_1e-06.nii -applyxfm -init xfm.mat -out test_rot_lfs.nii -paddingsize 0 -interp trilinear -ref /Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/RESHARP/lfs_resharp_0_smvrad1_cgs_1e-06.nii






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
! /usr/local/fsl/bin/convert_xfm -omat xfm_inv.mat -inverse xfm.mat

!/usr/local/fsl/bin/flirt -in chi_iLSQR_smvrad1.nii -applyxfm -init xfm_inv.mat -out chi_iLSQR_smvrad1_flirt.nii -paddingsize 0.0 -interp trilinear -ref chi_iLSQR_smvrad1.nii
