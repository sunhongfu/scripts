% PETRA recon

% read in PETRA magnitude and phase
% read in uncombined magnitude and phase images
path_mag = '/home/hongfu/NCIgb5_scratch/Jon_temp_downloads/point75_MP2RAGE_Multiechos/05_JON_H476/WIP635E_PETRA_MAG_UNCOMB';
path_pha = '/home/hongfu/NCIgb5_scratch/Jon_temp_downloads/point75_MP2RAGE_Multiechos/05_JON_H476/WIP635E_PETRA_PHA_UNCOMB';
path_out = '/home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/PETRA';


%% read in DICOMs of both uncombined magnitude and raw unfiltered phase images
path_mag = cd(cd(path_mag));
mag_list = dir([path_mag '/*.dcm']);
mag_list = mag_list(~strncmpi('.', {mag_list.name}, 1));
path_pha = cd(cd(path_pha));
ph_list = dir([path_pha '/*.dcm']);
ph_list = ph_list(~strncmpi('.', {ph_list.name}, 1));

% number of slices (mag and ph should be the same)
nSL = length(ph_list);

% get the sequence parameters
dicom_info = dicominfo([path_pha,filesep,ph_list(end).name]);
NumberOfEchoes = dicom_info.EchoNumber; 

for i = 1:nSL/NumberOfEchoes:nSL % read in TEs
    dicom_info = dicominfo([path_pha,filesep,ph_list(i).name]);
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
    ph(:,:,i) = single(dicomread([path_pha,filesep,ph_list(i).name]));
end


% crop mosaic into individual images
AcqMatrix = regexp(dicom_info.Private_0051_100b,'(\d)*(\d)','match');
if strcmpi(dicom_info.InPlanePhaseEncodingDirection,'COL') % A/P
% phase encoding along column
    wRow = round(str2num(AcqMatrix{1})/dicom_info.PercentSampling*100);
    wCol = str2num(AcqMatrix{2});
else % L/R
    wCol = round(str2num(AcqMatrix{1})/dicom_info.PercentSampling*100);
    wRow = str2num(AcqMatrix{2});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;
% works for square 32 channels (faster)
mag = mat2cell(mag,[wRow wRow wRow wRow wRow wRow], [wCol wCol wCol wCol wCol wCol], nSL);
mag_all = cat(4,mag{1,1}, mag{1,2}, mag{1,3}, mag{1,4}, mag{1,5}, mag{1,6}, mag{2,1}, mag{2,2}, mag{2,3}, mag{2,4}, mag{2,5}, mag{2,6}, mag{3,1}, mag{3,2}, mag{3,3}, mag{3,4}, mag{3,5}, mag{3,6}, mag{4,1}, mag{4,2}, mag{4,3}, mag{4,4}, mag{4,5}, mag{4,6}, mag{5,1}, mag{5,2}, mag{5,3}, mag{5,4}, mag{5,5}, mag{5,6}, mag{6,1}, mag{6,2});
clear mag
mag_all = reshape(mag_all, wRow, wCol, nSL/NumberOfEchoes, NumberOfEchoes, 32);
mag_all = permute(mag_all,[2 1 3 4 5]);

ph = mat2cell(ph,[wRow wRow wRow wRow wRow wRow], [wCol wCol wCol wCol wCol wCol], nSL);
ph_all = cat(4,ph{1,1}, ph{1,2}, ph{1,3}, ph{1,4}, ph{1,5}, ph{1,6}, ph{2,1}, ph{2,2}, ph{2,3}, ph{2,4}, ph{2,5}, ph{2,6}, ph{3,1}, ph{3,2}, ph{3,3}, ph{3,4}, ph{3,5}, ph{3,6}, ph{4,1}, ph{4,2}, ph{4,3}, ph{4,4}, ph{4,5}, ph{4,6}, ph{5,1}, ph{5,2}, ph{5,3}, ph{5,4}, ph{5,5}, ph{5,6}, ph{6,1}, ph{6,2});
clear ph
ph_all = reshape(ph_all, wRow, wCol, nSL/NumberOfEchoes, NumberOfEchoes, 32);
ph_all = permute(ph_all,[2 1 3 4 5]);
ph_all = 2*pi.*(ph_all - single(dicom_info.SmallestImagePixelValue))/(single(dicom_info.LargestImagePixelValue - dicom_info.SmallestImagePixelValue)) - pi;

toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% define output directories
path_qsm = [path_out '/QSM_PETRA_7T'];
mkdir(path_qsm);
init_dir = pwd;
cd(path_qsm);
% save the raw data for future use
clear mag ph
mag_all = squeeze(mag_all);
ph_all = squeeze(ph_all);

imsize = size(ph_all);


nii = make_nii(mag_all,vox);
save_nii(nii,'mag_all.nii');
nii = make_nii(ph_all,vox);
save_nii(nii,'ph_all.nii');

