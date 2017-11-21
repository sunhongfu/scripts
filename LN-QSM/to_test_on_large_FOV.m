% use Cornell's complex fitting + spurs unwrapping
voxel_size = vox;
% iField = mag.*exp(1i*ph_corr);
iField = mag.*exp(1i*ph);
% additional iField correction
iField = iField_correction(iField,vox);
%%%%% provide a noise_level here if possible %%%%%%
if (~exist('noise_level','var'))
    noise_level = calfieldnoise(iField, mask);
end
%%%%% normalize signal intensity by noise to get SNR %%%
iField = iField/noise_level;
%%%% Generate the Magnitude image %%%%
iMag = sqrt(sum(abs(iField).^2,4));
% complex fitting
[iFreq_raw N_std] = Fit_ppm_complex(iField);
nii = make_nii(iFreq_raw,voxel_size);
save_nii(nii,'iFreq_raw.nii');
nii = make_nii(N_std,voxel_size);
save_nii(nii,'N_std.nii');

delta_TE = TE(2) - TE(1);
B0_dir = z_prjs';
CF = dicom_info.ImagingFrequency *1e6;
matrix_size = single(size(iFreq_raw));

% % phase unwrapping
% iFreq = unwrapPhase(iMag,iFreq_raw,matrix_size);
% nii = make_nii(iFreq,vox);
% save_nii(nii,'iFreq_unwrapPhase.nii');

% % Spatial phase unwrapping (graph-cut based)
iFreq = unwrapping_gc(iFreq_raw,iMag,voxel_size);
nii = make_nii(iFreq,vox);
save_nii(nii,'iFreq_unwrapping_gc.nii');
% may need 2pi correction
iFreq = iFreq - 6*pi;
nii = make_nii(iFreq,vox);
save_nii(nii,'iFreq_unwrapping_gc.nii');

% generate mask of soft tissue
mask_soft = mag(:,:,:,1) > max(mag(:))/20;
mask_soft = single(mask_soft);
nii = make_nii(mask_soft,vox);
save_nii(nii,'mask_soft.nii');

tfs = iFreq/(2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6);
nii = make_nii(tfs,vox);
save_nii(nii,'tfs.nii');

% pad 40 zeros
tfs_pad = padarray(tfs,[0 0 40]);
mask_pad = padarray(mask,[0 0 40]);
mask_soft_pad = padarray(mask_soft, [0 0 40]);
% mask_head_pad = padarray(mask_head, [0 0 40]);
% mask_air_pad=mask_head_pad-mask_soft_pad;
mask_skull_pad = ((mask_soft_pad - mask_pad) == 1);
mask_soft_pad = mask_pad + mask_skull_pad;

mask_head_pad = MaskFilling(mask_soft_pad, 12);
% mask_head = mask_head(:,:,3:end-2);
mask_air_pad = mask_head_pad - mask_soft_pad;

nii = make_nii(mask_head_pad,vox);
save_nii(nii,'mask_head_pad.nii');
nii = make_nii(mask_soft_pad,vox);
save_nii(nii,'mask_soft_pad.nii');
nii = make_nii(mask_skull_pad,vox);
save_nii(nii,'mask_skull_pad.nii');
nii = make_nii(mask_air_pad,vox);
save_nii(nii,'mask_air_pad.nii');



load('all_new.mat','tfs_pad','mask_pad','mask_soft_pad','mask_head_pad','mask_air_pad','mask_skull_pad','vox','z_prjs');

mkdir 300
cd 300

% (1) single step
P = mask_soft_pad+ 30*(1 - mask_soft_pad);

chi_all_skull_tv = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_pad, 0, mask_skull_pad, 5e-4, 0, 1e-2, vox, P, z_prjs, 300);
nii = make_nii(chi_all_skull_tv,vox);
save_nii(nii,['chi_all_skull_tv1e-2_tik0.nii']);

chi_all_skull_NOtv = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_pad, 0, 0, 5e-4, 0, 0, vox, P, z_prjs, 300);
nii = make_nii(chi_all_skull_NOtv,vox);
save_nii(nii,['chi_all_skull_tv0_tik0.nii']);


