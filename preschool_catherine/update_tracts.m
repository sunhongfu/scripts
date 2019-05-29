% update tracts (correct for size mismatch)

tract_file_location = '/media/hongfu/Seagate/office_data/project_preschool/DTI_Tract_Data/updated_tracts/1_Re_Edited/CC_Body';
cd(tract_file_location)
!rm ._*
f = E_DTI_Get_files_from_folder(tract_file_location,'.mat');
output_dir = tract_file_location;
for i=1:length(f)
    load(f{i},'TractMask','VDims')
    [filepath,name,ext] = fileparts(f{i});
    E_DTI_write_nifti_file(TractMask, VDims,[output_dir '/' name '.nii'])
end


tract_file_location = '/media/hongfu/Seagate/office_data/project_preschool/DTI_Tract_Data/updated_tracts/1_Re_Edited/CC_Genu';
cd(tract_file_location)
!rm ._*
f = E_DTI_Get_files_from_folder(tract_file_location,'.mat');
output_dir = tract_file_location;
for i=1:length(f)
    load(f{i},'TractMask','VDims')
    [filepath,name,ext] = fileparts(f{i});
    E_DTI_write_nifti_file(TractMask, VDims,[output_dir '/' name '.nii'])
end


tract_file_location = '/media/hongfu/Seagate/office_data/project_preschool/DTI_Tract_Data/updated_tracts/1_Re_Edited/CC_Splenium';
cd(tract_file_location)
!rm ._*
f = E_DTI_Get_files_from_folder(tract_file_location,'.mat');
output_dir = tract_file_location;
for i=1:length(f)
    load(f{i},'TractMask','VDims')
    [filepath,name,ext] = fileparts(f{i});
    E_DTI_write_nifti_file(TractMask, VDims,[output_dir '/' name '.nii'])
end


tract_file_location = '/media/hongfu/Seagate/office_data/project_preschool/DTI_Tract_Data/updated_tracts/1_Re_Edited/Fornix';
cd(tract_file_location)
!rm ._*
f = E_DTI_Get_files_from_folder(tract_file_location,'.mat');
output_dir = tract_file_location;
for i=1:length(f)
    load(f{i},'TractMask','VDims')
    [filepath,name,ext] = fileparts(f{i});
    E_DTI_write_nifti_file(TractMask, VDims,[output_dir '/' name '.nii'])
end


tract_file_location = '/media/hongfu/Seagate/office_data/project_preschool/DTI_Tract_Data/updated_tracts/1_Re_Edited/L_Cingulum';
cd(tract_file_location)
!rm ._*
f = E_DTI_Get_files_from_folder(tract_file_location,'.mat');
output_dir = tract_file_location;
for i=1:length(f)
    load(f{i},'TractMask','VDims')
    [filepath,name,ext] = fileparts(f{i});
    E_DTI_write_nifti_file(TractMask, VDims,[output_dir '/' name '.nii'])
end


tract_file_location = '/media/hongfu/Seagate/office_data/project_preschool/DTI_Tract_Data/updated_tracts/1_Re_Edited/L_IFO';
cd(tract_file_location)
!rm ._*
f = E_DTI_Get_files_from_folder(tract_file_location,'.mat');
output_dir = tract_file_location;
for i=1:length(f)
    load(f{i},'TractMask','VDims')
    [filepath,name,ext] = fileparts(f{i});
    E_DTI_write_nifti_file(TractMask, VDims,[output_dir '/' name '.nii'])
end


tract_file_location = '/media/hongfu/Seagate/office_data/project_preschool/DTI_Tract_Data/updated_tracts/1_Re_Edited/L_ILF';
cd(tract_file_location)
!rm ._*
f = E_DTI_Get_files_from_folder(tract_file_location,'.mat');
output_dir = tract_file_location;
for i=1:length(f)
    load(f{i},'TractMask','VDims')
    [filepath,name,ext] = fileparts(f{i});
    E_DTI_write_nifti_file(TractMask, VDims,[output_dir '/' name '.nii'])
end


tract_file_location = '/media/hongfu/Seagate/office_data/project_preschool/DTI_Tract_Data/updated_tracts/1_Re_Edited/L_Pyramidal';
cd(tract_file_location)
!rm ._*
f = E_DTI_Get_files_from_folder(tract_file_location,'.mat');
output_dir = tract_file_location;
for i=1:length(f)
    load(f{i},'TractMask','VDims')
    [filepath,name,ext] = fileparts(f{i});
    E_DTI_write_nifti_file(TractMask, VDims,[output_dir '/' name '.nii'])
