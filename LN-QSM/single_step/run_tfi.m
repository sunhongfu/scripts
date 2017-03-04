% script to run tfi.m with different alpha and beta parameters

% (1) cgs without TV
load all.mat
clearvars -except tfs mask vox z_prjs R

mkdir TFI

for L2_sus_weight = [0.005, 0.01, 0.05]

	for L2_lfs_weight = [0, 0.0005, 0.001, 0.005, 0.01, 0.05, 0.1]

		chi = tfi_cgs(tfs, mask.*R, vox, z_prjs, L2_sus_weight, L2_lfs_weight);

		nii = make_nii(chi.*mask,vox);
		save_nii(nii,['TFI/chi_tfi_sus_' num2str(L2_sus_weight) '_lfs_' num2str(L2_lfs_weight) '.nii']);

	end

end



% (2) nlcg with TV
load all.mat
clearvars -except tfs mask vox z_prjs R mask_resharp

mkdir TFI/TV

for L2_sus_weight = 0

	for L2_lfs_weight = 0

		for TV_weight = 5e-4

			[chi,res] = tfi_nlcg(tfs, mask_resharp.*R, vox, z_prjs, L2_sus_weight, L2_lfs_weight, TV_weight);

		

			nii = make_nii(chi.*mask_resharp,vox);
			save_nii(nii,['TFI/TV/chi_tfi_ero_sus_' num2str(L2_sus_weight) '_lfs_' num2str(L2_lfs_weight) '_TV_' num2str(TV_weight) '.nii']);
			nii = make_nii(res.*mask_resharp,vox);
			save_nii(nii,['TFI/TV/res_tfi_ero_sus_' num2str(L2_sus_weight) '_lfs_' num2str(L2_lfs_weight) '_TV_' num2str(TV_weight) '.nii']);

		end	
	end

end
