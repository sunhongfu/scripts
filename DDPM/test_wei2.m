load('/Users/uqhsun8/SunLab Dropbox/Admins Only/github/deepMRI_data/DCRNet_data/demo/single_channel/kspace_full.mat');
k = permute(k, [1 3 4 2]);
k_2d = fftshift(fft(fftshift(k,4),[],4),4);
k_2d_sl = k_2d(:,:,1,80);
img_2d_sl = fftshift(fft2(fftshift(k_2d_sl)));
figure; imagesc(abs(img_2d_sl)); colormap('gray')
figure; imagesc(angle(img_2d_sl)); colormap('gray')
figure; imagesc(real(img_2d_sl)); colormap('gray')
figure; imagesc(imag(img_2d_sl)); colormap('gray')


% downsample image to half size (128*128)
% truncate the center of k-space will downsample in image space
k_2d_sl_lr = k_2d_sl(1+64:end-64, 1+64:end-64);
img_2d_sl_lr = fftshift(fft2(fftshift(k_2d_sl_lr)));
figure; imagesc(abs(img_2d_sl_lr)); colormap('gray')
figure; imagesc(angle(img_2d_sl_lr)); colormap('gray')
figure; imagesc(real(img_2d_sl_lr)); colormap('gray')
figure; imagesc(imag(img_2d_sl_lr)); colormap('gray')