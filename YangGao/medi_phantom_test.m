nii = load_nii('label_newPH.nii');
sus = double(nii.img);

mask = sus~=0;
mask = double(mask);

nii = load_nii('lfs_SLphantom.nii');
lfs = double(nii.img);

imsize = size(lfs);

% run MEDI
%%%%% normalize signal intensity by noise to get SNR %%%
%%%% Generate the Magnitude image %%%%
iMag = mask;
% iMag = abs(sus);


% [iFreq_raw N_std] = Fit_ppm_complex(ph_corr);
matrix_size = single(imsize);
voxel_size = [1 1 1];
delta_TE = 0.03; % s, doesnt matter in this case, place holder
B0_dir = [0 0 1]';
dicom_info.ImagingFrequency = 127.770289;
CF = dicom_info.ImagingFrequency *1e6;
iFreq = [];
N_std = 1;
dicom_info.MagneticFieldStrength = 3;
RDF = lfs*2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6;
Mask = mask;
save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
     voxel_size delta_TE CF B0_dir;
QSM = MEDI_L1_nomag('lambda',15);
nii = make_nii(QSM.*Mask,voxel_size);
save_nii(nii,'MEDI15.nii');