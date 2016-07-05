main_dir = '/media/academicfs/MEM/DomperidoneData_Sorted_Anonymous';

folder_list = dir(main_dir);
folder_list = folder_list([folder_list.isdir] & ~strncmpi('.', {folder_list.name}, 1));

for i = 1:length(folder_list)
	current_folder = [main_dir, filesep, folder_list(i).name];
	setenv('current_folder',current_folder);
	[status,cmdout] = system('find "${current_folder}" -name sus_resharp*.nii');
	current_folder
	if strcmp(cmdout,'')
		[status,cmdout] = system('find "${current_folder}" -name *ME_SPGRE*');
		qsm_spgr_ge(strtrim(cmdout),current_folder);
	end
end