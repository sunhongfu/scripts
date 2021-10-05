

clear
cd /home/hongfu/NCIgb5_scratch/hongfu/COSMOS/05SG/left/QSM_MEGE_7T

tik_reg = 1e-6;
save('raw.mat','tik_reg','-append')

load('raw.mat','tfs_0','mask','R_0','vox','cgs_num','dicom_info','z_prjs','mag_corr','imsize','TE','tik_reg');

for smv_rad = [1 2 3]
    % RE-SHARP (tik_reg: Tikhonov regularization parameter)
    disp('--> RESHARP to remove background field ...');
    % [lfs_resharp_0, mask_resharp_0] = resharp_lsqr(tfs_0,mask.*R_0,vox,smv_rad,lsqr_num);
    [lfs_resharp_0, mask_resharp_0] = resharp(tfs_0,mask.*R_0,vox,smv_rad,tik_reg,cgs_num);
    % save nifti
    mkdir('RESHARP');
    nii = make_nii(lfs_resharp_0,vox);
    % save_nii(nii,['RESHARP/lfs_resharp_0_smvrad' num2str(smv_rad) '_lsqr.nii']);
    save_nii(nii,['RESHARP/lfs_resharp_0_smvrad' num2str(smv_rad) '_cgs_' num2str(tik_reg) '.nii']);

    lfs_resharp(:,:,:,smv_rad) = lfs_resharp_0;
    mask_resharp(:,:,:,smv_rad) = mask_resharp_0;
save('raw.mat','lfs_resharp','mask_resharp','-append');

    % iLSQR
    chi_iLSQR_0 = QSM_iLSQR(lfs_resharp_0*(2.675e8*dicom_info.MagneticFieldStrength)/1e6,mask_resharp_0,'H',z_prjs,'voxelsize',vox,'niter',50,'TE',1000,'B0',dicom_info.MagneticFieldStrength);
    nii = make_nii(chi_iLSQR_0,vox);
    save_nii(nii,['RESHARP/chi_iLSQR_smvrad' num2str(smv_rad) '.nii']);

    chi_iLSQR(:,:,:,smv_rad) = chi_iLSQR_0;
save('raw.mat','chi_iLSQR','-append');

    % MEDI
    %%%%% normalize signal intensity by noise to get SNR %%%
    %%%% Generate the Magnitude image %%%%
    iMag = sqrt(sum(mag_corr.^2,4));
    % [iFreq_raw N_std] = Fit_ppm_complex(ph_corr);
    matrix_size = single(imsize(1:3));
    voxel_size = vox;
    delta_TE = TE(2) - TE(1);
    B0_dir = z_prjs';
    CF = dicom_info.ImagingFrequency *1e6;
    iFreq = [];
    N_std = 1;
    RDF = lfs_resharp_0*2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6;
    Mask = mask_resharp_0;
    save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
         voxel_size delta_TE CF B0_dir;
    QSM = MEDI_L1('lambda',1000);
    nii = make_nii(QSM.*Mask,vox);
    save_nii(nii,['RESHARP/MEDI1000_RESHARP_smvrad' num2str(smv_rad) '.nii']);

    chi_MEDI(:,:,:,smv_rad) = QSM.*Mask;
save('raw.mat','chi_MEDI','-append');

end

save('raw.mat','lfs_resharp','mask_resharp','chi_iLSQR','chi_MEDI','-append');


clear
cd /home/hongfu/NCIgb5_scratch/hongfu/COSMOS/05SG/right/QSM_MEGE_7T

tik_reg = 1e-6;
save('raw.mat','tik_reg','-append')

load('raw.mat','tfs_0','mask','R_0','vox','cgs_num','dicom_info','z_prjs','mag_corr','imsize','TE','tik_reg');

for smv_rad = [1 2 3]
    % RE-SHARP (tik_reg: Tikhonov regularization parameter)
    disp('--> RESHARP to remove background field ...');
    % [lfs_resharp_0, mask_resharp_0] = resharp_lsqr(tfs_0,mask.*R_0,vox,smv_rad,lsqr_num);
    [lfs_resharp_0, mask_resharp_0] = resharp(tfs_0,mask.*R_0,vox,smv_rad,tik_reg,cgs_num);
    % save nifti
    mkdir('RESHARP');
    nii = make_nii(lfs_resharp_0,vox);
    % save_nii(nii,['RESHARP/lfs_resharp_0_smvrad' num2str(smv_rad) '_lsqr.nii']);
    save_nii(nii,['RESHARP/lfs_resharp_0_smvrad' num2str(smv_rad) '_cgs_' num2str(tik_reg) '.nii']);

    lfs_resharp(:,:,:,smv_rad) = lfs_resharp_0;
    mask_resharp(:,:,:,smv_rad) = mask_resharp_0;
