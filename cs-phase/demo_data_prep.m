
% coil compression

addpath(genpath('/Users/uqhsun8/Documents/MATLAB/functions/GRAPPA_berkin/'))
% dt_fa04 = mapVBVD('meas_MID152_fl3d_mtv_FA_4_FID5350.dat', 'removeOS');
dt_fa04 = mapVBVD('/Volumes/LaCie_Top/DCRNet/CS-phase/invivo/2021_06_04_CS_QSM_001/RAW/meas_MID00113_FID08841_a_gre_cs_FA4.dat', 'removeOS');
k_full = squeeze(dt_fa04.image());

k_full=k_full(:,:,:,:,1:2);

k_full=permute(k_full,[3 4 1 5 2]);

num_svd = 8;                   % no of SVD channels for compression (num_svd = 16 works well for 32 chan array)

temp = reshape(k_full, [], size(k_full,5));

[V,D] = eig(temp'*temp);
V = flipdim(V,2);


% coil compressed image, where 1st chan is the virtual body coil to be used as phase reference:
k_full_svd = reshape(temp * V(:,1:num_svd), [size(k_full,[1 2 3 4]), num_svd]);

k = permute(k_full_svd,[1 2 3 5 4]);

save('kspace_sub_AF4_cc8.mat','k','-v7.3');