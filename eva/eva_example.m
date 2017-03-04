%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load in the data
load vol_nlm.mat
mag = double(vol_nlm);
% flip dim
mag = flipdim(mag,2);
vox = hdr_nlm.info.voxel_size;

nii = make_nii(mag,vox);
save_nii(nii,'mag.nii');

load vol.mat
ph = double(vol/4096*pi);
ph = flipdim(ph,2);

nii = make_nii(ph,vox);
save_nii(nii,'ph.nii');

TE1= 2.4;
ES = 1.2;

TE = TE1 + (0:63)*ES;
TE = TE/1000;
imsize = size(mag);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% save magnitude and raw phase niftis for each echo
mkdir('src')
for echo = 1:imsize(4)
    nii = make_nii(mag(:,:,:,echo),vox);
    save_nii(nii,['src/mag' num2str(echo) '.nii']);
    nii = make_nii(ph(:,:,:,echo),vox);
    save_nii(nii,['src/ph' num2str(echo) '.nii']);
end

bet_smooth = 2;
bet_thr = 0.4;
% brain extraction
% generate mask from magnitude of the 1th echo
disp('--> extract brain volume and generate mask ...');
setenv('bet_thr',num2str(bet_thr));
setenv('bet_smooth',num2str(bet_smooth));
[status,cmdout] = unix('rm BET*');
unix('bet2 src/mag1.nii BET -f ${bet_thr} -m -w ${bet_smooth}');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
readout = 'bipolar'
% phase offset correction
% if unipolar
if strcmpi('unipolar',readout)
    ph_corr = geme_cmb(mag.*exp(1j*ph),vox,TE);
% if bipolar
elseif strcmpi('bipolar',readout)
    ph_corr = zeros(imsize);
    ph_corr(:,:,:,1:2:end) = geme_cmb(mag(:,:,:,1:2:end).*exp(1j*ph(:,:,:,1:2:end)),vox,TE(1:2:end),mask);
    ph_corr(:,:,:,2:2:end) = geme_cmb(mag(:,:,:,2:2:end).*exp(1j*ph(:,:,:,2:2:end)),vox,TE(2:2:end),mask);
else
    error('is the sequence unipolar or bipolar readout?')
end

% save offset corrected phase niftis
for echo = 1:imsize(4)
    nii = make_nii(ph_corr(:,:,:,echo),vox);
    save_nii(nii,['src/ph_corr' num2str(echo) '.nii']);
end
