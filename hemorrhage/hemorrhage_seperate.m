%%
% seperate hemorrhage from the remaining part

imsize = size(lfs_lbv);
lfs = lfs_lbv;
mask_ero = ones(imsize);
mask_ero(lfs==0)=0;

imsize = size(lfs);
tvdi_n = 10;
nii = load_nii('mag_blur.nii');
mag_blur = double(nii.img);
R = zeros(imsize);
R((mag_blur<=0.7)&mask_ero)=1;
% nii = load_nii('R-1.img');
% R_man = flipdim(double(nii.img),2);
% R = R_man;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use cls_conv2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[sus,residual] = tvdi(lfs,mask_ero,voxelSize,tv_reg,ones(imsize),nor_vec,tvdi_n,R);
% [sus,residual] = tvdi(lfs,mask_ero.*(1-R),voxelSize,tv_reg,ones(imsize),nor_vec,tvdi_n,R);
nii = make_nii(sus,voxelSize);
save_nii(nii,'hemo.nii');
nii = make_nii(residual,voxelSize);
save_nii(nii,'residual.nii');
nii = make_nii(residual.*(1-R),voxelSize);
save_nii(nii,'residual_excluded.nii');

hemo = sus.*R;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use cls_conv
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sus = tvdi(residual_field,mask_ero.*(1-R),voxelSize,tv_reg,abs((img_cmb)),nor_vec,tvdi_n,ones(size(mask)));
[sus2,residual2] = tvdi(residual,mask_ero.*(1-R),voxelSize,tv_reg,abs(img_cmb),nor_vec,tvdi_n,ones(size(mask)));

% use cls_conv2
[sus2,residual2] = tvdi(residual,mask_ero.*(1-R),voxelSize,tv_reg,abs(img_cmb),nor_vec,tvdi_n,mask_ero.*(1-R));

% [sus2,residual2] = tvdi(residual,mask_ero.*(1-R),voxelSize,tv_reg,abs((img_cmb)),nor_vec,tvdi_n,(1-R).*mask_ero);
nii = make_nii(sus2,voxelSize);
save_nii(nii,'deep_restrict.nii');

deep = sus2.*(1-R).*mask_ero;

nii = make_nii(hemo+deep,voxelSize);
save_nii(nii,'combined_restrict.nii');










lfs = lfs_lbv;
mask_ero = ones(imsize);
mask_ero(lfs==0)=0;

[sus_hemo,residual] = tvdi(lfs,mask_ero,voxelSize,0,ones(imsize),nor_vec,tvdi_n,R);                                            
 nii = make_nii(sus_hemo,voxelSize);
 save_nii(nii,'hemo.nii')

[sus_deep,residual2]  = tvdi(residual,mask_ero.*(1-R),voxelSize,tv_reg,ones(imsize),nor_vec,tvdi_n,ones(imsize));

% [sus2,residual2] = tvdi(residual,mask_ero.*(1-R),voxelSize,tv_reg,abs((img_cmb)),nor_vec,tvdi_n,ones(size(mask)));     
 
 nii = make_nii(sus_deep,voxelSize);   
 save_nii(nii,'deep.nii')
