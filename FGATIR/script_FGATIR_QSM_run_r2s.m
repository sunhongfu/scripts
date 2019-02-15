clear
cd /media/data/FGATIR/sorted/qMRIms_022/QSM_SPGR_GE
load('all.mat','mag','TE','mask','imsize','vox');
[R2 T2 amp] = r2imgfit2(double(mag),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');


clear
cd /media/data/FGATIR/sorted/physio_05003/QSM_SPGR_GE
load('all.mat','mag','TE','mask','imsize','vox');
[R2 T2 amp] = r2imgfit2(double(mag),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');



clear
cd '/media/data/FGATIR/sorted/Js/Unnamed - 14902/QSM_p75/QSM_SPGR_GE'
load('all.mat','mag','TE','mask','imsize','vox');
[R2 T2 amp] = r2imgfit2(double(mag),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');




clear
cd '/media/data/FGATIR/sorted/Hs/Unnamed - 14903/QSM_p75/QSM_SPGR_GE'
load('all.mat','mag','TE','mask','imsize','vox');
[R2 T2 amp] = r2imgfit2(double(mag),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');


clear
cd '/media/data/FGATIR/2018_09_19_Physio_03016/Development - 14754/QSM_bestpath/QSM_SPGR_GE'
load('all.mat','mag','TE','mask','imsize','vox');
[R2 T2 amp] = r2imgfit2(double(mag),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');


clear
cd '/media/data/FGATIR/physio_03017-14792/QSM_p75mm/QSM_SPGR_GE/'
load('all.mat','mag','TE','mask','imsize','vox');
[R2 T2 amp] = r2imgfit2(double(mag),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');

