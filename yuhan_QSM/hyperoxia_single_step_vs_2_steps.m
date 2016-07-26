% yuhan 7 echoes, 1 mm isotropic, different oxygen levels

mag = zeros([260 320 128 7]);
unph = mag;

% read in mask
nii = load_nii('brain_bet2_hr_mask.nii');
mask = single(nii.img);

% read in the magnitudes and phase (prelude)
for echo = 1:7
	nii = load_nii(['mag_e' num2str(echo) '.nii']);
	mag(:,:,:,echo) = single(nii.img);
	nii = load_nii(['phase_e' num2str(echo) '_prelude.nii']);
	unph(:,:,:,echo) = single(nii.img).*mask;
end


% 2pi jumps correction
unph_diff = unph(:,:,:,1);

for echo = 3:7
    meandiff = unph(:,:,:,echo)-unph(:,:,:,2)-double(echo-2)*unph_diff;
    meandiff = meandiff(mask==1);
    meandiff = mean(meandiff(:));
    njump = round(meandiff/(2*pi));
    disp(['    ' num2str(njump) ' 2pi jumps for TE' num2str(echo)]);
    unph(:,:,:,echo) = unph(:,:,:,echo) - njump*2*pi;
    unph(:,:,:,echo) = unph(:,:,:,echo).*mask;
end


% fit the unph
[tfs, fit_residual] = echofit(unph(:,:,:,2:7),mag(:,:,:,2:7),TE(2:7)-TE(1),0); 

r_mask = 1;
fit_thr = 15;
% extra filtering according to fitting residuals
if r_mask
    % generate reliability map
    fit_residual_blur = smooth3(fit_residual,'box',round(1./voxel_size)*2+1); 
    nii = make_nii(fit_residual_blur,voxel_size);
    save_nii(nii,'fit_residual_blur.nii');
    R = ones(size(fit_residual_blur));
    R(fit_residual_blur >= fit_thr) = 0;
else
    R = 1;
end


tfs = tfs/(2.675e8*3)*1e6; % unit ppm
smv_rad = 3;
tik_reg = 1e-4;
cgs_num = 500;
[lfs_resharp, mask_resharp] = resharp(tfs,mask.*R,voxel_size,smv_rad,tik_reg,cgs_num);

% save nifti
mkdir('RESHARP');
nii = make_nii(lfs_resharp,voxel_size);
save_nii(nii,['RESHARP/lfs_resharp_tik_', num2str(tik_reg), '_num_', num2str(cgs_num), '.nii']);

tv_reg = 5e-4;
z_prjs = [0 0 1];
inv_num = 500;

% inversion of susceptibility 
disp('--> TV susceptibility inversion on RESHARP...');
sus_resharp = tvdi(lfs_resharp,mask_resharp,voxel_size,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 

% save nifti
nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
save_nii(nii,['RESHARP/sus_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);



% single step QSM (eroded)
L2_sus_weight = 5e-4;
L2_lfs_weight = 0;
TV_weight = 3e-4;

[chi,res] = tfi_nlcg(tfs, mask_resharp, voxel_size, z_prjs, L2_sus_weight, L2_lfs_weight, TV_weight,mask_resharp.*mag(:,:,:,7));

nii = make_nii(chi.*mask.*R,voxel_size);
save_nii(nii,['chi_tfi_ero3_magW_sus_' num2str(L2_sus_weight) '_TV_' num2str(TV_weight) '.nii']);
nii = make_nii(res.*mask.*R,voxel_size);
save_nii(nii,['res_tfi_ero3_magW_sus_' num2str(L2_sus_weight) '_TV_' num2str(TV_weight) '.nii']);




% single step QSM (full brain)
L2_sus_weight = 1e-3;
L2_lfs_weight = 0;
TV_weight = 3e-4;

[chi,res] = tfi_nlcg(tfs, mask.*R, voxel_size, z_prjs, L2_sus_weight, L2_lfs_weight, TV_weight, mask.*R.*mag(:,:,:,7));

nii = make_nii(chi.*mask.*R,voxel_size);
save_nii(nii,['chi_tfi_full_magW_sus_' num2str(L2_sus_weight) '_TV_' num2str(TV_weight) '.nii']);
nii = make_nii(res.*mask.*R,voxel_size);
save_nii(nii,['res_tfi_full_magW_sus_' num2str(L2_sus_weight) '_TV_' num2str(TV_weight) '.nii']);




