

% erode the original mask 2 voxels
r = 2;

[X,Y,Z] = ndgrid(-r:r,-r:r,-r:r);
h = (X.^2/r^2 + Y.^2/r^2 + Z.^2/r^2 <= 1);
ker = h/sum(h(:));
imsize = size(mask);
mask_tmp = convn(mask,ker,'same');
mask_ero = zeros(imsize);
mask_ero(mask_tmp > 1-1/sum(h(:))) = 1; % no error tolerance

% PDF + inv
lfs_pdf = projectionontodipolefields(tfs,mask_ero,vox,mask_ero,z_prjs);

% inversion of only TV
% save nifti
mkdir('PDF');
nii = make_nii(lfs_pdf,vox);
save_nii(nii,'PDF/lfs_pdf.nii');

Tik_weight = 0;
TV_weight = 3e-3;
[chi, res] = tfi_nlcg(lfs_pdf, mask_ero.*R, 1, 0, 1, Tik_weight, TV_weight, vox, z_prjs, 200);
nii = make_nii(chi.*mask_ero.*R,vox);
save_nii(nii,['PDF/chi_pdf_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '_200.nii']);

Tik_weight = 0;
TV_weight = 3e-3;
[chi, res] = tfi_nlcg(lfs_pdf, mask_ero.*R, mask_ero.*R, 0, mask_ero.*R, Tik_weight, TV_weight, vox, z_prjs, 200);
nii = make_nii(chi.*mask_ero.*R,vox);
save_nii(nii,['PDF/chi_pdf_force_insidemask_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '_200.nii']);

% RESHARP + inv
[lfs_resharp, mask_resharp_ero5] = resharp(tfs,mask,vox,7,5e-4,200);
mkdir('RESHARP');
nii = make_nii(lfs_resharp,vox);
save_nii(nii,'RESHARP/lfs_resharp_ero5_tik5e-4.nii');

Tik_weight = 0;
TV_weight = 3e-3;
[chi, res] = tfi_nlcg(lfs_resharp, mask_resharp_ero5.*R, 1, 0, 1, Tik_weight, TV_weight, vox, z_prjs, 200);
nii = make_nii(chi.*mask_resharp_ero5.*R,vox);
save_nii(nii,['RESHARP/chi_resharp_ero5_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '_200.nii']);

Tik_weight = 0;
TV_weight = 3e-3;
[chi, res] = tfi_nlcg(lfs_resharp, mask_resharp_ero5.*R, mask_resharp_ero5.*R, 0, mask_resharp_ero5.*R, Tik_weight, TV_weight, vox, z_prjs, 200);
nii = make_nii(chi.*mask_resharp_ero5.*R,vox);
save_nii(nii,['RESHARP/chi_resharp_ero5_force_insidemask_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '_200.nii']);



% different erosions of masks for brain tissue 
% for r = [2 7 10]

% pad zeros
tfs = padarray(tfs,[0 0 20]);
mask = padarray(mask,[0 0 20]);
R = padarray(R,[0 0 20]);

for r = [2 7] 

[X,Y,Z] = ndgrid(-r:r,-r:r,-r:r);
h = (X.^2/r^2 + Y.^2/r^2 + Z.^2/r^2 <= 1);
ker = h/sum(h(:));
imsize = size(mask);
mask_tmp = convn(mask,ker,'same');
mask_ero = zeros(imsize);
mask_ero(mask_tmp > 1-1/sum(h(:))) = 1; % no error tolerance

% try total field inversion on regular mask, regular prelude
Tik_weight = 0.008;
TV_weight = 3e-3;
[chi, res] = tfi_nlcg(tfs, mask_ero.*R, 1, mask_ero.*R, mask_ero.*R, Tik_weight, TV_weight, vox, z_prjs, 2000);
nii = make_nii(chi(:,:,21:end-20).*mask_ero(:,:,21:end-20).*R(:,:,21:end-20),vox);
save_nii(nii,['chi_brain_pad20_ero' num2str(r) '_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '_2000.nii']);

end






% different values of Tik_reg for L curve
mkdir L-curve
for TV_weight = [0 1e-6, 5e-6, 1e-5, 5e-5, 1e-4]
	for Tik_weight = [0 1e-6, 5e-6, 1e-5, 5e-5, 1e-4, 5e-4, 1e-3, 5e-3, 1e-2, 5e-2, 1e-1]
		[chi, res] = tfi_nlcg(tfs, mask.*R, 1, mask.*R, mask.*R, Tik_weight, TV_weight, vox, z_prjs, 200);
		nii = make_nii(chi,vox);
		save_nii(nii,['L-curve/chi_brain_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '.nii']);
	end
end



for TV_weight = [5e-4, 1e-3, 5e-3, 1e-2, 5e-2, 1e-1]
	for Tik_weight = [0 1e-6, 5e-6, 1e-5, 5e-5, 1e-4, 5e-4, 1e-3, 5e-3, 1e-2, 5e-2, 1e-1]
		[chi, res] = tfi_nlcg(tfs, mask.*R, 1, mask.*R, mask.*R, Tik_weight, TV_weight, vox, z_prjs, 200);
		nii = make_nii(chi,vox);
		save_nii(nii,['L-curve/chi_brain_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '.nii']);
	end
end



for TV_weight = 0.005
	for Tik_weight = [1 5 10]
		[chi, res] = tfi_nlcg(tfs, mask.*R, 1, mask.*R, mask.*R, Tik_weight, TV_weight, vox, z_prjs, 200);
		nii = make_nii(chi,vox);
		save_nii(nii,['L-curve/chi_brain_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '.nii']);
	end
end




% EPI
load all

% try total field inversion on regular mask, regular prelude
Tik_weight = 0.01;
TV_weight = 5e-4;
tfs_poly2d= tfs - poly2d(tfs,mask_ero);
tfs_poly3d= tfs - poly3d(tfs,mask_ero);

[chi, res] = tfi_nlcg(tfs_poly3d, mask, 1, mask, mask, Tik_weight, TV_weight, voxelSize, z_prjs, 1000);
nii = make_nii(chi,voxelSize);
save_nii(nii,['chi_brain_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '_1000_poly3d_1st_order.nii']);


[chi, res] = tfi_nlcg(tfs_poly2d, mask_ero, 1, mask_ero, mask_ero, Tik_weight, TV_weight, voxelSize, z_prjs, 1000);
nii = make_nii(chi,voxelSize);
save_nii(nii,['chi_brain_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '_1000_poly2d.nii']);


tfs_poly2d_pad = padarray(tfs_poly2d,[0 0 20]);
mask_pad = padarray(mask,[0 0 20]);

[chi, res] = tfi_nlcg(tfs_poly2d_pad, mask_pad, 1, mask_pad, mask_pad, Tik_weight, TV_weight, voxelSize, z_prjs, 1000);
nii = make_nii(chi,voxelSize);
save_nii(nii,['chi_brain_pad_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '_1000_poly2d.nii']);






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% for paper figures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% NO tik, only TV (3 different values on L-curve)
Tik_weight = 0;
TV_weight = 1e-6;
[chi, res] = tfi_nlcg(tfs, mask.*R, 1, mask.*R, mask.*R, Tik_weight, TV_weight, vox, z_prjs, 2000);
nii = make_nii(chi,vox);
save_nii(nii,['NOTik/chi_tik0_tv1e-6_2000.nii']);

Tik_weight = 0;
TV_weight = 5e-3;
[chi, res] = tfi_nlcg(tfs, mask.*R, 1, mask.*R, mask.*R, Tik_weight, TV_weight, vox, z_prjs, 2000);
nii = make_nii(chi,vox);
save_nii(nii,['NOTik/chi_tik0_tv5e-3_2000.nii']);

Tik_weight = 0;
TV_weight = 1;
[chi, res] = tfi_nlcg(tfs, mask.*R, 1, mask.*R, mask.*R, Tik_weight, TV_weight, vox, z_prjs, 2000);
nii = make_nii(chi,vox);
save_nii(nii,['NOTik/chi_tik0_tv1_2000.nii']);

