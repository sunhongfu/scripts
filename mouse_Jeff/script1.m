
clear
cd /media/pikelab/Hongfu/side_projects/mouse/NPCisUSPIOQSM/Yong-AC13-0272.431.Jg1/7
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
cd /media/pikelab/Hongfu/side_projects/mouse/NPCisUSPIOQSM/Yong-AC13-0272.432.Jg1/7
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
cd /media/pikelab/Hongfu/side_projects/mouse/NPCisUSPIOQSM/Yong-AC13-0272.430.Jg1/7
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
cd /media/pikelab/Hongfu/side_projects/mouse/NPCisUSPIOQSM/Yong-AC13-0272.444.Jh1/6
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
cd /media/pikelab/Hongfu/side_projects/mouse/NPCisUSPIOQSM/Yong-AC13-0272.443.Jh1/6
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
cd /media/pikelab/Hongfu/side_projects/mouse/NPCisUSPIOQSM/Yong-AC13-0272.448.Jh1/6
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
cd /media/pikelab/Hongfu/side_projects/mouse/NPCisUSPIOQSM/Yong-AC13-0272.436.Jg1/7
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
cd /media/pikelab/Hongfu/side_projects/mouse/NPCisUSPIOQSM/Yong-AC13-0272.447.Jh1/6
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
cd /media/pikelab/Hongfu/side_projects/mouse/NPCisUSPIOQSM/Yong-AC13-0272-425.Jg1/7
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
cd /media/pikelab/Hongfu/side_projects/mouse/NPCisUSPIOQSM/Yong-AC13-0272.439.Jh1/6
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


