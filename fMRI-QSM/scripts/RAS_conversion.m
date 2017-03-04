% 4.7T scanner coordinates to RAS

cd('/media/data/Hongfu/Project_fQSM/1.5T/HS_RAW/2014.11.04-15.22.50-epi_333_TR3_110vol_meas/QSM_EPI15_pre_2014.11.04-15.22.50-epi_333_TR3_110vol_meas');
[a,b]=unix('find . -name mag_cmb001.nii');
expression = '\n';
splitStr = regexp(strtrim(b),expression,'split');

for i =1:size(splitStr,2)
	[pathstr,name,ext] = fileparts(splitStr{i});
	cd(pathstr);
	mkdir('../../RAS_FOR_PETER');
	listing=dir('mag*.nii');
	for j = 1:size(listing,1)
		nii = load_nii(listing(j).name);
		mag = double(nii.img);
		voxelSize = nii.hdr.dime.pixdim(2:4);
		% RAS
		nii = make_nii(permute(flipdim(mag,3),[2 1 3]),permute(voxelSize,[2,1,3]));
		save_nii(nii,['../../RAS_FOR_PETER/',listing(j).name]);
	end
	cd ..
	cd('RESHARP');
	listing=dir('sus*.nii');
	for j = 1:size(listing,1)
		nii = load_nii(listing(j).name);
		sus = double(nii.img);
		tmp = sus(sus~=0);
		demean = mean(tmp(:));
		sus(sus~=0) = sus(sus~=0)+2-demean;
		min(sus(:))
		voxelSize = nii.hdr.dime.pixdim(2:4);
		% RAS
		nii = make_nii(permute(flipdim(sus,3),[2 1 3]),permute(voxelSize,[2,1,3]));
		save_nii(nii,['../../RAS_FOR_PETER/',listing(j).name]);
	end
	cd('/media/data/Hongfu/Project_fQSM/1.5T/HS_RAW/2014.11.04-15.22.50-epi_333_TR3_110vol_meas/QSM_EPI15_pre_2014.11.04-15.22.50-epi_333_TR3_110vol_meas');
end





% 1.5T scanner coordinates to RAS

cd('/media/data/Project_fMRI-QSM/1.5T/DZ_RAW/2015.03.10-14.24.19-epi_444_TR2_108vol_meas/QSM_EPI15_v1_2015.03.10-14.24.19-epi_444_TR2_108vol_meas');
[a,b]=unix('find . -name mag_cmb001.nii');
expression = '\n';
splitStr = regexp(strtrim(b),expression,'split');

for i =1:size(splitStr,2)
	[pathstr,name,ext] = fileparts(splitStr{i});
	cd(pathstr);
	mkdir('../../RAS_FOR_PETER');
	listing=dir('mag*.nii');
	for j = 1:size(listing,1)
		nii = load_nii(listing(j).name);
		mag = double(nii.img);
		voxelSize = nii.hdr.dime.pixdim(2:4);
		% RAS
		nii = make_nii(flipdim(flipdim(mag,1),2),voxelSize);
		save_nii(nii,['../../RAS_FOR_PETER/',listing(j).name]);
	end
	cd ..
	cd('RESHARP')
	listing=dir('sus*.nii');
	for j = 1:size(listing,1)
		nii = load_nii(listing(j).name);
		sus = double(nii.img);
		tmp = sus(sus~=0);
		size(tmp)
		demean = mean(tmp(:))
		sus(sus~=0) = sus(sus~=0)+2-demean;
		min(sus(:))
		voxelSize = nii.hdr.dime.pixdim(2:4);
		% RAS
		nii = make_nii(flipdim(flipdim(sus,1),2),voxelSize);
		save_nii(nii,['../../RAS_FOR_PETER/',listing(j).name]);
	end
	cd('/media/data/Project_fMRI-QSM/1.5T/DZ_RAW/2015.03.10-14.24.19-epi_444_TR2_108vol_meas/QSM_EPI15_v1_2015.03.10-14.24.19-epi_444_TR2_108vol_meas');
end



% 3D to 4D nifti
cd('/media/data/Project_fMRI-QSM/1.5T/DZ_RAW/2015.03.10-14.24.19-epi_444_TR2_108vol_meas');
[a,b]=unix('find . -name mag_cmb001.nii| grep RAS_FOR_PETER');
expression = '\n';
splitStr = regexp(strtrim(b),expression,'split');

for i =1:size(splitStr,2)
	[pathstr,name,ext] = fileparts(splitStr{i});
	cd(pathstr);
	cd('..');
	[stat, mess, id] = rmdir('spm','s');
	mkdir('spm');
	cd('RAS_FOR_PETER');
	listing=dir('mag*.nii');
	for j = 1:size(listing,1)
		nii = load_nii(listing(j).name);
		mag = double(nii.img);
		voxelSize = nii.hdr.dime.pixdim(2:4);
		% 4d
		mag_all(:,:,:,j) = mag;
	end
	nii = make_nii(mag_all,voxelSize);
	save_nii(nii,'../spm/mag_all.nii');
	clear mag_all

	listing=dir('sus*.nii');
	for j = 1:size(listing,1)
		nii = load_nii(listing(j).name);
		sus = double(nii.img);
		voxelSize = nii.hdr.dime.pixdim(2:4);
		% 4d
		sus(sus == 0) = sus(sus == 0) + 2;
		sus_all(:,:,:,j) = sus - 2;
		% sus_all(:,:,:,j) = sus;
	end
	nii = make_nii(sus_all,voxelSize);
	save_nii(nii,'../spm/sus_all.nii');
	clear sus_all



	cd('../spm');
	% relice using SPM
	!rm *.mat
	P = spm_select('ExtList', pwd, '^mag_all.nii',1:200);
	spm_realign(P);
	flags.mask=0;
	spm_reslice(P,flags);
	copyfile('mag_all.mat','sus_all.mat');
	P = spm_select('ExtList', pwd, '^sus_all.nii',1:200);
	flags.mask=0;
	spm_reslice(P,flags);

	cd('/media/data/Project_fMRI-QSM/1.5T/DZ_RAW/2015.03.10-14.24.19-epi_444_TR2_108vol_meas');

end



% % masking the brains for Peter

% nii = load_nii('BET001_mask.nii');
% mask = permute(flipdim(double(nii.img),3),[2 1 3]);
% % RAS

% cd ../RAS_FOR_PETER
% listing=dir('sus*.nii');
% 	for j = 1:size(listing,1)
% 		nii = load_nii(listing(j).name);
% 		sus = double(nii.img).*mask;
% 		min(sus(:))
% 		voxelSize = nii.hdr.dime.pixdim(2:4);
% 		% RAS
% 		nii = make_nii(sus,voxelSize);
% 		save_nii(nii,[listing(j).name]);
% 	end