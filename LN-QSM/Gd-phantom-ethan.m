
if ~ exist('path_dicom','var') || isempty(path_dicom)
    error('Please input the directory of DICOMs')
end

if ~ exist('path_out','var') || isempty(path_out)
    path_out = pwd;
    disp('Current directory for output')
end

if ~ exist('options','var') || isempty(options)
    options = [];
end

if ~ isfield(options,'readout')
    options.readout = 'unipolar';
end

if ~ isfield(options,'r_mask')
    options.r_mask = 1;
end

if ~ isfield(options,'fit_thr')
    options.fit_thr = 20;
end

if ~ isfield(options,'bet_thr')
    options.bet_thr = 0.4;
end

if ~ isfield(options,'bet_smooth')
    options.bet_smooth = 2;
end

if ~ isfield(options,'ph_unwrap')
    options.ph_unwrap = 'bestpath';
end

if ~ isfield(options,'bkg_rm')
    options.bkg_rm = {'resharp','lnqsm'};
    % options.bkg_rm = {'pdf','sharp','resharp','esharp','lbv'};
end

if ~ isfield(options,'t_svd')
    options.t_svd = 0.1;
end

if ~ isfield(options,'smv_rad')
    options.smv_rad = 2;
end

if ~ isfield(options,'tik_reg')
    % options.tik_reg = 1e-4;
    options.tik_reg = 0;
end

if ~ isfield(options,'cgs_num')
    options.cgs_num = 500;
end

if ~ isfield(options,'lbv_tol')
    options.lbv_tol = 0.01;
end

if ~ isfield(options,'lbv_peel')
    options.lbv_peel = 1;
end

if ~ isfield(options,'tv_reg')
    options.tv_reg = 5e-4;
end

if ~ isfield(options,'inv_num')
    options.inv_num = 200;
end

if ~ isfield(options,'interp')
    options.interp = 0;
end

readout    = options.readout;
r_mask     = options.r_mask;
fit_thr    = options.fit_thr;
bet_thr    = options.bet_thr;
bet_smooth = options.bet_smooth;
ph_unwrap  = options.ph_unwrap;
bkg_rm     = options.bkg_rm;
t_svd      = options.t_svd;
smv_rad    = options.smv_rad;
tik_reg    = options.tik_reg;
cgs_num    = options.cgs_num;
lbv_tol    = options.lbv_tol;
lbv_peel   = options.lbv_peel;
tv_reg     = options.tv_reg;
inv_num    = options.inv_num;
interp     = options.interp;

% read in MESPGR dicoms (multi-echo gradient-echo)
path_dicom = cd(cd(path_dicom));
list_dicom = dir(path_dicom);
list_dicom = list_dicom(~strncmpi('.', {list_dicom.name}, 1));


dicom_info = dicominfo([path_dicom,filesep,list_dicom(1).name]);
dicom_info.EchoTrainLength = 8;

imsize = [dicom_info.Width, dicom_info.Height, ...
            length(list_dicom)/dicom_info.EchoTrainLength/4, ...
                dicom_info.EchoTrainLength];

vox = [dicom_info.PixelSpacing(1), dicom_info.PixelSpacing(2), dicom_info.SliceThickness];
CF = dicom_info.ImagingFrequency *1e6;

% angles!!!
Xz = dicom_info.ImageOrientationPatient(3);
Yz = dicom_info.ImageOrientationPatient(6);
%Zz = sqrt(1 - Xz^2 - Yz^2);
Zxyz = cross(dicom_info.ImageOrientationPatient(1:3),dicom_info.ImageOrientationPatient(4:6));
Zz = Zxyz(3);
z_prjs = [Xz, Yz, Zz];


img = zeros(imsize);
TE = zeros(1, imsize(4));

chopper = double(mod(1:imsize(3),2)) ;
chopper( chopper < 1 ) = -1 ;

