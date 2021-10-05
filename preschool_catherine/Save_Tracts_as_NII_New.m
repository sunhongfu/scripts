%this code suggested by Alexander on the E_DTI google group

tract_file_location = [uigetdir('/media/hongfu/Seagate/office_data/project_preschool/DTI_Tract_Data/updated_tracts','Select folder of DTI data to be processed...') '/'];
%grab all .mat files from a folder and save the TractMask variable from the
%.mat file, should keep things simple then.
f = E_DTI_Get_files_from_folder(tract_file_location,'.mat');
% for i=1:length(f)
% load(f{i},'TractMask','VDims')
% E_DTI_write_nifti_file(TractMask, VDims,[f{i}(1:end-3) 'nii'])
% end

output_dir = '/media/hongfu/Seagate/office_data/project_preschool/DTI_Tract_Data/updated_tracts';
mkdir(output_dir)
for i=1:length(f)
load(f{i},'TractMask','VDims')
[filepath,name,ext] = fileparts(f{i});
E_DTI_write_nifti_file(TractMask, VDims,[output_dir '/' name '.nii'])
end
