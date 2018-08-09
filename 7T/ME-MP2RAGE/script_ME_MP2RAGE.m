% load 4D T1 maps
!gunzip /media/data/ME-MP2RAGE/01_VM_H257/T1map/*.nii.gz
nii = load_untouch_nii('/media/data/ME-MP2RAGE/01_VM_H257/T1map/20170228_124116mp2rage0p75mmisoBipolarPloss040a1001.nii');
t1_all = single(nii.img);


% load BET_mask
nii = load_untouch_nii('/media/data/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/BET_mask_adj.nii');
mask = single(nii.img);


t1_te1 = t1_all(:,:,:,1).*mask;
t1_te2 = t1_all(:,:,:,2).*mask;
t1_te3 = t1_all(:,:,:,3).*mask;
t1_te4 = t1_all(:,:,:,4).*mask;

% average t1 from 4 echoes
t1_ave = mean(t1_all,4).*mask;
nii.img = t1_ave;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/01_VM_H257/T1map/t1_ave.nii');
t1_sos = sqrt(sum(t1_all.^2,4)).*mask/2;
nii.img = t1_sos;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/01_VM_H257/T1map/t1_sos.nii');
nii.img = t1_te1;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/01_VM_H257/T1map/t1_te1.nii');
nii.img = t1_te2;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/01_VM_H257/T1map/t1_te2.nii');
nii.img = t1_te3;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/01_VM_H257/T1map/t1_te3.nii');
nii.img = t1_te4;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/01_VM_H257/T1map/t1_te4.nii');


% everything else compared to first echo (e.g. ave, 2, 3, 4)
t1_ave_diff_te1 = t1_ave - t1_te1;
t1_sos_diff_te1 = t1_sos - t1_te1;
t1_te2_diff_te1 = t1_te2 - t1_te1;
t1_te3_diff_te1 = t1_te3 - t1_te1;
t1_te4_diff_te1 = t1_te4 - t1_te1;

nii.img = t1_ave_diff_te1;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/01_VM_H257/T1map/t1_ave_diff_te1.nii');
nii.img = t1_sos_diff_te1;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/01_VM_H257/T1map/t1_sos_diff_te1.nii');
nii.img = t1_te2_diff_te1;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/01_VM_H257/T1map/t1_te2_diff_te1.nii');
nii.img = t1_te3_diff_te1;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/01_VM_H257/T1map/t1_te3_diff_te1.nii');
nii.img = t1_te4_diff_te1;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/01_VM_H257/T1map/t1_te4_diff_te1.nii');




% load 4D T1 weighted UNIDEN images
!gunzip /media/data/ME-MP2RAGE/01_VM_H257/UNIDEN_multiecho/*.nii.gz
nii = load_untouch_nii('/media/data/ME-MP2RAGE/01_VM_H257/UNIDEN_multiecho/20170228_124116mp2rage0p75mmisoBipolarPloss041a1001.nii');
uni_all = single(nii.img);


% load BET_mask
nii = load_untouch_nii('/media/data/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/BET_mask_adj.nii');
mask = single(nii.img);


uni_te1 = uni_all(:,:,:,1).*mask;
uni_te2 = uni_all(:,:,:,2).*mask;
uni_te3 = uni_all(:,:,:,3).*mask;
uni_te4 = uni_all(:,:,:,4).*mask;

% average t1 from 4 echoes
uni_ave = mean(uni_all,4).*mask;
nii.img = uni_ave;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/01_VM_H257/UNIDEN_multiecho/uni_ave.nii');
uni_sos = sqrt(sum(uni_all.^2,4)).*mask/2;
nii.img = uni_sos;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/01_VM_H257/UNIDEN_multiecho/uni_sos.nii');
nii.img = uni_te1;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/01_VM_H257/UNIDEN_multiecho/uni_te1.nii');
nii.img = uni_te2;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/01_VM_H257/UNIDEN_multiecho/uni_te2.nii');
nii.img = uni_te3;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/01_VM_H257/UNIDEN_multiecho/uni_te3.nii');
nii.img = uni_te4;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/01_VM_H257/UNIDEN_multiecho/uni_te4.nii');


% everything else compared to first echo (e.g. ave, 2, 3, 4)
uni_ave_diff_te1 = uni_ave - uni_te1;
uni_sos_diff_te1 = uni_sos - uni_te1;
uni_te2_diff_te1 = uni_te2 - uni_te1;
uni_te3_diff_te1 = uni_te3 - uni_te1;
uni_te4_diff_te1 = uni_te4 - uni_te1;

nii.img = uni_ave_diff_te1;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/01_VM_H257/UNIDEN_multiecho/uni_ave_diff_te1.nii');
nii.img = uni_sos_diff_te1;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/01_VM_H257/UNIDEN_multiecho/uni_sos_diff_te1.nii');
nii.img = uni_te2_diff_te1;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/01_VM_H257/UNIDEN_multiecho/uni_te2_diff_te1.nii');
nii.img = uni_te3_diff_te1;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/01_VM_H257/UNIDEN_multiecho/uni_te3_diff_te1.nii');
nii.img = uni_te4_diff_te1;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/01_VM_H257/UNIDEN_multiecho/uni_te4_diff_te1.nii');




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





# bash command
# FLIRT 12DOF register 0.75 MP2RAGE-QSM to GRE-QSM
/usr/local/fsl/5.0.9/bin/flirt -in /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2.nii -ref /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/07JON/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2.nii -out /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_flirt.nii -omat /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_flirt.mat -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear

# apply the transformation to R2* mapping
/usr/local/fsl/5.0.9/bin/flirt -in /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/R2_I2.nii -applyxfm -init /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_flirt.mat -out /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/R2_I2_flirt.nii -paddingsize 0.0 -interp trilinear -ref /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/07JON/neutral/QSM_MEGE_7T/R2.nii

/usr/local/fsl/5.0.9/bin/flirt -in /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/R2_I1.nii -applyxfm -init /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2_flirt.mat -out /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/R2_I1_flirt.nii -paddingsize 0.0 -interp trilinear -ref /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/07JON/neutral/QSM_MEGE_7T/R2.nii


# FLIRT 12DOF register 0.6 GRE-QSM to MP2RAGE-QSM 
/usr/local/fsl/5.0.9/bin/flirt -ref /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/RESHARP/chi_iLSQR_smvrad2.nii  -in /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/07JON/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2.nii -out /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/07JON/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_to_MP2RAGE.nii -omat /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/07JON/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_to_MP2RAGE.mat -bins 256 -cost normcorr -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear

# apply the trans to R2* mapping
/usr/local/fsl/5.0.9/bin/flirt -ref /gpfs/M2Scratch/NCIgb5/hongfu/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/R2_I2.nii -applyxfm -init /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/07JON/neutral/QSM_MEGE_7T/RESHARP/chi_iLSQR_smvrad2_to_MP2RAGE.mat -out /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/07JON/neutral/QSM_MEGE_7T/R2_to_MP2RAGE.nii -paddingsize 0.0 -interp trilinear -in /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/07JON/neutral/QSM_MEGE_7T/R2.nii







# SWI using Yuhan's codes
# this was run on office Ubuntu at UofC
cd /media/data/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/src
# generate mnc files from nii
rm ../*.mnc
nii2mnc ../BET_mask.nii
rm *.mnc
nii2mnc mag_corr1_n4.nii
nii2mnc mag_corr2_n4.nii
nii2mnc mag_corr3_n4.nii
nii2mnc mag_corr4_n4.nii
nii2mnc ph_corr1.nii
nii2mnc ph_corr2.nii
nii2mnc ph_corr3.nii
nii2mnc ph_corr4.nii


cd /media/data/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T/src
# generate mnc files from nii
rm ../*.mnc
nii2mnc ../BET_mask.nii
rm *.mnc
nii2mnc mag_corr1_n4.nii
nii2mnc mag_corr2_n4.nii
nii2mnc mag_corr3_n4.nii
nii2mnc mag_corr4_n4.nii
nii2mnc ph_corr1.nii
nii2mnc ph_corr2.nii
nii2mnc ph_corr3.nii
nii2mnc ph_corr4.nii


cd /media/data/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/src
# generate mnc files from nii
rm ../*.mnc
nii2mnc ../BET_mask.nii
rm *.mnc
nii2mnc mag_corr1_n4.nii
nii2mnc mag_corr2_n4.nii
nii2mnc mag_corr3_n4.nii
nii2mnc mag_corr4_n4.nii
nii2mnc ph_corr1.nii
nii2mnc ph_corr2.nii
nii2mnc ph_corr3.nii
nii2mnc ph_corr4.nii


cd /media/data/ME-MP2RAGE/04_BH_451/QSM_MEMP2RAGE_7T/src
# generate mnc files from nii
rm ../*.mnc
nii2mnc ../BET_mask.nii
rm *.mnc
nii2mnc mag_corr1_n4.nii
nii2mnc mag_corr2_n4.nii
nii2mnc mag_corr3_n4.nii
nii2mnc mag_corr4_n4.nii
nii2mnc ph_corr1.nii
nii2mnc ph_corr2.nii
nii2mnc ph_corr3.nii
nii2mnc ph_corr4.nii


cd /media/data/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/src
# generate mnc files from nii
rm ../*.mnc
nii2mnc ../BET_mask.nii
rm *.mnc
nii2mnc mag_corr1_n4.nii
nii2mnc mag_corr2_n4.nii
nii2mnc mag_corr3_n4.nii
nii2mnc mag_corr4_n4.nii
nii2mnc ph_corr1.nii
nii2mnc ph_corr2.nii
nii2mnc ph_corr3.nii
nii2mnc ph_corr4.nii



%% run these in MATLAB
cd /media/data/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/src
do_unwrap_swi('mag_corr1_n4.mnc', 'ph_corr1.mnc', 'swi_unwrap_echo_1_of_4.mnc', 'phase_unwrap_echo_1_of_4.mnc', '../BET_mask.mnc', 0.2, 1, 4, 1);
do_unwrap_swi('mag_corr2_n4.mnc', 'ph_corr2.mnc', 'swi_unwrap_echo_2_of_4.mnc', 'phase_unwrap_echo_2_of_4.mnc', '../BET_mask.mnc', 0.25, 1, 4, 1);
do_unwrap_swi('mag_corr3_n4.mnc', 'ph_corr3.mnc', 'swi_unwrap_echo_3_of_4.mnc', 'phase_unwrap_echo_3_of_4.mnc', '../BET_mask.mnc', 0.3, 1, 4, 1);
do_unwrap_swi('mag_corr4_n4.mnc', 'ph_corr4.mnc', 'swi_unwrap_echo_4_of_4.mnc', 'phase_unwrap_echo_4_of_4.mnc', '../BET_mask.mnc', 0.35, 1, 4, 1);
unix('./multi_echo_swi_unwrapped.pl mag_corr ph_corr ../BET_mask.mnc 4 combined_unwrap_swi.mnc');

do_swi('mag_corr1_n4.mnc', 'ph_corr1.mnc', 'swi_echo_1_of_4.mnc', 'phase_echo_1_of_4.mnc', 0.2, 1);
do_swi('mag_corr2_n4.mnc', 'ph_corr2.mnc', 'swi_echo_2_of_4.mnc', 'phase_echo_2_of_4.mnc', 0.25, 1);
do_swi('mag_corr3_n4.mnc', 'ph_corr3.mnc', 'swi_echo_3_of_4.mnc', 'phase_echo_3_of_4.mnc', 0.3, 1);
do_swi('mag_corr4_n4.mnc', 'ph_corr4.mnc', 'swi_echo_4_of_4.mnc', 'phase_echo_4_of_4.mnc', 0.35, 1);
unix('./multi_echo_swi.pl mag_corr ph_corr 4 combined_swi.mnc');




cd /media/data/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T/src
do_unwrap_swi('mag_corr1_n4.mnc', 'ph_corr1.mnc', 'swi_unwrap_echo_1_of_4.mnc', 'phase_unwrap_echo_1_of_4.mnc', '../BET_mask.mnc', 0.2, 1, 4, 1);
do_unwrap_swi('mag_corr2_n4.mnc', 'ph_corr2.mnc', 'swi_unwrap_echo_2_of_4.mnc', 'phase_unwrap_echo_2_of_4.mnc', '../BET_mask.mnc', 0.25, 1, 4, 1);
do_unwrap_swi('mag_corr3_n4.mnc', 'ph_corr3.mnc', 'swi_unwrap_echo_3_of_4.mnc', 'phase_unwrap_echo_3_of_4.mnc', '../BET_mask.mnc', 0.3, 1, 4, 1);
do_unwrap_swi('mag_corr4_n4.mnc', 'ph_corr4.mnc', 'swi_unwrap_echo_4_of_4.mnc', 'phase_unwrap_echo_4_of_4.mnc', '../BET_mask.mnc', 0.35, 1, 4, 1);
unix('./multi_echo_swi_unwrapped.pl mag_corr ph_corr ../BET_mask.mnc 4 combined_unwrap_swi.mnc');

do_swi('mag_corr1_n4.mnc', 'ph_corr1.mnc', 'swi_echo_1_of_4.mnc', 'phase_echo_1_of_4.mnc', 0.2, 1);
do_swi('mag_corr2_n4.mnc', 'ph_corr2.mnc', 'swi_echo_2_of_4.mnc', 'phase_echo_2_of_4.mnc', 0.25, 1);
do_swi('mag_corr3_n4.mnc', 'ph_corr3.mnc', 'swi_echo_3_of_4.mnc', 'phase_echo_3_of_4.mnc', 0.3, 1);
do_swi('mag_corr4_n4.mnc', 'ph_corr4.mnc', 'swi_echo_4_of_4.mnc', 'phase_echo_4_of_4.mnc', 0.35, 1);
unix('./multi_echo_swi.pl mag_corr ph_corr 4 combined_swi.mnc');



cd /media/data/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/src
do_unwrap_swi('mag_corr1_n4.mnc', 'ph_corr1.mnc', 'swi_unwrap_echo_1_of_4.mnc', 'phase_unwrap_echo_1_of_4.mnc', '../BET_mask.mnc', 0.2, 1, 4, 1);
do_unwrap_swi('mag_corr2_n4.mnc', 'ph_corr2.mnc', 'swi_unwrap_echo_2_of_4.mnc', 'phase_unwrap_echo_2_of_4.mnc', '../BET_mask.mnc', 0.25, 1, 4, 1);
do_unwrap_swi('mag_corr3_n4.mnc', 'ph_corr3.mnc', 'swi_unwrap_echo_3_of_4.mnc', 'phase_unwrap_echo_3_of_4.mnc', '../BET_mask.mnc', 0.3, 1, 4, 1);
do_unwrap_swi('mag_corr4_n4.mnc', 'ph_corr4.mnc', 'swi_unwrap_echo_4_of_4.mnc', 'phase_unwrap_echo_4_of_4.mnc', '../BET_mask.mnc', 0.35, 1, 4, 1);
unix('./multi_echo_swi_unwrapped.pl mag_corr ph_corr ../BET_mask.mnc 4 combined_unwrap_swi.mnc');

do_swi('mag_corr1_n4.mnc', 'ph_corr1.mnc', 'swi_echo_1_of_4.mnc', 'phase_echo_1_of_4.mnc', 0.2, 1);
do_swi('mag_corr2_n4.mnc', 'ph_corr2.mnc', 'swi_echo_2_of_4.mnc', 'phase_echo_2_of_4.mnc', 0.25, 1);
do_swi('mag_corr3_n4.mnc', 'ph_corr3.mnc', 'swi_echo_3_of_4.mnc', 'phase_echo_3_of_4.mnc', 0.3, 1);
do_swi('mag_corr4_n4.mnc', 'ph_corr4.mnc', 'swi_echo_4_of_4.mnc', 'phase_echo_4_of_4.mnc', 0.35, 1);
unix('./multi_echo_swi.pl mag_corr ph_corr 4 combined_swi.mnc');



cd /media/data/ME-MP2RAGE/04_BH_451/QSM_MEMP2RAGE_7T/src
do_unwrap_swi('mag_corr1_n4.mnc', 'ph_corr1.mnc', 'swi_unwrap_echo_1_of_4.mnc', 'phase_unwrap_echo_1_of_4.mnc', '../BET_mask.mnc', 0.2, 1, 4, 1);
do_unwrap_swi('mag_corr2_n4.mnc', 'ph_corr2.mnc', 'swi_unwrap_echo_2_of_4.mnc', 'phase_unwrap_echo_2_of_4.mnc', '../BET_mask.mnc', 0.25, 1, 4, 1);
do_unwrap_swi('mag_corr3_n4.mnc', 'ph_corr3.mnc', 'swi_unwrap_echo_3_of_4.mnc', 'phase_unwrap_echo_3_of_4.mnc', '../BET_mask.mnc', 0.3, 1, 4, 1);
do_unwrap_swi('mag_corr4_n4.mnc', 'ph_corr4.mnc', 'swi_unwrap_echo_4_of_4.mnc', 'phase_unwrap_echo_4_of_4.mnc', '../BET_mask.mnc', 0.35, 1, 4, 1);
unix('./multi_echo_swi_unwrapped.pl mag_corr ph_corr ../BET_mask.mnc 4 combined_unwrap_swi.mnc');

do_swi('mag_corr1_n4.mnc', 'ph_corr1.mnc', 'swi_echo_1_of_4.mnc', 'phase_echo_1_of_4.mnc', 0.2, 1);
do_swi('mag_corr2_n4.mnc', 'ph_corr2.mnc', 'swi_echo_2_of_4.mnc', 'phase_echo_2_of_4.mnc', 0.25, 1);
do_swi('mag_corr3_n4.mnc', 'ph_corr3.mnc', 'swi_echo_3_of_4.mnc', 'phase_echo_3_of_4.mnc', 0.3, 1);
do_swi('mag_corr4_n4.mnc', 'ph_corr4.mnc', 'swi_echo_4_of_4.mnc', 'phase_echo_4_of_4.mnc', 0.35, 1);
unix('./multi_echo_swi.pl mag_corr ph_corr 4 combined_swi.mnc');



cd /media/data/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/src
do_unwrap_swi('mag_corr1_n4.mnc', 'ph_corr1.mnc', 'swi_unwrap_echo_1_of_4.mnc', 'phase_unwrap_echo_1_of_4.mnc', '../BET_mask.mnc', 0.2, 1, 4, 1);
do_unwrap_swi('mag_corr2_n4.mnc', 'ph_corr2.mnc', 'swi_unwrap_echo_2_of_4.mnc', 'phase_unwrap_echo_2_of_4.mnc', '../BET_mask.mnc', 0.25, 1, 4, 1);
do_unwrap_swi('mag_corr3_n4.mnc', 'ph_corr3.mnc', 'swi_unwrap_echo_3_of_4.mnc', 'phase_unwrap_echo_3_of_4.mnc', '../BET_mask.mnc', 0.3, 1, 4, 1);
do_unwrap_swi('mag_corr4_n4.mnc', 'ph_corr4.mnc', 'swi_unwrap_echo_4_of_4.mnc', 'phase_unwrap_echo_4_of_4.mnc', '../BET_mask.mnc', 0.35, 1, 4, 1);
unix('./multi_echo_swi_unwrapped.pl mag_corr ph_corr ../BET_mask.mnc 4 combined_unwrap_swi.mnc');

do_swi('mag_corr1_n4.mnc', 'ph_corr1.mnc', 'swi_echo_1_of_4.mnc', 'phase_echo_1_of_4.mnc', 0.2, 1);
do_swi('mag_corr2_n4.mnc', 'ph_corr2.mnc', 'swi_echo_2_of_4.mnc', 'phase_echo_2_of_4.mnc', 0.25, 1);
do_swi('mag_corr3_n4.mnc', 'ph_corr3.mnc', 'swi_echo_3_of_4.mnc', 'phase_echo_3_of_4.mnc', 0.3, 1);
do_swi('mag_corr4_n4.mnc', 'ph_corr4.mnc', 'swi_echo_4_of_4.mnc', 'phase_echo_4_of_4.mnc', 0.35, 1);
unix('./multi_echo_swi.pl mag_corr ph_corr 4 combined_swi.mnc');




# move the current results to folder of filter strengths
cd /media/data/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/src
mkdir p1
mv phase_echo*.mnc swi_echo*.mnc phase_unwrap_echo*.mnc swi_unwrap_echo*.mnc combined_swi*.mnc combined_unwrap_swi*.mnc p1

cd /media/data/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T/src
mkdir p1
mv phase_echo*.mnc swi_echo*.mnc phase_unwrap_echo*.mnc swi_unwrap_echo*.mnc combined_swi*.mnc combined_unwrap_swi*.mnc p1

cd /media/data/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/src
mkdir p1
mv phase_echo*.mnc swi_echo*.mnc phase_unwrap_echo*.mnc swi_unwrap_echo*.mnc combined_swi*.mnc combined_unwrap_swi*.mnc p1

cd /media/data/ME-MP2RAGE/04_BH_451/QSM_MEMP2RAGE_7T/src
mkdir p1
mv phase_echo*.mnc swi_echo*.mnc phase_unwrap_echo*.mnc swi_unwrap_echo*.mnc combined_swi*.mnc combined_unwrap_swi*.mnc p1

cd /media/data/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/src
mkdir p1
mv phase_echo*.mnc swi_echo*.mnc phase_unwrap_echo*.mnc swi_unwrap_echo*.mnc combined_swi*.mnc combined_unwrap_swi*.mnc p1



# convert mnc results to nii
cd /media/data/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/src/p1
for minc_file in *.mnc
do
	mnc2nii $minc_file
done

cd /media/data/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/src/p2
for minc_file in *.mnc
do
	mnc2nii $minc_file
done

cd /media/data/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/src/p3
for minc_file in *.mnc
do
	mnc2nii $minc_file
done

cd /media/data/ME-MP2RAGE/01_VM_H257/QSM_MEMP2RAGE_7T/src/p4
for minc_file in *.mnc
do
	mnc2nii $minc_file
done


cd /media/data/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T/src/p1
for minc_file in *.mnc
do
	mnc2nii $minc_file
done

cd /media/data/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T/src/p2
for minc_file in *.mnc
do
	mnc2nii $minc_file
done

cd /media/data/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T/src/p3
for minc_file in *.mnc
do
	mnc2nii $minc_file
done

cd /media/data/ME-MP2RAGE/02_JF_H446/QSM_MEMP2RAGE_7T/src/p4
for minc_file in *.mnc
do
	mnc2nii $minc_file
done



cd /media/data/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/src/p1
for minc_file in *.mnc
do
	mnc2nii $minc_file
done

cd /media/data/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/src/p2
for minc_file in *.mnc
do
	mnc2nii $minc_file
done

cd /media/data/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/src/p3
for minc_file in *.mnc
do
	mnc2nii $minc_file
done

cd /media/data/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/src/p4
for minc_file in *.mnc
do
	mnc2nii $minc_file
done




cd /media/data/ME-MP2RAGE/04_BH_451/QSM_MEMP2RAGE_7T/src/p1
for minc_file in *.mnc
do
	mnc2nii $minc_file
done

cd /media/data/ME-MP2RAGE/04_BH_451/QSM_MEMP2RAGE_7T/src/p2
for minc_file in *.mnc
do
	mnc2nii $minc_file
done

cd /media/data/ME-MP2RAGE/04_BH_451/QSM_MEMP2RAGE_7T/src/p3
for minc_file in *.mnc
do
	mnc2nii $minc_file
done

cd /media/data/ME-MP2RAGE/04_BH_451/QSM_MEMP2RAGE_7T/src/p4
for minc_file in *.mnc
do
	mnc2nii $minc_file
done




cd /media/data/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/src/p1
for minc_file in *.mnc
do
	mnc2nii $minc_file
done

cd /media/data/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/src/p2
for minc_file in *.mnc
do
	mnc2nii $minc_file
done

cd /media/data/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/src/p3
for minc_file in *.mnc
do
	mnc2nii $minc_file
done

cd /media/data/ME-MP2RAGE/05_JON_H476/QSM_MEMP2RAGE_7T/src/p4
for minc_file in *.mnc
do
	mnc2nii $minc_file
done



TE1 = 2.3;
TE2 = 5;
TE3 = 6.9;
TE4 = 8.7;



% create mIP
nii = load_untouch_nii('/media/data/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/src/p1/phase_unwrap_echo_1_of_4.nii');
pha1 = single(nii.img)./TE1;
nii = load_untouch_nii('/media/data/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/src/p1/phase_unwrap_echo_2_of_4.nii');
pha2 = single(nii.img)./TE2;
nii = load_untouch_nii('/media/data/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/src/p1/phase_unwrap_echo_3_of_4.nii');
pha3 = single(nii.img)./TE3;
nii = load_untouch_nii('/media/data/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/src/p1/phase_unwrap_echo_4_of_4.nii');
pha4 = single(nii.img)./TE4;

pha_all = cat(4, pha1,pha2,pha3,pha4);
mIP_all = min(pha_all,[],4);
mIP_all = mIP_all*TE4;

nii.img = mIP_all;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/src/p1/phase_mIP.nii');

pha_mean = (pha1 + pha2 + pha3 + pha4)/4*TE4;
nii.img = pha_mean;
save_untouch_nii(nii,'/media/data/ME-MP2RAGE/03_MP_H447/QSM_MEMP2RAGE_7T/src/p1/pha_mean.nii');


