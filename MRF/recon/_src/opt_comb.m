%%-----------------------------------------------------------------------%%
%  Authors: M.A. Cloos
%  Martijn.Cloos@nyumc.org
%  Date: 2019 March 3
%  New York University School of Medicine, www.cai2r.net
%%-----------------------------------------------------------------------%%
function [opt_img] = opt_comb(imgs, rx, invNoiseCov)

    if(numel(invNoiseCov)>1)

        nRe = size(imgs,1);
        nPh = size(imgs,2);

        opt_img = zeros(nRe,nPh);

        for irow = 1:nRe
            for icol = 1:nPh
                s_matrix = squeeze(rx(irow,icol,:));
                i_matrix = squeeze(imgs(irow,icol,:)); 

                opt_img(irow,icol) = (s_matrix')*invNoiseCov*i_matrix;
            end
        end
    
    else
        opt_img = squeeze(imgs);
    end
end