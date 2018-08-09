# use the same mask (postmortem mask 6)
# then re-do QSM individually
/usr/local/fsl/5.0.9/bin/convert_xfm -omat /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/extension/flirt_qsm_inv.mat -inverse /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/extension/flirt_qsm_12DOF.mat
/usr/local/fsl/5.0.9/bin/convert_xfm -omat /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/flexion/flirt_qsm_inv.mat -inverse /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/flexion/flirt_qsm_12DOF.mat
/usr/local/fsl/5.0.9/bin/convert_xfm -omat /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/left/flirt_qsm_inv.mat -inverse /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/left/flirt_qsm_12DOF.mat
/usr/local/fsl/5.0.9/bin/convert_xfm -omat /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/right/flirt_qsm_inv.mat -inverse /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/right/flirt_qsm_12DOF.mat

/usr/local/fsl/5.0.9/bin/flirt -in /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/neutral/QSM_MEGE_7T/BET_mask.nii -applyxfm -init /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/extension/flirt_qsm_inv.mat -out /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/extension/QSM_MEGE_7T/BET_mask_new.nii -paddingsize 0.0 -interp trilinear -ref /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/extension/QSM_MEGE_7T/BET_mask.nii
/usr/local/fsl/5.0.9/bin/flirt -in /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/neutral/QSM_MEGE_7T/BET_mask.nii -applyxfm -init /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/flexion/flirt_qsm_inv.mat -out /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/flexion/QSM_MEGE_7T/BET_mask_new.nii -paddingsize 0.0 -interp trilinear -ref /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/flexion/QSM_MEGE_7T/BET_mask.nii
/usr/local/fsl/5.0.9/bin/flirt -in /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/neutral/QSM_MEGE_7T/BET_mask.nii -applyxfm -init /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/left/flirt_qsm_inv.mat -out /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/left/QSM_MEGE_7T/BET_mask_new.nii -paddingsize 0.0 -interp trilinear -ref /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/left/QSM_MEGE_7T/BET_mask.nii
/usr/local/fsl/5.0.9/bin/flirt -in /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/neutral/QSM_MEGE_7T/BET_mask.nii -applyxfm -init /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/right/flirt_qsm_inv.mat -out /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/right/QSM_MEGE_7T/BET_mask_new.nii -paddingsize 0.0 -interp trilinear -ref /gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/right/QSM_MEGE_7T/BET_mask.nii

paths = {'/gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/extension/QSM_MEGE_7T','/gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/flexion/QSM_MEGE_7T','/gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/left/QSM_MEGE_7T','/gpfs/M2Home/hongfu/NCIgb5_scratch/hongfu/recon/ED/right/QSM_MEGE_7T'};

for orientation = 1:4
	clearvars -except paths orientation
	cd(paths{orientation});
	load raw.mat

	unix('gunzip -f BET_mask_new.nii.gz');
	nii = load_nii('BET_mask_new.nii');
	mask = double(nii.img);
	mask(mask>0) = 1;

	% coil combination % smoothing factor 10?
	ph_corr = zeros(imsize(1:4));
	mag_corr = zeros(imsize(1:4));
	[ph_corr,mag_corr] = geme_cmb(mag_all.*exp(1j*ph_all),vox,TE,mask);

	% save niftis after coil combination
	mkdir('src');
	for echo = 1:imsize(4)
	    nii = make_nii(mag_corr(:,:,:,echo),vox);
	    save_nii(nii,['src/mag_corr' num2str(echo) '.nii']);
	    nii = make_nii(ph_corr(:,:,:,echo),vox);
	    save_nii(nii,['src/ph_corr' num2str(echo) '.nii']);
	end


	save('raw.mat','ph_corr','mag_corr','mask','-append');

	% if need to clear variables for memory
	clear mag_all ph_all

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

unph_bestpath = unph;
save('raw.mat','unph_bestpath','-append');

% set parameters
fit_thr = 20;
tik_reg = 1e-6;
cgs_num = 200;
% tv_reg = 2e-4;
inv_num = 1000;


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

% extra filtering according to fitting residuals
% generate reliability map
fit_residual_0_blur = smooth3(fit_residual_0,'box',round(1./vox)*2+1); 
nii = make_nii(fit_residual_0_blur,vox);
save_nii(nii,'fit_residual_0_blur.nii');
R_0 = ones(size(fit_residual_0_blur));
R_0(fit_residual_0_blur >= fit_thr) = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	for smv_rad = [3]
	    % RE-SHARP (tik_reg: Tikhonov regularization parameter)
	    disp('--> RESHARP to remove background field ...');
	    [lfs_resharp_0, mask_resharp_0] = resharp_lsqr(tfs_0,mask.*R_0,vox,smv_rad,cgs_num);
	    % % 3D 2nd order polyfit to remove any residual background
	    % lfs_resharp= (lfs_resharp - poly3d(lfs_resharp,mask_resharp)).*mask_resharp;
	    % save nifti
	    mkdir('RESHARP');
	    nii = make_nii(lfs_resharp_0,vox);
	    save_nii(nii,['RESHARP/lfs_resharp_0_smvrad' num2str(smv_rad) '_lsqr_nm.nii']);

	    % iLSQR
	    chi_iLSQR_0 = QSM_iLSQR(lfs_resharp_0*(2.675e8*dicom_info.MagneticFieldStrength)/1e6,mask_resharp_0,'H',z_prjs,'voxelsize',vox,'niter',50,'TE',1000,'B0',dicom_info.MagneticFieldStrength);
	    nii = make_nii(chi_iLSQR_0,vox);
	    save_nii(nii,['RESHARP/chi_iLSQR_0_niter50_smvrad' num2str(smv_rad) '_lsqr_nm.nii']);

	    % RE-SHARP (tik_reg: Tikhonov regularization parameter)
	    disp('--> RESHARP to remove background field ...');
	    [lfs_resharp_0, mask_resharp_0] = resharp(tfs_0,mask.*R_0,vox,smv_rad,tik_reg,cgs_num);
	    % % 3D 2nd order polyfit to remove any residual background
	    % lfs_resharp= (lfs_resharp - poly3d(lfs_resharp,mask_resharp)).*mask_resharp;
	    % save nifti
	    mkdir('RESHARP');
	    nii = make_nii(lfs_resharp_0,vox);
	    save_nii(nii,['RESHARP/lfs_resharp_0_smvrad' num2str(smv_rad) '_cgs_nm.nii']);

	    % iLSQR
	    chi_iLSQR_0 = QSM_iLSQR(lfs_resharp_0*(2.675e8*dicom_info.MagneticFieldStrength)/1e6,mask_resharp_0,'H',z_prjs,'voxelsize',vox,'niter',50,'TE',1000,'B0',dicom_info.MagneticFieldStrength);
	    nii = make_nii(chi_iLSQR_0,vox);
	    save_nii(nii,['RESHARP/chi_iLSQR_0_niter50_smvrad' num2str(smv_rad) '_cgs_nm.nii']);

	end


end
