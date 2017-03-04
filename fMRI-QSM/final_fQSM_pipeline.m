% rename files (1 --> 001)
for i = 1:78
	setenv('j',num2str(i));
	setenv('i',num2str(i,'%03i'));
	unix('mv mag_cmb${j}.nii mag_cmb${i}.nii');
end

for i = 1:78
	nii = load_nii(['mag_cmb' num2str(i,'%03i') '.nii']);
	all_mag_cmb(:,:,:,i) = double(nii.img);
end
nii = make_nii(all_mag_cmb,voxelSize);
save_nii(nii,'all_mag_cmb.nii');



for i = 1:78
	setenv('j',num2str(i));
	setenv('i',num2str(i,'%03i'));
	unix('mv sus_resharp${j}.nii sus_resharp${i}.nii');
end

for i = 1:78
	nii = load_nii(['sus_resharp' num2str(i,'%03i') '.nii']);
	all_sus_resharp(:,:,:,i) = double(nii.img);
end
nii = make_nii(all_sus_resharp,voxelSize);
save_nii(nii,'all_sus_resharp.nii');

% do SPM motion correction!


% interpolate and register different resolutions
% 222 to 1.5
% generate the matrix from 1st volumes and apply to the rest, using FLIRT
/usr/share/fsl/bin/flirt -in /media/data/Hongfu/4.7T_HS/se_epi_dw_fMRI_HR2_run101.fid/angle_corrected/combine/mag_cmb001.nii -ref /media/data/Hongfu/4.7T_HS/se_epi_dw_fMRI_HR15_run101.fid/angle_corrected/combine/mag_cmb001.nii -out /media/data/Hongfu/4.7T_HS/se_epi_dw_fMRI_HR2_run101.fid/angle_corrected/combine/interp_mag_cmb001.nii -omat /media/data/Hongfu/4.7T_HS/se_epi_dw_fMRI_HR2_run101.fid/angle_corrected/combine/interp_mag_cmb001.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear
% apply the matrix to motion-corrected QSMs
% apply FLIRT transformation
/usr/share/fsl/bin/flirt -in /media/data/Hongfu/4.7T_HS/se_epi_dw_fMRI_HR2_run101.fid/angle_corrected/RESHARP/rall_sus_resharp.nii -applyxfm -init /media/data/Hongfu/4.7T_HS/se_epi_dw_fMRI_HR2_run101.fid/angle_corrected/combine/interp_mag_cmb001.mat -out /media/data/Hongfu/4.7T_HS/se_epi_dw_fMRI_HR2_run101.fid/angle_corrected/RESHARP/interp_rall_sus_resharp.nii -paddingsize 0.0 -interp trilinear -ref /media/data/Hongfu/4.7T_HS/se_epi_dw_fMRI_HR15_run101.fid/angle_corrected/combine/mag_cmb001.nii




% interpolate and register different resolutions
% 333 to 1.5
% generate the matrix from 1st volumes and apply to the rest, using FLIRT
/usr/share/fsl/bin/flirt -in /media/data/Hongfu/4.7T_HS/se_epi_dw_fMRI_333_visual01.fid/angle_corrected/combine/mag_cmb001.nii -ref /media/data/Hongfu/4.7T_HS/se_epi_dw_fMRI_HR15_run101.fid/angle_corrected/combine/mag_cmb001.nii -out /media/data/Hongfu/4.7T_HS/se_epi_dw_fMRI_333_visual01.fid/angle_corrected/combine/interp_mag_cmb001.nii -omat /media/data/Hongfu/4.7T_HS/se_epi_dw_fMRI_333_visual01.fid/angle_corrected/combine/interp_mag_cmb001.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear
% apply the matrix to motion-corrected QSMs
% apply FLIRT transformation
/usr/share/fsl/bin/flirt -in /media/data/Hongfu/4.7T_HS/se_epi_dw_fMRI_333_visual01.fid/angle_corrected/RESHARP/rall_sus_resharp.nii -applyxfm -init /media/data/Hongfu/4.7T_HS/se_epi_dw_fMRI_333_visual01.fid/angle_corrected/combine/interp_mag_cmb001.mat -out /media/data/Hongfu/4.7T_HS/se_epi_dw_fMRI_333_visual01.fid/angle_corrected/RESHARP/interp_rall_sus_resharp.nii -paddingsize 0.0 -interp trilinear -ref /media/data/Hongfu/4.7T_HS/se_epi_dw_fMRI_HR15_run101.fid/angle_corrected/combine/mag_cmb001.nii




