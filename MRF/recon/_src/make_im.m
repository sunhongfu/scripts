%%-----------------------------------------------------------------------%%
%  Authors: M.A. Cloos
%  Martijn.Cloos@nyumc.org
%  Date: 2019 March 3
%  New York University School of Medicine, www.cai2r.net
%%-----------------------------------------------------------------------%%
function [img] = make_im(MrData)

%%-----------------------------------------------------------------------%%
% Extract the tradjectory & dimenions
%%-----------------------------------------------------------------------%%
    trj = get_trajectory(MrData);
    dim = MrData.Dim;

%%-----------------------------------------------------------------------%%
% Reconstruct the images
%%-----------------------------------------------------------------------%%
    I_rx = zeros(dim.nSl,dim.nRe,dim.nRe,dim.nCh);
    echo = 1;

    FT = NUFFT(squeeze(trj.k(1,:,:,:)), squeeze(trj.w(1,:,:,:)), 1, 0, [dim.nRe,dim.nRe], 2);
    for sl=1:dim.nSl
        for ch=1:dim.nCh
            I_rx(sl,:,:,ch)=FT'*double(squeeze(MrData.data(echo,sl,ch,:,:)));
        end
    end

%%-----------------------------------------------------------------------%%
% sum of squares
%%-----------------------------------------------------------------------%%
    img = sqrt(abs(sum(I_rx.*conj(I_rx),4)));
    

end