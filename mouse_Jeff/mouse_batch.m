
addpath('/Users/uqhsun8/Documents/MATLAB/scripts/mouse_Jeff');

% list = {'Yong-AC13-0272-422.Jg1/7/','Yong-AC13-0272.423.Jg1/7/','Yong-AC13-0272-424.Jg1/7/','Yong-AC13-0272-425.Jg1/7/','Yong-AC13-0272-426.Jg1/7/','Yong-AC13-0272.427.Jg1/7/','Yong-AC13-0272.429.Jg1/7/','Yong-AC13-0272.430.Jg1/7/','Yong-AC13-0272.431.Jg1/7/','Yong-AC13-0272.432.Jg1/7/','Yong-AC13-0272.433.Jg1/7/','Yong-AC13-0272.434.Jg1/7/','Yong-AC13-0272.435.Jg1/7/','Yong-AC13-0272.436.Jg1/7/','Yong-AC13-0272.437.Jh1/6/','Yong-AC13-0272.438.Jh1/6/','Yong-AC13-0272.439.Jh1/6/','Yong-AC13-0272.440.Jh1/6/','Yong-AC13-0272.441.Jh1/6/','Yong-AC13-0272.442.Jh1/6/','Yong-AC13-0272.443.Jh1/6/','Yong-AC13-0272.444.Jh1/6/','Yong-AC13-0272.445.Jh1/6/','Yong-AC13-0272.446.Jh1/6/','Yong-AC13-0272.447.Jh1/6/','Yong-AC13-0272.448.Jh1/6/','Yong-AC13-0272.449.Jh1/6/','Yong-AC13-0272.450.Jh1/6/'};

% list = {'/media/pikelab/Hongfu/side_projects/mouse/QSM_max/Mouse-160','/media/pikelab/Hongfu/side_projects/mouse/QSM_max/Mouse-162','/media/pikelab/Hongfu/side_projects/mouse/QSM_max/Mouse-172','/media/pikelab/Hongfu/side_projects/mouse/QSM_max/Mouse-178','/media/pikelab/Hongfu/side_projects/mouse/QSM_max/Mouse-188','/media/pikelab/Hongfu/side_projects/mouse/QSM_max/Mouse-190','/media/pikelab/Hongfu/side_projects/mouse/QSM_max/Mouse-192','/media/pikelab/Hongfu/side_projects/mouse/QSM_max/Mouse-161','/media/pikelab/Hongfu/side_projects/mouse/QSM_max/Mouse-171','/media/pikelab/Hongfu/side_projects/mouse/QSM_max/Mouse-174','/media/pikelab/Hongfu/side_projects/mouse/QSM_max/Mouse-179','/media/pikelab/Hongfu/side_projects/mouse/QSM_max/Mouse-189','/media/pikelab/Hongfu/side_projects/mouse/QSM_max/Mouse-191'};

% list = {'/Volumes/LaCie_Bottom/collaborators/Jeff_Dunn/QSM Study October_November 2021 Data/Dunn-Qandeel-QSM-01.aD1/14', '/Volumes/LaCie_Bottom/collaborators/Jeff_Dunn/QSM Study October_November 2021 Data/Dunn-Qandeel-QSM-02.aD1/14', '/Volumes/LaCie_Bottom/collaborators/Jeff_Dunn/QSM Study October_November 2021 Data/Dunn-Qandeel-QSM-03.aD1/14', '/Volumes/LaCie_Bottom/collaborators/Jeff_Dunn/QSM Study October_November 2021 Data/Dunn-Qandeel-QSM-04.aD1/14', '/Volumes/LaCie_Bottom/collaborators/Jeff_Dunn/QSM Study October_November 2021 Data/Dunn-Qandeel-QSM-05.aE1/14', '/Volumes/LaCie_Bottom/collaborators/Jeff_Dunn/QSM Study October_November 2021 Data/Dunn-Qandeel-QSM-06.aE1/14', '/Volumes/LaCie_Bottom/collaborators/Jeff_Dunn/QSM Study October_November 2021 Data/Dunn-Qandeel-QSM-07.aE1/14', '/Volumes/LaCie_Bottom/collaborators/Jeff_Dunn/QSM Study October_November 2021 Data/Dunn-Qandeel-QSM-08.aE1/14', '/Volumes/LaCie_Bottom/collaborators/Jeff_Dunn/QSM Study October_November 2021 Data/Dunn-Qandeel-QSM-09.aJ1/14', '/Volumes/LaCie_Bottom/collaborators/Jeff_Dunn/QSM Study October_November 2021 Data/Dunn-Qandeel-QSM-10.aJ1/14', '/Volumes/LaCie_Bottom/collaborators/Jeff_Dunn/QSM Study October_November 2021 Data/Dunn-Qandeel-QSM-11.aJ1/14', '/Volumes/LaCie_Bottom/collaborators/Jeff_Dunn/QSM Study October_November 2021 Data/Dunn-Qandeel-QSM-12.aJ1/14', '/Volumes/LaCie_Bottom/collaborators/Jeff_Dunn/QSM Study October_November 2021 Data/Dunn-Qandeel-QSM-13.aK1/14', '/Volumes/LaCie_Bottom/collaborators/Jeff_Dunn/QSM Study October_November 2021 Data/Dunn-Qandeel-QSM-14.aK1/14', '/Volumes/LaCie_Bottom/collaborators/Jeff_Dunn/QSM Study October_November 2021 Data/Dunn-Qandeel-QSM-15.aK1/14', '/Volumes/LaCie_Bottom/collaborators/Jeff_Dunn/QSM Study October_November 2021 Data/Dunn-Qandeel-QSM-16.aK1/14', '/Volumes/LaCie_Bottom/collaborators/Jeff_Dunn/QSM Study October_November 2021 Data/Dunn-Qandeel-QSM-17.aL1/14', '/Volumes/LaCie_Bottom/collaborators/Jeff_Dunn/QSM Study October_November 2021 Data/Dunn-Qandeel-QSM-18.aL1/14', '/Volumes/LaCie_Bottom/collaborators/Jeff_Dunn/QSM Study October_November 2021 Data/Dunn-Qandeel-QSM-19.aL1/14', '/Volumes/LaCie_Bottom/collaborators/Jeff_Dunn/QSM Study October_November 2021 Data/Dunn-Qandeel-QSM-20.aL1/14'}