# 1.5T 444 to 222
/usr/lib/fsl/5.0/flirt -in /media/data/Project_fMRI-QSM/1.5T/ZC_RAW/2015.03.13-13.04.52-epi_444_TR2_108vol_meas/RAS_FOR_PETER/mag_cmb001.nii -ref /media/data/Project_fMRI-QSM/1.5T/ZC_RAW/2015.03.13-13.23.03-epi_222_TR4_114vol_meas/RAS_FOR_PETER/mag_cmb001.nii -out /media/data/Project_fMRI-QSM/1.5T/ZC_RAW/2015.03.13-13.04.52-epi_444_TR2_108vol_meas/RAS_FOR_PETER/interp_to_222_mag_cmb001.nii -omat /media/data/Project_fMRI-QSM/1.5T/ZC_RAW/2015.03.13-13.04.52-epi_444_TR2_108vol_meas/RAS_FOR_PETER/interp_to_222_mag_cmb001.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear

/usr/lib/fsl/5.0/flirt -in /media/data/Project_fMRI-QSM/1.5T/ZC_RAW/2015.03.13-13.04.52-epi_444_TR2_108vol_meas/spm/rsus_all.nii -applyxfm -init /media/data/Project_fMRI-QSM/1.5T/ZC_RAW/2015.03.13-13.04.52-epi_444_TR2_108vol_meas/RAS_FOR_PETER/interp_to_222_mag_cmb001.mat -out /media/data/Project_fMRI-QSM/1.5T/ZC_RAW/2015.03.13-13.04.52-epi_444_TR2_108vol_meas/spm/interp_to_222_rsus_all.nii -paddingsize 0.0 -interp trilinear -ref /media/data/Project_fMRI-QSM/1.5T/ZC_RAW/2015.03.13-13.23.03-epi_222_TR4_114vol_meas/RAS_FOR_PETER/mag_cmb001.nii



%1.5T 333 to 222
/usr/share/fsl/4.1/bin/flirt -in /media/data/Hongfu/fQSM/HS_RAW/QSM_2014.11.04-15.22.50-epi_333_TR3_110vol_meas/combine/mag_cmb001.nii -ref /media/data/Hongfu/fQSM/HS_RAW/QSM_2014.11.04-15.32.28-epi_222_TR4_114vol_meas/combine/mag_cmb001.nii -out /media/data/Hongfu/fQSM/HS_RAW/QSM_2014.11.04-15.22.50-epi_333_TR3_110vol_meas/combine/interp_to_222_mag_cmb001.nii -omat /media/data/Hongfu/fQSM/HS_RAW/QSM_2014.11.04-15.22.50-epi_333_TR3_110vol_meas/combine/interp_to_222_mag_cmb001.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear

/usr/share/fsl/4.1/bin/flirt -in /media/data/Hongfu/fQSM/HS_RAW/QSM_2014.11.04-15.22.50-epi_333_TR3_110vol_meas/RESHARP/rall_sus_resharp.nii -applyxfm -init /media/data/Hongfu/fQSM/HS_RAW/QSM_2014.11.04-15.22.50-epi_333_TR3_110vol_meas/combine/interp_to_222_mag_cmb001.mat -out /media/data/Hongfu/fQSM/HS_RAW/QSM_2014.11.04-15.22.50-epi_333_TR3_110vol_meas/RESHARP/interp_to_222_rall_sus_resharp.nii -paddingsize 0.0 -interp trilinear -ref /media/data/Hongfu/fQSM/HS_RAW/QSM_2014.11.04-15.32.28-epi_222_TR4_114vol_meas/combine/mag_cmb001.nii


% SWI to 222
/usr/share/fsl/4.1/bin/flirt -in /media/data/Hongfu/fQSM/HS_RAW/QSM_2014.11.04-15.49.27-axgre3Dswi_meas/combine/mag_cmb.nii -ref /media/data/Hongfu/fQSM/HS_RAW/QSM_2014.11.04-15.32.28-epi_222_TR4_114vol_meas/combine/mag_cmb001.nii -out /media/data/Hongfu/fQSM/HS_RAW/QSM_2014.11.04-15.49.27-axgre3Dswi_meas/combine/down_to_222_mag_cmb.nii -omat /media/data/Hongfu/fQSM/HS_RAW/QSM_2014.11.04-15.49.27-axgre3Dswi_meas/combine/down_to_222_mag_cmb.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear

/usr/share/fsl/4.1/bin/flirt -in /media/data/Hongfu/fQSM/HS_RAW/QSM_2014.11.04-15.49.27-axgre3Dswi_meas/RESHARP/sus_resharp_clean.nii -applyxfm -init /media/data/Hongfu/fQSM/HS_RAW/QSM_2014.11.04-15.49.27-axgre3Dswi_meas/combine/down_to_222_mag_cmb.mat -out /media/data/Hongfu/fQSM/HS_RAW/QSM_2014.11.04-15.49.27-axgre3Dswi_meas/RESHARP/down_to_222_sus_resharp_clean.nii -paddingsize 0.0 -interp trilinear -ref /media/data/Hongfu/fQSM/HS_RAW/QSM_2014.11.04-15.32.28-epi_222_TR4_114vol_meas/combine/mag_cmb001.nii

