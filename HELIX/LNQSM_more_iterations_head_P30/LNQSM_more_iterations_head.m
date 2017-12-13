function LNQSM_more_iterations_head(subject_folder)

cd(subject_folder);
load LNQSM.mat


P = mask_soft_pad+ 30*(1 - mask_soft_pad);
% P = 1;

fit_mask = padarray(double(N_std<0.015),[0 0 40]).*mask_soft_pad;

mask_TV = 1 * mask_soft_pad + 1/30 * (~mask_soft_pad & mask_head_pad);

Res_wt = padarray(iMag,[0 0 40]).*fit_mask;
Res_wt = Res_wt/sum(Res_wt(:))*sum(fit_mask(:));
% Res_wt = Res_wt./mean(Res_wt(fit_mask>0));


chi_all_hs_2000_maskTV = tikhonov_qsm(tfs_pad, Res_wt, 1, mask_TV, mask_soft_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 2000);
nii = make_nii(chi_all_hs_2000_maskTV,vox);
save_nii(nii,['chi_all_hs_1e-3_wt_fitmask_2000_maskTV_P30.nii']);



chi_all_hs_5000_maskTV = tikhonov_qsm(tfs_pad, Res_wt, 1, mask_TV, mask_soft_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 5000);
nii = make_nii(chi_all_hs_5000_maskTV,vox);
save_nii(nii,['chi_all_hs_1e-3_wt_fitmask_5000_maskTV_P30.nii']);

