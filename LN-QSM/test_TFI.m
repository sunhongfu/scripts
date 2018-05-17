% script to test MEDI(RESHARP,LBV) and TFI and TIK-QSM (brain + whole head)

load all.mat
% use Cornell's complex fitting + spurs unwrapping
iField = mag.*exp(1i*ph_corr);
%%%%% provide a noise_level here if possible %%%%%%
if (~exist('noise_level','var'))
    noise_level = calfieldnoise(iField, mask);
end
%%%%% normalize signal intensity by noise to get SNR %%%
iField = iField/noise_level;
%%%% Generate the Magnitude image %%%%
iMag = sqrt(sum(abs(iField).^2,4));
[iFreq_raw N_std] = Fit_ppm_complex(iField);
matrix_size = single(imsize(1:3));
voxel_size = vox;
delta_TE = TE(2) - TE(1);
B0_dir = z_prjs';
CF = dicom_info.ImagingFrequency *1e6;

% % Spatial phase unwrapping (graph-cut based)
% iFreq = unwrapping_gc(iFreq_raw,iMag,voxel_size);
% iFreq = iFreq - 6*pi;
% nii = make_nii(iFreq,vox);
% save_nii(nii,'iFreq_unwrapping_gc.nii');


% or from traditional tfs (prelude+fitting)
iFreq = tfs*2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6;

load('all.mat','iFreq_raw','voxel_size','mask','R','delta_TE');

mkdir SS
cd SS
save('ss.mat','iFreq_raw','voxel_size','mask','R','delta_TE');
load('ss.mat');
nii = make_nii(iFreq_raw,voxel_size);
save_nii(nii,'iFreq_raw.nii');
nii = make_nii(mask.*R,voxel_size);
save_nii(nii,'mask.nii');
!tgv_qsm  -p iFreq_raw.nii -m mask.nii -f 3 -t 0.0034 -o SS_QSM --no-resampling


!tgv_qsm  -p iFreq_raw.nii -m mask.nii -f 3 -t 0.0034 -o SS_QSM_new --alpha 0.0009 0.0003 --no-resampling

% !tgv_qsm  -p iFreq_raw.nii -m mask.nii -f 3 -t 0.0034 -o SS_QSM_1 --alpha 0.0015 0.0005
% !tgv_qsm  -p iFreq_raw.nii -m mask.nii -f 3 -t 0.0034 -o SS_QSM_2 --alpha 0.015 0.005
% !tgv_qsm  -p iFreq_raw.nii -m mask.nii -f 3 -t 0.0034 -o SS_QSM_3 --alpha 0.00015 0.00005
% !tgv_qsm  -p iFreq_raw.nii -m mask.nii -f 3 -t 0.0034 -o SS_QSM_5 --alpha 0.00075 0.00025
% !tgv_qsm  -p iFreq_raw.nii -m mask.nii -f 3 -t 0.0034 -o SS_QSM_6 --alpha 0.00012 0.00004
% !tgv_qsm  -p iFreq_raw.nii -m mask.nii -f 3 -t 0.0034 -o SS_QSM_7 --alpha 0.0003 0.0001

%% !!! cannot run from MATLAB, need to run in shell

cd ..

save all.mat
clear





load('all.mat','mask','R','matrix_size','voxel_size','delta_TE','B0_dir','CF','iMag','N_std','iFreq','tfs','vox','dicom_info','z_prjs');
% apply R
mask = mask.*R;
% mask_erosion
r = 1; 
[X,Y,Z] = ndgrid(-r:r,-r:r,-r:r);
h = (X.^2/r^2 + Y.^2/r^2 + Z.^2/r^2 <= 1);
ker = h/sum(h(:));
imsize = size(mask);
mask_tmp = convn(mask,ker,'same');
mask_ero1 = zeros(imsize);
mask_ero1(mask_tmp > 0.999999) = 1; % no error tolerance
r = 2; 
[X,Y,Z] = ndgrid(-r:r,-r:r,-r:r);
h = (X.^2/r^2 + Y.^2/r^2 + Z.^2/r^2 <= 1);
ker = h/sum(h(:));
imsize = size(mask);
mask_tmp = convn(mask,ker,'same');
mask_ero2 = zeros(imsize);
mask_ero2(mask_tmp > 0.999999) = 1; % no error tolerance
r = 3; 
[X,Y,Z] = ndgrid(-r:r,-r:r,-r:r);
h = (X.^2/r^2 + Y.^2/r^2 + Z.^2/r^2 <= 1);
ker = h/sum(h(:));
imsize = size(mask);
mask_tmp = convn(mask,ker,'same');
mask_ero3 = zeros(imsize);
mask_ero3(mask_tmp > 0.999999) = 1; % no error tolerance

