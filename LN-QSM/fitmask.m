%fitmask clean

load('all.mat','mag');
load('all.mat','vox');
load('all.mat','mask');
load('all.mat','ph');
load('all.mat','TE')
load('all.mat','z_prjs');
load('all.mat','dicom_info');

mkdir LN-QSM
cd LN-QSM
% generate mask of soft tissue
mask_soft = mag(:,:,:,1) > max(mag(:))/20;
mask_soft = single(mask_soft);
nii = make_nii(mask_soft,vox);
save_nii(nii,'mask_soft.nii');

iField = mag.*exp(1i*ph);
% iField = mag.*exp(1i*ph_corr);
clear mag ph

% iField = iField_correction(iField,vox);

if (~exist('noise_level','var'))
    noise_level = calfieldnoise(iField, mask);
end

iField = iField/noise_level;

%%%% Generate the Magnitude image %%%%
iMag = sqrt(sum(abs(iField).^2,4));
nii = make_nii(iMag,vox);
save_nii(nii,'iMag.nii');

% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% % may help to do a N4 correction on iMag
% 	nii = make_nii(iMag*10000,vox);
% 	save_nii(nii,['iMag.nii']);

% 	% N3 correction
% 	unix('nii2mnc iMag.nii iMag.mnc');
% 	unix('nu_correct iMag.mnc corr_iMag.mnc -V1.0 -distance 200');
% 	unix('mnc2nii corr_iMag.mnc corr_iMag.nii');

% 	nii = load_nii('corr_iMag.nii');
% 	iMag = double(nii.img)/10000;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%

delta_TE = TE(2) - TE(1);
B0_dir = z_prjs';
CF = dicom_info.ImagingFrequency *1e6;
B0 = dicom_info.MagneticFieldStrength;

% [wwater wfat wfreq wunwph_uf unwphw N_std] = spurs_gc(conj(iField),TE,CF,vox);
% nii = make_nii(wwater,vox);
% save_nii(nii,'wwater.nii');
% nii = make_nii(wfat,vox);
% save_nii(nii,'wfat.nii');
% nii = make_nii(wfreq,vox);
% save_nii(nii,'wfreq.nii');
% nii = make_nii(wunwph_uf,vox);
% save_nii(nii,'wunwph_uf.nii');
% nii = make_nii(unwphw,vox);
% save_nii(nii,'unwphw.nii');
% nii = make_nii(N_std,vox);
% save_nii(nii,'N_std.nii');


[iFreq_raw N_std] = Fit_ppm_complex(iField);
nii = make_nii(iFreq_raw,vox);
save_nii(nii,'iFreq_raw.nii');
nii = make_nii(N_std,vox);
save_nii(nii,'N_std.nii');
matrix_size = single(size(iFreq_raw));

clear iField

% iFreq_gc = unwrapping_gc(iFreq_raw,iMag,vox);
% tmp = iFreq_gc;
% idxs_try = [-5:5];
% for i = 1:length(idxs_try)
%     tmps(i) = abs(sum(col((tmp - 2*pi*idxs_try(i)).*mask)));
% end
% [~,idx_tmp] = min(tmps);
% idx_wrap = idxs_try(idx_tmp)
% iFreq_gc = tmp - 2*pi*idx_wrap;
% nii = make_nii(iFreq_gc,vox);
% save_nii(nii,'iFreq_unwrapping_gc.nii');


% % replace laplacian with FUDGE? NO. FUDGE doesn't work
iFreq_lap = unwrapLaplacian(iFreq_raw, size(iFreq_raw), vox);
nii = make_nii(iFreq_lap,vox);
save_nii(nii,'iFreq_lap.nii');
% % FUDGE
% iFreq_fudge = fudge(iFreq_raw);
% nii = make_nii(iFreq_fudge,vox);
% save_nii(nii,'iFreq_fudge.nii');
% % FUDGE NO GC
% iFreq_fudge_raw = fudge(iFreq_raw);
% nii = make_nii(iFreq_fudge_raw,vox);
% save_nii(nii,'iFreq_fudge_raw.nii');

