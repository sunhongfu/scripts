
% generate the group average maps for QSM, R2*, from ME-MP2RAGE
% create group average maps
mkdir /home/hongfu/cj97_scratch/hongfu/COSMOS/group/ME-MP2RAGE_0p75

% R2* maps
% 01EG
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,1) = single(nii.img);
mask_to_MNI_all(:,:,:,1) = single(single(nii.img)~=0);


% 02SCOTT
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,2) = single(nii.img);
mask_to_MNI_all(:,:,:,2) = single(single(nii.img)~=0);


% 03JK
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,3) = single(nii.img);
mask_to_MNI_all(:,:,:,3) = single(single(nii.img)~=0);


% 05SG
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,4) = single(nii.img);
mask_to_MNI_all(:,:,:,4) = single(single(nii.img)~=0);


% 07JON 
!gunzip -f /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,5) = single(nii.img);
mask_to_MNI_all(:,:,:,5) = single(single(nii.img)~=0);


% average
R2s_to_MNI_mean = sum(R2s_to_MNI_all,4)./sum(mask_to_MNI_all,4);
R2s_to_MNI_mean(isinf(R2s_to_MNI_mean)) = 0;
R2s_to_MNI_mean(isnan(R2s_to_MNI_mean)) = 0;
nii.img = R2s_to_MNI_mean;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/ME-MP2RAGE_0p75/R2s_to_MNI_mean.nii');

mask_small = mean(mask_to_MNI_all,4);
mask_small(mask_small<1) = 0;

R2s_to_MNI_mean_small = R2s_to_MNI_mean.*mask_small;
nii.img = R2s_to_MNI_mean_small;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/ME-MP2RAGE_0p75/R2s_to_MNI_mean_small.nii');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% MATLAB scripts
% QSM
% O1EG
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,1) = single(nii.img);
mask_to_MNI_all(:,:,:,1) = single(single(nii.img)~=0);

% 02SCOTT
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,2) = single(nii.img);
mask_to_MNI_all(:,:,:,2) = single(single(nii.img)~=0);

% 03JK
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,3) = single(nii.img);
mask_to_MNI_all(:,:,:,3) = single(single(nii.img)~=0);

% 05SG
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,4) = single(nii.img);
mask_to_MNI_all(:,:,:,4) = single(single(nii.img)~=0);

% 07JON 
!gunzip -f /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,5) = single(nii.img);
mask_to_MNI_all(:,:,:,5) = single(single(nii.img)~=0);


% average
QSM_to_MNI_mean = sum(QSM_to_MNI_all,4)./sum(mask_to_MNI_all,4);
QSM_to_MNI_mean(isinf(QSM_to_MNI_mean)) = 0;
QSM_to_MNI_mean(isnan(QSM_to_MNI_mean)) = 0;
nii.img = QSM_to_MNI_mean;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/ME-MP2RAGE_0p75/QSM_to_MNI_mean.nii');

mask_small = mean(mask_to_MNI_all,4);
mask_small(mask_small<1) = 0;

QSM_to_MNI_mean_small = QSM_to_MNI_mean.*mask_small;
nii.img = QSM_to_MNI_mean_small;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/ME-MP2RAGE_0p75/QSM_to_MNI_mean_small.nii');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% MATLAB scripts
% UNIDEN/T1w
% 01EG
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,1) = single(nii.img);
mask_to_MNI_all(:,:,:,1) = single(single(nii.img)~=0);

% 02SCOTT
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,2) = single(nii.img);
mask_to_MNI_all(:,:,:,2) = single(single(nii.img)~=0);

% 03JK
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,3) = single(nii.img);
mask_to_MNI_all(:,:,:,3) = single(single(nii.img)~=0);

% 05SG 
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,4) = single(nii.img);
mask_to_MNI_all(:,:,:,4) = single(single(nii.img)~=0);

% 07JON
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,5) = single(nii.img);
mask_to_MNI_all(:,:,:,5) = single(single(nii.img)~=0);

