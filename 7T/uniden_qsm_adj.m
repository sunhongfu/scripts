% n4 correction 

cd /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T
for echo = 1:4
    setenv('echo',num2str(echo));
    unix('N4BiasFieldCorrection -i src/mag_corr${echo}.nii -o src/mag_corr${echo}_n4.nii');
end


cd /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T
for echo = 1:4
    setenv('echo',num2str(echo));
    unix('N4BiasFieldCorrection -i src/mag_corr${echo}.nii -o src/mag_corr${echo}_n4.nii');
end


cd /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T
for echo = 1:4
    setenv('echo',num2str(echo));
    unix('N4BiasFieldCorrection -i src/mag_corr${echo}.nii -o src/mag_corr${echo}_n4.nii');
end


cd /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/QSM_MEMP2RAGE_7T
for echo = 1:4
    setenv('echo',num2str(echo));
    unix('N4BiasFieldCorrection -i src/mag_corr${echo}.nii -o src/mag_corr${echo}_n4.nii');
end


cd /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T
for echo = 1:4
    setenv('echo',num2str(echo));
    unix('N4BiasFieldCorrection -i src/mag_corr${echo}.nii -o src/mag_corr${echo}_n4.nii');
end



% coordinate adjustment

cd /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T
!gunzip ../UNIDEN_comboecho/20170228_124116mp2rage0p75mmisoBipolarPloss046a4001.nii.gz
nii_coord_adj_LAS('src/mag_corr1_n4.nii','../UNIDEN_comboecho/20170228_124116mp2rage0p75mmisoBipolarPloss046a4001.nii');
nii_coord_adj_LAS('RESHARP/chi_iLSQR_smvrad2.nii','../UNIDEN_comboecho/20170228_124116mp2rage0p75mmisoBipolarPloss046a4001.nii');
nii_coord_adj_LAS('BET_mask.nii','../UNIDEN_comboecho/20170228_124116mp2rage0p75mmisoBipolarPloss046a4001.nii');
nii_coord_adj_LAS('R2_I2.nii','../UNIDEN_comboecho/20170228_124116mp2rage0p75mmisoBipolarPloss046a4001.nii');



cd /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T
!gunzip ../UNIDEN_comboecho/20170927_105246mp2rage0p75BiPlos4TEVariedBWtx220s008a4001.nii.gz
nii_coord_adj_LAS('src/mag_corr1_n4.nii','../UNIDEN_comboecho/20170927_105246mp2rage0p75BiPlos4TEVariedBWtx220s008a4001.nii');
nii_coord_adj_LAS('RESHARP/chi_iLSQR_smvrad2.nii','../UNIDEN_comboecho/20170927_105246mp2rage0p75BiPlos4TEVariedBWtx220s008a4001.nii');
nii_coord_adj_LAS('BET_mask.nii','../UNIDEN_comboecho/20170927_105246mp2rage0p75BiPlos4TEVariedBWtx220s008a4001.nii');
nii_coord_adj_LAS('R2_I2.nii','../UNIDEN_comboecho/20170927_105246mp2rage0p75BiPlos4TEVariedBWtx220s008a4001.nii');



cd /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T
!gunzip ../UNIDEN_comboecho/20170927_141928mp2rage0p75BiPlos4TEVariedBWtx213s012a4001.nii.gz
nii_coord_adj_LAS('src/mag_corr1_n4.nii','../UNIDEN_comboecho/20170927_141928mp2rage0p75BiPlos4TEVariedBWtx213s012a4001.nii');
nii_coord_adj_LAS('RESHARP/chi_iLSQR_smvrad2.nii','../UNIDEN_comboecho/20170927_141928mp2rage0p75BiPlos4TEVariedBWtx213s012a4001.nii');
nii_coord_adj_LAS('BET_mask.nii','../UNIDEN_comboecho/20170927_141928mp2rage0p75BiPlos4TEVariedBWtx213s012a4001.nii');
nii_coord_adj_LAS('R2_I2.nii','../UNIDEN_comboecho/20170927_141928mp2rage0p75BiPlos4TEVariedBWtx213s012a4001.nii');



cd /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/QSM_MEMP2RAGE_7T
!gunzip ../UNIDEN_comboecho/20171004_135402mp2rage0p75BiPlos4TEVariedBWs011a4001.nii.gz
nii_coord_adj_LAS('src/mag_corr1_n4.nii','../UNIDEN_comboecho/20171004_135402mp2rage0p75BiPlos4TEVariedBWs011a4001.nii');
nii_coord_adj_LAS('RESHARP/chi_iLSQR_smvrad2.nii','../UNIDEN_comboecho/20171004_135402mp2rage0p75BiPlos4TEVariedBWs011a4001.nii');
nii_coord_adj_LAS('BET_mask.nii','../UNIDEN_comboecho/20171004_135402mp2rage0p75BiPlos4TEVariedBWs011a4001.nii');
nii_coord_adj_LAS('R2_I2.nii','../UNIDEN_comboecho/20171004_135402mp2rage0p75BiPlos4TEVariedBWs011a4001.nii');



cd /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T
!gunzip ../UNIDEN_comboecho/20171031_141844mp2rage0p75BiPlos4TEVariedBWtx220s015a4001.nii.gz
nii_coord_adj_LAS('src/mag_corr1_n4.nii','../UNIDEN_comboecho/20171031_141844mp2rage0p75BiPlos4TEVariedBWtx220s015a4001.nii');
nii_coord_adj_LAS('RESHARP/chi_iLSQR_smvrad2.nii','../UNIDEN_comboecho/20171031_141844mp2rage0p75BiPlos4TEVariedBWtx220s015a4001.nii');
nii_coord_adj_LAS('BET_mask.nii','../UNIDEN_comboecho/20171031_141844mp2rage0p75BiPlos4TEVariedBWtx220s015a4001.nii');
nii_coord_adj_LAS('R2_I2.nii','../UNIDEN_comboecho/20171031_141844mp2rage0p75BiPlos4TEVariedBWtx220s015a4001.nii');


