% hemorrhage iterative method

disp('--> unwrap aliasing phase ...');
unix('prelude -a combine/mag_cmb.nii -p combine/ph_cmb.nii -u unph.nii -m BET_mask.nii -n 8');
unix('gunzip -f unph.nii.gz');
nii = load_nii('unph.nii');
unph = double(nii.img);


[lph_resharp,mask_resharp] = resharp(unph,mask,voxelSize,smv_rad,tik_reg);
mkdir('RESHARP');
nii = make_nii(lph_resharp,voxelSize);
save_nii(nii,'RESHARP/lph_resharp.nii');

[lph_resharp_R,mask_resharp_R] = resharp(unph,mask.*(1-R),voxelSize,smv_rad,tik_reg);
mkdir('RESHARP');
nii = make_nii(lph_resharp_R,voxelSize);
save_nii(nii,'RESHARP/lph_resharp_R.nii');

lph_dipole = lph_resharp - lph_resharp_R;
nii = make_nii(lph_dipole.*(1-R),voxelSize);
save_nii(nii,'RESHARP/lph_dipole.nii');

% inversion of the whole brain
tv_reg = 1e-2;
[sus_resharp,residual_resharp] = tvdi(lph_resharp,mask_resharp,voxelSize,tv_reg,abs(img_cmb),nor_vec,10);
nii = make_nii(sus_resharp,voxelSize);
save_nii(nii,'RESHARP/sus_resharp.nii');

% inversion of the remaining brain
tv_reg = 1e-2;
[sus_resharp_R,residual_resharp_R] = tvdi(lph_resharp_R,mask_resharp_R,voxelSize,tv_reg,abs(img_cmb),nor_vec,10);
nii = make_nii(sus_resharp_R,voxelSize);
save_nii(nii,'RESHARP/sus_resharp_R.nii');

% inversion of the dipole
tv_reg = 1;
[sus_resharp_D,residual_resharp] = tvdi(lph_dipole.*(1-R),ones(size(lph_dipole)),voxelSize,tv_reg,abs(img_cmb),nor_vec,10);
nii = make_nii(sus_resharp_D,voxelSize);
save_nii(nii,'RESHARP/sus_resharp-D.nii');




%% complexly smoothing
img_smooth = smooth3(exp(1j*lph_resharp_wrp),'box',2*round(2./voxelSize)+1);
nii = make_nii(angle(img_smooth),voxelSize);
save_nii(nii,'ph_smooth.nii')
nii = make_nii(abs(img_smooth),voxelSize);
save_nii(nii,'mag_smooth.nii')
unix('prelude -a mag_smooth.nii -p ph_smooth.nii -u unph_smooth.nii -m BET_mask.nii -n 8');
unix('gunzip -f unph_smooth.nii.gz');
nii = load_nii('unph_smooth.nii');
unph_smooth = double(nii.img);
a = tvdi(unph_smooth,mask_resharp,voxelSize,0.1,abs(img_cmb),[],10);
nii = make_nii(a,voxelSize);
save_nii(nii,'a.nii');

sus_total_init = sus_resharp_R.*mask_resharp_R + sus_resharp.*(1-mask_resharp_R).*mask_resharp;
nii = make_nii(sus_total_init,voxelSize);
save_nii(nii,'RESHARP/sus_total_init.nii');


for iter = 1:10

ph_local_iter = real(ifftn(fftn(sus_resharp_R.*mask_resharp_R).*D));
% ph_local_iter = 2.675e8 * (B_local_iter * 1e-6 * 1.5) * 40e-3;
img_comp_iter = exp(1j*lph_resharp_wrp)./exp(1j*ph_local_iter);
nii = make_nii(abs(img_comp_iter));
save_nii(nii,'mag_comp_noise.nii');
nii = make_nii(angle(img_comp_iter));
save_nii(nii,'ph_comp_noise.nii'); 

unph_lap_iter = unwrapLaplacian(angle(img_comp_iter), imsize, voxelSize);
nii = make_nii(unph_lap_iter, voxelSize);
save_nii(nii,'unph_lap_iter.nii');