nii = make_nii(mask,vox);
save_nii(nii,'mask_ero0.nii');
nii = make_nii(mask_ero1,vox);
save_nii(nii,'mask_ero1.nii');
nii = make_nii(mask_ero2,vox);
save_nii(nii,'mask_ero2.nii');
nii = make_nii(mask_ero3,vox);
save_nii(nii,'mask_ero3.nii');

% or from traditional tfs (prelude+fitting)
iFreq = tfs*2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mkdir TFS_LNQSM
% pad 40 zeros
tfs_pad = padarray(tfs,[0 0 40]);
mask_pad = padarray(mask,[0 0 40]);

P = mask_pad + 30*(1 - mask_pad);
Res_wt = iMag./mean(iMag(mask>0));
Res_wt = padarray(Res_wt,[0 0 40]);


chi_ero0_masked_500 = tikhonov_qsm(tfs_pad, Res_wt.*mask_pad, 1, mask_pad, mask_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 500);
nii = make_nii(chi_ero0_masked_500,vox);
save_nii(nii,['chi_ero0_mm_1e-3_wt_fitmask_masked_500.nii']);


chi_ero0_masked_2000 = tikhonov_qsm(tfs_pad, Res_wt.*mask_pad, 1, mask_pad, mask_pad, 0, 5e-4, 0.001, 0, vox, P, z_prjs, 2000);
nii = make_nii(chi_ero0_masked_2000,vox);
save_nii(nii,['chi_ero0_mm_1e-3_wt_fitmask_masked_2000.nii']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mkdir TFS_TFI_ERO0
cd TFS_TFI_ERO0
% (1) TFI of 0 voxel erosion
Mask = mask; % only brain tissue, need whole head later
Mask_G = Mask;
P_B = 30;
P = 1 * Mask + P_B * (1-Mask);
RDF = 0;
save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF
QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 600*2);
nii = make_nii(QSM.*Mask,vox);
save_nii(nii,'TFI_ero0.nii');
cd ..


mkdir TFS_TFI_ERO1
cd TFS_TFI_ERO1
% (2) TFI of 1 voxel erosion
Mask = mask_ero1; % only brain tissue, need whole head later
Mask_G = Mask;
P_B = 30;
P = 1 * Mask + P_B * (1-Mask);
RDF = 0;
save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF
QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 600*2);
nii = make_nii(QSM.*Mask,vox);
save_nii(nii,'TFI_ero1.nii');
cd ..


mkdir TFS_TFI_ERO2
cd TFS_TFI_ERO2
% (3) TFI of 2 voxel erosion
Mask = mask_ero2; % only brain tissue, need whole head later
Mask_G = Mask;
P_B = 30;
P = 1 * Mask + P_B * (1-Mask);
RDF = 0;
save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF
QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 600*2);
nii = make_nii(QSM.*Mask,vox);
save_nii(nii,'TFI_ero2.nii');
cd ..


