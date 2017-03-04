function [SWI, LFS] = HS_swi_proc(mag, img, par, choice, fw, ppb)
% haven't considered multi-echo yet, img is 4d np x nv x ns x rcvrs

[np,nv,ns,rcvrs] = size(img);
te = par.te;

%convert img to k-space
k = fftshift(fftshift(fft( fft(img,[],1), [], 2),1),2);

%generate a 2d hamming low-pass filter
if strcmp(choice, 'hamming')
	x = hamming(round(fw*np));
	x = [zeros(round((np-round(fw*np))/2),1); x; zeros(np-round(fw*np)-round((np-round(fw*np))/2),1)];
	y = hamming(round(fw*nv));
	y = [zeros(round((nv-round(fw*nv))/2),1); y; zeros(nv-round(fw*nv)-round((nv-round(fw*nv))/2),1)];
elseif strcmp(choice, 'gausswin')
	x = gausswin(np,15);
	y = gausswin(nv,15);
elseif strcmp(choice, 'hann')
	x = hann(round(fw*np));
	x = [zeros(round((np-round(fw*np))/2),1); x; zeros(np-round(fw*np)-round((np-round(fw*np))/2),1)];
	y = hann(round(fw*nv));
	y = [zeros(round((nv-round(fw*nv))/2),1); y; zeros(nv-round(fw*nv)-round((nv-round(fw*nv))/2),1)];
end
[X,Y] = meshgrid(y,x);
Z = X.*Y;
Z = repmat(Z,[1 1 ns rcvrs]);
clear x y X Y;

%apply 'highpass' filter and generate phase
k = k.*Z;
k_lowpass = k;
clear k Z;
k_lowpass = ifft(ifft(ifftshift(ifftshift(k_lowpass,1),2),[],1),[],2);
img_lowpass = k_lowpass;
clear k_lowpass;
phase = angle(img./img_lowpass);

%convert phase to local field shift
%phase = phase ./ (1e-9 * 2*pi*42.575e6 * 1e-4*par.B0 * te);
LFS = phase;
%clear phase;

%combine 4 channels if applicable
LFS = sum(LFS.*abs(img),4)./sum(abs(img),4);

%generate SWI masks based on LFS
mask = LFS;
mask(mask > 0) = 0;
mask = (mask+ppb)./ppb;
mask(mask<0) = mask(mask<0)./pi+1;
mask = mask.^4;

%apply masks to magnitude images and generate SWI
SWI = mag.*mask;

