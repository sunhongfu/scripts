clear
clc

recon_folder = './recons_svd_newdata/';
mkdir(recon_folder)
% FilePath = '/Users/uqhsun8/Library/CloudStorage/OneDrive-TheUniversityofQueensland/Desktop/scan_27may2026/sub02/meas_MID00090_FID13404_FB_shot1_res192_bw500_slc8.dat';
FilePath = '/Volumes/LaCie_Top/MRF_bSSFP/2026_08_06_Newcastle/meas_MID00382_FID22015_src_MrImagingFW_seq_FB_FLASHBack.dat';


for i = 1:22

    tmp_mappath = [recon_folder, sprintf('maps_slice%s.nii', num2str(i))];
    tmp_imgpath = [recon_folder, sprintf('img_slice%s.nii', num2str(i))];

    [maps, ~] = MRF_Recon_DM_svd(FilePath, i, tmp_mappath, tmp_imgpath );
end

recon_folder = './recons_svd_newdata/';
mkdir(recon_folder)
% 
% for i = 1 : 32
% 
%     tmp_mappath = [recon_folder, sprintf('maps_slice%s.nii', num2str(i))];
% 
%     [maps, ~] = MRF_Recon_DM_nosvd(FilePath, i, tmp_mappath);
% end