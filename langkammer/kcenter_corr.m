nii1 = load_untouch_nii('/Volumes/LaCie_Bottom/collaborators/Christian_Langkammer/data-lap-unet/7T_Control_magni.nii');
mag = single(nii1.img);

nii2 = load_untouch_nii('/Volumes/LaCie_Bottom/collaborators/Christian_Langkammer/data-lap-unet/7T_Control_phase.nii');
pha = single(nii2.img);
pha = 2*pi.*(pha - min(pha(:)))/(max(pha(:)) - min(pha(:))) - pi;

vox = nii1.hdr.dime.pixdim(2:4);
imsize = size(mag);

img = mag.*exp(1j*pha);
[nv,np,ns,nrcvrs] = size(img);



% center k-space correction (readout direction)
ks = ifftshift(ifftn(ifftshift(img)));
[MAX,Ind] = max(abs(ks(:)));;
% find maximum readout and phase encoding index
[Inv, Inp, Ins, Ircvrs] = ind2sub([nv,np,ns,nrcvrs],Ind);

% Apply phase ramp
pix = np/2-Inp; % voxel shift
ph_ramp = exp(-sqrt(-1)*2*pi*pix*(-1/2:1/np:1/2-1/np));
pix2 = nv/2-Inv;
ph_ramp2 = exp(-sqrt(-1)*2*pi*pix2*(-1/2:1/nv:1/2-1/nv));
pix3 = ns/2-Ins;
ph_ramp3 = exp(-sqrt(-1)*2*pi*pix3*(-1/2:1/ns:1/2-1/ns));

img_corr = img.* repmat(reshape(ph_ramp,[1 np 1 1]),[nv 1 ns nrcvrs]);
img_corr = img_corr.* repmat(reshape(ph_ramp2,[nv 1 1 1]),[1 np ns nrcvrs]);
img_corr = img_corr.* repmat(reshape(ph_ramp3,[1 1 ns 1]),[nv np 1 nrcvrs]);


