%--------------------------------------------------------------------------
%% load data
%--------------------------------------------------------------------------

% addpath(genpath('/Users/uqhsun8/Documents/MATLAB/functions/GRAPPA_berkin/LIBRARY/'))
addpath(genpath('/Users/uqhsun8/Documents/MATLAB/functions/GRAPPA_berkin/'))


% dt_fa04 = mapVBVD('meas_MID152_fl3d_mtv_FA_4_FID5350.dat', 'removeOS');
dt_fa04 = mapVBVD('/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_19Aug21/meas_MID00273_FID15743_wip925b_TI2_EC2_VC_PAT3_p75iso.dat', 'removeOS');
mkdir('/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_19Aug21/meas_MID00273_FID15743_wip925b_TI2_EC2_VC_PAT3_p75iso');
cd('/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_19Aug21/meas_MID00273_FID15743_wip925b_TI2_EC2_VC_PAT3_p75iso');

[prot,header,text] = read_meas_prot('/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_19Aug21/meas_MID00273_FID15743_wip925b_TI2_EC2_VC_PAT3_p75iso.dat');


%--------------------------------------------------------------------------
%% 
%--------------------------------------------------------------------------

dat = squeeze(dt_fa04.image());
dat = permute(dat, [1,3,4,2,5,6]);

% % pad due to accl
% dat = padarray(dat, [0,1,0,0,0,0]);
%%
num_ro = s(dat,1);

% pad ref data in readout to match mtx size
ref = squeeze(dt_fa04.refscan());
ref = permute(ref, [1,3,4,2,5,6]);

ref = padarray(ref, [(size(dat,1) - size(ref,1)), 0, 0, 0, 0, 0] / 2);


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
size_dat = size(dat);

%%%%% 2nd inversion
inv_select = 2;
Ksp_inv2 = zeros(size_dat(1:5),'single');


for slice_select = 1:num_ro % for loop here  

    dat_all = sq( dat(slice_select, :,:,:,:,inv_select) ); % ky,kz,chan,echo
    ref_all = sq( ref(slice_select, :,:,:,1,2) ); % always use the 2nd inversion 1st TE

    % img_dat_slc = ifft2call( dat_all );
    % img_ref_slc = ifft2call( ref_all );
    % mosaic( rsos(img_ref_slc,3), 1, 4, 10, '', '', -90 ),  
    % mosaic( rsos(img_dat_slc,3), 1, 4, 11, '', '', -90 ),  

    Kspace_Sampled = dat_all;
    Kspace_Acs = ref_all;

    size_kspace = size(Kspace_Sampled(:,:,1,1));
    size_ref = size(Kspace_Acs(:,:,1));

    Kspace_Acs = padarray( Kspace_Acs, [size_kspace-size_ref, 0]/2 );

%     mosaic( rsos(rsos(rsos(Kspace_Acs,3),4),5),1,1,1,'',[0,1e-4] ), setGcf(0.2)
%     mosaic( rsos(rsos(rsos(Kspace_Sampled,3),4),5),1,1,2,'',[0,1e-4] ), setGcf(0.2)

    [N(1), N(2), num_chan, num_echo] = size(Kspace_Sampled);

    %--------------------------------------------------------------------------
    %% grappa: apply PAT2 recon to get ~ground truth
    %--------------------------------------------------------------------------
    Rz = 3;
    Ry = 1;

    del_ky=0*ones(num_chan,1);
    del_kz=2*ones(num_chan,1);

    compute_gfactor = 0;
    lambda_tik = 1e-8;
    % lambda_tik = eps;

    num_acs = size_ref-2;        % size reduced due to 1 voxel circshift
    kernel_size = [3,3];        % odd kernel size

    Ksp_Grappa = zeros([N, num_chan, num_echo],'single');

    tic
    for t = 1:num_echo
        kspace_sampled = Kspace_Sampled(:,:,:,t);
        kspace_acs = Kspace_Acs;

        % Img_Grappa(:,:,:,t) = grappa_gfactor_2d_jvc2( kspace_sampled, kspace_acs, Rz, Ry, num_acs, kernel_size, lambda_tik, 0, del_kz, del_ky );
        img_grappa = grappa_gfactor_2d_jvc2(kspace_sampled, kspace_acs, Rz, Ry, num_acs, kernel_size, lambda_tik, 0 , del_kz, del_ky );
        % Img_Grappa(:,:,:,t) = grappa_gfactor_2d_jvc2( kspace_sampled, kspace_acs, Rz, Ry, num_acs, kernel_size, lambda_tik, 0 );

        Ksp_Grappa(:,:,:,t) = fft2c(img_grappa);
    end
    toc


    % Img_inv2(slice_select,:,:,:,:,inv_select) = Img_Grappa;
    Ksp_inv2(slice_select,:,:,:,:) = Ksp_Grappa;
