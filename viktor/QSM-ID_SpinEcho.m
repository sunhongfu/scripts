nii = load_untouch_nii('/Users/uqhsun8/Desktop/RFID_2/ID/SE/PHASE/phase_se_20190926130811_8_ph.nii');
ph = double(nii.img);
vox = nii.hdr.dime.pixdim(2:4);
imsize = size(ph);
% scale ph back to -pi to pi
ph = ph/4095*2*pi - pi;
nii2 = make_nii(ph,vox);
save_nii(nii2,'ph.nii');

% generate the mask by thresholding
clear nii
nii = load_untouch_nii('/Users/uqhsun8/Desktop/RFID_2/ID/SE/MAGN/MAGN_se_20190926130811_5.nii');
mag = double(nii.img);
nii2 = make_nii(mag,vox);
save_nii(nii2,'mag.nii');

mask = ones(imsize);
mask(mag<60) = 0;
% fill in the holes
% mask_filled = MaskFilling(mask, 5);
% nii = make_nii(mask_filled,vox);
% save_nii(nii,'mask_filled.nii');
for i = 1:imsize(3)
    mask(:,:,i) = imfill(squeeze(mask(:,:,i)), 'holes');
end

nii = make_nii(mask,vox);
save_nii(nii,'mask.nii');


% laplacian unwrapping
Options.voxelSize = vox;
iFreq_lap = lapunwrap(ph.*mask, Options);
nii2 = make_nii(iFreq_lap,vox);
save_nii(nii2,'iFreq_lap.nii');

% to scale with TE and field strength
tfs = iFreq_lap/(2.675e8*3*0.08*1e-6);
nii = make_nii(tfs,vox);
save_nii(nii,'tfs.nii');


% iLSQR
chi_iLSQR = QSM_iLSQR(tfs*(2.675e8*3)/1e6,mask,'H',[0 0 1],'voxelsize',vox,'niter',50,'TE',1000,'B0',3);
nii = make_nii(chi_iLSQR,vox);
save_nii(nii,['chi_iLSQR.nii']);

