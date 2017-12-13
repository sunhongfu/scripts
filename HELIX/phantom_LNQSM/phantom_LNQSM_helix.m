function phantom_LNQSM_helix(Tik_weight, TV_weight)

Tik_weight = str2num(Tik_weight);
TV_weight = str2num(TV_weight);

%% load Sagar's whole head susceptiblity phantom
s=load('/home/hongfu.sun/data/sagar_phantom/3Dmodel_new.mat');
model=s.model;
%% load the mask
s=load('/home/hongfu.sun/data/sagar_phantom/Brain_mask.mat');
mask_brain=s.brmask;
s=load('/home/hongfu.sun/data/sagar_phantom/Head_mask.mat');
mask_head=s.headmask;
clear s

%%%%%%
% undersample it to 128*128*128!
% otherwise too big!
model = downsample(model,4);
model = downsample(permute(model,[2 1 3]),4);
model = downsample(permute(model,[3 2 1]),4);
model = permute(model,[2 3 1]);

mask_brain = downsample(mask_brain,4);
mask_brain = downsample(permute(mask_brain,[2 1 3]),4);
mask_brain = downsample(permute(mask_brain,[3 2 1]),4);
mask_brain = permute(mask_brain,[2 3 1]);

mask_head = downsample(mask_head,4);
mask_head = downsample(permute(mask_head,[2 1 3]),4);
mask_head = downsample(permute(mask_head,[3 2 1]),4);
mask_head = permute(mask_head,[2 3 1]);



%%%%%%
% add a layer of skull bone (susceptiblity = -2ppm)
r = 4;
[X,Y,Z] = ndgrid(-r:r,-r:r,-r:r);
h = (X.^2/r^2 + Y.^2/r^2 + Z.^2/r^2 <= 1);
ker = h/sum(h(:));
imsize = size(mask_brain);
mask_tmp = convn(mask_brain,ker,'same');
mask_exp = zeros(imsize);
mask_exp(mask_tmp > 0) = 1; % no error tolerance

mask_skull = (mask_exp - mask_brain > 0) & (model == 0);
model(mask_skull) = -2;
%%%%%%%%%%%%


vox = [1 1 1];
z_prjs = [0 0 1];
imsize = size(model);

mask_tissue = ones(imsize);
mask_tissue(model == 9) =0;
mask_tissue(model == -3) =0;
mask_tissue(model == -2) =0;

nii = make_nii(model,vox);
save_nii(nii,'chi.nii');
nii = make_nii(mask_brain,vox);
save_nii(nii,'mask_brain.nii');
nii = make_nii(mask_head,vox);
save_nii(nii,'mask_head.nii');
nii = make_nii(mask_tissue,vox);
save_nii(nii,'mask_tissue.nii');

%% forward calculate the field
Nx = imsize(1);
Ny = imsize(2);
Nz = imsize(3);

% create K-space filter kernel D
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
D = fftshift(D);

field = real(ifftn(D.*fftn(model))).*mask_tissue;

nii = make_nii(field,vox);
save_nii(nii,'field.nii');


% add noise to field map
% % add to imaginary part
% field_noisy_real = awgn(real(field(:)),50,'measured');
% field_noisy_imag = awgn(imag(field(:)),50,'measured');

noise_real = 0.002*randn(size(field));
noise_imag = 0.002*randn(size(field));

field_noisy_real = real(field) + noise_real;
field_noisy_imag = imag(field) + noise_imag;

field_noisy = complex(field_noisy_real, field_noisy_imag);
% field_noisy = reshape(field_noisy,size(field));

% field_noisy = awgn(field(:),50,'measured');
% field_noisy = reshape(field_noisy,size(field));
nii = make_nii(field_noisy,vox);
save_nii(nii,'field_noisy.nii');




%% TFI of the whole head
iFreq = field_noisy*2*pi*42.58*3*15e-3;
delta_TE = 15e-3;
matrix_size = imsize;
% CF = 1/(2*pi)*1e6;
CF = 42.58*3e6;
Mask = mask_tissue;
iMag = Mask;
% iMag = Mask.*model;
N_std = 1;
voxel_size = vox;
B0_dir = z_prjs;



%%%% TIK-QSM
mkdir /home/hongfu.sun/data/phantom_LNQSM
cd /home/hongfu.sun/data/phantom_LNQSM
% tfs_pad = padarray(field,[0 0 20]);
% mask_pad = padarray(mask_tissue,[0 0 20]);
% mask_head_pad = padarray(mask_head,[0 0 20]);
% mask_brain_pad = padarray(mask_brain,[0 0 20]);

tfs_pad = field_noisy;
mask_tissue_pad = mask_tissue;
mask_head_pad = mask_head;
mask_brain_pad = mask_brain;

P = 1 * mask_tissue + 30 * (1 - mask_tissue);
% P_pad = padarray(P,[0 0 20]);
P_pad = P;

% P_pad = 1;

mask_TV = 1 * mask_tissue_pad + 1/30 * (~mask_tissue_pad & mask_head_pad);


% Tik_weight = [0, 5e-4, 1e-3];
% TV_weight = [1e-4, 2e-4, 5e-4];
for i = 1:length(Tik_weight)
	for j = 1:length(TV_weight)
		chi = tikhonov_qsm(tfs_pad, mask_tissue_pad, 1, mask_TV, mask_tissue_pad, 0, TV_weight(j), Tik_weight(i), 0, vox, P_pad, z_prjs, 5000);
		% nii = make_nii(chi(:,:,21:end-20),vox);
		nii = make_nii(chi,vox);
		save_nii(nii,['TIK_hs_TV_' num2str(TV_weight(j)) '_Tik_' num2str(Tik_weight(i)) '_P30_5000_maskTV.nii']);

		chi = tikhonov_qsm(tfs_pad, mask_tissue_pad, 1, mask_head_pad, mask_tissue_pad, 0, TV_weight(j), Tik_weight(i), 0, vox, P_pad, z_prjs, 5000);
		% nii = make_nii(chi(:,:,21:end-20),vox);
		nii = make_nii(chi,vox);
		save_nii(nii,['TIK_hs_TV_' num2str(TV_weight(j)) '_Tik_' num2str(Tik_weight(i)) '_P30_5000.nii']);

		% chi = tikhonov_qsm(tfs_pad, mask_tissue_pad, 1, mask_tissue_pad, mask_tissue_pad, 0, TV_weight(j), Tik_weight(i), 0, vox, P_pad, z_prjs, 200);
		% % nii = make_nii(chi(:,:,21:end-20),vox);
		% nii = make_nii(chi,vox);
		% save_nii(nii,['TIK_ss_TV_' num2str(TV_weight(j)) '_Tik_' num2str(Tik_weight(i)) '_P30_200.nii']);

		% chi = tikhonov_qsm(tfs_pad, mask_tissue_pad, 1, mask_tissue_pad, mask_tissue_pad, 0, TV_weight(j), Tik_weight(i), 0, vox, P_pad, z_prjs, 2000);
		% % nii = make_nii(chi(:,:,21:end-20),vox);
		% nii = make_nii(chi,vox);
		% save_nii(nii,['TIK_ss_TV_' num2str(TV_weight(j)) '_Tik_' num2str(Tik_weight(i)) '_P30_2000.nii']);
	end
end
cd ..

