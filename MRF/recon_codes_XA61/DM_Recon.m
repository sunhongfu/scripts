function [maps] = DM_Recon(img, dictionary)
%DM_RECONM Summary of this function goes here
%   Detailed explanation goes here
img = single(img); %makes the matching much faster
maps = zeros(4,size(img,1),size(img,2),size(img,3));
%
for i=1:size(img,1)
    [map, ~] = fast_match(img(i,:,:,:), dictionary, dictionary.chuck);
    maps(:,i,:,:) = map;
    disp(num2str(i));
end

end

