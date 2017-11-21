% whole head QSM with TFI and LN-QSM

load all.mat
% use Cornell's complex fitting + spurs unwrapping
% iField = mag.*exp(1i*ph_corr);
iField = mag.*exp(1i*ph);
%%%%% provide a noise_level here if possible %%%%%%
if (~exist('noise_level','var'))
    noise_level = calfieldnoise(iField, mask);
end
%%%%% normalize signal intensity by noise to get SNR %%%
iField = iField/noise_level;
%%%% Generate the Magnitude image %%%%
iMag = sqrt(sum(abs(iField).^2,4));
[iFreq_raw N_std] = Fit_ppm_complex(iField);
matrix_size = single(size(iMag));
voxel_size = vox;
delta_TE = TE(2) - TE(1);
B0_dir = z_prjs';
CF = dicom_info.ImagingFrequency *1e6;
nii = make_nii(iFreq_raw,voxel_size);
save_nii(nii,'iFreq_raw_nocorr.nii');

% % Spatial phase unwrapping (graph-cut based)
iFreq = unwrapping_gc(iFreq_raw,iMag,voxel_size);
iFreq = iFreq - 4*pi;
nii = make_nii(iFreq,vox);
save_nii(nii,'iFreq_unwrapping_gc.nii');

nii = load_nii('iFreq_unwrapping_gc.nii');
iFreq = double(nii.img);


mag1 = mag(:,:,:,1);
mask_soft = (mag1 > 500);
% mag1 = sqrt(sum(mag.^2,4));
% mask_soft = (mag1 > 2000);
mask_soft = double(mask_soft);

nii=make_nii(mask_soft,vox);
save_nii(nii,'mask_soft.nii');

% fill in the wholes and get entire head
mask_head = MaskFilling(padarray(mask_soft,[0 0 2]), 12);
mask_head = mask_head(:,:,3:end-2);
nii = make_nii(mask_head,vox);
save_nii(nii,'mask_head.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TFI
mkdir WH_TFI
cd WH_TFI

% Prepare for TFI (whole head)
Mask = mask_soft;
P_B = 30;
P = 1 * Mask + P_B * (1-Mask);
Mask_G = 1 * Mask + 1/P_B * (~Mask & mask_head);
% Mask_G = mask_head;
RDF = 0;

save RDF_wholehead.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq RDF Mask
save RDF_wholehead.mat P Mask_G -append 
QSM = TFI_L1('filename', 'RDF_wholehead.mat', 'lambda', 600*2);

nii = make_nii(QSM.*mask_head,vox);
save_nii(nii,'TFI_head_iter20.nii');

Mask = mask; % only brain tissue
Mask_G = Mask;
P_B = 30;
P = 1 * Mask + P_B * (1-Mask);
RDF = 0;
save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF
QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 600*2);
nii = make_nii(QSM.*Mask,vox);
save_nii(nii,'TFI_ero0_brain.nii');

cd ..



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mkdir WH_LNQSM
cd WH_LNQSM
tfs = iFreq/(2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6);
% pad 20 zeros
% tfs_pad = padarray(tfs,[0 0 20]);
% mask_soft_pad = padarray(mask_soft, [0 0 20]);
% mask_head_pad = padarray(mask_head, [0 0 20]);

tfs_pad = tfs;
mask_soft_pad = mask_soft;
mask_head_pad = mask_head;

r=0;
Tik_weight = 0.001;
Tik_weight = 0;
TV_weight = 0.0005;

% normalize the weights
Res_wt = sqrt(sum(mag.^2,4));
Res_wt = padarray(Res_wt, [0 0 20]);
Res_wt = Res_wt.*mask_soft_pad;
% Res_wt = Res_wt/sqrt(sum(Res_wt(:).^2)/numel(Res_wt));
% Res_wt = TV_mask.*Res_wt;
Res_wt = Res_wt/sum(Res_wt(:))*sum(mask_soft_pad(:));


P = 30*(mask_head_pad - mask_soft_pad) + 1 - (mask_head_pad - mask_soft_pad);
% P = 1./P;
% P = 1;
chi = tikhonov_qsm(tfs_pad, Res_wt, 1, mask_head_pad, mask_soft_pad, TV_weight, Tik_weight, vox, P, z_prjs, 300);


nii = make_nii(chi,vox);
save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight) '_soft_1_head_soft_300_outside1_wt_mag_P30.nii']);

cd ..
