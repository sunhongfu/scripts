% 20190116_093712_TOB_EpiBios_MHR_2400_M_I_D09_1_2_14_MGE

% # from acqp
% ##$ACQ_size=( 3 )
% 320 122 80
% ##$ACQ_ns_list_size=13
% ##$ACQ_ReceiverSelect=( 4 )
% Yes Yes Yes Yes


% appears to be unipolar echoes
readout = 'unipolar';

file = pwd;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              % 
%          load kspace (fid file)              %
%                                              %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

infile=[file,'/fid'];
infid=fopen(infile,'r','ieee-le');
[buf,count] = fread(infid,'int32');
raw=complex(buf(1:2:count),buf(2:2:count));

dim_x  = 320/2;
dim_y  = 122;
dim_z  = 80;
echoes = 13;
coils  = 4;

% raw=reshape(raw,[768,length(raw)/768]); % 192*4 {Each channel zero filled}
% kspace=raw(1:(dim_x*coils),:);          % Get rid of zeros

kspace=reshape(raw,[dim_x,coils,echoes,dim_y,dim_z]);
kspace=permute(kspace,[1,4,5,3,2]);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                                              % 
% %           Adjust for phase offset            %
% %                                              %    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% phoffset=0.665136984271868;
% fovphase=1.92;


% kspace=reshape(kspace,[dim_x,dim_y,(4*echoes*dim_z)]);

% for z=1:length(kspace)
%     for k=1:dim_y
%         kspace(:,k,z)=kspace(:,k,z)*exp(-1i*pi*2*phoffset*k/(fovphase*10));
%     end
% end