mkdir TFS_TFI_ERO3
cd TFS_TFI_ERO3
% (4) TFI of 3 voxels erosion
Mask = mask_ero3;
Mask_G = Mask;
P_B = 30;
P = 1 * Mask + P_B * (1-Mask);
RDF = 0;
save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF
QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 600*2);
nii = make_nii(QSM.*Mask,vox);
% save_nii(nii,'TFI_ero3.nii');
save_nii(nii,'TFI_ero3.nii');
cd ..


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mkdir TFS_PDF_ERO0
cd TFS_PDF_ERO0
RDF = projectionontodipolefields(iFreq,mask,vox,mask,z_prjs);
% RDF = PDF(iFreq,N_std, Mask,matrix_size,voxel_size, B0_dir,1e-6);
nii = make_nii(RDF,vox);
save_nii(nii,'PDF_ero0.nii');
Mask = mask;
save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
     voxel_size delta_TE CF B0_dir;

QSM = MEDI_L1('lambda',1000);
nii = make_nii(QSM.*Mask,vox);
save_nii(nii,'MEDI_PDF_ero0.nii');
cd ..


mkdir TFS_PDF_ERO1
cd TFS_PDF_ERO1
RDF = projectionontodipolefields(iFreq,mask_ero1,vox,mask_ero1,z_prjs);
% RDF = PDF(iFreq,N_std, Mask,matrix_size,voxel_size, B0_dir,1e-6);
nii = make_nii(RDF,vox);
save_nii(nii,'PDF_ero1.nii');
Mask = mask_ero1;
save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
     voxel_size delta_TE CF B0_dir;

QSM = MEDI_L1('lambda',1000);
nii = make_nii(QSM.*Mask,vox);
save_nii(nii,'MEDI_PDF_ero1.nii');
cd ..


mkdir TFS_PDF_ERO2
cd TFS_PDF_ERO2
RDF = projectionontodipolefields(iFreq,mask_ero2,vox,mask_ero2,z_prjs);
% RDF = PDF(iFreq,N_std, Mask,matrix_size,voxel_size, B0_dir,1e-6);
nii = make_nii(RDF,vox);
save_nii(nii,'PDF_ero2.nii');
Mask = mask_ero2;
save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
     voxel_size delta_TE CF B0_dir;

QSM = MEDI_L1('lambda',1000);
nii = make_nii(QSM.*Mask,vox);
save_nii(nii,'MEDI_PDF_ero2.nii');
cd ..


mkdir TFS_PDF_ERO3
cd TFS_PDF_ERO3
RDF = projectionontodipolefields(iFreq,mask_ero3,vox,mask_ero3,z_prjs);
% RDF = PDF(iFreq,N_std, Mask,matrix_size,voxel_size, B0_dir,1e-6);
nii = make_nii(RDF,vox);
save_nii(nii,'PDF_ero3.nii');
Mask = mask_ero3;
save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
     voxel_size delta_TE CF B0_dir;

QSM = MEDI_L1('lambda',1000);
nii = make_nii(QSM.*Mask,vox);
save_nii(nii,'MEDI_PDF_ero3.nii');
cd ..


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mkdir TFS_LBV_ERO1
cd TFS_LBV_ERO1
% (5) MEDI 1 voxel erosion with LBV
lfs_lbv = LBV(iFreq,mask,matrix_size,voxel_size,0.001);
Mask = ones(size(mask));
Mask(lfs_lbv == 0) = 0;
RDF= lfs_lbv - poly3d(lfs_lbv,Mask);
nii = make_nii(RDF.*Mask,vox);
save_nii(nii,'LBV_ero1_new.nii');

save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
     voxel_size delta_TE CF B0_dir;

QSM = MEDI_L1('lambda',1000);
nii = make_nii(QSM.*Mask,vox);
save_nii(nii,'MEDI_LBV_ero1_new.nii');
cd ..


mkdir TFS_LBV_ERO2
cd TFS_LBV_ERO2
% (5) MEDI 1 voxel erosion with LBV
lfs_lbv = LBV(iFreq,mask_ero1,matrix_size,voxel_size,0.001);
Mask = ones(size(mask));
Mask(lfs_lbv == 0) = 0;
RDF= lfs_lbv - poly3d(lfs_lbv,Mask);
nii = make_nii(RDF.*Mask,vox);
save_nii(nii,'LBV_ero2_new.nii');

save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
     voxel_size delta_TE CF B0_dir;

