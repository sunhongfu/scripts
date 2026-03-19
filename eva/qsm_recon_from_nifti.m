function qsm_recon_from_nifti(mag_dir, ph_dir, out_dir)
% QSM reconstruction from per-echo NIfTI magnitude/phase folders.
% Mirrors the processing flow in Eva.m but starts from mag*.nii/ph*.nii.
%
% Example:
% qsm_recon_from_nifti( ...
%   '/Volumes/LaCie_Bottom/collaborators/Eva_Alonso_Ortiz/MEGRE_INVIVO/20160726A_dicom_sorted/20160726/Sequence_Development_Eva - 1/EAO_FLASH_mc_25mm_7_nifti', ...
%   '/Volumes/LaCie_Bottom/collaborators/Eva_Alonso_Ortiz/MEGRE_INVIVO/20160726A_dicom_sorted/20160726/Sequence_Development_Eva - 1/EAO_FLASH_mc_25mm_8_nifti', ...
%   '/Volumes/LaCie_Bottom/collaborators/Eva_Alonso_Ortiz/MEGRE_INVIVO/20160726A_dicom_sorted/20160726/Sequence_Development_Eva - 1/QSM_25mm');

if nargin < 1 || isempty(mag_dir)
    mag_dir = '/Volumes/LaCie_Bottom/collaborators/Eva_Alonso_Ortiz/MEGRE_INVIVO/20160726A_dicom_sorted/20160726/Sequence_Development_Eva - 1/EAO_FLASH_mc_25mm_7_nifti';
end
if nargin < 2 || isempty(ph_dir)
    ph_dir = '/Volumes/LaCie_Bottom/collaborators/Eva_Alonso_Ortiz/MEGRE_INVIVO/20160726A_dicom_sorted/20160726/Sequence_Development_Eva - 1/EAO_FLASH_mc_25mm_8_nifti';
end
if nargin < 3 || isempty(out_dir)
    out_dir = fullfile(fileparts(mag_dir), 'QSM_from_nifti');
end

TE1_ms = 2.4;
ES_ms = 1.2;
readout = 'bipolar';
ph_unwrap = 'bestpath'; % 'bestpath' or 'prelude'
bkg_rm = {'lbv'};      % {'lbv'} or {'pdf'} or {'lbv','pdf'}

if ~exist(mag_dir, 'dir')
    error('Magnitude folder not found: %s', mag_dir);
end
if ~exist(ph_dir, 'dir')
    error('Phase folder not found: %s', ph_dir);
end
if ~exist(out_dir, 'dir')
    mkdir(out_dir);
end

% Find echo files: mag1.nii ... magN.nii / ph1.nii ... phN.nii
mag_files = get_echo_files(mag_dir, '^mag(\d+)\.nii$');
ph_files = get_echo_files(ph_dir, '^ph(\d+)\.nii$');

if isempty(mag_files)
    error('No mag*.nii files found in: %s', mag_dir);
end
if isempty(ph_files)
    error('No ph*.nii files found in: %s', ph_dir);
end

echo_num = min(numel(mag_files), numel(ph_files));
if echo_num < 2
    error('Need at least 2 echoes. Found %d.', echo_num);
end

if numel(mag_files) ~= numel(ph_files)
    warning('Different #echo files: mag=%d, ph=%d. Using first %d echoes.', ...
        numel(mag_files), numel(ph_files), echo_num);
end

% Load first echo to get size/voxel
nii0 = load_nii(fullfile(mag_dir, mag_files{1}.name));
vox = double(nii0.hdr.dime.pixdim(2:4));
imsize3 = size(double(nii0.img));
if numel(imsize3) ~= 3
    error('Expected 3D per-echo NIfTI. Got size %s', mat2str(size(nii0.img)));
end

mag = zeros([imsize3, echo_num], 'double');
ph = zeros([imsize3, echo_num], 'double');

for k = 1:echo_num
    nii_m = load_nii(fullfile(mag_dir, mag_files{k}.name));
    nii_p = load_nii(fullfile(ph_dir, ph_files{k}.name));
    mag(:,:,:,k) = double(nii_m.img);
    ph(:,:,:,k) = double(nii_p.img);
end

% Phase NIfTIs are expected to already be in radians.
% Keep values wrapped in [-pi, pi] to stabilize later processing.
ph = angle(exp(1j*ph));

TE = (TE1_ms + (0:echo_num-1)*ES_ms)/1000;
imsize = size(mag);

% Default B0 projection direction.
z_prjs = [0, 0, 1];

% Optional: refine z_prjs from one DICOM in matching non-_nifti folder.
dicom_dir = regexprep(mag_dir, '_nifti(_aligned)?$', '');
if exist(dicom_dir, 'dir')
    dcm = dir(fullfile(dicom_dir, '*.dcm'));
    if ~isempty(dcm)
        dicom_info = dicominfo(fullfile(dicom_dir, dcm(1).name));
        Xz = dicom_info.ImageOrientationPatient(3);
        Yz = dicom_info.ImageOrientationPatient(6);
        Zxyz = cross(dicom_info.ImageOrientationPatient(1:3), dicom_info.ImageOrientationPatient(4:6));
        Zz = Zxyz(3);
        z_prjs = [Xz, Yz, Zz];
    else
        warning('No DICOM found in %s. Using z_prjs=[0 0 1].', dicom_dir);
    end
