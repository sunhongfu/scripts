function img_pc = CS_Recon_2D_MC(ksp, mask, isNor, eval)
% function img_pc = CS_Recon_2D_MC(ksp, mask, maps, isNor, eval)
%CS_RECON2D_MC Summary of this function goes here
%   Detailed explanation goes here
% CS_Recon_2D: reconstruct one 2D slice using two conventional methods.
% ins: 1. fully sampled kspace data: ksp;
%         2. mask, subsampling mask/pattern.
%         3. isNor: whether to do amplitude-normalization before the
%         reconstruction. default: true;
%         4. eval: evaluation mode, when set to true, also return the fully
%         sampled and zero-filling results for a comparison. (I suggest only
%         use this mode to do a test on a sample 2D data to evaluate if the
%         algorithms have been properly set up). default: false;
% outs: 1. img_pc: phase cycling recon.
%          2. img_zhao: zhao's method recon.

if nargin < 2
    error('Not Enough Input Parameters');
end

if nargin < 5
    isNor = 1;
    eval = 0;
end

if nargin < 6
    isNor = 1;
    eval = 0;
end

if isNor
    scaling_factor = max(max(max(abs(ifft2c(ksp)))));
    disp(['Amplitude Normalization by: ', num2str(scaling_factor)]);
    % the following (yours) is incorrect normalization.
    % scaling_factor = ksp/max(max(max(abs(ifft2c(ksp)))));
    % let me put it more straightforward: in most situations. normalization
    % means that we would do such an operation: (x - a) / b, where a and b
    % are calculated from x. our situation is simpler here, which is an
    % amplitude-normalization (x / b). Zhuang, please think the reaon why we
    % only did amplitude normalization here?
else
    scaling_factor = 1;
end

ksp = ksp / scaling_factor; %% do amplitude normalization.
[sx, sy, nc] = size(ksp);


% mask = repmat(mask, [1,1,32]);

%disp(size(ksp))
%disp(size(mask))
%disp(size(maps))

y = ksp.*mask; %% subsampling happens; 

% % if eval
% %     disp('evaluation mode: saving fully-sampled results');
% %     F_full = p2DFT(ones(size(mask)),[sx, sy, nc]);
% %     S_single = Identity;
% %     [m_full, p_full] = pfinit(ksp, S_single, F_full, 1);
% %     x_full = m_full.*exp(1j*p_full);
% %     save('fully_sampled_label.mat', 'x_full');
% % end

%% Create linear operators
C = Identity;


% % % weights = ones([sx,sy,nc]);
% % % maps = ones([sx,sy,nc]);
% % weights = ones(256, 128); 

ksize = [6, 6];
[maps, weights] = ecalib(y, 24, ksize);
% [maps_old, weights] = ecalib(y, 24, ksize);

%%%%%%%%%%%%%%%%%%%%%%%
% ref coil to channel 32
maps = maps./repmat(maps(:,:,1)./abs(maps(:,:,1)),[1 1 32]);
% maps = abs(maps_old).*exp(1j*maps); % load your own offsets
maps(isnan(maps))=0;
maps(isinf(maps))=0;
%%%%%%%%%%%%%%%%%%%%%%%

S = ESPIRiT(maps, weights);
F = p2DFT(mask,[sx, sy, nc]);
M = Identity;
P = Identity; 

%% Create proximal operators

lambdam = 0.003;
lambdap = 0.005;

Pm = wave_thresh('db4', 3, lambdam);

Pp = wave_thresh('db4', 3, lambdap);

%% Get phase wraps
ncycles = 16;
% m0 and p0 are initial guess for magnitude and phase, base on zero filling
[m0, p0, W] = pfinit(y, S, F, ncycles);

if eval
    disp('evaluation mode: saving zero-filling results');
    x0 = m0.*exp(1j*p0);
    save('zero_filling_rec.mat', 'x0');
end

% (1) first method
%% Phase regularized reconstruction without phase cycling
%
%        niter =50;
%        ninneriter = 10;
%        doplot = 1;
%        dohogwild = 1;

%        [mn, pn] = mprecon(y, F, S, C, M, P, Pm, Pp, m0, p0, {}, niter, ninneriter, dohogwild, doplot);

%       mn = mn .* sqrt(weights);
%
% figure, imshowf(abs(mn), [0, 1.0])
% figure, imshowf(abs(mn - abs(x)), [0, 0.2])
% figure, imshowf(pn .* (abs(x) > 0.05), [-pi, pi])

%        disp(psnr(abs(x), abs(mn)))

%        img_npc(:,:,slice,echo) = mn.*exp(1j*pn);

% (2) second method
%% Proposed phase regularized reconstruction with phase cycling

niter = 10;  % default
ninneriter = 10; % default
doplot = 0;
dohogwild = 1;

tic
[m, p] = mprecon(y, F, S, C, M, P, Pm, Pp, m0, p0, W, niter, ninneriter, dohogwild, doplot);
toc

m = m .* sqrt(weights);

if eval
    figure, imshowf(abs(m), [0, 1.0])
    figure, imshowf(abs(abs(m) - abs(x)), [0, 0.2])
    figure, imshowf(p .* (abs(x) > 0.05), [-pi, pi])
    disp(psnr(abs(x), abs(m)))
end

img_pc = m.*exp(1j*p) * scaling_factor; % reverse the amplitude-normalization.


end

