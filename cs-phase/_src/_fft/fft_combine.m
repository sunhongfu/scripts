function img = fft_combine(kData,ARG,bRmOs)

    %--------------------------------------------------------------------------
    %% Reconstruct all images
    %--------------------------------------------------------------------------
    [nRe,nPh,nCh,nMe] = size(kData);
    img = zeros(nRe,nPh,nMe);

    rx = fft_get_rx(kData(:,:,:,ARG.RefMeas)); 
    ref = sqrt(abs(sum(rx.*conj(rx),3)));

    for iMe=1:nMe
        switch ARG.recon
            case 'sos'
                img(:,:,iMe) = fft_sos_rx(kData(:,:,:,iMe),rx);
            case 'opt'
                if(ARG.prewhitening)
                    disp('[WARNING]: Using both prewhitening and Roemer optimal coilcombine is not a good idea!');
                    disp('[SUGGEST]: Using both prewhitening and sum of squares!');
                end
                
                img(:,:,iMe) = fft_opt_rx(kData(:,:,:,iMe),rx,ref,ARG.INC);
            otherwise
                disp('otherwise: using sos');
                img(:,:,iMe) = fft_sos_rx(kData(:,:,:,iMe),rx);
        end
    end

    %--------------------------------------------------------------------------
    %% remove oversampling
    %--------------------------------------------------------------------------
    if (bRmOs)
        nRl = size(kData,1)/4;
        nRr = 3*nRl-1;
        img = img(nRl:nRr,:,:);
    end

end