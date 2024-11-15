%% load Sagar's whole head susceptiblity phantom
load('3Dmodel_new.mat');
%% load the mask
load('Brain_mask.mat');
load('Head_mask.mat');
mask_brain = brmask;
mask_head = headmask;
clear brmask headmask


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




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESHARP
[RDF, mask_resharp] = resharp(field_noisy,mask_brain,vox,2,1e-6,500);
nii = make_nii(RDF,vox);
save_nii(nii,'resharp_1e-6.nii');
RDF = 267.5*RDF;
Mask = mask_resharp;
iFreq = [];
iMag = mask_brain;
N_std = 1;
matrix_size = size(Mask);
voxel_size = vox;
delta_TE = 1;
CF = 42.6036*1e6;
B0_dir = [0 0 1];

% iLSQR
chi_iLSQR = QSM_iLSQR(RDF,mask_resharp,'H',z_prjs,'voxelsize',vox,'niter',200,'TE',1000*delta_TE,'B0',1);
nii = make_nii(chi_iLSQR,vox);
save_nii(nii,['chi_resharp_iLSQR_ero2.nii']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
iFreq = field_noisy*2*pi*42.58*3*15e-3;
delta_TE = 15e-3;
matrix_size = imsize;
% CF = 1/(2*pi)*1e6;
CF = 42.58*3e6;
% iMag = Mask.*model;
N_std = 1;
voxel_size = vox;
B0_dir = z_prjs;
[RDF, mask_resharp] = resharp(iFreq,mask_brain,vox,2,1e-6,500);

Mask = mask_resharp;
iMag = Mask;

save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
     voxel_size delta_TE CF B0_dir;
% run part of MEDI first
QSM = MEDI_L1('lambda',1000);
nii = make_nii(QSM.*Mask,vox);
save_nii(nii,'MEDI_RESHARP_1e-6_ero2.nii');





% RESHARP ERO3
[RDF, mask_resharp] = resharp(field_noisy,mask_brain,vox,3,1e-6,500);
nii = make_nii(RDF,vox);
save_nii(nii,'resharp_1e-6.nii');
Mask = mask_resharp;
iFreq = [];
iMag = mask_brain;
N_std = 1;
matrix_size = size(Mask);
voxel_size = vox;
delta_TE = 1;
CF = 42.6036*1e6;
B0_dir = [0 0 1];

save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
     voxel_size delta_TE CF B0_dir;
% run part of MEDI first
QSM = MEDI_L1('lambda',1000);
nii = make_nii(QSM.*Mask,vox);
save_nii(nii,'MEDI_RESHARP_1e-6_ero3.nii');

% iLSQR
chi_iLSQR = QSM_iLSQR(RDF,mask_resharp,'H',z_prjs,'voxelsize',vox,'niter',200,'TE',1000*delta_TE,'B0',dicom_info.MagneticFieldStrength);
nii = make_nii(chi_iLSQR,vox);
save_nii(nii,['chi_resharp_iLSQR_ero3.nii']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TGV-QSM

tgv_qsm  -p field_noisy.nii -m mask_brain.nii -f 1 -t 3.7383e-03 -e 2 -o SS_QSM_4 --alpha 0.0003 0.0001 --no-resampling
tgv_qsm  -p field_noisy.nii -m mask_brain.nii -f 1 -t 3.7383e-03 -e 2 -o SS_QSM_5 --alpha 0.00012 0.00004 --no-resampling
tgv_qsm  -p field_noisy.nii -m mask_brain.nii -f 1 -t 3.7383e-03 -e 2 -o SS_QSM_6 --alpha 0.00003 0.00001 --no-resampling
tgv_qsm  -p field_noisy.nii -m mask_brain.nii -f 1 -t 3.7383e-03 -e 2 -o SS_QSM_7 --alpha 0.00009 0.00003 --no-resampling
tgv_qsm  -p field_noisy.nii -m mask_brain.nii -f 1 -t 3.7383e-03 -e 2 -o SS_QSM_8 --alpha 0.000009 0.000003 --no-resampling
tgv_qsm  -p field_noisy.nii -m mask_brain.nii -f 1 -t 3.7383e-03 -e 2 -o SS_QSM_9 --alpha 0.00003 0.00001 --no-resampling 




%% TFI of the brain
iFreq = field_noisy*2*pi*42.58*3*15e-3;
delta_TE = 15e-3;
matrix_size = imsize;
% CF = 1/(2*pi)*1e6;
CF = 42.58*3e6;
Mask = mask_brain;
iMag = Mask;
% iMag = Mask.*model;
N_std = 1;
voxel_size = vox;
B0_dir = z_prjs;

mkdir TFI_brain
cd TFI_brain
% (1) TFI of 0 voxel erosion
% only brain tissue, need whole head later
P_B = 30;
P = 1 * Mask + P_B * (1-Mask);
% Mask_G = 1 * Mask + 1/P_B * (~Mask & mask_head);
Mask_G = Mask;
RDF = 0;
wG = 1;
save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF wG
QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 600*2);
nii = make_nii(QSM,voxel_size);
save_nii(nii,'TFI_brain.nii');



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

mkdir TFI
cd TFI
% (1) TFI of 0 voxel erosion
% only brain tissue, need whole head later
P_B = 30;
P = 1 * Mask + P_B * (1-Mask);
% Mask_G = 1 * Mask + 1/P_B * (~Mask & mask_head);
Mask_G = Mask;
RDF = 0;
wG = 1;
save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF wG
QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 600*2);
nii = make_nii(QSM,voxel_size);
save_nii(nii,'TFI_tissue.nii');


