load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_LEFT/QSM_SPGR_GE/z_prjs.mat');
nii = load_nii('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_LEFT/QSM_SPGR_GE/RESHARP/lfs_resharp_tik_0.0001_num_500.nii');
field = single(nii.img);

imsize = size(field);
% generate D and Field
vox = [1 1 1];
Nx = imsize(1);
Ny = imsize(2);
Nz = imsize(3);
FOV = vox.*[Nx,Ny,Nz];
FOVx = FOV(1);
FOVy = FOV(2);
FOVz = FOV(3);
x = -Nx/2:Nx/2-1;
y = -Ny/2:Ny/2-1;
z = -Nz/2:Nz/2-1;
[kx,ky,kz] = ndgrid(x/FOVx,y/FOVy,z/FOVz);
D = 1/3 - (kx.*z_prjs(1)+ky.*z_prjs(2)+kz.*z_prjs(3)).^2./(kx.^2 + ky.^2 + kz.^2);
D(floor(Nx/2+1),floor(Ny/2+1),floor(Nz/2+1)) = 0;
dipole_image = real(fftshift(fftn(fftshift(D))));
nii = make_nii(dipole_image,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo_left_dipole_image.nii');
field_D_cat = cat(3,field,D);
field_D_cat = field_D_cat(49:240,49:240,:);
nii = make_nii(field_D_cat,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo_left_field_D_cat_trunc.nii');
field_dipole_cat = cat(3,field,dipole_image);
field_dipole_cat = field_dipole_cat(49:240,49:240,:);
nii = make_nii(field_dipole_cat,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo_left_field_dipole_cat_trunc.nii');
field_kspace = ifftshift(fftn(field));
nii = make_nii(real(field_kspace),vox);
save_nii(nii, '/Volumes/LaCie/CommQSM/invivo/testing/renzo_left_field_kspace_real.nii');
nii = make_nii(imag(field_kspace),vox);
save_nii(nii, '/Volumes/LaCie/CommQSM/invivo/testing/renzo_left_field_kspace_imag.nii');








load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_RIGHT/QSM_SPGR_GE/z_prjs.mat');
nii = load_nii('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_RIGHT/QSM_SPGR_GE/RESHARP/lfs_resharp_tik_0.0001_num_500.nii');
field = single(nii.img);

imsize = size(field);
% generate D and Field
vox = [1 1 1];
Nx = imsize(1);
Ny = imsize(2);
Nz = imsize(3);
FOV = vox.*[Nx,Ny,Nz];
FOVx = FOV(1);
FOVy = FOV(2);
FOVz = FOV(3);
x = -Nx/2:Nx/2-1;
y = -Ny/2:Ny/2-1;
z = -Nz/2:Nz/2-1;
[kx,ky,kz] = ndgrid(x/FOVx,y/FOVy,z/FOVz);
D = 1/3 - (kx.*z_prjs(1)+ky.*z_prjs(2)+kz.*z_prjs(3)).^2./(kx.^2 + ky.^2 + kz.^2);
D(floor(Nx/2+1),floor(Ny/2+1),floor(Nz/2+1)) = 0;
dipole_image = real(fftshift(fftn(fftshift(D))));
nii = make_nii(dipole_image,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo_right_dipole_image.nii');
field_D_cat = cat(3,field,D);
field_D_cat = field_D_cat(49:240,49:240,:);
nii = make_nii(field_D_cat,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo_right_field_D_cat_trunc.nii');
field_dipole_cat = cat(3,field,dipole_image);
field_dipole_cat = field_dipole_cat(49:240,49:240,:);
nii = make_nii(field_dipole_cat,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo_right_field_dipole_cat_trunc.nii');
field_kspace = ifftshift(fftn(field));
nii = make_nii(real(field_kspace),vox);
save_nii(nii, '/Volumes/LaCie/CommQSM/invivo/testing/renzo_right_field_kspace_real.nii');
nii = make_nii(imag(field_kspace),vox);
save_nii(nii, '/Volumes/LaCie/CommQSM/invivo/testing/renzo_right_field_kspace_imag.nii');








load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_BACKWARD/QSM_SPGR_GE/z_prjs.mat');
nii = load_nii('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_BACKWARD/QSM_SPGR_GE/RESHARP/lfs_resharp_tik_0.0001_num_500.nii');
field = single(nii.img);

imsize = size(field);
% generate D and Field
vox = [1 1 1];
Nx = imsize(1);
Ny = imsize(2);
Nz = imsize(3);
FOV = vox.*[Nx,Ny,Nz];
FOVx = FOV(1);
FOVy = FOV(2);
FOVz = FOV(3);
x = -Nx/2:Nx/2-1;
y = -Ny/2:Ny/2-1;
z = -Nz/2:Nz/2-1;
[kx,ky,kz] = ndgrid(x/FOVx,y/FOVy,z/FOVz);
D = 1/3 - (kx.*z_prjs(1)+ky.*z_prjs(2)+kz.*z_prjs(3)).^2./(kx.^2 + ky.^2 + kz.^2);
D(floor(Nx/2+1),floor(Ny/2+1),floor(Nz/2+1)) = 0;
dipole_image = real(fftshift(fftn(fftshift(D))));
nii = make_nii(dipole_image,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo_backward_dipole_image.nii');
field_D_cat = cat(3,field,D);
field_D_cat = field_D_cat(49:240,49:240,:);
nii = make_nii(field_D_cat,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo_backward_field_D_cat_trunc.nii');
field_dipole_cat = cat(3,field,dipole_image);
field_dipole_cat = field_dipole_cat(49:240,49:240,:);
nii = make_nii(field_dipole_cat,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo_backward_field_dipole_cat_trunc.nii');
field_kspace = ifftshift(fftn(field));
nii = make_nii(real(field_kspace),vox);
save_nii(nii, '/Volumes/LaCie/CommQSM/invivo/testing/renzo_backward_field_kspace_real.nii');
nii = make_nii(imag(field_kspace),vox);
save_nii(nii, '/Volumes/LaCie/CommQSM/invivo/testing/renzo_backward_field_kspace_imag.nii');








load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_FORWARD/QSM_SPGR_GE/z_prjs.mat');
nii = load_nii('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_FORWARD/QSM_SPGR_GE/RESHARP/lfs_resharp_tik_0.0001_num_500.nii');
field = single(nii.img);

imsize = size(field);
% generate D and Field
vox = [1 1 1];
Nx = imsize(1);
Ny = imsize(2);
Nz = imsize(3);
FOV = vox.*[Nx,Ny,Nz];
FOVx = FOV(1);
FOVy = FOV(2);
FOVz = FOV(3);
x = -Nx/2:Nx/2-1;
y = -Ny/2:Ny/2-1;
z = -Nz/2:Nz/2-1;
[kx,ky,kz] = ndgrid(x/FOVx,y/FOVy,z/FOVz);
D = 1/3 - (kx.*z_prjs(1)+ky.*z_prjs(2)+kz.*z_prjs(3)).^2./(kx.^2 + ky.^2 + kz.^2);
D(floor(Nx/2+1),floor(Ny/2+1),floor(Nz/2+1)) = 0;
dipole_image = real(fftshift(fftn(fftshift(D))));
nii = make_nii(dipole_image,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo_forward_dipole_image.nii');
field_D_cat = cat(3,field,D);
field_D_cat = field_D_cat(49:240,49:240,:);
nii = make_nii(field_D_cat,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo_forward_field_D_cat_trunc.nii');
field_dipole_cat = cat(3,field,dipole_image);
field_dipole_cat = field_dipole_cat(49:240,49:240,:);
nii = make_nii(field_dipole_cat,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo_forward_field_dipole_cat_trunc.nii');
field_kspace = ifftshift(fftn(field));
nii = make_nii(real(field_kspace),vox);
save_nii(nii, '/Volumes/LaCie/CommQSM/invivo/testing/renzo_forward_field_kspace_real.nii');
nii = make_nii(imag(field_kspace),vox);
save_nii(nii, '/Volumes/LaCie/CommQSM/invivo/testing/renzo_forward_field_kspace_imag.nii');








load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_CENTER/QSM_SPGR_GE/all.mat','z_prjs');
nii = load_nii('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_CENTER/QSM_SPGR_GE/RESHARP/lfs_resharp_tik_0.0001_num_500.nii');
field = single(nii.img);

imsize = size(field);
% generate D and Field
vox = [1 1 1];
Nx = imsize(1);
Ny = imsize(2);
Nz = imsize(3);
FOV = vox.*[Nx,Ny,Nz];
FOVx = FOV(1);
FOVy = FOV(2);
FOVz = FOV(3);
x = -Nx/2:Nx/2-1;
y = -Ny/2:Ny/2-1;
z = -Nz/2:Nz/2-1;
[kx,ky,kz] = ndgrid(x/FOVx,y/FOVy,z/FOVz);
D = 1/3 - (kx.*z_prjs(1)+ky.*z_prjs(2)+kz.*z_prjs(3)).^2./(kx.^2 + ky.^2 + kz.^2);
D(floor(Nx/2+1),floor(Ny/2+1),floor(Nz/2+1)) = 0;
dipole_image = real(fftshift(fftn(fftshift(D))));
nii = make_nii(dipole_image,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo_central_dipole_image.nii');
field_D_cat = cat(3,field,D);
field_D_cat = field_D_cat(49:240,49:240,:);
nii = make_nii(field_D_cat,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo_central_field_D_cat_trunc.nii');
field_dipole_cat = cat(3,field,dipole_image);
field_dipole_cat = field_dipole_cat(49:240,49:240,:);
nii = make_nii(field_dipole_cat,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo_central_field_dipole_cat_trunc.nii');
field_kspace = ifftshift(fftn(field));
nii = make_nii(real(field_kspace),vox);
save_nii(nii, '/Volumes/LaCie/CommQSM/invivo/testing/renzo_central_field_kspace_real.nii');
nii = make_nii(imag(field_kspace),vox);
save_nii(nii, '/Volumes/LaCie/CommQSM/invivo/testing/renzo_central_field_kspace_imag.nii');















% % rotate/permute to other orthogonal orientations
% nii = load_nii('/Volumes/LaCie/CommQSM/invivo/testing/renzo_central_dipole.nii');
% img = permute(nii.img,[1 3 2]);
% vox = permute(nii.hdr.dime.pixdim(2:4), [1 3 2]);
% img = flip(flip(img,1),2);
% nii = make_nii(img,vox);
% save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo_central_dipole_permute132.nii');


nii = load_nii('/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_field.nii');
img = permute(nii.img,[1 3 2]);
vox = permute(nii.hdr.dime.pixdim(2:4), [1 3 2]);
img = flip(flip(img,1),2);
nii = make_nii(img,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo_central_permute132_field.nii');


nii = load_nii('/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_D.nii');
img = permute(nii.img,[1 3 2]);
vox = permute(nii.hdr.dime.pixdim(2:4), [1 3 2]);
img = flip(flip(img,1),2);
nii = make_nii(img,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo_central_permute132_D.nii');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imsize = [256 128 256];
vox = [1 1 1];

Nx = imsize(1);
Ny = imsize(2);
Nz = imsize(3);

z_prjs = [1 0 0];

% create K-space filter kernel D
% (1) k-space domain
FOV = vox.*[Nx,Ny,Nz];
FOVx = FOV(1);
FOVy = FOV(2);
FOVz = FOV(3);

x = -Nx/2:Nx/2-1;
y = -Ny/2:Ny/2-1;
z = -Nz/2:Nz/2-1;
[kx,ky,kz] = ndgrid(x/FOVx,y/FOVy,z/FOVz);
% D = 1/3 - kz.^2./(kx.^2 + ky.^2 + kz.^2);
D = 1/3 - (kx.*z_prjs(1)+ky.*z_prjs(2)+kz.*z_prjs(3)).^2./(kx.^2 + ky.^2 + kz.^2);
D(floor(Nx/2+1),floor(Ny/2+1),floor(Nz/2+1)) = 0;
nii = make_nii(img,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo_coronal_permute132_D.nii');