chi_all_ss = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_soft_pad, 0, 0, 5e-4, 0, 0, vox, P, z_prjs, 300);
nii = make_nii(chi_all_ss,vox);
save_nii(nii,['chi_all_ss_tik0.nii']);


chi_all_skull_tv2 = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_pad, mask_pad, mask_skull_pad, 5e-4, 2e-3, 1e-2, vox, P, z_prjs, 300);
nii = make_nii(chi_all_skull_tv2,vox);
save_nii(nii,['chi_all_skull_tv1e-2_tik2e-3_300.nii']);

chi_all_skull_tvair = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_pad, 0, 1 - mask_soft_pad, 5e-4, 0, 1e-2, vox, P, z_prjs, 300);
nii = make_nii(chi_all_skull_tvair,vox);
save_nii(nii,['chi_all_skull_tvair_tik0_300.nii']);

chi_all_skull_tvair = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_pad, 0, 1 - mask_soft_pad, 0, 0, 1e-2, vox, P, z_prjs, 300);
nii = make_nii(chi_all_skull_tvair,vox);
save_nii(nii,['chi_all_skull_tvair_tik0_300_TV0.nii']);

chi_all_skull_tvair = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_pad, 0, 1 - mask_soft_pad, 1e-2, 0, 1e-2, vox, P, z_prjs, 300);
nii = make_nii(chi_all_skull_tvair,vox);
save_nii(nii,['chi_all_skull_tvair_tik0_300_TV_1e-2.nii']);

chi_all_skull_tvair = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_pad, 0, 1 - mask_soft_pad, 5e-4, 0, 5e-4, vox, P, z_prjs, 300);
nii = make_nii(chi_all_skull_tvair,vox);
save_nii(nii,['chi_all_skull_tvair_tik0_300_5e-4.nii']);

chi_all_skull_tvair = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_pad, 0, 1 - mask_soft_pad, 5e-4, 0, 5e-6, vox, P, z_prjs, 300);
nii = make_nii(chi_all_skull_tvair,vox);
save_nii(nii,['chi_all_skull_tvair_tik0_300_5e-6.nii']);

chi_all_skull_tvair = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_pad, 0, 1 - mask_soft_pad, 5e-4, 0, 0, vox, P, z_prjs, 300);
nii = make_nii(chi_all_skull_tvair,vox);
save_nii(nii,['chi_all_skull_tvair_tik0_300_0.nii']);

chi_all_skull_tvair2 = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_pad, 0, mask_air_pad, 5e-4, 0, 1e-2, vox, P, z_prjs, 300);
nii = make_nii(chi_all_skull_tvair2,vox);
save_nii(nii,['chi_all_skull_tvair2_tik0_300.nii']);


chi_all_ss = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_soft_pad, mask_soft_pad, mask_air_pad, 5e-4, 2e-3, 1e-2, vox, P, z_prjs, 300);
nii = make_nii(chi_all_ss,vox);
save_nii(nii,['chi_all_ss_tik2e-3_airTV1e-2_300.nii']);



% TV of the head mask instead of BET mask or soft tissue mask
P = mask_soft_pad+ 30*(1 - mask_soft_pad);


% chi_all_head2 = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_head_pad, 0, 0, 5e-4, 0, 0, vox, P, z_prjs, 300);
% nii = make_nii(chi_all_head2,vox);
% save_nii(nii,['chi_all_head_tik0_300_5e-4.nii']);



chi_all_ss = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_soft_pad, mask_soft_pad, 0, 5e-4, 2e-3, 0, vox, P, z_prjs, 300);
nii = make_nii(chi_all_ss,vox);
save_nii(nii,['chi_all_ss_2e-3.nii']);

chi_all_ss = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_soft_pad, mask_soft_pad, 0, 5e-4, 1e-2, 0, vox, P, z_prjs, 300);
nii = make_nii(chi_all_ss,vox);
save_nii(nii,['chi_all_ss_1e-2.nii']);

