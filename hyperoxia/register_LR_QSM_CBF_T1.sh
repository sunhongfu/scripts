# office-fedora

# register magnitude with T1


/usr/local/fsl/bin/flirt -in /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/recon_QSM_O2=25_6/combine/mag_cmb1.nii -ref /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/T1_nifti.nii -out /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/25_to_T1.nii -omat /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/25_to_T1.mat -bins 256 -cost corratio -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 6  -interp trilinear


/usr/local/fsl/bin/flirt -in /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/recon_QSM_O2=50_10/combine/mag_cmb1.nii -ref /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/T1_nifti.nii -out /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/50_to_T1.nii -omat /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/50_to_T1.mat -bins 256 -cost corratio -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 6  -interp trilinear


/usr/local/fsl/bin/flirt -in /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/recon_QSM_O2=75_13/combine/mag_cmb1.nii -ref /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/T1_nifti.nii -out /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/75_to_T1.nii -omat /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/75_to_T1.mat -bins 256 -cost corratio -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 6  -interp trilinear


/usr/local/fsl/bin/flirt -in /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/recon_QSM_O2=100_16/combine/mag_cmb1.nii -ref /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/T1_nifti.nii -out /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/100_to_T1.nii -omat /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/100_to_T1.mat -bins 256 -cost corratio -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 6  -interp trilinear


# apply transformation to QSM


/usr/local/fsl/bin/flirt -in /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/recon_QSM_O2=100_16/RESHARP/sus_resharp.nii -applyxfm -init /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/100_to_T1.mat -out /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/QSM_100.nii -paddingsize 0.0 -interp trilinear -ref /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/T1_nifti.nii


/usr/local/fsl/bin/flirt -in /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/recon_QSM_O2=75_13/RESHARP/sus_resharp.nii -applyxfm -init /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/75_to_T1.mat -out /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/QSM_75.nii -paddingsize 0.0 -interp trilinear -ref /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/T1_nifti.nii


/usr/local/fsl/bin/flirt -in /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/recon_QSM_O2=50_10/RESHARP/sus_resharp.nii -applyxfm -init /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/50_to_T1.mat -out /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/QSM_50.nii -paddingsize 0.0 -interp trilinear -ref /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/T1_nifti.nii


/usr/local/fsl/bin/flirt -in /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/recon_QSM_O2=25_6/RESHARP/sus_resharp.nii -applyxfm -init /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/25_to_T1.mat -out /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/QSM_25.nii -paddingsize 0.0 -interp trilinear -ref /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/T1_nifti.nii



#######################################################################################################################

# register M0 to T1

/usr/local/fsl/bin/flirt -in /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/M0_map_100.nii -ref /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/T1_nifti.nii -out /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/M0_100_to_T1.nii -omat /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/M0_100_to_T1.mat -bins 256 -cost corratio -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 6  -interp trilinear


# apply transformation to CBF

/usr/local/fsl/bin/flirt -in /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/CBF_100.nii -applyxfm -init /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/M0_100_to_T1.mat -out /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/CBF_100_to_T1.nii -paddingsize 0.0 -interp trilinear -ref /mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/T1_nifti.nii