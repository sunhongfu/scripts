
%% -----------------------------------------------------------------------%%
% Dictionary Matching recon
%%-----------------------------------------------------------------------%%

addpath(genpath('/Volumes/LaCie_Top/MRF_bSSFP/2022_01_12_Startup_package/recon/_src'))

% load dictionary (corrected non-conjugate tranposed and normalized)
load /Volumes/LaCie_Top/MRF_bSSFP/2022_01_12_Startup_package/recon/dictionary_corr.mat
load /Volumes/LaCie_Top/MRF_bSSFP/2022_01_12_Startup_package/recon/dictionary_largedict_normed.mat




%%-----------------------------------------------------------------------%%
% 1. invivo water phantom
%%-----------------------------------------------------------------------%%
load /Volumes/LaCie_Top/MRF_bSSFP/2022_01_12_Startup_package/recon/img_10shots_noSVD.mat
load /Volumes/LaCie_Top/MRF_bSSFP/2022_01_12_Startup_package/recon/phantom_mask.mat

img = single(img); %makes the matching much faster 
maps = zeros(4,size(img,1),size(img,2),size(img,3));

for i=1:size(img,1)
    % [map, ~] = fast_match(img(i,:,:,:), dictionary, dictionary.chuck);
    [map, ~] = fast_match(1j*real(img(i,:,:,:))+imag(img(i,:,:,:)), dictionary, dictionary.chuck);
    maps(:,i,:,:) = map;
    disp(num2str(i));
end

nii = make_nii(permute(maps,[3 4 1 2]).*reshape(mask,[size(mask,1) size(mask,2) 1 size(mask,3)])); 
save_nii(nii,'phantom_dm_corr.nii')





%%-----------------------------------------------------------------------%%
% 2. digital brain realistic phantom
%%-----------------------------------------------------------------------%%
load /Volumes/LaCie_Top/MRF_bSSFP/2022_01_12_Startup_package/recon/RealisticPhantom.mat

img2 = single(img2); %makes the matching much faster 
img2 = reshape(img2,[1, size(img2)]);
maps = zeros(4,size(img2,1),size(img2,2),size(img2,3));

for i=1:size(img2,1)
    [map, ~] = fast_match(img2(i,:,:,:), dictionary, dictionary.chuck);
    maps(:,i,:,:) = map;
    disp(num2str(i));
end

nii = make_nii(permute(maps,[3 4 1 2]).*mask); 
save_nii(nii,'brain_phantom_dm_corr.nii')