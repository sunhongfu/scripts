 nii = load_nii('lfs_resharp_tik_0.0001_num_200.nii');
 lfs_resharp = double(nii.img);
 dicom_info.MagneticFieldStrength = 3.0;
 mask_resharp = (lfs_resharp~=0);
 mask_resharp = double(mask_resharp);
 z_prjs = [0 0 1];
 vox = [1,1,1];
 smv_rad = 3;
 
 cd ..

 chi_iLSQR = QSM_iLSQR(lfs_resharp*(2.675e8*dicom_info.MagneticFieldStrength)/1e6,mask_resharp,'H',z_prjs,'voxelsize',vox,'niter',50,'TE',1000,'B0',dicom_info.MagneticFieldStrength);
nii = make_nii(chi_iLSQR,vox);
save_nii(nii,['RESHARP/chi_iLSQR_smvrad' num2str(smv_rad) '.nii']);

