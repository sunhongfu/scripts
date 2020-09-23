% create D_shift with size of 48 and 64
vox = [1 1 1];

[field, D, dipole, field_kspace] = forward_field_calc(ones(48,48,48), vox, [0 0 1]);
D = fftshift(D);
nii = make_nii(D, vox);
save_nii(nii,'/Users/uqhsun8/Documents/MATLAB/scripts/pytorch_codes/D_shift_48.nii');

[field, D, dipole, field_kspace] = forward_field_calc(ones(64,64,64), vox, [0 0 1]);
D = fftshift(D);
nii = make_nii(D, vox);
save_nii(nii,'/Users/uqhsun8/Documents/MATLAB/scripts/pytorch_codes/D_shift_64.nii');

[field, D, dipole, field_kspace] = forward_field_calc(ones(80,80,80), vox, [0 0 1]);
D = fftshift(D);
nii = make_nii(D, vox);
save_nii(nii,'/Users/uqhsun8/Documents/MATLAB/scripts/pytorch_codes/D_shift_80.nii');