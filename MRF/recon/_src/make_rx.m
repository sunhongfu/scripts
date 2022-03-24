%%-----------------------------------------------------------------------%%
%  Authors: M.A. Cloos
%  Martijn.Cloos@nyumc.org
%  Date: 2019 March 3
%  New York University School of Medicine, www.cai2r.net
%%-----------------------------------------------------------------------%%
function [I_rx] = make_rx(MrData, r, mode)

%%-----------------------------------------------------------------------%%
% Extract the tradjectory & dimenions
%%-----------------------------------------------------------------------%%
    trj = get_trajectory(MrData);
    dim = MrData.Dim;
    r   = round(r); 
%%-----------------------------------------------------------------------%%
% Reconstruct the images
%%-----------------------------------------------------------------------%%
    I_rx = zeros(dim.nSl,dim.nRe,dim.nRe,dim.nCh);
    echo = 1;
    if r < 1
        p1 = 1;
        p2 = dim.nRe;        
    elseif r<dim.nRe
        p1 = (dim.nRe-r)/2;
        p2 = round(dim.nRe/2 +r/2 +1);
    else
        p1 = 1;
        p2 = dim.nRe;
    end
    
    FT = NUFFT(squeeze(trj.k(1,:,:,1)), squeeze(trj.w(1,:,:,1)), 1, 0, [dim.nRe,dim.nRe], 2);
    for sl=1:dim.nSl
        for ch=1:dim.nCh
            tmp = squeeze(MrData.data(echo,sl,ch,:,:,1));
            tmp(1:p1  ,:) = 0.0;
            tmp(p2:end,:) = 0.0;
            I_rx(sl,:,:,ch)=FT'*double(tmp);
        end
    end

%%-----------------------------------------------------------------------%%
% Extract images from radial pre-scan
%%-----------------------------------------------------------------------%%
    if strcmp(mode, 'SOS')
        I_body__rx = sqrt(abs(sum(I_rx.*conj(I_rx),4)));
    else
    
        I_body__rx = abs(I_rx(:,:,:,1));
    end
%     save('I_rx.mat','I_rx');
%     save('ref','I_body__rx');
%%-----------------------------------------------------------------------%%
% Calculate ratios
%%-----------------------------------------------------------------------%%
    I_rx = I_rx./repmat(I_body__rx,1,1,1,size(I_rx,4));
    
% %%-----------------------------------------------------------------------%%
% % Mask
% %%-----------------------------------------------------------------------%%    
%     mask = I_body__rx;
%     lim = mean(mask(:));
%     mask(mask < lim) = 0;
%     mask(mask > lim) = 1;
%     I_rx = I_rx.*repmat(mask,1,1,1,size(I_rx,4));
%     
% %%-----------------------------------------------------------------------%%
% % Normalize
% %%-----------------------------------------------------------------------%%     
%     I_rx = I_rx/max(abs(I_rx(:)));

end