else
    warning('Matching DICOM folder not found (%s). Using z_prjs=[0 0 1].', dicom_dir);
end

orig_dir = pwd;
cleanupObj = onCleanup(@() cd(orig_dir));
cd(out_dir);

% save source niftis in working dir
mkdir('src');
for echo = 1:imsize(4)
    nii = make_nii(mag(:,:,:,echo), vox);
    save_nii(nii, fullfile('src', ['mag' num2str(echo) '.nii']));
    nii = make_nii(ph(:,:,:,echo), vox);
    save_nii(nii, fullfile('src', ['ph' num2str(echo) '.nii']));
end

bet_smooth = 1.5;
bet_thr = 0.25;
bet_g = -0.15;

disp('--> extract brain volume and generate mask ...');
setenv('bet_thr', num2str(bet_thr));
setenv('bet_smooth', num2str(bet_smooth));
setenv('bet_g', num2str(bet_g));
unix('rm -f BET*');
unix('bet2 src/mag1.nii BET -f ${bet_thr} -g ${bet_g} -m -w ${bet_smooth}');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);

% phase offset correction
if strcmpi(readout, 'unipolar')
    ph_corr = geme_cmb(mag.*exp(1j*ph), vox, TE, mask);
elseif strcmpi(readout, 'bipolar')
    ph_corr = zeros(imsize);
    ph_corr(:,:,:,1:2:end) = geme_cmb(mag(:,:,:,1:2:end).*exp(1j*ph(:,:,:,1:2:end)), vox, TE(1:2:end), mask);
    ph_corr(:,:,:,2:2:end) = geme_cmb(mag(:,:,:,2:2:end).*exp(1j*ph(:,:,:,2:2:end)), vox, TE(2:2:end), mask);
else
    error('readout must be unipolar or bipolar');
end

for echo = 1:imsize(4)
    nii = make_nii(ph_corr(:,:,:,echo), vox);
    save_nii(nii, fullfile('src', ['ph_corr' num2str(echo) '.nii']));
end

if strcmpi(ph_unwrap, 'prelude')
    disp('--> unwrap aliasing phase for all TEs using prelude...');
    bash_command = sprintf([ ...
        'for ph in src/ph_corr*.nii\n' ...
        'do\n' ...
        '   base=`basename $ph`;\n' ...
        '   dir=`dirname $ph`;\n' ...
        '   mag=$dir/"mag"${base:7};\n' ...
        '   unph="unph"${base:7};\n' ...
        '   prelude -a $mag -p $ph -u $unph -m BET_mask.nii -n 12 &\n' ...
        'done\n' ...
        'wait\n' ...
        'gunzip -f unph*.gz\n']);
    unix(bash_command);

    unph = zeros(imsize);
    for echo = 1:imsize(4)
        nii = load_nii(['unph' num2str(echo) '.nii']);
        unph(:,:,:,echo) = double(nii.img);
    end
else
    disp('--> unwrap aliasing phase using bestpath...');
    mask_unwrp = uint8(abs(mask)*255);
    fid = fopen('mask_unwrp.dat','w'); fwrite(fid,mask_unwrp,'uchar'); fclose(fid);

    [pathstr, ~, ~] = fileparts(which('3DSRNCP.m'));
    setenv('pathstr', pathstr);
    setenv('nv', num2str(imsize(1)));
    setenv('np', num2str(imsize(2)));
    setenv('ns', num2str(imsize(3)));

    unph = zeros(imsize);
    for echo_num_i = 1:imsize(4)
        setenv('echo_num', num2str(echo_num_i));

        fid = fopen(['wrapped_phase' num2str(echo_num_i) '.dat'],'w');
        fwrite(fid, ph_corr(:,:,:,echo_num_i), 'float');
        fclose(fid);

        bash_script = ['${pathstr}/3DSRNCP wrapped_phase${echo_num}.dat mask_unwrp.dat ' ...
            'unwrapped_phase${echo_num}.dat $nv $np $ns reliability${echo_num}.dat'];
        unix(bash_script);

        fid = fopen(['unwrapped_phase' num2str(echo_num_i) '.dat'],'r');
        tmp = fread(fid, 'float'); fclose(fid);
        unph(:,:,:,echo_num_i) = reshape(tmp - round(mean(tmp(mask==1))/(2*pi))*2*pi, imsize(1:3)).*mask;

        fid = fopen(['reliability' num2str(echo_num_i) '.dat'],'r');
        reliability_raw = fread(fid, 'float'); fclose(fid);
        reliability_raw = reshape(reliability_raw, imsize(1:3));

        nii = make_nii(reliability_raw.*mask, vox);
        save_nii(nii, ['reliability_raw' num2str(echo_num_i) '.nii']);
    end
