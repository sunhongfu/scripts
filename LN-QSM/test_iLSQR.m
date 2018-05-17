load('LNQSM.mat','tfs','dicom_info','delta_TE','vox','mask','z_prjs');
load('../all.mat','R');

iFreq = tfs*2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6;
voxel_size = vox;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% change the RESHARP parameter? 1e-6?
mkdir TFS_RESHARP_ERO2_iLSQR
cd TFS_RESHARP_ERO2_iLSQR
% (8) MEDI eroded brain with RESHARP (2 voxels erosion)
[RDF, mask_resharp] = resharp(iFreq,mask.*R,vox,2,1e-6,200);
nii = make_nii(RDF,voxel_size);
save_nii(nii,'resharp_1e-6.nii');
% Mask = mask_resharp;
% save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
%      voxel_size delta_TE CF B0_dir;
% % run part of MEDI first
% QSM = MEDI_L1('lambda',1000);
% nii = make_nii(QSM.*Mask,vox);
% save_nii(nii,'MEDI_RESHARP_1e-6_ero2.nii');

%%%%%%%% (2) iLSQR %%%%%%%%%
chi_iLSQR = QSM_iLSQR(RDF,mask_resharp,'H',z_prjs,'voxelsize',vox,'niter',50,'TE',1000*delta_TE,'B0',dicom_info.MagneticFieldStrength);
nii = make_nii(chi_iLSQR,vox);
save_nii(nii,['chi_resharp_iLSQR_ero2.nii']);
cd ..

