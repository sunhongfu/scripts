function kData = pc_aply_const(kData, shift)

kDataDim = max(size(size(kData)));

switch kDataDim
    case 6
    kData(:,:,:,:,:,1) = kData(:,:,:,:,:,1)*exp( 1i*shift);
    kData(:,:,:,:,:,2) = kData(:,:,:,:,:,2)*exp(-1i*shift);
    case 5
    kData(:,:,:,:,1) = kData(:,:,:,:,1)*exp( 1i*shift);
    kData(:,:,:,:,2) = kData(:,:,:,:,2)*exp(-1i*shift);
    case 4
    kData(:,:,:,1) = kData(:,:,:,1)*exp( 1i*shift);
    kData(:,:,:,2) = kData(:,:,:,2)*exp(-1i*shift);
    case 3
    kData(:,:,1) = kData(:,:,1)*exp( 1i*shift);
    kData(:,:,2) = kData(:,:,2)*exp(-1i*shift);
    otherwise
    disp('[ERROR] | pc_aply_const: unexpected data size!');
end

end