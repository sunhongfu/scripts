
nii = load_nii('tfs128.nii');
tfs = double(nii.img);
nii = load_nii('lfs128.nii');
lfs = double(nii.img);
mask = (lfs ~=0);
mask = double(mask);
bkg = (tfs - lfs).*mask;

vox = [1 1 1];
z_prjs = [0 0 1];

[~,bkg_sus,bkg_field] = projectionontodipolefields(bkg,mask,vox,mask,z_prjs,50);

total_field = lfs + bkg_field;

nii = make_nii(total_field,vox);
save_nii(nii,'total_field.nii');

nii = make_nii(bkg_field,vox);
save_nii(nii,'bkg_field.nii')

nii = make_nii(bkg_sus,vox);
save_nii(nii,'bkg_sus.nii');