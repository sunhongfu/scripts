
% read in MESPGR dicoms (multi-echo gradient-echo)
path_dicom = cd(cd(path_dicom));
list_dicom = dir(path_dicom);
list_dicom = list_dicom(~strncmpi('.', {list_dicom.name}, 1));


dicom_info = dicominfo([path_dicom,filesep,list_dicom(1).name]);
dicom_info.EchoTrainLength = 8;

imsize = [dicom_info.Width, dicom_info.Height, length(list_dicom)/dicom_info.EchoTrainLength/2, ...
			 dicom_info.EchoTrainLength];
vox = [dicom_info.PixelSpacing(1), dicom_info.PixelSpacing(2), dicom_info.SliceThickness];


% angles!!!
Xz = dicom_info.ImageOrientationPatient(3);
Yz = dicom_info.ImageOrientationPatient(6);
%Zz = sqrt(1 - Xz^2 - Yz^2);
Zxyz = cross(dicom_info.ImageOrientationPatient(1:3),dicom_info.ImageOrientationPatient(4:6));
Zz = Zxyz(3);
z_prjs = [Xz, Yz, Zz];



% read in all images into matrix
raw_ims = zeros(imsize(1),imsize(2),length(list_dicom));
for im_num = 0:length(list_dicom)-1

	raw_ims(:,:,im_num+1) = double( dicomread( [path_dicom,filesep,'IM',num2str(im_num)] ) );
end

raw_ims_mag = raw_ims(:,:,1:2:end);
raw_ims_ph = raw_ims(:,:,2:2:end);

ims_mag = reshape(raw_ims_mag,imsize(1),imsize(2),8,:);


% reshape the raw images
ims = permute(raw_ims,[3 1 2]);
ims = reshape(raw_ims,2,dicom_info.EchoTrainLength,imsize(3),imsize(1),imsize(2));
ims_mag = permute(squeeze(ims(1,:,:,:,:)),[3 4 2 1]);
ims_ph = permute(squeeze(ims(1,:,:,:,:)),[3 4 2 1]);
