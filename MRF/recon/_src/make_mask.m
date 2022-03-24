%%-----------------------------------------------------------------------%%
%  Authors: M.A. Cloos
%  Martijn.Cloos@nyumc.org
%  Date: 2019 March 3
%  New York University School of Medicine, www.cai2r.net
%%-----------------------------------------------------------------------%%
function [mask] = make_mask(img, noi, invNoiseCov)

mask = img(:,:,:,1); %extract first eigen image



if numel(noi) == 1

%%-----------------------------------------------------------------------%%
% Mask based on mean signal
%%-----------------------------------------------------------------------%%    
    disp('Using mean signal to create mask.');    
    lim = mean(mask(:));
    mask(mask < lim) = 0;
    mask(mask > 0  ) = 1;
    
else
%%-----------------------------------------------------------------------%%
% Mask based on noise data
%%-----------------------------------------------------------------------%%     
    disp('Using std(noise) to create mask.');
%     tmp = sum(noi,3); %sum over rx channels
    tmp = squeeze(noi(1,1,:,:));
    
    tmp = sum(invNoiseCov*tmp);

    lim = std(tmp(:));
    mask(mask < lim) = 0;
    mask(mask > 0  ) = 1;
end
    

end