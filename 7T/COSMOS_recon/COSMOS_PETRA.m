
% (1) 12 DOF to register the images
/usr/local/fsl/5.0.9/bin/flirt -in /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/extension/PETRA/src/mag_corr1.nii -ref /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/neutral/PETRA/src/mag_corr1.nii -out /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/extension/PETRA/flirt_mag_12DOF.nii.gz -omat /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/extension/PETRA/flirt_mag_12DOF.mat -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear

/usr/local/fsl/5.0.9/bin/flirt -in /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/flexion/PETRA/src/mag_corr1.nii -ref /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/neutral/PETRA/src/mag_corr1.nii -out /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/flexion/PETRA/flirt_mag_12DOF.nii.gz -omat /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/flexion/PETRA/flirt_mag_12DOF.mat -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear

/usr/local/fsl/5.0.9/bin/flirt -in /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/right/PETRA/src/mag_corr1.nii -ref /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/neutral/PETRA/src/mag_corr1.nii -out /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/right/PETRA/flirt_mag_12DOF.nii.gz -omat /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/right/PETRA/flirt_mag_12DOF.mat -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear

/usr/local/fsl/5.0.9/bin/flirt -in /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/left/PETRA/src/mag_corr1.nii -ref /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/neutral/PETRA/src/mag_corr1.nii -out /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/left/PETRA/flirt_mag_12DOF.nii.gz -omat /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/left/PETRA/flirt_mag_12DOF.mat -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear




% (1) 6 DOF to register the images
/usr/local/fsl/5.0.9/bin/flirt -in /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/extension/PETRA/src/mag_corr1.nii -ref /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/neutral/PETRA/src/mag_corr1.nii -out /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/extension/PETRA/flirt_mag_6DOF.nii.gz -omat /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/extension/PETRA/flirt_mag_6DOF.mat -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear

/usr/local/fsl/5.0.9/bin/flirt -in /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/flexion/PETRA/src/mag_corr1.nii -ref /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/neutral/PETRA/src/mag_corr1.nii -out /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/flexion/PETRA/flirt_mag_6DOF.nii.gz -omat /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/flexion/PETRA/flirt_mag_6DOF.mat -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear

/usr/local/fsl/5.0.9/bin/flirt -in /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/right/PETRA/src/mag_corr1.nii -ref /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/neutral/PETRA/src/mag_corr1.nii -out /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/right/PETRA/flirt_mag_6DOF.nii.gz -omat /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/right/PETRA/flirt_mag_6DOF.mat -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear

/usr/local/fsl/5.0.9/bin/flirt -in /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/left/PETRA/src/mag_corr1.nii -ref /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/neutral/PETRA/src/mag_corr1.nii -out /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/left/PETRA/flirt_mag_6DOF.nii.gz -omat /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/left/PETRA/flirt_mag_6DOF.mat -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear




% apply the transformation to local field map
/usr/local/fsl/5.0.9/bin/flirt -in /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/extension/PETRA/RESHARP/lfs_resharp_0_smvrad2_cgs_1e-06.nii -applyxfm -init /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/extension/PETRA/flirt_mag_12DOF.mat -out /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/extension/PETRA/flirt_lfs.nii -paddingsize 0.0 -interp trilinear -ref /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/neutral/PETRA/RESHARP/lfs_resharp_0_smvrad2_cgs_1e-06.nii

/usr/local/fsl/5.0.9/bin/flirt -in /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/flexion/PETRA/RESHARP/lfs_resharp_0_smvrad2_cgs_1e-06.nii -applyxfm -init /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/flexion/PETRA/flirt_mag_12DOF.mat -out /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/flexion/PETRA/flirt_lfs.nii -paddingsize 0.0 -interp trilinear -ref /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/neutral/PETRA/RESHARP/lfs_resharp_0_smvrad2_cgs_1e-06.nii

