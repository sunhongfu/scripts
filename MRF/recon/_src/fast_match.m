%%-----------------------------------------------------------------------%%
%  Authors: M.A. Cloos
%  Martijn.Cloos@nyumc.org
%  Date: 2019 april 23
%  New York University School of Medicine, www.cai2r.net
%%-----------------------------------------------------------------------%%
function [ maps, fits ] = fast_match( img , dictionary, partSize )

[nSl, nRe, nPh, ~] = size(img);
[nSv, nDi]         = size(dictionary.atoms);

posm  = zeros(nDi/partSize, nSl*nRe*nPh);
corm  = zeros(nDi/partSize, nSl*nRe*nPh);
index = 1;


imv = reshape(img, [ nSl*nRe*nPh nSv ]);
% imv = single(imv');
imv = single(imv.');

%%-----------------------------------------------------------------------%%
% Matching
%%-----------------------------------------------------------------------%%
pb2 = CmdLineProgressBar(' Matching: '); 
for ds=1:partSize:nDi
    de = ds + partSize - 1;
   
    atom = squeeze(dictionary.atoms(:,(ds:de)));
    atom = atom';
    [cor, pos] = max(atom*imv);
    posm(index, :)  = pos(:) + ds - 1;
    corm(index, :)  = cor(:);
    index = index + 1;
    pb2.print(de,nDi);
end

%%-----------------------------------------------------------------------%%
% Pick est matches from look uptable
%%-----------------------------------------------------------------------%%
[pdFact, pos] = max(corm);

maps  = zeros(4  ,nSl*nRe*nPh);
fits  = zeros(nSv,nSl*nRe*nPh);
for i=1:(nSl*nRe*nPh)
    maps(:,i) = dictionary.lookup(:,posm(pos(i),i));
    fits(:,i) = dictionary.atoms(:,posm(pos(i),i));
end

%%-----------------------------------------------------------------------%%
% Convert norm to PD
%%-----------------------------------------------------------------------%%
maps(1,:) =  pdFact./maps(1,:);

%%-----------------------------------------------------------------------%%
% rescale svd images with PD
%%-----------------------------------------------------------------------%%
pdFact = repmat(pdFact,[nSv 1]);
fits   = fits.*pdFact;

%%-----------------------------------------------------------------------%%
% reshape
%%-----------------------------------------------------------------------%%
maps = reshape(maps, [4, nSl,nRe,nPh]);
fits = reshape(fits, [nSv, nSl,nRe,nPh]);

% normalize the PD in the images
maps(1,:,:,:) = squeeze(maps(1,:,:,:)./(max(abs(squeeze(maps(1,:))))));

end