end


tract_file_location = '/media/hongfu/Seagate/office_data/project_preschool/DTI_Tract_Data/updated_tracts/1_Re_Edited/L_SLF';
cd(tract_file_location)
!rm ._*
f = E_DTI_Get_files_from_folder(tract_file_location,'.mat');
output_dir = tract_file_location;
for i=1:length(f)
    load(f{i},'TractMask','VDims')
    [filepath,name,ext] = fileparts(f{i});
    E_DTI_write_nifti_file(TractMask, VDims,[output_dir '/' name '.nii'])
end


tract_file_location = '/media/hongfu/Seagate/office_data/project_preschool/DTI_Tract_Data/updated_tracts/1_Re_Edited/L_Uncinate';
cd(tract_file_location)
!rm ._*
f = E_DTI_Get_files_from_folder(tract_file_location,'.mat');
output_dir = tract_file_location;
for i=1:length(f)
    load(f{i},'TractMask','VDims')
    [filepath,name,ext] = fileparts(f{i});
    E_DTI_write_nifti_file(TractMask, VDims,[output_dir '/' name '.nii'])
end


tract_file_location = '/media/hongfu/Seagate/office_data/project_preschool/DTI_Tract_Data/updated_tracts/1_Re_Edited/R_Cingulum';
cd(tract_file_location)
!rm ._*
f = E_DTI_Get_files_from_folder(tract_file_location,'.mat');
output_dir = tract_file_location;
for i=1:length(f)
    load(f{i},'TractMask','VDims')
    [filepath,name,ext] = fileparts(f{i});
    E_DTI_write_nifti_file(TractMask, VDims,[output_dir '/' name '.nii'])
end


tract_file_location = '/media/hongfu/Seagate/office_data/project_preschool/DTI_Tract_Data/updated_tracts/1_Re_Edited/R_IFO';
cd(tract_file_location)
!rm ._*
f = E_DTI_Get_files_from_folder(tract_file_location,'.mat');
output_dir = tract_file_location;
for i=1:length(f)
    load(f{i},'TractMask','VDims')
    [filepath,name,ext] = fileparts(f{i});
    E_DTI_write_nifti_file(TractMask, VDims,[output_dir '/' name '.nii'])
end


tract_file_location = '/media/hongfu/Seagate/office_data/project_preschool/DTI_Tract_Data/updated_tracts/1_Re_Edited/R_ILF';
cd(tract_file_location)
!rm ._*
f = E_DTI_Get_files_from_folder(tract_file_location,'.mat');
output_dir = tract_file_location;
for i=1:length(f)
    load(f{i},'TractMask','VDims')
    [filepath,name,ext] = fileparts(f{i});
    E_DTI_write_nifti_file(TractMask, VDims,[output_dir '/' name '.nii'])
end


tract_file_location = '/media/hongfu/Seagate/office_data/project_preschool/DTI_Tract_Data/updated_tracts/1_Re_Edited/R_Pyramidal';
cd(tract_file_location)
!rm ._*
f = E_DTI_Get_files_from_folder(tract_file_location,'.mat');
output_dir = tract_file_location;
for i=1:length(f)
    load(f{i},'TractMask','VDims')
    [filepath,name,ext] = fileparts(f{i});
    E_DTI_write_nifti_file(TractMask, VDims,[output_dir '/' name '.nii'])
end


tract_file_location = '/media/hongfu/Seagate/office_data/project_preschool/DTI_Tract_Data/updated_tracts/1_Re_Edited/R_SLF';
cd(tract_file_location)
!rm ._*
f = E_DTI_Get_files_from_folder(tract_file_location,'.mat');
output_dir = tract_file_location;
for i=1:length(f)
    load(f{i},'TractMask','VDims')
    [filepath,name,ext] = fileparts(f{i});
    E_DTI_write_nifti_file(TractMask, VDims,[output_dir '/' name '.nii'])
end


tract_file_location = '/media/hongfu/Seagate/office_data/project_preschool/DTI_Tract_Data/updated_tracts/1_Re_Edited/R_Uncinate';
cd(tract_file_location)
!rm ._*
f = E_DTI_Get_files_from_folder(tract_file_location,'.mat');
output_dir = tract_file_location;
for i=1:length(f)
    load(f{i},'TractMask','VDims')
    [filepath,name,ext] = fileparts(f{i});
    E_DTI_write_nifti_file(TractMask, VDims,[output_dir '/' name '.nii'])
end
