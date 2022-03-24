%% This demo shows the complete reconstruction pipeline for iQSM on Multi-echo MRI phase data
%% Assume your raw phase data is in NIFTI format


% (1) download or clone github repo for deepMRI: https://github.com/sunhongfu/deepMRI
% (2) download demo data and checkpoints here: https://www.dropbox.com/sh/9kmbytgf3jpj7bh/AACUZJ1KlJ1AFCPMIVyRFJi5a?dl=0

clear 
clc

for echo = 1:4
    nii = load_untouch_nii(['/Volumes/LaCie_Top/AHEAD/Mp2rageme/sub-091_ses-1_acq-wb_inv-2_echo-' num2str(echo) '_part-mag_mprage.nii']);
    mag(:,:,:,echo) = double(nii.img +32768);
    nii = load_untouch_nii(['/Volumes/LaCie_Top/AHEAD/Mp2rageme/sub-091_ses-1_acq-wb_inv-2_echo-' num2str(echo) '_part-ph_mprage.nii']);
    ph(:,:,:,echo) = double(nii.img); 
end
ph = 2*pi.*(ph - min(ph(:)))/(max(ph(:)) - min(ph(:))) - pi;


% load in the ph after offset correction
% load /Users/uqhsun8/Desktop/recon/qsm_highres_mp2rageme_poem/src/mag_ph.mat


for echo = 1:4
    nii.img = real(mag(:,:,:,echo).*exp(1j*ph(:,:,:,echo)));
    save_untouch_nii(nii,['real_e' num2str(echo) '.nii']);
    nii.img = imag(mag(:,:,:,echo).*exp(1j*ph(:,:,:,echo)));
    save_untouch_nii(nii,['imag_e' num2str(echo) '.nii']);
end

% reslice the nifti to scanner coordinate according to affine in the header
voxel_size = [1 1 1];
% voxel_size = [0.65 0.65 0.65];

for echo = 1:4
    nii_real = reslice_nii(['real_e' num2str(echo) '.nii'], voxel_size);
    nii_imag = reslice_nii(['imag_e' num2str(echo) '.nii'], voxel_size);
    img_resliced(:,:,:,echo) = nii_real.img + 1j*nii_imag.img;
end

nii = make_nii(abs(img_resliced),voxel_size);
save_nii(nii,'mag_resliced.nii');

nii = make_nii(angle(img_resliced),voxel_size);
save_nii(nii,'ph_resliced.nii');



nii = make_nii(abs(img_resliced(:,:,:,1)), voxel_size);
save_nii(nii,'mag1.nii');

unix('bet2 mag1.nii BET -f 0.4 -m');
% set a lower threshold for postmortem
% unix('bet2 mag1_sos.nii BET -f 0.1 -m');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);

