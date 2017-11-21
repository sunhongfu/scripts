load('raw.mat', 'mag_corr')
load('raw.mat', 'ph_corr')
load('raw.mat', 'mask')
load('raw.mat', 'dicom_info')
load('raw.mat', 'vox')
load('raw.mat', 'TE')
load('raw.mat', 'z_prjs')
mag=mag_corr;
ph=ph_corr;
clear mag_corr ph_corr

mkdir LN-QSM
cd LN-QSM
% generate mask of soft tissue
mask_soft = mag(:,:,:,1) > max(mag(:))/20;
mask_soft = single(mask_soft);
nii = make_nii(mask_soft,vox);
save_nii(nii,'mask_soft.nii');

iField = mag.*exp(1i*ph);
if (~exist('noise_level','var'))
noise_level = calfieldnoise(iField, mask);
end
iField = iField/noise_level;
%%%% Generate the Magnitude image %%%%
iMag = sqrt(sum(abs(iField).^2,4));
nii = make_nii(iMag,vox);
save_nii(nii,'iMag.nii');
delta_TE = TE(2) - TE(1);
B0_dir = z_prjs';
CF = dicom_info.ImagingFrequency *1e6;
B0 = dicom_info.MagneticFieldStrength;
[iFreq_raw N_std] = Fit_ppm_complex(iField);
nii = make_nii(iFreq_raw,vox);
save_nii(nii,'iFreq_raw.nii');
nii = make_nii(N_std,vox);
save_nii(nii,'N_std.nii');
matrix_size = single(size(iFreq_raw));
% % replace laplacian with FUDGE? NO. FUDGE doesn't work
iFreq_lap = unwrapLaplacian(iFreq_raw, size(iFreq_raw), vox);
nii = make_nii(iFreq_lap,vox);
save_nii(nii,'iFreq_lap.nii');
tfs = -iFreq_lap/(2.675e8*B0*delta_TE*1e-6);


% pad 40 zeros
tfs_pad = padarray(tfs,[0 0 40]);
mask_soft_pad = padarray(mask_soft, [0 0 40]);
fit_mask = padarray(double(N_std<0.05),[0 0 40]).*mask_soft_pad;
mask_pad = padarray(mask,[0 0 40]).*fit_mask;


mask_skull_pad = ((mask_soft_pad - mask_pad) == 1);
mask_soft_pad = mask_pad + mask_skull_pad;
% mask_head_pad = MaskFilling(mask_soft_pad, 12);
% mask_air_pad = mask_head_pad - mask_soft_pad;
nii = make_nii(mask_pad,vox);
save_nii(nii,'mask_pad.nii');
nii = make_nii(mask_soft_pad,vox);
save_nii(nii,'mask_soft_pad.nii');

nii = make_nii(single(mask_skull_pad),vox);
save_nii(nii,'mask_skull_pad.nii');
% nii = make_nii(mask_air_pad,vox);
% save_nii(nii,'mask_air_pad.nii');
% nii = make_nii(mask_head_pad,vox);
% save_nii(nii,'mask_head_pad.nii');


Res_wt = padarray(iMag,[0 0 40]).*fit_mask;
Res_wt = Res_wt/sum(Res_wt(:))*sum(fit_mask(:));
nii = make_nii(Res_wt,vox);
save_nii(nii,'Res_wt.nii')
nii = make_nii(fit_mask,vox);
save_nii(nii,'fit_mask.nii');


clear iField iFreq_lap iFreq_raw mag ph iMag mask mask_soft N_std tfs


P = mask_soft_pad+ 30*(1 - mask_soft_pad);
chi_all_ss_500 = tikhonov_qsm(tfs_pad, Res_wt, 1, mask_soft_pad, mask_soft_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 500);
nii = make_nii(chi_all_ss_500,vox);
save_nii(nii,['chi_all_ss_1e-3_wt_fitmask_500.nii']);

chi_ero0_500 = tikhonov_qsm(tfs_pad, Res_wt, 1, mask_pad, mask_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 500);
nii = make_nii(chi_ero0_500,vox);
save_nii(nii,['chi_ero0_mm_1e-3_wt_fitmask_500.nii']);

P = mask_pad+ 30*(1 - mask_pad);
chi_ero0_masked_500 = tikhonov_qsm(tfs_pad, Res_wt.*mask_pad, 1, mask_pad, mask_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 500);
nii = make_nii(chi_ero0_masked_500,vox);
save_nii(nii,['chi_ero0_mm_1e-3_wt_fitmask_masked_500.nii']);


P = mask_soft_pad+ 30*(1 - mask_soft_pad);

% chi_all_hs_500 = tikhonov_qsm(tfs_pad, Res_wt, 1, mask_head_pad, mask_soft_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 500);
% nii = make_nii(chi_all_hs_500,vox);
% save_nii(nii,['chi_all_hs_1e-3_wt_fitmask_500.nii']);

chi_all_1s_500 = tikhonov_qsm(tfs_pad, Res_wt, 1, 1, mask_soft_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 500);
nii = make_nii(chi_all_1s_500,vox);
save_nii(nii,['chi_all_1s_500_1e-3_wt_fitmask_500.nii']);


