TE2=TE(1:3);

% fit phase images with echo times
disp('--> magnitude weighted LS fit of phase to TE ...');
[tfs0, fit_residual0] = echofit(unph,mag,TE,0); 
nii = make_nii(tfs0,voxel_size);
save_nii(nii,'tfs0.nii');
nii = make_nii(fit_residual0,voxel_size);
save_nii(nii,'fit_residual0.nii');

r_mask = 1;
fit_thr = 40;
% extra filtering according to fitting residuals
if r_mask
    % generate reliability map
    fit_residual_blur = smooth3(fit_residual0,'box',round(0.1./voxel_size)*2+1); 
    nii = make_nii(fit_residual_blur,voxel_size);
    save_nii(nii,'fit_residual_blur.nii');
    R = ones(size(fit_residual_blur));
    R(fit_residual_blur >= fit_thr) = 0;
else
    R = 1;
end


% normalize to main field
% ph = gamma*dB*TE
% dB/B = ph/(gamma*TE*B0)
% units: TE s, gamma 2.675e8 rad/(sT), B0 3T
tfs = -tfs0/(2.675e8*9.4)*1e6; % unit ppm

nii = make_nii(tfs,voxel_size);
save_nii(nii,'tfs.nii');


% disp('--> RESHARP to remove background field ...');
% smv_rad = 0.3;
% tik_reg = 1e-4;
% cgs_num = 500;
% tv_reg = 2e-4;
% z_prjs = B0_dir;
% inv_num = 500;

% [lfs_resharp, mask_resharp] = resharp(tfs,mask.*R,voxel_size,smv_rad,tik_reg,cgs_num);
% % % 3D 2nd order polyfit to remove any residual background
% % lfs_resharp= lfs_resharp - poly3d(lfs_resharp,mask_resharp);

% % save nifti
% [~,~,~] = mkdir('RESHARP');
% nii = make_nii(lfs_resharp,voxel_size);
% save_nii(nii,['RESHARP/lfs_resharp_tik_', num2str(tik_reg), '_num_', num2str(cgs_num), '.nii']);

% % % inversion of susceptibility 
% % disp('--> TV susceptibility inversion on RESHARP...');
% % sus_resharp = tvdi(lfs_resharp,mask_resharp,voxel_size,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 

% % % save nifti
% % nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
% % save_nii(nii,['RESHARP/sus_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);

% % iLSQR method
% chi_iLSQR_0 = QSM_iLSQR(lfs_resharp*(2.675e8*9.4)/1e6,mask_resharp,'H',z_prjs,'voxelsize',voxel_size,'niter',50,'TE',1000,'B0',9.4);
% nii = make_nii(chi_iLSQR_0,voxel_size);
% save_nii(nii,'chi_iLSQR_0.nii');




disp('--> RESHARP to remove background field ...');
smv_rad = 0.2;
tik_reg = 1e-4;
cgs_num = 200;
tv_reg = 2e-4;
z_prjs = B0_dir;
inv_num = 500;

[lfs_resharp, mask_resharp] = resharp(tfs,mask.*R,voxel_size,smv_rad,tik_reg,cgs_num);
% % 3D 2nd order polyfit to remove any residual background
% lfs_resharp= lfs_resharp - poly3d(lfs_resharp,mask_resharp);

% save nifti
[~,~,~] = mkdir('RESHARP');
nii = make_nii(lfs_resharp,voxel_size);
save_nii(nii,['RESHARP/lfs_resharp0_tik_', num2str(tik_reg), '_num_', num2str(cgs_num), '.nii']);

% % inversion of susceptibility 
% disp('--> TV susceptibility inversion on RESHARP...');
% sus_resharp = tvdi(lfs_resharp,mask_resharp,voxel_size,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 
% % save nifti
% nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
% save_nii(nii,['RESHARP/sus_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);

% iLSQR method
chi_iLSQR = QSM_iLSQR(lfs_resharp*(2.675e8*9.4)/1e6,mask_resharp,'H',z_prjs,'voxelsize',voxel_size,'niter',50,'TE',1000,'B0',9.4);
nii = make_nii(chi_iLSQR,voxel_size);
save_nii(nii,'RESHARP/chi_iLSQR0.nii');



% V-SHARP + iLSQR
B0 =9.4;
voxelsize = voxel_size;
padsize = [12 12 12];
smvsize = 12;
[TissuePhase3d, mask_vsharp] = V_SHARP(tfs ,single(mask.*R),'smvsize',smvsize,'voxelsize',voxelsize*10);
nii = make_nii(TissuePhase3d,voxel_size);
% save nifti
[~,~,~] = mkdir('VSHARP');
save_nii(nii,'VSHARP/VSHARP.nii');

chi_iLSQR_0 = QSM_iLSQR(TissuePhase3d*(2.675e8*9.4)/1e6,mask_vsharp,'H',z_prjs,'voxelsize',voxel_size,'niter',50,'TE',1000,'B0',9.4);
nii = make_nii(chi_iLSQR_0,voxel_size);
save_nii(nii,'VSHARP/chi_iLSQR_0_vsharp.nii');


% % V-SHARP + iLSQR for each single echo
% TissuePhase3d = zeros(size(mag));
% mask_vsharp = TissuePhase3d;
% chi_iLSQR_0 = mask_vsharp;

% for echo = 1:3
%     [TissuePhase3d(:,:,:,echo), mask_vsharp(:,:,:,echo)] = V_SHARP(-unph(:,:,:,echo) ,single(mask.*R),'smvsize',smvsize,'voxelsize',voxelsize*10);
%     nii = make_nii(TissuePhase3d(:,:,:,echo),voxel_size);
%     save_nii(nii,['VSHARP' num2str(echo) '.nii']);

%     chi_iLSQR_0(:,:,:,echo) = QSM_iLSQR(TissuePhase3d(:,:,:,echo),mask_vsharp(:,:,:,echo),'H',z_prjs,'voxelsize',voxel_size,'niter',50,'TE',TE(echo)*1000,'B0',9.4);
%     nii = make_nii(chi_iLSQR_0(:,:,:,echo),voxel_size);
%     save_nii(nii,['chi_iLSQR_0_vsharp' num2str(echo) '.nii']);
% end

% chi_iLSQR_0_ave = mean(chi_iLSQR_0,4);
% nii = make_nii(chi_iLSQR_0_ave,voxel_size);
% save_nii(nii,'chi_iLSQR_0_ave.nii');