% BEGIN THE QSM RECON PIPELINE
% initial quick brain mask
% simple sum-of-square combination
mag_sos = sqrt(sum(mag_all.^2,4));
nii = make_nii(mag_sos,vox);
save_nii(nii,'mag_sos.nii');

unix('N4BiasFieldCorrection -i mag_sos.nii -o mag_sos_n4.nii');

% save in real and imaginary parts
for i = 1:imsize(4)
	nii = make_nii(real(mag_all(:,:,:,i).*exp(1j*ph_all(:,:,:,i))),vox);
	save_nii(nii,['real_ch' num2str(i) '.nii']);
	nii = make_nii(imag(mag_all(:,:,:,i).*exp(1j*ph_all(:,:,:,i))),vox);
	save_nii(nii,['imag_ch' num2str(i) '.nii']);
end

save('raw.mat','-v7.3');


mkdir '/home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/PETRA/'
cd '/home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/PETRA/'

!/usr/local/fsl/5.0.9/bin/flirt -in /home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/PETRA/QSM_PETRA_7T/mag_sos_n4.nii -ref /home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/QSM_MEGE_7T/src/mag_corr1.nii -out /home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/PETRA/mag_sos_n4_aligned.nii -omat /home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/PETRA/mag_sos_n4_aligned.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear


% registration
for i = 1:imsize(4)
	setenv('ch',num2str(i));
	!/usr/local/fsl/5.0.9/bin/flirt -in /home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/PETRA/QSM_PETRA_7T/imag_ch${ch}.nii -applyxfm -init /home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/PETRA/mag_sos_n4_aligned.mat -out /home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/PETRA/flirt_imag_ch${ch}.nii -paddingsize 0.0 -interp trilinear -ref /home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/QSM_MEGE_7T/src/mag_corr1.nii
	!/usr/local/fsl/5.0.9/bin/flirt -in /home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/PETRA/QSM_PETRA_7T/real_ch${ch}.nii -applyxfm -init /home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/PETRA/mag_sos_n4_aligned.mat -out /home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/PETRA/flirt_real_ch${ch}.nii -paddingsize 0.0 -interp trilinear -ref /home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/QSM_MEGE_7T/src/mag_corr1.nii
end

% unzip all the gz
!gunzip -f *.nii.gz

% read in 
for i = 1:imsize(4)
	nii = load_nii(['flirt_real_ch' num2str(i) '.nii']);
	real_all(:,:,:,i) = imgaussfilt3(single(nii.img),2);
	nii = load_nii(['flirt_imag_ch' num2str(i) '.nii']);
	imag_all(:,:,:,i) = imgaussfilt3(single(nii.img),2);
end

% save into magnitude and phase
mag_all_aligned = abs(real_all + 1j*imag_all);
ph_all_aligned = angle(real_all + 1j*imag_all);
clear real_all imag_all


load('/home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/QSM_MEGE_7T/raw.mat', 'vox');

nii = make_nii(mag_all_aligned,vox);
save_nii(nii,'mag_all_aligned.nii');
nii = make_nii(ph_all_aligned,vox);
save_nii(nii,'ph_all_aligned.nii');

save('raw.mat','mag_all_aligned','ph_all_aligned','-v7.3');



% go to GRE NEUTRAL folder
load('/home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/QSM_MEGE_7T/raw.mat', 'ph_all')
load('/home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/QSM_MEGE_7T/raw.mat', 'mag_all')
load('/home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/QSM_MEGE_7T/raw.mat', 'TE')
load('/home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/QSM_MEGE_7T/raw.mat', 'mask')
load('/home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/QSM_MEGE_7T/raw.mat', 'z_prjs')
load('/home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/QSM_MEGE_7T/raw.mat', 'imsize')
load('/home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/QSM_MEGE_7T/raw.mat', 'dicom_info')
load('/home/hongfu/NCIgb5_scratch/hongfu/MS_7T/05JON/QSM_MEGE_7T/raw.mat', 'vox')

% [ph_corr,mag_corr,img_corr] = geme_cmb(mag_all.*exp(1j*ph_all),vox,TE,mask);

% compare two things:
% (1) compare our phase offsets with PETRA phase offset
% (2) compare our corrected indivudual-channel images with PETRA corrected

% nii = make_nii(angle(img_corr(:,:,:,1,:)),vox);
% save_nii(nii,'ph_all_chs_te1_corr.nii');

% % apply/subtract PETRA phase from raw phase
% % load('/home/hongfu/NCIgb5_scratch/hongfu/COSMOS_7T/ed/recon/PETRA/QSM_PETRA_7T/raw.mat','ph_all_aligned');
% nii = make_nii(angle(exp(1j*squeeze(ph_all(:,:,:,4,:)))./exp(1j*ph_all_aligned)),vox);
% save_nii(nii,'ph_all_chs_te4_PETRA.nii');

