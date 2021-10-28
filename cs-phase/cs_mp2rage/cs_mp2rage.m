clc; clear all; close all; %Yes Matlab, clear all is nessesary!
addpath(genpath('/Users/uqhsun8/Documents/MATLAB/scripts/cs-phase/_src'));

%--------------------------------------------------------------------------
%% To do
%--------------------------------------------------------------------------
%Add coil compression: faster and kick out some noise


%--------------------------------------------------------------------------
%% fixed file path option
%--------------------------------------------------------------------------
sFile = 'meas_MID00351_FID05065_wip925b_TI2_ECHO2_VC_CS9_SAM54.dat';
sPath = '/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_24Sep21/';

%--------------------------------------------------------------------------
%% select a file (optional)
%--------------------------------------------------------------------------
if exist('sFile', 'var')~=true 
    [sFile, sPath] = uigetfile('*.dat');
end

% cd(sPath)
mkdir('meas_MID00351_FID05065_wip925b_TI2_ECHO2_VC_CS9_SAM54');
cd('meas_MID00351_FID05065_wip925b_TI2_ECHO2_VC_CS9_SAM54');

%--------------------------------------------------------------------------
%% settings
%--------------------------------------------------------------------------
if exist('ARG', 'var')~=true 
    
    ARG.FileName       = sFile;  %  file name
    ARG.RefMeas        = 1;      %  Me index to use as a phase refference
    ARG.Echo4Recon     = 1;      %  The echo you want to reconstrcut (for now just do one at a time)
    
    ARG.part_order     = 'Sequential'; 
    ARG.ACS            = 'Internal';
    ARG.prewhitening   = false;
    
    ARG.CS             = 1;

    ARG.mb.factor      = 1;
    ARG.mb.theta       = 0;
    ARG.mb.sign        = 1;
    ARG.mb.kernel      = [5, 5]; % [Re direction, Ph direction]
    ARG.mb.lambda      = 1E-4; 
    
    ARG.iPAT.factor    = [1, 1]; % [Re direction, Ph direction]
    ARG.iPAT.kernel    = [5, 4]; % [Re direction, Ph direction]
    ARG.iPAT.tol       = 1E-4; %1E-6;   %  numerical toloerence for pinv (truncated SVD)
    
    ARG.PF             =  8/8;   %  partial fourier factor
    ARG.PFrecon        = 'pocs'; %  partial fourier method ('pocs' or 'zero')
    ARG.pocsItr        = 10;     %  number of pocs iterations 
    ARG.recon          = 'sos';  %  coil combine method ('opt' or 'sos')
    
    ARG.pc_const_shift = 0;      % no EPI
    ARG.pc_linea_shift = 0;      % no EPI <- can be highjacked to introduce subvoxel shift
    
    ARG.multiraid      = false;

    % save setting
    save([sPath sFile(1:(end-4)) '_ARG.mat'],'ARG');
else
    disp('[WARNING]: USING SAVED SETTINGS!!');
end

    PRG.debug = false; % not usefull when nMeas = 1;

%--------------------------------------------------------------------------
%% load twix object
%--------------------------------------------------------------------------
twix_obj = mapVBVD([sPath, sFile], 'removeOS');
% twix_obj = mapVBVD([sPath, sFile]);

if ARG.multiraid  == true
%    twix_obj{1,2}.noise = twix_obj{1,1}.noise;
    twix_obj = twix_obj{1,2};
%    twix_obj.refscanPC = twix_obj.refscan;
end

%--------------------------------------------------------------------------
%% get the inverse noise covariance matrix
%--------------------------------------------------------------------------
if( strcmp(ARG.recon, 'opt') || ARG.prewhitening ) 
    [ARG.INC, ARG.NC] = get_inv_noise_cov(twix_obj);
else
    ARG.INC = 0;
    ARG.NC  = 0;
end

%--------------------------------------------------------------------------
%% load the k-space trajactory
%--------------------------------------------------------------------------
ARG.trj = load_trj([sPath, sFile], twix_obj.image.NCol);

%--------------------------------------------------------------------------
%% load k-data
%--------------------------------------------------------------------------
nRe = twix_obj.hdr.Config.NImageCols;
nPh = twix_obj.hdr.Config.NImageLins;  % nPh = round(twix_obj.image.NLin/ARG.PF);
% nPa = twix_obj.image.NPar; %nPa = twix_obj.hdr.Config.NPar; 
nPa = twix_obj.hdr.Config.NPar; 
nCh = twix_obj.image.NCha;
NEco = twix_obj.image.NEco;
NSet = twix_obj.image.NSet;

% k_full = zeros([nRe*2,nPh,nPa,NEco,nCh,NSet],'single');
% k_full = zeros([nRe*2,nPh,nPa,NEco,nCh],'single');
k_full = zeros([nRe,nPh,nPa,NEco,nCh],'single');


