%--------------------------------------------------------------------------
%% load data
%--------------------------------------------------------------------------

addpath(genpath('/Users/uqhsun8/Documents/MATLAB/functions/GRAPPA_berkin/LIBRARY/'))


% dt_fa04 = mapVBVD('meas_MID152_fl3d_mtv_FA_4_FID5350.dat', 'removeOS');
dt_fa04 = mapVBVD('/Volumes/LaCie_Top/CS-phase/invivo/2021_06_04_CS_QSM_002/RAW/meas_MID00089_FID08817_gre_full_3x3.dat', 'removeOS');
mkdir('/Volumes/LaCie_Top/CS-phase/invivo/2021_06_04_CS_QSM_002/GRAPPA3X3_reg');
cd('/Volumes/LaCie_Top/CS-phase/invivo/2021_06_04_CS_QSM_002/GRAPPA3X3_reg');

% prot = read_meas_prot('/Volumes/LaCie_Top/CS-phase/invivo/2021_06_04_CS_QSM_002/RAW/meas_MID00089_FID08817_gre_full_3x3.dat');


%--------------------------------------------------------------------------
%% 
%--------------------------------------------------------------------------

dat = squeeze(dt_fa04.image());
dat = permute(dat, [1,3,4,2,5]);

% pad due to accl
dat = padarray(dat, [0,2,0,0,0]);
dat = padarray(dat, [0,0,1,0,0]);
%%
num_ro = s(dat,1);

% pad ref data in readout to match mtx size
ref = squeeze(dt_fa04.refscan());
ref = permute(ref, [1,3,4,2,5]);

ref = ref(:,:,:,:,1);

ref = padarray(ref, [(num_ro - size(ref,1)), 0, 0, 0] / 2);


%--------------------------------------------------------------------------
%% compress to 32 chan
%--------------------------------------------------------------------------

% num_chan = 32;
% 
% [REF_svd, cmp_mtx] = svd_compress3d(ref, num_chan, 1);
% 
% 
% size_new = size(dat);
% size_new(4) = num_chan;
% 
% DAT_svd = zeross( size_new );
% 
% for t = 1:size_new(5)  
%     DAT_svd(:,:,:,:,t) = svd_apply3d(dat(:,:,:,:,t), cmp_mtx);
% end


%% ifft over kx -> x,ky,kz,chan,te
ref = ifftc( ref, 1 );
dat = ifftc( dat, 1 );


% clear DAT_svd REF_svd


%--------------------------------------------------------------------------
%% select slice
%--------------------------------------------------------------------------
Img_R2 = zeros(256,192,144,32,8);

for slice_select = 1:256 % for loop here

    dat_all = sq( dat(slice_select, :,:,:,:) ); % ky,kz,chan,echo

    ref_all = sq( ref(slice_select, :,:,:) );


    img_dat_slc = ifft2call( dat_all );

    img_ref_slc = ifft2call( ref_all );


%     mosaic( rsos(img_ref_slc,3), 1, 3, 10, '', [0,15e-4], -90 ),  
%     mosaic( rsos(img_dat_slc,3), 1, 3, 11, '', [0,5e-4], -90 ),  




    Kspace_Sampled = dat_all;
    Kspace_Acs = ref_all;


    size_kspace = size(Kspace_Sampled(:,:,1,1,1));
    size_ref = size(Kspace_Acs(:,:,1,1,1));


    Kspace_Acs = padarray( Kspace_Acs, [size_kspace-size_ref, 0, 0, 0]/2 );


%     mosaic( rsos(rsos(rsos(Kspace_Acs,3),4),5),1,1,1,'',[0,1e-4] ), setGcf(0.2)
%     mosaic( rsos(rsos(rsos(Kspace_Sampled,3),4),5),1,1,2,'',[0,1e-4] ), setGcf(0.2)


    [N(1), N(2), num_chan, num_echo, num_flip] = size(Kspace_Sampled);




    %--------------------------------------------------------------------------
    %% grappa: apply PAT2 recon to get ~ground truth
    %--------------------------------------------------------------------------


    num_eco = 8;

    Rz = 3;
    Ry = 3;

    del_ky=1*ones(num_chan,1);
    del_kz=3*ones(num_chan,1);

    compute_gfactor = 0;
    lambda_tik = 1e-8;
    % lambda_tik = eps;


    num_acs = [24,24]-2;        % size reduced due to 1 voxel circshift
    kernel_size = [3,3];        % odd kernel size


    Img_Grappa = zeros([N, num_chan, num_eco]);


    tic
    for t = 1:num_eco
        kspace_sampled = Kspace_Sampled(:,:,:,t);

        Img_Grappa(:,:,:,t) = grappa_gfactor_2d_jvc2( kspace_sampled, Kspace_Acs, Rz, Ry, num_acs, kernel_size, lambda_tik, 0, del_kz, del_ky );
    end
    toc


    Img_R2(slice_select,:,:,:,:) = Img_Grappa;
end

% mosaic(reshape(rsos(Img_R2, 3), [N, num_eco]),1,1,1,'',[0,3e-3],-90)
% 
% %%
% mosaic(rsos(Kspace_Acs,3),1,1,1), 
% 
% mosaic(rsos(kspace_sampled,3),1,1,1), setGcf(.5)


save('all_grappa.mat','-v7.3');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hongfu code
vox = [1,1,1];

img = permute(Img_R2,[1 2 3 5 4]);
clear Img_R2 dat

% BEGIN THE QSM RECON PIPELINE
% initial quick brain mask
% simple sum-of-square combination
mag1_sos = sqrt(sum(abs(img(:,:,:,1,:)).^2,5));
nii = make_nii(mag1_sos,vox);
save_nii(nii,'mag1_sos.nii');

% unix('N4BiasFieldCorrection -i mag1_sos.nii -o mag1_sos_n4.nii');

unix('bet2 mag1_sos.nii BET -f 0.2 -m');
% set a lower threshold for postmortem
% unix('bet2 mag1_sos.nii BET -f 0.1 -m');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);

% coil combination % smoothing factor 10?
TE = 3.4 + [0:7]*3.5;
TE = TE/1000;

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

clear img kData



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
    options.fit_thr = 20;
end

if ~ isfield(options,'bet_thr')
    options.bet_thr = 0.3;
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
dicom_info.MagneticFieldStrength = 3.0;
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

% save all.mat
% Hongfu code ends
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

