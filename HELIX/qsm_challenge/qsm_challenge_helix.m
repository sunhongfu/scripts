function qsm_challenge_helix(Tik_weight, TV_weight)

Tik_weight = str2num(Tik_weight);
TV_weight = str2num(TV_weight);

load('/home/hongfu.sun/data/qsm_challenge/all.mat');
vox = spatial_res;
z_prjs = [0 0 1];

%%%% TIK-QSM
%mkdir LN-QSM
%cd LN-QSM
% tfs_pad = padarray(field,[0 0 20]);
% mask_pad = padarray(mask_tissue,[0 0 20]);
% mask_head_pad = padarray(mask_head,[0 0 20]);
% mask_brain_pad = padarray(mask_brain,[0 0 20]);
iFreq = phs_unwrap;
tfs = iFreq/(2*pi*42.58*3*25e-3);
tfs_pad = padarray(tfs,[20 20 20]);
mask_tissue_pad = padarray(msk,[20 20 20]);;

P_pad = 1 * mask_tissue_pad + 30 * (1 - mask_tissue_pad);

%Tik_weight = [0, 5e-4, 1e-3];
% Tik_weight = [1e-3, 0];
%TV_weight = [1e-4, 2e-4, 5e-4];
for i = 1:length(Tik_weight)
	        for j = 1:length(TV_weight)
			                chi = tikhonov_qsm(tfs_pad, mask_tissue_pad, 1, mask_tissue_pad, mask_tissue_pad, 0, TV_weight(j), Tik_weight(i), 0, vox, P_pad, z_prjs, 5000);
					                nii = make_nii(chi(21:end-20,21:end-20,21:end-20).*msk,vox);
							                % nii = make_nii(chi,vox);
									                save_nii(nii,['TIK_ss_TV_' num2str(TV_weight(j)) '_Tik_' num2str(Tik_weight(i)) '_P30_5000.nii']);
											        end
											end
											cd ..


