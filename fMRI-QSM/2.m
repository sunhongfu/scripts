% load in all.mat
load all.mat

mkdir('expension');
cd('expension');


imsize = size(img_cmb);

% generate brain mask
unix('rm BET*');
bet_thr = 0.01;
setenv('bet_thr',num2str(bet_thr));
unix('bet ../combine/mag_cmb.nii BET -f ${bet_thr} -m -R');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);


% % laplacian unwrapping after
% unph = unwrapLaplacian(angle(img_cmb), size(img_cmb), vox);
% nii = make_nii(unph, vox);
% save_nii(nii,'unph_lap.nii');


%% unwrap combined phase with PRELUDE
disp('--> unwrap aliasing phase ...');
unix('prelude -a ../combine/mag_cmb.nii -p ../combine/ph_cmb.nii -u unph.nii -m BET_mask.nii -n 8');
unix('gunzip -f unph.nii.gz');
nii = load_nii('unph.nii');
unph = double(nii.img);


tfs = -unph/(2.675e8*Pars.te*4.7)*1e6; % unit ppm


% polyfit
% tfs_poly = poly3d(tfs,hemo_mask);
tfs_poly = poly3d(tfs,mask);
nii = make_nii(tfs_poly,vox);
save_nii(nii,'tfs_poly.nii');



% (2) lbv
disp('--> lbv to remove background field ...');
lfs_lbv = LBV(tfs_poly,mask,size(tfs_poly),vox,0.01,2); % strip 2 layers
mkdir('LBV');
nii = make_nii(lfs_lbv,vox);
save_nii(nii,'LBV/lfs_lbv.nii');
% % Don't use lbv's mask*.bin, not accurate
% % read in eroded mask from lbv
% listing = dir('mask*.bin');
% filename = listing.name;
% fid = fopen(filename);
% mask_lbv = fread(fid,'int');
% mask_lbv = reshape(mask_lbv,size(mask));
% fclose all;
mask_lbv = ones(size(mask));
mask_lbv(lfs_lbv==0) = 0;



% (1) resharp 
disp('--> resharp to remove background field ...');
mkdir('resharp');
[lfs_resharp,mask_resharp] = resharp(tfs_poly,mask,vox,3,1e-4);

nii = make_nii(lfs_resharp,vox);
save_nii(nii,'lfs_resharp.nii');



% % % (1) PDF to remove air
% z_prjs = [-sNormal.dSag, -sNormal.dCor, sNormal.dTra];
% % weights = abs(img_cmb).*hemo_mask_new.*mask;
% weights = mask.*abs(img_cmb);
% [lfs_pdf_noAir,mask_pdf_ero] = pdf(tfs_poly,mask,vox,smv_rad,weights,z_prjs);
% % nii = make_nii(lfs_pdf_noAir.*mask_pdf_ero.*hemo_mask,voxelSize);
% nii = make_nii(lfs_pdf_noAir,vox);
% save_nii(nii,'lfs_pdf_noAir.nii');
% nii = make_nii(mask_pdf_ero,vox);
% save_nii(nii,'mask_pdf_ero.nii');



%% susceptibility inversion
disp('--> TV susceptibility inversion ...');
sus_resharp = tvdi(lfs_resharp,mask_resharp,vox,tv_reg,abs(img_cmb),[],200);

nii = make_nii(sus_resharp,vox);
save_nii(nii,'sus_resharp.nii');

nii = make_nii(sus_resharp.*mask_resharp,vox);
save_nii(nii,'sus_resharp.nii');

