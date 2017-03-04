% whole head QSM with TFI and LN-QSM

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

nii = load_nii('iFreq_unwrapping_gc.nii');
iFreq = double(nii.img);


mag1 = mag(:,:,:,1);
mask_b = (mag1 > 0.2*median(mag1(logical(mask(:)))));
mask_b = double(mask_b);

nii=make_nii(mask_b,vox);
save_nii(nii,'mask_b.nii');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TFI
mkdir WH_TFI
cd WH_TFI

% Prepare for TFI (whole head)
Mask = mask_b;
P_B = 30;
P = 1 * Mask + P_B * (1-Mask);
% Mask_G = 1 * Mask + 1/P_B * (~Mask & Mask_entirehead);
Mask_G = Mask;

save RDF_wholehead.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq RDF Mask
save RDF_wholehead.mat P Mask_G -append 
QSM = TFI_L1('filename', 'RDF_wholehead.mat', 'lambda', 600*2);

nii = make_nii(QSM.*Mask,vox);
save_nii(nii,'TFI_ero0.nii');
cd ..



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mkdir WH_LNQSM
cd WH_LNQSM
tfs_pad = padarray(iFreq/(2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6),[0 0 20]);
mask_pad = padarray(mask_b,[0 0 20]);
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
	chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 500);
	nii = make_nii(chi(:,:,21:end-20),vox);
	save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_500.nii']);
end
cd ..