end

% Fourier transform of first dim
Ksp_inv2 = fftc( Ksp_inv2, 1 );


% % remove zero padding
% Ksp_inv2 = Ksp_inv2(:,2:end-1,:,:,:);

save('Ksp_inv2','Ksp_inv2','-v7.3');



% perform POCS for partial fourier 6/8 undersampling
% zero padding for PF to full size
Ksp_inv2 = padarray(Ksp_inv2,[0,0,2/6*size(Ksp_inv2,3),0,0],'pre');

% looping through echo and inversion
for echo_num = 1:num_echo
        Ksp = Ksp_inv2(:,:,:,:,echo_num);
        [~, Ksp] = pocs(permute(Ksp,[4,1,2,3]),20);
        Ksp = permute(Ksp, [2,3,4,1]);
        Ksp_inv2(:,:,:,:,echo_num) = Ksp;
end


Ksp_inv2 = padarray(Ksp_inv2,[0,2/6*size(Ksp_inv2,2),0,0,0],'pre');

% looping through echo and inversion
for echo_num = 1:4
        Ksp = Ksp_inv2(:,:,:,:,echo_num);
        [~, Ksp] = pocs(permute(Ksp,[4,1,2,3]),20);
        Ksp = permute(Ksp, [2,3,4,1]);
        Ksp_inv2(:,:,:,:,echo_num) = Ksp;
end


% asymmetric echo
Ksp_inv2 = padarray(Ksp_inv2,[68,0,0,0,0,0],'pre');

% looping through echo and inversion
for echo_num = 1:4
        Ksp = Ksp_inv2(:,:,:,:,echo_num);
        [~, Ksp] = pocs(permute(Ksp,[4,1,2,3]),20);
        Ksp = permute(Ksp, [2,3,4,1]);
        Ksp_inv2(:,:,:,:,echo_num) = Ksp;
end


% save the matrix
save('Ksp_inv2_pocs','Ksp_inv2','-v7.3');





Ksp_inv2 = ifftc( Ksp_inv2, 1 );
Ksp_inv2 = ifftc( Ksp_inv2, 2 );
Ksp_inv2 = ifftc( Ksp_inv2, 3 );

Img_inv2 = Ksp_inv2;
clear Ksp_inv2 dat dat_all Ksp Ksp_Grappa Kspace_Sampled Kspace_Acs ref ref_all 

Img_inv2 = flip(flip(Img_inv2,2),3);








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hongfu code for QSM
vox = [0.75 0.75 0.75];
TE = prot.alTE*1e-6;
z_prjs = [0 0 1];

% define output directories
path_qsm = 'QSM_MEMP2RAGE_7T_1e-8';
mkdir(path_qsm);
init_dir = pwd;
cd(path_qsm);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% use only the second inversion
Mag_inv2 = abs(Img_inv2)*1e6;
Ph_inv2 = angle(Img_inv2);
clear Img_inv2

Mag_inv2 = permute(Mag_inv2,[1 2 3 5 4]);
Ph_inv2 = permute(Ph_inv2,[1 2 3 5 4]);

