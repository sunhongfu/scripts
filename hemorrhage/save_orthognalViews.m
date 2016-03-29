% save coronal and sagittal view
listing = dir('mag*.nii');

for i = 1:length(listing)
	nii = load_nii(listing(i).name);
	img = double(nii.img);
	vox = nii.hdr.dime.pixdim(2:4)
	nii = make_nii(flipdim(permute(img,[1 3 2]),2),permute(vox,[1 3 2]));
	save_nii(nii,['xz_' listing(i).name]);
	nii = make_nii(flipdim(permute(img,[2 3 1]),2),permute(vox,[2 3 1]));
	save_nii(nii,['yz_' listing(i).name]);
end