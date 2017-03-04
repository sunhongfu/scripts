function img = HS_SWI3dRec(k, par)

%% Reshape K-space values
disp('Reshaping and Sorting K-space Data');
np    = par.np/2;
nv    = par.nv;
nv2   = par.nv2;
nrcvrs= par.nrcvrs;
pro   = par.pro;
ppe   = par.ppe;
ppe2  = par.ppe2;
lro   = par.lro;
lpe   = par.lpe;
lpe2  = par.lpe2;

k = reshape(k,[np,nv,nrcvrs,nv2]);
k = permute(k,[1 2 4 3]);

%% Remove DC
% Marc's(count those values<=std as noise, and their mean value as DCshift)
    % for i = 1:nrcvrs
    %     itemp = k(:,:,:,i);
    %     ind = abs(itemp(:)) <= mean([std(real(itemp(:))) std(imag(itemp(:)))]);
    %     k(:,:,:,i) = k(:,:,:,i) - complex(mean(real(itemp(ind))),mean(imag(itemp(ind))));
    % end
clear i itemp ind
% Amir's (count the first several points as noise, so the mean counts as DCshift)
Mean = mean(k(1:round(np/20),:,:,:));
DCshift = repmat(Mean, [np 1 1 1]);
k = k - DCshift;

%% Apply ramp for pro and ppe shifts
% if abs(pro) > 0.001
%     disp('Applying Position Shift to RO');
%     pix = pro/(lro/np);
%     ro_ramp = exp(1i*2*pi*pix*(-1/2:1/np:1/2-1/np));
%     ro_ramp = reshape(ro_ramp, [np 1 1 1]);
%     k = k .* repmat(ro_ramp,[1 nv nv2 nrcvrs]);
%     clear ro_ramp pix
% end
    
if abs(ppe) > 0.001
    disp('Applying Position Shift To PE');
    pix = ppe/(lpe/nv);
    ph_ramp = exp(1i*2*pi*pix*(-1/2:1/nv:1/2-1/nv));
    ph_ramp = reshape(ph_ramp, [1 nv 1 1]);
    k = k .* repmat(ph_ramp,[np 1 nv2 nrcvrs]);
    clear ph_ramp pix
end

if abs(ppe2) > 0.001
    disp('Applying Position Shift To PE2');
    pix = ppe2/(lpe2/nv2);
    ph_ramp = exp(1i*2*pi*pix*(-1/2:1/nv2:1/2-1/nv2));
    ph_ramp = reshape(ph_ramp, [1 1 nv2 1]);
    k = k .* repmat(ph_ramp,[np nv 1 nrcvrs]);
    clear ph_ramp pix
end

%% Transform to image space
disp('Transforming to image space');
k = fftshift(fftshift(fftshift(fft(fft(fft(fftshift(fftshift(fftshift(k,1),2),3),[],1),[],2),[],3),1),2),3);
img = k;
clear k

%% Flip the slice dimension
img = flipdim(img,1);
img = flipdim(img,3);
