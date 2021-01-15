function kData = prewhitening(kData,ARG)

    [nRe,nPh,nCh,nMe] = size(kData);
    
    L = chol(ARG.NC,'lower');
    L_inv = inv(L);    

    kData = permute(kData, [3,1,2,4]);
    kData = reshape(kData, nCh,nRe*nPh*nMe);
    
    kData = ARG.INC*kData;
    kData = L_inv*kData;
    
    
    kData = reshape(kData, nCh, nRe, nPh, nMe);
    kData = permute(kData, [2,3,1,4]);
  
end