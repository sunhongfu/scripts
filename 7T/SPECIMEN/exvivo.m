% exvivo brain slice
% read in uncombined magnitude and phase images
path_mag = '/gpfs/M2Scratch/NCIgb5/hongfu/exvivo/1.10.2/1.10.2.215/1.10.2.215.1.1/1.10.2.215.1.1.27/dicom_series';
path_ph = '/gpfs/M2Scratch/NCIgb5/hongfu/exvivo/1.10.2/1.10.2.215/1.10.2.215.1.1/1.10.2.215.1.1.28/dicom_series';
path_out = '/gpfs/M2Scratch/NCIgb5/hongfu/exvivo/1.10.2/1.10.2.215/1.10.2.215.1.1/';

%% read in DICOMs of both uncombined magnitude and raw unfiltered phase images
%
path_mag = cd(cd(path_mag));
mag_list = dir([path_mag '/*.dcm']);
mag_list = mag_list(~strncmpi('.', {mag_list.name}, 1));
path_ph = cd(cd(path_ph));
ph_list = dir([path_ph '/*.dcm']);
ph_list = ph_list(~strncmpi('.', {ph_list.name}, 1));

% number of slices (mag and ph should be the same)
nSL = length(ph_list);

% get the sequence parameters
EchoTrainLength = 7; % this number is wrong in DICOM header
for i = 1:nSL/EchoTrainLength:nSL % read in TEs
    dicom_info = dicominfo([path_ph,filesep,ph_list(i).name]);
    TE(dicom_info.EchoNumber) = dicom_info.EchoTime*1e-3;
end
vox = [dicom_info.PixelSpacing(1), dicom_info.PixelSpacing(2), dicom_info.SliceThickness];

% angles (z projections of the image x y z coordinates) 
Xz = dicom_info.ImageOrientationPatient(3);
Yz = dicom_info.ImageOrientationPatient(6);
Zxyz = cross(dicom_info.ImageOrientationPatient(1:3),dicom_info.ImageOrientationPatient(4:6));
Zz = Zxyz(3);
z_prjs = [Xz, Yz, Zz];

% read in measurements
mag = zeros(dicom_info.Rows,dicom_info.Columns,nSL,'single');
ph = zeros(dicom_info.Rows,dicom_info.Columns,nSL,'single');
for i = 1:nSL
    mag(:,:,i) = single(dicomread([path_mag,filesep,mag_list(i).name]));
    ph(:,:,i) = single(dicomread([path_ph,filesep,ph_list(i).name]));
end

% reshape into 4 echoes
mag = reshape(mag,double(dicom_info.Rows),double(dicom_info.Columns),[],EchoTrainLength);
mag = permute(mag,[2 1 3 4]);
ph = reshape(ph,double(dicom_info.Rows),double(dicom_info.Columns),[],EchoTrainLength);
ph = permute(ph,[2 1 3 4]);
% 0028,0106  Smallest Image Pixel Value: 0
% 0028,0107  Largest Image Pixel Value: 4094
% conver scale to -pi to pi
ph = 2*pi.*(ph - single(dicom_info.SmallestImagePixelValue))./(single(dicom_info.LargestImagePixelValue - dicom_info.SmallestImagePixelValue)) - pi;

imsize = size(ph);

% define output directories
path_qsm = [path_out '/QSM_EXVIVO_7T'];
mkdir(path_qsm);
init_dir = pwd;
cd(path_qsm);
% save the raw data for future use
save('raw.mat','-v7.3');




% BEGIN THE QSM RECON PIPELINE
% initial quick brain mask
% simple sum-of-square combination
nii = make_nii(mag(:,:,:,1),vox);
save_nii(nii,'mag1.nii');
unix('bet2 mag1.nii BET -f 0.15  -m');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);

% % coil combination % smoothing factor 10?
% ph_corr = zeros(imsize(1:4));
% mag_corr = zeros(imsize(1:4));
% [ph_corr(:,:,:,1:2:end),mag_corr(:,:,:,1:2:end)] = geme_cmb(mag(:,:,:,1:2:end,:).*exp(1j*ph(:,:,:,1:2:end,:)),vox,TE(1:2:end),mask);
% [ph_corr(:,:,:,2:2:end),mag_corr(:,:,:,2:2:end)] = geme_cmb(mag(:,:,:,2:2:end,:).*exp(1j*ph(:,:,:,2:2:end,:)),vox,TE(2:2:end),mask);
% [ph_corr,mag_corr] = geme_cmb(mag.*exp(1j*ph),vox,TE,mask);
ph_corr = ph;
mag_corr = mag;

