load ../../data_info.mat

for i = 2:7
	nii = load_nii(['phase_e' num2str(i) '_prelude.nii']);
	ph(:,:,:,i-1) = double(nii.img);
	nii = load_nii(['mag_e' num2str(i) '.nii']);
	mag(:,:,:,i-1) = double(nii.img);
end


nii = load_nii('brain_bet2_hr_mask.nii');
mask = single(nii.img);

ph_diff = ph(:,:,:,2)-ph(:,:,:,1);

for echo = 2:6
    meandiff = ph(:,:,:,echo)-ph(:,:,:,1)-double(echo-1)*ph_diff;
    meandiff = meandiff(mask==1);
    meandiff = mean(meandiff(:))
    njump = round(meandiff/(2*pi))
    disp(['    ' num2str(njump) ' 2pi jumps for TE' num2str(echo)]);
    ph(:,:,:,echo) = ph(:,:,:,echo) - njump*2*pi;
    ph(:,:,:,echo) = ph(:,:,:,echo).*mask;
end




TE = TE - TE(1);
TE = TE(2:7);

[tfs, fit_residual] = echofit(ph,mag,TE);

mkdir new
cd new

nii = make_nii(tfs,voxel_size);
save_nii(nii,'tfs.nii');


% extra filtering according to fitting residuals
% generate reliability map
fit_residual_blur = smooth3(fit_residual,'box',round(1./voxel_size)*2+1); 
nii = make_nii(fit_residual_blur,voxel_size);
save_nii(nii,'fit_residual_blur.nii');
R = ones(size(fit_residual_blur));
R(fit_residual_blur >= 10) = 0;


tfs_norm = tfs/(2.675e8*3)*1e6; % unit ppm
nii = make_nii(tfs_norm,voxel_size);
save_nii(nii,'tfs_norm.nii');




%%%%%%%%%%%% two step QSM
disp('--> RESHARP to remove background field ...');
smv_rad = 3;
tik_reg = 1e-4;
cgs_num = 500;
[lfs_resharp, mask_resharp] = resharp(tfs_norm,mask.*R,voxel_size,smv_rad,tik_reg,cgs_num);

nii = make_nii(lfs_resharp,voxel_size);
save_nii(nii,['lfs_resharp_tik_', num2str(tik_reg), '_num_', num2str(cgs_num), '.nii']);

