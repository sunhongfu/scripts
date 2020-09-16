k = 1;
for z_prjs_x = -1:0.1:1
    for z_prjs_y = -sqrt(1-z_prjs_x^2):0.1:sqrt(1-z_prjs_x^2)
        z_prjs_z = sqrt(1-z_prjs_x^2-z_prjs_y^2);
        z_prjs(k,:) = [z_prjs_x, z_prjs_y, z_prjs_z];
        k = k + 1;
    end
end
z_prjs = real(z_prjs);

% mkdir /scratch/itee/uqhsun8/CommQSM/invivo/alldirs_chi
% mkdir /scratch/itee/uqhsun8/CommQSM/invivo/alldirs_field
mkdir /scratch/itee/uqhsun8/CommQSM/invivo/alldirs_D_shift

fileID = fopen('/scratch/itee/uqhsun8/CommQSM/pytorch_codes/image_unet_stack_prjs_alldirs_150k/z_prjs_alldirs.txt','r');
formatSpec = '%s %s %s %s';
A = textscan(fileID,formatSpec);
a = A{1};


for i = 1:150000
    filename = split(a{i},'-');
    nii = load_nii(['/scratch/itee/uqygao10/QSM_NEW/QSM_VIVO/' filename{1}, '-Phantom_NIFTI.nii']);
    img = single(nii.img);

    % generate D and Field
    vox = [1 1 1];

    [~, D, ~, ~] = forward_field_calc(img, vox, z_prjs(str2double(filename{2}),:));

    D = fftshift(D);
    nii = make_nii(D, vox);
    save_nii(nii,['/scratch/itee/uqhsun8/CommQSM/invivo/alldirs_D_shift/alldirs_D_shift_' a{i} '.nii']);

end

