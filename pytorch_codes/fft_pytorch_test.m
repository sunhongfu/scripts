%% read data
lfs_r = niftiread('renzo_central_bigAngle_field_real.nii');
lfs_i = niftiread('renzo_central_bigAngle_field_imag.nii');

%% save data as shape of 2 * H * W * D 
lfs(1,:,:,:) = lfs_r;
lfs(2,:,:,:) = lfs_i;

niftiwrite(lfs, 'lfs_k')

%% matlab recon. 
lfs_k = lfs_r + 1j * lfs_i; 
lfs_img_matlab = ifftn(ifftshift(lfs_k));
figure, imagesc(lfs_img_matlab(:,:,64)); colormap gray;
caxis([-0.05,0.05])
title('matlab_{recon}')
drawnow

%% python recon; 
% use vscode to run file fft_test.py

%% load python recon results; 
try load lfs_img;
    lfs_img_py = PRED;
    err = lfs_img_py - lfs_img_matlab;
    figure, imagesc(lfs_img_py(:,:,64)); colormap gray;
    caxis([-0.05,0.05])
    title('python_{recon}')
    drawnow
       
    figure, imagesc(err(:,:,64)); colormap gray;
    caxis([-0.05,0.05])
    title('ReconErrors')
    drawnow
catch e
    msgbox('Run fft_test.py first !')
end