Counter = 1;
for zCount = 1 : imsize(3)
    for echoCount = 1 : imsize(4)

		%tmpHeaders{Counter} = dicominfo( imagelist( Counter+2 ).name ) ;
        Counter = Counter + 1 ;
        
        %tmpHeaders{Counter} = dicominfo( imagelist( Counter+2 ).name ) ;
        Counter = Counter + 1 ;
        
        %tmpHeaders{Counter} = dicominfo( imagelist( Counter+2 ).name ) ;
        theReal = ...
            permute(chopper(zCount)*double( dicomread( [path_dicom,filesep,list_dicom(Counter).name] ) ),[2 1]) ;
        dicom_info = dicominfo([path_dicom,filesep,list_dicom(Counter).name]);
	    TE(dicom_info.EchoNumber) = dicom_info.EchoTime*1e-3;
		Counter = Counter + 1 ;
        
        %tmpHeaders{Counter} = dicominfo( imagelist( Counter+2 ).name ) ;
        theImag = ...
            permute(chopper(zCount)*double( dicomread( [path_dicom,filesep,list_dicom(Counter).name] ) ),[2 1]) ;    
        Counter = Counter + 1 ;
        
        img(:,:,zCount,echoCount) = theReal + 1j * theImag ;
    end
end

% interpolate the images to the double size
if interp
    img = single(img);
    % zero padding the k-space
    k = fftshift(fftshift(fftshift(fft(fft(fft(img,[],1),[],2),[],3),1),2),3);
    k = padarray(k,double(imsize(1:3)/2));
    img = ifft(ifft(ifft(ifftshift(ifftshift(ifftshift(k,1),2),3),[],1),[],2),[],3);
    clear k;
    imsize = size(img);
    vox = vox/2;
end

mag = abs(img);
ph = angle(img);
clear img


% define output directories
path_qsm = [path_out '/QSM_SPGR_GE'];
[~,~,~] = mkdir(path_qsm);
init_dir = pwd;
cd(path_qsm);



% save magnitude and raw phase niftis for each echo
[~,~,~] = mkdir('src');
for echo = 1:imsize(4)
    nii = make_nii(mag(:,:,:,echo),vox);
    save_nii(nii,['src/mag' num2str(echo) '.nii']);
    nii = make_nii(ph(:,:,:,echo),vox);
    save_nii(nii,['src/ph' num2str(echo) '.nii']);
end



% brain extraction
% generate mask from magnitude of the 1th echo
disp('--> extract brain volume and generate mask ...');
setenv('bet_thr',num2str(bet_thr));
setenv('bet_smooth',num2str(bet_smooth));
[~,~] = unix('rm BET*');
unix('bet2 src/mag1.nii BET -f ${bet_thr} -m -w ${bet_smooth}');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);



% phase offset correction
% if unipolar
if strcmpi('unipolar',readout)
    ph_corr = geme_cmb(mag.*exp(1j*ph),vox,TE,mask);
% if bipolar
elseif strcmpi('bipolar',readout)
    ph_corr = zeros(imsize);
    ph_corr(:,:,:,1:2:end) = geme_cmb(mag(:,:,:,1:2:end).*exp(1j*ph(:,:,:,1:2:end)),vox,TE(1:2:end),mask);
    ph_corr(:,:,:,2:2:end) = geme_cmb(mag(:,:,:,2:2:end).*exp(1j*ph(:,:,:,2:2:end)),vox,TE(2:2:end),mask);
else
    error('is the sequence unipolar or bipolar readout?')
end


% save offset corrected phase niftis
for echo = 1:imsize(4)
    nii = make_nii(ph_corr(:,:,:,echo),vox);
    save_nii(nii,['src/ph_corr' num2str(echo) '.nii']);
end


% %% 1 best path
% % unwrap the phase using best path
%     disp('--> unwrap aliasing phase using bestpath...');
%     mask_unwrp = uint8(abs(mask)*255);
%     fid = fopen('mask_unwrp.dat','w');
%     fwrite(fid,mask_unwrp,'uchar');
%     fclose(fid);

%     [pathstr, ~, ~] = fileparts(which('3DSRNCP.m'));
%     setenv('pathstr',pathstr);
%     setenv('nv',num2str(imsize(1)));
%     setenv('np',num2str(imsize(2)));
%     setenv('ns',num2str(imsize(3)));

