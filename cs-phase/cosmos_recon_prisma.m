
% apply the transformation to local field map
unix('/usr/local/fsl/bin/flirt -in "/Users/uqhsun8/Downloads/cosmos_prisma/LFS/k_net/knet_lfs_left.nii" -applyxfm -init /Volumes/LaCie/COSMOS_3T/cosmos_prisma/LEFT/flirt_qsm_12DOF.mat -out "/Users/uqhsun8/Downloads/cosmos_prisma/LFS/k_net/knet_lfs_left_flirt.nii" -paddingsize 0.0 -interp trilinear -ref /Volumes/LaCie/COSMOS_3T/cosmos_prisma/center_new/QSM_R2S_PRISMA/RESHARP/lfs_resharp.nii');

unix('/usr/local/fsl/bin/flirt -in "/Users/uqhsun8/Downloads/cosmos_prisma/LFS/k_net/knet_lfs_right.nii" -applyxfm -init /Volumes/LaCie/COSMOS_3T/cosmos_prisma/RIGHT/flirt_qsm_12DOF.mat -out "/Users/uqhsun8/Downloads/cosmos_prisma/LFS/k_net/knet_lfs_right_flirt.nii" -paddingsize 0.0 -interp trilinear -ref /Volumes/LaCie/COSMOS_3T/cosmos_prisma/center_new/QSM_R2S_PRISMA/RESHARP/lfs_resharp.nii');

unix('/usr/local/fsl/bin/flirt -in "/Users/uqhsun8/Downloads/cosmos_prisma/LFS/k_net/knet_lfs_flexion.nii" -applyxfm -init /Volumes/LaCie/COSMOS_3T/cosmos_prisma/FLEXION/flirt_qsm_12DOF.mat -out "/Users/uqhsun8/Downloads/cosmos_prisma/LFS/k_net/knet_lfs_flexion_flirt.nii" -paddingsize 0.0 -interp trilinear -ref /Volumes/LaCie/COSMOS_3T/cosmos_prisma/center_new/QSM_R2S_PRISMA/RESHARP/lfs_resharp.nii');

unix('/usr/local/fsl/bin/flirt -in "/Users/uqhsun8/Downloads/cosmos_prisma/LFS/k_net/knet_lfs_extension.nii" -applyxfm -init /Volumes/LaCie/COSMOS_3T/cosmos_prisma/EXTENSION/flirt_qsm_12DOF.mat -out "/Users/uqhsun8/Downloads/cosmos_prisma/LFS/k_net/knet_lfs_extension_flirt.nii" -paddingsize 0.0 -interp trilinear -ref /Volumes/LaCie/COSMOS_3T/cosmos_prisma/center_new/QSM_R2S_PRISMA/RESHARP/lfs_resharp.nii');


% calculate the angles of B0 with registered local field maps
% R is transformation matrix from individual image space to common space (FLIRT matrix)
% common space coordinates = R* object image space coordinates
load /Volumes/LaCie/COSMOS_3T/cosmos_prisma/LEFT/flirt_qsm.mat -ASCII
R_t(:,:,1) = flirt_qsm(1:3,1:3);
load /Volumes/LaCie/COSMOS_3T/cosmos_prisma/RIGHT/flirt_qsm.mat -ASCII
R_t(:,:,2) = flirt_qsm(1:3,1:3);
load /Volumes/LaCie/COSMOS_3T/cosmos_prisma/FLEXION/flirt_qsm.mat -ASCII
R_t(:,:,3) = flirt_qsm(1:3,1:3);
load /Volumes/LaCie/COSMOS_3T/cosmos_prisma/EXTENSION/flirt_qsm.mat -ASCII
R_t(:,:,4) = flirt_qsm(1:3,1:3);
R_t(:,:,5) = eye(3);

% (each orientation has own R and z_prjs)
% R is the rotation matrix from image space to common space
load('/Volumes/LaCie/COSMOS_3T/cosmos_prisma/LEFT/QSM_R2S_PRISMA/all.mat','z_prjs')
z_prjs_o(:,1) = z_prjs';
load('/Volumes/LaCie/COSMOS_3T/cosmos_prisma/RIGHT/QSM_R2S_PRISMA/all.mat','z_prjs')
z_prjs_o(:,2) = z_prjs';
load('/Volumes/LaCie/COSMOS_3T/cosmos_prisma/FLEXION/QSM_R2S_PRISMA/all.mat','z_prjs')
z_prjs_o(:,3) = z_prjs';
load('/Volumes/LaCie/COSMOS_3T/cosmos_prisma/EXTENSION/QSM_R2S_PRISMA/all.mat','z_prjs')
z_prjs_o(:,4) = z_prjs';
load('/Volumes/LaCie/COSMOS_3T/cosmos_prisma/NEUTRAL/QSM_R2S_PRISMA/all.mat','z_prjs')
z_prjs_o(:,5) = z_prjs';