chi_all_ss = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_soft_pad, mask_soft_pad, 0, 5e-4, 5e-3, 0, vox, P, z_prjs, 300);
nii = make_nii(chi_all_ss,vox);
save_nii(nii,['chi_all_ss_5e-3.nii']);


chi_all_ss = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_soft_pad, mask_soft_pad, 0, 5e-4, 0.1, 0, vox, P, z_prjs, 300);
nii = make_nii(chi_all_ss,vox);
save_nii(nii,['chi_all_ss_1e-1.nii']);

Res_wt = padarray(iMag,[0 0 40]).*mask_soft_pad;
Res_wt = Res_wt/sum(Res_wt(:))*sum(mask_soft_pad(:));
chi_all_ss = tikhonov_qsm(tfs_pad, Res_wt, 1, mask_soft_pad, mask_soft_pad, 0, 5e-4, 0.1, 0, vox, P, z_prjs, 300);
nii = make_nii(chi_all_ss,vox);
save_nii(nii,['chi_all_ss_1e-1_wt.nii']);


chi_all_mm = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_pad, mask_pad, 0, 5e-4, 2e-3, 0, vox, P, z_prjs, 300);
nii = make_nii(chi_all_mm,vox);
save_nii(nii,['chi_all_mm_2e-3.nii']);

chi_all_mm = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_pad, mask_pad, 0, 5e-4, 1e-2, 0, vox, P, z_prjs, 300);
nii = make_nii(chi_all_mm,vox);
save_nii(nii,['chi_all_mm_1e-2.nii']);

chi_all_mm = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_pad, mask_pad, 0, 5e-4, 5e-3, 0, vox, P, z_prjs, 300);
nii = make_nii(chi_all_mm,vox);
save_nii(nii,['chi_all_mm_5e-3.nii']);



mkdir P_1_1_30

P = 30*(mask_head_pad - mask_soft_pad) + 1 - (mask_head_pad - mask_soft_pad);

% chi_all_head2 = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_head_pad, 0, 0, 5e-4, 0, 0, vox, P, z_prjs, 300);
% nii = make_nii(chi_all_head2,vox);
% save_nii(nii,['chi_all_head_tik0_300_5e-4.nii']);

chi_all_ss = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_soft_pad, mask_soft_pad, 0, 5e-4, 2e-3, 0, vox, P, z_prjs, 300);
nii = make_nii(chi_all_ss,vox);
save_nii(nii,['chi_all_ss_2e-3.nii']);

chi_all_ss = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_soft_pad, mask_soft_pad, 0, 5e-4, 1e-2, 0, vox, P, z_prjs, 300);
nii = make_nii(chi_all_ss,vox);
save_nii(nii,['chi_all_ss_1e-2.nii']);

chi_all_ss = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_soft_pad, mask_soft_pad, 0, 5e-4, 5e-3, 0, vox, P, z_prjs, 300);
nii = make_nii(chi_all_ss,vox);
save_nii(nii,['chi_all_ss_5e-3.nii']);


chi_all_mm = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_pad, mask_pad, 0, 5e-4, 2e-3, 0, vox, P, z_prjs, 300);
nii = make_nii(chi_all_mm,vox);
save_nii(nii,['chi_all_mm_2e-3.nii']);

chi_all_mm = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_pad, mask_pad, 0, 5e-4, 1e-2, 0, vox, P, z_prjs, 300);
nii = make_nii(chi_all_mm,vox);
save_nii(nii,['chi_all_mm_1e-2.nii']);

chi_all_mm = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_pad, mask_pad, 0, 5e-4, 5e-3, 0, vox, P, z_prjs, 300);
nii = make_nii(chi_all_mm,vox);
save_nii(nii,['chi_all_mm_5e-3.nii']);