% average
UNIDEN_to_MNI_mean = sum(UNIDEN_to_MNI_all,4)./sum(mask_to_MNI_all,4);
UNIDEN_to_MNI_mean(isinf(UNIDEN_to_MNI_mean)) = 0;
UNIDEN_to_MNI_mean(isnan(UNIDEN_to_MNI_mean)) = 0;
nii.img = UNIDEN_to_MNI_mean;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/ME-MP2RAGE_0p75/UNIDEN_to_MNI_mean.nii');

mask_small = mean(mask_to_MNI_all,4);
mask_small(mask_small<1) = 0;

UNIDEN_to_MNI_mean_small = UNIDEN_to_MNI_mean.*mask_small;
nii.img = UNIDEN_to_MNI_mean_small;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/ME-MP2RAGE_0p75/UNIDEN_to_MNI_mean_small.nii');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% MATLAB scripts
% T1map
% 01EG
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/T1map/T1m_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/T1map/T1m_to_MNI.nii');
T1M_to_MNI_all(:,:,:,1) = single(nii.img);
mask_to_MNI_all(:,:,:,1) = single(single(nii.img)~=0);

% 02SCOTT
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/T1map/T1m_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/T1map/T1m_to_MNI.nii');
T1M_to_MNI_all(:,:,:,2) = single(nii.img);
mask_to_MNI_all(:,:,:,2) = single(single(nii.img)~=0);

% 03JK
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/T1map/T1m_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/T1map/T1m_to_MNI.nii');
T1M_to_MNI_all(:,:,:,3) = single(nii.img);
mask_to_MNI_all(:,:,:,3) = single(single(nii.img)~=0);

% 05SG 
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/T1map/T1m_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/T1map/T1m_to_MNI.nii');
T1M_to_MNI_all(:,:,:,4) = single(nii.img);
mask_to_MNI_all(:,:,:,4) = single(single(nii.img)~=0);

% 07JON
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/T1map/T1m_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,5) = single(nii.img);
mask_to_MNI_all(:,:,:,5) = single(single(nii.img)~=0);

% average
T1M_to_MNI_mean = sum(T1M_to_MNI_all,4)./sum(mask_to_MNI_all,4);
T1M_to_MNI_mean(isinf(T1M_to_MNI_mean)) = 0;
T1M_to_MNI_mean(isnan(T1M_to_MNI_mean)) = 0;
nii.img = T1M_to_MNI_mean;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/ME-MP2RAGE_0p75/T1M_to_MNI_mean.nii');

mask_small = mean(mask_to_MNI_all,4);
mask_small(mask_small<1) = 0;

T1M_to_MNI_mean_small = T1M_to_MNI_mean.*mask_small;
nii.img = T1M_to_MNI_mean_small;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/ME-MP2RAGE_0p75/T1M_to_MNI_mean_small.nii');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% generate the group average maps for QSM, R2*, from BI-QSM, direct to MNI
% create group average maps
mkdir /home/hongfu/cj97_scratch/hongfu/COSMOS/group/BI-QSM_0p75

% R2* maps
% 01EG
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,1) = single(nii.img);
mask_to_MNI_all(:,:,:,1) = single(single(nii.img)~=0);

% 02SCOTT
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,2) = single(nii.img);
mask_to_MNI_all(:,:,:,2) = single(single(nii.img)~=0);

% 03JK
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,3) = single(nii.img);
mask_to_MNI_all(:,:,:,3) = single(single(nii.img)~=0);

% 05SG
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,4) = single(nii.img);
mask_to_MNI_all(:,:,:,4) = single(single(nii.img)~=0);

% 07JON 
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,5) = single(nii.img);
mask_to_MNI_all(:,:,:,5) = single(single(nii.img)~=0);


% average
R2s_to_MNI_mean = sum(R2s_to_MNI_all,4)./sum(mask_to_MNI_all,4);
R2s_to_MNI_mean(isinf(R2s_to_MNI_mean)) = 0;
R2s_to_MNI_mean(isnan(R2s_to_MNI_mean)) = 0;
nii.img = R2s_to_MNI_mean;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/BI-QSM_0p75/R2s_to_MNI_mean.nii');

