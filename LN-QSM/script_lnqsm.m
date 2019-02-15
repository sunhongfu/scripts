% LN-QSM script
chi = tikhonov_qsm(tfs, 1, 1, mask, mask, 0, 5e-4, 0.001, 0, vox, 30, z_prjs, 500);

% tfs is the total field shift in ppm
% mask is the brain mask from BET
% vox is the voxel size (spatial resolution in mm)
% z_prjs is the coordinate projections onto the main field direction, if acquired pure axial, set to [0 0 1]


% for more options, check out the codes in tikhonov_qsm.m
