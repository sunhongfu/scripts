% DCM to NIFTI
% subject 01EG
!/home/hongfu/bin/mricrogl_lx/dcm2niix -f UNIDEN_comboecho -o /scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho /scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/1.7.72.2.1.2.12/dicom_series
% correct for the SIZE. pad a zero slice
nii = load_untouch_nii('/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4.nii');
nii.img = padarray(nii.img,[0 0 1],'post');
nii.hdr.dime.dim(2:4) = size(nii.img);
save_untouch_nii(nii,'/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii');


!/home/hongfu/bin/mricrogl_lx/dcm2niix -f T1map -o /scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/T1map /scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/T1map/1.7.72.2.1.2.7/dicom_series
% correct for the SIZE. pad a zero slice
for i = 1:4
    nii = load_untouch_nii(['/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/T1map/T1map_c32_e' num2str(i) '.nii']);
    nii.img = padarray(nii.img,[0 0 1],'post');
    nii.hdr.dime.dim(2:4) = size(nii.img);
    save_untouch_nii(nii,['/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/T1map/T1map_c32_e' num2str(i) '_padded.nii']);
end

T1_sum = 0;
for i = 1:4
    nii = load_untouch_nii(['/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/T1map/T1map_c32_e' num2str(i) '_padded.nii']);
    nii.img = padarray(nii.img,[0 0 1],'post');
    T1_sum = T1_sum + nii.img;
end
nii.img = T1_sum/4;
save_untouch_nii(nii,'/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/T1map/T1map_ave.nii');

   



% DCM to NIFTI
% subject 02SCOTT
!/home/hongfu/bin/mricrogl_lx/dcm2niix -f UNIDEN_comboecho -o /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/1.7.72.3.1.3.20/dicom_series
% correct for the SIZE. pad a zero slice
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4.nii');
nii.img = padarray(nii.img,[0 0 1],'post');
nii.hdr.dime.dim(2:4) = size(nii.img);
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii');


!/home/hongfu/bin/mricrogl_lx/dcm2niix -f T1map -o /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/T1map /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/T1map/1.7.72.3.1.3.16/dicom_series
% correct for the SIZE. pad a zero slice
for i = 1:4
    nii = load_untouch_nii(['/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/T1map/T1map_c32_e' num2str(i) '.nii']);
    nii.img = padarray(nii.img,[0 0 1],'post');
    nii.hdr.dime.dim(2:4) = size(nii.img);
    save_untouch_nii(nii,['/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/T1map/T1map_c32_e' num2str(i) '_padded.nii']);
end

T1_sum = 0;
for i = 1:4
    nii = load_untouch_nii(['/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/T1map/T1map_c32_e' num2str(i) '_padded.nii']);
    nii.img = padarray(nii.img,[0 0 1],'post');
    T1_sum = T1_sum + nii.img;
end
nii.img = T1_sum/4;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/T1map/T1map_ave.nii');

   



% DCM to NIFTI
% subject 03JK
!/home/hongfu/bin/mricrogl_lx/dcm2niix -f UNIDEN_comboecho -o /home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho /home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/1.7.72.5.1.3.12/dicom_series
% correct for the SIZE. pad a zero slice
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4.nii');
nii.img = padarray(nii.img,[0 0 1],'post');
nii.hdr.dime.dim(2:4) = size(nii.img);
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii');


!/home/hongfu/bin/mricrogl_lx/dcm2niix -f T1map -o /home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/T1map /home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/T1map/1.7.72.5.1.3.7/dicom_series
% correct for the SIZE. pad a zero slice
for i = 1:4
    nii = load_untouch_nii(['/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/T1map/T1map_c32_e' num2str(i) '.nii']);
    nii.img = padarray(nii.img,[0 0 1],'post');
    nii.hdr.dime.dim(2:4) = size(nii.img);
    save_untouch_nii(nii,['/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/T1map/T1map_c32_e' num2str(i) '_padded.nii']);
end

T1_sum = 0;
for i = 1:4
    nii = load_untouch_nii(['/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/T1map/T1map_c32_e' num2str(i) '_padded.nii']);
    nii.img = padarray(nii.img,[0 0 1],'post');
    T1_sum = T1_sum + nii.img;
end
nii.img = T1_sum/4;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/T1map/T1map_ave.nii');

  




% DCM to NIFTI
% subject 05SG
!/home/hongfu/bin/mricrogl_lx/dcm2niix -f UNIDEN_comboecho -o /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/1.7.72.4.1.2.21/dicom_series
% correct for the SIZE. pad a zero slice
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4.nii');
nii.img = padarray(nii.img,[0 0 1],'post');
nii.hdr.dime.dim(2:4) = size(nii.img);
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii');


