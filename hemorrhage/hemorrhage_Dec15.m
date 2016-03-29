% % hemorrhage fix
% % superposition
% [status,cmdout] = unix('find /media/data/Hongfu/Project_Hemorrhage/recon/medium -name QSM*');
% list = strsplit(cmdout,'\n');

% for i = 1:length(list)-1
% 	clearvars -except list i;
% 	cd(list{i});


% load in all.mat
load all.mat

mkdir('super_fix');
cd('super_fix');


imsize = size(img_cmb);


% segment the hemorrhage
% blur the magnitude
img_smooth = smooth3(img_cmb,'gaussian',[7,7,3],1);
nii = make_nii(angle(img_smooth),voxelSize);
save_nii(nii,'ph_smooth.nii');
nii = make_nii(abs(img_smooth),voxelSize);
save_nii(nii,'mag_smooth.nii');

% threshold the magnitude
% untrusted worthy hemorrhage as 0, others 1
hemo_mask = mask;
hemo_mask(abs(img_smooth)<=0.3) = 0;

nii = make_nii(hemo_mask,voxelSize);
save_nii(nii,'hemo_mask.nii');


% masked inversion
tv_reg = 5e-4;
%% !!! to strip LBV 1 layer
lfs_lbv = LBV(tfs,mask,size(tfs),voxelSize,0.01,1); % strip 1 layers
mask_lbv = ones(size(mask));
mask_lbv(lfs_lbv==0) = 0;
% 3D 2nd order polyfit to remove any residual background
lfs_lbv= poly3d(lfs_lbv,mask_lbv);

weights = abs(img_cmb)./max(abs(img_cmb(:))).*mask_lbv.*hemo_mask;
weights = smooth3(weights,'gaussian',[7,7,3],2);
% sus_masked_lbv = tvdi(lfs_lbv,mask_lbv, voxelSize,tv_reg,weights,z_prjs,500); 
sus_masked_lbv = tvdi(lfs_lbv,mask_lbv, voxelSize,5e-2,weights,z_prjs,500,2); 
nii = make_nii(sus_masked_lbv.*mask_lbv,voxelSize);
save_nii(nii,'sus_masked_lbv.nii');


% better segment the hemorrhage
hemo_mask_lbv = mask;
hemo_mask_lbv(sus_masked_lbv >= 0.5) = 0;
nii = make_nii(hemo_mask_lbv,voxelSize);
save_nii(nii,'hemo_mask_lbv.nii');


% remove the hemorrhage dipole fields
% % LBV to remove hemorrhage
lfs_noHemo_lbv = LBV(tfs,mask.*hemo_mask_lbv,imsize,voxelSize,0.01,1); % strip 1 layers
mask_noHemo_lbv = ones(imsize);
mask_noHemo_lbv(lfs_noHemo_lbv == 0) = 0;

lfs_noHemo_lbv = poly3d(lfs_noHemo_lbv,mask_noHemo_lbv);

nii = make_nii(lfs_noHemo_lbv,voxelSize);
save_nii(nii,'lfs_noHemo_lbv.nii');

nii = make_nii(mask_noHemo_lbv,voxelSize);
save_nii(nii,'mask_noHemo_lbv.nii');



% inversion on remaining part (noHemo) of the brain
tv_reg = 5e-4;
weights = abs(img_cmb).*mask_lbv.*mask_noHemo_lbv;
sus_noHemo_lbv = tvdi(lfs_noHemo_lbv,mask_lbv.*mask_noHemo_lbv,voxelSize,tv_reg,weights,z_prjs,500); 
nii = make_nii(sus_noHemo_lbv.*mask_lbv.*mask_noHemo_lbv,voxelSize);
save_nii(nii,['sus_noHemo_lbv.nii']);


% super add together
sus_super_lbv = sus_noHemo_lbv.*mask_lbv.*mask_noHemo_lbv + sus_masked_lbv.*(mask_lbv - mask_noHemo_lbv);
nii = make_nii(sus_super_lbv,voxelSize);
save_nii(nii,'sus_super_lbv.nii');


% baseline fix
%%%%% make this a seperate function in the future
Nx = size(sus_super_lbv,1);
Ny = size(sus_super_lbv,2);
Nz = size(sus_super_lbv,3);
FOV = voxelSize.*[Nx,Ny,Nz];
FOVx = FOV(1);
FOVy = FOV(2);
FOVz = FOV(3);

x = -Nx/2:Nx/2-1;
y = -Ny/2:Ny/2-1;
z = -Nz/2:Nz/2-1;
[kx,ky,kz] = ndgrid(x/FOVx,y/FOVy,z/FOVz);
D = 1/3 - (kx.*z_prjs(1)+ky.*z_prjs(2)+kz.*z_prjs(3)).^2./(kx.^2 + ky.^2 + kz.^2);
D(floor(Nx/2+1),floor(Ny/2+1),floor(Nz/2+1)) = 0;
D = fftshift(D);