imsize = size(Ph_inv2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% save the raw data for future use
save('raw.mat','-v7.3');


% BEGIN THE QSM RECON PIPELINE
% initial quick brain mask
% simple sum-of-square combination
mag1_sos = sqrt(sum(Mag_inv2(:,:,:,1,:).^2,5));
nii = make_nii(mag1_sos,vox);
save_nii(nii,'mag1_sos.nii');

unix('N4BiasFieldCorrection -i mag1_sos.nii -o mag1_sos_n4.nii');

unix('bet2 mag1_sos_n4.nii BET -f 0.3 -m');
% set a lower threshold for postmortem
% unix('bet2 mag1_sos.nii BET -f 0.1 -m');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);

% coil combination % smoothing factor 10?


% % unipolar
if text(strfind(text,'ParamLong."ucReadOutMode"')+44) == '1'
    [ph_corr,mag_corr] = geme_cmb(Mag_inv2.*exp(1j*Ph_inv2),vox,TE,mask);
% bipolar
elseif text(strfind(text,'ParamLong."ucReadOutMode"')+44) == '2'
    ph_corr = zeros(imsize(1:4));
    mag_corr = zeros(imsize(1:4));
    [ph_corr(:,:,:,1:2:end),mag_corr(:,:,:,1:2:end)] = geme_cmb(Mag_inv2(:,:,:,1:2:end,:).*exp(1j*Ph_inv2(:,:,:,1:2:end,:)),vox,TE(1:2:end),mask);
    !mkdir odd_box3d; mv offsets* odd_box3d
    [ph_corr(:,:,:,2:2:end),mag_corr(:,:,:,2:2:end)] = geme_cmb(Mag_inv2(:,:,:,2:2:end,:).*exp(1j*Ph_inv2(:,:,:,2:2:end,:)),vox,TE(2:2:end),mask);
    !mkdir even_box3d; mv offsets* even_box3d
else
    error('cannot determine readout mode, bipolar or unipolar');
end

clear Mag_inv2 Ph_inv2

% save niftis after coil combination
mkdir('src');
for echo = 1:imsize(4)
    nii = make_nii(mag_corr(:,:,:,echo),vox);
    save_nii(nii,['src/mag_corr' num2str(echo) '.nii']);
    nii = make_nii(ph_corr(:,:,:,echo),vox);
    save_nii(nii,['src/ph_corr' num2str(echo) '.nii']);
end

save('raw.mat','ph_corr','mag_corr','mask','-append');




% (1) unwrap the phase using best path
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

    bash_script = ['${pathstr}/3DSRNCP wrapped_phase${echo_num}.dat mask_unwrp.dat ' ...
        'unwrapped_phase${echo_num}.dat $nv $np $ns reliability${echo_num}.dat'];
    unix(bash_script) ;

    fid = fopen(['unwrapped_phase' num2str(echo_num) '.dat'],'r');
    tmp = fread(fid,'float');
    % tmp = tmp - tmp(1);
    unph(:,:,:,echo_num) = reshape(tmp - round(mean(tmp(mask==1))/(2*pi))*2*pi ,imsize(1:3)).*mask;
    fclose(fid);
end

nii = make_nii(unph,vox);
save_nii(nii,'unph_bestpath_before_jump_correction.nii');

% remove all the temp files
! rm *.dat

% 2pi jumps correction
nii = load_nii('unph_diff.nii');
unph_diff = double(nii.img);

% bipolar
unph_diff = unph_diff/2;

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
save_nii(nii,'unph_bestpath.nii');

save('raw.mat','unph','-append');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set parameters
fit_thr = 10;
tik_reg = 1e-6;
cgs_num = 500;
lsqr_num = 500;
% tv_reg = 2e-4;
inv_num = 500;
dicom_info.MagneticFieldStrength = 7; 

% fit phase images with echo times
disp('--> magnitude weighted LS fit of phase to TE ...');
[tfs_0, fit_residual_0] = echofit(unph,mag_corr,TE,0); 
% normalize to main field
% ph = gamma*dB*TE
% dB/B = ph/(gamma*TE*B0)
% units: TE s, gamma 2.675e8 rad/(sT), B0 7T
tfs_0 = tfs_0/(2.675e8*dicom_info.MagneticFieldStrength)*1e6; % unit ppm
nii = make_nii(tfs_0,vox);
save_nii(nii,'tfs_0.nii');
nii = make_nii(fit_residual_0,vox);
save_nii(nii,'fit_residual_0.nii');
% extra filtering according to fitting residuals
% generate reliability map
fit_residual_0_blur = smooth3(fit_residual_0,'box',round(1./vox)*2+1); 
nii = make_nii(fit_residual_0_blur,vox);
save_nii(nii,'fit_residual_0_blur.nii');
R_0 = ones(size(fit_residual_0_blur));
R_0(fit_residual_0_blur >= fit_thr) = 0;

