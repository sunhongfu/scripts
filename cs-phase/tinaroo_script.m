load k_full

vox = [1,1,1];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hongfu code

% BEGIN THE QSM RECON PIPELINE
% initial quick brain mask
% simple sum-of-square combination
mag1_sos = sqrt(sum(abs(k_full(:,:,:,1,:)).^2,5));
nii = make_nii(mag1_sos,vox);
save_nii(nii,'mag1_sos.nii');

% unix('N4BiasFieldCorrection -i mag1_sos.nii -o mag1_sos_n4.nii');

unix('bet2 mag1_sos.nii BET -f 0.2 -m');
% set a lower threshold for postmortem
% unix('bet2 mag1_sos.nii BET -f 0.1 -m');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);

% coil combination % smoothing factor 10?
imsize = size(k_full);
TE = 3.4 + [0:7]*3.5;


% (1) if unipolar
[ph_corr,mag_corr] = geme_cmb(k_full,vox,TE,mask,[],0);


% save niftis after coil combination
mkdir('src');
for echo = 1:imsize(4)
    nii = make_nii(mag_corr(:,:,:,echo),vox);
    save_nii(nii,['src/mag_corr' num2str(echo) '.nii']);

    % setenv('echo',num2str(echo));
    % unix('N4BiasFieldCorrection -i src/mag_corr${echo}.nii -o src/mag_corr${echo}_n4.nii');

    nii = make_nii(ph_corr(:,:,:,echo),vox);
    save_nii(nii,['src/ph_corr' num2str(echo) '.nii']);
end
