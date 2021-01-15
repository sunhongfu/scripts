function sig = pc_test_const(kData, shift)

r = kData(:,:,1,1); 
f = kData(:,:,2,2); 

r = r*exp( 1i*shift);
f = f*exp(-1i*shift);

r = ifftshift(fft(fftshift(r,1),[],1),1); % to image space
f = ifftshift(fft(fftshift(f,1),[],1),1); % to image space

sig = r.*conj(f);
sig = sum(sig,2); %sum over coils
sig = sum(sig,1); %sum over entire line
sig = abs(sig);

end