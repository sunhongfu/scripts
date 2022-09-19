path_mag = '/Volumes/LaCie_Top/CSMEMP2RAGE/singleTI_09082022/qsm_recon/19049_Csmp2Rage_004/Wip925B_Cstfl_Mp2Rage_Wip925B_Cstfl - 1/sag_cs30_eco5_1200_2400/wip925B_1mm_CS30_eco5_1200_2400_17'
path_ph = '/Volumes/LaCie_Top/CSMEMP2RAGE/singleTI_09082022/qsm_recon/19049_Csmp2Rage_004/Wip925B_Cstfl_Mp2Rage_Wip925B_Cstfl - 1/sag_cs30_eco5_1200_2400/wip925B_1mm_CS30_eco5_1200_2400_18'

if ~ exist('path_mag','var') || isempty(path_mag)
    error('Please input the directory of magnitude DICOMs')
end

if ~ exist('path_ph','var') || isempty(path_ph)
    error('Please input the directory of unfiltered phase DICOMs')
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
    options.fit_thr = 40;
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
    options.tik_reg = 1e-3;
end

if ~ isfield(options,'cgs_num')
    options.cgs_num = 500;
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

% read in DICOMs of both magnitude and raw unfiltered phase images
% read in magnitude DICOMs
path_mag = cd(cd(path_mag));
mag_list = dir(path_mag);
mag_list = mag_list(~strncmpi('.', {mag_list.name}, 1));

% get the sequence parameters
dicom_info = dicominfo([path_mag,filesep,mag_list(end).name]);
% EchoTrainLength = dicom_info.EchoTrainLength;
EchoTrainLength = dicom_info.EchoNumbers;
for i = 1:EchoTrainLength % read in TEs
    dicom_info = dicominfo([path_mag,filesep,mag_list(1+(i-1)*(length(mag_list))./EchoTrainLength).name]);
    TE(dicom_info.EchoNumbers) = dicom_info.EchoTime*1e-3;
end
vox = [dicom_info.PixelSpacing(1), dicom_info.PixelSpacing(2), dicom_info.SliceThickness];

% angles!!! (z projections)
Xz = dicom_info.ImageOrientationPatient(3);
Yz = dicom_info.ImageOrientationPatient(6);
%Zz = sqrt(1 - Xz^2 - Yz^2);
Zxyz = cross(dicom_info.ImageOrientationPatient(1:3),dicom_info.ImageOrientationPatient(4:6));
Zz = Zxyz(3);
z_prjs = [Xz, Yz, Zz];

for i = 1:length(mag_list)
    [NS,NE] = ind2sub([length(mag_list)./EchoTrainLength,EchoTrainLength],i);
    mag(:,:,NS,NE) = permute(single(dicomread([path_mag,filesep,mag_list(i).name])),[2,1]);
end
% size of matrix
imsize = size(mag);

% read in phase DICOMs
path_ph = cd(cd(path_ph));
ph_list = dir(path_ph);
ph_list = ph_list(~strncmpi('.', {ph_list.name}, 1));

for i = 1:length(ph_list)
    [NS,NE] = ind2sub([length(ph_list)./EchoTrainLength,EchoTrainLength],i);
    ph(:,:,NS,NE) = permute(single(dicomread([path_ph,filesep,ph_list(i).name])),[2,1]);    % covert to [-pi pi] range
    ph(:,:,NS,NE) = ph(:,:,NS,NE)/4095*2*pi - pi;
end



% interpolation into isotropic
if interp
    img = mag.*exp(1j*ph);
    k = fftshift(fftshift(fftshift(fft(fft(fft(img,[],1),[],2),[],3),1),2),3);
    % find the finest resolution
    minvox = min(vox);
    % update matrix size
    pad_size =  round((vox.*imsize(1:3)/minvox - imsize(1:3))/2);
    k = padarray(k, pad_size);
    img = ifft(ifft(ifft(ifftshift(ifftshift(ifftshift(k,1),2),3),[],1),[],2),[],3);
    clear k;
    imsize_old = imsize;
    imsize = size(img);
    vox = imsize_old(1:3).*vox./imsize(1:3);
    mag = abs(img);
    ph = angle(img);
end






% % resample from sagittal to axial
% mag = permute(mag,[3 1 2 4]);
% ph = permute(ph,[3 1 2 4]);
% vox = [vox(3) vox(1) vox(2)];
% z_prjs = [z_prjs(3) z_prjs(1) z_prjs(2)];
% imsize = [imsize(3) imsize(1) imsize(2) imsize(4)];



% define output directories
path_qsm = [path_out '/QSM_R2S_PRISMA'];
mkdir(path_qsm);
init_dir = pwd;
cd(path_qsm);


