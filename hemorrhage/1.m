% hemorrhage fix
% superposition
[status,cmdout] = unix('find /media/data/Hongfu/Project_Hemorrhage/recon/bright -name QSM*');
list = strsplit(cmdout,'\n');

for i = 1:length(list)-1
	clearvars -except list i;
	cd(list{i});


% load in all.mat
load all.mat

mkdir('superposition_lap');
cd('superposition_lap');


imsize = size(img_cmb);

% generate brain mask
unix('rm BET*');
bet_thr = 0.45;
setenv('bet_thr',num2str(bet_thr));
unix('bet ../combine/mag_cmb.nii BET -f ${bet_thr} -m -R');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);


% segment the hemorrhage
	% blur the magnitude
	img_smooth = smooth3(img_cmb,'box',[3,3,1]);
	nii = make_nii(angle(img_smooth),voxelSize);
	save_nii(nii,'ph_smooth.nii');
	nii = make_nii(abs(img_smooth),voxelSize);
	save_nii(nii,'mag_smooth.nii');

	% threshold the magnitude
	hemo_mask = mask;
	hemo_mask(abs(img_smooth)<=0.5) = 0;


	% hemo_mask_new = ones(imsize);

	% hemo_mask_new(158:198,152:213,31:54) = hemo_mask(158:198,152:213,31:54);
	% hemo_mask = hemo_mask_new;

	nii = make_nii(hemo_mask,voxelSize);
	save_nii(nii,'hemo_mask.nii');


% laplacian unwrapping after
% unph = unwrapLaplacian(unwrapped_phase.*mask, size(img_cmb), voxelSize);
unph = unwrapLaplacian(angle(img_cmb).*mask, size(img_cmb), voxelSize);
nii = make_nii(unph, voxelSize);
save_nii(nii,'unph_lap.nii');
unwrapped_phase = unph;


% normalize to ppm unit
TE = params.protocol_header.alTE{1}/1e6;
B_0 = params.protocol_header.m_flMagneticFieldStrength;
gamma = 2.675222e8;
tfs = unwrapped_phase./(gamma*TE*B_0)*1e6; % unit ppm
nii = make_nii(tfs,voxelSize);
save_nii(nii,'tfs.nii');



% polyfit
% tfs_poly = poly3d(tfs,hemo_mask);
tfs_poly = poly3d(tfs,mask);
nii = make_nii(tfs_poly,voxelSize);
save_nii(nii,'tfs_poly.nii');



% % (1) PDF to remove air
z_prjs = [-sNormal.dSag, -sNormal.dCor, sNormal.dTra];


% (3) LBV to remove air
lfs_lbv_noAir = LBV(tfs_poly,mask,imsize,voxelSize,0.01,2); % strip 2 layers
nii = make_nii(lfs_lbv_noAir,voxelSize);
save_nii(nii,'lfs_lbv_noAir.nii');
mask_lbv_noAir =ones(imsize);
mask_lbv_noAir(lfs_lbv_noAir==0) = 0;
nii = make_nii(mask_lbv_noAir);
save_nii(nii,'mask_lbv_noAir.nii');

lfs_resharp_noAir = lfs_lbv_noAir;
mask_resharp_noAir = mask_lbv_noAir;



% (2) REHSARP
tv_reg = 5e-4;
weights = abs(img_cmb).*mask_resharp_noAir.*hemo_mask;
sus_regular_mask_resharp = tvdi(lfs_resharp_noAir,mask_resharp_noAir,voxelSize,tv_reg,weights,z_prjs,200); 
nii = make_nii(sus_regular_mask_resharp.*mask_resharp_noAir,voxelSize);
save_nii(nii,['sus_regular_mask_resharp' num2str(tv_reg) '.nii']);


% update the hemorrhage mask (sus_hemo_mask)
sus_hemo_mask = zeros(imsize);
sus_hemo_mask(sus_regular_mask_resharp>=0.5) = 1;
sus_hemo_mask_new = zeros(imsize);
sus_hemo_mask_new(152:213,152:213,31:50) = sus_hemo_mask(152:213,152:213,31:50);
nii = make_nii(sus_hemo_mask_new,voxelSize);
save_nii(nii,'sus_hemo_mask_new.nii');
sus_hemo_mask = sus_hemo_mask_new;


