load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_LEFT/QSM_SPGR_GE/z_prjs.mat', 'z_prjs');

imsize = [256 256 128];
vox = [1 1 1];

Nx = imsize(1);
Ny = imsize(2);
Nz = imsize(3);

% create K-space filter kernel D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

nii = make_nii(D,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_left_D.nii');

dipole = real(fftshift(fftn(fftshift(D))));
nii = make_nii(dipole,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_left_dipole.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_RIGHT/QSM_SPGR_GE/z_prjs.mat', 'z_prjs');

imsize = [256 256 128];
vox = [1 1 1];

Nx = imsize(1);
Ny = imsize(2);
Nz = imsize(3);

% create K-space filter kernel D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

nii = make_nii(D,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_right_D.nii');

dipole = real(fftshift(fftn(fftshift(D))));
nii = make_nii(dipole,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_right_dipole.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_FORWARD/QSM_SPGR_GE/z_prjs.mat', 'z_prjs');

imsize = [256 256 128];
vox = [1 1 1];

Nx = imsize(1);
Ny = imsize(2);
Nz = imsize(3);

% create K-space filter kernel D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

nii = make_nii(D,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_forward_D.nii');

dipole = real(fftshift(fftn(fftshift(D))));
nii = make_nii(dipole,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_forward_dipole.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_BACKWARD/QSM_SPGR_GE/z_prjs.mat', 'z_prjs');

imsize = [256 256 128];
vox = [1 1 1];

Nx = imsize(1);
Ny = imsize(2);
Nz = imsize(3);

% create K-space filter kernel D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

nii = make_nii(D,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_backward_D.nii');

dipole = real(fftshift(fftn(fftshift(D))));
nii = make_nii(dipole,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_backward_dipole.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_CENTER/QSM_SPGR_GE/all.mat', 'z_prjs');

imsize = [256 256 128];
vox = [1 1 1];

Nx = imsize(1);
Ny = imsize(2);
Nz = imsize(3);

% create K-space filter kernel D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

nii = make_nii(D,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_D.nii');

dipole = real(fftshift(fftn(fftshift(D))));
nii = make_nii(dipole,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_dipole.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%