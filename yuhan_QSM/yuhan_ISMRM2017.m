load ../../data_info.mat
z_prjs = [0 0 1];
CF = 42.6036 *3 *1e6;

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

mkdir LN-QSM
cd LN-QSM

nii = make_nii(tfs,voxel_size);
save_nii(nii,'tfs.nii');


% extra filtering according to fitting residuals
% generate reliability map
fit_residual_blur = smooth3(fit_residual,'box',round(1./voxel_size)*2+1); 
nii = make_nii(fit_residual_blur,voxel_size);
save_nii(nii,'fit_residual_blur.nii');
R = ones(size(fit_residual_blur));
R(fit_residual_blur >= 10) = 0;


tfs = tfs/(2.675e8*3)*1e6; % unit ppm
nii = make_nii(tfs,voxel_size);
save_nii(nii,'tfs.nii');

vox = voxel_size;
matrix_size = single(size(tfs));
delta_TE = TE(2) - TE(1);
B0_dir = z_prjs';
iMag = sqrt(sum(mag.^2,4));
maskR = mask.*R;
Res_wt = iMag.*maskR;
Res_wt = Res_wt/sum(Res_wt(:))*sum(maskR(:));




%%%%%%%%%%%%%%%%%%%%%%%%% RESHARP %%%%%%%%%%%%%%%%%%%%%%%%%
tik_reg = 1e-4;
cgs_num = 200;

% for smv_rad = 2:3
for smv_rad = 2

[lfs_resharp, mask_resharp] = resharp(tfs,maskR,vox,smv_rad,tik_reg,cgs_num);
% % 3D 2nd order polyfit to remove any residual background
% lfs_resharp= lfs_resharp - poly3d(lfs_resharp,mask_resharp);

% save nifti
[~,~,~] = mkdir('RESHARP');
nii = make_nii(lfs_resharp,vox);
save_nii(nii,['RESHARP/lfs_resharp_tik_', num2str(tik_reg), '_smvrad_', num2str(smv_rad), '.nii']);

%%%%%%%%% TFI %%%%%%%%%
iFreq = lfs_resharp*CF*2*pi*delta_TE*1e-6;
N_std = 1;
Mask = mask_resharp;
Mask_G = Mask;
P_B = 30;
P = 1 * Mask + P_B * (1 - Mask);
RDF = 0;
save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF

% QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 1000);
% nii = make_nii(QSM.*Mask,vox);
% save_nii(nii,['RESHARP/TFI_resharp_lambda1000_smvrad' num2str(smv_rad) '.nii']);

QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 2000);
nii = make_nii(QSM.*Mask,vox);
save_nii(nii,['RESHARP/TFI_resharp_lambda2000_smvrad' num2str(smv_rad) '.nii']);


%%%%%%%%% LN-QSM %%%%%%%%%
P = mask_resharp + 30*(1 - mask_resharp);
LN_resharp_2000 = tikhonov_qsm(lfs_resharp, Res_wt.*mask_resharp, 1, mask_resharp, mask_resharp, 0, 4e-4, 0.001, 0, vox, P, z_prjs, 2000);
nii = make_nii(LN_resharp_2000.*mask_resharp,vox);
save_nii(nii,['RESHARP/LN_resharp_tik_1e-3_tv_4e-4_2000_smvrad_' num2str(smv_rad) '.nii']);

% LN_resharp_2000 = tikhonov_qsm(lfs_resharp, Res_wt.*mask_resharp, 1, mask_resharp, mask_resharp, 0, 1e-4, 0.001, 0, vox, P, z_prjs, 2000);
% nii = make_nii(LN_resharp_2000.*mask_resharp,vox);
% save_nii(nii,['RESHARP/LN_resharp_tik_1e-3_tv_1e-4_2000_smvrad_' num2str(smv_rad) '.nii']);

end






