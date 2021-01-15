function [kdata] = fft_apl_co(kdata, ph)

    [nRe,nCh,nPh,nSl,nMe] = size(kdata);

    ph_ramp = exp(1i*ph*(1:nRe));
    ph_ramp = ph_ramp(:);
    ph_ramp = repmat(ph_ramp,1,nCh,1,nSl,nMe);
    
    
    %shift odd lines
    for iPh =1:2:nPh
        kdata(:,:,iPh,:,:) = kdata(:,:,iPh,:,:).* ph_ramp;
    end
    
    %shift even lines
    ph_ramp = conj(ph_ramp);
    for iPh =2:2:nPh
        kdata(:,:,iPh,:,:) = kdata(:,:,iPh,:,:).* ph_ramp;
    end

end