% two steps

 P = mask_soft_pad+ 30*(1 - mask_soft_pad);


 chi_air300_P30 = tikhonov_qsm(tfs_pad, mask_soft_pad, 1 - mask_soft_pad, 0, 0, 0, 0, 0, 0, vox, P, z_prjs, 300);
 nii = make_nii(chi_air300_P30,vox);
 save_nii(nii,['air_outside_30_300.nii']);

 % foward calculation  
 % create K-space filter kernel D
 %%%%% make this a seperate function in the future
 [Nx, Ny, Nz] = size(tfs_pad);
 FOV  = vox.*[Nx, Ny, Nz];
 FOVx = FOV(1);
 FOVy = FOV(2);
 FOVz = FOV(3);

 x = -Nx/2:Nx/2-1;
 y = -Ny/2:Ny/2-1;
 z = -Nz/2:Nz/2-1;

 [kx, ky, kz] = ndgrid(x/FOVx,y/FOVy,z/FOVz);
 D = 1/3 - (kx.*z_prjs(1) + ky.*z_prjs(2) + kz.*z_prjs(3)).^2 ./ (kx.^2 + ky.^2 + kz.^2);
 D(floor(Nx/2+1), floor(Ny/2+1), floor(Nz/2+1)) = 0;
 D = fftshift(D);


 data_air300_P30 = (tfs_pad - real(ifftn(D.*fftn(chi_air300_P30)))).*mask_soft_pad;
 nii = make_nii(data_air300_P30,vox);
 save_nii(nii,'data_air300_P30.nii');


 chi300_P30_ss = tikhonov_qsm(data_air300_P30, mask_soft_pad, 1, mask_soft_pad, mask_soft_pad, 0, 5e-4, 2e-3, 0, vox, P, z_prjs, 300);
 nii = make_nii(chi300_P30_ss,vox);
 save_nii(nii,['chi300_P30_ss.nii']);

 chi300_P30_mm = tikhonov_qsm(data_air300_P30, mask_soft_pad, 1, mask_pad, mask_pad, 0, 5e-4, 2e-3, 0, vox, P, z_prjs, 300);
 nii = make_nii(chi300_P30_mm,vox);
 save_nii(nii,['chi300_P30_mm.nii']);


 P = 1;

 chi300_P30_ss_P1 = tikhonov_qsm(data_air300_P30, mask_soft_pad, 1, mask_soft_pad, mask_soft_pad, 0, 5e-4, 2e-3, 0, vox, P, z_prjs, 300);
 nii = make_nii(chi300_P30_ss_P1,vox);
 save_nii(nii,['chi300_P30_ss_P1.nii']);

 chi300_P30_mm_P1 = tikhonov_qsm(data_air300_P30, mask_soft_pad, 1, mask_pad, mask_pad, mask_soft_pad - mask_pad, 5e-4, 2e-3, 0.01, vox, P, z_prjs, 300);
 nii = make_nii(chi300_P30_mm_P1,vox);
 save_nii(nii,['chi300_P30_mm_P1.nii']);

 chi300_P30_mm_P1 = tikhonov_qsm(data_air300_P30, mask_soft_pad, 1, mask_pad, mask_pad, mask_soft_pad - mask_pad, 5e-4, 2e-3, 0.01, vox, P, z_prjs, 300);
 nii = make_nii(chi300_P30_mm_P1,vox);
 save_nii(nii,['chi300_P30_mm_P1_noskll.nii']);

%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% P = mask_soft_pad+ 60*(1 - mask_soft_pad);

% chi = tikhonov_qsm(tfs_pad, mask_soft_pad, 1 - mask_soft_pad, 0, 0, 0, 0, 0, 0, vox, P, z_prjs, 300);
% nii = make_nii(chi,vox);
% save_nii(nii,['air_outside30_wt_mask_P60_300.nii']);

% % foward calculation
% % create K-space filter kernel D
% %%%%% make this a seperate function in the future
% [Nx, Ny, Nz] = size(tfs_pad);
% FOV  = vox.*[Nx, Ny, Nz];
% FOVx = FOV(1); 
% FOVy = FOV(2); 
% FOVz = FOV(3); 

% x = -Nx/2:Nx/2-1;
% y = -Ny/2:Ny/2-1;
% z = -Nz/2:Nz/2-1;