for P_B = 10:10:100
	% 
	P = 1 * Mask + P_B * (1-Mask);
	Mask_G = 1 * Mask + 1/P_B * (~Mask & mask_head);
	RDF = 0;
	wG = 1;
	save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF wG
	QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 600*2);
	nii = make_nii(QSM,voxel_size);
	save_nii(nii,['TFI_head_' num2str(P_B) '.nii']);
end

% % 
% Mask_G = mask_head;
% RDF = 0;
% wG = 1;
% save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF wG
% QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 600*2);
% nii = make_nii(QSM,voxel_size);
% save_nii(nii,'TFI_head_maskhead.nii');
cd ..




%%%% TIK-QSM
mkdir LN-QSM
cd LN-QSM
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

% !!!
% attention
% if to use padding, above P is wrong
% create P from the padded mask instead!


% Pnew_pad = P_pad.*mask_head_pad;
% Pnewnew_pad = Pnew_pad + 1/30*(1 - mask_head_pad);
mask_TV = 1 * mask_tissue_pad + 1/30 * (~mask_tissue_pad & mask_head_pad);


Tik_weight = [0, 5e-4, 1e-3];
% Tik_weight = [1e-3, 0];
TV_weight = [1e-4, 2e-4, 5e-4];
for i = 1:length(Tik_weight)
	for j = 1:length(TV_weight)
		chi = tikhonov_qsm(tfs_pad, mask_tissue_pad, 1, mask_TV, mask_tissue_pad, 0, TV_weight(j), Tik_weight(i), 0, vox, P_pad, z_prjs, 2000);
		% nii = make_nii(chi(:,:,21:end-20),vox);
		nii = make_nii(chi,vox);
		save_nii(nii,['TIK_hs_TV_' num2str(TV_weight(j)) '_Tik_' num2str(Tik_weight(i)) '_P30_2000_maskTV.nii']);

		chi = tikhonov_qsm(tfs_pad, mask_tissue_pad, 1, mask_head_pad, mask_tissue_pad, 0, TV_weight(j), Tik_weight(i), 0, vox, P_pad, z_prjs, 2000);
		% nii = make_nii(chi(:,:,21:end-20),vox);
		nii = make_nii(chi,vox);
		save_nii(nii,['TIK_hs_TV_' num2str(TV_weight(j)) '_Tik_' num2str(Tik_weight(i)) '_P30_2000.nii']);

		chi = tikhonov_qsm(tfs_pad, mask_tissue_pad, 1, mask_tissue_pad, mask_tissue_pad, 0, TV_weight(j), Tik_weight(i), 0, vox, P_pad, z_prjs, 200);
		% nii = make_nii(chi(:,:,21:end-20),vox);
		nii = make_nii(chi,vox);
		save_nii(nii,['TIK_ss_TV_' num2str(TV_weight(j)) '_Tik_' num2str(Tik_weight(i)) '_P30_200.nii']);

		chi = tikhonov_qsm(tfs_pad, mask_tissue_pad, 1, mask_tissue_pad, mask_tissue_pad, 0, TV_weight(j), Tik_weight(i), 0, vox, P_pad, z_prjs, 2000);
		% nii = make_nii(chi(:,:,21:end-20),vox);
		nii = make_nii(chi,vox);
		save_nii(nii,['TIK_ss_TV_' num2str(TV_weight(j)) '_Tik_' num2str(Tik_weight(i)) '_P30_2000.nii']);
	end
end
cd ..




















% %% wrap the phase and add noise?
% gamma = 2*pi*42.58;
% B0 = 3;
% TE = 15e-3;
% phase = gamma.*field.*B0.*TE;
% complexData = mask_tissue.*exp(1i.*phase);
% % complexData(:) = awgn(complexData(:), 100, 'measured');

% nii = make_nii(angle(complexData),vox);
% save_nii(nii,'phaseNoisy.nii');

% nii = make_nii(abs(complexData),vox);
% save_nii(nii,'magNoisy.nii');

% % unwrap the phase using graphic cut
% iFreq = unwrapping_gc(angle(complexData),mask_tissue,vox);
% nii = make_nii(iFreq,vox);
% save_nii(nii,'iFreq_gc.nii');

% % unwrap using prelude
% !prelude -a magNoisy.nii -p phaseNoisy.nii -u iFreq_pre.nii -m mask_brain.nii -n 12

% nii = load_nii('iFreq_pre.nii');
% unph_pre = double(nii.img)-2*pi;


% % laplacian unwrapping
% disp('--> unwrap aliasing phase using laplacian...');
%     imsize = size(complexData);
%     unph = unwrapLaplacian(angle(complexData), imsize,vox);
%     nii = make_nii(unph, vox);
%     save_nii(nii,'unph_lap.nii');