save('raw.mat','lfs_resharp','mask_resharp','-append');

    % iLSQR
    chi_iLSQR_0 = QSM_iLSQR(lfs_resharp_0*(2.675e8*dicom_info.MagneticFieldStrength)/1e6,mask_resharp_0,'H',z_prjs,'voxelsize',vox,'niter',50,'TE',1000,'B0',dicom_info.MagneticFieldStrength);
    nii = make_nii(chi_iLSQR_0,vox);
    save_nii(nii,['RESHARP/chi_iLSQR_smvrad' num2str(smv_rad) '.nii']);

    chi_iLSQR(:,:,:,smv_rad) = chi_iLSQR_0;
save('raw.mat','chi_iLSQR','-append');

    % MEDI
    %%%%% normalize signal intensity by noise to get SNR %%%
    %%%% Generate the Magnitude image %%%%
    iMag = sqrt(sum(mag_corr.^2,4));
    % [iFreq_raw N_std] = Fit_ppm_complex(ph_corr);
    matrix_size = single(imsize(1:3));
    voxel_size = vox;
    delta_TE = TE(2) - TE(1);
    B0_dir = z_prjs';
    CF = dicom_info.ImagingFrequency *1e6;
    iFreq = [];
    N_std = 1;
    RDF = lfs_resharp_0*2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6;
    Mask = mask_resharp_0;
    save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
         voxel_size delta_TE CF B0_dir;
    QSM = MEDI_L1('lambda',1000);
    nii = make_nii(QSM.*Mask,vox);
    save_nii(nii,['RESHARP/MEDI1000_RESHARP_smvrad' num2str(smv_rad) '.nii']);

    chi_MEDI(:,:,:,smv_rad) = QSM.*Mask;
save('raw.mat','chi_MEDI','-append');

end

save('raw.mat','lfs_resharp','mask_resharp','chi_iLSQR','chi_MEDI','-append');


clear
cd /home/hongfu/NCIgb5_scratch/hongfu/COSMOS/05SG/extension/QSM_MEGE_7T

tik_reg = 1e-6;
save('raw.mat','tik_reg','-append')

load('raw.mat','tfs_0','mask','R_0','vox','cgs_num','dicom_info','z_prjs','mag_corr','imsize','TE','tik_reg');

for smv_rad = [1 2 3]
    % RE-SHARP (tik_reg: Tikhonov regularization parameter)
    disp('--> RESHARP to remove background field ...');
    % [lfs_resharp_0, mask_resharp_0] = resharp_lsqr(tfs_0,mask.*R_0,vox,smv_rad,lsqr_num);
    [lfs_resharp_0, mask_resharp_0] = resharp(tfs_0,mask.*R_0,vox,smv_rad,tik_reg,cgs_num);
    % save nifti
    mkdir('RESHARP');
    nii = make_nii(lfs_resharp_0,vox);
    % save_nii(nii,['RESHARP/lfs_resharp_0_smvrad' num2str(smv_rad) '_lsqr.nii']);
    save_nii(nii,['RESHARP/lfs_resharp_0_smvrad' num2str(smv_rad) '_cgs_' num2str(tik_reg) '.nii']);

    lfs_resharp(:,:,:,smv_rad) = lfs_resharp_0;
    mask_resharp(:,:,:,smv_rad) = mask_resharp_0;
save('raw.mat','lfs_resharp','mask_resharp','-append');

    % iLSQR
    chi_iLSQR_0 = QSM_iLSQR(lfs_resharp_0*(2.675e8*dicom_info.MagneticFieldStrength)/1e6,mask_resharp_0,'H',z_prjs,'voxelsize',vox,'niter',50,'TE',1000,'B0',dicom_info.MagneticFieldStrength);
    nii = make_nii(chi_iLSQR_0,vox);
    save_nii(nii,['RESHARP/chi_iLSQR_smvrad' num2str(smv_rad) '.nii']);

    chi_iLSQR(:,:,:,smv_rad) = chi_iLSQR_0;
