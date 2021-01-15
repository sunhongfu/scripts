function [shift] = nft_get_shift(kdata, trj)

testRange  = -0.01:0.0001:0.01;
testResult = testRange*0;
testIndex  = 1; 


kdata = sum(kdata,3); %sum slices

for dShift = testRange
    tmp = nft_nft_1D(kdata,dShift,trj,true);
    tmp = ifftshift(fft(fftshift(tmp,1),[],1),1); % to image space

    tmp = sum(tmp(:,:,:,1,1).*conj(tmp(:,:,:,2,2)),1); % compare lines dot product
    tmp = sum(tmp,2); % all coils;

    testResult(testIndex) = tmp(:);
    testIndex = testIndex+1;
end


[~, pos] =  max(abs(testResult));
shift = testRange(pos);

% disp(['[INFO]: nft_get_shift = ' num2str(shift)])

end