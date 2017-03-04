nii = load_nii('chi.nii');
chi = double(nii.img);

nii = load_nii('mask_brain.nii');
mask_brain = double(nii.img);

nii = load_nii('mask_head.nii');
mask_head = double(nii.img);

nii = load_nii('mask_tissue.nii');
mask_tissue = double(nii.img);

nii = load_nii('TFI_brain_ero0.nii');
tfi = double(nii.img);

nii = load_nii('TFI_tissue_ero0.nii');
tfi2 = double(nii.img);

nii = load_nii('TIK_tissue_ero0_TV_0.0002_Tik_0_PRE_2000.nii');
tik1 = double(nii.img);

nii = load_nii('TIK_tissue_ero0_TV_0.0002_Tik_1e-06_PRE_2000.nii');
tik2 = double(nii.img);


diff_tfi_head = (tfi-chi).*mask_head;
diff_tik1_head = (tik1-chi).*mask_head;
diff_tik2_head = (tik2-chi).*mask_head;

chi_mean = chi(logical(mask_tissue));
chi_mean = mean(chi_mean(:));
tfi_mean = tfi(logical(mask_tissue));
tfi_mean = mean(tfi_mean(:));
tfi2_mean = tfi2(logical(mask_tissue));
tfi2_mean = mean(tfi2_mean(:));
tik1_mean = tik1(logical(mask_tissue));
tik1_mean = mean(tik1_mean(:));
tik2_mean = tik2(logical(mask_tissue));
tik2_mean = mean(tik2_mean(:));

diff_tfi_tissue = (tfi-tfi_mean-chi+chi_mean).*mask_tissue;
diff_tfi2_tissue = (tfi2-tfi2_mean-chi+chi_mean).*mask_tissue;
diff_tik1_tissue = (tik1-tik1_mean-chi+chi_mean).*mask_tissue;
diff_tik2_tissue = (tik2-tik2_mean-chi+chi_mean).*mask_tissue;
nii = make_nii(diff_tfi_tissue);
save_nii(nii,'diff_tfi_tissue.nii');
nii = make_nii(diff_tfi2_tissue);
save_nii(nii,'diff_tfi2_tissue.nii');
nii = make_nii(diff_tik1_tissue);
save_nii(nii,'diff_tik1_tissue.nii');
nii = make_nii(diff_tik2_tissue);
save_nii(nii,'diff_tik2_tissue.nii');

rmse_tfi_tissue = sqrt(sum(diff_tfi_tissue(:).^2)/sum(mask_tissue(:)))
rmse_tfi2_tissue = sqrt(sum(diff_tfi2_tissue(:).^2)/sum(mask_tissue(:)))
rmse_tik1_tissue = sqrt(sum(diff_tik1_tissue(:).^2)/sum(mask_tissue(:)))
rmse_tik2_tissue = sqrt(sum(diff_tik2_tissue(:).^2)/sum(mask_tissue(:)))


diff_tfi_brain = (tfi-chi).*mask_brain;
diff_tik1_brain = (tik1-chi).*mask_brain;
diff_tik2_brain = (tik2-chi).*mask_brain;


chi_mean = chi(logical(mask_brain));
chi_mean = mean(chi_mean(:));
tfi_mean = tfi(logical(mask_brain));
tfi_mean = mean(tfi_mean(:));
tfi2_mean = tfi2(logical(mask_brain));
tfi2_mean = mean(tfi2_mean(:));
tik1_mean = tik1(logical(mask_brain));
tik1_mean = mean(tik1_mean(:));
tik2_mean = tik2(logical(mask_brain));
tik2_mean = mean(tik2_mean(:));

diff_tfi_brain = (tfi-tfi_mean-chi+chi_mean).*mask_brain;
diff_tfi2_brain = (tfi2-tfi2_mean-chi+chi_mean).*mask_brain;
diff_tik1_brain = (tik1-tik1_mean-chi+chi_mean).*mask_brain;
diff_tik2_brain = (tik2-tik2_mean-chi+chi_mean).*mask_brain;
nii = make_nii(diff_tfi_brain);
save_nii(nii,'diff_tfi_brain.nii');
nii = make_nii(diff_tik1_brain);
save_nii(nii,'diff_tik1_brain.nii');
nii = make_nii(diff_tik2_brain);
save_nii(nii,'diff_tik2_brain.nii');

rmse_tfi_brain = sqrt(sum(diff_tfi_brain(:).^2)/sum(mask_brain(:)))
rmse_tfi2_brain = sqrt(sum(diff_tfi2_brain(:).^2)/sum(mask_brain(:)))
rmse_tik1_brain = sqrt(sum(diff_tik1_brain(:).^2)/sum(mask_brain(:)))
rmse_tik2_brain = sqrt(sum(diff_tik2_brain(:).^2)/sum(mask_brain(:)))