W = abs(img_cmb).*mask_lbv.*hemo_mask;

x1 = W.*ifftn(D.*fftn(mask_lbv - mask_noHemo_lbv));
x2 = W.*(lfs_lbv - ifftn(D.*fftn(sus_super_lbv)));
x1 = x1(:);
x2 = x2(:);
o = real(x1'*x2/(x1'*x1))

sus_super_fix_lbv = sus_super_lbv + o*(mask_lbv - mask_noHemo_lbv);
nii = make_nii(sus_super_fix_lbv,voxelSize);
save_nii(nii,'sus_super_fix_lbv.nii');



% save the workspace
save all_super.mat




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%










% % polyfit
% % tfs_poly = poly3d(tfs,hemo_mask);
% tfs_poly = poly3d(tfs,mask);
% nii = make_nii(tfs_poly,voxelSize);
% save_nii(nii,'tfs_poly.nii');



% bkg_rm = 3;
% switch bkg_rm
% case 1
% 	% (1) PDF to remove air
% 	weights = abs(img_cmb).*hemo_mask;
% 	% weights = mask.*hemo_mask;
% 	[lfs_pdf_noAir,mask_pdf_ero] = pdf(tfs_poly,mask,voxelSize,smv_rad,weights,z_prjs);
% 	% nii = make_nii(lfs_pdf_noAir.*mask_pdf_ero.*hemo_mask,voxelSize);
% 	nii = make_nii(lfs_pdf_noAir,voxelSize);
% 	save_nii(nii,'lfs_pdf_noAir.nii');
% 	nii = make_nii(mask_pdf_ero,voxelSize);
% 	save_nii(nii,'mask_pdf_ero.nii');

% 	lfs_noAir = lfs_pdf_noAir;
% 	mask_noAir = mask_pdf_ero;

% case 2
% 	% (2) RESHARP to remove air
% 	tik_reg = 5e-4;
% 	smv_rad = 3;
% 	[lfs_resharp_noAir,mask_resharp_noAir] = resharp(tfs,mask,voxelSize,smv_rad,tik_reg);
% 	nii = make_nii(lfs_resharp_noAir,voxelSize);
% 	save_nii(nii,'lfs_resharp_noAir.nii');
% 	nii = make_nii(mask_resharp_noAir,voxelSize);
% 	save_nii(nii,'mask_resharp_noAir.nii');

% 	lfs_noAir = lfs_resharp_noAir;
% 	mask_noAir = mask_resharp_noAir;

% case 3
% 	% (3) LBV to remove air
% 	lfs_lbv_noAir = LBV(tfs_poly,mask,imsize,voxelSize,0.01,1); % strip 2 layers
% 	nii = make_nii(lfs_lbv_noAir,voxelSize);
% 	save_nii(nii,'lfs_lbv_noAir.nii');
% 	mask_lbv_noAir =ones(imsize);
% 	mask_lbv_noAir(lfs_lbv_noAir==0) = 0;
% 	nii = make_nii(mask_lbv_noAir);
% 	save_nii(nii,'mask_lbv_noAir.nii');

% 	lfs_noAir = lfs_lbv_noAir;
% 	mask_noAir = mask_lbv_noAir;
% end


% % regular inversion
% tv_reg = 5e-4;
% weights = abs(img_cmb)./max(abs(img_cmb(:))).*mask_noAir.*hemo_mask;
% weights = smooth3(weights,'gaussian',[7,7,3],2);
% % weights = abs(img_cmb).*mask_noAir;
% % sus_regular_mask = tvdi(lfs_noAir,mask_noAir, voxelSize,tv_reg,weights,z_prjs,200,2); 
% sus_regular_mask = tvdi(lfs_noAir,mask_noAir, voxelSize,tv_reg,weights,z_prjs,1000); 
% nii = make_nii(sus_regular_mask.*mask_noAir,voxelSize);
% save_nii(nii,'sus_regular_mask.nii');



% % for iter = 1:5
% 	% update the hemorrhage mask (sus_hemo_mask)
% 	sus_hemo_mask = mask;
% 	sus_hemo_mask(sus_regular_mask >= 0.5) = 0;
% 	nii = make_nii(sus_hemo_mask,voxelSize);
% 	save_nii(nii,'sus_hemo_mask.nii');


% 	% % update hemo_mask with sus_hemo_mask
% 	% tv_reg = 5e-3;
% 	% weights = abs(img_cmb)./max(abs(img_cmb(:))).*mask_noAir.*sus_hemo_mask;
% 	% weights = smooth3(weights,'gaussian',[7,7,3],1);
% 	% sus_regular_mask = tvdi(lfs_noAir,mask_noAir, voxelSize,tv_reg,weights,z_prjs,20); 
% 	% nii = make_nii(sus_regular_mask.*mask_noAir,voxelSize);
% 	% save_nii(nii,['sus_regular_mask_updated.nii']);
% % end


