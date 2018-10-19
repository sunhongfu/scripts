
% generate the group average maps for QSM, T1, R2*
% create group average maps
mkdir /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/group

% MATLAB scripts
% R2* maps
!gunzip /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,1) = single(nii.img);
mask_to_MNI_all(:,:,:,1) = single(single(nii.img)~=0);

!gunzip /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,2) = single(nii.img);
mask_to_MNI_all(:,:,:,2) = single(single(nii.img)~=0);

!gunzip /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,3) = single(nii.img);
mask_to_MNI_all(:,:,:,3) = single(single(nii.img)~=0);

!gunzip /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/04_BH_H451/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/04_BH_H451/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,4) = single(nii.img);
mask_to_MNI_all(:,:,:,4) = single(single(nii.img)~=0);

!gunzip /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/R2_I2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,5) = single(nii.img);
mask_to_MNI_all(:,:,:,5) = single(single(nii.img)~=0);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 01EG
!gunzip /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,6) = single(nii.img);
mask_to_MNI_all(:,:,:,6) = single(single(nii.img)~=0);


% 02SCOTT
!gunzip /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,7) = single(nii.img);
mask_to_MNI_all(:,:,:,7) = single(single(nii.img)~=0);


% 03JK
!gunzip /home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,8) = single(nii.img);
mask_to_MNI_all(:,:,:,8) = single(single(nii.img)~=0);


% 05SG
!gunzip /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/R2_adj_to_MNI.nii');
R2s_to_MNI_all(:,:,:,9) = single(nii.img);
mask_to_MNI_all(:,:,:,9) = single(single(nii.img)~=0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

R2s_to_MNI_mean = sum(R2s_to_MNI_all,4)./sum(mask_to_MNI_all,4);
R2s_to_MNI_mean(isinf(R2s_to_MNI_mean)) = 0;
R2s_to_MNI_mean(isnan(R2s_to_MNI_mean)) = 0;
nii.img = R2s_to_MNI_mean;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/group/R2s_to_MNI_mean.nii');

mask_small = mean(mask_to_MNI_all,4);
mask_small(mask_small<1) = 0;

R2s_to_MNI_mean_small = R2s_to_MNI_mean.*mask_small;
nii.img = R2s_to_MNI_mean_small;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/group/R2s_to_MNI_mean_small.nii');






% MATLAB scripts
% QSM
mkdir /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/group

!gunzip /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,1) = single(nii.img);
mask_to_MNI_all(:,:,:,1) = single(single(nii.img)~=0);

!gunzip /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,2) = single(nii.img);
mask_to_MNI_all(:,:,:,2) = single(single(nii.img)~=0);

!gunzip /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,3) = single(nii.img);
mask_to_MNI_all(:,:,:,3) = single(single(nii.img)~=0);

!gunzip /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/04_BH_H451/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/04_BH_H451/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,4) = single(nii.img);
mask_to_MNI_all(:,:,:,4) = single(single(nii.img)~=0);

!gunzip /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,5) = single(nii.img);
mask_to_MNI_all(:,:,:,5) = single(single(nii.img)~=0);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% O1EG
!gunzip /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,6) = single(nii.img);
mask_to_MNI_all(:,:,:,6) = single(single(nii.img)~=0);

% 02SCOTT
!gunzip /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,7) = single(nii.img);
mask_to_MNI_all(:,:,:,7) = single(single(nii.img)~=0);

% 03JK
!gunzip /home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,8) = single(nii.img);
mask_to_MNI_all(:,:,:,8) = single(single(nii.img)~=0);

% 05SG
!gunzip /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_adj_to_MNI.nii');
QSM_to_MNI_all(:,:,:,9) = single(nii.img);
mask_to_MNI_all(:,:,:,9) = single(single(nii.img)~=0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


QSM_to_MNI_mean = sum(QSM_to_MNI_all,4)./sum(mask_to_MNI_all,4);
QSM_to_MNI_mean(isinf(QSM_to_MNI_mean)) = 0;
QSM_to_MNI_mean(isnan(QSM_to_MNI_mean)) = 0;
nii.img = QSM_to_MNI_mean;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/group/QSM_to_MNI_mean.nii');

mask_small = mean(mask_to_MNI_all,4);
mask_small(mask_small<1) = 0;

QSM_to_MNI_mean_small = QSM_to_MNI_mean.*mask_small;
nii.img = QSM_to_MNI_mean_small;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/group/QSM_to_MNI_mean_small.nii');






% MATLAB scripts
% T1W
mkdir /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/group

!gunzip /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/01_VM_H257/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/01_VM_H257/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,1) = single(nii.img);
mask_to_MNI_all(:,:,:,1) = single(single(nii.img)~=0);

!gunzip /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/02_JF_H446/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/02_JF_H446/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,2) = single(nii.img);
mask_to_MNI_all(:,:,:,2) = single(single(nii.img)~=0);

!gunzip /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/03_MP_H447/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/03_MP_H447/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,3) = single(nii.img);
mask_to_MNI_all(:,:,:,3) = single(single(nii.img)~=0);

!gunzip /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/04_BH_H451/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/04_BH_H451/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,4) = single(nii.img);
mask_to_MNI_all(:,:,:,4) = single(single(nii.img)~=0);