%     unph = zeros(imsize);

%     for echo_num = 1:imsize(4)
%         setenv('echo_num',num2str(echo_num));
%         fid = fopen(['wrapped_phase' num2str(echo_num) '.dat'],'w');
%         fwrite(fid,ph_corr(:,:,:,echo_num),'float');
%         fclose(fid);
%         if isdeployed
%             bash_script = ['~/bin/3DSRNCP wrapped_phase${echo_num}.dat mask_unwrp.dat ' ...
%             'unwrapped_phase${echo_num}.dat $nv $np $ns reliability${echo_num}.dat'];
%         else    
%             bash_script = ['${pathstr}/3DSRNCP wrapped_phase${echo_num}.dat mask_unwrp.dat ' ...
%             'unwrapped_phase${echo_num}.dat $nv $np $ns reliability${echo_num}.dat'];
%         end
%         unix(bash_script) ;

%         fid = fopen(['unwrapped_phase' num2str(echo_num) '.dat'],'r');
%         tmp = fread(fid,'float');
%         % tmp = tmp - tmp(1);
%         unph(:,:,:,echo_num) = reshape(tmp - round(mean(tmp(mask==1))/(2*pi))*2*pi ,imsize(1:3)).*mask;
%         fclose(fid);

%         fid = fopen(['reliability' num2str(echo_num) '.dat'],'r');
%         reliability_raw = fread(fid,'float');
%         reliability_raw = reshape(reliability_raw,imsize(1:3));
%         fclose(fid);

%         nii = make_nii(reliability_raw.*mask,vox);
%         save_nii(nii,['reliability_raw' num2str(echo_num) '.nii']);
%     end

%     nii = make_nii(unph,vox);
%     save_nii(nii,'unph_bestpath.nii');


%% 2 prelude
% unwrap phase from each echo
    disp('--> unwrap aliasing phase for all TEs using prelude...');
    setenv('echo_num',num2str(imsize(4)));
    bash_command = sprintf(['for ph in src/ph_corr*.nii\n' ...
    'do\n' ...
    '   base=`basename $ph`;\n' ...
    '   dir=`dirname $ph`;\n' ...
    '   mag=$dir/"mag"${base:7};\n' ...
    '   unph="unph"${base:7};\n' ...
    '   prelude -a $mag -p $ph -u $unph -m BET_mask.nii -n 12&\n' ...
    'done\n' ...
    'wait\n' ...
    'gunzip -f unph*.gz\n']);
    unix(bash_command);

    unph = zeros(imsize);
    for echo = 1:imsize(4)
        nii = load_nii(['unph' num2str(echo) '.nii']);
        unph(:,:,:,echo) = double(nii.img);
    end



nii = load_nii('unph_diff.nii');
unph_diff = double(nii.img);
if strcmpi('bipolar',readout)
    unph_diff = unph_diff/2;
end

for echo = 2:imsize(4)
    meandiff = unph(:,:,:,echo)-unph(:,:,:,1)-double(echo-1)*unph_diff;
    meandiff = meandiff(mask==1);
    meandiff = mean(meandiff(:));
    njump = round(meandiff/(2*pi));
    disp(['    ' num2str(njump) ' 2pi jumps for TE' num2str(echo)]);
    unph(:,:,:,echo) = unph(:,:,:,echo) - njump*2*pi;
    unph(:,:,:,echo) = unph(:,:,:,echo).*mask;
end

% for echo = 2:imsize(4)
%     meandiff = unph(:,:,:,echo)-unph(:,:,:,echo-1)-unph_diff;
%     meandiff = meandiff(mask==1);
%     meandiff = mean(meandiff(:))
%     njump = round(meandiff/(2*pi))
%     disp(['    ' num2str(njump) ' 2pi jumps for TE' num2str(echo)]);
%     unph(:,:,:,echo) = unph(:,:,:,echo) - njump*2*pi;
%     unph(:,:,:,echo) = unph(:,:,:,echo).*mask;
% end

nii = make_nii(unph,vox);
save_nii(nii,'unph_corrected.nii');



