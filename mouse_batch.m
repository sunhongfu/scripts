list = {'Yong-AC13-0272-422.Jg1/7/','Yong-AC13-0272.423.Jg1/7/','Yong-AC13-0272-424.Jg1/7/','Yong-AC13-0272-425.Jg1/7/','Yong-AC13-0272-426.Jg1/7/','Yong-AC13-0272.427.Jg1/7/','Yong-AC13-0272.429.Jg1/7/','Yong-AC13-0272.430.Jg1/7/','Yong-AC13-0272.431.Jg1/7/','Yong-AC13-0272.432.Jg1/7/','Yong-AC13-0272.433.Jg1/7/','Yong-AC13-0272.434.Jg1/7/','Yong-AC13-0272.435.Jg1/7/','Yong-AC13-0272.436.Jg1/7/','Yong-AC13-0272.437.Jh1/6/','Yong-AC13-0272.438.Jh1/6/','Yong-AC13-0272.439.Jh1/6/','Yong-AC13-0272.440.Jh1/6/','Yong-AC13-0272.441.Jh1/6/','Yong-AC13-0272.442.Jh1/6/','Yong-AC13-0272.443.Jh1/6/','Yong-AC13-0272.444.Jh1/6/','Yong-AC13-0272.445.Jh1/6/','Yong-AC13-0272.446.Jh1/6/','Yong-AC13-0272.447.Jh1/6/','Yong-AC13-0272.448.Jh1/6/','Yong-AC13-0272.449.Jh1/6/','Yong-AC13-0272.450.Jh1/6/'};

for i =1:length(list)
	cd /media/data/NPCisUSPIOQSM
	cd(list{i})

	[iField voxel_size matrix_size TE delta_TE CF Affine3D B0_dir TR NumEcho] = Read_Bruker_raw_sun(pwd);
% iField = iField(:,:,70:112,:);
% matrix_size(3) = 43;

mkdir src
nii = make_nii(abs(iField)*10000,voxel_size);
save_nii(nii,'src/mag.nii');
nii = make_nii(angle(iField),voxel_size);
save_nii(nii,'src/ph.nii');

imsize = size(iField);

for i = 1:size(iField,4)
	nii = make_nii(abs(iField(:,:,:,i))*10000,voxel_size);
	save_nii(nii,['src/mag' num2str(i) '.nii']);

	% N3 correction
	setenv('echonum',num2str(i));
	unix('nii2mnc src/mag${echonum}.nii src/mag${echonum}.mnc');
	unix('nu_correct src/mag${echonum}.mnc src/corr_mag${echonum}.mnc -V1.0 -distance 10');
	unix('mnc2nii src/corr_mag${echonum}.mnc src/corr_mag${echonum}.nii');

	nii = make_nii(angle(iField(:,:,:,i)),voxel_size);
	save_nii(nii,['src/ph' num2str(i) '.nii']);
end


mag = zeros(imsize);
for echo = 1:imsize(4)
    nii = load_nii(['src/corr_mag' num2str(echo) '.nii']);
    mag(:,:,:,echo) = double(nii.img);
end

save raw.mat

end

