load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_LEFT/QSM_SPGR_GE/z_prjs.mat');
nii = load_nii('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_LEFT/QSM_SPGR_GE/RESHARP/lfs_resharp_tik_0.0001_num_500.nii');
field = single(nii.img);
vox = nii.hdr.dime.pixdim(2:4);
field_kspace = ifftshift(fftn(field));
nii = make_nii(real(field_kspace),vox);
save_nii(nii, '/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_left_field_kspace_real.nii');
nii = make_nii(imag(field_kspace),vox);
save_nii(nii, '/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_left_field_kspace_imag.nii');








load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_RIGHT/QSM_SPGR_GE/z_prjs.mat');
nii = load_nii('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_RIGHT/QSM_SPGR_GE/RESHARP/lfs_resharp_tik_0.0001_num_500.nii');
field = single(nii.img);
vox = nii.hdr.dime.pixdim(2:4);
field_kspace = ifftshift(fftn(field));
nii = make_nii(real(field_kspace),vox);
save_nii(nii, '/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_right_field_kspace_real.nii');
nii = make_nii(imag(field_kspace),vox);
save_nii(nii, '/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_right_field_kspace_imag.nii');








load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_BACKWARD/QSM_SPGR_GE/z_prjs.mat');
nii = load_nii('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_BACKWARD/QSM_SPGR_GE/RESHARP/lfs_resharp_tik_0.0001_num_500.nii');
field = single(nii.img);
vox = nii.hdr.dime.pixdim(2:4);
field_kspace = ifftshift(fftn(field));
nii = make_nii(real(field_kspace),vox);
save_nii(nii, '/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_backward_field_kspace_real.nii');
nii = make_nii(imag(field_kspace),vox);
save_nii(nii, '/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_backward_field_kspace_imag.nii');








load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_FORWARD/QSM_SPGR_GE/z_prjs.mat');
nii = load_nii('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_FORWARD/QSM_SPGR_GE/RESHARP/lfs_resharp_tik_0.0001_num_500.nii');
field = single(nii.img);
vox = nii.hdr.dime.pixdim(2:4);
field_kspace = ifftshift(fftn(field));
nii = make_nii(real(field_kspace),vox);
save_nii(nii, '/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_forward_field_kspace_real.nii');
nii = make_nii(imag(field_kspace),vox);
save_nii(nii, '/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_forward_field_kspace_imag.nii');








load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_CENTER/QSM_SPGR_GE/all.mat','z_prjs');
nii = load_nii('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_CENTER/QSM_SPGR_GE/RESHARP/lfs_resharp_tik_0.0001_num_500.nii');
field = single(nii.img);
vox = nii.hdr.dime.pixdim(2:4);
field_kspace = ifftshift(fftn(field));
nii = make_nii(real(field_kspace),vox);
save_nii(nii, '/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_field_kspace_real.nii');
nii = make_nii(imag(field_kspace),vox);
save_nii(nii, '/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_field_kspace_imag.nii');







% rotate/reslice into coronal
nii = load_nii('/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_field.nii');
field = flip(permute(nii.img,[1 3 2]),1);
vox = permute(nii.hdr.dime.pixdim(2:4), [1 3 2]);
nii = make_nii(field,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_permute132_field.nii');

field_kspace = ifftshift(fftn(field));
nii = make_nii(real(field_kspace),vox);
save_nii(nii, '/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_permute132_field_real.nii');
nii = make_nii(imag(field_kspace),vox);
save_nii(nii, '/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_permute132_field_imag.nii');





% big angle from forward calc
nii = load_nii('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_CENTER/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad1.nii');
chi = double(nii.img);
vox = nii.hdr.dime.pixdim(2:4);

z_prjs = [sqrt(2)/2, 0 , sqrt(2)/2];

[field, D, dipole, field_kspace] = forward_field_calc(chi, vox, z_prjs);

mask = (chi ~= 0);
mask = double(mask); 

nii = make_nii(field.*mask,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_bigAngle_field.nii');

field_kspace = ifftshift(fftn(field.*mask));

nii = make_nii(real(field_kspace),vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_bigAngle_field_real.nii');

nii = make_nii(imag(field_kspace),vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_bigAngle_field_imag.nii');