function b0_correct_magnitude_3T(mag_dir, qsm_dir, TE1_ms, ES_ms, use_z_only)
% B0 correction of multi-echo magnitude images at 3T using linear phase model.
%
% Inputs:
%   mag_dir   : folder with mag1.nii ... magN.nii
%   qsm_dir   : folder containing tfs.nii (ppm)
%   TE1_ms    : first echo time in ms (default 2.4)
%   ES_ms     : echo spacing in ms (default 1.2)
%   use_z_only: true for z-gradient only, false for all gradients (default false)
%
% Outputs (written under qsm_dir/B0corr):
%   imgC_3T.nii       : corrected magnitude, 4D
%   b0_weights_3T.nii : correction weights, 4D
%
% Example:
% b0_correct_magnitude_3T( ...
%   '/Volumes/LaCie_Bottom/collaborators/Eva_Alonso_Ortiz/MEGRE_INVIVO/20160726A_dicom_sorted/20160726/Sequence_Development_Eva - 1/EAO_FLASH_mc_25mm_7_nifti', ...
%   '/Volumes/LaCie_Bottom/collaborators/Eva_Alonso_Ortiz/MEGRE_INVIVO/20160726A_dicom_sorted/20160726/Sequence_Development_Eva - 1/QSM_EAO_FLASH_mc_25mm', ...
%   2.4, 1.2, false);

if nargin < 1 || isempty(mag_dir)
    error('mag_dir is required.');
end
if nargin < 2 || isempty(qsm_dir)
    error('qsm_dir is required.');
end
if nargin < 3 || isempty(TE1_ms)
    TE1_ms = 2.4;
end
if nargin < 4 || isempty(ES_ms)
    ES_ms = 1.2;
end
if nargin < 5 || isempty(use_z_only)
    use_z_only = false;
end

tfs_path = fullfile(qsm_dir, 'tfs.nii');
if ~exist(tfs_path, 'file')
    error('Cannot find tfs.nii in qsm_dir: %s', qsm_dir);
end

mag_files = get_echo_files(mag_dir);
if isempty(mag_files)
    error('No mag*.nii found in: %s', mag_dir);
end

echo_num = numel(mag_files);
TE = (TE1_ms + (0:echo_num-1)*ES_ms) / 1000; % seconds

% Load first magnitude to get image geometry
nii_mag0 = load_nii(fullfile(mag_dir, mag_files{1}));
mag_size3 = size(double(nii_mag0.img));
vox = double(nii_mag0.hdr.dime.pixdim(2:4)); % mm

% Load all magnitude echoes
mag_all = zeros([mag_size3, echo_num], 'double');
for e = 1:echo_num
    nii_m = load_nii(fullfile(mag_dir, mag_files{e}));
    mag_all(:,:,:,e) = double(nii_m.img);
end

% Load tfs (ppm) from QSM pipeline
nii_tfs = load_nii(tfs_path);
tfs = double(nii_tfs.img);
if ~isequal(size(tfs), mag_size3)
    error('tfs size %s does not match magnitude size %s.', mat2str(size(tfs)), mat2str(mag_size3));
end

% 3T conversion: ppm -> Hz
% 1 ppm at 3T = (gamma/2pi)*B0*1e-6 = 42.57747892*3 ~= 127.7324 Hz
tfs_hertz = tfs * 127.73243676;

% Field gradients (Hz/mm), then convert to Hz/voxel for sinc model.
[gx, gy, gz] = gradient(tfs_hertz, vox(1), vox(2), vox(3));
gx(isnan(gx)) = 0; gy(isnan(gy)) = 0; gz(isnan(gz)) = 0;

gxv = gx * vox(1);
gyv = gy * vox(2);
gzv = gz * vox(3);

weights = zeros(size(mag_all), 'double');
imgC = zeros(size(mag_all), 'double');

for e = 1:echo_num
    if use_z_only
        w = sinc(gzv * TE(e));
    else
        w = sinc(gxv * TE(e)) .* sinc(gyv * TE(e)) .* sinc(gzv * TE(e));
    end

    % Avoid unstable division in heavily dephased voxels
    w(w < 0.125) = Inf;
    imgC(:,:,:,e) = mag_all(:,:,:,e) ./ w;
    weights(:,:,:,e) = w;
end

weights(weights == Inf) = 0;

out_dir = fullfile(qsm_dir, 'B0corr');
if ~exist(out_dir, 'dir')
    mkdir(out_dir);
end

nii = make_nii(imgC, vox);
save_nii(nii, fullfile(out_dir, 'imgC_3T.nii'));

nii = make_nii(weights, vox);
save_nii(nii, fullfile(out_dir, 'b0_weights_3T.nii'));

disp(['Saved: ' fullfile(out_dir, 'imgC_3T.nii')]);
disp(['Saved: ' fullfile(out_dir, 'b0_weights_3T.nii')]);
end

function files = get_echo_files(mag_dir)
d = dir(fullfile(mag_dir, 'mag*.nii'));
ids = [];
names = {};
for i = 1:numel(d)
    tok = regexp(d(i).name, '^mag(\d+)\.nii$', 'tokens', 'once');
    if isempty(tok)
        continue;
    end
    ids(end+1) = str2double(tok{1}); %#ok<AGROW>
    names{end+1} = d(i).name; %#ok<AGROW>
end

if isempty(ids)
    files = {};
    return;
end

[~, ord] = sort(ids);
files = names(ord);
end