for i = 1:5
    z_prjs_c(:,i) = R_t(:,:,i)'*z_prjs_o(:,i);
end

%% COSMOS reconstruction with closed-form solution
% load in registered local field shift maps

unix('gunzip -f /Users/uqhsun8/Downloads/cosmos_prisma/LFS/k_net/knet_lfs_left_flirt.nii.gz');
nii = load_nii('/Users/uqhsun8/Downloads/cosmos_prisma/LFS/k_net/knet_lfs_left_flirt.nii');
lfs(:,:,:,1) = double(nii.img);

unix('gunzip -f /Users/uqhsun8/Downloads/cosmos_prisma/LFS/k_net/knet_lfs_right_flirt.nii.gz');
nii = load_nii('/Users/uqhsun8/Downloads/cosmos_prisma/LFS/k_net/knet_lfs_right_flirt.nii');
lfs(:,:,:,2) = double(nii.img);

unix('gunzip -f /Users/uqhsun8/Downloads/cosmos_prisma/LFS/k_net/knet_lfs_flexion_flirt.nii.gz');
nii = load_nii('/Users/uqhsun8/Downloads/cosmos_prisma/LFS/k_net/knet_lfs_flexion_flirt.nii');
lfs(:,:,:,3) = double(nii.img);

unix('gunzip -f /Users/uqhsun8/Downloads/cosmos_prisma/LFS/k_net/knet_lfs_extension_flirt.nii.gz');
nii = load_nii('/Users/uqhsun8/Downloads/cosmos_prisma/LFS/k_net/knet_lfs_extension_flirt.nii');
lfs(:,:,:,4) = double(nii.img);

nii = load_nii('/Users/uqhsun8/Downloads/cosmos_prisma/LFS/k_net/knet_lfs_center.nii');
lfs(:,:,:,5) = double(nii.img);

mask = and(and(and(and(lfs(:,:,:,1),lfs(:,:,:,2)),lfs(:,:,:,3)),lfs(:,:,:,4)),lfs(:,:,:,5));
mask = double(mask);


% construct k-space kernel for each orientation
% create K-space filter kernel D
%%%%% make this a seperate function in the future
vox = [1 1 1];

Nx = size(lfs,1);
Ny = size(lfs,2);
Nz = size(lfs,3);

for i = 1:5
    FOV = vox.*[Nx,Ny,Nz];
    FOVx = FOV(1);
    FOVy = FOV(2);
    FOVz = FOV(3);

    x = -Nx/2:Nx/2-1;
    y = -Ny/2:Ny/2-1;
    z = -Nz/2:Nz/2-1;
    [kx,ky,kz] = ndgrid(x/FOVx,y/FOVy,z/FOVz);
    % D = 1/3 - kz.^2./(kx.^2 + ky.^2 + kz.^2);
    D = 1/3 - (kx.*z_prjs_c(1,i)+ky.*z_prjs_c(2,i)+kz.*z_prjs_c(3,i)).^2./(kx.^2 + ky.^2 + kz.^2);
    D(floor(Nx/2+1),floor(Ny/2+1),floor(Nz/2+1)) = 0;
    D = fftshift(D);

    kernel(:,:,:,i) = D;
end


for i = 1:5
    lfs_k(:,:,:,i) = fftn(lfs(:,:,:,i).*mask);
end

kernel_sum = sum(abs(kernel).^2, 4);

chi_cosmos = real( ifftn( sum(kernel .* lfs_k, 4) ./ (eps + kernel_sum) ) ) .* mask;

nii = make_nii(-chi_cosmos,vox);
save_nii(nii,'/Users/uqhsun8/Downloads/cosmos_prisma/LFS/k_net/knet_COSMOS.nii');


%%%% inversion of each orientation on registered LFS
nii = load_nii('/media/data/QSM_data/COSMOS_renzo/sorted/patient/9175/QSM_SPGRE_CENTER/QSM_SPGR_GE/src/mag1.nii');
mag = double(nii.img);
for i = 1:5
    disp('--> TV susceptibility inversion on RESHARP...');
    sus_resharp(:,:,:,i) = tvdi(lfs(:,:,:,i),mask,vox,tv_reg,mag,z_prjs_c(:,i),inv_num); 
   
    % save nifti
    nii = make_nii(sus_resharp(:,:,:,i).*mask,vox);
    save_nii(nii,['sus_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '_orien_' num2str(i) '.nii']);
end