list = {'/Users/uqhsun8/Downloads/MRI/Dunn Rehman MRI Files/Dunn-Rehman-01/13', '/Users/uqhsun8/Downloads/MRI/Dunn Rehman MRI Files/Dunn-Rehman-02/13', '/Users/uqhsun8/Downloads/MRI/Dunn Rehman MRI Files/Dunn-Rehman-03/13', '/Users/uqhsun8/Downloads/MRI/Dunn Rehman MRI Files/Dunn-Rehman-04/13', '/Users/uqhsun8/Downloads/MRI/Dunn Rehman MRI Files/Dunn-Rehman-05/13', '/Users/uqhsun8/Downloads/MRI/Dunn Rehman MRI Files/Dunn-Rehman-06/13', '/Users/uqhsun8/Downloads/MRI/Dunn Rehman MRI Files/Dunn-Rehman-07/13', '/Users/uqhsun8/Downloads/MRI/Dunn Rehman MRI Files/Dunn-Rehman-08/13', '/Users/uqhsun8/Downloads/MRI/Dunn Rehman MRI Files/Dunn-Rehman-09/13', '/Users/uqhsun8/Downloads/MRI/Dunn Rehman MRI Files/Dunn-Rehman-10/13', '/Users/uqhsun8/Downloads/MRI/Dunn Rehman MRI Files/Dunn-Rehman-11/13', '/Users/uqhsun8/Downloads/MRI/Dunn Rehman MRI Files/Dunn-Rehman-12/13', '/Users/uqhsun8/Downloads/MRI/Dunn Rehman MRI Files/Dunn-Rehman-13/13', '/Users/uqhsun8/Downloads/MRI/Dunn Rehman MRI Files/Dunn-Rehman-14/13', '/Users/uqhsun8/Downloads/MRI/Dunn Rehman MRI Files/Dunn-Rehman-15/13', '/Users/uqhsun8/Downloads/MRI/Dunn Rehman MRI Files/Dunn-Rehman-16/13', '/Users/uqhsun8/Downloads/MRI/Dunn Rehman MRI Files/Dunn-Rehman-17/13', '/Users/uqhsun8/Downloads/MRI/Dunn Rehman MRI Files/Dunn-Rehman-18/13', '/Users/uqhsun8/Downloads/MRI/Dunn Rehman MRI Files/Dunn-Rehman-19/13'}

for i =1:length(list)
	% cd /media/data/NPCisUSPIOQSM
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

	for j = 1:size(iField,4)
		nii = make_nii(abs(iField(:,:,:,j))*10000,voxel_size);
		save_nii(nii,['src/mag' num2str(j) '.nii']);

		% % N3 correction
		% setenv('echonum',num2str(i));
		% unix('nii2mnc src/mag${echonum}.nii src/mag${echonum}.mnc');
		% unix('nu_correct src/mag${echonum}.mnc src/corr_mag${echonum}.mnc -V1.0 -distance 10');
		% unix('mnc2nii src/corr_mag${echonum}.mnc src/corr_mag${echonum}.nii');

		nii = make_nii(angle(iField(:,:,:,j)),voxel_size);
		save_nii(nii,['src/ph' num2str(j) '.nii']);
	end


	% mag = zeros(imsize);
	% for echo = 1:imsize(4)
	%     nii = load_nii(['src/corr_mag' num2str(echo) '.nii']);
	%     mag(:,:,:,echo) = double(nii.img);
	% end

	mag = abs(iField*10000);

	save raw.mat

	QSM_new_for_hyperoxygen

end