% lfs_iter = unph_lap_iter./( 2.675e8 * 1e-6 * 1.5 * 40e-3 );
a = tvdi(unph_lap_iter,mask_resharp,voxelSize,0.1,abs(img_cmb),[],10);
sus_total_init = sus_total_init + a.*(1-mask_resharp_R).*mask_resharp;

% sus_ph_regular = sus_ph_regular.*R + tvdi(unph_lap_iter,mask_resharp,voxelSize,tv_reg,abs(img_cmb),[],100);

nii = make_nii(sus_total_init,voxelSize);
save_nii(nii,'sus_total_init.nii');

end


% % superpositin
% sus_super = sus_resharp.*mask_resharp + sus_resharp_noAir.*(1-mask_resharp).*mask_resharp_noAir;
% nii = make_nii(sus_super,voxelSize);
% save_nii(nii,'sus_super.nii');


bph_resharp = (unph - lph_resharp).*mask_resharp;
nii = make_nii(bph_resharp,voxelSize);
save_nii(nii,'RESHARP/bph_resharp.nii');


% nii = make_nii(angle(exp(1j*bph_resharp)),voxelSize);
% save_nii(nii,'RESHARP/bph_resharp_wrp.nii');




lph_resharp_wrp = angle(img_cmb./exp(1j*bph_resharp)).*mask_resharp;
nii = make_nii(lph_resharp_wrp,voxelSize);
save_nii(nii,'RESHARP/lph_resharp_wrp.nii');


un_lph = unwrapLaplacian(lph_resharp_wrp, size(lph_resharp_wrp), voxelSize);
nii = make_nii(un_lph, voxelSize);
save_nii(nii,'un_lph.nii');


% first inversion
% (1) RESHARP
tv_reg = 1e-2;
[sus_resharp,residual_resharp] = tvdi(un_lph,mask_resharp,voxelSize,tv_reg,abs(img_cmb),z_prjs,100);
nii = make_nii(sus_resharp,voxelSize);
save_nii(nii,'RESHARP/sus_resharp_1e-2.nii');
nii=make_nii(sus_resharp.*mask_resharp,voxelSize);
save_nii(nii,'RESHARP/sus_resharp_clean_1e-2.nii');



% extract hemorrhage
imsize = size(sus_resharp);
R = zeros(imsize);
% to blur the magnitude
mag_blur = smooth3(abs(img_cmb),'box',2*round(2./voxelSize)+1);
nii = make_nii(mag_blur,voxelSize);
save_nii(nii,'mag_blur.nii');
R((mag_blur<=0.45)&mask_resharp)=1;
R_final = zeros(imsize);
R_final(145:210,160:220,30:55) = R(145:210,160:220,30:55);
nii = make_nii(R_final,voxelSize);
save_nii(nii,'R_final.nii');

R = R_final;
save('R','R');

% nii = load_nii('mag_blur.nii');
% mag_blur = double(nii.img);
% R((mag_blur<=0.5)&mask)=1;
% R((abs(img_cmb)<=0.5)&mask)=1;
R((sus_resharp>=5))=1;




% iteration

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


sus_ph_regular = sus_resharp;

for iter = 1:10

ph_local_iter = real(ifftn(fftn(sus_ph_regular.*R).*D));
% ph_local_iter = 2.675e8 * (B_local_iter * 1e-6 * 1.5) * 40e-3;
img_comp_iter = exp(1j*lph_resharp_wrp)./exp(1j*ph_local_iter);
nii = make_nii(abs(img_comp_iter));
save_nii(nii,'mag_comp_noise.nii');
nii = make_nii(angle(img_comp_iter));
save_nii(nii,'ph_comp_noise.nii'); 

unph_lap_iter = unwrapLaplacian(angle(img_comp_iter), imsize, voxelSize);
nii = make_nii(unph_lap_iter, voxelSize);
save_nii(nii,'unph_lap_iter.nii');

% lfs_iter = unph_lap_iter./( 2.675e8 * 1e-6 * 1.5 * 40e-3 );
sus_ph_regular = sus_ph_regular.*R + tvdi(unph_lap_iter,mask_resharp,voxelSize,tv_reg,abs(img_cmb),[],100);

nii = make_nii(sus_ph_regular,voxelSize);
save_nii(nii,'sus_ph_regular.nii');

end