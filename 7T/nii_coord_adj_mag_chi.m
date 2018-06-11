
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/06PS/neutral/QSM_MEGE_7T
nii_coord_adj('src/mag_corr1_n4.nii','src/mag_corr1_dicoms.nii');
nii_coord_adj('RESHARP/chi_iLSQR_smvrad2.nii','src/mag_corr1_dicoms.nii');
nii_coord_adj('BET_mask.nii','src/mag_corr1_dicoms.nii');


cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/06PS/left/QSM_MEGE_7T
nii_coord_adj('src/mag_corr1_n4.nii','src/mag_corr1_dicoms.nii');
nii_coord_adj('RESHARP/chi_iLSQR_smvrad2.nii','src/mag_corr1_dicoms.nii');


cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/06PS/right/QSM_MEGE_7T
nii_coord_adj('src/mag_corr1_n4.nii','src/mag_corr1_dicoms.nii');
nii_coord_adj('RESHARP/chi_iLSQR_smvrad2.nii','src/mag_corr1_dicoms.nii');


cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/06PS/extension/QSM_MEGE_7T
nii_coord_adj('src/mag_corr1_n4.nii','src/mag_corr1_dicoms.nii');
nii_coord_adj('RESHARP/chi_iLSQR_smvrad2.nii','src/mag_corr1_dicoms.nii');


cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/06PS/flexion/QSM_MEGE_7T
nii_coord_adj('src/mag_corr1_n4.nii','src/mag_corr1_dicoms.nii');
nii_coord_adj('RESHARP/chi_iLSQR_smvrad2.nii','src/mag_corr1_dicoms.nii');
