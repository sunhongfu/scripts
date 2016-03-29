[~,asdf] = unix('find . -name QSM_SWI15_v5_best -print');
asdf = strtrim(asdf);
recon_list = strsplit(asdf,'\n');
my_init_dir = pwd;

for i = 1:size(recon_list,2)
    cd(recon_list{i});
    if ~ exist('superposition_2015_01_23')




load all

    fid = fopen('reliability.dat','r');
    reliability_raw = fread(fid,'float');
    fclose(fid);
    reliability_raw = reshape(reliability_raw,[nv,np,ns]).*mask_lbv;
    % reliability_raw = 1./reliability_raw.*mask;

    % superposition

mkdir('superposition_2015_01_29');
cd('superposition_2015_01_29');


    nii = make_nii(reliability_raw,voxelSize);
    save_nii(nii,'reliability_raw.nii');
    % reliability_smooth = smooth3(reliability,'gaussian',[7,7,3],1);
    reliability = mask_lbv;
    reliability(reliability_raw >= 20) = 0;
    % reliability(reliability > 0.1) = 1;
    nii = make_nii(reliability,voxelSize);
    save_nii(nii,'reliability.nii');




% calculate the median value of magnitude
tmp = abs(img_cmb(logical(mask)));
size(tmp)
median(tmp(:))



weights = abs(img_cmb)./max(abs(img_cmb(:))).*mask_lbv.*reliability;
weights = smooth3(weights,'gaussian',[7,7,3],1);
% weights = smooth3(weights,'gaussian',[7,7,3],0.5);
nii = make_nii(weights,voxelSize);
save_nii(nii,'weights.nii');



% % LBV
% lfs_lbv = LBV(tfs,mask,size(tfs),voxelSize,0.01,2); % strip 2 layers
% mask_lbv = ones(size(mask));
% mask_lbv(lfs_lbv==0) = 0;
% % 3D 2nd order polyfit to remove any residual background
% lfs_lbv= poly3d(lfs_lbv,mask_lbv);

sus_masked_lbv = tvdi(lfs_lbv, mask_lbv, voxelSize,tv_reg,weights.^2,z_prjs,200); 
sus_masked_lbv = sus_masked_lbv.*mask_lbv;
nii = make_nii(sus_masked_lbv.*mask_lbv,voxelSize);
save_nii(nii,'sus_masked_lbv_200.nii');





imsize = size(img_cmb);

% segment the hemorrhage
% blur the magnitude
img_smooth = smooth3(img_cmb,'gaussian',[7,7,3],1);
nii = make_nii(angle(img_smooth),voxelSize);
save_nii(nii,'ph_smooth.nii');
nii = make_nii(abs(img_smooth),voxelSize);
save_nii(nii,'mag_smooth.nii');

% hemo_mask = ones(imsize);
% hemo_mask((abs(img_smooth)<=0.3) & (mask_lbv>0)) = 0;


hemo_mask = ones(imsize);
% hemo_mask((weights<=0.1) & (mask_lbv>0)) = 0;
hemo_mask(sus_masked_lbv>=0.45) = 0;

% % threshold the magnitude
% % untrusted worthy hemorrhage as 0, others 1
% hemo_mask = mask;
% hemo_mask(abs(img_smooth)<=0.3) = 0;

nii = make_nii(hemo_mask,voxelSize);
save_nii(nii,'hemo_mask.nii');



% remove the hemorrhage dipole fields
% % LBV to remove hemorrhage
lfs_noHemo_lbv = LBV(lfs_lbv,mask_lbv.*hemo_mask,imsize,voxelSize,0.0001,1); % strip 1 layers
% lfs_noHemo_lbv = LBV(lfs_lbv,1-(mask_lbv-hemo_mask_lbv),imsize,voxelSize,0.01,1); % strip 1 layers
mask_noHemo_lbv = ones(imsize);
mask_noHemo_lbv(lfs_noHemo_lbv == 0) = 0;

% lfs_noHemo_lbv = poly3d(lfs_noHemo_lbv,mask_noHemo_lbv);

nii = make_nii(lfs_noHemo_lbv,voxelSize);
save_nii(nii,'lfs_noHemo_lbv1.nii');

nii = make_nii(mask_noHemo_lbv,voxelSize);
save_nii(nii,'mask_noHemo_lbv.nii');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inversion on remaining part (noHemo) of the brain
tv_reg = 5e-4;
weights = abs(img_cmb).*mask_lbv.*mask_noHemo_lbv;
sus_noHemo_lbv = tvdi(lfs_noHemo_lbv,mask_lbv.*mask_noHemo_lbv,voxelSize,tv_reg,weights,z_prjs,200); 
nii = make_nii(sus_noHemo_lbv.*mask_lbv.*mask_noHemo_lbv,voxelSize);
save_nii(nii,['sus_noHemo_lbv.nii']);


% super add together
sus_super_lbv = sus_noHemo_lbv.*mask_lbv.*mask_noHemo_lbv + sus_masked_lbv.*(mask_lbv - mask_noHemo_lbv);
nii = make_nii(sus_super_lbv,voxelSize);
save_nii(nii,'sus_super_lbv1.nii');





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
save_nii(nii,'sus_super_fix_lbv1.nii');



% save the workspace
save all_super.mat



end
cd(my_init_dir);
end