tv_reg = 5e-4;
weights = abs(img_cmb).*mask_resharp_noAir;
sus_regular_resharp = tvdi(lfs_resharp_noAir,mask_resharp_noAir,voxelSize,tv_reg,weights,z_prjs,200); 
nii = make_nii(sus_regular_resharp.*mask_resharp_noAir,voxelSize);
save_nii(nii,['sus_regular_resharp' num2str(tv_reg) '.nii']);

% % (3) LBV
% tv_reg = 5e-4;
% weights = abs(img_cmb).*mask_lbv_noAir.*hemo_mask;
% sus_regular_mask_lbv = tvdi(lfs_lbv_noAir,mask_lbv_noAir,voxelSize,tv_reg,weights,z_prjs,200); 
% nii = make_nii(sus_regular_mask_lbv,voxelSize);
% save_nii(nii,['sus_regular_mask_lbv' num2str(tv_reg) '.nii']);


% % RESHARP to remove hemorrhage (a second RESHARP)
% smv_rad = 3;
% tik_reg = 5e-4; % try different parameters?
% % [lfs_resharp_noHemo,mask_resharp_Hemo] = resharp(lfs_resharp_noAir,hemo_mask,voxelSize,smv_rad,tik_reg);
% [lfs_resharp_noHemo,mask_resharp_Hemo] = resharp(lfs_resharp_noAir,1-sus_hemo_mask,voxelSize,smv_rad,tik_reg);
% nii = make_nii(lfs_resharp_noHemo.*mask_resharp_noAir,voxelSize);
% save_nii(nii,'lfs_resharp_noHemo.nii');
% nii = make_nii(mask_resharp_Hemo,voxelSize);
% save_nii(nii,'mask_resharp_Hemo.nii');


% % LBV to remove hemorrhage
lfs_lbv_noHemo = LBV(tfs_poly,mask.*(1-sus_hemo_mask),imsize,voxelSize,0.01,2); % strip 2 layers
nii = make_nii(lfs_lbv_noHemo,voxelSize);
save_nii(nii,'lfs_lbv_noHemo.nii');
mask_lbv_remainbrain =ones(imsize);
mask_lbv_remainbrain(lfs_lbv_noHemo==0) = 0;
nii = make_nii(mask_lbv_remainbrain);
save_nii(nii,'mask_lbv_remainbrain.nii');

lfs_resharp_noHemo = lfs_lbv_noHemo;
mask_resharp_Hemo = mask_lbv_remainbrain;

% % RESHARP to remove hemorrhage from the beginning, togother with air removal
% [lfs_resharp_noHemo,mask_resharp_noHemo] = resharp(tfs_poly,mask.*hemo_mask,voxelSize,smv_rad,tik_reg);
% nii = make_nii(lfs_resharp_noHemo,voxelSize);
% save_nii(nii,'lfs_resharp_noHemo.nii');

% inversion on the remaining of the brain
tv_reg = 5e-4;
weights = abs(img_cmb).*mask_resharp_noAir.*mask_resharp_Hemo;
sus_resharp_noHemo = tvdi(lfs_resharp_noHemo,mask_resharp_noAir.*mask_resharp_Hemo,voxelSize,tv_reg,weights,z_prjs,200); 
nii = make_nii(sus_resharp_noHemo.*mask_resharp_noAir.*mask_resharp_Hemo,voxelSize);
save_nii(nii,['sus_resharp_noHemo' num2str(tv_reg) '.nii']);


% super add together
% sus_super = sus_resharp_noHemo.*mask_resharp_noAir.*mask_resharp_Hemo + sus_regular_mask_resharp.*(1-hemo_mask);
sus_super = sus_resharp_noHemo.*mask_resharp_noAir.*mask_resharp_Hemo + sus_regular_mask_resharp.*mask_resharp_noAir.*(1-mask_resharp_Hemo);
nii = make_nii(sus_super,voxelSize);
save_nii(nii,'sus_super.nii');


