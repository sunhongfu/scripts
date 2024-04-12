for i = 1:8
    nii = load_nii(['mag' num2str(i) '.nii']);
    mag(:,:,:,i) = single(nii.img);
end


cd ..

nii = load_nii('BET_mask.nii');
mask = logical(nii.img);

mag1 = mag(:,:,:,1);



mean1 = mean(mag1(mask(:)))

real1 = real(mag1);
imag1 = imag(mag1);

real1_n = real1 + 0.01*mean1*randn(size(real1));
imag1_n = imag1 + 0.01*mean1*randn(size(imag1));


comp1_n = real1_n + 1j*imag1_n;
mag1_n = abs(comp1_n);

nii = make_nii(mag1_n);
save_nii(nii,'mag1_n.nii')




mag5 = mag(:,:,:,5);

real5 = real(mag5);
imag5 = imag(mag5);

real5_n = real5 + 0.01*mean1*randn(size(real5));
imag5_n = imag5 + 0.01*mean1*randn(size(imag5));


comp5_n = real5_n + 1j*imag5_n;
mag5_n = abs(comp5_n);

nii = make_nii(mag5_n);
save_nii(nii,'mag5_n.nii')




mag8 = mag(:,:,:,8);

real8 = real(mag8);
imag8 = imag(mag8);

real8_n = real8 + 0.01*mean1*randn(size(real8));
imag8_n = imag8 + 0.01*mean1*randn(size(imag8));


comp8_n = real8_n + 1j*imag8_n;
mag8_n = abs(comp8_n);

nii = make_nii(mag8_n);
save_nii(nii,'mag8_n.nii')

