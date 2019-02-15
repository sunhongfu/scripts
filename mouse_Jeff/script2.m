
clear
cd /media/pikelab/Hongfu/side_projects/mouse/NPCisUSPIOQSM/Yong-AC13-0272-422.Jg1/7
load('raw.mat','mag','TE','imsize','voxel_size');
nii = load_nii('QSM_new/mask_thr.nii');
mask = double(nii.img);
mkdir r2star
cd r2star
[R2 T2 amp] = r2imgfit2(double(mag),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,voxel_size);
save_nii(nii,'R2.nii');
nii = make_nii(T2,voxel_size);
save_nii(nii,'T2.nii');
nii = make_nii(amp,voxel_size);
save_nii(nii,'amp.nii');



clear
cd /media/pikelab/Hongfu/side_projects/mouse/NPCisUSPIOQSM/Yong-AC13-0272.429.Jg1/7
load('raw.mat','mag','TE','imsize','voxel_size');
nii = load_nii('QSM_new/mask_thr.nii');
mask = double(nii.img);
mkdir r2star
cd r2star
[R2 T2 amp] = r2imgfit2(double(mag),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,voxel_size);
save_nii(nii,'R2.nii');
nii = make_nii(T2,voxel_size);
save_nii(nii,'T2.nii');
nii = make_nii(amp,voxel_size);
save_nii(nii,'amp.nii');



clear
cd /media/pikelab/Hongfu/side_projects/mouse/NPCisUSPIOQSM/Yong-AC13-0272-426.Jg1/7
load('raw.mat','mag','TE','imsize','voxel_size');
nii = load_nii('QSM_new/mask_thr.nii');
mask = double(nii.img);
mkdir r2star
cd r2star
[R2 T2 amp] = r2imgfit2(double(mag),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,voxel_size);
save_nii(nii,'R2.nii');
nii = make_nii(T2,voxel_size);
save_nii(nii,'T2.nii');
nii = make_nii(amp,voxel_size);
save_nii(nii,'amp.nii');



clear
cd /media/pikelab/Hongfu/side_projects/mouse/NPCisUSPIOQSM/Yong-AC13-0272.434.Jg1/7
load('raw.mat','mag','TE','imsize','voxel_size');
nii = load_nii('QSM_new/mask_thr.nii');
mask = double(nii.img);
mkdir r2star
cd r2star
[R2 T2 amp] = r2imgfit2(double(mag),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,voxel_size);
save_nii(nii,'R2.nii');
nii = make_nii(T2,voxel_size);
save_nii(nii,'T2.nii');
nii = make_nii(amp,voxel_size);
save_nii(nii,'amp.nii');



clear
cd /media/pikelab/Hongfu/side_projects/mouse/NPCisUSPIOQSM/Yong-AC13-0272.442.Jh1/6
load('raw.mat','mag','TE','imsize','voxel_size');
nii = load_nii('QSM_new/mask_thr.nii');
mask = double(nii.img);
mkdir r2star
cd r2star
[R2 T2 amp] = r2imgfit2(double(mag),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,voxel_size);
save_nii(nii,'R2.nii');
nii = make_nii(T2,voxel_size);
save_nii(nii,'T2.nii');
nii = make_nii(amp,voxel_size);
save_nii(nii,'amp.nii');



clear
cd /media/pikelab/Hongfu/side_projects/mouse/NPCisUSPIOQSM/Yong-AC13-0272.437.Jh1/6
load('raw.mat','mag','TE','imsize','voxel_size');
nii = load_nii('QSM_new/mask_thr.nii');
mask = double(nii.img);
mkdir r2star
cd r2star
[R2 T2 amp] = r2imgfit2(double(mag),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,voxel_size);
save_nii(nii,'R2.nii');
nii = make_nii(T2,voxel_size);
save_nii(nii,'T2.nii');
nii = make_nii(amp,voxel_size);
save_nii(nii,'amp.nii');



clear
cd /media/pikelab/Hongfu/side_projects/mouse/NPCisUSPIOQSM/Yong-AC13-0272.441.Jh1/6
load('raw.mat','mag','TE','imsize','voxel_size');
nii = load_nii('QSM_new/mask_thr.nii');
mask = double(nii.img);
mkdir r2star
cd r2star
[R2 T2 amp] = r2imgfit2(double(mag),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,voxel_size);
save_nii(nii,'R2.nii');
nii = make_nii(T2,voxel_size);
save_nii(nii,'T2.nii');
nii = make_nii(amp,voxel_size);
save_nii(nii,'amp.nii');



clear
cd /media/pikelab/Hongfu/side_projects/mouse/NPCisUSPIOQSM/Yong-AC13-0272-424.Jg1/7
load('raw.mat','mag','TE','imsize','voxel_size');
nii = load_nii('QSM_new/mask_thr.nii');
mask = double(nii.img);
mkdir r2star
cd r2star
[R2 T2 amp] = r2imgfit2(double(mag),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,voxel_size);
save_nii(nii,'R2.nii');
nii = make_nii(T2,voxel_size);
save_nii(nii,'T2.nii');
nii = make_nii(amp,voxel_size);
save_nii(nii,'amp.nii');



clear
cd /media/pikelab/Hongfu/side_projects/mouse/NPCisUSPIOQSM/Yong-AC13-0272.423.Jg1/7
load('raw.mat','mag','TE','imsize','voxel_size');
nii = load_nii('QSM_new/mask_thr.nii');
mask = double(nii.img);
mkdir r2star
cd r2star
[R2 T2 amp] = r2imgfit2(double(mag),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,voxel_size);
save_nii(nii,'R2.nii');
nii = make_nii(T2,voxel_size);
save_nii(nii,'T2.nii');
nii = make_nii(amp,voxel_size);
save_nii(nii,'amp.nii');



clear
cd /media/pikelab/Hongfu/side_projects/mouse/NPCisUSPIOQSM/Yong-AC13-0272.435.Jg1/7
load('raw.mat','mag','TE','imsize','voxel_size');
nii = load_nii('QSM_new/mask_thr.nii');
mask = double(nii.img);
mkdir r2star
cd r2star
[R2 T2 amp] = r2imgfit2(double(mag),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,voxel_size);
save_nii(nii,'R2.nii');
nii = make_nii(T2,voxel_size);
save_nii(nii,'T2.nii');
nii = make_nii(amp,voxel_size);