% switch bkg_rm
% case 1
% 	% (1) PDF to remove air
% 	weights = abs(img_cmb).*mask.*sus_hemo_mask;
% 	[lfs_pdf_noHemo,mask_pdf_Hemo] = pdf(tfs_poly,mask.*sus_hemo_mask,voxelSize,smv_rad,weights,z_prjs);
% 	nii = make_nii(lfs_pdf_noHemo,voxelSize);
% 	save_nii(nii,'lfs_pdf_noHemo.nii');
% 	nii = make_nii(mask_pdf_Hemo,voxelSize);
% 	save_nii(nii,'mask_pdf_Hemo.nii');

% 	lfs_noHemo = lfs_pdf_noHemo;
% 	mask_Hemo = mask_pdf_Hemo;

% case 2
% 	% RESHARP to remove hemorrhage (a second RESHARP)
% 	smv_rad = 3;
% 	tik_reg = 5e-4; % try different parameters?
% 	% [lfs_resharp_noHemo,mask_resharp_Hemo] = resharp(lfs_resharp_noAir,hemo_mask,voxelSize,smv_rad,tik_reg);
% 	[lfs_resharp_noHemo,mask_resharp_Hemo] = resharp(tfs,mask.*sus_hemo_mask,voxelSize,smv_rad,tik_reg);
% 	nii = make_nii(lfs_resharp_noHemo.*mask_resharp_Hemo,voxelSize);
% 	save_nii(nii,'lfs_resharp_noHemo.nii');
% 	nii = make_nii(mask_resharp_Hemo,voxelSize);
% 	save_nii(nii,'mask_resharp_Hemo.nii');

% 	lfs_noHemo = lfs_resharp_noHemo;
% 	mask_Hemo = mask_resharp_Hemo;

% case 3
% 	% % LBV to remove hemorrhage
% 	lfs_lbv_noHemo = LBV(tfs_poly,mask.*sus_hemo_mask,imsize,voxelSize,0.01,1); % strip 2 layers
% 	% lfs_lbv_noHemo = LBV(tfs_poly,mask.*hemo_mask,imsize,voxelSize,0.01,2); % strip 2 layers
% 	nii = make_nii(lfs_lbv_noHemo,voxelSize);
% 	save_nii(nii,'lfs_lbv_noHemo.nii');
% 	mask_lbv_remainbrain =ones(imsize);
% 	mask_lbv_remainbrain(lfs_lbv_noHemo==0) = 0;
% 	nii = make_nii(mask_lbv_remainbrain);
% 	save_nii(nii,'mask_lbv_remainbrain.nii');

% 	lfs_noHemo = lfs_lbv_noHemo;
% 	mask_Hemo = mask_lbv_remainbrain;
% end


% % inversion on the remaining of the brain
% tv_reg = 5e-4;
% weights = abs(img_cmb).*mask_noAir.*mask_Hemo;
% sus_noHemo = tvdi(lfs_noHemo,mask_noAir.*mask_Hemo,voxelSize,tv_reg,weights,z_prjs,1000); 
% nii = make_nii(sus_noHemo.*mask_noAir.*mask_Hemo,voxelSize);
% save_nii(nii,['sus_noHemo.nii']);


% % super add together
% sus_super = sus_noHemo.*mask_noAir.*mask_Hemo + ...
% 	sus_regular_mask.*(mask_noAir - mask_Hemo);
% nii = make_nii(sus_super,voxelSize);
% save_nii(nii,'sus_super.nii');



% % baseline fix
% %%%%% make this a seperate function in the future
% Nx = size(sus_super,1);
% Ny = size(sus_super,2);
% Nz = size(sus_super,3);
% FOV = voxelSize.*[Nx,Ny,Nz];
% FOVx = FOV(1);
% FOVy = FOV(2);
% FOVz = FOV(3);

% x = -Nx/2:Nx/2-1;
% y = -Ny/2:Ny/2-1;
% z = -Nz/2:Nz/2-1;
% [kx,ky,kz] = ndgrid(x/FOVx,y/FOVy,z/FOVz);
% % D = 1/3 - kz.^2./(kx.^2 + ky.^2 + kz.^2);
% D = 1/3 - (kx.*z_prjs(1)+ky.*z_prjs(2)+kz.*z_prjs(3)).^2./(kx.^2 + ky.^2 + kz.^2);
% D(floor(Nx/2+1),floor(Ny/2+1),floor(Nz/2+1)) = 0;
% D = fftshift(D);

% W = abs(img_cmb).*mask_noAir.*hemo_mask;
% x1 = W.*ifftn(D.*fftn(mask_noAir - mask_Hemo));
% x2 = W.*(lfs_noAir - ifftn(D.*fftn(sus_super)));
% x1 = x1(:);
% x2 = x2(:);
% o = real(x1'*x2/(x1'*x1))

% sus_super_fix = sus_super + o*(mask_noAir - mask_Hemo);
% nii = make_nii(sus_super_fix,voxelSize);
% save_nii(nii,'sus_super_fix.nii');




% save all_super.mat

% % end
