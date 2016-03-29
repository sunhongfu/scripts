load data_simulation.mat
brain_field = brain_field(145:305,125:325,145:305);
brain_mask = single(brain_mask(145:305,125:325,145:305));

vox = [1,1,1];
smv_ker = 2;

lambda = [0, 1e-6, 5e-6, 1e-5, 5e-4, 1e-4, 2e-4, 3e-4, 4e-4, 5e-4, ...
 6e-4, 7e-4, 8e-4, 9e-4, 1e-3, 2e-3, 3e-3, 4e-3, 5e-3, 6e-3, 7e-3, 8e-3, 9e-3, ...
 1e-2, 1.3e-2, 1.8e-2, 2e-2, 2.3e-2, 2.8e-2, 3e-2, 3.5e-2, 4e-2, 4.5e-2, 5e-2, 6e-2, 7e-2, 8e-2, 9e-2, 0.1];

for i = 1:length(lambda)
	[lfs, mask_ero, data_fidelity(i), regularization_term(i)] = resharp(brain_field,brain_mask,vox,smv_ker,lambda(i));
%	nii = make_nii(lfs,vox);
%	save_nii(nii,['lfs_' num2str(lambda(i)) '.nii']);
end

save('all.mat','-v7.3');


reference_field = reference_field(145:305,125:325,145:305);
nii = make_nii(reference_field,vox);
save_nii(nii,'groundTruth.nii');


smv_ker = [2,3,4,5,6,7,8];

for i = 1:length(smv_ker)
	[lfs, mask_ero] = resharp(brain_field,brain_mask,vox,smv_ker(i),0);
	nii = make_nii(lfs,vox);
	save_nii(nii,['lfs_smv_rad' num2str(smv_ker(i)) '.nii']);
	err = mask_ero.*(lfs - reference_field);
	err_norm(i) = norm(err(:))
end


lambda = [1e-7, 1e-6, 5e-6, 1e-5, 2e-5, 3e-5, 4e-5, 5e-5, 6e-5, 7e-5, 8e-5, 9e-5, ...
	1e-4, 2e-4, 3e-4, 4e-4, 5e-4, 6e-4, 7e-4, 8e-4, 9e-4, 1e-3,2e-3,3e-3,4e-3,5e-3,6e-3,7e-3,8e-3,9e-3, ...
	1e-2,2e-2,3e-2,4e-2,5e-2,6e-2,7e-2,8e-2,9e-2 0.1];
for i = 1:length(lambda)
	[lfs, mask_ero, data_fidelity(i), regularization_term(i)] = resharp(brain_field,brain_mask,vox,2,lambda(i));
	nii = make_nii(lfs,vox);
	save_nii(nii,['lfs_' num2str(lambda(i)) '.nii']);
	err = mask_ero.*(lfs - reference_field);
	err_norm(i) = norm(err(:))
end
