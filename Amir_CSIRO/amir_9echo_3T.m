nii1 = load_untouch_nii('sub-473554_exp-T0_PD_ME-GRE_PISA_9ECH__REP1_MAG.nii');
mag = single(nii1.img);

nii2 = load_untouch_nii('sub-473554_exp-T0_PD_ME-GRE_PISA_9ECH__REP1_PHA.nii');
pha = single(nii2.img);
pha = 2*pi.*(pha - min(pha(:)))/(max(pha(:)) - min(pha(:))) - pi;

vox = nii1.hdr.dime.pixdim(2:4);
imsize = size(mag);

jsontext = fileread('sub-473554_exp-T0_PD_ME-GRE_PISA_9ECH__REP1_MAG.json');
params = jsondecode(jsontext);
TE = params.time.samples.EchoTime/1000;


mkdir('sub-473554')
cd('sub-473554')

% save('raw.mat','-v7.3');

% BEGIN THE QSM RECON PIPELINE
% initial quick brain mask
% simple sum-of-square combination
nii = make_nii(mag(:,:,:,1),vox);
save_nii(nii,'mag1.nii');

unix('bet2 mag1.nii BET -f 0.4 -m');
% set a lower threshold for postmortem
% unix('bet2 mag1_sos.nii BET -f 0.1 -m');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);

% coil combination % smoothing factor 10?
% ph_corr = zeros(imsize(1:4));
% mag_corr = zeros(imsize(1:4));

% (1) if unipolar
[ph_corr,mag_corr] = poem(mag,pha,vox,TE,mask);


mkdir('src');
for echo = 1:imsize(4)
    nii = make_nii(mag_corr(:,:,:,echo),vox);
    save_nii(nii,['src/mag_corr' num2str(echo) '.nii']);
    nii = make_nii(ph_corr(:,:,:,echo),vox);
    save_nii(nii,['src/ph_corr' num2str(echo) '.nii']);
end


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
end

nii = make_nii(unph,vox);
save_nii(nii,'unph_bestpath_before_jump_correction.nii');

% remove all the temp files
! rm *.dat

% 2pi jumps correction
nii = load_nii('unph_diff.nii');
unph_diff = double(nii.img);
% unph_diff = unph_diff/2;
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

unph_bestpath = unph;



% set parameters
fit_thr = 40;
tik_reg = 1e-6;
cgs_num = 500;
% lsqr_num = 500;
% tv_reg = 2e-4;
% inv_num = 500;


% fit phase images with echo times
disp('--> magnitude weighted LS fit of phase to TE ...');
[tfs_0, fit_residual_0] = echofit(unph,mag_corr,TE,0); 
% normalize to main field
% ph = gamma*dB*TE
% dB/B = ph/(gamma*TE*B0)
% units: TE s, gamma 2.675e8 rad/(sT), B0 7T
tfs_0 = tfs_0/(2.675e8*3)*1e6; % unit ppm
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

% save('raw.mat','tfs_0','fit_residual_0','fit_residual_0_blur','R_0','fit_thr','cgs_num','tik_reg','-append');

% load('raw.mat','tfs_0','mask','R_0','vox','cgs_num','dicom_info','z_prjs','mag_corr','imsize','TE','tik_reg');

z_prjs = [0 0 1]

for smv_rad = [2 3]
% for smv_rad = 5
    % RE-SHARP (tik_reg: Tikhonov regularization parameter)
    disp('--> RESHARP to remove background field ...');
    % [lfs_resharp_0, mask_resharp_0] = resharp_lsqr(tfs_0,mask.*R_0,vox,smv_rad,lsqr_num);
    [lfs_resharp_0, mask_resharp_0] = resharp(tfs_0,mask.*R_0,vox,smv_rad,tik_reg,cgs_num);
    % save nifti
    mkdir('RESHARP');
    nii = make_nii(lfs_resharp_0,vox);
    % save_nii(nii,['RESHARP/lfs_resharp_0_smvrad' num2str(smv_rad) '_lsqr.nii']);
    save_nii(nii,['RESHARP/lfs_resharp_0_smvrad' num2str(smv_rad) '_cgs_' num2str(tik_reg) '.nii']);

    lfs_resharp(:,:,:,smv_rad) = lfs_resharp_0;
    mask_resharp(:,:,:,smv_rad) = mask_resharp_0;

    % iLSQR
    % chi_iLSQR_0 = QSM_iLSQR(lfs_resharp_0*(2.675e8*dicom_info.MagneticFieldStrength)/1e6,mask_resharp_0,'H',z_prjs,'voxelsize',vox,'niter',50,'TE',1000,'B0',dicom_info.MagneticFieldStrength);
    chi_iLSQR_0 = QSM_iLSQR(lfs_resharp_0*(2.675e8*3)/1e6,mask_resharp_0,'H',z_prjs,'voxelsize',vox,'niter',50,'TE',1000,'B0',3);
    nii = make_nii(chi_iLSQR_0,vox);
    save_nii(nii,['RESHARP/chi_iLSQR_smvrad' num2str(smv_rad) '.nii']);

    chi_iLSQR(:,:,:,smv_rad) = chi_iLSQR_0;

    % % MEDI
    % %%%%% normalize signal intensity by noise to get SNR %%%
    % %%%% Generate the Magnitude image %%%%
    % iMag = sqrt(sum(mag_corr.^2,4));
    % % [iFreq_raw N_std] = Fit_ppm_complex(ph_corr);
    % matrix_size = single(imsize(1:3));
    % voxel_size = vox;
    % delta_TE = TE(2) - TE(1);
    % B0_dir = z_prjs';
    % % CF = dicom_info.ImagingFrequency *1e6;
    % CF = 127.74 *1e6;
    % iFreq = [];
    % N_std = 1;
    % % RDF = lfs_resharp_0*2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6;
    % RDF = lfs_resharp_0*2.675e8*3*delta_TE*1e-6;
    % Mask = mask_resharp_0;
    % save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
    %      voxel_size delta_TE CF B0_dir;
    % QSM = MEDI_L1('lambda',1000);
    % nii = make_nii(QSM.*Mask,vox);
    % save_nii(nii,['RESHARP/MEDI1000_RESHARP_smvrad' num2str(smv_rad) '.nii']);

    % chi_MEDI(:,:,:,smv_rad) = QSM.*Mask;
end

% save('raw.mat','lfs_resharp','mask_resharp','chi_iLSQR','chi_MEDI','-append');
save all.mat
save('for_uQSM.mat','mag_corr','ph_corr','mask','TE','vox','z_prjs','R_0');