save('raw.mat','tfs_0','fit_residual_0','fit_residual_0_blur','R_0','fit_thr','cgs_num','tik_reg','inv_num','-append');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load('raw.mat','tfs_0','mask','R_0','vox','cgs_num','dicom_info','z_prjs','mag_corr','imsize','TE');

for smv_rad = [1 2 3]
% for smv_rad = [1 2 3]
    % RE-SHARP (tik_reg: Tikhonov regularization parameter)
    disp('--> RESHARP to remove background field ...');
    % [lfs_resharp_0, mask_resharp_0] = resharp_lsqr(tfs_0,mask.*R_0,vox,smv_rad,lsqr_num);
    [lfs_resharp_0, mask_resharp_0] = resharp(tfs_0,mask.*R_0,vox,smv_rad,tik_reg,cgs_num);
    % save nifti
    mkdir('RESHARP');
    nii = make_nii(lfs_resharp_0,vox);
    % save_nii(nii,['RESHARP/lfs_resharp_0_smvrad' num2str(smv_rad) '_lsqr.nii']);
    save_nii(nii,['RESHARP/lfs_resharp_0_smvrad' num2str(smv_rad) '_cgs_' num2str(tik_reg) '.nii']);

    % iLSQR
    chi_iLSQR_0 = QSM_iLSQR(lfs_resharp_0*(2.675e8*dicom_info.MagneticFieldStrength)/1e6,mask_resharp_0,'H',z_prjs,'voxelsize',vox,'niter',50,'TE',1000,'B0',dicom_info.MagneticFieldStrength);
    nii = make_nii(chi_iLSQR_0,vox);
    save_nii(nii,['RESHARP/chi_iLSQR_smvrad' num2str(smv_rad) '.nii']);

    % % MEDI
    % %%%%% normalize signal intensity by noise to get SNR %%%
    % %%%% Generate the Magnitude image %%%%
    % iMag = sqrt(sum(mag_corr.^2,4));
    % % [iFreq_raw N_std] = Fit_ppm_complex(ph_corr);
    % matrix_size = single(imsize(1:3));
    % voxel_size = vox;
    % delta_TE = TE(2) - TE(1);
    % B0_dir = z_prjs';
    % CF = dicom_info.ImagingFrequency *1e6;
    % iFreq = [];
    % N_std = 1;
    % RDF = lfs_resharp_0*2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6;
    % Mask = mask_resharp_0;
    % save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
    %      voxel_size delta_TE CF B0_dir;
    % QSM = MEDI_L1('lambda',1000);
    % nii = make_nii(QSM.*Mask,vox);
    % save_nii(nii,['RESHARP/MEDI1000_RESHARP_smvrad' num2str(smv_rad) '.nii']);
    
    % %TVDI
    % sus_resharp = tvdi(lfs_resharp_0,mask_resharp_0,vox,2e-4,iMag,z_prjs,500); 
    % nii = make_nii(sus_resharp.*mask_resharp_0,vox);
    % save_nii(nii,['RESHARP/TV_2e-4_smvrad' num2str(smv_rad) '.nii']);
end


load('raw.mat','mag_corr','TE','mask');

[R2, T2, amp] = r2imgfit(double(mag_corr),TE,repmat(mask,[1 1 1 4]));
nii = make_nii(R2,vox);
save_nii(nii,'R2_4echo.nii');
nii = make_nii(T2,vox);
save_nii(nii,'T2_4echo.nii');
nii = make_nii(amp,vox);
save_nii(nii,'amp_4echo.nii');


% Hongfu code ends
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