/usr/local/fsl/5.0.9/bin/flirt -in /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/right/PETRA/RESHARP/lfs_resharp_0_smvrad2_cgs_1e-06.nii -applyxfm -init /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/right/PETRA/flirt_mag_12DOF.mat -out /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/right/PETRA/flirt_lfs.nii -paddingsize 0.0 -interp trilinear -ref /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/neutral/PETRA/RESHARP/lfs_resharp_0_smvrad2_cgs_1e-06.nii

/usr/local/fsl/5.0.9/bin/flirt -in /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/left/PETRA/RESHARP/lfs_resharp_0_smvrad2_cgs_1e-06.nii -applyxfm -init /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/left/PETRA/flirt_mag_12DOF.mat -out /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/left/PETRA/flirt_lfs.nii -paddingsize 0.0 -interp trilinear -ref /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/neutral/PETRA/RESHARP/lfs_resharp_0_smvrad2_cgs_1e-06.nii





% calculate the angles of B0 with registered local field maps
% R is transformation matrix from individual image space to common space (FLIRT matrix)
% common space coordinates = R* object image space coordinates
load /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/extension/PETRA/flirt_mag_6DOF.mat -ASCII
R_t(:,:,1) = flirt_mag_6DOF(1:3,1:3);

load /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/flexion/PETRA/flirt_mag_6DOF.mat -ASCII
R_t(:,:,2) = flirt_mag_6DOF(1:3,1:3);

load /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/right/PETRA/flirt_mag_6DOF.mat -ASCII
R_t(:,:,3) = flirt_mag_6DOF(1:3,1:3);

load /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/left/PETRA/flirt_mag_6DOF.mat -ASCII
R_t(:,:,4) = flirt_mag_6DOF(1:3,1:3);

R_t(:,:,5) = eye(3);


% (each orientation has own R and z_prjs)
% R is the rotation matrix from image space to common space
load('/home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/extension/QSM_MEGE_7T/raw.mat','z_prjs');
z_prjs_o(:,1) = z_prjs';

load('/home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/flexion/QSM_MEGE_7T/raw.mat','z_prjs');
z_prjs_o(:,2) = z_prjs';

load('/home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/right/QSM_MEGE_7T/raw.mat','z_prjs');
z_prjs_o(:,3) = z_prjs';

load('/home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/left/QSM_MEGE_7T/raw.mat','z_prjs');
z_prjs_o(:,4) = z_prjs';

load('/home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/neutral/QSM_MEGE_7T/raw.mat','z_prjs');
z_prjs_o(:,5) = z_prjs';

for i = 1:5
    z_prjs_c(:,i) = R_t(:,:,i)'*z_prjs_o(:,i);
end


%% COSMOS reconstruction with closed-form solution
% load in registered local field shift maps
unix('gunzip -f /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/extension/PETRA/*.gz');
nii = load_nii('/home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/extension/PETRA/flirt_lfs.nii');
lfs(:,:,:,1) = double(nii.img);

unix('gunzip -f /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/flexion/PETRA/*.gz');
nii = load_nii('/home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/flexion/PETRA/flirt_lfs.nii');
lfs(:,:,:,2) = double(nii.img);

unix('gunzip -f /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/right/PETRA/*.gz');
nii = load_nii('/home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/right/PETRA/flirt_lfs.nii');
lfs(:,:,:,3) = double(nii.img);

unix('gunzip -f /home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/left/PETRA/*.gz');
nii = load_nii('/home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/left/PETRA/flirt_lfs.nii');
lfs(:,:,:,4) = double(nii.img);

nii = load_nii('/home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/neutral/PETRA/RESHARP/lfs_resharp_0_smvrad2_cgs_1e-06.nii');
lfs(:,:,:,5) = double(nii.img);

mask = and(and(and(and(lfs(:,:,:,1),lfs(:,:,:,2)),lfs(:,:,:,3)),lfs(:,:,:,4)),lfs(:,:,:,5));
mask = double(mask);

% construct k-space kernel for each orientation
% create K-space filter kernel D
%%%%% make this a seperate function in the future
load('/home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/neutral/QSM_MEGE_7T/raw.mat','vox');

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

nii = make_nii(chi_cosmos,vox);
save_nii(nii,'/home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/PETRA/cosmos_5_6DOF_rad2.nii');

