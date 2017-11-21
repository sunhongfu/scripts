Mask = mask_soft;
Mask_G = Mask;
P_B = 30;
P = 1 * Mask + P_B * (1-Mask);
RDF = 0;
save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF
QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 600*2);
nii = make_nii(QSM,vox);
% save_nii(nii,'TFI_ero3.nii');
save_nii(nii,'TFI_soft.nii');

Mask = mask;
Mask_G = Mask;
P_B = 30;

P = 1 * Mask + P_B * (1-Mask);
RDF = 0;
save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF
QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 600*2);
nii = make_nii(QSM,vox);
% save_nii(nii,'TFI_ero3.nii');
save_nii(nii,'TFI_mask.nii');

Mask = mask_ero;
Mask_G = Mask;
P_B = 30;
P = 1 * Mask + P_B * (1-Mask);
RDF = 0;
save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF
QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 600*2);
nii = make_nii(QSM,vox);
% save_nii(nii,'TFI_ero3.nii');
save_nii(nii,'TFI_mask_ero.nii');
