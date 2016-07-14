

cd /media/data/Hongfu/Project_fQSM/1.5T/ZC_RAW/
A=`ls -d *333*`
B=`ls -d *222*`

/usr/share/fsl/5.0/bin/flirt -in /media/data/Hongfu/Project_fQSM/1.5T/ZC_RAW/$A/spm/meanmag_all.nii -ref /media/data/Hongfu/Project_fQSM/1.5T/ZC_RAW/$B/spm/meanmag_all.nii -out /media/data/Hongfu/Project_fQSM/1.5T/ZC_RAW/$A/spm/interpo_mag.nii -omat /media/data/Hongfu/Project_fQSM/1.5T/ZC_RAW/$A/spm/interpo_mag.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear

/usr/share/fsl/5.0/bin/flirt -in /media/data/Hongfu/Project_fQSM/1.5T/ZC_RAW/$A/spm/rsus_all.nii -applyxfm -init /media/data/Hongfu/Project_fQSM/1.5T/ZC_RAW/$A/spm/interpo_mag.mat -out /media/data/Hongfu/Project_fQSM/1.5T/ZC_RAW/$A/spm/interpo_rsus_all.nii -paddingsize 0.0 -interp trilinear -ref /media/data/Hongfu/Project_fQSM/1.5T/ZC_RAW/$B/spm/rsus_all.nii





%%%%%%%%%%%%%%%%%%% 4.7T

/usr/lib/fsl/flirt -in /media/data/Hongfu/fQSM/4.7T/ZC_47T_20150702/s_20150702_01/data/se_epi_dw_fMRI_HR2_01.fid/spm/meanmag_all.nii -ref /media/data/Hongfu/fQSM/4.7T/ZC_47T_20150702/s_20150702_01/data/se_epi_dw_fMRI_HR15_01.fid/spm/meanmag_all.nii -out /media/data/Hongfu/fQSM/4.7T/ZC_47T_20150702/s_20150702_01/data/se_epi_dw_fMRI_HR2_01.fid/spm/interpo_mag.nii -omat /media/data/Hongfu/fQSM/4.7T/ZC_47T_20150702/s_20150702_01/data/se_epi_dw_fMRI_HR2_01.fid/spm/interpo_mag.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear

/usr/lib/fsl/flirt -in /media/data/Hongfu/fQSM/4.7T/ZC_47T_20150702/s_20150702_01/data/se_epi_dw_fMRI_HR2_01.fid/spm/rsus_all.nii -applyxfm -init /media/data/Hongfu/fQSM/4.7T/ZC_47T_20150702/s_20150702_01/data/se_epi_dw_fMRI_HR2_01.fid/spm/interpo_mag.mat -out /media/data/Hongfu/fQSM/4.7T/ZC_47T_20150702/s_20150702_01/data/se_epi_dw_fMRI_HR2_01.fid/spm/interpo_rsus_all.nii -paddingsize 0.0 -interp trilinear -ref /media/data/Hongfu/fQSM/4.7T/ZC_47T_20150702/s_20150702_01/data/se_epi_dw_fMRI_HR15_01.fid/spm/rsus_all.nii



/usr/lib/fsl/flirt -in /media/data/Hongfu/fQSM/4.7T/ZC_47T_20150702/s_20150702_01/data/se_epi_dw_fMRI_Fullbrain_01.fid/spm/meanmag_all.nii -ref /media/data/Hongfu/fQSM/4.7T/ZC_47T_20150702/s_20150702_01/data/se_epi_dw_fMRI_HR15_01.fid/spm/meanmag_all.nii -out /media/data/Hongfu/fQSM/4.7T/ZC_47T_20150702/s_20150702_01/data/se_epi_dw_fMRI_Fullbrain_01.fid/spm/interpo_mag.nii -omat /media/data/Hongfu/fQSM/4.7T/ZC_47T_20150702/s_20150702_01/data/se_epi_dw_fMRI_Fullbrain_01.fid/spm/interpo_mag.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear

/usr/lib/fsl/flirt -in /media/data/Hongfu/fQSM/4.7T/ZC_47T_20150702/s_20150702_01/data/se_epi_dw_fMRI_Fullbrain_01.fid/spm/rsus_all.nii -applyxfm -init /media/data/Hongfu/fQSM/4.7T/ZC_47T_20150702/s_20150702_01/data/se_epi_dw_fMRI_Fullbrain_01.fid/spm/interpo_mag.mat -out /media/data/Hongfu/fQSM/4.7T/ZC_47T_20150702/s_20150702_01/data/se_epi_dw_fMRI_Fullbrain_01.fid/spm/interpo_rsus_all.nii -paddingsize 0.0 -interp trilinear -ref /media/data/Hongfu/fQSM/4.7T/ZC_47T_20150702/s_20150702_01/data/se_epi_dw_fMRI_HR15_01.fid/spm/rsus_all.nii


