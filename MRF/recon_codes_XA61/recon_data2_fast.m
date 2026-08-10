%%-----------------------------------------------------------------------%%
% Fast rewrite of recon_data2.m
%
% Instead of calling the recon once per slice (re-loading the 2 GB
% dictionary, re-computing its SVD and re-reading the whole raw .dat file
% every time), all slices are reconstructed in ONE call to
% MRF_Recon_DM_svd_fast. Output files are identical in naming/layout to
% the original per-slice outputs.
%%-----------------------------------------------------------------------%%
clear
clc

recon_folder = './recons_svd_newdata/';
mkdir(recon_folder)

FilePath = '/Volumes/LaCie_Top/MRF_bSSFP/2026_08_06_Newcastle/meas_MID00382_FID22015_src_MrImagingFW_seq_FB_FLASHBack.dat';

slice_range = 0;   % 0 (or []) = reconstruct all slices in the raw data

maps_pattern = [recon_folder, 'maps_slice%d.nii'];
img_pattern  = [recon_folder, 'img_slice%d.nii'];

[maps_all, img_all] = MRF_Recon_DM_svd_fast(FilePath, slice_range, ...
                                            maps_pattern, img_pattern);

% maps_all: (4, nSlices, nRe, nPh)  -> PD / T1 / T2 / B0
% img_all : (nSlices, nRe, nPh, nSv) aliased SVD images (complex single)