%%%%%%%%%%%%%%%%%%%%%%%%% TFI %%%%%%%%%%%%%%%%%%%%%%%%%
mkdir TFI
N_std = 1;
iFreq = tfs*CF*2*pi*delta_TE*1e-6;
% erode the mask (full mask to 3mm erosion)
% mask_erosion
r = 1;
[X,Y,Z] = ndgrid(-r:r,-r:r,-r:r);
h = (X.^2/r^2 + Y.^2/r^2 + Z.^2/r^2 <= 1);
ker = h/sum(h(:));
imsize = size(mask);
mask_tmp = convn(maskR,ker,'same');
mask_ero1 = zeros(imsize);
mask_ero1(mask_tmp > 0.999999) = 1; % no error tolerance
r = 2;
[X,Y,Z] = ndgrid(-r:r,-r:r,-r:r);
h = (X.^2/r^2 + Y.^2/r^2 + Z.^2/r^2 <= 1);
ker = h/sum(h(:));
imsize = size(mask);
mask_tmp = convn(maskR,ker,'same');
mask_ero2 = zeros(imsize);
mask_ero2(mask_tmp > 0.999999) = 1; % no error tolerance
r = 3;
[X,Y,Z] = ndgrid(-r:r,-r:r,-r:r);
h = (X.^2/r^2 + Y.^2/r^2 + Z.^2/r^2 <= 1);
ker = h/sum(h(:));
imsize = size(mask);
mask_tmp = convn(maskR,ker,'same');
mask_ero3 = zeros(imsize);
mask_ero3(mask_tmp > 0.999999) = 1; % no error tolerance


% Mask = maskR;
% Mask_G = Mask;
% P_B = 30;
% P = 1 * Mask + P_B * (1-Mask);
% RDF = 0;
% save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF


% % QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 1000);
% % nii = make_nii(QSM.*Mask,vox);
% % save_nii(nii,'TFI/TFI_ero0_lambda1000.nii');

% QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 2000);
% nii = make_nii(QSM.*Mask,vox);
% save_nii(nii,'TFI/TFI_ero0_lambda2000.nii');


Mask = mask_ero1;
Mask_G = Mask;
P_B = 30;
P = 1 * Mask + P_B * (1-Mask);
RDF = 0;
save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF

% QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 1000);
% nii = make_nii(QSM.*Mask,vox);
% save_nii(nii,'TFI/TFI_ero1_lambda1000.nii');

QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 2000);
nii = make_nii(QSM.*Mask,vox);
save_nii(nii,'TFI/TFI_ero1_lambda2000.nii');


% Mask = mask_ero2;
% Mask_G = Mask;
% P_B = 30;
% P = 1 * Mask + P_B * (1-Mask);
% RDF = 0;
% save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF

% % QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 1000);
% % nii = make_nii(QSM.*Mask,vox);
% % save_nii(nii,'TFI/TFI_ero2_lambda1000.nii');

% QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 2000);
% nii = make_nii(QSM.*Mask,vox);
% save_nii(nii,'TFI/TFI_ero2_lambda2000.nii');



% Mask = mask_ero3;
% Mask_G = Mask;
% P_B = 30;
% P = 1 * Mask + P_B * (1-Mask);
% RDF = 0;
% save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF

% % QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 1000);
% % nii = make_nii(QSM.*Mask,vox);
% % save_nii(nii,'TFI/TFI_ero3_lambda1000.nii');

% QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 2000);
% nii = make_nii(QSM.*Mask,vox);
% save_nii(nii,'TFI/TFI_ero3_lambda2000.nii');




%%%%%%%%%%%%%%%%%%%%%%%%% LN-QSM %%%%%%%%%%%%%%%%%%%%%%%%%
mkdir LN-QSM
% erode the mask (full mask to 3mm erosion)
% mask_erosion
r = 1;
[X,Y,Z] = ndgrid(-r:r,-r:r,-r:r);
h = (X.^2/r^2 + Y.^2/r^2 + Z.^2/r^2 <= 1);
ker = h/sum(h(:));
imsize = size(mask);
mask_tmp = convn(maskR,ker,'same');
mask_ero1 = zeros(imsize);
mask_ero1(mask_tmp > 0.999999) = 1; % no error tolerance
r = 2;
[X,Y,Z] = ndgrid(-r:r,-r:r,-r:r);
h = (X.^2/r^2 + Y.^2/r^2 + Z.^2/r^2 <= 1);
ker = h/sum(h(:));
imsize = size(mask);
mask_tmp = convn(maskR,ker,'same');
mask_ero2 = zeros(imsize);
mask_ero2(mask_tmp > 0.999999) = 1; % no error tolerance
r = 3;
[X,Y,Z] = ndgrid(-r:r,-r:r,-r:r);
h = (X.^2/r^2 + Y.^2/r^2 + Z.^2/r^2 <= 1);
ker = h/sum(h(:));
imsize = size(mask);
mask_tmp = convn(maskR,ker,'same');
mask_ero3 = zeros(imsize);
mask_ero3(mask_tmp > 0.999999) = 1; % no error tolerance


