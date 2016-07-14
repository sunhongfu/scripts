folders = ...
{'./222_TR4_54vol_motor/QSM_2014.10.30-13.59.20-epi_222_TR4_54vol_motor_meas', ...
'./222_TR4_54vol_visual/QSM_2014.10.30-13.38.46-epi_222_TR4_54vol_visual_meas', ...
'./333_TR3_72vol_motor/QSM_2014.10.30-13.53.48-epi_333_TR3_72vol_motor_meas', ...
'./333_TR3_72vol_visual/QSM_2014.10.30-14.04.27-epi_333_TR3_72vol_visual_meas', ...
'./444_TR2_108vol_motor/QSM_2014.10.30-13.48.20-epi_444_TR2_108vol_motor_meas', ...
'./444_TR2_108vol_visual/QSM_2014.10.30-13.27.23-epi_444_TR2_108vol_visual_meas', ...
'./single_vol/222/QSM_2014.10.30-13.19.44-epi_222_TR4_meas', ...
'./single_vol/333/QSM_2014.10.30-13.20.25-epi_333_TR3_meas', ...
'./single_vol/444/QSM_2014.10.30-13.20.56-epi_444_TR2_meas'};


init_dir = pwd;


for i = 1:size(folders,2)
	copyfile(folders{i},[folders{i},'_RAS']);
	cd([folders{i},'_RAS']);

	[~,cmout] = unix('find . -name "*.nii" | sort > files.txt');
	fileID = fopen('files.txt','r');
	files = fscanf(fileID,'%s');


	splitStr = regexp(files,'.nii','split');

	% for i = 1:size(splitStr,2)
	% if exist(splitStr{i},'file');
	% 	nii = load_nii(splitStr{i});
	% 	img = double(nii.img);
	% 	img = flipdim(permute(img,[2 1 3]),3);
	% 	nii = make_nii(img, nii.hdr.dime.pixdim(2:4));
	% 	save_nii(nii,splitStr{i});
	% end
	% end



	for i = 1:size(splitStr,2)
	if exist([splitStr{i},'.nii'],'file');
		nii = load_nii([splitStr{i},'.nii']);
		img = double(nii.img);
		img = rot90(img,2);
		nii = make_nii(img, nii.hdr.dime.pixdim(2:4));
		save_nii(nii,[splitStr{i},'.nii']);
	end
	end

	cd(init_dir);
end