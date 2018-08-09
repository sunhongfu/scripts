% load 4D T1 maps
!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/T1map/*.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/T1map/20170228_124116mp2rage0p75mmisoBipolarPloss040a1001.nii');
t1_all = single(nii.img);


% load BET_mask
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/BET_mask_adj.nii');
mask = single(nii.img);


t1_te1 = t1_all(:,:,:,1).*mask;
t1_te2 = t1_all(:,:,:,2).*mask;
t1_te3 = t1_all(:,:,:,3).*mask;
t1_te4 = t1_all(:,:,:,4).*mask;

% average t1 from 4 echoes
t1_ave = mean(t1_all,4).*mask;
nii.img = t1_ave;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/T1map/t1_ave.nii');
t1_sos = sqrt(sum(t1_all.^2,4)).*mask/2;
nii.img = t1_sos;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/T1map/t1_sos.nii');
nii.img = t1_te1;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/T1map/t1_te1.nii');
nii.img = t1_te2;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/T1map/t1_te2.nii');
nii.img = t1_te3;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/T1map/t1_te3.nii');
nii.img = t1_te4;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/01_VM_H257/T1map/t1_te4.nii');



% load 4D T1 maps
!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/T1map/*.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/T1map/20170927_105246mp2rage0p75BiPlos4TEVariedBWtx220s006a1001.nii');
t1_all = single(nii.img);


% load BET_mask
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T/BET_mask_adj.nii');
mask = single(nii.img);


t1_te1 = t1_all(:,:,:,1).*mask;
t1_te2 = t1_all(:,:,:,2).*mask;
t1_te3 = t1_all(:,:,:,3).*mask;
t1_te4 = t1_all(:,:,:,4).*mask;

% average t1 from 4 echoes
t1_ave = mean(t1_all,4).*mask;
nii.img = t1_ave;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/T1map/t1_ave.nii');
t1_sos = sqrt(sum(t1_all.^2,4)).*mask/2;
nii.img = t1_sos;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/T1map/t1_sos.nii');
nii.img = t1_te1;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/T1map/t1_te1.nii');
nii.img = t1_te2;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/T1map/t1_te2.nii');
nii.img = t1_te3;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/T1map/t1_te3.nii');
nii.img = t1_te4;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/02_JF_H446/T1map/t1_te4.nii');




% load 4D T1 maps
!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/T1map/*.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/T1map/20170927_141928mp2rage0p75BiPlos4TEVariedBWtx213s007a1001.nii');
t1_all = single(nii.img);


% load BET_mask
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/BET_mask_adj.nii');
mask = single(nii.img);


t1_te1 = t1_all(:,:,:,1).*mask;
t1_te2 = t1_all(:,:,:,2).*mask;
t1_te3 = t1_all(:,:,:,3).*mask;
t1_te4 = t1_all(:,:,:,4).*mask;

% average t1 from 4 echoes
t1_ave = mean(t1_all,4).*mask;
nii.img = t1_ave;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/T1map/t1_ave.nii');
t1_sos = sqrt(sum(t1_all.^2,4)).*mask/2;
nii.img = t1_sos;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/T1map/t1_sos.nii');
nii.img = t1_te1;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/T1map/t1_te1.nii');
nii.img = t1_te2;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/T1map/t1_te2.nii');
nii.img = t1_te3;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/T1map/t1_te3.nii');
nii.img = t1_te4;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/03_MP_H447/T1map/t1_te4.nii');




% load 4D T1 maps
!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/T1map/*.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/T1map/20171004_135402mp2rage0p75BiPlos4TEVariedBWs009a1001.nii');
t1_all = single(nii.img);


% load BET_mask
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/QSM_MEMP2RAGE_7T/BET_mask_adj.nii');
mask = single(nii.img);


t1_te1 = t1_all(:,:,:,1).*mask;
t1_te2 = t1_all(:,:,:,2).*mask;
t1_te3 = t1_all(:,:,:,3).*mask;
t1_te4 = t1_all(:,:,:,4).*mask;

% average t1 from 4 echoes
t1_ave = mean(t1_all,4).*mask;
nii.img = t1_ave;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/T1map/t1_ave.nii');
t1_sos = sqrt(sum(t1_all.^2,4)).*mask/2;
nii.img = t1_sos;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/T1map/t1_sos.nii');
nii.img = t1_te1;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/T1map/t1_te1.nii');
nii.img = t1_te2;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/T1map/t1_te2.nii');
nii.img = t1_te3;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/T1map/t1_te3.nii');
nii.img = t1_te4;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/04_BH_451/T1map/t1_te4.nii');




% load 4D T1 maps
!gunzip /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/T1map/*.nii.gz
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/T1map/20171031_141844mp2rage0p75BiPlos4TEVariedBWtx220s008a1001.nii');
t1_all = single(nii.img);


% load BET_mask
nii = load_untouch_nii('/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/BET_mask_adj.nii');
mask = single(nii.img);


t1_te1 = t1_all(:,:,:,1).*mask;
t1_te2 = t1_all(:,:,:,2).*mask;
t1_te3 = t1_all(:,:,:,3).*mask;
t1_te4 = t1_all(:,:,:,4).*mask;

% average t1 from 4 echoes
t1_ave = mean(t1_all,4).*mask;
nii.img = t1_ave;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/T1map/t1_ave.nii');
t1_sos = sqrt(sum(t1_all.^2,4)).*mask/2;
nii.img = t1_sos;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/T1map/t1_sos.nii');
nii.img = t1_te1;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/T1map/t1_te1.nii');
nii.img = t1_te2;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/T1map/t1_te2.nii');
nii.img = t1_te3;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/T1map/t1_te3.nii');
nii.img = t1_te4;
save_untouch_nii(nii,'/gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/T1map/t1_te4.nii');


