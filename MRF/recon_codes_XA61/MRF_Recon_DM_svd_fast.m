function [maps_all, img_all] = MRF_Recon_DM_svd_fast(FilePath, slice_range, SaveMapsPaths, SaveImgPaths)
%%-----------------------------------------------------------------------%%
%  Batched / vectorised rewrite of MRF_Recon_DM_svd.m
%
%  Reconstructs ALL requested slices in a single call:
%    - dictionary is loaded / SVD-compressed ONCE (not once per slice)
%    - raw data (.dat) is read ONCE via mapVBVD (not once per slice)
%    - trajectory + NUFFT structure are built ONCE
%    - temporal (SVD) compression of the raw data is applied on the fly
%      per slice (no 4-5 GB intermediate array, no nested scalar loops)
%    - NUFFT adjoints are batched over coils/components (multi-column
%      nufft_adj instead of one call per channel per component)
%    - coil combination (opt_comb) and dictionary matching lookups are
%      fully vectorised (no per-pixel loops)
%
%  Per-slice numerics are kept equivalent to the original pipeline:
%    - coil compression is still computed per slice (as the original did)
%    - the dictionary normalisation replicates the original code exactly,
%      including its quirk of writing lookup(1,:) AFTER normalisation
%      (so lookup(1,:) becomes ~1 -- flagged below)
%
%  Input:  FilePath      raw data file (.dat)
%          slice_range   vector of slice indices, or 0/[] for all slices
%          SaveMapsPaths (optional) cell array of .nii paths (one per slice)
%                        or a sprintf pattern containing %d, e.g.
%                        './recons/maps_slice%d.nii'
%          SaveImgPaths  (optional) same, for the aliased SVD images
%
%  Output: maps_all (4, nSlices, nRe, nPh)   PD/T1/T2/B0 maps
%          img_all  (nSlices, nRe, nPh, nSv) aliased SVD images (single)
%%-----------------------------------------------------------------------%%
addpath(genpath('./_src'));
addpath(genpath('./'));

maxNumCompThreads(10);

if nargin < 2, slice_range = 0; end
if nargin < 3, SaveMapsPaths = []; end
if nargin < 4, SaveImgPaths  = []; end

%%-----------------------------------------------------------------------%%
% Settings (same as original)
%%-----------------------------------------------------------------------%%
includes_noise_scan = true;
reset_noise_cov     = true;
remove_os_before_FT = false;
remove_os_after__FT = true;
compress_rx = 8;      % max number of svd compressed coil elements
matrix4__rx = 96;     % central area of k-space used for RX estimation
kShift      = 0;      % gradient delay correction (in dwelltimes)
svd_range   = 200;    % number of temporal SVD components

% 'gram' : eigen-decomposition of atoms*atoms' (fast, low memory).
%          Component phases are arbitrary, but since dictionary AND data
%          are projected with the same U this cancels in the matching --
%          the parameter maps are unaffected (SVD images may differ by a
%          per-component phase w.r.t. the original code).
% 'econ' : svd(atoms,'econ'), bit-identical to the original (much slower).
svd_method  = 'gram';

comp_batch  = 4;      % SVD components gridded per nufft_adj call
                      % (memory / speed trade-off; each call handles
                      %  comp_batch * nCh k-space columns at once)

%%-----------------------------------------------------------------------%%
% Load + compress dictionary  (ONCE)
%%-----------------------------------------------------------------------%%
fprintf('loading dictionary...\n');
S = load('dictionary_small_nosvd.mat');
dict = S.dictionary;
clear S;

