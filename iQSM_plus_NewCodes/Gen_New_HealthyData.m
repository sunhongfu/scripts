
clear
clc
%% addpath for utilities
addpath ./utils/

datasize = 96 * 5 * 6 * 5;

%% set folders
lfs_Folder = 'lfs_training';
wph_Folder = 'wph_training';
mask_Folder = 'mask_training';
TE_Folder = 'TE_training';
zprjs_Folder = 'z_prjs_training';

vox_Folder = 'vox_training'; 

mkdir(lfs_Folder)
mkdir(wph_Folder )
mkdir(mask_Folder)
mkdir(TE_Folder)

%% default parameters;
B0 = 3; % tesla
gamma = 267.52; % gyro ratio: rad/s/T

%% label dataset;

%% generating input data;
for FileNo = 1 : 4 * datasize
    
    load(sprintf('./vox_training/vox_patch_%d.mat', FileNo)); 
    load(sprintf('z_prjs_training/z_prjs_%d.mat', FileNo)); 
    
    z_prjs
    vox

    chi_name = sprintf('./qsm_training/chi_patch_%d.mat', FileNo);
    load(chi_name);
    chi = chi_patch;
    clear chi_patch;

    bkg_name = sprintf('./bkg_training/bkg_patch_%d.mat', FileNo);
    load(bkg_name);
    bkg = bkg_patch;
    clear bkg_patch;

    %% different TEs.
    TE = 20e-3 + 6e-3 * randn(1);

    if TE < 3e-3
        TE = 3e-3;
    elseif TE > 38e-3
        TE = 38e-3;
    end

    BET_mask = chi ~= 0;

    TE_patch = repmat(TE, size(chi));
    save(sprintf('./%s/TE_patch_%d.mat', TE_Folder, FileNo), 'TE_patch');

    lfs_patch = forward_field_calc(chi, vox, z_prjs, 1);
    lfs_patch = lfs_patch .* BET_mask;
    save(sprintf('./%s/lfs_patch_%d.mat', lfs_Folder, FileNo), 'lfs_patch');

    tfs_patch = lfs_patch + bkg;
    %% save(sprintf('./%s/tfs_patch_%d.mat', tfs_Folder, FileNo), 'tfs_patch');
    unwph = -tfs_patch * gamma * B0 * TE; % assume the phase shift equals 0;

    cph = exp(1j * unwph); % converted into complex domain;

    wph = angle(cph);

    wph_patch = wph .* BET_mask;
    save(sprintf('./%s/wph_patch_%d.mat', wph_Folder, FileNo), 'wph_patch');

    Mask_patch = MaskErode(BET_mask, 1);
    save(sprintf('./%s/Mask_patch_%d.mat', mask_Folder, FileNo), 'Mask_patch');

end





