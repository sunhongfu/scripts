
% load in all.mat
load all.mat

fid = fopen('wrapped_phase.dat','w');
    fwrite(fid,angle(img_cmb),'float');
    fclose(fid);
    % mask_unwrp = uint8(hemo_mask.*255);
    mask_unwrp = uint8(abs(mask)*255);
    fid = fopen('mask_unwrp.dat','w');
    fwrite(fid,mask_unwrp,'uchar');
    fclose(fid);
    unix('cp /home/hongfu/Documents/MATLAB/3DSRNCP 3DSRNCP');
    setenv('nv',num2str(nv));
    setenv('np',num2str(np));
    setenv('ns',num2str(ns));
    bash_script = ['./3DSRNCP wrapped_phase.dat mask_unwrp.dat unwrapped_phase.dat ' ...
        '$nv $np $ns reliability.dat'];
    unix(bash_script) ;
    % fid = fopen('unwrapped_phase.dat','r');
    % unph = fread(fid,'float');
    % unph = reshape(unph - unph(1) ,[nv,np,ns]);
    % fclose(fid);
    % nii = make_nii(unph,voxelSize);
    % save_nii(nii,'unph.nii');

    fid = fopen('reliability.dat','r');
    reliability_raw = fread(fid,'float');
    fclose(fid);
    reliability_raw = reshape(reliability_raw,[nv,np,ns]).*mask_lbv;
    % reliability_raw = 1./reliability_raw.*mask;
    nii = make_nii(reliability_raw,voxelSize);
    save_nii(nii,'reliability_raw.nii');
    % reliability_smooth = smooth3(reliability,'gaussian',[7,7,3],1);
    reliability = mask_lbv;
    reliability(reliability_raw >= 20) = 0;
    % reliability(reliability > 0.1) = 1;
    nii = make_nii(reliability,voxelSize);
    save_nii(nii,'reliability.nii');





% fid = fopen('reliability.dat','r');
% reliability = fread(fid,'float');
% fclose(fid);
% reliability = reshape(reliability,[nv,np,ns]);
% reliability = 1./reliability.*mask;
% % reliability_smooth = smooth3(reliability,'gaussian',[7,7,3],1);
% reliability(reliability <= 0.05) = 0;
% reliability(reliability > 0.05) = 1;
% nii = make_nii(reliability,voxelSize);
% save_nii(nii,'reliability.nii');



mkdir('superposition_2015_01_13');
cd('superposition_2015_01_13');


imsize = size(img_cmb);


% segment the hemorrhage
% blur the magnitude
img_smooth = smooth3(img_cmb,'gaussian',[7,7,3],1);
nii = make_nii(angle(img_smooth),voxelSize);
save_nii(nii,'ph_smooth.nii');
nii = make_nii(abs(img_smooth),voxelSize);
save_nii(nii,'mag_smooth.nii');

hemo_mask = ones(imsize);
hemo_mask((abs(img_smooth)<=0.3) & (mask_resharp>0)) = 0;

% threshold the magnitude
% untrusted worthy hemorrhage as 0, others 1
hemo_mask = mask;
hemo_mask(abs(img_smooth)<=0.3) = 0;

nii = make_nii(hemo_mask,voxelSize);
save_nii(nii,'hemo_mask.nii');


% masked inversion
tv_reg = 5e-4;
options.lbv_layer = 2;  % strip 2 layers
lfs_lbv = LBV(tfs,mask,size(tfs),voxelSize,0.0001,options.lbv_layer);
mask_lbv = ones(size(mask));
mask_lbv(lfs_lbv==0) = 0;
nii = make_nii(mask_lbv,voxelSize);
save_nii(nii,'mask_lbv.nii');
% 3D 2nd order polyfit to remove any residual background
lfs_lbv= poly3d(lfs_lbv,mask_lbv);
nii = make_nii(lfs_lbv,voxelSize);
save_nii(nii,'lfs_lbv.nii');

% weights = abs(img_cmb)./max(abs(img_cmb(:))).*mask_lbv.*hemo_mask;
% weights = abs(img_smooth)./max(abs(img_smooth(:))).*mask_lbv.*reliability;
weights = abs(img_cmb)./max(abs(img_cmb(:))).*mask_lbv.*reliability;
weights = smooth3(weights,'gaussian',[7,7,3],1);
nii = make_nii(weights,voxelSize);
save_nii(nii,'weights.nii');

% weights_mask = zeros(imsize);
% weights_mask(weights >= 0.1) = 1;

sus_masked_lbv = tvdi(lfs_lbv, mask_lbv, voxelSize,tv_reg,weights,z_prjs,2000); 
% sus_masked_lbv = tvdi(lfs_lbv, mask_lbv, voxelSize,0,weights,z_prjs,20,2); 
% sus_masked_lbv = tvdi(lfs_lbv,mask_lbv, voxelSize,1e-3,weights,z_prjs,20,2); 
sus_masked_lbv = sus_masked_lbv.*mask_lbv;
nii = make_nii(sus_masked_lbv.*mask_lbv,voxelSize);
save_nii(nii,'sus_masked_lbv_l1.nii');


% better segment the hemorrhage
hemo_mask_lbv = mask_lbv;
hemo_mask_lbv(sus_masked_lbv >= 0.5) = 0;
nii = make_nii(hemo_mask_lbv,voxelSize);
save_nii(nii,'hemo_mask_lbv.nii');


%%%%%%%%
% hemo_mask_lbv = weights_mask;

%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% remove the hemorrhage dipole fields
% % LBV to remove hemorrhage
lfs_noHemo_lbv = LBV(lfs_lbv,mask_lbv.*hemo_mask_lbv,imsize,voxelSize,0.0001,0); % strip 1 layers
% lfs_noHemo_lbv = LBV(lfs_lbv,1-(mask_lbv-hemo_mask_lbv),imsize,voxelSize,0.01,1); % strip 1 layers
mask_noHemo_lbv = ones(imsize);
mask_noHemo_lbv(lfs_noHemo_lbv == 0) = 0;

% lfs_noHemo_lbv = poly3d(lfs_noHemo_lbv,mask_noHemo_lbv);

nii = make_nii(lfs_noHemo_lbv,voxelSize);
save_nii(nii,'lfs_noHemo_lbv.nii');

nii = make_nii(mask_noHemo_lbv,voxelSize);
save_nii(nii,'mask_noHemo_lbv.nii');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % remove the dipole field with RESHARP
% [lfs_noHemo_resharp, mask_noHemo_resharp] = resharp(lfs_resharp,hemo_mask,voxelSize,2,tik_reg);


nii = make_nii(lfs_noHemo_resharp,voxelSize);
save_nii(nii,'lfs_noHemo_resharp.nii');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inversion on remaining part (noHemo) of the brain
tv_reg = 5e-4;
weights = abs(img_cmb).*mask_lbv.*mask_noHemo_lbv;
sus_noHemo_lbv = tvdi(lfs_noHemo_lbv,mask_lbv.*mask_noHemo_lbv,voxelSize,tv_reg,weights,z_prjs,2000); 
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

W = weights;

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
