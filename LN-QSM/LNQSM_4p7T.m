load all.mat

mkdir LN-QSM
cd LN-QSM

mag = abs(img_cmb);
ph = angle(img_cmb);

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


delta_TE = te(2) - te(1);
B0_dir = z_prjs';
% CF = dicom_info.ImagingFrequency *1e6;
B0 = 4.7;


[iFreq_raw N_std] = Fit_ppm_complex(iField);
nii = make_nii(iFreq_raw,vox);
save_nii(nii,'iFreq_raw.nii');
nii = make_nii(N_std,vox);
save_nii(nii,'N_std.nii');
matrix_size = single(size(iFreq_raw));

clear iField



% % replace laplacian with FUDGE? NO. FUDGE doesn't work
iFreq_lap = unwrapLaplacian(iFreq_raw, size(iFreq_raw), vox);
nii = make_nii(iFreq_lap,vox);
save_nii(nii,'iFreq_lap.nii');

tfs = iFreq_lap/(2.675e8*B0*delta_TE*1e-6);


clear iFreq_raw iFreq_lap
% no laplacian unwrapping
% laplacian unwrapping may suppress the air dipole?
% tfs = iFreq_gc/(2.675e8*B0*delta_TE*1e-6);

% pad 40 zeros
tfs_pad = padarray(tfs,[0 0 40]);
mask_pad = padarray(mask,[0 0 40]);
mask_soft_pad = padarray(mask_soft, [0 0 40]);
mask_skull_pad = ((mask_soft_pad - mask_pad) == 1);
mask_soft_pad = mask_pad + mask_skull_pad;
% mask_head_pad = MaskFilling(mask_soft_pad, 12);
mask_head = imfill3(mask_soft);
mask_head_pad = imfill3(mask_soft_pad);
mask_air_pad = mask_head_pad - mask_soft_pad;
nii = make_nii(mask_head_pad,vox);
save_nii(nii,'mask_head_pad.nii');
nii = make_nii(mask_soft_pad,vox);
save_nii(nii,'mask_soft_pad.nii');
nii = make_nii(single(mask_skull_pad),vox);
save_nii(nii,'mask_skull_pad.nii');
nii = make_nii(mask_air_pad,vox);
save_nii(nii,'mask_air_pad.nii');

save LNQSM.mat



%%%%%%% TFI
cd ..
mkdir TFI
cd TFI

voxel_size = vox;
iFreq = tfs*(2.675e8*B0*delta_TE*1e-6);

% Prepare for TFI (whole head)
Mask = mask_soft;
P_B = 30;
P = 1 * Mask + P_B * (1-Mask);
Mask_G = 1 * Mask + 1/P_B * (~Mask & mask_head);
% Mask_G = mask_head;
RDF = 0;

save RDF_wholehead.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq RDF Mask
save RDF_wholehead.mat P Mask_G -append 
QSM = TFI_L1('filename', 'RDF_wholehead.mat', 'lambda', 600*2);

nii = make_nii(QSM.*mask_head,vox);
save_nii(nii,'TFI_head.nii');

Mask = mask; % only brain tissue
Mask_G = Mask;
P_B = 30;
P = 1 * Mask + P_B * (1-Mask);
RDF = 0;
save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF
QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 600*2);
nii = make_nii(QSM.*Mask,vox);
save_nii(nii,'TFI_ero0_brain.nii');

cd ..

cd LN-QSM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



P = mask_soft_pad+ 30*(1 - mask_soft_pad);

fit_mask = padarray(double(N_std<0.05),[0 0 40]).*mask_soft_pad;

Res_wt = padarray(iMag,[0 0 40]).*fit_mask;
Res_wt = Res_wt/sum(Res_wt(:))*sum(fit_mask(:));
% Res_wt = Res_wt./mean(Res_wt(fit_mask>0));

nii = make_nii(Res_wt,vox);
save_nii(nii,'Res_wt.nii')
nii = make_nii(fit_mask,vox);
save_nii(nii,'fit_mask.nii');

mask_TV = 1 * mask_soft_pad + 1/30 * (~mask_soft_pad & mask_head_pad);

chi_all_hs_500_maskTV = tikhonov_qsm(tfs_pad, Res_wt, 1, mask_TV, mask_soft_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 500);
nii = make_nii(chi_all_hs_500_maskTV,vox);
save_nii(nii,['chi_all_hs_1e-3_wt_fitmask_500_maskTV.nii']);


mask_TV2 = 1 * mask_soft_pad + 1/30 * (~mask_soft_pad);
chi_all_hs_500_maskTV2 = tikhonov_qsm(tfs_pad, Res_wt, 1, mask_TV2, mask_soft_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 500);
nii = make_nii(chi_all_hs_500_maskTV2,vox);
save_nii(nii,['chi_all_hs_1e-3_wt_fitmask_500_maskTV2.nii']);


mask_TV3 = 1 * mask_soft_pad + 1/10 * (~mask_soft_pad);
chi_all_hs_500_maskTV3 = tikhonov_qsm(tfs_pad, Res_wt, 1, mask_TV3, mask_soft_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 500);
nii = make_nii(chi_all_hs_500_maskTV3,vox);
save_nii(nii,['chi_all_hs_1e-3_wt_fitmask_500_maskTV3.nii']);


mask_TV4 = 1 * mask_soft_pad + 1/5 * (~mask_soft_pad);
chi_all_hs_500_maskTV4 = tikhonov_qsm(tfs_pad, Res_wt, 1, mask_TV4, mask_soft_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 500);
nii = make_nii(chi_all_hs_500_maskTV4,vox);
save_nii(nii,['chi_all_hs_1e-3_wt_fitmask_500_maskTV4.nii']);


mask_TV5 = 1 * mask_soft_pad + 1/2 * (~mask_soft_pad);
chi_all_hs_500_maskTV5 = tikhonov_qsm(tfs_pad, Res_wt, 1, mask_TV5, mask_soft_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 500);
nii = make_nii(chi_all_hs_500_maskTV5,vox);
save_nii(nii,['chi_all_hs_1e-3_wt_fitmask_500_maskTV5.nii']);




