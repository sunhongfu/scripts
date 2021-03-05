% composite magnitude
mag_all = 0;
for i = 1:8
    nii = load_nii(['mag_corr' num2str(i) '.nii']);
    mag = double(nii.img);
    mag_all = mag_all + mag.^2;
end

nii = make_nii(mag_all);
save_nii(nii,'mag_comp.nii')
