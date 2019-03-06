%% subject Sun_14_2179

cd /Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/BI-QSM_0p75
% correct for co-ordinates
nii_coord_adj('mag_corr1_n4.nii','dicom_series_QSM_gre_9echo_bi_p2_0p75iso_20181128110350_22_e1.nii');
nii_coord_adj('BET_mask.nii','dicom_series_QSM_gre_9echo_bi_p2_0p75iso_20181128110350_22_e1.nii');
nii_coord_adj('chi_iLSQR_smvrad2.nii','dicom_series_QSM_gre_9echo_bi_p2_0p75iso_20181128110350_22_e1.nii');
nii_coord_adj('R2.nii','dicom_series_QSM_gre_9echo_bi_p2_0p75iso_20181128110350_22_e1.nii');

cd /Users/hongfusun/DATA/paper_revision/registration/Sun_14_2179/ME-MP2RAGE_0p75
% correct for the SIZE. pad a zero slice
nii = load_untouch_nii('dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181128110350_11.nii');
nii.img = padarray(nii.img,[0 0 1],'post');
nii.hdr.dime.dim(2:4) = size(nii.img);
save_untouch_nii(nii,'dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181128110350_11_padded.nii');
% correct for the SIZE. pad a zero slice
for i = 1:4
    nii = load_untouch_nii(['dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181128110350_5_e' num2str(i) '.nii']);
    nii.img = padarray(nii.img,[0 0 1],'post');
    nii.hdr.dime.dim(2:4) = size(nii.img);
    save_untouch_nii(nii,['dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181128110350_5_e' num2str(i) '_padded.nii']);
end
T1_sum = 0;
for i = 1:4
    nii = load_untouch_nii(['dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181128110350_5_e' num2str(i) '_padded.nii']);
    nii.img = padarray(nii.img,[0 0 1],'post');
    T1_sum = T1_sum + nii.img;
end
nii.img = T1_sum/4;
save_untouch_nii(nii,'T1map_ave.nii');
% N4 correction
unix('N4BiasFieldCorrection -i mag_corr1.nii -o mag_corr1_n4.nii');
% correct for co-ordinates
nii_coord_adj('mag_corr1_n4.nii','dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181128110350_11_padded.nii');
nii_coord_adj('BET_mask.nii','dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181128110350_11_padded.nii');
nii_coord_adj('chi_iLSQR_smvrad2.nii','dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181128110350_11_padded.nii');
nii_coord_adj('R2.nii','dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181128110350_11_padded.nii');
nii_coord_adj('T1map_ave.nii','dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181128110350_11_padded.nii');




%% subject Tuccio_525

cd /Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/BI-QSM_0p75
% correct for co-ordinates
nii_coord_adj('mag_corr1_n4.nii','dicom_series_QSM_gre_9echo_bi_p2_0p75iso_20181127102251_39_e1.nii');
nii_coord_adj('BET_mask.nii','dicom_series_QSM_gre_9echo_bi_p2_0p75iso_20181127102251_39_e1.nii');
nii_coord_adj('chi_iLSQR_smvrad2.nii','dicom_series_QSM_gre_9echo_bi_p2_0p75iso_20181127102251_39_e1.nii');
nii_coord_adj('R2.nii','dicom_series_QSM_gre_9echo_bi_p2_0p75iso_20181127102251_39_e1.nii');

cd /Users/hongfusun/DATA/paper_revision/registration/Tuccio_525/ME-MP2RAGE_0p75
% correct for the SIZE. pad a zero slice
nii = load_untouch_nii('dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181127102251_11.nii');
nii.img = padarray(nii.img,[0 0 1],'post');
nii.hdr.dime.dim(2:4) = size(nii.img);
save_untouch_nii(nii,'dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181127102251_11_padded.nii');
% correct for the SIZE. pad a zero slice
for i = 1:4
    nii = load_untouch_nii(['dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181127102251_7_e' num2str(i) '.nii']);
    nii.img = padarray(nii.img,[0 0 1],'post');
    nii.hdr.dime.dim(2:4) = size(nii.img);
    save_untouch_nii(nii,['dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181127102251_7_e' num2str(i) '_padded.nii']);
end
T1_sum = 0;
for i = 1:4
    nii = load_untouch_nii(['dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181127102251_7_e' num2str(i) '_padded.nii']);
    nii.img = padarray(nii.img,[0 0 1],'post');
    T1_sum = T1_sum + nii.img;
end
nii.img = T1_sum/4;
save_untouch_nii(nii,'T1map_ave.nii');
% correct for co-ordinates
nii_coord_adj('mag_corr1_n4.nii','dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181127102251_11_padded.nii');
nii_coord_adj('BET_mask.nii','dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181127102251_11_padded.nii');
nii_coord_adj('chi_iLSQR_smvrad2.nii','dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181127102251_11_padded.nii');
nii_coord_adj('R2.nii','dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181127102251_11_padded.nii');
nii_coord_adj('T1map_ave.nii','dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_20181127102251_11_padded.nii');




%% subject Wu_524

cd /Users/hongfusun/DATA/paper_revision/registration/Wu_524/ME-MP2RAGE_0p75
% correct for the SIZE. pad a zero slice
nii = load_untouch_nii('dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_R-L_20181126131256_71.nii');
nii.img = padarray(nii.img,[0 0 1],'post');
nii.hdr.dime.dim(2:4) = size(nii.img);
save_untouch_nii(nii,'dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_R-L_20181126131256_71_padded.nii');
% correct for the SIZE. pad a zero slice
for i = 1:4
    nii = load_untouch_nii(['dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_R-L_20181126131256_64_e' num2str(i) '.nii']);
    nii.img = padarray(nii.img,[0 0 1],'post');
    nii.hdr.dime.dim(2:4) = size(nii.img);
    save_untouch_nii(nii,['dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_R-L_20181126131256_64_e' num2str(i) '_padded.nii']);
end
T1_sum = 0;
for i = 1:4
    nii = load_untouch_nii(['dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_R-L_20181126131256_64_e' num2str(i) '_padded.nii']);
    nii.img = padarray(nii.img,[0 0 1],'post');
    T1_sum = T1_sum + nii.img;
end
nii.img = T1_sum/4;
save_untouch_nii(nii,'T1map_ave.nii');
% correct for co-ordinates
nii_coord_adj('mag_corr1_n4.nii','dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_R-L_20181126131256_71_padded.nii');
nii_coord_adj('BET_mask.nii','dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_R-L_20181126131256_71_padded.nii');
nii_coord_adj('chi_iLSQR_smvrad2.nii','dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_R-L_20181126131256_71_padded.nii');
nii_coord_adj('R2.nii','dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_R-L_20181126131256_71_padded.nii');
nii_coord_adj('T1map_ave.nii','dicom_series_mp2rage-wip944_0p75Bi4TEMatchedtoSE_R-L_20181126131256_71_padded.nii');