fprintf('computing temporal SVD basis (%s)...\n', svd_method);
switch svd_method
    case 'gram'
        G = dict.atoms * dict.atoms';          % (nTime x nTime) Gram matrix
        G = (G + G') / 2;                      % enforce Hermitian symmetry
        [V, D]   = eig(double(G));
        [~, ord] = sort(real(diag(D)), 'descend');
        U = V(:, ord(1:svd_range));
    case 'econ'
        [U, ~, ~] = svd(dict.atoms, 'econ');
        U = U(:, 1:svd_range);
    otherwise
        error('unknown svd_method');
end

% compress + normalise dictionary (vectorised).
% NOTE: replicates the original code exactly -- lookup(1,:) is written
% AFTER the normalisation, so it ends up ~1 (probable bug in the original,
% kept for identical behaviour; fast_match then uses pdFact directly).
dict.atoms = (dict.atoms.' * U).';             % non-conjugate, as original
nrm = sqrt(sum(abs(dict.atoms).^2, 1));
dict.atoms = dict.atoms ./ nrm;
dict.lookup(1,:) = sqrt(sum(abs(dict.atoms).^2, 1));
dict.atoms = single(dict.atoms);               % single-precision matching
fprintf('---dictionary compressed (%d atoms, %d components)\n', ...
        size(dict.atoms,2), svd_range);

%%-----------------------------------------------------------------------%%
% Load raw data  (ONCE, all slices)
%%-----------------------------------------------------------------------%%
if nargin < 1 || isempty(FilePath)
    MrData = RawDataObj(remove_os_before_FT);
else
    [FileFolder, FileName, FileExt] = fileparts(FilePath);
    MrData = RawDataObj(remove_os_before_FT, [FileFolder, filesep], [FileName, FileExt]);
end

% dump the ascii header once (as the original did)
fileID = fopen([MrData.file_path '/' MrData.file_name]);
bytes  = fread(fileID, 1000000, 'char');
fclose(fileID);
fileID = fopen('header.txt','w');
fwrite(fileID, bytes, 'char');
fclose(fileID);
clear bytes;

dim0 = MrData.Dim;   % nEc, nSl, nCh, nRe, nLi, nSe (raw)
disp([num2str(dim0.nSl) ' Slices']);

if isempty(slice_range) || isequal(slice_range, 0)
    slice_list = 1:dim0.nSl;
else
    slice_list = slice_range(:).';
end
if max(slice_list) > dim0.nSl || min(slice_list) < 1
    error('incorrect slice setting!');
end
nSlices = numel(slice_list);

% expand sprintf-pattern save paths into cell arrays
SaveMapsPaths = expand_paths(SaveMapsPaths, slice_list);
SaveImgPaths  = expand_paths(SaveImgPaths,  slice_list);

%%-----------------------------------------------------------------------%%
% Noise / imaging set split (indices only; data is stripped per slice
% AFTER coil compression, matching the original order of operations)
%%-----------------------------------------------------------------------%%
if includes_noise_scan
    noise_sets = 11:50;    % first lines may contain stimulated echoes
    data_sets  = 51:dim0.nSe;
else
    noise_sets = [];
    data_sets  = 1:dim0.nSe;
end
nSeT = numel(data_sets);
if nSeT ~= size(U,1)
    error('number of imaging sets (%d) does not match dictionary time points (%d)', ...
          nSeT, size(U,1));
end

%%-----------------------------------------------------------------------%%
% Trajectory + NUFFT structure  (ONCE) -- vectorised get_trajectory
%%-----------------------------------------------------------------------%%
ang = MrData.angles(1, :, data_sets);          % (1, nLi, nSeT), echo 1
ang = ang(:).';                                % spokes: li fastest, then se

nRe = dim0.nRe;
rho = ((1:nRe) - (nRe+1)/2 + kShift) / nRe;

x = rho.' * sin(ang);                          % (nRe, nSpokes)
y = rho.' * cos(ang);
k = x + 1i*y;
w = sqrt(x.^2 + y.^2);
w = w / max(w(:));
nSpokes = size(k, 2);
clear x y;

fprintf('preparing NUFFT structure...\n');
om = [real(k(:)), imag(k(:))] * 2*pi;
st = nufft_init(om, [nRe, nRe], [6,6], [nRe, nRe]*2, [nRe, nRe]/2, 'kaiser');
wvec = w(:);
clear om k w;
fprintf('NUFFT structure ready!\n');

% central-readout window for the RX estimation (same logic as make_rx)
r = round(matrix4__rx);
if r < 1 || r >= nRe
    p1 = 1;  p2 = nRe;
else
    p1 = (nRe - r)/2;
    p2 = round(nRe/2 + r/2 + 1);
end

% oversampling crop indices
if remove_os_after__FT
    parI = round(nRe/4);
    staI = parI + 1;
    endI = round(3*parI);
else
    staI = 1;
    endI = nRe;
end
nCrop = endI - staI + 1;

%%-----------------------------------------------------------------------%%
% Per-slice reconstruction
%%-----------------------------------------------------------------------%%
maps_all = zeros(4, nSlices, nCrop, nCrop);
img_all  = zeros(nSlices, nCrop, nCrop, svd_range, 'like', single(1i));

Us = single(U);

for isl = 1:nSlices
    sl = slice_list(isl);
    fprintf('=== slice %d (%d of %d) ===\n', sl, isl, nSlices);

    %% ---- per-slice coil compression (identical to RawDataObj method) --
    raw = MrData.data(:, sl, :, :, :, :);          % (nEc,1,nCh0,nRe,nLi,nSe)
    tmp = permute(raw, [3,1,2,4,5,6]);
    tmp = tmp(:,:);                                % (nCh0, nEc*nRe*nLi*nSe)
    [Uc, ~, ~] = svd(tmp, 'econ');
    Uc  = Uc(:, 1:compress_rx);
    tmp = Uc' * tmp;                               % (nCh, ...)
    nCh = compress_rx;
    slc = reshape(tmp, [nCh, dim0.nEc, nRe, dim0.nLi, dim0.nSe]);
    clear raw tmp Uc;

    %% ---- noise covariance ---------------------------------------------
    if reset_noise_cov || isempty(noise_sets)
        invNoiseCov = eye(nCh);
    else
        noi = slc(:, 1, :, :, noise_sets);
        noi = reshape(noi, nCh, []);
        noisecov = noi * noi';                     % sum n_i .* conj(n_j)
        invNoiseCov = inv(noisecov);
        invNoiseCov = invNoiseCov / norm(invNoiseCov);
        clear noi noisecov;
    end

    %% ---- imaging data: echo 1, imaging sets ---------------------------
    dat = reshape(slc(:, 1, :, :, data_sets), [nCh, nRe, dim0.nLi, nSeT]);
    dat = single(dat);
    clear slc;

    %% ---- RX sensitivities (make_rx, SOS mode, vectorised) -------------
    kd1 = dat .* reshape(Us(:,1), [1,1,1,nSeT]);   % 1st SVD component weights
    kd1 = reshape(kd1, [nCh, nRe, nSpokes]);
    kd1(:, 1:p1, :)   = 0;                         % keep central k-space only
    kd1(:, p2:end, :) = 0;
    X = double(reshape(permute(kd1, [2,3,1]), [nRe*nSpokes, nCh]));
    coil_rx = nufft_adj(X .* wvec, st) / nRe;      % (nRe, nRe, nCh)
    clear kd1 X;

    I_body = sqrt(abs(sum(coil_rx .* conj(coil_rx), 3)));
    I_rx   = coil_rx ./ I_body;
    clear coil_rx I_body;

    % fold the noise covariance into the rx profiles:
    %   s' * C * i  ==  sum( conj(S * conj(C)) .* I , coils )
    Seff = reshape(I_rx, [nRe*nRe, nCh]) * conj(invNoiseCov);
    clear I_rx;

    %% ---- matched-filter recon: batched NUFFT over coils+components ----
    img_sl = zeros(nRe, nRe, svd_range, 'like', single(1i));
    fprintf(' Matched Filter Reconstruction: ');
    for c0 = 1:comp_batch:svd_range
        cc  = c0:min(c0+comp_batch-1, svd_range);
        ncc = numel(cc);

        % on-the-fly temporal compression (replaces applyCompression)
        kd = dat .* reshape(Us(:,cc), [1,1,1,nSeT,ncc]);
        kd = permute(kd, [2,3,4,1,5]);             % (nRe,nLi,nSeT,nCh,ncc)
        X  = double(reshape(kd, [nRe*nSpokes, nCh*ncc]));
        clear kd;

        imgs = nufft_adj(X .* wvec, st) / nRe;     % (nRe, nRe, nCh*ncc)
        clear X;

        % vectorised opt_comb
        I    = reshape(imgs, [nRe*nRe, nCh, ncc]);
        comb = sum(conj(Seff) .* I, 2);            % (npix, 1, ncc)
        img_sl(:,:,cc) = single(reshape(comb, [nRe, nRe, ncc]));
        clear imgs I comb;

        fprintf('%d ', cc(end));
    end
    fprintf('done\n');
    clear dat;

    %% ---- remove oversampling ------------------------------------------
    img_sl = img_sl(staI:endI, staI:endI, :);
    img_all(isl, :, :, :) = reshape(img_sl, [1, nCrop, nCrop, svd_range]);

    %% ---- dictionary matching (vectorised fast_match) ------------------
    maps_sl = fast_match_vec(img_sl, dict);        % (4, nCrop, nCrop)
    maps_all(:, isl, :, :) = reshape(maps_sl, [4, 1, nCrop, nCrop]);

    %% ---- save (same file layout as the original) ----------------------
    if ~isempty(SaveMapsPaths)
        maps_save = maps_sl;
        maps_save(1,:,:) = abs(maps_sl(1,:,:));
        niftiwrite(permute(maps_save, [2,3,1]), SaveMapsPaths{isl});
    end
    if ~isempty(SaveImgPaths)
        % (nCrop, nCrop, 2*nSv): volumes 1:nSv = real, nSv+1:2*nSv = imag
        data = cat(3, real(img_sl), imag(img_sl));
        niftiwrite(data, SaveImgPaths{isl});
        clear data;
    end
    clear img_sl maps_sl maps_save Seff;
end

%%-----------------------------------------------------------------------%%
% Combined 4D maps: (nRe, nPh, nSlices, 4) -- 3rd dim slice, 4th dim map
% (PD / T1 / T2 / B0). Written next to the per-slice maps files.
%%-----------------------------------------------------------------------%%
if ~isempty(SaveMapsPaths)
    maps4d = maps_all;
    maps4d(1,:,:,:) = abs(maps_all(1,:,:,:));
    maps4d = permute(real(maps4d), [3,4,2,1]);      % (nCrop,nCrop,nSl,4)
    outdir = fileparts(SaveMapsPaths{1});
    if isempty(outdir), outdir = '.'; end
    all_path = fullfile(outdir, 'maps_all.nii');
    niftiwrite(maps4d, all_path);
    fprintf('combined 4D maps saved: %s\n', all_path);
    clear maps4d;
end

disp('done!');

end % /MRF_Recon_DM_svd_fast


%%=======================================================================%%
% Vectorised fast_match (chunked correlation + linear-index lookup;
% same math as fast_match.m, per-slice PD normalisation preserved)
%%=======================================================================%%
function maps = fast_match_vec(imgc, dict)

[n1, n2, nSv] = size(imgc);
npix = n1 * n2;

imv = reshape(imgc, [npix, nSv]).';            % (nSv, npix), single
nDi  = size(dict.atoms, 2);
part = dict.chuck;
nChunks = ceil(nDi / part);

posm = zeros(nChunks, npix);
corm = zeros(nChunks, npix, 'like', single(1i));

fprintf(' Matching: ');
idx = 1;
for ds = 1:part:nDi
    de = min(ds + part - 1, nDi);
    [cor, pos] = max(dict.atoms(:, ds:de)' * imv, [], 1);
    posm(idx,:) = pos + ds - 1;
    corm(idx,:) = cor;
    idx = idx + 1;
    fprintf('%d%% ', round(100*de/nDi));
end
fprintf('\n');

[pdFact, sel] = max(corm, [], 1);
best = posm(sub2ind([nChunks, npix], sel, 1:npix));

maps = double(dict.lookup(:, best));
maps(1,:) = double(pdFact) ./ maps(1,:);       % convert norm to PD
maps = reshape(maps, [4, n1, n2]);

% normalise PD (per slice, as in the original per-slice calls)
maps(1,:,:) = maps(1,:,:) ./ max(abs(reshape(maps(1,:,:), 1, [])));

end % /fast_match_vec


%%=======================================================================%%
% Expand a sprintf pattern ('...%d...') into per-slice paths
%%=======================================================================%%
function paths = expand_paths(in, slice_list)

if isempty(in)
    paths = [];
elseif iscell(in)
    if numel(in) ~= numel(slice_list)
        error('number of save paths must match number of slices');
    end
    paths = in;
elseif ischar(in) || isstring(in)
    paths = arrayfun(@(s) sprintf(char(in), s), slice_list, 'UniformOutput', false);
else
    error('save paths must be a cell array or a sprintf pattern');
end

end % /expand_paths
