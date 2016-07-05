% STI
load QSM_SPGRE_LEFT/mag_flirt.mat -ascii
R_t(:,:,1) = mag_flirt(1:3,1:3);
load QSM_SPGRE_RIGHT/mag_flirt.mat -ascii
R_t(:,:,2) = mag_flirt(1:3,1:3);
load QSM_SPGRE_FORWARD/mag_flirt.mat -ascii
R_t(:,:,3) = mag_flirt(1:3,1:3);
load QSM_SPGRE_BACKWARD/mag_flirt.mat -ascii
R_t(:,:,4) = mag_flirt(1:3,1:3);
R_t(:,:,5) = eye(3);

% projections of B0 direction on common space coordinates is:
% R*z_prjs, z_prjs derived from DICOM headers for each orientation
load QSM_SPGRE_LEFT/QSM_SPGR_GE/z_prjs.mat
z_prjs_o(:,1) = z_prjs';
load QSM_SPGRE_RIGHT/QSM_SPGR_GE/z_prjs.mat
z_prjs_o(:,2) = z_prjs';
load QSM_SPGRE_FORWARD/QSM_SPGR_GE/z_prjs.mat
z_prjs_o(:,3) = z_prjs';
load QSM_SPGRE_BACKWARD/QSM_SPGR_GE/z_prjs.mat
z_prjs_o(:,4) = z_prjs';
load QSM_SPGRE_CENTER/QSM_SPGR_GE/z_prjs.mat
z_prjs_o(:,5) = z_prjs';

for i = 1:5
    z_prjs_c(:,i) = R_t(:,:,i)'*z_prjs_o(:,i);
end


% load in registered local field shift maps
unix('gunzip -f QSM_SPGRE_LEFT/QSM_SPGR_GE/RESHARP/*.gz');
nii = load_nii('QSM_SPGRE_LEFT/QSM_SPGR_GE/RESHARP/lfs_resharp_flirt.nii');
lfs(:,:,:,1) = double(nii.img);
unix('gunzip -f QSM_SPGRE_RIGHT/QSM_SPGR_GE/RESHARP/*.gz');
nii = load_nii('QSM_SPGRE_RIGHT/QSM_SPGR_GE/RESHARP/lfs_resharp_flirt.nii');
lfs(:,:,:,2) = double(nii.img);
unix('gunzip -f QSM_SPGRE_FORWARD/QSM_SPGR_GE/RESHARP/*.gz');
nii = load_nii('QSM_SPGRE_FORWARD/QSM_SPGR_GE/RESHARP/lfs_resharp_flirt.nii');
lfs(:,:,:,3) = double(nii.img);
unix('gunzip -f QSM_SPGRE_BACKWARD/QSM_SPGR_GE/RESHARP/*.gz');
nii = load_nii('QSM_SPGRE_BACKWARD/QSM_SPGR_GE/RESHARP/lfs_resharp_flirt.nii');
lfs(:,:,:,4) = double(nii.img);
nii = load_nii('QSM_SPGRE_CENTER/QSM_SPGR_GE/RESHARP/lfs_resharp_tik_0.0001_num_500.nii');
lfs(:,:,:,5) = double(nii.img);


mask = and(and(and(and(lfs(:,:,:,1),lfs(:,:,:,2)),lfs(:,:,:,3)),lfs(:,:,:,4)),lfs(:,:,:,5));



% STI kernels
H_Matrix = zeros(5,3); % 5 directions in total
H_Deg = zeros(5,1);


for ndir = 1:5
    H_Vec = z_prjs_c(:,ndir);
    
    H_Matrix(ndir,:) = H_Vec;
    H_Deg(ndir) = acosd(H_Vec(3));
    
    figure(20), hold on, plot3(linspace(0, H_Vec(1), 100), linspace(0, H_Vec(2), 100), linspace(0, H_Vec(3), 100), 'color', rand(3,1))
    grid on, title('Direction vectors')
end
figure(21), plot(H_Deg, 'marker', '*'), axis tight, title('Degrees of rotation')



%% Iterative STI recon with LSQR
% construct k-space kernel for each orientation
% create K-space filter kernel D
%%%%% make this a seperate function in the future

vox = [1 1 1];
msk = mask;
N = size(mask);

Nx = size(lfs,1);
Ny = size(lfs,2);
Nz = size(lfs,3);

FOV = vox.*[Nx,Ny,Nz];
FOVx = FOV(1);
FOVy = FOV(2);
FOVz = FOV(3);

