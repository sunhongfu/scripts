masked_inv_listing = {'2013.06.19-11.38.13','2013.08.02-12.20.23','2013.08.20-14.49.01','2013.09.09-14.49.54','2013.09.09-14.58.52','2013.09.12-14.33.38','2013.09.19-15.05.17','2013.09.19-15.12.21','2013.11.01-14.02.15','2013.11.18-15.57.02','2013.11.26-11.07.13','2013.11.26-12.16.07'};
masked_inv_listing = {}


for i = 1:size(masked_inv_listing,2)
	cd(masked_inv_listing{i});
	cd('QSM_SWI15_v5_pre');















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


fid = fopen('reliability.dat','r');
reliability = fread(fid,'float');
fclose(fid);
reliability = reshape(reliability,[nv,np,ns]);
reliability = 1./reliability.*mask;
% reliability_smooth = smooth3(reliability,'gaussian',[7,7,3],1);
reliability(reliability <= 0.1) = 0;
reliability(reliability > 0.1) = 1;
nii = make_nii(reliability,voxelSize);
save_nii(nii,'reliability.nii');



mkdir('mask_inversion_2015_01_20_R0.1');
cd('mask_inversion_2015_01_20_R0.1');

imsize = size(img_cmb);

weights = abs(img_cmb)./max(abs(img_cmb(:))).*mask_lbv.*reliability;
weights = smooth3(weights,'gaussian',[7,7,3],1);
nii = make_nii(weights.^2,voxelSize);
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




% RESHARP
% [lfs_resharp, mask_resharp] = resharp(tfs,mask,voxelSize,smv_rad,tik_reg);
% % 3D 2nd order polyfit to remove any residual background
% lfs_resharp= poly3d(lfs_resharp,mask_resharp);

% sus_masked_resharp = tvdi(lfs_resharp, mask_resharp, voxelSize,tv_reg,weights,z_prjs,2000); 
% sus_masked_resharp = sus_masked_resharp.*mask_resharp;
% nii = make_nii(sus_masked_resharp.*mask_resharp,voxelSize);
% save_nii(nii,'sus_masked_resharp_2000.nii');

save all_masked_inversion
cd ..



















cd ..
cd ..
end