% save niftis after coil combination
mkdir('src');
for echo = 1:imsize(4)
    nii = make_nii(mag_corr(:,:,:,echo),vox);
    save_nii(nii,['src/mag_corr' num2str(echo) '.nii']);
    nii = make_nii(ph_corr(:,:,:,echo),vox);
    save_nii(nii,['src/ph_corr' num2str(echo) '.nii']);
end

save('raw.mat','ph_corr','mag_corr','mask','-append');





% (1) unwrap the phase using best path
disp('--> unwrap aliasing phase using bestpath...');
mask_unwrp = uint8(abs(mask)*255);
fid = fopen('mask_unwrp.dat','w');
fwrite(fid,mask_unwrp,'uchar');
fclose(fid);

[pathstr, ~, ~] = fileparts(which('3DSRNCP.m'));
setenv('pathstr',pathstr);
setenv('nv',num2str(imsize(1)));
setenv('np',num2str(imsize(2)));
setenv('ns',num2str(imsize(3)));

unph = zeros(imsize(1:4));

for echo_num = 1:imsize(4)
    setenv('echo_num',num2str(echo_num));
    fid = fopen(['wrapped_phase' num2str(echo_num) '.dat'],'w');
    fwrite(fid,ph_corr(:,:,:,echo_num),'float');
    fclose(fid);

    bash_script = ['${pathstr}/3DSRNCP wrapped_phase${echo_num}.dat mask_unwrp.dat ' ...
        'unwrapped_phase${echo_num}.dat $nv $np $ns reliability${echo_num}.dat'];
    unix(bash_script) ;

    fid = fopen(['unwrapped_phase' num2str(echo_num) '.dat'],'r');
    tmp = fread(fid,'float');
    % tmp = tmp - tmp(1);
    unph(:,:,:,echo_num) = reshape(tmp - round(mean(tmp(mask==1))/(2*pi))*2*pi ,imsize(1:3)).*mask;
    fclose(fid);
end

nii = make_nii(unph,vox);
save_nii(nii,'unph_bestpath_before_jump_correction.nii');

% remove all the temp files
! rm *.dat


% 2pi jumps correction
nii = load_nii('unph_diff.nii');
unph_diff = double(nii.img);
unph_diff = unph_diff/2;
for echo = 2:imsize(4)
    meandiff = unph(:,:,:,echo)-unph(:,:,:,1)-double(echo-1)*unph_diff;
    meandiff = meandiff(mask==1);
    meandiff = mean(meandiff(:));
    njump = round(meandiff/(2*pi));
    disp(['    ' num2str(njump) ' 2pi jumps for TE' num2str(echo)]);
    unph(:,:,:,echo) = unph(:,:,:,echo) - njump*2*pi;
    unph(:,:,:,echo) = unph(:,:,:,echo).*mask;
end
nii = make_nii(unph,vox);
save_nii(nii,'unph_bestpath.nii');



% set parameters
fit_thr = 50;
smv_rad = 1;
tik_reg = 1e-6;
cgs_num = 500;
tv_reg = 2e-4;
inv_num = 1000;



% fit phase images with echo times
disp('--> magnitude weighted LS fit of phase to TE ...');
[tfs_1, fit_residual_1] = echofit(unph,mag_corr,TE,1); 
% normalize to main field
% ph = gamma*dB*TE
% dB/B = ph/(gamma*TE*B0)
% units: TE s, gamma 2.675e8 rad/(sT), B0 7T
tfs_1 = tfs_1/(2.675e8*dicom_info.MagneticFieldStrength)*1e6; % unit ppm
nii = make_nii(tfs_1,vox);
save_nii(nii,'tfs_1.nii');

% extra filtering according to fitting residuals
% generate reliability map
fit_residual_1_blur = smooth3(fit_residual_1,'box',round(1./vox)*2+1); 
nii = make_nii(fit_residual_1_blur,vox);
save_nii(nii,'fit_residual_1_blur.nii');
R_1 = ones(size(fit_residual_1_blur));
R_1(fit_residual_1_blur >= fit_thr) = 0;


% RE-SHARP (tik_reg: Tikhonov regularization parameter)
disp('--> RESHARP to remove background field ...');
[lfs_resharp_1, mask_resharp_1] = resharp(tfs_1,mask.*R_1,vox,smv_rad,tik_reg,cgs_num);
% % 3D 2nd order polyfit to remove any residual background
% lfs_resharp= (lfs_resharp - poly3d(lfs_resharp,mask_resharp)).*mask_resharp;

% save nifti
mkdir('RESHARP');
nii = make_nii(lfs_resharp_1,vox);
save_nii(nii,'RESHARP/lfs_resharp_1_ero4.nii');