% % % LBV to remove hemorrhage
% lfs_lbv_noHemo = LBV(lfs_resharp_noAir,hemo_mask,imsize,voxelSize,0.01,1); % strip 2 layers
% nii = make_nii(lfs_lbv_noHemo,voxelSize);
% save_nii(nii,'lfs_lbv_noHemo.nii');
% mask_lbv_remainbrain =ones(imsize);
% mask_lbv_remainbrain(lfs_lbv_noHemo==0) = 0;
% nii = make_nii(mask_lbv_remainbrain);
% save_nii(nii,'mask_lbv_remainbrain.nii');


% % inversion on the remaining of the brain
% tv_reg = 5e-4;
% weights = abs(img_cmb).*mask_lbv_remainbrain;
% sus_lbv_remainbrain = tvdi(lfs_lbv_noHemo,mask_lbv_remainbrain,voxelSize,tv_reg,weights,z_prjs,200); 
% nii = make_nii(sus_lbv_remainbrain,voxelSize);
% save_nii(nii,['sus_lbv_remainbrain' num2str(tv_reg) '.nii']);



% % super add together
% sus_super = sus_lbv_remainbrain.*mask_lbv_remainbrain.*mask_pdf_ero + sus_regular_mask_pdf.*(1 - mask_lbv_remainbrain).*mask_pdf_ero;
% % sus_super = (sus_lbv_remainbrain + sus_dipole.*(1 - mask_lbv_remainbrain)).*mask_pdf_ero;
% nii = make_nii(sus_super,voxelSize);
% save_nii(nii,'sus_super.nii');



% baseline fix
%%%%% make this a seperate function in the future
vox = voxelSize;
Nx = size(sus_super,1);
Ny = size(sus_super,2);
Nz = size(sus_super,3);
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

W = abs(img_cmb).*mask_resharp_noAir.*hemo_mask;
x1 = W.*ifftn(D.*fftn(mask_resharp_noAir.*(1-mask_resharp_Hemo)));
x2 = W.*(lfs_resharp_noAir - ifftn(D.*fftn(sus_super)));
x1 = x1(:);
x2 = x2(:);
o = x1'*x2/(x1'*x1)

sus_super_fix = sus_super + o*(mask_resharp_noAir.*(1-mask_resharp_Hemo));
nii = make_nii(sus_super_fix,voxelSize);
save_nii(nii,'sus_super_fix.nii');






end


























% % PDF to remove hemorrhage
% weights = abs(img_cmb).*mask_pdf_ero.*hemo_mask;
% [lfs_pdf_noHemo,mask_pdf_remainbrain] = pdf(lfs_pdf_noAir,hemo_mask,voxelSize,smv_rad,weights,z_prjs);
% nii = make_nii(lfs_pdf_noHemo,voxelSize);
% save_nii(nii,'lfs_pdf_noHemo.nii');





% % LBV to remove hemorrhage
% lfs_lbv_noHemo = LBV(lfs_lbv_noAir,hemo_mask,imsize,voxelSize,0.01,2); % strip 2 layers
% nii = make_nii(lfs_lbv_noHemo,voxelSize);
% save_nii(nii,'lfs_lbv_noHemo.nii');
% mask_lbv_remainbrain =ones(imsize);
% mask_lbv_remainbrain(lfs_lbv_noHemo==0) = 0;
% nii = make_nii(mask_lbv_remainbrain);
% save_nii(nii,'mask_lbv_remainbrain.nii');


% % RESHARP to remove hemorrhage
% [lfs_resharp_remainbrain,mask_lbv_remainbrain] = resharp(lfs_pdf_noAir,hemo_mask,voxelSize,smv_rad,tik_reg);
% nii = make_nii(lfs_resharp_remainbrain,voxelSize);
% save_nii(nii,'lfs_resharp_remainbrain.nii');


% % dipole
% lfs_dipole = (lfs_pdf_noAir - lfs_lbv_noHemo);
% nii = make_nii(lfs_dipole,voxelSize);
% save_nii(nii,'lfs_dipole.nii');


