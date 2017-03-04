
% (2) nlcg with TV
load all.mat
clearvars -except tfs mask voxel_size z_prjs R mask_resharp
z_prjs = [0 0 1]

mkdir TFI/TV

for L2_sus_weight = 0

        for L2_lfs_weight = 0

                for TV_weight = 3e-4

                        [chi,res] = tfi_nlcg(tfs, mask_resharp.*R, vox, z_prjs, L2_sus_weight, L2_lfs_weight, TV_weight);



                        nii = make_nii(chi.*mask,vox);
                        save_nii(nii,['TFI/TV/chi_tfi_ero_sus_' num2str(L2_sus_weight) '_lfs_' num2str(L2_lfs_weight) '_TV_' num2str(TV_weight) '.nii']);
                        nii = make_nii(res.*mask,vox);
                        save_nii(nii,['TFI/TV/res_tfi_ero_sus_' num2str(L2_sus_weight) '_lfs_' num2str(L2_lfs_weight) '_TV_' num2str(TV_weight) '.nii']);

                end
        end

end





load all.mat
())clearvars -except tfs mask vox z_prjs R mask_resharp


mkdir TFI/TV/paper

for L2_sus_weight = [0.001 0.0005]

        for L2_lfs_weight = 0

                for TV_weight = 3e-4

                        [chi,res] = tfi_nlcg(tfs, mask_resharp.*R, vox, z_prjs, L2_sus_weight, L2_lfs_weight, TV_weight);



                        nii = make_nii(chi.*mask_resharp,vox);
                        save_nii(nii,['TFI/TV/paper/chi_tfi_ero5_sus_' num2str(L2_sus_weight) '_lfs_' num2str(L2_lfs_weight) '_TV_' num2str(TV_weight) '.nii']);
                        nii = make_nii(res.*mask_resharp,vox);
                        save_nii(nii,['TFI/TV/paper/res_tfi_ero5_sus_' num2str(L2_sus_weight) '_lfs_' num2str(L2_lfs_weight) '_TV_' num2str(TV_weight) '.nii']);

                end
        end

end


[lfs_resharp, mask_resharp] = resharp(tfs,mask.*R,vox,1,100,cgs_num);

for L2_sus_weight = [0.005 0.01]

        for L2_lfs_weight = 0

                for TV_weight = 3e-4

                        [chi,res] = tfi_nlcg(tfs, mask_resharp.*R, vox, z_prjs, L2_sus_weight, L2_lfs_weight, TV_weight);



                        nii = make_nii(chi.*mask,vox);
                        save_nii(nii,['TFI/TV/paper/chi_tfi_full_sus_' num2str(L2_sus_weight) '_lfs_' num2str(L2_lfs_weight) '_TV_' num2str(TV_weight) '.nii']);
                        nii = make_nii(res.*mask,vox);
                        save_nii(nii,['TFI/TV/paper/res_tfi_full_sus_' num2str(L2_sus_weight) '_lfs_' num2str(L2_lfs_weight) '_TV_' num2str(TV_weight) '.nii']);

                end
        end

end




L2_sus_weight = 5e-4;
L2_lfs_weight = 0;
TV_weight = 3e-4;
[chi,res] = tfi_nlcg(tfs, mask_resharp.*R, vox, z_prjs, L2_sus_weight, L2_lfs_weight, TV_weight, mag(:,:,:,end));



nii = make_nii(chi.*mask,vox);
save_nii(nii,['TFI/TV/chi_tfi_ero5_magW_sus_' num2str(L2_sus_weight) '_lfs_' num2str(L2_lfs_weight) '_TV_' num2str(TV_weight) '.nii']);
nii = make_nii(res.*mask,vox);
save_nii(nii,['TFI/TV/res_tfi_ero5_magW_sus_' num2str(L2_sus_weight) '_lfs_' num2str(L2_lfs_weight) '_TV_' num2str(TV_weight) '.nii']);

