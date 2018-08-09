
cd /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/neutral/QSM_MEGE_7T
nii_coord_adj('src/mag_corr1_n4.nii','src/mag_corr1_dicoms.nii');
nii_coord_adj('RESHARP/chi_iLSQR_smvrad2.nii','src/mag_corr1_dicoms.nii');
nii_coord_adj('BET_mask.nii','src/mag_corr1_dicoms.nii');
nii_coord_adj('R2.nii','src/mag_corr1_dicoms.nii');



cd /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/left/QSM_MEGE_7T
nii_coord_adj('src/mag_corr1_n4.nii','src/mag_corr1_dicoms.nii');
nii_coord_adj('RESHARP/chi_iLSQR_smvrad2.nii','src/mag_corr1_dicoms.nii');


cd /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/right/QSM_MEGE_7T
nii_coord_adj('src/mag_corr1_n4.nii','src/mag_corr1_dicoms.nii');
nii_coord_adj('RESHARP/chi_iLSQR_smvrad2.nii','src/mag_corr1_dicoms.nii');


cd /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/extension/QSM_MEGE_7T
nii_coord_adj('src/mag_corr1_n4.nii','src/mag_corr1_dicoms.nii');
nii_coord_adj('RESHARP/chi_iLSQR_smvrad2.nii','src/mag_corr1_dicoms.nii');


cd /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/flexion/QSM_MEGE_7T
nii_coord_adj('src/mag_corr1_n4.nii','src/mag_corr1_dicoms.nii');
nii_coord_adj('RESHARP/chi_iLSQR_smvrad2.nii','src/mag_corr1_dicoms.nii');