!gunzip /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,5) = single(nii.img);
mask_to_MNI_all(:,:,:,5) = single(single(nii.img)~=0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 01EG
!gunzip /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,6) = single(nii.img);
mask_to_MNI_all(:,:,:,6) = single(single(nii.img)~=0);

% 02SCOTT
!gunzip /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,7) = single(nii.img);
mask_to_MNI_all(:,:,:,7) = single(single(nii.img)~=0);

% 03JK
!gunzip /home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,8) = single(nii.img);
mask_to_MNI_all(:,:,:,8) = single(single(nii.img)~=0);

% 05SG 
!gunzip /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/UNIDEN_comboecho/ants_trans_T1_to_MNI.nii');
UNIDEN_to_MNI_all(:,:,:,9) = single(nii.img);
mask_to_MNI_all(:,:,:,9) = single(single(nii.img)~=0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


UNIDEN_to_MNI_mean = sum(UNIDEN_to_MNI_all,4)./sum(mask_to_MNI_all,4);
UNIDEN_to_MNI_mean(isinf(UNIDEN_to_MNI_mean)) = 0;
UNIDEN_to_MNI_mean(isnan(UNIDEN_to_MNI_mean)) = 0;
nii.img = UNIDEN_to_MNI_mean;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/group/UNIDEN_to_MNI_mean.nii');

mask_small = mean(mask_to_MNI_all,4);
mask_small(mask_small<1) = 0;

UNIDEN_to_MNI_mean_small = UNIDEN_to_MNI_mean.*mask_small;
nii.img = UNIDEN_to_MNI_mean_small;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/group/UNIDEN_to_MNI_mean_small.nii');








% MATLAB scripts
% T1 mapping
mkdir /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/group

!gunzip /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/01_VM_H257/T1map/T1m_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/01_VM_H257/T1map/T1m_to_MNI.nii');
T1m_to_MNI_all(:,:,:,1) = single(nii.img);
mask_to_MNI_all(:,:,:,1) = single(single(nii.img)~=0);

!gunzip /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/02_JF_H446/T1map/T1m_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/02_JF_H446/T1map/T1m_to_MNI.nii');
T1m_to_MNI_all(:,:,:,2) = single(nii.img);
mask_to_MNI_all(:,:,:,2) = single(single(nii.img)~=0);

!gunzip /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/03_MP_H447/T1map/T1m_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/03_MP_H447/T1map/T1m_to_MNI.nii');
T1m_to_MNI_all(:,:,:,3) = single(nii.img);
mask_to_MNI_all(:,:,:,3) = single(single(nii.img)~=0);

!gunzip /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/04_BH_H451/T1map/T1m_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/04_BH_H451/T1map/T1m_to_MNI.nii');
T1m_to_MNI_all(:,:,:,4) = single(nii.img);
mask_to_MNI_all(:,:,:,4) = single(single(nii.img)~=0);

!gunzip /home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/T1map/T1m_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/05_JON_H476/T1map/T1m_to_MNI.nii');
T1m_to_MNI_all(:,:,:,5) = single(nii.img);
mask_to_MNI_all(:,:,:,5) = single(single(nii.img)~=0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 01EG
!gunzip /home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/T1map/T1m_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/01EG/1.7.72.2/1.7.72.2.1.2/ME-MP2RAGE_0p75/T1map/T1m_to_MNI.nii');
T1m_to_MNI_all(:,:,:,6) = single(nii.img);
mask_to_MNI_all(:,:,:,6) = single(single(nii.img)~=0);

% 02SCOTT
!gunzip /home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/T1map/T1m_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/02SCOTT/1.7.72.3/1.7.72.3.1.3/ME-MP2RAGE_0p75/T1map/T1m_to_MNI.nii');
T1m_to_MNI_all(:,:,:,7) = single(nii.img);
mask_to_MNI_all(:,:,:,7) = single(single(nii.img)~=0);

% 03JK
!gunzip /home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/T1map/T1m_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/03JK/1.7.72.5/1.7.72.5.1.3/ME-MP2RAGE_0p75/T1map/T1m_to_MNI.nii');
T1m_to_MNI_all(:,:,:,8) = single(nii.img);
mask_to_MNI_all(:,:,:,8) = single(single(nii.img)~=0);

% 05SG 
!gunzip /home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/T1map/T1m_to_MNI.nii.gz
nii = load_untouch_nii('/home/hongfu/cj97_scratch/hongfu/COSMOS/05SG/1.7.72.4/1.7.72.4.1.2/ME-MP2RAGE_0p75/T1map/T1m_to_MNI.nii');
T1m_to_MNI_all(:,:,:,9) = single(nii.img);
mask_to_MNI_all(:,:,:,9) = single(single(nii.img)~=0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T1m_to_MNI_mean = sum(T1m_to_MNI_all,4)./sum(mask_to_MNI_all,4);
T1m_to_MNI_mean(isinf(T1m_to_MNI_mean)) = 0;
T1m_to_MNI_mean(isnan(T1m_to_MNI_mean)) = 0;
nii.img = T1m_to_MNI_mean;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/group/T1m_to_MNI_mean.nii');

mask_small = mean(mask_to_MNI_all,4);
mask_small(mask_small<1) = 0;

T1m_to_MNI_mean_small = T1m_to_MNI_mean.*mask_small;
nii.img = T1m_to_MNI_mean_small;
save_untouch_nii(nii,'/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/group/T1m_to_MNI_mean_small.nii');


