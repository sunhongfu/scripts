function kNew = matrix_completion(kData, nPhNew)

    [nRe,nPh,nCh,nMe] = size(kData);
    kNew = zeros(nRe,nPhNew,nCh,nMe);
    kNew(:,1:nPh,:,:) = kData;
  
end