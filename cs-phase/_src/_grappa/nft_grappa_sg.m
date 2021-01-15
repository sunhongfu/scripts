function img = nft_grappa_sg(kData,iData,ARG)

%--------------------------------------------------------------------------
%% get noise matrix
%--------------------------------------------------------------------------
invNoiseCov = ARG.INC;

%--------------------------------------------------------------------------
%% GRAPPA
%--------------------------------------------------------------------------
switch ARG.kernelSize    
    case '2x3'
        kData = grappa2x3(kData,iData,ARG);
    case '2x5'
        kData = grappa2x5(kData,iData,ARG);
    case '4x3'
        kData = grappa4x3(kData,iData,ARG);
    case '4x5'
        kData = grappa4x5(kData,iData,ARG);
    case '6x7'
        disp('6x7 is not ready, using 4x5 ');
        kData = grappa4x5(kData,iData,ARG);
    otherwise
        disp('otherwise: using GRAPPA kernel size 4x5 ');
        kData = grappa4x5(kData,iData,ARG);
end

%--------------------------------------------------------------------------
%% PF 
%--------------------------------------------------------------------------
[nRe,nPh,nCh,nMe] = size(kData);

if ARG.PF ~= 1
    krecon = zeros(nRe, round(1/ARG.PF*nPh),nCh,nMe);
    krecon(:,round(1/ARG.PF*nPh)-nPh+1:end,:,:) = kData;
    switch ARG.PFrecon
        case 'zero'
            % do nothing          
        case 'pocs'
            for iMe=1:nMe                
                [~,kspFull] = pocs(permute(squeeze(krecon(:,:,:,iMe)),[3,2,1]),ARG.pocsItr);
                krecon(:,:,:,iMe) = permute(kspFull,[3,2,1]);
            end
        otherwise
            disp('otherwise: zero padding');
    end
else
    krecon = zeros(nRe,nRe/2,nCh,nMe);
    krecon(:,1:nPh,:,:) = kData;
end

%--------------------------------------------------------------------------
%% Shift image
%--------------------------------------------------------------------------
if ARG.sg == true
    for iPh = 1:size(krecon,2)
        phi = (iPh-1)*pi/(ARG.iPAT);
        epi = exp(-1i*ARG.mb.sign*(phi+ARG.mb.theta));

        krecon(:,iPh,:,:,:) = epi * krecon(:,iPh,:,:,:);    
    end
end

%--------------------------------------------------------------------------
%% Reconstruct all images
%--------------------------------------------------------------------------
[~,nPh,~,~,~] = size(krecon);
img = zeros(nRe,nPh,nMe);

rx = fft_get_rx(krecon(:,:,:,1)); 
ref = sqrt(abs(sum(rx.*conj(rx),3)));

for iMe=1:nMe
    switch ARG.recon
        case 'sos'
            img(:,:,iMe) = fft_sos_rx(krecon(:,:,:,iMe),rx);
        case 'opt'
            img(:,:,iMe) = fft_opt_rx(krecon(:,:,:,iMe),rx,ref,invNoiseCov);
        otherwise
            disp('otherwise: using sos');
            img(:,:,iMe) = fft_sos_rx(krecon(:,:,:,iMe),rx);
    end
end    

end