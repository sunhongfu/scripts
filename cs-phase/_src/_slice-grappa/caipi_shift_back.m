function kData = caipi_shift_back(kData,ARG)

    for iPh = 1:size(kData,2)
        phi = (iPh-1)*pi/(ARG.iPAT.factor(2));
        epi = exp(-1i*ARG.mb.sign*(phi+ARG.mb.theta));

        kData(:,iPh,:,:,:) = epi * kData(:,iPh,:,:,:);    
    end

end