for echo = 1:NEco

    kData = load_volume(twix_obj,echo,'kData');

    %--------------------------------------------------------------------------
    %% prewhiten acs
    %--------------------------------------------------------------------------  
    if(ARG.prewhitening)
        iData = permute(iData,[1,3,2,4,5]);
        iData = prewhitening(iData,ARG);
        iData = permute(iData,[1,2,4,3]);  % nRe,nPh,nPa,nCh
        
        kData = permute(kData,[1,3,2,4,5]);
        kData = prewhitening(kData,ARG);
        kData = permute(kData,[1,2,4,3]);  % nRe,nPh,nPa,nCh
    else
        kData = permute(kData,[1,3,2,4,5]);
        kData = permute(kData,[1,2,4,3,5]);  % nRe,nPh,nPa,nCh
    end

    imsize = size(kData);
    pad_size = [0, nPh-imsize(2), nPa-imsize(3), 0, 0];
    kData = padarray(kData,pad_size,'post');

    % pre-padding for asymmetric echo
    kData = padarray(kData,[nRe*2-imsize(1),0,0,0, 0],'pre');

    %--------------------------------------------------------------------------
    %% tmp
    %--------------------------------------------------------------------------

    % tmp = sum(abs(kData),4);
    % save('tmp.mat','tmp');

    save(['k_full_echo' num2str(echo)],'kData','-v7.3');

    % keep only the 2nd inversion
    k_full(:,:,:,echo,:) = kData(:,:,:,:,2);
    
    % kData = fftshift(fft(fftshift(fftshift(fft(fftshift(fftshift(fft(fftshift(kData,1),[],1),1),3),[],3),3),2),[],2),2);
    % k_full(:,:,:,echo,:,:) = kData(nRe/2+1:end-nRe/2,:,:,:,:);
end

% save('k_full','k_full','-v7.3');
clear kData


% kData_s2 = ifftshift(ifft(ifftshift(ifftshift(ifft(ifftshift(ifftshift(ifft(ifftshift(kData_s1,1),[],1),1),3),[],3),3),2),[],2),2);
for necho = 1:NEco
    % for nset = 1:NSet
    % k_full(:,:,:,necho,:,nset) = fftshift(fft(fftshift(fftshift(fft(fftshift(fftshift(fft(fftshift(k_full(:,:,:,necho,:,nset),1),[],1),1),3),[],3),3),2),[],2),2);
    k_full(:,:,:,necho,:) = fftshift(fft(fftshift(fftshift(fft(fftshift(fftshift(fft(fftshift(k_full(:,:,:,necho,:),1),[],1),1),3),[],3),3),2),[],2),2);
    % end
end

% k_full = k_full(nRe/2+1:end-nRe/2,:,:,:,:,:);
% k_full([1:nRe/2,3*nRe/2+1:2*nRe],:,:,:,:,:) = [];
k_full([1:nRe/2,3*nRe/2+1:2*nRe],:,:,:,:) = [];


% save('k_full_512','k_full','-v7.3');

