function kOut = slice_grappa(kData, iData, ARG)

    [nRe,nPh,nCh,nMe] = size(kData);

% % % % Find zero lines used to reduce the data 
     zero_map = id_lines(kData); 


% % % % Remove zero lines
    kDataTT = zeros(nCh,nRe,size(zero_map,1),nMe, 'single');
    
    kData    = permute(kData,[3,1,2,4]);
    for iPh=1:size(zero_map,1)
        kDataTT(:,:,iPh,:) = kData(:,:,zero_map(iPh,2),:);
    end
    clear('kData');
    
    iDataTT = permute(iData,[4,1,2,3]);
    iDataTT = iDataTT(:,:,1:3:end,:);  % do I need to reduce this? Yes...
       
   
% % % % slice grappa
    out_spsg = spsg_me(kDataTT, iDataTT, ARG.mb.kernel, ARG.mb.lambda); % was 5x5
    clear('kDataTT');

% % % % return zeros
    nSl = ARG.mb.factor;
    kOut = zeros(nCh,nRe,nPh,nSl,nMe, 'single');
    
    for iPh=1:size(zero_map,1)
        kOut(:,:,zero_map(iPh,2),:,:) = out_spsg(:,:,iPh,:,:);
    end
    
% % % % done
    kOut = permute(kOut,[2,3,1,4,5]);
end
