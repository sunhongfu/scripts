% script for reconstructing phase from undersampled k-space

clear
load /Users/uqhsun8/DATA/CS-phase/prevent198/pc/kspace.mat
load /Users/uqhsun8/DATA/CS-phase/prevent198/pc/yangMask_ratio4.mat
mkdir /Users/uqhsun8/DATA/CS-phase/prevent198/zhao/AF4
cd /Users/uqhsun8/DATA/CS-phase/prevent198/zhao/AF4

mask = Mask;

% correct fftshift etc for kspace
k = ifftshift(ifft(ifftshift(fft(fftshift(k,1),[],1),1),[],1),1);
k = ifftshift(ifft(ifftshift(fft(fftshift(k,2),[],2),2),[],2),2);
k = ifftshift(ifft(ifftshift(fft(fftshift(k,3),[],3),3),[],3),3);

% fft into individual 2D kspace
k = fftshift(fft(fftshift(k,3),[],3),3);

img_full = zeros(size(k));
img_npc = zeros(size(k));
img_pc = zeros(size(k));
img_zhao = zeros(size(k));

% for each TE
for echo = 1: size(k,4)

    tic

    % for each slice:
    for slice = 1:size(k,3)

        ksp = k(:,:,slice,echo);

        ksp = ksp/max(max(max(abs(ifft2c(ksp)))));
        FOV = size(ksp);
        [sx, sy, nc] = size(ksp);

        y = ksp.*mask;
        % ksp: fully sampled kspace
        % mask: under-sampling pattern

        % x = fftshift(fft2(fftshift(ksp)))/sqrt(sx*sy);
        F_full = p2DFT(ones(size(mask)),[sx, sy, nc]);
        S_single = Identity;
        [m_full, p_full] = pfinit(ksp, S_single, F_full, 1);
        x = m_full.*exp(1j*p_full);

        img_full(:,:,slice,echo) = x;


        %% Create linear operators
        C = Identity;
        S = Identity;
        F = p2DFT(mask,[sx, sy, nc]);
        M = Identity;
        P = Identity;

        weights = ones([sx,sy,nc]);
        maps = ones([sx,sy,nc]);

        %% Create proximal operators

        lambdam = 0.003;
        lambdap = 0.005;

        Pm = wave_thresh('db4', 3, lambdam);

        Pp = wave_thresh('db4', 3, lambdap);

        %% Get phase wraps
        ncycles = 16;
        [m0, p0, W] = pfinit(y, S, F, ncycles);
        % m0 and p0 are initial guess for magnitude and phase, base on zero filling

% (1) first method
        % %% Phase regularized reconstruction without phase cycling

        % niter = 100;
        % ninneriter = 10;
        % doplot = 1;
        % dohogwild = 1;

        % [mn, pn] = mprecon(y, F, S, C, M, P, Pm, Pp, m0, p0, {}, niter, ninneriter, dohogwild, doplot);

        % mn = mn .* sqrt(weights);

        % % figure, imshowf(abs(mn), [0, 1.0])
        % % figure, imshowf(abs(mn - abs(x)), [0, 0.2])
        % % figure, imshowf(pn .* (abs(x) > 0.05), [-pi, pi])

        % disp(psnr(abs(x), abs(mn)))

        % img_npc(:,:,slice,echo) = mn.*exp(1j*pn);

% (2) second method
        % %% Proposed phase regularized reconstruction with phase cycling

        % niter = 100;
        % ninneriter = 10;
        % doplot = 1;
        % dohogwild = 1;

        % [m, p] = mprecon(y, F, S, C, M, P, Pm, Pp, m0, p0, W, niter, ninneriter, dohogwild, doplot);

        % m = m .* sqrt(weights);

        % % figure, imshowf(abs(m), [0, 1.0])
        % % figure, imshowf(abs(abs(m) - abs(x)), [0, 0.2])
        % % figure, imshowf(p .* (abs(x) > 0.05), [-pi, pi])

        % disp(psnr(abs(x), abs(m)))

        % img_pc(:,:,slice,echo) = m.*exp(1j*p);


% (3) third method
        %% Zhao et al. Separate magnitude and phase reconstruction
        % Requires irt from Jeff Fessler.
        % Please run setup.m in the toolbox first.

        lambda_m = 0.3; % regularization parameter for magnitude
        lambda_p = 0.3; % regularization parameter for phase (rg2/rg4)

        im_mask = weights > 0.1;
        maps = maps .* im_mask;
        proxg_m = wave_thresh('db4', 3, lambda_m);

        y = ksp(mask == 1);
        samp = mask(:, :, 1) == 1; % change to logical for irt.

        setup; % set up the irt package

        [mi, xi] = separate_mag_phase_recon(y, samp, maps, im_mask, proxg_m, lambda_p);
        disp(psnr(abs(x) / max(abs(x(:))), abs(mi) / max(abs(mi(:)))))

        img_zhao(:,:,slice,echo) = mi.*exp(1j*xi);

    end

    toc
end

save all.mat