% kspace=reshape(kspace,[dim_x,dim_y,dim_z,echoes,coils]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              % 
%            Reconstruct Image                 %
%                                              %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hongfu add
kspace = fftshift(kspace,1);
kspace = fftshift(kspace,2);
kspace = fftshift(kspace,3);

image=zeros(dim_x,dim_y,dim_z,echoes,coils);
for coil = 1:coils
	for echo = 1:echoes
		image(:,:,:,echo,coil) = fftn(squeeze(kspace(:,:,:,echo,coil)));
	end
end


image = fftshift(image,1);
image = fftshift(image,2);
image = fftshift(image,3);

[tmp voxel_size matrix_size TE delta_TE CF Affine3D B0_dir TR NumEcho] = Read_Bruker_raw_sun(pwd);
clear tmp



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QSM recon
mkdir QSM
cd QSM

% save the channel 1 phase to check polarity
nii = make_nii(angle(image(:,:,:,:,1))); save_nii(nii,'ph_all_chan1.nii')

%% combine the coils
% sum-of-squres combine magnitude
mag_cmb = sqrt(sum(abs(image).^2,5));
nii = make_nii(mag_cmb, voxel_size);
save_nii(nii,'mag_cmb.nii');

imsize = size(image);
mkdir src

mag_corr = zeros(size(image,1), size(image,2), size(image,3), size(image,4));
ph_corr = zeros(size(image,1), size(image,2), size(image,3), size(image,4));

% For 'unipolar' readout, process all echoes together
if strcmp(readout,'unipolar')
    [ph_corr, mag_corr] = poem(abs(image), angle(image), voxel_size, TE);
elseif strcmp(readout,'bipolar')
    % Odd echoes
    [ph_corr(:,:,:,1:2:end,:), mag_corr(:,:,:,1:2:end,:)] = poem(abs(image(:,:,:,1:2:end,:)), angle(image(:,:,:,1:2:end,:)), voxel_size, TE(1:2:end));
    % Even echoes
    [ph_corr(:,:,:,2:2:end,:), mag_corr(:,:,:,2:2:end,:)] = poem(abs(image(:,:,:,2:2:end,:)), angle(image(:,:,:,2:2:end,:)), voxel_size, TE(2:2:end));
else
    error('Unknown readout type: %s', readout);
end

nii = make_nii(ph_corr,voxel_size);
save_nii(nii,'src/ph_corr.nii');
nii = make_nii(mag_corr,voxel_size);
save_nii(nii,'src/mag_corr.nii');

B0=CF/(42.576e6); % in T
B0_dir = B0_dir(:)'; % make sure it is a row vector

% QSM = iQSM_plus(-ph_corr, TE, 'mag', mag_corr, 'voxel_size', voxel_size, 'B0', B0, 'B0_dir', B0_dir, 'output_dir', 'iQSM_wholehead');


% conventional method

% mask based on mag_cmb
mag_cmb_echo = sqrt(sum(abs(mag_cmb).^2,4));
nii = make_nii(mag_cmb_echo, voxel_size);
save_nii(nii,'mag_cmb_echo.nii');

unix('N4BiasFieldCorrection -i mag_cmb_echo.nii -o mag_cmb_echo_n4.nii');


mask = ones(size(mag_cmb_echo));
mask_middle = mag_cmb(:,:,:,end) > 500000; % threshold
nii = make_nii(single(mask_middle), voxel_size);
save_nii(nii,'mask_middle.nii');
% mask(mag_cmb<1500000) = 0;
% nii = make_nii(mask,voxel_size);
% save_nii(nii,'mask.nii');

imsize = size(image);
%% Method 2: unwrap of each echo then fit

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

unph = zeros(imsize(1:4));

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
    unph(:,:,:,echo_num) = reshape(tmp - round(mean(tmp(mask_middle==1))/(2*pi))*2*pi ,imsize(1:3)).*mask;
    fclose(fid);

    fid = fopen(['reliability' num2str(echo_num) '.dat'],'r');
    reliability_raw = fread(fid,'float');
    reliability_raw = reshape(reliability_raw,imsize(1:3));
    fclose(fid);

    nii = make_nii(reliability_raw.*mask,voxel_size);
    save_nii(nii,['reliability_raw' num2str(echo_num) '.nii']);
end

unph = unph.*repmat(mask,[1 1 1 imsize(4)]);
nii = make_nii(unph,voxel_size);
save_nii(nii,'unph_bestpath.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% 2pi jumps correction
nii = load_nii('unph_diff.nii');
if strcmp(readout, 'bipolar')
    % calculate the phase difference between echo 1 and echo 2
    unph_diff = double(nii.img)/2;
else
    % calculate the phase difference between echo 1 and echo 2
    unph_diff = double(nii.img);
end


% mask_mid = zeros(size(mask));
% mask_mid(44:124,44:84,20:50) = 1;
mask_mid = mask_middle;
for echo = 2:imsize(4)
    meandiff = unph(:,:,:,echo)-unph(:,:,:,1)-double(echo-1)*unph_diff;
    meandiff = meandiff(mask_mid==1);
    meandiff = mean(meandiff(:));
    njump = round(meandiff/(2*pi));
    disp(['    ' num2str(njump) ' 2pi jumps for TE' num2str(echo)]);
    unph(:,:,:,echo) = unph(:,:,:,echo) - njump*2*pi;
    unph(:,:,:,echo) = unph(:,:,:,echo).*mask;
end

nii = make_nii(unph,voxel_size);
save_nii(nii,'unph_corr.nii');


% fit phase images with echo times
disp('--> magnitude weighted LS fit of phase to TE ...');
% [tfs0, fit_residual0] = echofit(unph,n3_mag_cmb,TE,0); 
[tfs0, fit_residual0] = echofit(unph(:,:,:,1:end),mag_cmb(:,:,:,1:end),TE(1:end),0); 
nii = make_nii(tfs0,voxel_size);
save_nii(nii,'tfs0.nii');
nii = make_nii(fit_residual0,voxel_size);
save_nii(nii,'fit_residual0.nii');

r_mask = 1;
% fit_thr = 200; % all 20 echoes
% fit_thr = 10; % first 10 echoes (bestpath)
fit_thr = 100; % first 10 echoes (prelude)
% extra filtering according to fitting residuals
if r_mask
    % generate reliability map
    fit_residual_blur = smooth3(fit_residual0,'box',round(0.1./voxel_size)*2+1); 
    nii = make_nii(fit_residual_blur,voxel_size);
    save_nii(nii,'fit_residual_blur0.nii');
    R = ones(size(fit_residual_blur));
    R(fit_residual_blur >= fit_thr) = 0;
else
    R = 1;
end

% normalize to main field
% ph = gamma*dB*TE
% dB/B = ph/(gamma*TE*B0)
% units: TE s, gamma 2.675e8 rad/(sT), B0 3T
tfs = tfs0/(2.675e8*B0)*1e6; % unit ppm

nii = make_nii(tfs,voxel_size);
save_nii(nii,'tfs.nii');



disp('--> RESHARP to remove background field ...');
smv_rad = 0.3;
tik_reg = 5e-4;
cgs_num = 500;
tv_reg = 2e-4;
z_prjs = B0_dir;
inv_num = 500;

[lfs_resharp, mask_resharp] = resharp(tfs,mask.*R,voxel_size,smv_rad,tik_reg,cgs_num);
% % 3D 2nd order polyfit to remove any residual background
% lfs_resharp= lfs_resharp - poly3d(lfs_resharp,mask_resharp);

% save nifti
[~,~,~] = mkdir('RESHARP');
nii = make_nii(lfs_resharp,voxel_size);
save_nii(nii,['RESHARP/lfs_resharp0_tik_', num2str(tik_reg), '_num_', num2str(cgs_num), '.nii']);

% iLSQR method
chi_iLSQR = QSM_iLSQR(lfs_resharp*(2.675e8*B0)/1e6,mask_resharp,'H',B0_dir,'voxelsize',voxel_size,'niter',50,'TE',1000,'B0',B0);
nii = make_nii(chi_iLSQR,voxel_size);
save_nii(nii,'RESHARP/chi_iLSQR0.nii');

% save all.mat

QSM = iQSM_plus(-ph_corr, TE, 'mag', mag_corr, 'voxel_size', voxel_size, 'B0', B0, 'B0_dir', B0_dir, 'output_dir', 'iQSM_wholehead');
QSM = iQSM_plus(-ph_corr, TE, 'mask', R, 'mag', mag_corr, 'voxel_size', voxel_size, 'B0', B0, 'B0_dir', B0_dir, 'eroded_rad', 0,'output_dir', 'iQSM_brain');
QSM = iQSM_plus(-ph_corr, TE, 'mask', R, 'mag', mag_corr, 'voxel_size', voxel_size, 'B0', B0, 'B0_dir', B0_dir, 'eroded_rad', 1,'output_dir', 'iQSM_brain_ero1');
QSM = iQSM_plus(-ph_corr, TE, 'mask', R, 'mag', mag_corr, 'voxel_size', voxel_size, 'B0', B0, 'B0_dir', B0_dir, 'eroded_rad', 2,'output_dir', 'iQSM_brain_ero2');
QSM = iQSM_plus(-ph_corr, TE, 'mask', R, 'mag', mag_corr, 'voxel_size', voxel_size, 'B0', B0, 'B0_dir', B0_dir, 'eroded_rad', 3,'output_dir', 'iQSM_brain_ero3');

% load('all.mat', 'ph_corr')
% load('all.mat', 'mag_corr')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %% ===== iQSM_plus at 1 mm, then bring chi back to native resolution =====
% % Inputs assumed available from your code above:
% %   ph_corr [Nx,Ny,Nz,Ne], mag_corr [Nx,Ny,Nz,Ne], voxel_size [vx vy vz] (mm)
% %   TE, B0, B0_dir
% % Output:
% %   QSM_native.nii : chi upsampled back to original matrix with original voxel size
% %% ===== Periodic stride split (vectorized) -> per-set iQSM_plus -> reassemble =====
% % Inputs:
% %   ph_corr [Nx,Ny,Nz,Ne], mag_corr [Nx,Ny,Nz,Ne], voxel_size [vx vy vz] (mm)
% %   TE, B0, B0_dir
% % Choose strides (so effective voxel = voxel_size .* stride ~ 1 mm)
% % target_vox = [1 1 1];
% target_vox = [0.3 0.3 0.3];

% stride = max(1, ceil(target_vox ./ voxel_size));   % [sx sy sz]
% sx = stride(1); sy = stride(2); szd = stride(3);

% [Nx,Ny,Nz,Ne] = size(ph_corr);

% pad_x = mod(-Nx, sx); pad_y = mod(-Ny, sy); pad_z = mod(-Nz, szd);
% ph_corr = padarray(ph_corr, [pad_x pad_y pad_z 0], 'post');
% mag_corr = padarray(mag_corr, [pad_x pad_y pad_z 0], 'post');

% [Nx,Ny,Nz,Ne] = size(ph_corr);

% assert(mod(Nx,sx)==0 && mod(Ny,sy)==0 && mod(Nz,szd)==0, ...
%   'Dimensions must be divisible by stride. Got size [%d %d %d], stride [%d %d %d].', ...
%   Nx,Ny,Nz,sx,sy,szd);

% eff_vox = voxel_size .* stride;             % effective low-res voxel size (mm)
% nx = Nx/sx; ny = Ny/sy; nz = Nz/szd;
% nsets = sx*sy*szd;

% % --- pack all subsets at once (vectorized; no nested loops) ---
% % Use complex to avoid phase wrap issues (even though we won’t interpolate).
% zc = mag_corr .* exp(1i*ph_corr);           % [Nx Ny Nz Ne]

% % Pack into [sx nx sy ny sz nz Ne], then permute to [nx ny nz Ne sx sy sz]
% zc_pack = reshape(zc, [sx, nx, sy, ny, szd, nz, Ne]);
% zc_pack = permute(zc_pack, [2 4 6 7 1 3 5]);   % [nx ny nz Ne sx sy sz]

% % Collapse offset dims -> a sets dimension
% zc_sets = reshape(zc_pack, [nx, ny, nz, Ne, nsets]);   % all subsets stacked
% mag_sets = abs(zc_sets);                                % [nx ny nz Ne nsets]
% ph_sets  = angle(zc_sets);

% % (Optional) save the low-res stacks once (not required per-set):
% % nii = make_nii(mag_sets(:,:,:,:,1), eff_vox); save_nii(nii,'debug_one_set_mag.nii');

% % --- run iQSM_plus per set (single loop; parallel-friendly) ---
% chi_sets = zeros(nx, ny, nz, nsets, 'single');

% for s = 1:nsets
%     sub_mag = mag_sets(:,:,:,:,s);
%     sub_ph  = ph_sets (:,:,:,:,s);
%     Qi = iQSM_plus(-sub_ph, TE, ...
%         'mag',        sub_mag, ...
%         'voxel_size', eff_vox, ...
%         'B0',         B0, ...
%         'B0_dir',     B0_dir, ...
%         'output_dir', sprintf('sets_stride_%d_%d_%d/set_%03d', sx,sy,szd, s));
%     if isstruct(Qi)
%         if isfield(Qi,'chi'), chi_set = Qi.chi; elseif isfield(Qi,'QSM'), chi_set = Qi.QSM; else, error('iQSM_plus output lacks chi/QSM'); end
%     else
%         chi_set = Qi;
%     end
%     if ndims(chi_set)==4, chi_set = chi_set(:,:,:,1); end
%     chi_sets(:,:,:,s) = single(chi_set);
% end

% % --- reassemble back to native grid (exact inverse of packing) ---
% % reshape sets back to [nx ny nz sx sy sz] then inverse permute/reshape to [Nx Ny Nz]
% chi6 = reshape(chi_sets, [nx, ny, nz, sx, sy, szd]);     % [nx ny nz sx sy sz]
% chi6 = permute(chi6, [4 1 5 2 6 3]);                    % [sx nx sy ny sz nz]
% chi_native = reshape(chi6, [Nx, Ny, Nz]);               % [Nx Ny Nz]

% nii = make_nii(chi_native, voxel_size);
% save_nii(nii, 'chi_reassembled_native.nii');

% fprintf('Done. stride=[%d %d %d], eff vox=[%.3f %.3f %.3f] mm, sets=%d\n', ...
%         sx,sy,szd, eff_vox, nsets);

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
