clear
clc

slices = 1:16; 

recon_folder = './recons_svd_3shots_smallFOV/'; 
mkdir(recon_folder)
FilePath = '/Volumes/T7/humanbrain_3T_MRF/bSSFP_MRF_3T_12_Jul_2022/2022_07_12/meas_MID00034_FID24632_bsffp_MRF_3Shots.dat'; 

for i = 1 : 16
    
    tmp_mappath = [recon_folder, sprintf('maps_slice%s.nii', num2str(i))]; 
    
    [maps, ~] = MRF_Recon_DM_svd(FilePath, slices(i), tmp_mappath); 
end 