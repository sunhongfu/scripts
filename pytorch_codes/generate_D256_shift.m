mkdir D256_shift
load z_prjs_all

vox = [1 1 1];

Nx = 256;
Ny = 256;
Nz = 256;

FOV = vox.*[Nx,Ny,Nz];
FOVx = FOV(1);
FOVy = FOV(2);
FOVz = FOV(3);

x = -Nx/2:Nx/2-1;
y = -Ny/2:Ny/2-1;
z = -Nz/2:Nz/2-1;
[kx,ky,kz] = ndgrid(x/FOVx,y/FOVy,z/FOVz);

% for i = 1:5:15000
    for j = 1:size(z_prjs_all,1)
        z_prjs = z_prjs_all(j,:);
        % create K-space filter kernel D
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % (1) k-space domain

        % D = 1/3 - kz.^2./(kx.^2 + ky.^2 + kz.^2);
        D = 1/3 - (kx.*z_prjs(1)+ky.*z_prjs(2)+kz.*z_prjs(3)).^2./(kx.^2 + ky.^2 + kz.^2);
        D(floor(Nx/2+1),floor(Ny/2+1),floor(Nz/2+1)) = 0;
        D = fftshift(D);
        nii = make_nii(D, vox);
        save_nii(nii,['D256_shift/D256_shift_orien' num2str(j) '.nii']);
    end
% end