ph_corr = angle(sum(mag_all.*(exp(1j*ph_all))./exp(1j*permute(repmat(ph_all_aligned,[1 1 1 1 imsize(4)]),[1 2 3 5 4])),5));
mag_corr= sqrt(sum(mag_all.^2,5));

nii = make_nii(mag_corr,vox);
save_nii(nii,'mag_corr.nii');
nii = make_nii(ph_corr,vox);
save_nii(nii,'ph_corr.nii');

clear mag_all ph_all ph_all_aligned mag_all_aligned
save('raw.mat','ph_corr','mag_corr','-append')

% save niftis after coil combination
mkdir('src');
for echo = 1:imsize(4)
    nii = make_nii(mag_corr(:,:,:,echo),vox);
    save_nii(nii,['src/mag_corr' num2str(echo) '.nii']);
    nii = make_nii(ph_corr(:,:,:,echo),vox);
    save_nii(nii,['src/ph_corr' num2str(echo) '.nii']);
end

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
unph_diff = (unph(:,:,:,3) - unph(:,:,:,1))/2;
for echo = 2:imsize(4)
    meandiff = unph(:,:,:,echo) - unph(:,:,:,1) - double(echo-1)*unph_diff;
    meandiff = meandiff(mask==1);
    meandiff = mean(meandiff(:));
    njump = round(meandiff/(2*pi));
    disp(['    ' num2str(njump) ' 2pi jumps for TE' num2str(echo)]);
    unph(:,:,:,echo) = unph(:,:,:,echo) - njump*2*pi;
    unph(:,:,:,echo) = unph(:,:,:,echo).*mask;
end
nii = make_nii(unph,vox);
save_nii(nii,'unph_bestpath.nii');

unph_bestpath = unph;
save('raw.mat','unph_bestpath','-append');


% set parameters
fit_thr = 20;
tik_reg = 1e-6;
cgs_num = 500;
lsqr_num = 500;
% tv_reg = 2e-4;
inv_num = 500;


% fit phase images with echo times
disp('--> magnitude weighted LS fit of phase to TE ...');
[tfs_0, fit_residual_0] = echofit(unph,mag_corr,TE,0); 
% normalize to main field
% ph = gamma*dB*TE
% dB/B = ph/(gamma*TE*B0)
% units: TE s, gamma 2.675e8 rad/(sT), B0 7T
tfs_0 = tfs_0/(2.675e8*dicom_info.MagneticFieldStrength)*1e6; % unit ppm
nii = make_nii(tfs_0,vox);
save_nii(nii,'tfs_0.nii');
nii = make_nii(fit_residual_0,vox);
save_nii(nii,'fit_residual_0.nii');

% extra filtering according to fitting residuals
% generate reliability map
fit_residual_0_blur = smooth3(fit_residual_0,'box',round(1./vox)*2+1); 
nii = make_nii(fit_residual_0_blur,vox);
save_nii(nii,'fit_residual_0_blur.nii');
R_0 = ones(size(fit_residual_0_blur));
R_0(fit_residual_0_blur >= fit_thr) = 0;

save('raw.mat','tfs_0','fit_residual_0','fit_residual_0_blur','R_0','fit_thr','cgs_num','inv_num','-append');

for smv_rad = [1]
% for smv_rad = [1 2 3]load
    % RE-SHARP (tik_reg: Tikhonov regularization parameter)
    disp('--> RESHARP to remove background field ...');
    % [lfs_resharp_0, mask_resharp_0] = resharp_lsqr(tfs_0,mask.*R_0,vox,smv_rad,lsqr_num);
    [lfs_resharp_0, mask_resharp_0] = resharp(tfs_0,mask.*R_0,vox,smv_rad,tik_reg,cgs_num);
    % save nifti
    mkdir('RESHARP');
    nii = make_nii(lfs_resharp_0,vox);
    % save_nii(nii,['RESHARP/lfs_resharp_0_smvrad' num2str(smv_rad) '_lsqr.nii']);
    save_nii(nii,['RESHARP/lfs_resharp_0_smvrad' num2str(smv_rad) '_cgs_' num2str(tik_reg) '.nii']);

    % iLSQR
    chi_iLSQR_0 = QSM_iLSQR(lfs_resharp_0*(2.675e8*dicom_info.MagneticFieldStrength)/1e6,mask_resharp_0,'H',z_prjs,'voxelsize',vox,'niter',50,'TE',1000,'B0',dicom_info.MagneticFieldStrength);
    nii = make_nii(chi_iLSQR_0,vox);
    save_nii(nii,['RESHARP/chi_iLSQR_smvrad' num2str(smv_rad) '.nii']);
end






