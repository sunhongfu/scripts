function [invNoiseCov, noisecov] = get_inv_noise_cov(twix_obj)

    if(~isfield(twix_obj,'noise'))
        disp('[ERROR]: Missing noise data!');
        return;
    end
   
    nData = squeeze(twix_obj.noise());

    [~,nCh] = size(nData);

    noisecov = zeros(nCh);

    for iCh = 1:nCh
       for jCh = 1:nCh
           noisecov(iCh,jCh) = sum(squeeze( nData(:,iCh).*conj(nData(:,jCh)) ));
       end
    end

    invNoiseCov = inv(noisecov);
    invNoiseCov = invNoiseCov./norm(invNoiseCov);

end