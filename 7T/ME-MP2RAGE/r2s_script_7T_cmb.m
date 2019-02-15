mag_cmb='/home/hongfu/cj97_scratch/hongfu/ME-MP2RAGE/Sun/1.7.72/1.7.72.14/1.7.72.14.1.1/1.7.72.14.1.1.22/dicom_series';

setenv('mag_cmb',mag_cmb);

!/home/hongfu/mricrogl_lx/dcm2niix $mag_cmb

cd(mag_cmb);

% load in the nifti
for echo = 1:4
    nii = load_untouch_nii(['UNIDEN_comboecho_e' num2str(echo) '.nii']);
    mag(:,:,:,echo) = single(nii.img);
end

for echo = 1:9
    nii = load_untouch_nii(['UNIDEN_comboecho_e' num2str(echo) '.nii']);
    mag(:,:,:,echo) = single(nii.img);
end


% flip second dimension
mag = flipdim(mag,2);

path_mag = mag_cmb;

%% read in DICOMs of both uncombined magnitude and raw unfiltered phase images
path_mag = cd(cd(path_mag));
mag_list = dir([path_mag '/*.dcm']);
mag_list = mag_list(~strncmpi('.', {mag_list.name}, 1));

% number of total slices 
nSL = length(mag_list);

% get the sequence parameters
dicom_info = dicominfo([path_mag,filesep,mag_list(end).name]);
NumberOfEchoes = dicom_info.EchoNumber; 

% get the sequence parameters
for i = 1:nSL/NumberOfEchoes:nSL % read in TEs
    dicom_info = dicominfo([path_mag,filesep,mag_list(i).name]);
    TE(dicom_info.EchoNumber) = dicom_info.EchoTime*1e-3;
end
vox = [dicom_info.PixelSpacing(1), dicom_info.PixelSpacing(2), dicom_info.SliceThickness];
imsize = size(mag);

cd ..

nii = make_nii(mag(:,:,:,1),vox);
save_nii(nii,'mag1.nii');

unix('N4BiasFieldCorrection -i mag1.nii -o mag1_n4.nii');

unix('bet2 mag1_n4.nii BET -f 0.3 -m');
% set a lower threshold for postmortem
% unix('bet2 mag1_sos.nii BET -f 0.1 -m');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

TE = TE(1:4);

[R2 T2 amp] = r2imgfit(double(mag),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2_4echo.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2_4echo.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp_4echo.nii');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[R2 T2 amp] = r2imgfit(double(mag),TE,repmat(mask,[1 1 1 imsize(4)]));
nii = make_nii(R2,vox);
save_nii(nii,'R2.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp.nii');