!/home/hongfu/bin/mricrogl_lx/dcm2niix -f T1map -o /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/T1map /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/T1map/1.7.72.4.1.2.14/dicom_series
% correct for the SIZE. pad a zero slice
for i = 1:4
    nii = load_untouch_nii(['/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/T1map/T1map_c32_e' num2str(i) '.nii']);
    nii.img = padarray(nii.img,[0 0 1],'post');
    nii.hdr.dime.dim(2:4) = size(nii.img);
    save_untouch_nii(nii,['/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/T1map/T1map_c32_e' num2str(i) '_padded.nii']);
end

T1_sum = 0;
for i = 1:4
    nii = load_untouch_nii(['/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/T1map/T1map_c32_e' num2str(i) '_padded.nii']);
    nii.img = padarray(nii.img,[0 0 1],'post');
    T1_sum = T1_sum + nii.img;
end
nii.img = T1_sum/4;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/T1map/T1map_ave.nii');

  




% n4 correction & co-ord adj
cd /scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T
for echo = 1:4
    setenv('echo',num2str(echo));
    unix('N4BiasFieldCorrection -i src/mag_corr${echo}.nii -o src/mag_corr${echo}_n4.nii');
end
% adjust coordinates
nii_coord_adj('src/mag_corr1_n4.nii','/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii');
nii_coord_adj('RESHARP/chi_iLSQR_smvrad2.nii','/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii');
nii_coord_adj('BET_mask.nii','/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii');
nii_coord_adj('R2.nii','/scratch/cj97/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii');



cd /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T
for echo = 1:4
    setenv('echo',num2str(echo));
    unix('N4BiasFieldCorrection -i src/mag_corr${echo}.nii -o src/mag_corr${echo}_n4.nii');
end
% adjust coordinates
nii_coord_adj('src/mag_corr1_n4.nii','/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii');
nii_coord_adj('RESHARP/chi_iLSQR_smvrad2.nii','/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii');
nii_coord_adj('BET_mask.nii','/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii');
nii_coord_adj('R2.nii','/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii');



cd /scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T
for echo = 1:4
    setenv('echo',num2str(echo));
    unix('N4BiasFieldCorrection -i src/mag_corr${echo}.nii -o src/mag_corr${echo}_n4.nii');
end
% adjust coordinates
nii_coord_adj('src/mag_corr1_n4.nii','/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii');
nii_coord_adj('RESHARP/chi_iLSQR_smvrad2.nii','/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii');
nii_coord_adj('BET_mask.nii','/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii');
nii_coord_adj('R2.nii','/scratch/cj97/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii');



cd /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T
for echo = 1:4
    setenv('echo',num2str(echo));
    unix('N4BiasFieldCorrection -i src/mag_corr${echo}.nii -o src/mag_corr${echo}_n4.nii');
end
% adjust coordinates
nii_coord_adj('src/mag_corr1_n4.nii','/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii');
nii_coord_adj('RESHARP/chi_iLSQR_smvrad2.nii','/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii');
nii_coord_adj('BET_mask.nii','/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii');
nii_coord_adj('R2.nii','/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/UNIDEN_comboecho_c32_e4_padded.nii');









cd /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/QSM_MEGE_7T
nii_coord_adj('src/mag_corr1_n4.nii','src/mag_corr1_dicoms.nii');
nii_coord_adj('RESHARP/chi_iLSQR_smvrad2.nii','src/mag_corr1_dicoms.nii');
nii_coord_adj('R2.nii','src/mag_corr1_dicoms.nii');

cd /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/QSM_MEGE_7T
nii_coord_adj('src/mag_corr1_n4.nii','src/mag_corr1_dicoms.nii');
nii_coord_adj('RESHARP/chi_iLSQR_smvrad2.nii','src/mag_corr1_dicoms.nii');
nii_coord_adj('R2.nii','src/mag_corr1_dicoms.nii');

cd /home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/QSM_MEGE_7T
nii_coord_adj('src/mag_corr1_n4.nii','src/mag_corr1_dicoms.nii');
nii_coord_adj('RESHARP/chi_iLSQR_smvrad2.nii','src/mag_corr1_dicoms.nii');
nii_coord_adj('R2.nii','src/mag_corr1_dicoms.nii');

cd /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/QSM_MEGE_7T
nii_coord_adj('src/mag_corr1_n4.nii','src/mag_corr1_dicoms.nii');
nii_coord_adj('RESHARP/chi_iLSQR_smvrad2.nii','src/mag_corr1_dicoms.nii');
nii_coord_adj('R2.nii','src/mag_corr1_dicoms.nii');

cd /home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/QSM_MEGE_7T
nii_coord_adj('src/mag_corr1_n4.nii','src/mag_corr1_dicoms.nii');
nii_coord_adj('RESHARP/chi_iLSQR_smvrad2.nii','src/mag_corr1_dicoms.nii');
nii_coord_adj('R2.nii','src/mag_corr1_dicoms.nii');






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

cd /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_H451/QSM_MEMP2RAGE_7T
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

