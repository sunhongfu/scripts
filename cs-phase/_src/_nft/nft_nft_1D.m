function kdata = nft_nft_1D(kdata,shift,trj,bRemoveOS)

    if(kdata==0)
        return; 
    end
    
    kDataDim = max(size(size(kdata)));
    
    nRe = size(kdata, 1);
    nCh = size(kdata, 2);
    nPh = size(kdata, 3);
    
    switch kDataDim
        case 6
            nRe = size(kdata, 1);
            nCh = size(kdata, 2);
            nPh = size(kdata, 3);
            nSl = size(kdata, 4);        
            nMe = size(kdata, 5);
            nSe = size(kdata, 6);
            nAll= nPh*nSl*nMe;
            
            kDataR = kdata(:,:,:,:,:,1);
            kDataF = kdata(:,:,:,:,:,2);
            
        case 5 % nSl or nMe do not matter
            nRe = size(kdata, 1);
            nCh = size(kdata, 2);
            nPh = size(kdata, 3);
            nSl = size(kdata, 4);        
            nSe = size(kdata, 5);
            nAll= nPh*nSl;
            
            kDataR = kdata(:,:,:,:,1);
            kDataF = kdata(:,:,:,:,2);            
            
        case 4
            nRe = size(kdata, 1);
            nCh = size(kdata, 2);
            nPh = size(kdata, 3);
            nSe = size(kdata, 4);
            nAll= nPh;
            
            kDataR = kdata(:,:,:,1);
            kDataF = kdata(:,:,:,2);            

        case 3
            disp('FLASH calibartion')
            nRe = size(kdata, 1);
            nCh = size(kdata, 2);
            nPh = size(kdata, 3);
            nSe = 2;
            nAll= nPh;
            
            kDataR = kdata(:,:,:,1);
            kDataF = 0*kdata(:,:,:,1);            
            
            
        
        otherwise
            disp('[ERROR] | nft_nft_1D, unknown data size lvl1');
            return;
    end
    
    %-----------------------------------------------------------------------
    %% Prepare nuft operator
    %-----------------------------------------------------------------------
    x1 = trj.x - shift; %read shift
    x2 = trj.x + shift; %read shift
    
    FT1 = NUFFT(x1, trj.w, 1, 0, [nRe,1], 2);
    FT2 = NUFFT(x2, trj.w, 1, 0, [nRe,1], 2);    
    
   %-----------------------------------------------------------------------
   %% Regrid
   %-----------------------------------------------------------------------  
   centre = nRe / 2;
% tic
   for iAll=1:nAll
      if abs(kDataR(centre,1,iAll)) > 0 % don't fft zero lines
       for iCh=1:nCh
            kDataR(:,iCh,iAll) = FT1'*double(squeeze(kDataR(:,iCh,iAll)));
       end
      end
      
      if abs(kDataF(centre,1,iAll)) > 0  % don't fft zero lines
       for iCh=1:nCh
            kDataF(:,iCh,iAll) = FT2'*double(squeeze(kDataF(:,iCh,iAll)));
       end
      end
       
   end
% toc
    
    switch kDataDim
        case 6
            kdata(:,:,:,:,:,1) = kDataR;
            kdata(:,:,:,:,:,2) = kDataF;
            kdata = reshape(kdata, [nRe,nCh,nPh,nSl,nMe,nSe]);
        case 5
            kdata(:,:,:,:,1) = kDataR;
            kdata(:,:,:,:,2) = kDataF;
            kdata = reshape(kdata, [nRe,nCh,nPh,nSl,nSe]);
        case 4
            kdata(:,:,:,1) = kDataR;
            kdata(:,:,:,2) = kDataF;
            kdata = reshape(kdata, [nRe,nCh,nPh,nSe]);
        case 3
            kdata = zeros(nRe,nCh,nPh,2);
            kdata(:,:,:,1) = kDataR;
            kdata(:,:,:,2) = kDataF;
            kdata = reshape(kdata, [nRe,nCh,nPh,2]);            
        otherwise
            disp('[ERROR] | nft_nft_1D, unknown data size lvl2');
            return;
    end
 
   %-----------------------------------------------------------------------
   %% Remove OS
   %-----------------------------------------------------------------------   
    if(bRemoveOS)
        nRl = size(kdata,1)/4;
        nRr = 3*nRl-1;
        kdata = kdata(nRl:nRr,:,:,:,:,:);
    end

   %-----------------------------------------------------------------------
   %% Return to k-space
   %----------------------------------------------------------------------- 
    kdata = ifftshift(ifft(fftshift(kdata,1),[],1),1);
    
    


end