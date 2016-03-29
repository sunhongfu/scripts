list = dir('/media/data/Hongfu/Project_Hemorrhage/recon/QSM*axgre3Dswi*');


for i = 1: size(list,1)

	clearvars -except list i

	cd(['/media/data/Hongfu/Project_Hemorrhage/recon/' list(i).name]);
	% use RESHARP to remove the hemorrhage dipole effect

	if exist('LBV/fix','dir')
		continue;
	end

	mkdir('LBV/fix');

	load all
	if ~ exist('z_prjs','var') || isempty(z_prjs)
	    z_prjs = nor_vec;
	end
	imsize = size(img_cmb);
	R = zeros(imsize);

	% nii = load_nii('mag_blur.nii');
	% mag_blur = double(nii.img);
	% R((mag_blur<=0.5)&mask)=1;
	% R((abs(img_cmb)<=0.5)&mask)=1;
	R((sus_resharp>=0.6))=1;


	% [lfs_resharp_remainbrain,mask_resharp_remainbrain] = resharp(tfs,mask.*(1-R),voxelSize,smv_rad,tik_reg);
	% nii = make_nii(lfs_resharp_remainbrain,voxelSize);
	% save_nii(nii,'RESHARP/fix/lfs_resharp_remainbrain_smv3.nii');


	% % tvdi of the remaining brain part
	% sus_resharp_remainbrain = tvdi(lfs_resharp_remainbrain,mask_resharp_remainbrain,voxelSize,tv_reg,abs(img_cmb),z_prjs,tvdi_n); 
	% nii = make_nii(sus_resharp_remainbrain,voxelSize);
	% save_nii(nii,'RESHARP/fix/sus_resharp_remainbrain.nii');


	% % superposition
	% sus_resharp_super = sus_resharp_remainbrain.*mask_resharp_remainbrain + sus_resharp.*(1-mask_resharp_remainbrain).*mask_resharp;
	% nii = make_nii(sus_resharp_super,voxelSize);
	% save_nii(nii,'RESHARP/fix/sus_resharp_super.nii');



% LBV
lfs_resharp_lbv = LBV(lfs_resharp,(1-R),imsize,voxelSize,0.01,2); % strip 2 layers
mkdir('LBV');
nii = make_nii(lfs_resharp_lbv,voxelSize);
save_nii(nii,'LBV/lfs_resharp_lbv.nii');
mask_lbv_remainbrain = mask_resharp;
mask_lbv_remainbrain(lfs_resharp_lbv==0) = 0;
nii = make_nii(mask_lbv_remainbrain);
save_nii(nii,'mask_lbv_remainbrain.nii');


% tvdi of the remaining brain part
tv_reg = 1e-3;
% sus_resharp_remainbrain = tvdi(lfs_resharp_remainbrain,mask_resharp_remainbrain,voxelSize,tv_reg,ones(size(B_local_full)),[],200); 
sus_lbv_remainbrain = tvdi(lfs_resharp_lbv,mask_lbv_remainbrain,voxelSize,tv_reg,abs(img_cmb).*R,[],20); 
nii = make_nii(sus_lbv_remainbrain,voxelSize);
save_nii(nii,'LBV/sus_lbv_remainbrain3_1e-3.nii');



%%% 
% incoporate hemorrhage susceptibility initially
sus_total_init = sus_lbv_remainbrain.*mask_lbv_remainbrain + sus_resharp.*(1 - mask_lbv_remainbrain).*mask_resharp;
nii = make_nii(sus_total_init,voxelSize);
save_nii(nii,'sus_total_init.nii');

% forward calculation

% create K-space filter kernel D
%%%%% make this a seperate function in the future
FOV = voxelSize.*imsize;
Nx = imsize(1);
Ny = imsize(2);
Nz = imsize(3);
FOVx = FOV(1);
FOVy = FOV(2);
FOVz = FOV(3);

x = -Nx/2:Nx/2-1;
y = -Ny/2:Ny/2-1;
z = -Nz/2:Nz/2-1;
[kx,ky,kz] = ndgrid(x/FOVx,y/FOVy,z/FOVz);
% D = 1/3 - kz.^2./(kx.^2 + ky.^2 + kz.^2);
D = 1/3 - (kx.*nor_vec(1)+ky.*nor_vec(2)+kz.*nor_vec(3)).^2./(kx.^2 + ky.^2 + kz.^2);
D(floor(Nx/2+1),floor(Ny/2+1),floor(Nz/2+1)) = 0;
D = fftshift(D);


ph_local_init = real(ifftn(fftn(sus_total_init).*D));


% (1) RESHARP inversion to check
[sus_resharp,residual_resharp] = tvdi(ph_local_init,mask_resharp,voxelSize,tv_reg,abs(img_cmb),nor_vec,200);
nii = make_nii(sus_resharp,voxelSize);
save_nii(nii,'RESHARP/sus_resharp.nii');
nii=make_nii(sus_resharp.*mask_resharp,voxelSize);
save_nii(nii,'RESHARP/sus_resharp_clean.nii');



% ph_local_iter = 2.675e8 * (B_local_iter * 1e-6 * 1.5) * 40e-3;
img_comp_iter = exp(1j*lph_resharp_wrp)./exp(1j*ph_local_iter);
nii = make_nii(abs(img_comp_iter));
save_nii(nii,'mag_comp_noise.nii');
nii = make_nii(angle(img_comp_iter));
save_nii(nii,'ph_comp_noise.nii'); 

unph_lap_iter = unwrapLaplacian(angle(img_comp_iter), imsize, voxelSize);
nii = make_nii(unph_lap_iter, voxelSize);
save_nii(nii,'unph_lap_iter.nii');






sus_total_iter = tvdi_new(lfs_resharp,mask_lbv_remainbrain,voxelSize,tv_reg,abs(img_cmb),[],200,sus_lbv_remainbrain,R);
nii = make_nii(sus_total_iter,voxelSize);
save_nii(nii,'LBV/sus_total_iter.nii');


	save('all_fix_new.mat','-v7.3');
end





% [lfs_resharp_noAir,mask_resharp_noAir] = resharp(tfs,mask,voxelSize,smv_rad,tik_reg);
% nii = make_nii(lfs_resharp_noAir,voxelSize);
% save_nii(nii,'lfs_resharp_noAir_3voxelEro.nii');

% sus_resharp_noAir = tvdi(lfs_resharp_noAir,mask_resharp_noAir,voxelSize,tv_reg,abs(img_cmb),z_prjs,200); 
% nii = make_nii(sus_resharp_noAir,voxelSize);
% save_nii(nii,'sus_no_air.nii');

% % % tvdi cls2
% % sus_resharp = tvdi2(lfs_resharp_noAir,mask_resharp_noAir,voxelSize,tv_reg,abs(img_cmb),z_prjs,10,(1-mask_resharp)); 

% % nii = make_nii(sus_resharp,voxelSize);
% % save_nii(nii,'sus_hemo.nii');


% % superpositin
% sus_super = sus_resharp.*mask_resharp + sus_resharp_noAir.*(1-mask_resharp).*mask_resharp_noAir;
% nii = make_nii(sus_super,voxelSize);
% save_nii(nii,'sus_super.nii');


% save('sus_resharp.mat','sus_resharp');
% load sus_resharp.mat;