% fit phase images with echo times
disp('--> magnitude weighted LS fit of phase to TE ...');
% [tfs, fit_residual] = echofit(unph,mag,TE,0); 
[tfs, fit_residual] = echofit(unph(:,:,:,1:2),mag(:,:,:,1:2),TE(1:2),0); 

fit_thr = 1;

% extra filtering according to fitting residuals
if r_mask
    % generate reliability map
    fit_residual_blur = smooth3(fit_residual,'box',round(1./vox)*2+1); 
    nii = make_nii(fit_residual_blur,vox);
    save_nii(nii,'fit_residual_blur.nii');
    R = ones(size(fit_residual_blur));
    R(fit_residual_blur >= fit_thr) = 0;
else
    R = 1;
end



% normalize to main field
% ph = gamma*dB*TE
% dB/B = ph/(gamma*TE*B0)
% units: TE s, gamma 2.675e8 rad/(sT), B0 3T
% tfs = -tfs/(2.675e8*dicom_info.MagneticFieldStrength)*1e6; % unit ppm
tfs = -tfs/(CF*2*pi)*1e6; % unit ppm

nii = make_nii(tfs,vox);
save_nii(nii,'tfs.nii');



iMag = sqrt(sum((mag(:,:,:,1:2)).^2,4));
matrix_size = single(imsize(1:3));
voxel_size = vox;
delta_TE = TE(2) - TE(1);
B0_dir = z_prjs';
CF = dicom_info.ImagingFrequency *1e6;

iFreq = tfs*2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% change the RESHARP parameter? 1e-6?
mkdir TFS_RESHARP_ERO2_2echoes
cd TFS_RESHARP_ERO2_2echoes
% (8) MEDI eroded brain with RESHARP (2 voxels erosion)
[RDF, mask_resharp] = resharp(iFreq,mask.*R,vox,2,1e-6,200);
nii = make_nii(RDF,voxel_size);
save_nii(nii,'resharp_1e-6.nii');
Mask = mask_resharp;
iMag = Mask; wG = 1;
N_std = 1;

save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
     voxel_size delta_TE CF B0_dir;
% run part of MEDI first
QSM = MEDI_L1('lambda',1000);
nii = make_nii(QSM.*Mask,vox);
save_nii(nii,'MEDI_iMag_uni_1e-6_ero2.nii');

%%%%%%%% (2) iLSQR %%%%%%%%%
chi_iLSQR = QSM_iLSQR(RDF,mask_resharp,'H',z_prjs,'voxelsize',vox,'niter',200,'TE',1000*delta_TE,'B0',dicom_info.MagneticFieldStrength);
nii = make_nii(chi_iLSQR,vox);
save_nii(nii,['chi_resharp_iLSQR_ero2.nii']);
cd ..



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mkdir TFS_TFI_ERO0_2echoes
cd TFS_TFI_ERO0_2echoes
% (1) TFI of 0 voxel erosion
Mask = mask.*R; % only brain tissue, need whole head later
Mask_G = Mask;
iMag = Mask; wG = 1;
P_B = 30;
P = 1 * Mask + P_B * (1-Mask);
RDF = 0;
save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF wG
QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 600*2);
nii = make_nii(QSM.*Mask,vox);
save_nii(nii,'TFI_ero0_iMag_uni.nii');
cd ..



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mkdir TFS_TIK_PRE_ERO0_2echoes
cd TFS_TIK_PRE_ERO0_2echoes

fit_mask = mask.*R;
P = fit_mask + 30*(1 - fit_mask);

Res_wt = sqrt(sum(mag.^2,4)).*fit_mask;
Res_wt = Res_wt/sum(Res_wt(:))*sum(fit_mask(:));

r=0;
Tik_weight = [1e-3, 0, 1e-4];
TV_weight = [5e-4,1e-3];
for i = 1:length(Tik_weight)
for j = 1:length(TV_weight)
chi = tikhonov_qsm(tfs, Res_wt, 1, fit_mask, fit_mask, 0, TV_weight(j), Tik_weight(i), 0, vox, P, z_prjs, 2000);
nii = make_nii(chi.*fit_mask,vox);
save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);

