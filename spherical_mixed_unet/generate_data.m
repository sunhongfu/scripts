for i = 1:15000
    x = randn;
    y = randn;
    z = randn;
    mag = sqrt(x*x + y*y + z*z);
    prjs_x(i) = x/mag;
    prjs_y(i) = y/mag;
    prjs_z(i) = z/mag;
end

prjs = [prjs_x', prjs_y', prjs_z'];

% save the prjs in mat and text file
save('prjs_sphere_15k.mat', 'prjs');
save('prjs_sphere_15k.txt', 'prjs', '-ascii');

% generate field maps and write down the sampled prjs

for i = 1:15000
    nii = load_nii(['/scratch/itee/uqygao10/QSM_NEW/QSM_VIVO/' num2str(i), '-Phantom_NIFTI.nii']);
    img = single(nii.img);

    % generate D and Field
    vox = [1 1 1];

    [field, D, dipole, field_kspace] = forward_field_calc(img, vox, prjs(i,:));
    % D = fftshift(D);
    % field_kspace = fftshift(field_kspace);
    % nii = make_nii(D, vox);
    % save_nii(nii,['/scratch/itee/uqhsun8/CommQSM/invivo/D_shift/D_shift_' num2str(i) '-' num2str(j) '.nii']);
    % nii = make_nii(real(field_kspace), vox);
    % save_nii(nii,['/scratch/itee/uqhsun8/CommQSM/invivo/field_kspace_shift/real_field_kspace_shift_' num2str(i) '-' num2str(j) '.nii']);
    % nii = make_nii(imag(field_kspace), vox);
    % save_nii(nii,['/scratch/itee/uqhsun8/CommQSM/invivo/field_kspace_shift/imag_field_kspace_shift_' num2str(i) '-' num2str(j) '.nii']);

    % field_kspace(1)
    % field_D_cat = cat(3,field,D);
    % field_dipole_cat = cat(3,field,dipole);

    %% save chi(img), field, D, field_D_cat as NIFTIs
    nii = make_nii(img, vox);
    save_nii(nii,['/scratch/itee/uqhsun8/spherical_mixed_unet_data/spherical_dirs_chi/spherical_dirs_chi_' num2str(i) '.nii']);
    nii = make_nii(field, vox);
    save_nii(nii,['/scratch/itee/uqhsun8/spherical_mixed_unet_data/spherical_dirs_field/spherical_dirs_field_' num2str(i) '.nii']);
    % nii = make_nii(D, vox);
    % save_nii(nii,['/scratch/itee/uqhsun8/CommQSM/invivo/D/D_' num2str(i) '-' num2str(j) '.nii']);
    % nii = make_nii(dipole, vox);
    % save_nii(nii,['/scratch/itee/uqhsun8/CommQSM/invivo/dipole/dipole_' num2str(i) '-' num2str(j) '.nii']);
    % nii = make_nii(field_dipole_cat, vox);
    % save_nii(nii,['/scratch/itee/uqhsun8/CommQSM/invivo/field_dipole_cat/field_dipole_cat_' num2str(i) '-' num2str(j) '.nii']);
    % nii = make_nii(field_D_cat, vox);
    % save_nii(nii,['/scratch/itee/uqhsun8/CommQSM/invivo/field_D_cat/field_D_cat_' num2str(i) '-' num2str(j) '.nii']);
    % nii = make_nii(real(field_kspace), vox);
    % save_nii(nii,['/scratch/itee/uqhsun8/CommQSM/invivo/field_kspace/real_field_kspace_' num2str(i) '-' num2str(j) '.nii']);
    % nii = make_nii(imag(field_kspace), vox);
    % save_nii(nii,['/scratch/itee/uqhsun8/CommQSM/invivo/field_kspace/imag_field_kspace_' num2str(i) '-' num2str(j) '.nii']);



end