% try not giving mask
% mask = ones(size(img_resliced(:,:,:,1)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data preparation guide: 

% 1. phase evolution type:
% The relationship between the phase data and filed pertubation (delta_B) 
% is assumed to satisfy the following equation: 
% "phase = -delta_B * gamma * TE" 
% Therefore, if your phase data is in the format of "phase = delta_B * gamma * TE;" 
% it will have to be preprocessed by multiplication by -1; 

% 2. For Ultra-high resolutin data:
% it is recommended that the phase data of ultra-high resolution (higher
% than 0.7 mm) should be interpoloated into 1 mm for better reconstruction results.  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set your own data paths and parameters
deepMRI_root = '/Users/uqhsun8/code/deepMRI'; % where deepMRI git repo is downloaded/cloned to
checkpoints_dir  = '/Users/uqhsun8/SunLab Dropbox/Admins Only/github/deepMRI_data/iQSM_data/checkpoints';
  % where raw phase data is (in NIFTI format)
ReconDir     = '/Users/uqhsun8/Desktop/iqsm_demo_recon_masked_noiselayer_learnable/';  %% where to save reconstruction output
Eroded_voxel = 3;  %  set number of voxels for brain mask erosion; 0 means no erosion;
TE           = [0.0030    0.0115    0.0190    0.0285]; % set Echo Times (in second)
B0           = 7; % set B0 field (in Tesla)
vox          = voxel_size; % set voxel size a.k.a image resolution (in millimeter)
NetworkType  = 0; % network type: 0 for original iQSM, 1 for networks trained with data fidelity,
                  % 2 for networks trained with learnable Lap-Layer (15 learnable kernels) and data fidelity;


%% add MATLAB paths
addpath(genpath([deepMRI_root,'/iQSM/iQSM_fcns/']));  % add necessary utility function for saving data and echo-fitting;
addpath(genpath([deepMRI_root,'/utils']));  %  add NIFTI saving and loading functions;

phase = -angle(img_resliced);
mag = abs(img_resliced);

imsize = size(mag)



%% mkdir for output folders
if ~exist(ReconDir, 'dir')
    mkdir(ReconDir)
end


[mask, pos] = ZeroPadding(mask, 16);

%% set inference.py path; 
switch NetworkType 
    case 0
        InferencePath = [deepMRI_root, '/iQSM/PythonCodes/Evaluation/Inference_16Learnable_noise_DF.py']; 
        checkpoints = [checkpoints_dir, '/noise_layer_learnable'];
    case 1
        InferencePath = [deepMRI_root, '/iQSM/PythonCodes/Evaluation/DataFidelityVersion/Inference.py'];
        checkpoints = [checkpoints_dir, '/iQSM_iQFM_DataFidelity']; 
    case 2
        InferencePath = [deepMRI_root, '/iQSM/PythonCodes/Evaluation/LearnableLapLayer/Inference.py'];
        checkpoints = [checkpoints_dir, '/noise_layer_learnable']; 
end 

for echo_num = 1 : imsize(4)
    
    %% 2. save all information (B0, TE, phase) as .mat file for Network Reconstruction echo by echo
    tmp_TE = TE(echo_num);
    tmp_phase = phase(:,:,:,echo_num);
    
    tmp_phase = ZeroPadding(tmp_phase, 16);
    
    mask_eroded = Save_Input(tmp_phase, mask, tmp_TE, B0, Eroded_voxel, ReconDir);
    
    % Call Python script to conduct the reconstruction; use python API to run iQSM on the demo data
    PythonRecon(InferencePath, [ReconDir,'/Network_Input.mat'], ReconDir, checkpoints);
    
    %% load reconstruction data and save as NIFTI
    load([ReconDir,'/iQSM.mat']);
    load([ReconDir,'/iQFM.mat']);
    
    pred_chi = ZeroRemoving(pred_chi, pos);
    pred_lfs = ZeroRemoving(pred_lfs, pos);
    
    chi(:,:,:,echo_num) = pred_chi;
    lfs(:,:,:,echo_num) = pred_lfs;
    
    clear tmp_phase;
end



%% save results of all echoes before echo fitting
nii = make_nii(chi, vox);
save_nii(nii, [ReconDir, 'iQSM_all_echoes.nii']);

nii = make_nii(lfs, vox);
save_nii(nii, [ReconDir, 'iQFM_all_echoes.nii']);




%% magnitude weighted echo-fitting and save as NIFTI

for echo_num = 1 : imsize(4)
    chi(:,:,:,echo_num) = TE(echo_num) .* chi(:,:,:,echo_num);
    lfs(:,:,:,echo_num) = TE(echo_num) .* lfs(:,:,:,echo_num);
end

chi_fitted = echofit(chi, mag, TE);
lfs_fitted = echofit(lfs, mag, TE);


nii = make_nii(chi_fitted, vox);
save_nii(nii, [ReconDir,'/iQSM_echo_fitted.nii']);

nii = make_nii(lfs_fitted, vox);
save_nii(nii, [ReconDir,'/iQFM_echo_fitted.nii']);


delete([ReconDir,'/Network_Input.mat']);
delete([ReconDir,'/iQFM.mat']);
delete([ReconDir,'/iQSM.mat']);