mask_small = mean(mask_to_MNI_all,4);
mask_small(mask_small<1) = 0;

R2s_to_MNI_mean_small = R2s_to_MNI_mean.*mask_small;
nii.img = R2s_to_MNI_mean_small;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/BI-QSM_0p75/R2s_to_MNI_mean_small.nii');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% MATLAB scripts
% QSM
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,1) = single(nii.img);
mask_to_MNI_all(:,:,:,1) = single(single(nii.img)~=0);

% 02SCOTT
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,2) = single(nii.img);
mask_to_MNI_all(:,:,:,2) = single(single(nii.img)~=0);

% 03JK
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,3) = single(nii.img);
mask_to_MNI_all(:,:,:,3) = single(single(nii.img)~=0);

% 05SG
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,4) = single(nii.img);
mask_to_MNI_all(:,:,:,4) = single(single(nii.img)~=0);

% 07JON 
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,5) = single(nii.img);
mask_to_MNI_all(:,:,:,5) = single(single(nii.img)~=0);


% average
QSM_to_MNI_mean = sum(QSM_to_MNI_all,4)./sum(mask_to_MNI_all,4);
QSM_to_MNI_mean(isinf(QSM_to_MNI_mean)) = 0;
QSM_to_MNI_mean(isnan(QSM_to_MNI_mean)) = 0;
nii.img = QSM_to_MNI_mean;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/BI-QSM_0p75/QSM_to_MNI_mean.nii');

mask_small = mean(mask_to_MNI_all,4);
mask_small(mask_small<1) = 0;

QSM_to_MNI_mean_small = QSM_to_MNI_mean.*mask_small;
nii.img = QSM_to_MNI_mean_small;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/BI-QSM_0p75/QSM_to_MNI_mean_small.nii');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% generate the group average maps for QSM, R2*, from BI-QSM, to ME-MP2RAGE then to MNI
% create group average maps
mkdir /home/hongfu/cj97_scratch/hongfu/COSMOS/group/BI-QSM_0p75/to_ME-MP2RAGE_to_MNI

% R2* maps
% 01EG
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_bi2memp2rage_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_bi2memp2rage_to_MNI.nii');
R2s_to_MNI_all(:,:,:,1) = single(nii.img);
mask_to_MNI_all(:,:,:,1) = single(single(nii.img)~=0);

% 02SCOTT
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_bi2memp2rage_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_bi2memp2rage_to_MNI.nii');
R2s_to_MNI_all(:,:,:,2) = single(nii.img);
mask_to_MNI_all(:,:,:,2) = single(single(nii.img)~=0);

% 03JK
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_bi2memp2rage_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_bi2memp2rage_to_MNI.nii');
R2s_to_MNI_all(:,:,:,3) = single(nii.img);
mask_to_MNI_all(:,:,:,3) = single(single(nii.img)~=0);

% 05SG
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_bi2memp2rage_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_bi2memp2rage_to_MNI.nii');
R2s_to_MNI_all(:,:,:,4) = single(nii.img);
mask_to_MNI_all(:,:,:,4) = single(single(nii.img)~=0);

% 07JON 
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_bi2memp2rage_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/QSM_MEGE_7T/R2_adj_bi2memp2rage_to_MNI.nii');
R2s_to_MNI_all(:,:,:,5) = single(nii.img);
mask_to_MNI_all(:,:,:,5) = single(single(nii.img)~=0);


% average
R2s_to_MNI_mean = sum(R2s_to_MNI_all,4)./sum(mask_to_MNI_all,4);
R2s_to_MNI_mean(isinf(R2s_to_MNI_mean)) = 0;
R2s_to_MNI_mean(isnan(R2s_to_MNI_mean)) = 0;
nii.img = R2s_to_MNI_mean;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/BI-QSM_0p75/to_ME-MP2RAGE_to_MNI/R2s_to_MNI_mean.nii');