% P = maskR + 30*(1 - maskR);
% LN_ero0_2000 = tikhonov_qsm(tfs, Res_wt.*maskR, 1, maskR, maskR, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 2000);
% nii = make_nii(LN_ero0_2000.*maskR,vox);
% save_nii(nii,['LN-QSM/LN_ero0_tik_1e-3_tv_5e-4_2000.nii']);


P = mask_ero1 + 30*(1 - mask_ero1);
LN_ero1_2000 = tikhonov_qsm(tfs, Res_wt.*mask_ero1, 1, mask_ero1, mask_ero1, 0, 4e-4, 0.001, 0, vox, P, z_prjs, 2000);
nii = make_nii(LN_ero1_2000.*mask_ero1,vox);
save_nii(nii,['LN-QSM/LN_ero1_tik_1e-3_tv_4e-4_2000.nii']);


P = mask_ero2 + 30*(1 - mask_ero2);
LN_ero2_2000 = tikhonov_qsm(tfs, Res_wt.*mask_ero2, 1, mask_ero2, mask_ero2, 0, 4e-4, 0.001, 0, vox, P, z_prjs, 2000);
nii = make_nii(LN_ero2_2000.*mask_ero2,vox);
save_nii(nii,['LN-QSM/LN_ero2_tik_1e-3_tv_4e-4_2000.nii']);


% P = mask_ero3 + 30*(1 - mask_ero3);
% LN_ero3_2000 = tikhonov_qsm(tfs, Res_wt.*mask_ero3, 1, mask_ero3, mask_ero3, 0, 4e-4, 0.001, 0, vox, P, z_prjs, 2000);
% nii = make_nii(LN_ero3_2000.*mask_ero3,vox);
% save_nii(nii,['LN-QSM/LN_ero3_tik_1e-3_tv_4e-4_2000.nii']);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


























% %%%%%%%%%%%% two step QSM
% disp('--> RESHARP to remove background field ...');
% smv_rad = 3;
% tik_reg = 1e-4;
% cgs_num = 500;
% [lfs_resharp, mask_resharp] = resharp(tfs,mask.*R,voxel_size,smv_rad,tik_reg,cgs_num);

% nii = make_nii(lfs_resharp,voxel_size);
% save_nii(nii,['lfs_resharp_tik_', num2str(tik_reg), '_num_', num2str(cgs_num), '.nii']);

% disp('--> TV susceptibility inversion on RESHARP...');
% tv_reg = 1e-3;
% z_prjs = [0 0 1];
% inv_num = 1000;
% sus_resharp = tvdi(lfs_resharp,mask_resharp,voxel_size,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 

% % save nifti
% nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
% save_nii(nii,['sus_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);

% disp('--> TV susceptibility inversion on RESHARP...');
% tv_reg = 2e-3;
% z_prjs = [0 0 1];
% inv_num = 1000;
% sus_resharp = tvdi(lfs_resharp,mask_resharp,voxel_size,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 

% % save nifti
% nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
% save_nii(nii,['sus_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);

% disp('--> TV susceptibility inversion on RESHARP...');
% tv_reg = 3e-3;
% z_prjs = [0 0 1];
% inv_num = 1000;
% sus_resharp = tvdi(lfs_resharp,mask_resharp,voxel_size,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 

% % save nifti
% nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
% save_nii(nii,['sus_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);



% disp('--> TV susceptibility inversion on RESHARP...');
% tv_reg = 5e-3;
% z_prjs = [0 0 1];
% inv_num = 1000;
% sus_resharp = tvdi(lfs_resharp,mask_resharp,voxel_size,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 

% % save nifti
% nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
% save_nii(nii,['sus_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);




% disp('--> TV susceptibility inversion on RESHARP...');
% tv_reg = 6e-3;
% z_prjs = [0 0 1];
% inv_num = 1000;
% sus_resharp = tvdi(lfs_resharp,mask_resharp,voxel_size,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 

% % save nifti
% nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
% save_nii(nii,['sus_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);




% disp('--> TV susceptibility inversion on RESHARP...');
% tv_reg = 7e-3;
% z_prjs = [0 0 1];
% inv_num = 1000;
% sus_resharp = tvdi(lfs_resharp,mask_resharp,voxel_size,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 

% % save nifti
% nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
% save_nii(nii,['sus_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);


%%%%%%%%%%%% NEW single step QSM

% pad zeros
tfs = padarray(tfs,[0 0 20]);
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
[chi, res] = tikhonov_qsm(tfs, mask_ero.*R, 1, mask_ero.*R, mask_ero.*R, TV_weight, Tik_weight, voxel_size, z_prjs, 2000);
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