x = -Nx/2:Nx/2-1;
y = -Ny/2:Ny/2-1;
z = -Nz/2:Nz/2-1;
[kx,ky,kz] = ndgrid(x/FOVx,y/FOVy,z/FOVz);
kx = fftshift(kx);      ky = fftshift(ky);      kz = fftshift(kz);


% [ky,kx,kz] = meshgrid(-N(2)/2:N(2)/2-1,-N(1)/2:N(1)/2-1,-N(3)/2:N(3)/2-1);      % k-space grid
% kx = fftshift(kx);      ky = fftshift(ky);      kz = fftshift(kz);

N_direction = 5;        % no of directions

Phase_tissue = zeros(size(lfs));
for ind = 1:N_direction
    Phase_tissue(:,:,:,ind) = fftn(lfs(:,:,:,ind));
end

param = [];
param.SS = N;
param.N_direction = N_direction;
param.H_Matrix = H_Matrix;
param.kx = kx;      param.ky = ky;      param.kz = kz;
param.k2 = kx.^2 + ky.^2 + kz.^2;

lsqr_tol = 1e-2;                            % LSQR tolerance
lsqr_iter = 30;                             % no of LSQR iterations    

tic
    [res, flag, relres, iter] = lsqr(@apply_STI, Phase_tissue(:), lsqr_tol, lsqr_iter, [], [], [], param);  
    disp(['Flag: ', num2str(flag), '  Relres: ', num2str(relres), '  Iter: ', num2str(iter)])
toc

Fchi_res = reshape(res, [N,6]);             % susceptibility tensor in k-space

chi_res = zeros(size(Fchi_res));
for ind = 1:6
    chi_res(:,:,:,ind) = real( ifftn(Fchi_res(:,:,:,ind)) ) .* msk;             % susceptibility tensor in image space
end

nii = make_nii(chi_res,vox);
save_nii(nii,'chi_res.nii');



%% Compute eigenvalues at each voxel

Chi_tensor = zeros([N, 3, 3]);
Chi_tensor(:,:,:,1,1) = chi_res(:,:,:,1);
Chi_tensor(:,:,:,1,2) = chi_res(:,:,:,2);
Chi_tensor(:,:,:,2,1) = chi_res(:,:,:,2);
Chi_tensor(:,:,:,1,3) = chi_res(:,:,:,3);
Chi_tensor(:,:,:,3,1) = chi_res(:,:,:,3);
Chi_tensor(:,:,:,2,2) = chi_res(:,:,:,4);
Chi_tensor(:,:,:,2,3) = chi_res(:,:,:,5);
Chi_tensor(:,:,:,3,2) = chi_res(:,:,:,5);
Chi_tensor(:,:,:,3,3) = chi_res(:,:,:,6);

mask_tensor = msk(:);

Chi_tensor = permute(Chi_tensor, [4,5,1,2,3]);
chi_tensor = reshape(Chi_tensor, [3,3, numel(mask_tensor)]);

Chi_eig = zeros(numel(mask_tensor),3);
Chi_eig_vectors = zeros(numel(mask_tensor),3,3);

tic
for v = 1:length(mask_tensor)
    if mask_tensor(v) ~= 0
        [V,D] = eig(chi_tensor(:,:,v));
        Chi_eig(v,:) = diag(D)';
        Chi_eig_vectors(v,:,:) = V;
    end
end
toc

Chi_eig = reshape(Chi_eig, [N, 3]);
Chi_eig_vectors = reshape(Chi_eig_vectors, [N,3,3]);

nii = make_nii(Chi_eig,vox);
save_nii(nii,'Chi_eig.nii');


%% display Mean Magnetic Susceptibility (MMS) and Magnetic Susceptibility Anisotropy (MSA)

MMS = mean(Chi_eig,4);
MSA = Chi_eig(:,:,:,3) - (Chi_eig(:,:,:,1) + Chi_eig(:,:,:,2)) / 2; 

nii = make_nii(MMS,vox);
save_nii(nii,'MMS.nii');

nii = make_nii(MSA,vox);
save_nii(nii,'MSA.nii');


% save the eigen values and eigen vector of the most paramagnetic component (largest eigen value)
eig_value_principle = Chi_eig(:,:,:,3);
save('eig_value_principle.mat','eig_value_principle');

eig_vector_principle = Chi_eig_vectors(:,:,:,:,3);
save('eig_vector_principle.mat','eig_vector_principle');

save all_STI.mat