mask_small = mean(mask_to_MNI_all,4);
mask_small(mask_small<1) = 0;

R2s_to_MNI_mean_small = R2s_to_MNI_mean.*mask_small;
nii.img = R2s_to_MNI_mean_small;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/BI-QSM_0p75/to_ME-MP2RAGE_to_MNI/R2s_to_MNI_mean_small.nii');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% MATLAB scripts
% QSM
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii');
QSM_to_MNI_all(:,:,:,1) = single(nii.img);
mask_to_MNI_all(:,:,:,1) = single(single(nii.img)~=0);

% 02SCOTT
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii');
QSM_to_MNI_all(:,:,:,2) = single(nii.img);
mask_to_MNI_all(:,:,:,2) = single(single(nii.img)~=0);

% 03JK
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii');
QSM_to_MNI_all(:,:,:,3) = single(nii.img);
mask_to_MNI_all(:,:,:,3) = single(single(nii.img)~=0);

% 05SG
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii');
QSM_to_MNI_all(:,:,:,4) = single(nii.img);
mask_to_MNI_all(:,:,:,4) = single(single(nii.img)~=0);

% 07JON 
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/BI-QSM_0p75/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_bi2memp2rage_to_MNI.nii');
QSM_to_MNI_all(:,:,:,5) = single(nii.img);
mask_to_MNI_all(:,:,:,5) = single(single(nii.img)~=0);


% average
QSM_to_MNI_mean = sum(QSM_to_MNI_all,4)./sum(mask_to_MNI_all,4);
QSM_to_MNI_mean(isinf(QSM_to_MNI_mean)) = 0;
QSM_to_MNI_mean(isnan(QSM_to_MNI_mean)) = 0;
nii.img = QSM_to_MNI_mean;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/BI-QSM_0p75/to_ME-MP2RAGE_to_MNI/QSM_to_MNI_mean.nii');

mask_small = mean(mask_to_MNI_all,4);
mask_small(mask_small<1) = 0;

QSM_to_MNI_mean_small = QSM_to_MNI_mean.*mask_small;
nii.img = QSM_to_MNI_mean_small;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/BI-QSM_0p75/to_ME-MP2RAGE_to_MNI/QSM_to_MNI_mean_small.nii');








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% generate the group average maps for T1M and UNDEN for SE-MP2RAGE (to ME-MP2RAGE, then to MNI)
mkdir /home/hongfu/cj97_scratch/hongfu/COSMOS/group/SE-MP2RAGE_0p75/to_ME-MP2RAGE_to_MNI

% MATLAB scripts
% UNIDEN
% 01EG
!gunzip -f -f /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32_SE_to_ME_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32_SE_to_ME_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,1) = single(nii.img);
mask_to_MNI_all(:,:,:,1) = single(single(nii.img)~=0);

% 02SCOTT
!gunzip -f -f /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32_SE_to_ME_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32_SE_to_ME_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,2) = single(nii.img);
mask_to_MNI_all(:,:,:,2) = single(single(nii.img)~=0);

% 03JK
!gunzip -f -f /home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32_SE_to_ME_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32_SE_to_ME_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,3) = single(nii.img);
mask_to_MNI_all(:,:,:,3) = single(single(nii.img)~=0);

% 05SG 
!gunzip -f -f /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32_SE_to_ME_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/UNI-DEN/UNIDEN_c32_SE_to_ME_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,4) = single(nii.img);
mask_to_MNI_all(:,:,:,4) = single(single(nii.img)~=0);

% 07JON 
!gunzip -f -f /home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/UNI-DEN/UNIDEN_c32_SE_to_ME_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/UNI-DEN/UNIDEN_c32_SE_to_ME_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,5) = single(nii.img);
mask_to_MNI_all(:,:,:,5) = single(single(nii.img)~=0);