% iLSQR
chi_iLSQR_0 = QSM_iLSQR(lfs_resharp_1*(2.675e8*dicom_info.MagneticFieldStrength)/1e6,mask_resharp_1,'H',z_prjs,'voxelsize',vox,'niter',30,'TE',1000,'B0',dicom_info.MagneticFieldStrength);
nii = make_nii(chi_iLSQR_1,vox);
save_nii(nii,'RESHARP/chi_iLSQR_1_30_ero4.nii');




% complex fitting without unwrapping of each echo
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

% unwrap the iFreq_raw
nii = make_nii(iFreq_raw,vox);
save_nii(nii,'iFreq_raw.nii');


% unwrap the phase using best path
disp('--> unwrap aliasing phase using bestpath...');
mask_unwrp = uint8(abs(mask)*255);
fid = fopen('mask_unwrp.dat','w');
fwrite(fid,mask_unwrp,'uchar');
fclose(fid);

[pathstr, ~, ~] = fileparts(which('3DSRNCP.m'));
setenv('pathstr',pathstr);
setenv('nv',num2str(imsize(1)));
setenv('np',num2str(imsize(2)));
setenv('ns',num2str(imsize(3)));

unph = zeros(imsize(1:3));

fid = fopen(['wrapped_phase.dat'],'w');
fwrite(fid,iFreq_raw,'float');
fclose(fid);

bash_script = ['${pathstr}/3DSRNCP wrapped_phase.dat mask_unwrp.dat ' ...
    'unwrapped_phase.dat $nv $np $ns reliability.dat'];
unix(bash_script) ;

fid = fopen('unwrapped_phase.dat','r');
tmp = fread(fid,'float');
% tmp = tmp - tmp(1);
unph = reshape(tmp - round(mean(tmp(mask==1))/(2*pi))*2*pi ,imsize(1:3)).*mask;
fclose(fid);

nii = make_nii(unph,vox);
save_nii(nii,'unph_ppm_fit.nii');

tfs = unph./(2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6);
nii = make_nii(tfs,vox);
save_nii(nii,'tfs.nii');



smv_rad = 4;
tik_reg = 1e-6;
cgs_num = 100;
% RE-SHARP (tik_reg: Tikhonov regularization parameter)
disp('--> RESHARP to remove background field ...');
[lfs_resharp_0, mask_resharp_0] = resharp(tfs,mask,vox,smv_rad,tik_reg,cgs_num);
% % 3D 2nd order polyfit to remove any residual background
% lfs_resharp= (lfs_resharp - poly3d(lfs_resharp,mask_resharp)).*mask_resharp;

% save nifti
mkdir('RESHARP');
nii = make_nii(lfs_resharp_0,vox);
save_nii(nii,'RESHARP/lfs_resharp_0_ero4.nii');




% (2) unwrap the phase using PRELUDE
setenv('echo_num',num2str(imsize(4)));
bash_command = sprintf(['for ph in src/ph_corr[1-$echo_num].nii\n' ...
'do\n' ...
'   base=`basename $ph`;\n' ...
'   dir=`dirname $ph`;\n' ...
'   mag=$dir/"mag_corr"${base:7};\n' ...
'   unph="unph"${base:7};\n' ...
'   prelude -a $mag -p $ph -u $unph -m BET_mask.nii -n 12&\n' ...
'done\n' ...
'wait\n' ...
'gunzip -f unph*.gz\n']);
unix(bash_command);

unph = zeros(imsize(1:4));
for echo = 1:imsize(4)
    nii = load_nii(['unph' num2str(echo) '.nii']);
    unph(:,:,:,echo) = double(nii.img);
end

nii = make_nii(unph,vox);
save_nii(nii,'unph_PRELUDE_before_jump_correction.nii');

unph_prelude = unph;


% perform inversion on each individual echo
tfs_resharp = zeros(imsize(1:4));
chi_iLSQR = zeros(imsize(1:4));
for i = 1:imsize(4)
    % RE-SHARP (tik_reg: Tikhonov regularization parameter)
    disp('--> RESHARP to remove background field ...');
    [tfs_resharp(:,:,:,i), mask_resharp] = resharp(unph(:,:,:,i),mask,vox,smv_rad,tik_reg,cgs_num);

    % iLSQR
    chi_iLSQR(:,:,:,i) = QSM_iLSQR(tfs_resharp(:,:,:,i),mask_resharp,'H',z_prjs,'voxelsize',vox,'niter',30,'TE',1000*TE(i),'B0',dicom_info.MagneticFieldStrength);
    nii = make_nii(chi_iLSQR(:,:,:,i),vox);
    save_nii(nii,['RESHARP/chi_iLSQR_30' 'e' num2str(i) '.nii']);
end