% k_full = k_full(129:128+256,:,:,:,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate magnitude sen
vox = [0.75 0.75 0.75];
% mag_sos = sqrt(sum(abs(k_full).^2,5)/size(k_full,5));
mag_sos = squeeze(sqrt(sum(abs(k_full).^2,5)));
nii = make_nii(mag_sos,vox);
save_nii(nii,'inv2_mag_sos.nii');

nii = make_nii(abs(k_full(:,:,:,1,:)),vox);
save_nii(nii,'inv2_mag1_all.nii');


sen = squeeze(abs(k_full(:,:,:,1,:)))./repmat(mag_sos(:,:,:,1),[1 1 1 size(k_full,5)]);
nii = make_nii(sen,vox);
save_nii(nii,'inv2_sen_mag_raw.nii');

sen_smooth = zeros(size(sen),'single');
% smooth the coil sensitivity
for chan = 1:size(k_full,5) 
    sen_smooth(:,:,:,chan) = smooth3(sen(:,:,:,chan),'box',round(8./vox)*2+1); 
end

nii = make_nii(sen_smooth,vox);
save_nii(nii,'inv2_sen_mag_smooth.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


img = k_full;
clear k_full mag_sos sen sen_smooth









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hongfu code
vox = [0.75 0.75 0.75];
% TE = 1.92 + (0:3)*3.02;
TE = 1.79 + (0:8)*2.75;

TE = TE/1000;

% % keep only the 2nd inversion
% img = img(:,:,:,:,:,2);

% BEGIN THE QSM RECON PIPELINE
% initial quick brain mask
% simple sum-of-square combination
mag1_sos = sqrt(sum(abs(img(:,:,:,1,:)).^2,5));
nii = make_nii(mag1_sos,vox);
save_nii(nii,'mag1_sos.nii');

unix('N4BiasFieldCorrection -i mag1_sos.nii -o mag1_sos_n4.nii');

unix('bet2 mag1_sos_n4.nii BET -f 0.8 -m');
% set a lower threshold for postmortem
% unix('bet2 mag1_sos.nii BET -f 0.1 -m');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);

% (1) if unipolar
[ph_corr,mag_corr] = geme_cmb(img,vox,TE,mask,[],0);

imsize = size(mag_corr);

% save niftis after coil combination
mkdir('src');
for echo = 1:size(img,4)
    nii = make_nii(mag_corr(:,:,:,echo),vox);
    save_nii(nii,['src/mag_corr' num2str(echo) '.nii']);

    % setenv('echo',num2str(echo));
    % unix('N4BiasFieldCorrection -i src/mag_corr${echo}.nii -o src/mag_corr${echo}_n4.nii');

    nii = make_nii(ph_corr(:,:,:,echo),vox);
    save_nii(nii,['src/ph_corr' num2str(echo) '.nii']);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear img 



% load in default parameters
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
    options.fit_thr = 5;
end

if ~ isfield(options,'bet_thr')
    options.bet_thr = 0.6;
end

if ~ isfield(options,'bet_smooth')
    options.bet_smooth = 2;
end

if ~ isfield(options,'ph_unwrap')
    options.ph_unwrap = 'bestpath';
end

if ~ isfield(options,'bkg_rm')
    options.bkg_rm = 'resharp';
    % options.bkg_rm = {'pdf','sharp','resharp','esharp','lbv'};
end

if ~ isfield(options,'t_svd')
    options.t_svd = 0.1;
end

if ~ isfield(options,'smv_rad')
    options.smv_rad = 3;
end

if ~ isfield(options,'tik_reg')
    options.tik_reg = 1e-4;
end

if ~ isfield(options,'cgs_num')
    options.cgs_num = 200;
end

if ~ isfield(options,'lbv_tol')
    options.lbv_tol = 0.01;
end

if ~ isfield(options,'lbv_peel')
    options.lbv_peel = 2;
end

if ~ isfield(options,'tv_reg')
    options.tv_reg = 5e-4;
end

if ~ isfield(options,'inv_num')
    options.inv_num = 500;
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


% brain extraction
% generate mask from magnitude of the 1th echo
disp('--> extract brain volume and generate mask ...');
setenv('bet_thr',num2str(bet_thr));
setenv('bet_smooth',num2str(bet_smooth));
[~,~] = unix('rm BET*');
unix('bet2 src/mag_corr1.nii BET -f ${bet_thr} -m -w ${bet_smooth}');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);