% average
UNIDEN_to_MNI_mean = sum(UNIDEN_to_MNI_all,4)./sum(mask_to_MNI_all,4);
UNIDEN_to_MNI_mean(isinf(UNIDEN_to_MNI_mean)) = 0;
UNIDEN_to_MNI_mean(isnan(UNIDEN_to_MNI_mean)) = 0;
nii.img = UNIDEN_to_MNI_mean;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/SE-MP2RAGE_0p75/to_ME-MP2RAGE_to_MNI/UNIDEN_to_MNI_mean.nii');

mask_small = mean(mask_to_MNI_all,4);
mask_small(mask_small<1) = 0;

UNIDEN_to_MNI_mean_small = UNIDEN_to_MNI_mean.*mask_small;
nii.img = UNIDEN_to_MNI_mean_small;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/SE-MP2RAGE_0p75/to_ME-MP2RAGE_to_MNI/UNIDEN_to_MNI_mean_small.nii');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% MATLAB scripts
% T1map
% 01EG
!gunzip -f -f /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/T1/T1map_c32_SE_to_ME_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/T1/T1map_c32_SE_to_ME_to_MNI.nii');
T1M_to_MNI_all(:,:,:,1) = single(nii.img);
mask_to_MNI_all(:,:,:,1) = single(single(nii.img)~=0);

% 02SCOTT
!gunzip -f -f /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/T1/T1map_c32_SE_to_ME_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/T1/T1map_c32_SE_to_ME_to_MNI.nii');
T1M_to_MNI_all(:,:,:,2) = single(nii.img);
mask_to_MNI_all(:,:,:,2) = single(single(nii.img)~=0);

% 03JK
!gunzip -f -f /home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/T1/T1map_c32_SE_to_ME_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/T1/T1map_c32_SE_to_ME_to_MNI.nii');
T1M_to_MNI_all(:,:,:,3) = single(nii.img);
mask_to_MNI_all(:,:,:,3) = single(single(nii.img)~=0);

% 05SG 
!gunzip -f -f /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/T1/T1map_c32_SE_to_ME_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/T1/T1map_c32_SE_to_ME_to_MNI.nii');
T1M_to_MNI_all(:,:,:,4) = single(nii.img);
mask_to_MNI_all(:,:,:,4) = single(single(nii.img)~=0);

% 07JON 
!gunzip -f -f /home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/T1/T1map_c32_SE_to_ME_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/T1/T1map_c32_SE_to_ME_to_MNI.nii');
T1M_to_MNI_all(:,:,:,5) = single(nii.img);
mask_to_MNI_all(:,:,:,5) = single(single(nii.img)~=0);


% average
T1M_to_MNI_mean = sum(T1M_to_MNI_all,4)./sum(mask_to_MNI_all,4);
T1M_to_MNI_mean(isinf(T1M_to_MNI_mean)) = 0;
T1M_to_MNI_mean(isnan(T1M_to_MNI_mean)) = 0;
nii.img = T1M_to_MNI_mean;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/SE-MP2RAGE_0p75/to_ME-MP2RAGE_to_MNI/T1M_to_MNI_mean.nii');

mask_small = mean(mask_to_MNI_all,4);
mask_small(mask_small<1) = 0;

T1M_to_MNI_mean_small = T1M_to_MNI_mean.*mask_small;
nii.img = T1M_to_MNI_mean_small;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/SE-MP2RAGE_0p75/to_ME-MP2RAGE_to_MNI/T1M_to_MNI_mean_small.nii');






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% generate the group average maps for T1M and UNDEN for SE-MP2RAGE (dicrect to MNI)
mkdir /home/hongfu/cj97_scratch/hongfu/COSMOS/group/SE-MP2RAGE_0p75

% MATLAB scripts
% UNIDEN
% 01EG
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/UNI-DEN/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/UNI-DEN/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,1) = single(nii.img);
mask_to_MNI_all(:,:,:,1) = single(single(nii.img)~=0);

