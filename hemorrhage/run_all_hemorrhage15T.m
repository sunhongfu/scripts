! find /media/data/Hongfu/Project_Hemorrhage/rawdata/ -name "*axgre3Dswi*.out" > hemorrhage_rawfiles_list
fileID = fopen('hemorrhage_rawfiles_list');
C = textscan(fileID,'%s','delimiter','\n'); % list of all file names

for i = 1: size(C{1},1)
	meas_in = C{1}{i};
	path_out = '/media/data/Hongfu/Project_Hemorrhage/recon';
	qsm_swi15(meas_in, path_out);
end
