function qsm_recon_run_all_subjects(root_dir)
% Run QSM reconstruction for all 5mm and 25mm MEGRE series under root_dir.
% Uses qsm_recon_from_nifti(mag_dir, ph_dir, out_dir).
%
% It scans for:
%   EAO_FLASH_mc_5mm_*_nifti
%   EAO_FLASH_mc_25mm_*_nifti
% (and *_nifti_aligned variants), pairs mag/ph by folder content.
%
% Example:
%   addpath('/Users/uqhsun8/Documents/New project');
%   qsm_recon_run_all_subjects('/Volumes/LaCie_Bottom/collaborators/Eva_Alonso_Ortiz/MEGRE_INVIVO');

if nargin < 1 || isempty(root_dir)
    root_dir = '/Volumes/LaCie_Bottom/collaborators/Eva_Alonso_Ortiz/MEGRE_INVIVO';
end

if ~exist(root_dir, 'dir')
    error('Root folder not found: %s', root_dir);
end

patterns = { ...
    '**/EAO_FLASH_mc_5mm_*_nifti', ...
    '**/EAO_FLASH_mc_25mm_*_nifti', ...
    '**/EAO_FLASH_mc_5mm_*_nifti_aligned', ...
    '**/EAO_FLASH_mc_25mm_*_nifti_aligned' ...
};

dirs_all = [];
for i = 1:numel(patterns)
    d = dir(fullfile(root_dir, patterns{i}));
    if ~isempty(d)
        dirs_all = [dirs_all; d(:)]; %#ok<AGROW>
    end
end

if isempty(dirs_all)
    error('No matching 5mm/25mm nifti folders found under: %s', root_dir);
end

% Build pairing table by parent + sequence base name
pairs = struct();
for i = 1:numel(dirs_all)
    if ~dirs_all(i).isdir
        continue;
    end
    dpath = fullfile(dirs_all(i).folder, dirs_all(i).name);

    has_mag = ~isempty(dir(fullfile(dpath, 'mag1.nii')));
    has_ph  = ~isempty(dir(fullfile(dpath, 'ph1.nii')));
    if ~(has_mag || has_ph)
        continue;
    end

    parent = dirs_all(i).folder;
    base = regexprep(dirs_all(i).name, '_\d+_nifti(_aligned)?$', '');
    is_aligned = ~isempty(regexp(dirs_all(i).name, '_nifti_aligned$', 'once'));

    key = matlab.lang.makeValidName([parent '__' base '__' num2str(is_aligned)]);

    if ~isfield(pairs, key)
        pairs.(key) = struct( ...
            'parent', parent, ...
            'base', base, ...
            'is_aligned', is_aligned, ...
            'mag', '', ...
            'ph', '' ...
        );
    end

    if has_mag
        pairs.(key).mag = dpath;
    end
    if has_ph
        pairs.(key).ph = dpath;
    end
end

keys = fieldnames(pairs);
if isempty(keys)
    error('No valid mag/ph folder pairs were found.');
end

fprintf('Found %d candidate scan groups.\n', numel(keys));

for i = 1:numel(keys)
    item = pairs.(keys{i});

    if isempty(item.mag) || isempty(item.ph)
        fprintf('Skipping incomplete pair: %s | %s (mag=%s, ph=%s)\n', ...
            item.parent, item.base, item.mag, item.ph);
        continue;
    end

    if item.is_aligned
        out_dir = fullfile(item.parent, ['QSM_' item.base '_aligned']);
    else
        out_dir = fullfile(item.parent, ['QSM_' item.base]);
    end

    fprintf('\nRunning QSM\n  mag: %s\n  ph : %s\n  out: %s\n', item.mag, item.ph, out_dir);

    try
        qsm_recon_from_nifti(item.mag, item.ph, out_dir);
    catch ME
        fprintf(2, 'FAILED: %s | %s\n  %s\n', item.parent, item.base, ME.message);
    end
end

fprintf('\nAll subject processing finished.\n');
end
