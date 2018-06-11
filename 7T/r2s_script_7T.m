cd /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T

clear

% T2* mapping recon using Marc Label codes
load('raw.mat','mag_all_sos','TE','mask','imsize','vox');

[R2_I1 T2_I1 amp_I1] = r2imgfit(double(mag_all_sos(:,:,:,:,1)),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2_I1,vox);
save_nii(nii,'R2_I1.nii');
nii = make_nii(T2_I1,vox);
save_nii(nii,'T2_I1.nii');
nii = make_nii(amp_I1,vox);
save_nii(nii,'amp_I1.nii');

[R2_I2 T2_I2 amp_I2] = r2imgfit(double(mag_all_sos(:,:,:,:,2)),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2_I2,vox);
save_nii(nii,'R2_I2.nii');
nii = make_nii(T2_I2,vox);
save_nii(nii,'T2_I2.nii');
nii = make_nii(amp_I2,vox);
save_nii(nii,'amp_I2.nii');



cd /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T

clear

% T2* mapping recon using Marc Label codes
load('raw.mat','mag_all_sos','TE','mask','imsize','vox');

[R2_I1 T2_I1 amp_I1] = r2imgfit(double(mag_all_sos(:,:,:,:,1)),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2_I1,vox);
save_nii(nii,'R2_I1.nii');
nii = make_nii(T2_I1,vox);
save_nii(nii,'T2_I1.nii');
nii = make_nii(amp_I1,vox);
save_nii(nii,'amp_I1.nii');

[R2_I2 T2_I2 amp_I2] = r2imgfit(double(mag_all_sos(:,:,:,:,2)),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2_I2,vox);
save_nii(nii,'R2_I2.nii');
nii = make_nii(T2_I2,vox);
save_nii(nii,'T2_I2.nii');
nii = make_nii(amp_I2,vox);
save_nii(nii,'amp_I2.nii');




cd /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T

clear

% T2* mapping recon using Marc Label codes
load('raw.mat','mag_all_sos','TE','mask','imsize','vox');

[R2_I1 T2_I1 amp_I1] = r2imgfit(double(mag_all_sos(:,:,:,:,1)),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2_I1,vox);
save_nii(nii,'R2_I1.nii');
nii = make_nii(T2_I1,vox);
save_nii(nii,'T2_I1.nii');
nii = make_nii(amp_I1,vox);
save_nii(nii,'amp_I1.nii');

[R2_I2 T2_I2 amp_I2] = r2imgfit(double(mag_all_sos(:,:,:,:,2)),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2_I2,vox);
save_nii(nii,'R2_I2.nii');
nii = make_nii(T2_I2,vox);
save_nii(nii,'T2_I2.nii');
nii = make_nii(amp_I2,vox);
save_nii(nii,'amp_I2.nii');




cd /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/QSM_MEMP2RAGE_7T

clear

% T2* mapping recon using Marc Label codes
load('raw.mat','mag_all_sos','TE','mask','imsize','vox');

[R2_I1 T2_I1 amp_I1] = r2imgfit(double(mag_all_sos(:,:,:,:,1)),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2_I1,vox);
save_nii(nii,'R2_I1.nii');
nii = make_nii(T2_I1,vox);
save_nii(nii,'T2_I1.nii');
nii = make_nii(amp_I1,vox);
save_nii(nii,'amp_I1.nii');

[R2_I2 T2_I2 amp_I2] = r2imgfit(double(mag_all_sos(:,:,:,:,2)),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2_I2,vox);
save_nii(nii,'R2_I2.nii');
nii = make_nii(T2_I2,vox);
save_nii(nii,'T2_I2.nii');
nii = make_nii(amp_I2,vox);
save_nii(nii,'amp_I2.nii');




cd /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T

clear

% T2* mapping recon using Marc Label codes
load('raw.mat','mag_all_sos','TE','mask','imsize','vox');

[R2_I1 T2_I1 amp_I1] = r2imgfit(double(mag_all_sos(:,:,:,:,1)),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2_I1,vox);
save_nii(nii,'R2_I1.nii');
nii = make_nii(T2_I1,vox);
save_nii(nii,'T2_I1.nii');
nii = make_nii(amp_I1,vox);
save_nii(nii,'amp_I1.nii');

[R2_I2 T2_I2 amp_I2] = r2imgfit(double(mag_all_sos(:,:,:,:,2)),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2_I2,vox);
save_nii(nii,'R2_I2.nii');
nii = make_nii(T2_I2,vox);
save_nii(nii,'T2_I2.nii');
nii = make_nii(amp_I2,vox);
save_nii(nii,'amp_I2.nii');






cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/07JON/left/QSM_MEGE_7T
clear
load('raw.mat','mag_corr','TE','mask','imsize','vox');

[R2 T2 amp] = r2imgfit(double(mag_corr),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');



cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/07JON/right/QSM_MEGE_7T
clear
load('raw.mat','mag_corr','TE','mask','imsize','vox');

[R2 T2 amp] = r2imgfit(double(mag_corr),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');




cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/07JON/extension/QSM_MEGE_7T
clear
load('raw.mat','mag_corr','TE','mask','imsize','vox');

[R2 T2 amp] = r2imgfit(double(mag_corr),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');




cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/07JON/flexion/QSM_MEGE_7T
clear
load('raw.mat','mag_corr','TE','mask','imsize','vox');

[R2 T2 amp] = r2imgfit(double(mag_corr),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');