save('raw.mat','chi_iLSQR','-append');

    % MEDI
    %%%%% normalize signal intensity by noise to get SNR %%%
    %%%% Generate the Magnitude image %%%%
    iMag = sqrt(sum(mag_corr.^2,4));
    % [iFreq_raw N_std] = Fit_ppm_complex(ph_corr);
    matrix_size = single(imsize(1:3));
    voxel_size = vox;
    delta_TE = TE(2) - TE(1);
    B0_dir = z_prjs';
    CF = dicom_info.ImagingFrequency *1e6;
    iFreq = [];
    N_std = 1;
    RDF = lfs_resharp_0*2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6;
    Mask = mask_resharp_0;
    save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
         voxel_size delta_TE CF B0_dir;
    QSM = MEDI_L1('lambda',1000);
    nii = make_nii(QSM.*Mask,vox);
    save_nii(nii,['RESHARP/MEDI1000_RESHARP_smvrad' num2str(smv_rad) '.nii']);

    chi_MEDI(:,:,:,smv_rad) = QSM.*Mask;
save('raw.mat','chi_MEDI','-append');

end

save('raw.mat','lfs_resharp','mask_resharp','chi_iLSQR','chi_MEDI','-append');


clear
cd /home/hongfu/NCIgb5_scratch/hongfu/COSMOS/05SG/flexion/QSM_MEGE_7T

tik_reg = 1e-6;
save('raw.mat','tik_reg','-append')

load('raw.mat','tfs_0','mask','R_0','vox','cgs_num','dicom_info','z_prjs','mag_corr','imsize','TE','tik_reg');

for smv_rad = [1 2 3]
    % RE-SHARP (tik_reg: Tikhonov regularization parameter)
    disp('--> RESHARP to remove background field ...');
    % [lfs_resharp_0, mask_resharp_0] = resharp_lsqr(tfs_0,mask.*R_0,vox,smv_rad,lsqr_num);
    [lfs_resharp_0, mask_resharp_0] = resharp(tfs_0,mask.*R_0,vox,smv_rad,tik_reg,cgs_num);
    % save nifti
    mkdir('RESHARP');
    nii = make_nii(lfs_resharp_0,vox);
    % save_nii(nii,['RESHARP/lfs_resharp_0_smvrad' num2str(smv_rad) '_lsqr.nii']);
    save_nii(nii,['RESHARP/lfs_resharp_0_smvrad' num2str(smv_rad) '_cgs_' num2str(tik_reg) '.nii']);

    lfs_resharp(:,:,:,smv_rad) = lfs_resharp_0;
    mask_resharp(:,:,:,smv_rad) = mask_resharp_0;
save('raw.mat','lfs_resharp','mask_resharp','-append');

    % iLSQR
    chi_iLSQR_0 = QSM_iLSQR(lfs_resharp_0*(2.675e8*dicom_info.MagneticFieldStrength)/1e6,mask_resharp_0,'H',z_prjs,'voxelsize',vox,'niter',50,'TE',1000,'B0',dicom_info.MagneticFieldStrength);
    nii = make_nii(chi_iLSQR_0,vox);
    save_nii(nii,['RESHARP/chi_iLSQR_smvrad' num2str(smv_rad) '.nii']);

    chi_iLSQR(:,:,:,smv_rad) = chi_iLSQR_0;
save('raw.mat','chi_iLSQR','-append');

    % MEDI
    %%%%% normalize signal intensity by noise to get SNR %%%
    %%%% Generate the Magnitude image %%%%
    iMag = sqrt(sum(mag_corr.^2,4));
    % [iFreq_raw N_std] = Fit_ppm_complex(ph_corr);
    matrix_size = single(imsize(1:3));
    voxel_size = vox;
    delta_TE = TE(2) - TE(1);
    B0_dir = z_prjs';
    CF = dicom_info.ImagingFrequency *1e6;
    iFreq = [];
    N_std = 1;
    RDF = lfs_resharp_0*2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6;
    Mask = mask_resharp_0;
    save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
         voxel_size delta_TE CF B0_dir;
    QSM = MEDI_L1('lambda',1000);
    nii = make_nii(QSM.*Mask,vox);
    save_nii(nii,['RESHARP/MEDI1000_RESHARP_smvrad' num2str(smv_rad) '.nii']);

    chi_MEDI(:,:,:,smv_rad) = QSM.*Mask;
save('raw.mat','chi_MEDI','-append');

end

save('raw.mat','lfs_resharp','mask_resharp','chi_iLSQR','chi_MEDI','-append');