QSM = MEDI_L1('lambda',1000);
nii = make_nii(QSM.*Mask,vox);
save_nii(nii,'MEDI_LBV_ero2_new.nii');
cd ..


mkdir TFS_LBV_ERO3
cd TFS_LBV_ERO3
% (5) MEDI 1 voxel erosion with LBV
lfs_lbv = LBV(iFreq,mask_ero2,matrix_size,voxel_size,0.001);
Mask = ones(size(mask));
Mask(lfs_lbv == 0) = 0;
RDF= lfs_lbv - poly3d(lfs_lbv,Mask);
nii = make_nii(RDF.*Mask,vox);
save_nii(nii,'LBV_ero3_new.nii');

save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
     voxel_size delta_TE CF B0_dir;

QSM = MEDI_L1('lambda',1000);
nii = make_nii(QSM.*Mask,vox);
save_nii(nii,'MEDI_LBV_ero3_new.nii');
cd ..


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% change the RESHARP parameter? 1e-6?
mkdir TFS_RESHARP_ERO2
cd TFS_RESHARP_ERO2
% (8) MEDI eroded brain with RESHARP (2 voxels erosion)
[RDF, mask_resharp] = resharp(iFreq,mask,vox,2,1e-6,200);
nii = make_nii(RDF,voxel_size);
save_nii(nii,'resharp_1e-6.nii');
Mask = mask_resharp;
save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
     voxel_size delta_TE CF B0_dir;
% run part of MEDI first
QSM = MEDI_L1('lambda',1000);
nii = make_nii(QSM.*Mask,vox);
save_nii(nii,'MEDI_RESHARP_1e-6_ero2.nii');
cd ..


%% change the RESHARP parameter? 1e-6?
mkdir TFS_RESHARP_ERO3
cd TFS_RESHARP_ERO3
% (9) MEDI eroded brain with RESHARP (3 voxels erosion)
[RDF, mask_resharp] = resharp(iFreq,mask,vox,3,1e-6,500);
nii = make_nii(RDF,voxel_size);
save_nii(nii,'resharp_1e-6.nii');
Mask = mask_resharp;
save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
     voxel_size delta_TE CF B0_dir;
% run part of MEDI first
QSM = MEDI_L1('lambda',1000);
nii = make_nii(QSM.*Mask,vox);
save_nii(nii,'MEDI_RESHARP_1e-6_ero3.nii');
cd ..


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% change the RESHARP parameter? 1e-6?
mkdir TFS_RESHARP_TV_ERO2
cd TFS_RESHARP_TV_ERO2
% (10) TVDI eroded brain with RESHARP (2 voxels erosion)
[RDF, mask_resharp] = resharp(iFreq,mask,vox,2,1e-6,500);
lfs_resharp = RDF/(2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6);
sus_resharp = tvdi(lfs_resharp,mask_resharp,vox,5e-4,iMag,z_prjs,500); 
nii = make_nii(sus_resharp.*mask_resharp,vox);
save_nii(nii,'TV_RESHARP_1e-6_ero2.nii');
cd ..


%% change the RESHARP parameter? 1e-6?
mkdir TFS_RESHARP_TV_ERO3
cd TFS_RESHARP_TV_ERO3
% (11) TVDI eroded brain with RESHARP (3 voxels erosion)
[RDF, mask_resharp] = resharp(iFreq,mask,vox,3,1e-6,500);
lfs_resharp = RDF/(2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6);
sus_resharp = tvdi(lfs_resharp,mask_resharp,vox,5e-4,iMag,z_prjs,500); 
nii = make_nii(sus_resharp.*mask_resharp,vox);
save_nii(nii,'TV_RESHARP_1e-6_ero3.nii');
cd ..


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mkdir TFS_TIK_PRE_ERO0
cd TFS_TIK_PRE_ERO0
tfs_pad = padarray(iFreq/(2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6),[0 0 20]);
mask_pad = padarray(mask,[0 0 20]);
% R_pad = padarray(R,[0 0 20]);
r=0;
Tik_weight = [1e-3];
TV_weight = 4e-4;
for i = 1:length(Tik_weight)
	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 200);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_200.nii']);
	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 500);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_500.nii']);
	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 2000);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);
	chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 5000);
	nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_5000.nii']);
