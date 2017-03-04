function img = HS_SWI2dRec(k, par)

%% Reshape K-space values
disp('Reshaping and Sorting K-space Data');
np    = par.np/2;
nv    = par.nv;
ns    = par.ns;
nrcvrs= par.nrcvrs;
pro   = par.pro;
ppe   = par.ppe;
lro   = par.lro;
lpe   = par.lpe;
pss   = par.pss;

k = reshape(k,[np,ns,nrcvrs,nv]);
k = permute(k,[1 4 2 3]);

%% Remove DC
% Marc's(count those values<=std as noise, and their mean value as DCshift)
for i = 1:nrcvrs
    itemp = k(:,:,:,i);
    ind = abs(itemp(:)) <= mean([std(real(itemp(:))) std(imag(itemp(:)))]);
    k(:,:,:,i) = k(:,:,:,i) - complex(mean(real(itemp(ind))),mean(imag(itemp(ind))));
end
clear i itemp ind
% Amir's (count the first several points as noise, so the mean counts as DCshift)
% Mean = mean(k(1:round(np/20),:,:,:));
% DCshift = repmat(Mean, [np 1 1 1]);
% k = k - DCshift;

%% Apply ramp for pro and ppe shifts
% if abs(pro) > 0.001
%     disp('Applying Position Shift to RO');
%     pix = pro/(lro/np)
% %    ro_ramp = exp(1i*2*pi*pix*(-1/2:1/np:1/2-1/np));
%     ro_ramp = exp(1i*2*pi*pix*(0:np-1)/np);
%     ro_ramp = reshape(ro_ramp, [np 1 1 1]);
%     k = k .* repmat(ro_ramp,[1 nv ns nrcvrs]);
%     clear ro_ramp pix
% end
    
if abs(ppe) > 0.001
    disp('Applying Position Shift To PE');
    pix = ppe/(lpe/nv);
    ph_ramp = exp(1i*2*pi*pix*(-1/2:1/nv:1/2-1/nv));
    ph_ramp = reshape(ph_ramp, [1 nv 1 1]);
    k = k .* repmat(ph_ramp,[np 1 ns nrcvrs]);
    clear ph_ramp pix
end

%% Transform to image space
disp('Transforming to image space');
k = fftshift(fftshift(fft(fft(fftshift(fftshift(k,1),2),[],1),[],2),1),2);
%k = fftshift(fftshift(fft(fft(k,[],1),[],2),1),2);
img = k;
clear k

%   Reorder slices
[par.pss ind] = sort(pss);
img(:,:,:,:) = img(:,:,ind,:);
img = flipdim(img,1);