tfs = iFreq_lap/(2.675e8*B0*delta_TE*1e-6);
% 7T
% tfs = -iFreq_lap/(2.675e8*B0*delta_TE*1e-6);

clear iFreq_raw iFreq_lap
% no laplacian unwrapping
% laplacian unwrapping may suppress the air dipole?
% tfs = iFreq_gc/(2.675e8*B0*delta_TE*1e-6);

% pad 40 zeros
tfs_pad = padarray(tfs,[0 0 40]);
mask_pad = padarray(mask,[0 0 40]);
mask_soft_pad = padarray(mask_soft, [0 0 40]);
% mask_head_pad = padarray(mask_head, [0 0 40]);
% mask_air_pad=mask_head_pad-mask_soft_pad;
mask_skull_pad = ((mask_soft_pad - mask_pad) == 1);
mask_soft_pad = mask_pad + mask_skull_pad;
mask_head_pad = MaskFilling(mask_soft_pad, 12);
mask_air_pad = mask_head_pad - mask_soft_pad;
nii = make_nii(mask_head_pad,vox);
save_nii(nii,'mask_head_pad.nii');
nii = make_nii(mask_soft_pad,vox);
save_nii(nii,'mask_soft_pad.nii');
nii = make_nii(single(mask_skull_pad),vox);
save_nii(nii,'mask_skull_pad.nii');
nii = make_nii(mask_air_pad,vox);
save_nii(nii,'mask_air_pad.nii');


% unix('bet2 iMag.nii BET -f 0.5 -m');
% unix('gunzip -f BET.nii.gz');
% unix('gunzip -f BET_mask.nii.gz');
% nii = load_nii('BET_mask.nii');
% mask = double(nii.img);


P = mask_soft_pad+ 30*(1 - mask_soft_pad);

fit_mask = padarray(double(N_std<0.015),[0 0 40]).*mask_soft_pad;

% % for 7T
% fit_mask = padarray(double(N_std<0.05),[0 0 40]).*mask_soft_pad;

% % for 4.7T
% N_std = N_std*1e6;
% fit_mask = padarray(double(N_std<8),[0 0 40]).*mask_soft_pad;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mkdir wt_mag_NOmask
cd wt_mag_NOmask
Res_wt = iMag./mean(iMag(mask>0));
Res_wt = padarray(Res_wt,[0 0 40]);
nii = make_nii(Res_wt,vox);
save_nii(nii,'Res_wt.nii')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Res_wt = padarray(iMag,[0 0 40]).*fit_mask;
Res_wt = Res_wt/sum(Res_wt(:))*sum(fit_mask(:));
% Res_wt = Res_wt./mean(Res_wt(fit_mask>0));

nii = make_nii(Res_wt,vox);
save_nii(nii,'Res_wt.nii')
nii = make_nii(fit_mask,vox);
save_nii(nii,'fit_mask.nii');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
chi_all_ss_100 = tikhonov_qsm(tfs_pad, Res_wt, 1, mask_soft_pad, mask_soft_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 100);
nii = make_nii(chi_all_ss_100,vox);
save_nii(nii,['chi_all_ss_1e-3_wt_fitmask_100.nii']);

chi_all_ss_300 = tikhonov_qsm(tfs_pad, Res_wt, 1, mask_soft_pad, mask_soft_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 300);
nii = make_nii(chi_all_ss_300,vox);
save_nii(nii,['chi_all_ss_1e-3_wt_fitmask_300.nii']);