disp('--> TV susceptibility inversion on RESHARP...');
tv_reg = 1e-3;
z_prjs = [0 0 1];
inv_num = 1000;
sus_resharp = tvdi(lfs_resharp,mask_resharp,voxel_size,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 

% save nifti
nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
save_nii(nii,['sus_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);

disp('--> TV susceptibility inversion on RESHARP...');
tv_reg = 2e-3;
z_prjs = [0 0 1];
inv_num = 1000;
sus_resharp = tvdi(lfs_resharp,mask_resharp,voxel_size,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 

% save nifti
nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
save_nii(nii,['sus_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);

disp('--> TV susceptibility inversion on RESHARP...');
tv_reg = 3e-3;
z_prjs = [0 0 1];
inv_num = 1000;
sus_resharp = tvdi(lfs_resharp,mask_resharp,voxel_size,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 

% save nifti
nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
save_nii(nii,['sus_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);



disp('--> TV susceptibility inversion on RESHARP...');
tv_reg = 5e-3;
z_prjs = [0 0 1];
inv_num = 1000;
sus_resharp = tvdi(lfs_resharp,mask_resharp,voxel_size,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 

% save nifti
nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
save_nii(nii,['sus_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);




disp('--> TV susceptibility inversion on RESHARP...');
tv_reg = 6e-3;
z_prjs = [0 0 1];
inv_num = 1000;
sus_resharp = tvdi(lfs_resharp,mask_resharp,voxel_size,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 

% save nifti
nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
save_nii(nii,['sus_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);




disp('--> TV susceptibility inversion on RESHARP...');
tv_reg = 7e-3;
z_prjs = [0 0 1];
inv_num = 1000;
sus_resharp = tvdi(lfs_resharp,mask_resharp,voxel_size,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 

% save nifti
nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
save_nii(nii,['sus_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);


%%%%%%%%%%%% NEW single step QSM

% pad zeros
tfs_norm = padarray(tfs_norm,[0 0 20]);
mask = padarray(mask,[0 0 20]);
R = padarray(R,[0 0 20]);

for r = 1

[X,Y,Z] = ndgrid(-r:r,-r:r,-r:r);
h = (X.^2/r^2 + Y.^2/r^2 + Z.^2/r^2 <= 1);
ker = h/sum(h(:));
imsize = size(mask);
mask_tmp = convn(mask.*R,ker,'same');
mask_ero = zeros(imsize);
mask_ero(mask_tmp > 0.999999) = 1; % no error tolerance

% try total field inversion on regular mask, regular prelude
Tik_weight = 0.001;
TV_weight = 5e-4;
z_prjs = [0 0 1];
[chi, res] = tikhonov_qsm(tfs_norm, mask_ero.*R, 1, mask_ero.*R, mask_ero.*R, TV_weight, Tik_weight, voxel_size, z_prjs, 2000);
nii = make_nii(chi(:,:,21:end-20).*mask_ero(:,:,21:end-20).*R(:,:,21:end-20),voxel_size);
save_nii(nii,['chi_brain_pad20_ero' num2str(r) '_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '_2000.nii']);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% complex fitting
nii = load_nii('ph_fitted_prelude.nii');
tfs_cpx = double(nii.img);
tfs_cpx_norm = -tfs_cpx/(2.675e8*3)*1e6/(TE(2)-TE(1));

disp('--> RESHARP to remove background field ...');
smv_rad = 3;
tik_reg = 1e-4;
cgs_num = 500;
[lfs_cpx_resharp, mask_resharp] = resharp(tfs_cpx_norm,mask.*R,voxel_size,smv_rad,tik_reg,cgs_num);

nii = make_nii(lfs_cpx_resharp,voxel_size);
save_nii(nii,['lfs_cpx_resharp_tik_', num2str(tik_reg), '_num_', num2str(cgs_num), '.nii']);


disp('--> TV susceptibility inversion on RESHARP...');
tv_reg = 6e-3;
z_prjs = [0 0 1];
inv_num = 1000;
sus_cpx_resharp = tvdi(lfs_cpx_resharp,mask_resharp,voxel_size,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 

% save nifti
nii = make_nii(sus_cpx_resharp.*mask_resharp,voxel_size);
save_nii(nii,['sus_cpx_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);





%% tik-qsm
%%%%%%%%%%%% NEW single step QSM

% pad zeros
tfs_cpx_norm = padarray(tfs_cpx_norm,[0 0 20]);
mask = padarray(mask,[0 0 20]);
R = padarray(R,[0 0 20]);

for r = [2 ] 

[X,Y,Z] = ndgrid(-r:r,-r:r,-r:r);
h = (X.^2/r^2 + Y.^2/r^2 + Z.^2/r^2 <= 1);
ker = h/sum(h(:));
imsize = size(mask);
mask_tmp = convn(mask,ker,'same');
mask_ero = zeros(imsize);
mask_ero(mask_tmp > 1-1/sum(h(:))) = 1; % no error tolerance

% try total field inversion on regular mask, regular prelude
Tik_weight = 0.005;
TV_weight = 0.008;
z_prjs = [0 0 1];
[chi, res] = tikhonov_qsm(tfs_cpx_norm, mask_ero.*R, 1, mask_ero.*R, mask_ero.*R, TV_weight, Tik_weight, voxel_size, z_prjs, 2000);
nii = make_nii(chi(:,:,21:end-20).*mask_ero(:,:,21:end-20).*R(:,:,21:end-20),voxel_size);
save_nii(nii,['chi__cpx_brain_pad20_ero' num2str(r) '_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '_2000.nii']);

end

