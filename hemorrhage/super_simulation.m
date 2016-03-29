load sus_local;
imsize = size(sus_local);
mag_local = ones(imsize);
mag_local(sus_local>0.1) = 0.01;
vox = [1,1,1];

nii = make_nii(sus_local,vox);
save_nii(nii,'sus_local.nii');
nii = make_nii(mag_local,vox);
save_nii(nii,'mag_local.nii');

R = zeros(imsize);
R(sus_local>0.1) = 1;

mask = ones(imsize);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% unit dipole kernel
[Nx,Ny,Nz] = size(sus_local);
FOV = vox.*[Nx,Ny,Nz];
FOVx = FOV(1);
FOVy = FOV(2);
FOVz = FOV(3);
x = -Nx/2:Nx/2-1;
y = -Ny/2:Ny/2-1;
z = -Nz/2:Nz/2-1;
[kx,ky,kz] = ndgrid(x/FOVx,y/FOVy,z/FOVz);
D = 1/3 - kz.^2./(kx.^2 + ky.^2 + kz.^2);
D(floor(Nx/2+1),floor(Ny/2+1),floor(Nz/2+1)) = 0;
D = fftshift(D);






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% field forward caculation
B_local = real(ifftn(fftn(sus_local).*D));
nii = make_nii(B_local);
save_nii(nii,'B_local.nii');






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% scale to 1.5T 40ms
ph_local = 2.675e8 * (B_local * 1e-6 * 1.5) * 40e-3;
nii = make_nii(ph_local,vox);
save_nii(nii,'ph_local.nii');

ph_local_wrp = angle(exp(1j*ph_local));
nii = make_nii(ph_local_wrp,vox);
save_nii(nii,'ph_local_wrp.nii');







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% add complex noise in real and imaginary part
img_comp = mag_local.*exp(1j*ph_local);
% img_comp = mag_local.*exp(1j*ph_local);
% k = ifftshift(ifftn(ifftshift(img_comp)));

% complex noise
cgnoise = 0.01*randn(imsize) + i*0.01*randn(imsize);
img_comp_noise = img_comp + cgnoise;
% k_noise = k + cgnoise;

% img_comp_noise = fftshift(fftn(fftshift(k_noise)));

% img_real_noise = real(img_comp) + random('norm', 0, 0.1, imsize);
% img_imag_noise = imag(img_comp) + random('norm', 0, 0.1, imsize);
% img_comp_noise = img_real_noise + 1j*img_imag_noise;

nii = make_nii(abs(img_comp_noise));
save_nii(nii,'mag_local_noise.nii');
nii = make_nii(angle(img_comp_noise));
save_nii(nii,'ph_local_noise_wrp.nii'); 






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% unwrap !
% % 
fid = fopen('wrapped_phase.dat','w');
fwrite(fid,angle(img_comp_noise),'float');
fclose(fid);

mask = uint8(mask*255);

fid = fopen('mask.dat','w');
fwrite(fid,mask,'uchar');
fclose(fid);

% execute your command in linux terminal:
unix('./3DSRNCP wrapped_phase.dat mask.dat unwrapped_phase.dat 128 128 128') ;

fid = fopen('unwrapped_phase.dat','r');
unwrapped_phase = fread(fid,'float');
unwrapped_phase = reshape(unwrapped_phase,imsize);
fclose(fid);

nii = make_nii(unwrapped_phase,vox);
save_nii(nii,'unwrapped_phase.nii')






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% scale back to field map
lfs = unwrapped_phase./( 2.675e8 * 1e-6 * 1.5 * 40e-3 );
% lfs = unph_prelude2d./( 2.675e8 * 1e-6 * 1.5 * 40e-3 );
nii = make_nii(lfs,vox);
save_nii(nii,'lfs.nii');






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
weights = abs(img_comp_noise).*(1-R);
tv_reg = 1e-2;
sus_ph_regular = tvdi(lfs,double(mask),vox,tv_reg,weights,[],200);
nii = make_nii(sus_ph_regular,vox);
save_nii(nii,['sus_ph_regular_' num2str(tv_reg) '.nii']);





% ESHARP
[ extendedLocalPhase, sharpLocalPhase ] = esharp(lfs,1-R);
nii = make_nii(extendedLocalPhase,vox);
save_nii(nii,'esharp.nii');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% remove dipole field
R = zeros(imsize);
R(sus_local>0.1) = 1;

lfs_lbv = LBV(angle(img_comp_noise),1-R,imsize,vox,0.01,2); % strip 2 layers
mkdir('LBV');
nii = make_nii(lfs_lbv,vox);
save_nii(nii,'LBV/lfs_lbv.nii');
mask_lbv_remainbrain = ones(imsize);
mask_lbv_remainbrain(lfs_lbv==0) = 0;
nii = make_nii(mask_lbv_remainbrain);
save_nii(nii,['LBV/mask_lbv_remainbrain_' num2str(tv_reg) '.nii']);


tv_reg = 1e-2;
sus_lbv_remainbrain = tvdi(lfs_lbv,mask_lbv_remainbrain,vox,tv_reg,weights,[],200); 
nii = make_nii(sus_lbv_remainbrain,vox);
save_nii(nii,['LBV/sus_lbv_remainbrain_' num2str(tv_reg) '.nii']);




lfs_remain = real(ifftn(fftn(sus_lbv_remainbrain.*mask_lbv_remainbrain).*D));
lfs_dipole = angle(img_comp_noise) - lfs_remain;
nii = make_nii(lfs_dipole,vox);
save_nii(nii,'lfs_dipole.nii');

tv_reg = 1e-2;
sus_lbv_dipole = tvdi(lfs_dipole,ones(imsize),vox,tv_reg,weights,[],200,1-mask_lbv_remainbrain); 
nii = make_nii(sus_lbv_dipole,vox);
save_nii(nii,['LBV/sus_lbv_dipole' num2str(tv_reg) '.nii']);


% sus_super = sus_lbv_dipole.*(1-mask_lbv_remainbrain) + sus_lbv_remainbrain.*mask_lbv_remainbrain;
sus_super = sus_lbv_dipole + sus_lbv_remainbrain;
nii = make_nii(sus_super,vox);
save_nii(nii,'sus_super.nii');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% super method
sus_total_iter = tvdi_new(lfs,ones(imsize),vox,tv_reg,weights,[],500,sus_lbv_remainbrain,R);
nii = make_nii(sus_total_iter,vox);
save_nii(nii,['LBV/sus_total_iter_' num2str(tv_reg) '.nii']);