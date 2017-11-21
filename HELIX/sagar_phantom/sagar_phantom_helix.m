function sagar_phantom_helix(Tik_weight,TV_weight)

TV_weight = str2num(TV_weight);
Tik_weight = str2num(Tik_weight);

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


vox = [1 1 1];
z_prjs = [0 0 1];
imsize = size(model);

mask_tissue = ones(imsize);
mask_tissue(model == 9) =0;
mask_tissue(model == -3) =0;

%nii = make_nii(model,vox);
%save_nii(nii,'chi.nii');
%nii = make_nii(mask_brain,vox);
%save_nii(nii,'mask_brain.nii');
%nii = make_nii(mask_head,vox);
%save_nii(nii,'mask_head.nii');
%nii = make_nii(mask_tissue,vox);
%save_nii(nii,'mask_tissue.nii');

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



%%%% TIK-QSM
iFreq = field;
mkdir /home/hongfu.sun/data/sagar_phantom/TFS_TIK_PRE_ERO0
cd /home/hongfu.sun/data/sagar_phantom/TFS_TIK_PRE_ERO0
tfs_pad = padarray(iFreq,[0 0 20]);
mask_pad = padarray(mask_tissue,[0 0 20]);
mask_head_pad = padarray(mask_head,[0 0 20]);
mask_brain_pad = padarray(mask_brain,[0 0 20]);
% tfs_pad = iFreq;
% mask_pad = mask_tissue;
% mask_head_pad = mask_head;
% mask_brain_pad = mask_brain;
% R_pad = padarray(R,[0 0 20]);
r=0;
% % Tik_weight = [1e-3, 2e-3];
% Tik_weight = 0;
% TV_weight = [1e-4, 2e-4];
for i = 1:length(Tik_weight)
	for j = 1:length(TV_weight)
	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_head_pad, TV_weight, Tik_weight(i), vox, z_prjs, 2000);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_head_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);

 %    chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_brain_pad, mask_brain_pad, TV_weight, Tik_weight(i), vox, z_prjs, 2000);
	% nii = make_nii(chi(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_tissue_brain_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);


	chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight(j), Tik_weight(i), vox, z_prjs, 5000);
	nii = make_nii(chi(:,:,21:end-20),vox);
	save_nii(nii,['TIK_tissue_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_5000.nii']);


 %    chi = tikhonov_qsm(tfs_pad, mask_brain_pad, 1, mask_brain_pad, mask_brain_pad, TV_weight, Tik_weight(i), vox, z_prjs, 2000);
	% nii = make_nii(chi(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_brain_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);

	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 2000);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);
	
	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 500);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_500.nii']);
	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 2000);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);
	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 5000);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_5000.nii']);
	end
end
