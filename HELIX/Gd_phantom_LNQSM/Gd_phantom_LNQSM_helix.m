function Gd_phantom_LNQSM_helix(Tik_weight, TV_weight)

Tik_weight = str2num(Tik_weight);
TV_weight = str2num(TV_weight);

load('/home/hongfu.sun/data/Gd_phantom/all_prelude_2echoes.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fit_mask = mask.*R;
%P = fit_mask + 30*(1 - fit_mask);
P = 1;

Res_wt = sqrt(sum(mag.^2,4)).*fit_mask;
Res_wt = Res_wt/sum(Res_wt(:))*sum(fit_mask(:));

r=0;
% Tik_weight = [1e-3, 0, 1e-4];
% TV_weight = [5e-4,1e-3];
for i = 1:length(Tik_weight)
for j = 1:length(TV_weight)
chi = tikhonov_qsm(tfs, Res_wt, 1, fit_mask, fit_mask, 0, TV_weight(j), Tik_weight(i), 0, vox, P, z_prjs, 2000);
nii = make_nii(chi.*fit_mask,vox);
save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight(j)) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);

% chi = tikhonov_qsm(tfs, fit_mask, 1, fit_mask, fit_mask, 0, TV_weight(j), Tik_weight(i), 0, vox, P, z_prjs, 2000);
% nii = make_nii(chi.*fit_mask,vox);
% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000_noWt.nii']);
end
end

