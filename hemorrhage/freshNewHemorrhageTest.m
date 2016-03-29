% freshNew
tvdi_n = 200;


% normalize to ppm unit
TE = params.protocol_header.alTE{1}/1e6;
B_0 = params.protocol_header.m_flMagneticFieldStrength;
gamma = 2.675222e8;
tfs = unph/(gamma*TE*B_0)*1e6; % unit ppm


% segment the hemorrhage, simple thresholding
imsize = size(img_cmb);
nii = load_nii('mag_blur.nii');
mag_blur = double(nii.img);
R = zeros(imsize);
R((mag_blur<=0.4)&mask)=1;
% nii = load_nii('R_man.nii');
% R = double(nii.img);

u = ones(imsize);

% remove air effect
lfs_noAir = LBV(tfs,mask,imsize,voxelSize,0.01,2); % strip 2 layers
nii = make_nii(lfs_noAir,voxelSize);
save_nii(nii,'lfs_noAir.nii');

% mask without air
mask_noAir = ones(imsize);
mask_noAir(lfs_noAir==0)=0;
nii = make_nii(mask_noAir,voxelSize);
save_nii(nii,'mask_noAir.nii');



% remove hemorrhage effect
lfs_noAir_noHemo = LBV(lfs_noAir,(1-R),imsize,voxelSize,0.01,0); % strip 2 layers
nii = make_nii(lfs_noAir_noHemo,voxelSize);
save_nii(nii,'lfs_noAir_noHemo.nii');

% mask without air without hemorrhage
mask_noAir_noHemo = ones(imsize);
mask_noAir_noHemo(lfs_noAir_noHemo==0)=0;
mask_noAir_noHemo = mask_noAir_noHemo.*mask_noAir;
nii = make_nii(mask_noAir_noHemo,voxelSize);
save_nii(nii,'mask_noAir_noHemo.nii');



% field from hemorrhage
lfs_hemo = lfs_noAir - lfs_noAir_noHemo;
nii = make_nii(lfs_hemo,voxelSize);
save_nii(nii,'lfs_hemo.nii');



% inversion of deep gray matter
[sus_deep,residual] = tvdi(lfs_noAir_noHemo,mask_noAir_noHemo,voxelSize,tv_reg,abs(img_cmb),nor_vec,tvdi_n,u);
nii = make_nii(sus_deep,voxelSize);
save_nii(nii,'sus_deep.nii');



% inversion of hemorrhage
mask_hemo_ext = zeros(imsize);
mask_hemo_ext((lfs_noAir_noHemo==0)&mask) = 1;

% extend even further
rx = 3;
ry = 3;
rz = 5;
[X,Y,Z] = ndgrid(-rx:rx,-ry:ry,-rz:rz);
h = (X.^2/rx^2 + Y.^2/ry^2 + Z.^2/rz^2 < 1);
ker = h/sum(h(:));
% circularshift, linear conv to Fourier multiplication
csh = [rx,ry,rz]; % circularshift
% extend the R by convolving with the kernel
cvsize = imsize + [2*rx+1, 2*ry+1, 2*rz+1] -1; % linear conv size
R_tmp = real(ifftn(fftn(mask_hemo_ext,cvsize).*fftn(ker,cvsize)));
R_tmp = R_tmp(rx+1:end-rx, ry+1:end-ry, rz+1:end-rz); % same size
mask_hemo_ext2 = zeros(imsize);
mask_hemo_ext2(abs(R_tmp) > 0.001) = 1;
nii = make_nii(mask_hemo_ext2,voxelSize);
save_nii(nii,'mask_hemo_ext2.nii');



tvdi_n = 20;
% [sus_hemo,residual] = tvdi(lfs_hemo,u,voxelSize,tv_reg,u,nor_vec,tvdi_n,mask_hemo_ext2);
[sus_hemo,residual] = tvdi(lfs_hemo,u,voxelSize,tv_reg,u,nor_vec,tvdi_n,mask_hemo_ext);
nii = make_nii(sus_hemo,voxelSize);
save_nii(nii,'sus_hemo.nii');



% combine them together
sus_combined = sus_deep.*mask_noAir_noHemo + sus_hemo.*(1-mask_noAir_noHemo).*mask_noAir;
nii = make_nii(sus_combined,voxelSize);
save_nii(nii,'sus_combined.nii');






% % background removal (including dipole from hemorrhage)
% %% LBV
% % normalize to ppm unit
% TE = params.protocol_header.alTE{1}/1e6;
% B_0 = params.protocol_header.m_flMagneticFieldStrength;
% gamma = 2.675222e8;
% tfs = unph/(gamma*TE*B_0)*1e6; % unit ppm

% lfs_deep = LBV(tfs,mask.*(1-R),imsize,voxelSize,0.01,2); % strip 2 layers
% nii = make_nii(lfs_deep,voxelSize);
% save_nii(nii,'lfs_deep.nii');


% % accurate mask of lfs_deep
% mask_deep = ones(imsize);
% mask_deep(lfs_deep == 0) = 0;
 
% % perform inversion of deep gray matter (open area)
% u = ones(imsize);
% [sus_deep,residual] = tvdi(lfs_deep,u,voxelSize,tv_reg,u,nor_vec,tvdi_n,u);
% nii = make_nii(sus_deep,voxelSize);
% save_nii(nii,'sus_deep.nii');


% lfs_hemo = tfs - lfs_deep;
% nii = make_nii(lfs_hemo,voxelSize);
% save_nii(nii,'lfs_hemo.nii');


% % remove air effect
% lfs_noAir = LBV(tfs,mask,imsize,voxelSize,0.01,2); % strip 2 layers
% nii = make_nii(lfs_noAir,voxelSize);
% save_nii(nii,'lfs_noAir.nii');



% % perform inverion on hemorrhage
% [sus_hemo,residual] = tvdi(lfs_noAir-lfs_deep,u,voxelSize,0,u,nor_vec,tvdi_n,R);
% nii = make_nii(sus_hemo,voxelSize);
% save_nii(nii,'sus_hemo.nii');