% %% TFI of the whole head
% iFreq = unph_pre;
% delta_TE = 15e-3;
% matrix_size = imsize;
% % CF = 1/(2*pi)*1e6;
% CF = 42.58*3e6;
% Mask = mask_tissue;
% iMag = Mask;
% % iMag = Mask.*model;
% N_std = 1;
% voxel_size = vox;
% B0_dir = z_prjs;

% mkdir TFS_TFI_ERO0
% cd TFS_TFI_ERO0
% % (1) TFI of 0 voxel erosion
% % only brain tissue, need whole head later
% P_B = 30;
% P = 1 * Mask + P_B * (1-Mask);
% Mask_G = 1 * Mask + 1/P_B * (~Mask & mask_head);
% % Mask_G = Mask;
% RDF = 0;
% wG = 1;
% save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF wG
% QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 600*2);
% nii = make_nii(QSM,voxel_size);
% save_nii(nii,'TFI_pre_head_ero0.nii');
% cd ..


% %% TFI of the whole tissue
% iFreq = unph;
% delta_TE = 15e-3;
% matrix_size = imsize;
% % CF = 1/(2*pi)*1e6;
% CF = 42.58*3e6;
% Mask = mask_tissue;
% iMag = Mask;
% % iMag = Mask.*model;
% N_std = 1;
% voxel_size = vox;
% B0_dir = z_prjs;


% mkdir TFS_TFI_ERO0
% cd TFS_TFI_ERO0
% % (1) TFI of 0 voxel erosion
% % only brain tissue, need whole head later
% P_B = 30;
% P = 1 * Mask + P_B * (1-Mask);
% % Mask_G = 1 * Mask + 1/P_B * (~Mask & mask_head);
% Mask_G = Mask;
% RDF = 0;
% wG = 1;
% save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF wG
% QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 600*2);
% nii = make_nii(QSM,voxel_size);
% save_nii(nii,'TFI_lap_tissue_ero0.nii');
% cd ..


% %% TFI of the whole brain
% iFreq = unph_pre;
% delta_TE = 15e-3;
% matrix_size = imsize;
% % CF = 1/(2*pi)*1e6;
% CF = 42.58*3e6;
% Mask = mask_brain;
% iMag = Mask;
% % iMag = Mask.*model;
% N_std = 1;
% voxel_size = vox;
% B0_dir = z_prjs;


% mkdir TFS_TFI_ERO0
% cd TFS_TFI_ERO0
% % (1) TFI of 0 voxel erosion
% % only brain tissue, need whole head later
% P_B = 30;
% P = 1 * Mask + P_B * (1-Mask);
% % Mask_G = 1 * Mask + 1/P_B * (~Mask & mask_head);
% Mask_G = Mask;
% RDF = 0;
% wG = 1;
% save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF wG
% QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 600*2);
% nii = make_nii(QSM,voxel_size);
% save_nii(nii,'TFI_pre_brain_ero0.nii');
% cd ..





% %%%% TIK-QSM
% iFreq = unph_pre/(gamma*B0*TE);
% mkdir TFS_TIK_PRE_ERO0
% cd TFS_TIK_PRE_ERO0
% tfs_pad = padarray(iFreq,[0 0 20]);
% mask_pad = padarray(mask_tissue,[0 0 20]);
% mask_head_pad = padarray(mask_head,[0 0 20]);
% mask_brain_pad = padarray(mask_brain,[0 0 20]);
% % tfs_pad = iFreq;
% % mask_pad = mask_tissue;
% % mask_head_pad = mask_head;
% % mask_brain_pad = mask_brain;
% % R_pad = padarray(R,[0 0 20]);
% r=0;
% % Tik_weight = [1e-3, 2e-3];
% Tik_weight = 1e-6;
% TV_weight = 2e-4;
% for i = 1:length(Tik_weight)
% 	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_head_pad, TV_weight, Tik_weight(i), vox, z_prjs, 2000);
% 	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
% 	% save_nii(nii,['TIK_head_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);

%  %    chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_brain_pad, mask_brain_pad, TV_weight, Tik_weight(i), vox, z_prjs, 2000);
% 	% nii = make_nii(chi(:,:,21:end-20),vox);
% 	% save_nii(nii,['TIK_tissue_brain_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);


% 	chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 2000);
% 	nii = make_nii(chi(:,:,21:end-20),vox);
% 	save_nii(nii,['TIK_pre_tissue_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);


%  %    chi = tikhonov_qsm(tfs_pad, mask_brain_pad, 1, mask_brain_pad, mask_brain_pad, TV_weight, Tik_weight(i), vox, z_prjs, 2000);
% 	% nii = make_nii(chi(:,:,21:end-20),vox);
% 	% save_nii(nii,['TIK_brain_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);

% 	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 2000);
% 	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
% 	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);
	
% 	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 500);
% 	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
% 	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_500.nii']);
% 	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 2000);
% 	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
% 	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);
% 	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 5000);
% 	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
% 	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_5000.nii']);
% end
% cd ..


