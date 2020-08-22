k = 1;
for z_prjs_x = -1:0.1:1
    for z_prjs_y = -sqrt(1-z_prjs_x^2):0.1:sqrt(1-z_prjs_x^2)
        z_prjs_z = sqrt(1-z_prjs_x^2-z_prjs_y^2);
        z_prjs(k,:) = [z_prjs_x, z_prjs_y, z_prjs_z];
        k = k + 1;
    end
end
z_prjs = real(z_prjs);

mkdir /Volumes/LaCie/CommQSM/invivo/data_for_training/alldirs_chi
mkdir /Volumes/LaCie/CommQSM/invivo/data_for_training/alldirs_field

fileID = fopen('/Users/uqhsun8/Documents/MATLAB/scripts/pytorch_codes/image_unet_stack_prjs_alldirs/z_prjs_alldirs.txt','w');

for i = 1:5:15000
    nii = load_nii(['/Volumes/LaCie/CommQSM/invivo/QSM_VIVO/' num2str(i), '-Phantom_NIFTI.nii']);
    img = single(nii.img);

    % generate D and Field
    vox = [1 1 1];
    % for j = 1:size(z_prjs_all,1)
    for j = randi(length(z_prjs),[1,5])
        [field, D, dipole, field_kspace] = forward_field_calc(img, vox, z_prjs(j,:));
        % D = fftshift(D);
        % field_kspace = fftshift(field_kspace);
        % nii = make_nii(D, vox);
        % save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/data_for_training/D_shift/D_shift_' num2str(i) '-' num2str(j) '.nii']);
        % nii = make_nii(real(field_kspace), vox);
        % save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/data_for_training/field_kspace_shift/real_field_kspace_shift_' num2str(i) '-' num2str(j) '.nii']);
        % nii = make_nii(imag(field_kspace), vox);
        % save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/data_for_training/field_kspace_shift/imag_field_kspace_shift_' num2str(i) '-' num2str(j) '.nii']);

        % field_kspace(1)
        % field_D_cat = cat(3,field,D);
        % field_dipole_cat = cat(3,field,dipole);

        %% save chi(img), field, D, field_D_cat as NIFTIs
        nii = make_nii(img, vox);
        save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/data_for_training/alldirs_chi/alldirs_chi_' num2str(i) '-' num2str(j) '.nii']);
        nii = make_nii(field, vox);
        save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/data_for_training/alldirs_field/alldirs_field_' num2str(i) '-' num2str(j) '.nii']);
        % nii = make_nii(D, vox);
        % save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/data_for_training/D/D_' num2str(i) '-' num2str(j) '.nii']);
        % nii = make_nii(dipole, vox);
        % save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/data_for_training/dipole/dipole_' num2str(i) '-' num2str(j) '.nii']);
        % nii = make_nii(field_dipole_cat, vox);
        % save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/data_for_training/field_dipole_cat/field_dipole_cat_' num2str(i) '-' num2str(j) '.nii']);
        % nii = make_nii(field_D_cat, vox);
        % save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/data_for_training/field_D_cat/field_D_cat_' num2str(i) '-' num2str(j) '.nii']);
        % nii = make_nii(real(field_kspace), vox);
        % save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/data_for_training/field_kspace/real_field_kspace_' num2str(i) '-' num2str(j) '.nii']);
        % nii = make_nii(imag(field_kspace), vox);
        % save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/data_for_training/field_kspace/imag_field_kspace_' num2str(i) '-' num2str(j) '.nii']);

        % write down the prjs
        line_str = [num2str(i) '-' num2str(j) ' ' regexprep(num2str(z_prjs(j,:)),'\s+',' ')];
        fprintf(fileID,'%s\n',line_str);


    end
end

