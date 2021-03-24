echonum = 8
mag = [];
for i = 1:echonum
    nii = load_nii(['src/mag_corr' num2str(i) '.nii']);
    mag(:,:,:,i) = double(nii.img);
end

TE = [0.0034    0.0069    0.0104    0.0139    0.0174    0.0209    0.0244    0.0279];
vox = [1 1 1];

nii = load_nii('RESHARP/chi_iLSQR_smvrad3.nii');
mask = double(nii.img~=0);

[R2 T2 amp] = r2imgfit2(double(mag),TE,repmat(mask,[1 1 1 echonum]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');