% save magnitude and raw phase niftis for each echo
mkdir('src')
for echo = 1:imsize(4)
    nii = make_nii(mag(:,:,:,echo),vox);
    save_nii(nii,['src/mag' num2str(echo) '.nii']);
    nii = make_nii(ph(:,:,:,echo),vox);
    save_nii(nii,['src/ph' num2str(echo) '.nii']);
end



% truncate image to help BET
mag_sos = sqrt(sum(mag.^2,4));
% mag_sos = (sum(mag.^2,4));
mag_sos(:,[1:16,165:end],:,:) = 0;
% nii = make_nii(mag_sos(:,:,[17:164],:),vox);
nii = make_nii(mag_sos,vox);
save_nii(nii,['src/mag_sos.nii']);


% brain extraction
% generate mask from magnitude of the 1th echo
disp('--> extract brain volume and generate mask ...');
setenv('bet_thr',num2str(bet_thr));
setenv('bet_smooth',num2str(bet_smooth));
[~,~] = unix('rm BET*');
unix('bet2 src/mag_sos.nii BET -f 0.2 -m -w ${bet_smooth} ');
% unix('bet src/mag_sos.nii BET -f 0.5 -m  -g 0.8');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);


readout = 'bipolar'


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


% unwrap phase from each echo
if strcmpi('prelude',ph_unwrap)
    disp('--> unwrap aliasing phase for all TEs using prelude...');
    setenv('echo_num',num2str(imsize(4)));
    bash_command = sprintf(['for ph in src/ph_corr[1-$echo_num].nii\n' ...
    'do\n' ...
    '	base=`basename $ph`;\n' ...
    '	dir=`dirname $ph`;\n' ...
    '	mag=$dir/"mag"${base:7};\n' ...
    '	unph="unph"${base:7};\n' ...
    '	prelude -a $mag -p $ph -u $unph -m BET_mask.nii -n 12&\n' ...
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

        bash_script = ['${pathstr}/3DSRNCP wrapped_phase${echo_num}.dat mask_unwrp.dat ' ...
            'unwrapped_phase${echo_num}.dat $nv $np $ns reliability${echo_num}.dat'];
        unix(bash_script) ;

        fid = fopen(['unwrapped_phase' num2str(echo_num) '.dat'],'r');
        tmp = fread(fid,'float');
        % tmp = tmp - tmp(1);
        unph(:,:,:,echo_num) = reshape(tmp - round(mean(tmp(mask==1))/(2*pi))*2*pi ,imsize(1:3)).*mask;
        fclose(fid);

        fid = fopen(['reliability' num2str(echo_num) '.dat'],'r');
        reliability_raw = fread(fid,'float');
        reliability_raw = reshape(reliability_raw,imsize(1:3));
        fclose(fid);

        nii = make_nii(reliability_raw.*mask,vox);
        save_nii(nii,['reliability_raw' num2str(echo_num) '.nii']);
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

for echo = 2:imsize(4)
    meandiff = unph(:,:,:,echo)-unph(:,:,:,1)-double(echo-1)*unph_diff;
    meandiff = meandiff(mask==1);
    meandiff = mean(meandiff(:));
    njump = round(meandiff/(2*pi));
    disp(['    ' num2str(njump) ' 2pi jumps for TE' num2str(echo)]);
    unph(:,:,:,echo) = unph(:,:,:,echo) - njump*2*pi;
    unph(:,:,:,echo) = unph(:,:,:,echo).*mask;
end


% fit phase images with echo times
disp('--> magnitude weighted LS fit of phase to TE ...');
[tfs, fit_residual] = echofit(unph,mag,TE,0); 

fit_thr = 10

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
% units: TE s, gamma 2.675e8 rad/(sT), B0 4.7T
tfs = tfs/(2.675e8*dicom_info.MagneticFieldStrength)*1e6; % unit ppm

nii = make_nii(tfs,vox);
save_nii(nii,'tfs.nii');


disp('--> RESHARP to remove background field ...');
    [lfs_resharp, mask_resharp] = resharp(tfs,mask.*R,vox,smv_rad,tik_reg,cgs_num);
    % % 3D 2nd order polyfit to remove any residual background
    % lfs_resharp= poly3d(lfs_resharp,mask_resharp);

    % save nifti
    mkdir('RESHARP');
    nii = make_nii(lfs_resharp,vox);
    save_nii(nii,'RESHARP/lfs_resharp.nii');

    % inversion of susceptibility 
    disp('--> TV susceptibility inversion on RESHARP...');
    % iLSQR
    chi_iLSQR = QSM_iLSQR(lfs_resharp*(2.675e8*dicom_info.MagneticFieldStrength)/1e6,mask_resharp,'H',z_prjs,'voxelsize',vox,'niter',50,'TE',1000,'B0',dicom_info.MagneticFieldStrength);
    nii = make_nii(chi_iLSQR,vox);
    save_nii(nii,['RESHARP/chi_iLSQR_smvrad' num2str(smv_rad) '.nii']);


    save('all.mat','-v7.3');