end

nii = make_nii(unph, vox);
save_nii(nii, 'unph_bestpath.nii');

% 2pi jumps correction (requires precomputed unph_diff.nii)
if exist('unph_diff.nii', 'file')
    nii = load_nii('unph_diff.nii');
    unph_diff = double(nii.img)/2;

    for echo = 2:imsize(4)
        meandiff = unph(:,:,:,echo)-unph(:,:,:,1)-double(echo-1)*unph_diff;
        meandiff = mean(meandiff(mask==1));
        njump = round(meandiff/(2*pi));
        disp(['    ' num2str(njump) ' 2pi jumps for TE' num2str(echo)]);
        unph(:,:,:,echo) = (unph(:,:,:,echo) - njump*2*pi).*mask;
    end
else
    warning('unph_diff.nii not found. Skipping explicit 2pi-jump correction.');
end

disp('--> magnitude weighted LS fit of phase to TE ...');
[tfs, fit_residual] = echofit(unph, mag, TE, 0);

tfs = tfs/(2.675e8*3)*1e6;
nii = make_nii(tfs, vox);
save_nii(nii, 'tfs.nii');

fit_residual_blur = smooth3(fit_residual, 'box', round(1./vox)*2+1);
nii = make_nii(fit_residual_blur, vox);
save_nii(nii, 'fit_residual_blur.nii');
% R = ones(size(fit_residual_blur));
% R(fit_residual_blur >= 100) = 0;

% lbv_tol = 0.01;
% lbv_peel = 0;
% tv_reg = 5e-4;
% inv_num = 500;

% if any(strcmpi('lbv', bkg_rm))
%     disp('--> LBV to remove background field ...');
%     lfs_lbv = LBV(tfs, mask, imsize(1:3), vox, lbv_tol, lbv_peel);
%     mask_lbv = ones(imsize(1:3));
%     mask_lbv(lfs_lbv==0) = 0;
%     lfs_lbv = lfs_lbv - poly3d(lfs_lbv, mask_lbv);

%     mkdir('LBV');
%     nii = make_nii(lfs_lbv.*mask_lbv, vox);
%     save_nii(nii, 'LBV/lfs_lbv.nii');

%     disp('--> TV susceptibility inversion on LBV...');
%     sus_lbv = tvdi(lfs_lbv, mask_lbv, vox, tv_reg, mag(:,:,:,end), z_prjs, inv_num);
%     nii = make_nii(sus_lbv.*mask_lbv, vox);
%     save_nii(nii, ['LBV/sus_lbv_tv_' num2str(tv_reg) '_num_' num2str(inv_num) '.nii']);
% end

% if any(strcmpi('pdf', bkg_rm))
%     disp('--> PDF to remove background field ...');
%     [lfs_pdf, mask_pdf] = projectionontodipolefields(tfs, mask, vox, mag(:,:,:,end), z_prjs);

%     mkdir('PDF');
%     nii = make_nii(lfs_pdf, vox);
%     save_nii(nii, 'PDF/lfs_trunc_pdf.nii');

%     disp('--> TV susceptibility inversion on PDF...');
%     sus_pdf = tvdi(lfs_pdf, mask_pdf, vox, tv_reg, mag(:,:,:,end), z_prjs, inv_num);
%     nii = make_nii(sus_pdf.*mask_pdf, vox);
%     save_nii(nii, ['PDF/sus_trunc_pdf_tv_' num2str(tv_reg) '_num_' num2str(inv_num) '.nii']);
% end

% % Tik-QSM
% pad_tfs = padarray(tfs, [0 0 20]);
% pad_mask = padarray(mask.*R, [0 0 20]);

% Tik_weight = 0.005;
% TV_weight = 0.003;
% [chi, ~] = tikhonov_qsm(pad_tfs, pad_mask, 1, pad_mask, pad_mask, TV_weight, Tik_weight, vox, z_prjs, 200);
% nii = make_nii(chi(:,:,21:end-20).*pad_mask(:,:,21:end-20), vox);
% save_nii(nii, ['chi_brain_pad20_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight) '_200.nii']);

% disp('QSM reconstruction completed.');
end

function files = get_echo_files(folder, pattern)
all_files = dir(fullfile(folder, '*.nii'));
ids = [];
keep = {};
for i = 1:numel(all_files)
    tok = regexp(all_files(i).name, pattern, 'tokens', 'once');
    if isempty(tok)
        continue;
    end
    ids(end+1) = str2double(tok{1}); %#ok<AGROW>
    keep{end+1} = all_files(i).name; %#ok<AGROW>
end

if isempty(ids)
    files = {};
    return;
end

[~,ord] = sort(ids);
files = cell(1, numel(ord));
for i = 1:numel(ord)
    s.name = keep{ord(i)};
    files{i} = s;
end
end