end
cd ..


mkdir TFS_TIK_PRE_ERO1
cd TFS_TIK_PRE_ERO1
tfs_pad = padarray(iFreq/(2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6),[0 0 20]);
mask_pad = padarray(mask_ero1,[0 0 20]);
% R_pad = padarray(R,[0 0 20]);
r=1;
Tik_weight = [1e-3];
TV_weight = 4e-4;
for i = 1:length(Tik_weight)
	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 200);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_200.nii']);
	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 500);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_500.nii']);
	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 2000);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);
	chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 5000);
	nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_5000.nii']);
end
cd ..


mkdir TFS_TIK_PRE_ERO2
cd TFS_TIK_PRE_ERO2
tfs_pad = padarray(iFreq/(2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6),[0 0 20]);
mask_pad = padarray(mask_ero2,[0 0 20]);
% R_pad = padarray(R,[0 0 20]);
r=2;
Tik_weight = [1e-3];
TV_weight = 4e-4;
for i = 1:length(Tik_weight)
	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 200);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_200.nii']);
	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 500);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_500.nii']);
	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 2000);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);
	chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 5000);
	nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_5000.nii']);
end
cd ..


mkdir TFS_TIK_PRE_ERO3
cd TFS_TIK_PRE_ERO3
tfs_pad = padarray(iFreq/(2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6),[0 0 20]);
mask_pad = padarray(mask_ero3,[0 0 20]);
% R_pad = padarray(R,[0 0 20]);

% add a polyfit
tfs_pad_poly = (tfs_pad - poly3d(tfs_pad,mask_pad,2)).*mask_pad;
tfs_pad = tfs_pad_poly;
P = mask_pad + 60*(1 - mask_pad);