% [kx, ky, kz] = ndgrid(x/FOVx,y/FOVy,z/FOVz);
% D = 1/3 - (kx.*z_prjs(1) + ky.*z_prjs(2) + kz.*z_prjs(3)).^2 ./ (kx.^2 + ky.^2 + kz.^2);
% D(floor(Nx/2+1), floor(Ny/2+1), floor(Nz/2+1)) = 0;
% D = fftshift(D);


% data = tfs_pad - ifftn(D.*fftn(chi));
% nii = make_nii(data,vox);
% save_nii(nii,'data_300_P60.nii');


% P = mask_soft_pad + 30*(1 - mask_soft_pad);

% chi_local = tikhonov_qsm(data.*mask_soft_pad, mask_soft_pad, 1, mask_soft_pad, mask_soft_pad, 0, 5e-4, 1e-3, 0, vox, P, z_prjs, 300);

% nii = make_nii(chi_local,vox);
% save_nii(nii,['local_outside30_wt_mask_susmask1.nii']);


% chi_local = tikhonov_qsm(data.*mask_soft_pad, mask_soft_pad, 1, mask_soft_pad, mask_soft_pad, 0, 5e-4, 0, 0, vox, P, z_prjs, 300);
% nii = make_nii(chi_local,vox);
% save_nii(nii,['local_outside30_wt_mask_susmask1_tik0_300.nii']);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  P = mask_soft_pad+ 30*(1 - mask_soft_pad);
%  Mask_G = 1 * mask_soft_pad + 1/30 * (~mask_soft_pad & mask_head_pad);

%  chi = tikhonov_qsm(tfs_pad, mask_soft_pad, 1 - mask_soft_pad, Mask_G, 0, 0, 0.01, 0, 0, vox, P, z_prjs, 300);
%  nii = make_nii(chi,vox);
%  save_nii(nii,['air_outside30_wt_mask_P30_300_MaskG.nii']);


%  P = 30*(mask_head_pad - mask_soft_pad) + 1 - (mask_head_pad - mask_soft_pad);
%  nii=make_nii(P,vox);
%  save_nii(nii,'P.nii')
%  Mask_G = 1 * mask_soft_pad + 1/30 * (~mask_soft_pad & mask_head_pad);
%  nii=make_nii(Mask_G,vox);
%  save_nii(nii,'Mask_G.nii')

%  % foward calculation
%  % create K-space filter kernel D
%  %%%%% make this a seperate function in the future
%  [Nx, Ny, Nz] = size(tfs_pad);
%  FOV  = vox.*[Nx, Ny, Nz];
%  FOVx = FOV(1); 
%  FOVy = FOV(2); 
%  FOVz = FOV(3); 

%  x = -Nx/2:Nx/2-1;
%  y = -Ny/2:Ny/2-1;
%  z = -Nz/2:Nz/2-1;

%  [kx, ky, kz] = ndgrid(x/FOVx,y/FOVy,z/FOVz);
%  D = 1/3 - (kx.*z_prjs(1) + ky.*z_prjs(2) + kz.*z_prjs(3)).^2 ./ (kx.^2 + ky.^2 + kz.^2);
%  D(floor(Nx/2+1), floor(Ny/2+1), floor(Nz/2+1)) = 0;
%  D = fftshift(D);


%  data = tfs_pad - ifftn(D.*fftn(chi));
%  nii = make_nii(data,vox);
%  save_nii(nii,'data_300_P30.nii');


%  data = real(tfs_pad - ifftn(D.*fftn(chi)));
%  nii = make_nii(data,vox);
%  save_nii(nii,'data_300_P30.nii');
%  nii = make_nii(data.*mask_soft_pad,vox);
%  save_nii(nii,'data_300_P30.nii');

%  chi_local = tikhonov_qsm(data.*mask_soft_pad, mask_soft_pad, 1, mask_soft_pad, mask_soft_pad, 0, 5e-4, 0, 0, vox, P, z_prjs, 300);
%  nii = make_nii(chi_local,vox);
%  save_nii(nii,['local_outside30_wt_mask_susmask1_tik0_300.nii']);



