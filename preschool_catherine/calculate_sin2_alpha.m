
% eigen vectors relative to scanner frame/coordinates

% get the direction cosines of the first row and first column with respect to the patient/scanner
% 6 values from the PatientOrientation tag from DICOM
% The DICOM Tag (0020,0037) is "Image Orientation (Patient)". It should always have 6 values (VM = 6). It's two Normalized 3D vectors(i.e. directions). The first one we will call X and it has three components (Xx, Xy, Xz) and the second one is Y and strangely it has three components too (Yx, Yy, Yz). Xx is the projection of X on x Axis, Xy is the projection (or Cosine) of X on y Axis and so on. These are direction cosines of the image plane relative to the RCS. The first direction is the direction of the image rows in the RCS and the second direction is the direction of the image columns in the RCS.
% DICOM defines a term: "Reference Coordinates System" or RCS.  The RCS is a very intuitive coordinate system of the patient body: X direction is from Right to Left. So if the patient is standing in front of you with the arm raised to the sides, then X direction is from the right hand to the left hand.
% Y direction is from front to back or medical-wise from Anterior to Posterior so if the patient is standing in front of you so you see him/her from his/her left side, then Y goes from your left to your right (confusing? look at the picture).
% Z direction goes from Feet to Head.



% read in the diffusion_orientations.csv
% diffusion_orientations = readtable('/Users/hongfusun/Dropbox/research/papers/preschool/2019/diffusion_orientations.csv');
diffusion_orientations = readtable('diffusion_orientations.csv');
merge_path = '/QRISdata/Q1041/preschool/project_preschool/merge/';

diffusion_orientations{1,1}{1} = diffusion_orientations{1,1}{1}(2:end); % trim the first strange white space

for i = 1:height(diffusion_orientations)
	% for i =1:3
	cd(merge_path)
	cd(diffusion_orientations{i,1}{1})
	
	FE = dir('*_FE.nii');
	if isempty(FE)
		continue
	end

	nii = load_untouch_nii(FE(1).name);
	data = nii.img;
	vox = nii.hdr.dime.pixdim(2:4);
	data_permuteXY_flipY = cat(4,data(:,:,:,2),-data(:,:,:,1),data(:,:,:,3));
	nii.img = data_permuteXY_flipY;
	save_untouch_nii(nii,'FE_permuteXY_flipY.nii');

	% size of data_permuteXY_flipY: X,Y,Z,3
	% x components: (X,Y,Z,1)
	% y components: (X,Y,Z,2)
	% z components: (X,Y,Z,3)
	% x,y,z components are in the coordinates of FOV acquisition (patientOrientation) RAS

	% transform from FOV RAS to scanner RAS
	% patientOrientation [Xx, Xy, Xz, Yx, Yy, Yz]
	patientOrientation = diffusion_orientations{i,2:7};
	Xx = patientOrientation(1);
	Xy = patientOrientation(2);
	Xz = patientOrientation(3);
	Yx = patientOrientation(4);
	Yy = patientOrientation(5);
	Yz = patientOrientation(6);

	% calculate Zx,Zy,Zz
	Zxyz = cross([Xx, Xy, Xz], [Yx, Yy, Yz]);
	Zx = Zxyz(1);
	Zy = Zxyz(2);
	Zz = Zxyz(3);

	% form the transformation matrix
	T = [Xx, Yx, Zx; Xy, Yy, Zy; Xz, Yz, Zz];

	% reshape data_permuteXY_flipY into 3*number_of_voxels
	tmp = permute(data_permuteXY_flipY,[4,1,2,3]);
	tmp = reshape(tmp,3,[]);

	imsize = size(data_permuteXY_flipY);
	sizeX = imsize(1);
	sizeY = imsize(2);
	sizeZ = imsize(3);

	Vectors_ScannerRAS = T*tmp;
	Vectors_ScannerRAS = reshape(Vectors_ScannerRAS,[3, sizeX, sizeY, sizeZ]);
	Vectors_ScannerRAS = permute(Vectors_ScannerRAS,[2,3,4,1]);

	nii.img = Vectors_ScannerRAS;
	save_untouch_nii(nii,'Vectors_ScannerRAS.nii');

	% calculate the sin2_alpha to the main field
	sin2_alpha = 1 - Vectors_ScannerRAS(:,:,:,3).^2;
	nii2 = make_nii(sin2_alpha,vox);
	save_nii(nii2,'sin2_alpha.nii');


	% make use of the FLIRT registration between QSM/T2* and DTI/B0
	% To finally calculate the fiber angle between acquisition QSM and B0
	% map from DTI to QSM (apply the inverse tranform, since did FLIRT from QSM to B0)
	load flirt_trans_T2s_to_B0.mat -ASCII
	F = flirt_trans_T2s_to_B0(1:3,1:3);
	qsm_Vectors_ScannerRAS = F\(T*tmp);
	qsm_Vectors_ScannerRAS = reshape(qsm_Vectors_ScannerRAS,[3, sizeX, sizeY, sizeZ]);
	qsm_Vectors_ScannerRAS = permute(qsm_Vectors_ScannerRAS,[2,3,4,1]);

	% calculate the sin2_alpha to the main field
	qsm_sin2_alpha = 1 - qsm_Vectors_ScannerRAS(:,:,:,3).^2;
	nii2 = make_nii(qsm_sin2_alpha,vox);
	save_nii(nii2,'qsm_sin2_alpha.nii');
end

