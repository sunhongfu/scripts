voxelSize = [2 2 2];

for i = 1:110
	setenv('j',num2str(i));
	setenv('i',num2str(i,'%03i'));
	unix('mv mag_cmb${j}.nii mag_cmb${i}.nii');
end

for i = 1:110
	nii = load_nii(['mag_cmb' num2str(i,'%03i') '.nii']);
	mag_cmb(:,:,:,i) = double(nii.img);
end
nii = make_nii(mag_cmb,voxelSize);
save_nii(nii,'all_mag_cmb.nii');


for i = 1:110
	setenv('j',num2str(i));
	setenv('i',num2str(i,'%03i'));
	unix('mv sus_resharp${j}.nii sus_resharp${i}.nii');
end

for i = 1:110
	nii = load_nii(['sus_resharp' num2str(i,'%03i') '.nii']);
	sus_resharp(:,:,:,i) = double(nii.img);
end
nii = make_nii(sus_resharp,voxelSize);
save_nii(nii,'all_sus_resharp.nii');


for i = 1:110
	setenv('j',num2str(i));
	setenv('i',num2str(i,'%03i'));
	unix('mv lfs_resharp${j}.nii lfs_resharp${i}.nii');
end

for i = 1:110
	nii = load_nii(['lfs_resharp' num2str(i,'%03i') '.nii']);
	lfs_resharp(:,:,:,i) = double(nii.img);
end
nii = make_nii(lfs_resharp,voxelSize);
save_nii(nii,'all_lfs_resharp.nii');



for i = 1:110
	setenv('j',num2str(i));
	setenv('i',num2str(i,'%03i'));
	unix('mv unph${j}.nii unph${i}.nii');
end

for i = 1:110
	nii = load_nii(['unph' num2str(i,'%03i') '.nii']);
	unph(:,:,:,i) = double(nii.img);
end
nii = make_nii(unph,voxelSize);
save_nii(nii,'all_unph.nii');









for i = 1:108
	nii = load_nii(['ph_cmb' num2str(i) '.nii']);
	ph_cmb(:,:,:,i) = double(nii.img);
end
nii = make_nii(ph_cmb,voxelSize);
save_nii(nii,'all_ph_cmb.nii');


for i = 1:108
	nii = load_nii(['lfs_resharp' num2str(i) '.nii']);
	lfs_resharp(:,:,:,i) = double(nii.img);
end
nii = make_nii(lfs_resharp,voxelSize);
save_nii(nii,'all_lfs_resharp.nii');


for i = 1:108
	nii = load_nii(['sus_resharp' num2str(i) '.nii']);
	sus_resharp(:,:,:,i) = double(nii.img);
end
nii = make_nii(sus_resharp,voxelSize);
save_nii(nii,'all_sus_resharp.nii');












voxelSize = [3 3 3];

for i = 1:108
	setenv('j',num2str(i));
	setenv('i',num2str(i,'%03i'));
	unix('mv mag_cmb${j}.nii mag_cmb${i}.nii');
end

for i = 1:108
	nii = load_nii(['mag_cmb' num2str(i,'%03i') '.nii']);
	mag_cmb(:,:,:,i) = flipdim(flipdim(permute(double(nii.img),[2 1 3]),2),3);
end
nii = make_nii(mag_cmb,voxelSize);
save_nii(nii,'all_mag_cmb.nii');



for i = 1:108
	setenv('j',num2str(i));
	setenv('i',num2str(i,'%03i'));
	unix('mv sus_resharp_flip${j}.nii sus_resharp${i}.nii');
end

for i = 1:108
	nii = load_nii(['sus_resharp' num2str(i,'%03i') '.nii']);
	sus_resharp(:,:,:,i) = double(nii.img);
end
nii = make_nii(sus_resharp,voxelSize);
save_nii(nii,'all_sus_resharp.nii');

sus_ave = mean(sus_resharp(:,:,:,[1:9, 11:59, 61:end]),4);
nii = make_nii(sus_ave,voxelSize);
save_nii(nii,'sus_ave.nii');