r=3;
Tik_weight = [1e-3];
TV_weight = 4e-4;
for i = 1:length(Tik_weight)
	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 200);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_200.nii']);
	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 500);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_500.nii']);
	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 2000);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);
	chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, P, z_prjs, 2000);
	nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	save_nii(nii,['poly2_TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);
end
cd ..


mkdir VSHARP_MEDI_ERO2
cd VSHARP_MEDI_ERO2
padsize = [12 12 12];
smvsize = 12;
RDF = V_SHARP(iFreq ,single(mask),'smvsize',smvsize,'voxelsize',voxel_size);
nii = make_nii(RDF,voxel_size);
save_nii(nii,'vsharp12.nii');
Mask = ones(size(mask));
Mask(RDF == 0) = 0;
save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
     voxel_size delta_TE CF B0_dir;
% run part of MEDI first
QSM = MEDI_L1('lambda',1000);
nii = make_nii(QSM.*Mask,voxel_size);
save_nii(nii,'MEDI_VSHARP_12_ero2.nii');
cd ..


mkdir VSHARP_MEDI_ERO3
cd VSHARP_MEDI_ERO3
padsize = [12 12 12];
smvsize = 12;
RDF = V_SHARP(iFreq ,single(mask_ero1),'smvsize',smvsize,'voxelsize',voxel_size);
nii = make_nii(RDF,voxel_size);
save_nii(nii,'vsharp12.nii');
Mask = ones(size(mask));
Mask(RDF == 0) = 0;
save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
     voxel_size delta_TE CF B0_dir;
% run part of MEDI first
QSM = MEDI_L1('lambda',1000);
nii = make_nii(QSM.*Mask,voxel_size);
save_nii(nii,'MEDI_VSHARP_12_ero3.nii');
cd ..


mkdir ESHARP_MEDI_ERO0
cd ESHARP_MEDI_ERO0
iFreq_odd = padarray(iFreq,[1 1 1],'post');
mask_odd = padarray(mask,[1 1 1],'post');
iFreq_odd = iFreq_odd.*mask_odd;
%% Processing... (1) Determine SMV
sharpOptions.radii              = [ 6 6 3 ] ;
sharpOptions.thresholdParameter = 0.000001 ;
gridDimensionVector = size( iFreq_odd ) ;
midPoint            = ( gridDimensionVector + [1 1 1] ) / 2 ;
midPoint            = sub2ind( gridDimensionVector, midPoint(1), midPoint(2), midPoint(3) ) ;
reducedROI          = shaver( mask_odd, sharpOptions.radii ) ;
sphere                  = createellipsoid( gridDimensionVector, sharpOptions.radii) ;
numAveragingPoints      = sum( sphere(:) ) ;
sharpFilter             = - sphere / numAveragingPoints ;
sharpFilter( midPoint ) = sharpFilter( midPoint ) + 1 ;
FFTSharpFilter = fftc( sharpFilter ) ;
% Deconv.
tmp            = fftc( reducedROI .* ifftc( fftc( sharpFilter ) .* fftc( iFreq_odd ) ) ) ./ FFTSharpFilter ;
% Regularization
tmpReg         = FFTSharpFilter < sharpOptions.thresholdParameter ;
tmp( tmpReg )  = 0 ;
localPhaseNoSVD       = reducedROI .* real( ifftc( tmp ) );
backgroundPhaseNoSVD  = reducedROI .* (iFreq_odd - localPhaseNoSVD) ;
%% (3) TAYLOR
taylorOptions.name                = strcat(pwd, 'inVivo') ;
taylorOptions.isSavingInterimVar  = 'true' ;
taylorOptions.voxelSize           =  voxel_size;
taylorOptions.expansionOrder      = 2 ;
taylorOptions.numIterations       = 1 ;
taylorOptions.numCPU              = 1 ;
EdgeOut  = sharpedges( backgroundPhaseNoSVD, mask_odd, reducedROI, taylorOptions) ;
%% (4) TSVD
extendedBackgroundPhase = mask_odd .* ( EdgeOut.reducedBackgroundField + EdgeOut.extendedBackgroundField(:,:,:,3) ) ;
tmpLocal       = mask_odd .* ( iFreq_odd - extendedBackgroundPhase ) ;
fTmpLocal      = fftc( tmpLocal ) ;
% Regularization
sharpOptions.thresholdParameter = 0.05 ;
tmpReg         = FFTSharpFilter < sharpOptions.thresholdParameter ;
fTmpLocal( tmpReg )  = 0 ;
localPhaseEsharp = mask_odd .* ifftc( fTmpLocal) ;
RDF = localPhaseEsharp(1:end-1,1:end-1,1:end-1);
nii = make_nii(localPhaseEsharp,voxel_size);
save_nii(nii,'ESHARP.nii');

Mask = ones(size(mask));
Mask(RDF == 0) = 0;
save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
     voxel_size delta_TE CF B0_dir;
% run part of MEDI first
QSM = MEDI_L1('lambda',1000);
nii = make_nii(QSM.*Mask,voxel_size);
save_nii(nii,'MEDI_ESHARP_ERO0.nii');
cd ..


mkdir ESHARP_MEDI_ERO1
cd ESHARP_MEDI_ERO1
iFreq_odd = padarray(iFreq,[1 1 1],'post');
mask_odd = padarray(mask_ero1,[1 1 1],'post');
iFreq_odd = iFreq_odd.*mask_odd;
%% Processing... (1) Determine SMV
sharpOptions.radii              = [ 6 6 3 ] ;
sharpOptions.thresholdParameter = 0.000001 ;
gridDimensionVector = size( iFreq_odd ) ;
midPoint            = ( gridDimensionVector + [1 1 1] ) / 2 ;
midPoint            = sub2ind( gridDimensionVector, midPoint(1), midPoint(2), midPoint(3) ) ;
reducedROI          = shaver( mask_odd, sharpOptions.radii ) ;
sphere                  = createellipsoid( gridDimensionVector, sharpOptions.radii) ;
numAveragingPoints      = sum( sphere(:) ) ;
sharpFilter             = - sphere / numAveragingPoints ;
sharpFilter( midPoint ) = sharpFilter( midPoint ) + 1 ;
FFTSharpFilter = fftc( sharpFilter ) ;
% Deconv.
tmp            = fftc( reducedROI .* ifftc( fftc( sharpFilter ) .* fftc( iFreq_odd ) ) ) ./ FFTSharpFilter ;
% Regularization
tmpReg         = FFTSharpFilter < sharpOptions.thresholdParameter ;
tmp( tmpReg )  = 0 ;
localPhaseNoSVD       = reducedROI .* real( ifftc( tmp ) );
backgroundPhaseNoSVD  = reducedROI .* (iFreq_odd - localPhaseNoSVD) ;
%% (3) TAYLOR
taylorOptions.name                = strcat(pwd, 'inVivo') ;
taylorOptions.isSavingInterimVar  = 'true' ;
taylorOptions.voxelSize           =  voxel_size;
taylorOptions.expansionOrder      = 2 ;
taylorOptions.numIterations       = 1 ;
taylorOptions.numCPU              = 1 ;
EdgeOut  = sharpedges( backgroundPhaseNoSVD, mask_odd, reducedROI, taylorOptions) ;
%% (4) TSVD
extendedBackgroundPhase = mask_odd .* ( EdgeOut.reducedBackgroundField + EdgeOut.extendedBackgroundField(:,:,:,3) ) ;
tmpLocal       = mask_odd .* ( iFreq_odd - extendedBackgroundPhase ) ;
fTmpLocal      = fftc( tmpLocal ) ;
% Regularization
sharpOptions.thresholdParameter = 0.05 ;
tmpReg         = FFTSharpFilter < sharpOptions.thresholdParameter ;
fTmpLocal( tmpReg )  = 0 ;
localPhaseEsharp = mask_odd .* ifftc( fTmpLocal) ;
RDF = localPhaseEsharp(1:end-1,1:end-1,1:end-1);
nii = make_nii(localPhaseEsharp,voxel_size);
save_nii(nii,'ESHARP.nii');

Mask = ones(size(mask_ero1));
Mask(RDF == 0) = 0;
save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
     voxel_size delta_TE CF B0_dir;
% run part of MEDI first
QSM = MEDI_L1('lambda',1000);
nii = make_nii(QSM.*Mask,voxel_size);
save_nii(nii,'MEDI_ESHARP_ERO1.nii');
cd ..



mkdir ESHARP_MEDI_ERO2
cd ESHARP_MEDI_ERO2
iFreq_odd = padarray(iFreq,[1 1 1],'post');
mask_odd = padarray(mask_ero2,[1 1 1],'post');
iFreq_odd = iFreq_odd.*mask_odd;
%% Processing... (1) Determine SMV
sharpOptions.radii              = [ 6 6 3 ] ;
sharpOptions.thresholdParameter = 0.000001 ;
gridDimensionVector = size( iFreq_odd ) ;
midPoint            = ( gridDimensionVector + [1 1 1] ) / 2 ;
midPoint            = sub2ind( gridDimensionVector, midPoint(1), midPoint(2), midPoint(3) ) ;
reducedROI          = shaver( mask_odd, sharpOptions.radii ) ;
sphere                  = createellipsoid( gridDimensionVector, sharpOptions.radii) ;
numAveragingPoints      = sum( sphere(:) ) ;
sharpFilter             = - sphere / numAveragingPoints ;
sharpFilter( midPoint ) = sharpFilter( midPoint ) + 1 ;
FFTSharpFilter = fftc( sharpFilter ) ;
% Deconv.
tmp            = fftc( reducedROI .* ifftc( fftc( sharpFilter ) .* fftc( iFreq_odd ) ) ) ./ FFTSharpFilter ;
% Regularization
tmpReg         = FFTSharpFilter < sharpOptions.thresholdParameter ;
tmp( tmpReg )  = 0 ;
localPhaseNoSVD       = reducedROI .* real( ifftc( tmp ) );
backgroundPhaseNoSVD  = reducedROI .* (iFreq_odd - localPhaseNoSVD) ;
%% (3) TAYLOR
taylorOptions.name                = strcat(pwd, 'inVivo') ;
taylorOptions.isSavingInterimVar  = 'true' ;
taylorOptions.voxelSize           =  voxel_size;
taylorOptions.expansionOrder      = 2 ;
taylorOptions.numIterations       = 1 ;
taylorOptions.numCPU              = 1 ;
EdgeOut  = sharpedges( backgroundPhaseNoSVD, mask_odd, reducedROI, taylorOptions) ;
%% (4) TSVD
extendedBackgroundPhase = mask_odd .* ( EdgeOut.reducedBackgroundField + EdgeOut.extendedBackgroundField(:,:,:,3) ) ;
tmpLocal       = mask_odd .* ( iFreq_odd - extendedBackgroundPhase ) ;
fTmpLocal      = fftc( tmpLocal ) ;
% Regularization
sharpOptions.thresholdParameter = 0.05 ;
tmpReg         = FFTSharpFilter < sharpOptions.thresholdParameter ;
fTmpLocal( tmpReg )  = 0 ;
localPhaseEsharp = mask_odd .* ifftc( fTmpLocal) ;
RDF = localPhaseEsharp(1:end-1,1:end-1,1:end-1);
nii = make_nii(localPhaseEsharp,voxel_size);
save_nii(nii,'ESHARP.nii');

Mask = ones(size(mask_ero2));
Mask(RDF == 0) = 0;
save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
     voxel_size delta_TE CF B0_dir;
% run part of MEDI first
QSM = MEDI_L1('lambda',1000);
nii = make_nii(QSM.*Mask,voxel_size);
save_nii(nii,'MEDI_ESHARP_ERO2.nii');
cd ..




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% change the RESHARP parameter? 1e-6?
mkdir TFS_RESHARP_ERO2_iLSQR
cd TFS_RESHARP_ERO2_iLSQR
% (8) MEDI eroded brain with RESHARP (2 voxels erosion)
[RDF, mask_resharp] = resharp(iFreq,mask,vox,2,1e-6,200);
nii = make_nii(RDF,voxel_size);
save_nii(nii,'resharp_1e-6.nii');
% Mask = mask_resharp;
% save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
%      voxel_size delta_TE CF B0_dir;
% % run part of MEDI first
% QSM = MEDI_L1('lambda',1000);
% nii = make_nii(QSM.*Mask,vox);
% save_nii(nii,'MEDI_RESHARP_1e-6_ero2.nii');

%%%%%%%% (2) iLSQR %%%%%%%%%
chi_iLSQR = QSM_iLSQR(RDF,mask_resharp,'H',z_prjs,'voxelsize',vox,'niter',50,'TE',1000*delta_TE,'B0',dicom_info.MagneticFieldStrength);
nii = make_nii(chi_iLSQR,vox);
save_nii(nii,['chi_resharp_iLSQR_ero2.nii']);
cd ..


%% change the RESHARP parameter? 1e-6?
mkdir TFS_RESHARP_ERO3_iLSQR
cd TFS_RESHARP_ERO3_iLSQR
% (9) MEDI eroded brain with RESHARP (3 voxels erosion)
[RDF, mask_resharp] = resharp(iFreq,mask,vox,3,1e-6,200);
nii = make_nii(RDF,voxel_size);
save_nii(nii,'resharp_1e-6.nii');
% Mask = mask_resharp;
% save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
%      voxel_size delta_TE CF B0_dir;
% % run part of MEDI first
% QSM = MEDI_L1('lambda',1000);
% nii = make_nii(QSM.*Mask,vox);
% save_nii(nii,'MEDI_RESHARP_1e-6_ero3.nii');

%%%%%%%% (2) iLSQR %%%%%%%%%
chi_iLSQR = QSM_iLSQR(RDF,mask_resharp,'H',z_prjs,'voxelsize',vox,'niter',50,'TE',1000*delta_TE,'B0',dicom_info.MagneticFieldStrength);
nii = make_nii(chi_iLSQR,vox);
save_nii(nii,['chi_resharp_iLSQR_ero3.nii']);
cd ..