chi_all_ss_500 = tikhonov_qsm(tfs_pad, Res_wt, 1, mask_soft_pad, mask_soft_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 500);
nii = make_nii(chi_all_ss_500,vox);
save_nii(nii,['chi_all_ss_1e-3_wt_fitmask_500.nii']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
chi_ero0_100 = tikhonov_qsm(tfs_pad, Res_wt, 1, mask_pad, mask_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 100);
nii = make_nii(chi_ero0_100,vox);
save_nii(nii,['chi_ero0_mm_1e-3_wt_fitmask_100.nii']);

chi_ero0_300 = tikhonov_qsm(tfs_pad, Res_wt, 1, mask_pad, mask_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 300);
nii = make_nii(chi_ero0_300,vox);
save_nii(nii,['chi_ero0_mm_1e-3_wt_fitmask_300.nii']);

chi_ero0_500 = tikhonov_qsm(tfs_pad, Res_wt, 1, mask_pad, mask_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 500);
nii = make_nii(chi_ero0_500,vox);
save_nii(nii,['chi_ero0_mm_1e-3_wt_fitmask_500.nii']);

% P = mask_pad+ 30*(1 - mask_pad);
% chi_ero0_500 = tikhonov_qsm(tfs_pad, Res_wt, 1, mask_pad, mask_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 500);
% nii = make_nii(chi_ero0_500,vox);
% save_nii(nii,['chi_ero0_mm_1e-3_wt_fitmask_500_Pmask.nii']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P = mask_pad+ 30*(1 - mask_pad);
chi_ero0_masked_100 = tikhonov_qsm(tfs_pad, Res_wt.*mask_pad, 1, mask_pad, mask_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 100);
nii = make_nii(chi_ero0_masked_100,vox);
save_nii(nii,['chi_ero0_mm_1e-3_wt_fitmask_masked_100.nii']);

chi_ero0_masked_300 = tikhonov_qsm(tfs_pad, Res_wt.*mask_pad, 1, mask_pad, mask_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 300);
nii = make_nii(chi_ero0_masked_300,vox);
save_nii(nii,['chi_ero0_mm_1e-3_wt_fitmask_masked_300.nii']);

chi_ero0_masked_500 = tikhonov_qsm(tfs_pad, Res_wt.*mask_pad, 1, mask_pad, mask_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 500);
nii = make_nii(chi_ero0_masked_500,vox);
save_nii(nii,['chi_ero0_mm_1e-3_wt_fitmask_masked_500.nii']);

% chi_ero0_masked_500 = tikhonov_qsm(tfs_pad, Res_wt.*mask_pad, 1, mask_pad.*fit_mask, mask_pad.*fit_mask, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 500);
% nii = make_nii(chi_ero0_masked_500,vox);
% save_nii(nii,['chi_ero0_mm_1e-3_wt_fitmask_masked_500_new.nii']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P = mask_soft_pad+ 30*(1 - mask_soft_pad);

chi_all_hs_100 = tikhonov_qsm(tfs_pad, Res_wt, 1, mask_head_pad, mask_soft_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 100);
nii = make_nii(chi_all_hs_100,vox);
save_nii(nii,['chi_all_hs_1e-3_wt_fitmask_100.nii']);

chi_all_hs_300 = tikhonov_qsm(tfs_pad, Res_wt, 1, mask_head_pad, mask_soft_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 300);
nii = make_nii(chi_all_hs_300,vox);
save_nii(nii,['chi_all_hs_1e-3_wt_fitmask_300.nii']);

chi_all_hs_500 = tikhonov_qsm(tfs_pad, Res_wt, 1, mask_head_pad, mask_soft_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 500);
nii = make_nii(chi_all_hs_500,vox);
save_nii(nii,['chi_all_hs_1e-3_wt_fitmask_500.nii']);


chi_all_1s_500 = tikhonov_qsm(tfs_pad, Res_wt, 1, 1, mask_soft_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 500);
nii = make_nii(chi_all_1s_500,vox);
save_nii(nii,['chi_all_1s_500_1e-3_wt_fitmask_500.nii']);


%%%
% let P match exactly the non-zero of Res_wt

