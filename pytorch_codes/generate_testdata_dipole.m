load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_LEFT/QSM_SPGR_GE/z_prjs.mat', 'z_prjs');

imsize = [256 256 128];
vox = [1 1 1];
[~, D, dipole, ~] = forward_field_calc(ones(imsize), vox, z_prjs);

nii = make_nii(D,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_left_D.nii');

nii = make_nii(fftshift(D),vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_left_D_shift.nii');

nii = make_nii(dipole,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_left_dipole.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_RIGHT/QSM_SPGR_GE/z_prjs.mat', 'z_prjs');

imsize = [256 256 128];
vox = [1 1 1];
[~, D, dipole, ~] = forward_field_calc(ones(imsize), vox, z_prjs);

nii = make_nii(D,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_right_D.nii');

nii = make_nii(fftshift(D),vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_right_D_shift.nii');

nii = make_nii(dipole,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_right_dipole.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_FORWARD/QSM_SPGR_GE/z_prjs.mat', 'z_prjs');

imsize = [256 256 128];
vox = [1 1 1];
[~, D, dipole, ~] = forward_field_calc(ones(imsize), vox, z_prjs);

nii = make_nii(D,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_forward_D.nii');

nii = make_nii(fftshift(D),vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_forward_D_shift.nii');

nii = make_nii(dipole,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_forward_dipole.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_BACKWARD/QSM_SPGR_GE/z_prjs.mat', 'z_prjs');

imsize = [256 256 128];
vox = [1 1 1];
[~, D, dipole, ~] = forward_field_calc(ones(imsize), vox, z_prjs);

nii = make_nii(D,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_backward_D.nii');

nii = make_nii(fftshift(D),vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_backward_D_shift.nii');

nii = make_nii(dipole,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_backward_dipole.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_CENTER/QSM_SPGR_GE/all.mat', 'z_prjs');

imsize = [256 256 128];
vox = [1 1 1];
[~, D, dipole, ~] = forward_field_calc(ones(imsize), vox, z_prjs);

nii = make_nii(D,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_D.nii');

nii = make_nii(fftshift(D),vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_D_shift.nii');

nii = make_nii(dipole,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_dipole.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





% rotate/reslice into coronal
load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_CENTER/QSM_SPGR_GE/all.mat', 'z_prjs');

z_prjs = permute(z_prjs, [1 3 2]);
z_prjs(1) = -z_prjs(1);
imsize = [256 128 256];
vox = [1 1 1];

[~, D, dipole, ~] = forward_field_calc(ones(imsize), vox, z_prjs);

nii = make_nii(D,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_permute132_D.nii');

nii = make_nii(dipole,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_permute132_dipole.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% big angle from forward calc
nii = load_nii('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_CENTER/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad1.nii');
chi = double(nii.img);
vox = nii.hdr.dime.pixdim(2:4);

z_prjs = [sqrt(2)/2, 0 , sqrt(2)/2];

[~, D, dipole, ~] = forward_field_calc(chi, vox, z_prjs);

nii = make_nii(D,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_bigAngle_D.nii');

nii = make_nii(dipole,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_bigAngle_dipole.nii');