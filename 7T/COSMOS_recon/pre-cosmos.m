% generate QSM using a few other methods/parameters

load('all.mat','tfs','mask','R','vox','smv_rad','cgs_num','tv_reg','mag','z_prjs','inv_num','lfs_resharp','mask_resharp','dicom_info');

% iLSQR
chi_iLSQR = QSM_iLSQR(lfs_resharp*(2.675e8*dicom_info.MagneticFieldStrength)/1e6,mask_resharp,'H',z_prjs,'voxelsize',vox,'niter',50,'TE',1000,'B0',dicom_info.MagneticFieldStrength);
nii = make_nii(chi_iLSQR,vox);
save_nii(nii,['RESHARP/chi_iLSQR_niter50_smvrad' num2str(smv_rad) '.nii']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('--> RESHARP to remove background field ...');
[lfs_resharp, mask_resharp] = resharp(tfs,mask.*R,vox,smv_rad,1e-6,cgs_num);
% % 3D 2nd order polyfit to remove any residual background
% lfs_resharp= poly3d(lfs_resharp,mask_resharp);

% save nifti
mkdir('RESHARP');
nii = make_nii(lfs_resharp,vox);
save_nii(nii,'RESHARP/lfs_resharp_1e-6.nii');

% inversion of susceptibility 
disp('--> TV susceptibility inversion on RESHARP...');
sus_resharp = tvdi(lfs_resharp,mask_resharp,vox,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 

% save nifti
nii = make_nii(sus_resharp.*mask_resharp,vox);
save_nii(nii,'RESHARP/sus_resharp_tik1e-6.nii');

% iLSQR
chi_iLSQR = QSM_iLSQR(lfs_resharp*(2.675e8*dicom_info.MagneticFieldStrength)/1e6,mask_resharp,'H',z_prjs,'voxelsize',vox,'niter',50,'TE',1000,'B0',dicom_info.MagneticFieldStrength);
nii = make_nii(chi_iLSQR,vox);
save_nii(nii,['RESHARP/chi_iLSQR_niter50_smvrad' num2str(smv_rad) '_tik1e-6.nii']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('--> RESHARP to remove background field ...');
[lfs_resharp, mask_resharp] = resharp(tfs,mask.*R,vox,smv_rad,1e-4,cgs_num);
% % 3D 2nd order polyfit to remove any residual background
% lfs_resharp= poly3d(lfs_resharp,mask_resharp);

% save nifti
mkdir('RESHARP');
nii = make_nii(lfs_resharp,vox);
save_nii(nii,'RESHARP/lfs_resharp_1e-4.nii');

% inversion of susceptibility 
disp('--> TV susceptibility inversion on RESHARP...');
sus_resharp = tvdi(lfs_resharp,mask_resharp,vox,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 

% save nifti
nii = make_nii(sus_resharp.*mask_resharp,vox);
save_nii(nii,'RESHARP/sus_resharp_tik1e-4.nii');

% iLSQR
chi_iLSQR = QSM_iLSQR(lfs_resharp*(2.675e8*dicom_info.MagneticFieldStrength)/1e6,mask_resharp,'H',z_prjs,'voxelsize',vox,'niter',50,'TE',1000,'B0',dicom_info.MagneticFieldStrength);
nii = make_nii(chi_iLSQR,vox);
save_nii(nii,['RESHARP/chi_iLSQR_niter50_smvrad' num2str(smv_rad) '_tik1e-4.nii']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% V-SHARP + TV / iLSQR
smvsize = 12;
[lfs_vsharp, mask_vsharp] = V_SHARP(tfs ,single(mask.*R),'smvsize',smvsize,'voxelsize',vox);

% save nifti
mkdir('VSHARP');
nii = make_nii(lfs_vsharp,vox);
save_nii(nii,'VSHARP/lfs_vsharp.nii');
% inversion of susceptibility 
disp('--> TV susceptibility inversion on RESHARP...');
sus_vsharp = tvdi(lfs_vsharp,mask_vsharp,vox,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 

% save nifti
nii = make_nii(sus_vsharp.*mask_vsharp,vox);
save_nii(nii,'VSHARP/sus_vsharp.nii');


% iLSQR
chi_iLSQR = QSM_iLSQR(lfs_vsharp*(2.675e8*dicom_info.MagneticFieldStrength)/1e6,mask_resharp,'H',z_prjs,'voxelsize',vox,'niter',50,'TE',1000,'B0',dicom_info.MagneticFieldStrength);
nii = make_nii(chi_iLSQR,vox);
save_nii(nii,['VSHARP/chi_iLSQR_niter50_smvrad' num2str(smv_rad) '.nii']);