% % inversion on the remaining of the brain
% tv_reg = 5e-4;
% weights = abs(img_cmb).*mask_lbv_remainbrain;
% sus_lbv_remainbrain = tvdi(lfs_lbv_noHemo,mask_lbv_remainbrain,voxelSize,tv_reg,weights,z_prjs,20); 
% nii = make_nii(sus_lbv_remainbrain,voxelSize);
% save_nii(nii,['sus_lbv_remainbrain' num2str(tv_reg) '.nii']);


% % inversion of the dipole
% tv_reg = 5e-4;
% weights = hemo_mask;
% sus_dipole = tvdi(lfs_dipole,ones(imsize),voxelSize,tv_reg,weights,z_prjs,20); 
% nii = make_nii(sus_dipole,voxelSize);
% save_nii(nii,['sus_dipole' num2str(tv_reg) '.nii']);



% % super add together
% % sus_super = sus_resharp_remainbrain.*mask_lbv_remainbrain + sus_dipole.*(1 - mask_lbv_remainbrain).*mask_ero;
% sus_super = (sus_lbv_remainbrain + sus_dipole.*(1 - mask_lbv_remainbrain)).*mask_pdf_ero;
% nii = make_nii(sus_super,voxelSize);
% save_nii(nii,'sus_super.nii');


% % inversion of everything
% tv_reg = 5e-3;
% weights = abs(img_cmb).*mask_pdf_ero.*hemo_mask;
% sus_regular = tvdi(lfs_pdf_noAir,ones(imsize),voxelSize,tv_reg,weights,z_prjs,20); 
% nii = make_nii(sus_regular,voxelSize);
% save_nii(nii,['sus_regular' num2str(tv_reg) '.nii']);





















% % inversion
% tv_reg = 5e-4;
% weights = abs(img_cmb).*mask_ero.*hemo_mask;
% sus_pdf = tvdi(lfs,mask_ero,vox,tv_reg,weights,z_prjs,100); 
% nii = make_nii(sus_pdf,vox);
% save_nii(nii,['sus_pdf' num2str(tv_reg) '.nii']);



% % resharp to remove air
% [lfs_resharp_noAir,mask_resharp] = resharp(tfs,mask,voxelSize,smv_rad,tik_reg);
% mkdir('RESHARP');
% nii = make_nii(lfs_resharp_noAir,voxelSize);
% save_nii(nii,'RESHARP/lfs_resharp_noAir.nii');


% lfs_lbv = LBV(tfs,hemo_mask,imsize,vox,0.01,2); % strip 2 layers
% mkdir('LBV');
% nii = make_nii(lfs_lbv,voxelSize);
% save_nii(nii,'LBV/lfs_lbv.nii');



% lfs_lbv_noAir = LBV(tfs_poly,hemo_mask,imsize,vox,0.01,2); % strip 2 layers
% mkdir('LBV');
% nii = make_nii(lfs_lbv_noAir,voxelSize);
% save_nii(nii,'LBV/lfs_lbv_noAir.nii');


% % background field removal
% % (1) RESHARP
% [lfs_resharp,hemo_mask_resharp] = resharp(tfs,hemo_mask,voxelSize,smv_rad,tik_reg);
% mkdir('RESHARP');
% nii = make_nii(lfs_resharp,voxelSize);
% save_nii(nii,'RESHARP/lfs_resharp.nii');

% % inversion on the remaining of the brain
% tv_reg = 5e-4;
% weights = abs(img_cmb).*hemo_mask_resharp;
% sus_resharp_remainbrain = tvdi(lfs_resharp,hemo_mask_resharp,vox,tv_reg,weights,z_prjs,200); 
% nii = make_nii(sus_resharp_remainbrain,vox);
% save_nii(nii,['sus_resharp_remainbrain_' num2str(tv_reg) '.nii']);



% % seperate the hemorrhage dipole
% lfs_resharp_dipole = (lfs_resharp_noAir - lfs_resharp).*hemo_mask;
% weights = abs(img_cmb).*mask.*hemo_mask;
% tv_reg = 1e-3;
% sus_resharp_dipole = tvdi(lfs_resharp_dipole,hemo_mask_resharp,vox,tv_reg,weights,z_prjs,20); 
% nii = make_nii(sus_resharp_dipole,vox);
% save_nii(nii,['sus_resharp_dipole' num2str(tv_reg) '.nii']);

