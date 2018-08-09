

cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/04JG/extension/QSM_MEGE_7T
clear
load('raw.mat','mag_corr','TE','mask','imsize','vox');

[R2 T2 amp] = r2imgfit(double(mag_corr),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');




cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/04JG/flexion/QSM_MEGE_7T
clear
load('raw.mat','mag_corr','TE','mask','imsize','vox');

[R2 T2 amp] = r2imgfit(double(mag_corr),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');


cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/05SG/left/QSM_MEGE_7T
clear
load('raw.mat','mag_corr','TE','mask','imsize','vox');

[R2 T2 amp] = r2imgfit(double(mag_corr),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');



cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/05SG/right/QSM_MEGE_7T
clear
load('raw.mat','mag_corr','TE','mask','imsize','vox');

[R2 T2 amp] = r2imgfit(double(mag_corr),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');




cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/05SG/extension/QSM_MEGE_7T
clear
load('raw.mat','mag_corr','TE','mask','imsize','vox');

[R2 T2 amp] = r2imgfit(double(mag_corr),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');




cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/05SG/flexion/QSM_MEGE_7T
clear
load('raw.mat','mag_corr','TE','mask','imsize','vox');

[R2 T2 amp] = r2imgfit(double(mag_corr),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');


cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/06PS/neutral/QSM_MEGE_7T
clear
load('raw.mat','mag_corr','TE','mask','imsize','vox');

[R2 T2 amp] = r2imgfit(double(mag_corr),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');



cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/06PS/left/QSM_MEGE_7T
clear
load('raw.mat','mag_corr','TE','mask','imsize','vox');

[R2 T2 amp] = r2imgfit(double(mag_corr),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');



cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/06PS/right/QSM_MEGE_7T
clear
load('raw.mat','mag_corr','TE','mask','imsize','vox');

[R2 T2 amp] = r2imgfit(double(mag_corr),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');




cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/06PS/extension/QSM_MEGE_7T
clear
load('raw.mat','mag_corr','TE','mask','imsize','vox');

[R2 T2 amp] = r2imgfit(double(mag_corr),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');




cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/06PS/flexion/QSM_MEGE_7T
clear
load('raw.mat','mag_corr','TE','mask','imsize','vox');

[R2 T2 amp] = r2imgfit(double(mag_corr),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');


