function WH_LNQSM_helix(Tik_weight,TV_weight)

TV_weight = str2num(TV_weight);
Tik_weight = str2num(Tik_weight);

load('/home/hongfu.sun/data/WH_LNQSM/all.mat');


tfs = iFreq/(2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6);

% pad 20 zeros
tfs_pad = padarray(tfs,[0 0 20]);
mask_soft_pad = padarray(mask_soft, [0 0 20]);
mask_head_pad = padarray(mask_head, [0 0 20]);
tfs_pad = tfs_pad.*mask_soft_pad;

r = 0;
% P = 60*(mask_head_pad - mask_soft_pad) + mask_soft_pad;
P = 60*(mask_head_pad - mask_soft_pad) + 1 - (mask_head_pad - mask_soft_pad);
% P = 1./P;
% P = 1;
chi = tikhonov_qsm(tfs_pad, mask_soft_pad, 1, mask_head_pad, mask_soft_pad, 0, TV_weight, Tik_weight, 0, vox, P, z_prjs, 300);

cd /home/hongfu.sun/data/WH_LNQSM

nii = make_nii(chi,vox);
save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight) '_soft_1_head_soft_300_outside1.nii']);
