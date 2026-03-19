function b0_correct_batch_3T(root_dir, TE1_ms, ES_ms, use_z_only)
% Batch B0 correction for all QSM folders under MEGRE_INVIVO.
% Requires b0_correct_magnitude_3T.m in path.
%
% It looks for QSM folders named:
%   QSM_EAO_FLASH_mc_... or QSM_EAO_FLASH_mc_..._aligned
% and maps each one to the matching magnitude folder:
%   EAO_FLASH_mc_..._nifti or EAO_FLASH_mc_..._nifti_aligned
%
% Example:
%   addpath('/Users/uqhsun8/Documents/New project');
%   b0_correct_batch_3T('/Volumes/LaCie_Bottom/collaborators/Eva_Alonso_Ortiz/MEGRE_INVIVO', 2.4, 1.2, false);

if nargin < 1 || isempty(root_dir)
    root_dir = '/Volumes/LaCie_Bottom/collaborators/Eva_Alonso_Ortiz/MEGRE_INVIVO';
end
if nargin < 2 || isempty(TE1_ms)
    TE1_ms = 2.4;
end
if nargin < 3 || isempty(ES_ms)
    ES_ms = 1.2;
end
if nargin < 4 || isempty(use_z_only)
    use_z_only = false;
end

if ~exist(root_dir, 'dir')
    error('Root folder not found: %s', root_dir);
end

qsm_dirs = dir(fullfile(root_dir, '**', 'QSM_EAO_FLASH_mc_*'));
qsm_dirs = qsm_dirs([qsm_dirs.isdir]);

if isempty(qsm_dirs)
    error('No QSM_EAO_FLASH_mc_* folders found under: %s', root_dir);
end

fprintf('Found %d QSM folders.\n', numel(qsm_dirs));

n_ok = 0;
n_fail = 0;

for i = 1:numel(qsm_dirs)
    qsm_dir = fullfile(qsm_dirs(i).folder, qsm_dirs(i).name);

    % Require tfs.nii from QSM pipeline.
    if ~exist(fullfile(qsm_dir, 'tfs.nii'), 'file')
        fprintf('Skip (no tfs.nii): %s\n', qsm_dir);
        continue;
    end

    qsm_name = qsm_dirs(i).name;

    % Map QSM name back to sequence base.
    seq_base = regexprep(qsm_name, '^QSM_', '');
    seq_base = regexprep(seq_base, '_aligned$', '');

    is_aligned = ~isempty(regexp(qsm_name, '_aligned$', 'once'));

    % Find sibling folder that actually contains magnitude echoes.
    if is_aligned
        cand = dir(fullfile(qsm_dirs(i).folder, [seq_base '*_nifti_aligned']));
    else
        cand = dir(fullfile(qsm_dirs(i).folder, [seq_base '*_nifti']));
    end
    cand = cand([cand.isdir]);
    found = '';
    for c = 1:numel(cand)
        d = fullfile(cand(c).folder, cand(c).name);
        if exist(fullfile(d, 'mag1.nii'), 'file')
            found = d;
            break;
        end
    end
    mag_dir = found;

    if isempty(mag_dir) || ~exist(mag_dir, 'dir')
        fprintf(2, 'Skip (no matching magnitude folder): %s\n', qsm_dir);
        n_fail = n_fail + 1;
        continue;
    end

    fprintf('\nB0 correcting\n  mag: %s\n  qsm: %s\n', mag_dir, qsm_dir);

    try
        b0_correct_magnitude_3T(mag_dir, qsm_dir, TE1_ms, ES_ms, use_z_only);
        n_ok = n_ok + 1;
    catch ME
        fprintf(2, 'FAILED: %s\n  %s\n', qsm_dir, ME.message);
        n_fail = n_fail + 1;
    end
end

fprintf('\nBatch B0 correction finished. Success=%d  Failed=%d\n', n_ok, n_fail);
end