% unwrap phase from each echo
if strcmpi('prelude',ph_unwrap)
    disp('--> unwrap aliasing phase for all TEs using prelude...');
    setenv('echo_num',num2str(imsize(4)));
    bash_command = sprintf(['for ph in src/ph_corr[1-$echo_num].nii\n' ...
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


elseif strcmpi('bestpath',ph_unwrap)
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

    unph = zeros(imsize);

    for echo_num = 1:imsize(4)
        setenv('echo_num',num2str(echo_num));
        fid = fopen(['wrapped_phase' num2str(echo_num) '.dat'],'w');
        fwrite(fid,ph_corr(:,:,:,echo_num),'float');
        fclose(fid);
        if isdeployed
            bash_script = ['~/bin/3DSRNCP wrapped_phase${echo_num}.dat mask_unwrp.dat ' ...
            'unwrapped_phase${echo_num}.dat $nv $np $ns reliability${echo_num}.dat'];
        else    
            bash_script = ['${pathstr}/3DSRNCP wrapped_phase${echo_num}.dat mask_unwrp.dat ' ...
            'unwrapped_phase${echo_num}.dat $nv $np $ns reliability${echo_num}.dat'];
        end
        unix(bash_script) ;

        fid = fopen(['unwrapped_phase' num2str(echo_num) '.dat'],'r');
        tmp = fread(fid,'float');
        % tmp = tmp - tmp(1);
        unph(:,:,:,echo_num) = reshape(tmp - round(mean(tmp(mask==1))/(2*pi))*2*pi ,imsize(1:3)).*mask;
        fclose(fid);

        % fid = fopen(['reliability' num2str(echo_num) '.dat'],'r');
        % reliability_raw = fread(fid,'float');
        % reliability_raw = reshape(reliability_raw,imsize(1:3));
        % fclose(fid);

        % nii = make_nii(reliability_raw.*mask,vox);
        % save_nii(nii,['reliability_raw' num2str(echo_num) '.nii']);
    end

    nii = make_nii(unph,vox);
    save_nii(nii,'unph_bestpath.nii');

else
    error('what unwrapping methods to use? prelude or bestpath?')
end




% check and correct for 2pi jump between echoes
disp('--> correct for potential 2pi jumps between TEs ...')

% nii = load_nii('unph_cmb1.nii');
% unph1 = double(nii.img);
% nii = load_nii('unph_cmb2.nii');
% unph2 = double(nii.img);
% unph_diff = unph2 - unph1;

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


nii = make_nii(unph,vox);
save_nii(nii,'unph_corrected.nii');

% fit phase images with echo times
disp('--> magnitude weighted LS fit of phase to TE ...');
[tfs, fit_residual] = echofit(unph,mag_corr,TE,0); 


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
dicom_info.MagneticFieldStrength = 7.0;
tfs = tfs/(2.675e8*dicom_info.MagneticFieldStrength)*1e6; % unit ppm

nii = make_nii(tfs,vox);
save_nii(nii,'tfs.nii');

disp('--> RESHARP to remove background field ...');
[lfs_resharp, mask_resharp] = resharp(tfs,mask.*R,vox,smv_rad,tik_reg,cgs_num);
% % 3D 2nd order polyfit to remove any residual background
% lfs_resharp= lfs_resharp - poly3d(lfs_resharp,mask_resharp);

% save nifti
[~,~,~] = mkdir('RESHARP');
nii = make_nii(lfs_resharp,vox);
save_nii(nii,['RESHARP/lfs_resharp_tik_', num2str(tik_reg), '_num_', num2str(cgs_num), '.nii']);

% iLSQR
z_prjs = [0 0 1];
chi_iLSQR = QSM_iLSQR(lfs_resharp*(2.675e8*dicom_info.MagneticFieldStrength)/1e6,mask_resharp,'H',z_prjs,'voxelsize',vox,'niter',50,'TE',1000,'B0',dicom_info.MagneticFieldStrength);
nii = make_nii(chi_iLSQR,vox);
save_nii(nii,['RESHARP/chi_iLSQR_smvrad' num2str(smv_rad) '.nii']);

save all.mat
% Hongfu code ends
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






















%--------------------------------------------------------------------------
%% Partition fft
%--------------------------------------------------------------------------
% iData = fftshift(fft(fftshift(iData,3),[],3),3);
kData = fftshift(fft(fftshift(kData,3),[],3),3);

%--------------------------------------------------------------------------
%% Allocate memory for all images
%--------------------------------------------------------------------------
nRe = twix_obj.hdr.Config.NImageCols;
nPh = twix_obj.hdr.Config.NImageLins;  % nPh = round(twix_obj.image.NLin/ARG.PF);
nPa = twix_obj.image.NPar; %nPa = twix_obj.hdr.Config.NPar; 
nCh = twix_obj.image.NCha;
    
img = zeros(nRe,nPh,nPa);

%--------------------------------------------------------------------------
%% Reconstruct all images
%--------------------------------------------------------------------------
for iPa=1:nPa
         
    tmpK = squeeze(kData(:,:,iPa,:));
%     tmpI = squeeze(iData(:,:,iPa,:));

    %----------------------
    % Matrix completion
    %----------------------
    if(ARG.iPAT.factor(1) > 1 || ARG.iPAT.factor(2) > 1)
        if(ARG.PF == 1 && nPh ~= size(tmpK,2))
            tmpK = matrix_completion(tmpK,nPh);
        end
    end
    
    %----------------------OK
    % Grappa (in plane)
    %----------------------
    if(ARG.iPAT.factor(1) > 1 || ARG.iPAT.factor(2) > 1)    %||ARG.CS
        tmpK = grappa(tmpK,tmpI,ARG);
    end
    
    %----------------------
    % Partial fourier
    %----------------------
    if ARG.PF ~= 1
        tmpK = partial_fourier(tmpK,ARG);
    end
    
    %----------------------
    % FFT and Coil combine
    %----------------------    
    img(:,:,iPa) = fft_combine(tmpK, ARG, true);
    
    %----------------------
    % Progress update
    %----------------------

    disp(['[INFO]: compleated partition ' num2str(iPa), ' of ' num2str(nPa)]);
end


%--------------------------------------------------------------------------
%% Export nifti
%--------------------------------------------------------------------------
[niiA, ~] = export_to_nii(img, ARG);

%--------------------------------------------------------------------------
%% Display 
%--------------------------------------------------------------------------
view_nii(niiA)

%--------------------------------------------------------------------------
%% DEBUG: Display 
%--------------------------------------------------------------------------
% amp =   abs(img(:,:,2,end));
% pha = angle(img(:,:,2,end));
% 
% figure(1);
% subplot(1,2,1); imshow(amp,[0,max(amp(:))]);
% subplot(1,2,2); imshow(pha,[-pi,pi]);



