load('k_full.mat');
vox = [1,1,1];
mag_sos = sqrt(sum(abs(k_full).^2,5)/size(k_full,5));
nii = make_nii(mag_sos,vox);
save_nii(nii,'mag_sos.nii');

nii = make_nii(abs(k_full(:,:,:,1,:)),vox);
save_nii(nii,'mag1_all.nii');


sen = squeeze(abs(k_full(:,:,:,1,:)))./repmat(mag_sos(:,:,:,1),[1 1 1 size(k_full,5)]);
nii = make_nii(sen,vox);
save_nii(nii,'sen_mag_raw.nii');


% smooth the coil sensitivity
for chan = 1:size(k_full,5) 
    sen_smooth(:,:,:,chan) = smooth3(sen(:,:,:,chan),'box',round(8./vox)*2+1); 
end

nii = make_nii(sen_smooth,vox);
save_nii(nii,'sen_mag_smooth.nii');



% sen correction
mag_corr_individual = abs(k_full)./permute(repmat(sen_smooth,[1 1 1 1 8]),[1 2 3 5 4]);

nii = make_nii(mag_corr_individual(:,:,:,1,:),vox);
save_nii(nii,'mag_corr_individual_e1.nii')
