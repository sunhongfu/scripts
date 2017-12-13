function LNQSM_more_iterations_brain(subject_folder)

cd(subject_folder);
load LNQSM.mat


fit_mask = padarray(double(N_std<0.015),[0 0 40]).*mask_soft_pad;
Res_wt = padarray(iMag,[0 0 40]).*fit_mask;
Res_wt = Res_wt/sum(Res_wt(:))*sum(fit_mask(:));
% Res_wt = Res_wt./mean(Res_wt(fit_mask>0));

%P = mask_pad+ 30*(1 - mask_pad);
P = 1;
% chi_ero0_masked_100 = tikhonov_qsm(tfs_pad, Res_wt.*mask_pad, 1, mask_pad, mask_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 100);
% nii = make_nii(chi_ero0_masked_100,vox);
% save_nii(nii,['chi_ero0_mm_1e-3_wt_fitmask_masked_100.nii']);

% chi_ero0_masked_300 = tikhonov_qsm(tfs_pad, Res_wt.*mask_pad, 1, mask_pad, mask_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 300);
% nii = make_nii(chi_ero0_masked_300,vox);
% save_nii(nii,['chi_ero0_mm_1e-3_wt_fitmask_masked_300.nii']);

chi_ero0_masked_2000 = tikhonov_qsm(tfs_pad, Res_wt.*mask_pad, 1, mask_pad, mask_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 2000);
nii = make_nii(chi_ero0_masked_2000,vox);
save_nii(nii,['chi_ero0_mm_1e-3_wt_fitmask_masked_2000_P1.nii']);

chi_ero0_masked_5000 = tikhonov_qsm(tfs_pad, Res_wt.*mask_pad, 1, mask_pad, mask_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 5000);
nii = make_nii(chi_ero0_masked_5000,vox);
save_nii(nii,['chi_ero0_mm_1e-3_wt_fitmask_masked_5000_P1.nii']);

