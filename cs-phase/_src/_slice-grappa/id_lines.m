function [map] = id_lines(kData)
[nRe, nPh, nSl, nCh, nMe] = size(kData);

if nMe>1
    disp('id_lines: strange data size...')
end

kData = abs(squeeze(kData(:,:,:,:,1)));

kData = sum(kData,4);
kData = sum(kData,3);

map = zeros(nPh,2);

totNonZero = 0;

for iPh=1:nPh
    if max(kData(:,iPh)) > 0
        totNonZero = totNonZero +1;
        map(totNonZero,1) = totNonZero;
        map(totNonZero,2) = iPh;
    end
end

map = map(1:totNonZero,:);


end

