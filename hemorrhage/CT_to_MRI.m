clear
path_dcm = pwd;

% read in DICOMs into NIFTI
path_dcm = cd(cd(path_dcm));
dcm_list = dir(path_dcm);

for i = 3:length(dcm_list)
    dcm(:,:,i-2) = permute(single(dicomread([path_dcm,filesep,dcm_list(i).name])),[2,1]);
end

% get the sequence parameters
dicom_info = dicominfo([path_dcm,filesep,dcm_list(3).name]);
vox = [dicom_info.PixelSpacing(1), dicom_info.PixelSpacing(2), dicom_info.SliceThickness];
imsize = size(dcm);

cd ..
nii = make_nii(dcm,vox);
save_nii(nii,'head_CT.nii');


% coregister CT to MRI magnitude

% run elastix
unix('elastix -f /media/data/Hongfu/Project_Hemorrhage/ALL_DATA/ICH/ICHADAPT_II_13/2013.08.20-10.20.49/QSM_SWI15/combine/mag_cmb.nii -m result.0.nii.gz -out deform . -p ~/Documents/MATLAB/elastix/Deformable.txt');



mkdir deform
elastix -f /media/data/3T/ICH-ADAPTII/ICHADAPT_II_084/2017_02_06/QSM_HEMO_PRISMA/src/mag.nii -m head_CT.nii -out deform -p ~/Documents/MATLAB/elastix/Deformable.txt