chi = tikhonov_qsm(tfs, fit_mask, 1, fit_mask, fit_mask, 0, TV_weight(j), Tik_weight(i), 0, vox, P, z_prjs, 2000);
nii = make_nii(chi.*fit_mask,vox);
save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight(j)) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000_noWt.nii']);
end
end
cd ..





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate the wG
grad = @cgrad_forw;
wG = gradient_mask(1, iMag, Mask, grad, voxel_size);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mkdir TFS_TIK_PRE_ERO0_2echoes_wG
cd TFS_TIK_PRE_ERO0_2echoes_wG

fit_mask = mask.*R;
P = fit_mask + 30*(1 - fit_mask);

Res_wt = sqrt(sum(mag.^2,4)).*fit_mask;
Res_wt = Res_wt/sum(Res_wt(:))*sum(fit_mask(:));

r=0;
Tik_weight = [1e-3, 0, 1e-4];
TV_weight = [1000,2000];
for i = 1:length(Tik_weight)
for j = 1:length(TV_weight)
chi = tikhonov_qsm_wG(tfs, Res_wt, 1, fit_mask, fit_mask, 0, TV_weight(j), Tik_weight(i), 0, vox, P, z_prjs, 200, wG);
nii = make_nii(chi.*fit_mask,vox);
save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight(j)) '_Tik_' num2str(Tik_weight(i)) '_PRE_200.nii']);

% chi = tikhonov_qsm(tfs, fit_mask, 1, fit_mask, fit_mask, 0, TV_weight(j), Tik_weight(i), 0, vox, P, z_prjs, 200, wG);
% nii = make_nii(chi.*fit_mask,vox);
% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_200_noWt.nii']);
end
end
cd ..




load all_prelude.mat
% use Cornell's complex fitting + spurs unwrapping
iField = mag.*exp(1i*ph);
%%%%% provide a noise_level here if possible %%%%%%
if (~exist('noise_level','var'))
    noise_level = calfieldnoise(iField, mask);
end
%%%%% normalize signal intensity by noise to get SNR %%%
iField = iField/noise_level;
%%%% Generate the Magnitude image %%%%
% iMag = sqrt(sum(abs(iField).^2,4));
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

mkdir SS
cd SS
% save('ss.mat','iFreq_raw','voxel_size','mask','R','delta_TE');
% load('ss.mat');
nii = make_nii(ph(:,:,:,1),voxel_size);
save_nii(nii,'iFreq_raw_echo1.nii');
nii = make_nii(mask.*R,voxel_size);
save_nii(nii,'mask.nii');

% 0.0032    0.0056    0.0079    0.0103    0.0127    0.0150    0.0174    0.0198

tgv_qsm  -p iFreq_raw.nii -m mask.nii -f 3 -t 0.0079 -o SS_QSM --no-resampling

tgv_qsm  -p iFreq_raw.nii -m mask.nii -f 3 -t 0.0079 -o SS_QSM_1 --no-resampling --alpha 0.0015 0.0005
tgv_qsm  -p iFreq_raw.nii -m mask.nii -f 3 -t 0.0079 -o SS_QSM_2 --no-resampling --alpha 0.015 0.005
tgv_qsm  -p iFreq_raw.nii -m mask.nii -f 3 -t 0.0079 -o SS_QSM_3 --no-resampling --alpha 0.00015 0.00005
tgv_qsm  -p iFreq_raw.nii -m mask.nii -f 3 -t 0.0079 -o SS_QSM_5 --no-resampling --alpha 0.00075 0.00025
tgv_qsm  -p iFreq_raw.nii -m mask.nii -f 3 -t 0.0079 -o SS_QSM_6 --no-resampling --alpha 0.00012 0.00004
tgv_qsm  -p iFreq_raw.nii -m mask.nii -f 3 -t 0.0079 -o SS_QSM_7 --no-resampling --alpha 0.0003 0.0001


tgv_qsm  -p iFreq_raw_echo1.nii -m mask.nii -f 3 -t 0.0032 -o SS_QSM_echo1 --no-resampling --save-laplacian --output-physical