% 02SCOTT
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/UNI-DEN/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/UNI-DEN/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,2) = single(nii.img);
mask_to_MNI_all(:,:,:,2) = single(single(nii.img)~=0);

% 03JK
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/UNI-DEN/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/UNI-DEN/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,3) = single(nii.img);
mask_to_MNI_all(:,:,:,3) = single(single(nii.img)~=0);

% 05SG 
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/UNI-DEN/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/UNI-DEN/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,4) = single(nii.img);
mask_to_MNI_all(:,:,:,4) = single(single(nii.img)~=0);

% 07JON 
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/UNI-DEN/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/UNI-DEN/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,5) = single(nii.img);
mask_to_MNI_all(:,:,:,5) = single(single(nii.img)~=0);

% average
UNIDEN_to_MNI_mean = sum(UNIDEN_to_MNI_all,4)./sum(mask_to_MNI_all,4);
UNIDEN_to_MNI_mean(isinf(UNIDEN_to_MNI_mean)) = 0;
UNIDEN_to_MNI_mean(isnan(UNIDEN_to_MNI_mean)) = 0;
nii.img = UNIDEN_to_MNI_mean;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/SE-MP2RAGE_0p75/UNIDEN_to_MNI_mean.nii');

mask_small = mean(mask_to_MNI_all,4);
mask_small(mask_small<1) = 0;

UNIDEN_to_MNI_mean_small = UNIDEN_to_MNI_mean.*mask_small;
nii.img = UNIDEN_to_MNI_mean_small;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/SE-MP2RAGE_0p75/UNIDEN_to_MNI_mean_small.nii');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% MATLAB scripts
% T1map
% 01EG
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/T1/T1map_c32_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/SE-MP2RAGE_0p75/T1/T1map_c32_to_MNI.nii');
T1M_to_MNI_all(:,:,:,1) = single(nii.img);
mask_to_MNI_all(:,:,:,1) = single(single(nii.img)~=0);

% 02SCOTT
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/T1/T1map_c32_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/SE-MP2RAGE_0p75/T1/T1map_c32_to_MNI.nii');
T1M_to_MNI_all(:,:,:,2) = single(nii.img);
mask_to_MNI_all(:,:,:,2) = single(single(nii.img)~=0);

% 03JK
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/T1/T1map_c32_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/SE-MP2RAGE_0p75/T1/T1map_c32_to_MNI.nii');
T1M_to_MNI_all(:,:,:,3) = single(nii.img);
mask_to_MNI_all(:,:,:,3) = single(single(nii.img)~=0);

% 05SG 
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/T1/T1map_c32_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/SE-MP2RAGE_0p75/T1/T1map_c32_to_MNI.nii');
T1M_to_MNI_all(:,:,:,4) = single(nii.img);
mask_to_MNI_all(:,:,:,4) = single(single(nii.img)~=0);

% 07JON 
!gunzip -f /home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/T1/T1map_c32_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/07JON/1.7.72.6/1.7.72.6.1.1/SE-MP2RAGE_0p9/T1/T1map_c32_to_MNI.nii');
T1M_to_MNI_all(:,:,:,5) = single(nii.img);
mask_to_MNI_all(:,:,:,5) = single(single(nii.img)~=0);


% average
T1M_to_MNI_mean = sum(T1M_to_MNI_all,4)./sum(mask_to_MNI_all,4);
T1M_to_MNI_mean(isinf(T1M_to_MNI_mean)) = 0;
T1M_to_MNI_mean(isnan(T1M_to_MNI_mean)) = 0;
nii.img = T1M_to_MNI_mean;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/SE-MP2RAGE_0p75/T1M_to_MNI_mean.nii');

mask_small = mean(mask_to_MNI_all,4);
mask_small(mask_small<1) = 0;

T1M_to_MNI_mean_small = T1M_to_MNI_mean.*mask_small;
nii.img = T1M_to_MNI_mean_small;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/COSMOS/group/SE-MP2RAGE_0p75/T1M_to_MNI_mean_small.nii');


