
nii = load_nii('/Volumes/LaCie_Bottom/MEMP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/tfs_0.nii');
B0 = double(nii.img);
B0 = permute(B0,[2 1 3]);

B0_mod = B0;
B0_mod = B0_mod*100;
B0_mod(B0_mod>100) = 100;

mask = ones(size(B0));
mask(B0==0) = 0;


nii = load_nii('/Volumes/LaCie_Bottom/MEMP2RAGE/05_JON_H476/T1map/t1_ave.nii');
T1 = double(nii.img);
T1 = flip(flip(T1,1),2);
T1 = permute(T1,[2 1 3]);

T1_mod = T1;
T1_mod(T1_mod>4000) = 4000;
T1_mod = T1_mod.*mask;


nii = load_nii('/Volumes/LaCie_Bottom/MEMP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/T2_I2.nii');
T2 = double(nii.img);
T2 = permute(T2,[2 1 3]);

T2_mod = T2;
T2_mod(T2_mod>0.1) = 0.1;
T2_mod = smooth3(T2_mod);
T2_mod = T2_mod*2000;
T2_mod = T2_mod.*mask;


% choose a single slice
T1map = T1_mod(:,:,90);
T2map = T2_mod(:,:,90);
B0map = B0_mod(:,:,90);
maskmap = mask(:,:,90);

subplot(1,4,1); imagesc(T1map); colormap hot; title 'T1 map';
subplot(1,4,2); imagesc(T2map); colormap hot; title 'T2 map';
subplot(1,4,3); imagesc(B0map); colormap hot; title 'B0 map';
subplot(1,4,4); imagesc(maskmap);
