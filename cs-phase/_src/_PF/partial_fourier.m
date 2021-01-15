function kFull = partial_fourier(kData,ARG)

[nRe,nPh,nCh,nMe] = size(kData);

kFull = zeros(nRe, round(1/ARG.PF*nPh),nCh,nMe);
kFull(:,round(1/ARG.PF*nPh)-nPh+1:end,:,:) = kData;
switch ARG.PFrecon
    case 'zero'
        % do nothing 
    case 'pocs'
        for iMe=1:nMe                
            [~,kspFull] = pocs(permute(squeeze(kFull(:,:,:,iMe)),[3,2,1]),ARG.pocsItr);
            kFull(:,:,:,iMe) = permute(kspFull,[3,2,1]);
        end
    otherwise
        disp('otherwise: zero padding');
end

end