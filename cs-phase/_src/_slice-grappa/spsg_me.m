function out = spsg_me(input, calib, kernel, lambda)

%   Split-slice GRAPPA Multi-band Recon
%   Based on Cauley et al., MRM 2014
%
%   MChiew
%   Nov 2016

%   input is [c,kx,ky,1,t]
%   calib is [c,kx,ky,z]
%   kernel is (kx, ky)

    w   =   weights_spsg(calib, kernel, lambda);

    [nCh,nRe,nPh,nMe] = size(input);
    [~  ,~  ,~  ,nSl] = size(calib);

    out = zeros(nCh,nRe,nPh,nSl,nMe);

    for iMe=1:nMe
        out(:,:,:,:,iMe) =   apply_weights(input(:,:,:,iMe), w);
    end

end
