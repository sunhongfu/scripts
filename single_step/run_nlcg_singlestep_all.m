load all

imsize = size(mask);

% % threshold on 1st magnitude
% mask = ones(imsize);
% mask(mag(:,:,:,1)<2000) = 0;



[Nx,Ny,Nz] = size(mask);

% create K-space filter kernel D
%%%%% make this a seperate function in the future
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



Tik_weight = 3e-1;
TV_weight = 3e-2;


params.TV = cls_tv;

params.Itnlim = 500; % interations numbers (adjust accordingly!)
params.gradToll = 1e-6; % step size tolerance stopping criterea
params.l1Smooth = eps; %1e-15; smoothing parameter of L1 norm
params.pNorm = 1; % type of norm to use (i.e. L1 L2 etc)
params.lineSearchItnlim = 100;
params.lineSearchAlpha = 0.01;
params.lineSearchBeta = 0.6;
params.lineSearchT0 = 1 ; % step size to start with

params.Tik_weight = Tik_weight; 
params.TV_weight = TV_weight; % TV penalty 
params.mask = mask_resharp; %%% not used in nlcg
%params.wt = mask; % weighting matrix
% params.wt = wt;
params.data = ph_corr;
params.D = D;
params.const = -2.675e8*dicom_info.MagneticFieldStrength*1e-6;
params.TE = TE;

% non-linear conjugate gradient method
chi = nlcg_singlestep_all_subtraction(zeros(Nx,Ny,Nz), params);

chi = nlcg_singlestep_all(zeros(Nx,Ny,Nz), params);

% if want to keep the dipole fitting result
% don't mask it, instead, use the following:
% chi = real(chi).*mask;
chi = real(chi);

% residual difference between fowardly calculated field and lfs
res = tfs - real(ifftn(D.*fftn(chi)));



