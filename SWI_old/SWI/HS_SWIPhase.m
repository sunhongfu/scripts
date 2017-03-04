function phase = HS_SWIPhase(img, choice, fw)

[np, nv, ns, nrcvrs] = size(img);

% convert img to frequency domain
k = fftshift(fftshift(fft( fft(img,[],1), [], 2),1),2);

% generate a 2d hamming low-pass filter
if strcmp(choice, 'hamming')
	x = hamming(round(fw*np));
	x = [zeros(round((np-round(fw*np))/2),1); x; zeros(np-round(fw*np)-round((np-round(fw*np))/2),1)];
	y = hamming(round(fw*nv));
	y = [zeros(round((nv-round(fw*nv))/2),1); y; zeros(nv-round(fw*nv)-round((nv-round(fw*nv))/2),1)];
elseif strcmp(choice, 'gausswin')
  	x = gausswin(round(fw*np));
	x = [zeros(round((np-round(fw*np))/2),1); x; zeros(np-round(fw*np)-round((np-round(fw*np))/2),1)];
	y = gausswin(round(fw*nv));
	y = [zeros(round((nv-round(fw*nv))/2),1); y; zeros(nv-round(fw*nv)-round((nv-round(fw*nv))/2),1)];
elseif strcmp(choice, 'hann')
	x = hann(round(fw*np));
	x = [zeros(round((np-round(fw*np))/2),1); x; zeros(np-round(fw*np)-round((np-round(fw*np))/2),1)];
	y = hann(round(fw*nv));
	y = [zeros(round((nv-round(fw*nv))/2),1); y; zeros(nv-round(fw*nv)-round((nv-round(fw*nv))/2),1)];
end
[X,Y] = meshgrid(y,x);
Z = X.*Y;
Z = repmat(Z,[1 1 ns nrcvrs]);
clear x y X Y;

% apply 'highpass' filter and generate phase
k = k.*Z;
k_lowpass = k;
clear k Z;
k_lowpass = ifft(ifft(ifftshift(ifftshift(k_lowpass,1),2),[],1),[],2);
img_lowpass = k_lowpass;
clear k_lowpass;
phase = angle(img./img_lowpass);
