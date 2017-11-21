# use the same mask (postmortem mask 6)
# then re-do QSM individually
/usr/local/fsl/5.0.9/bin/convert_xfm -omat /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/1/flirt_qsm_inv.mat -inverse /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/1/flirt_qsm_12DOF.mat
/usr/local/fsl/5.0.9/bin/convert_xfm -omat /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/2/flirt_qsm_inv.mat -inverse /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/2/flirt_qsm_12DOF.mat
/usr/local/fsl/5.0.9/bin/convert_xfm -omat /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/3/flirt_qsm_inv.mat -inverse /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/3/flirt_qsm_12DOF.mat
/usr/local/fsl/5.0.9/bin/convert_xfm -omat /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/4/flirt_qsm_inv.mat -inverse /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/4/flirt_qsm_12DOF.mat
/usr/local/fsl/5.0.9/bin/convert_xfm -omat /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/5/flirt_qsm_inv.mat -inverse /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/5/flirt_qsm_12DOF.mat

/usr/local/fsl/5.0.9/bin/flirt -in /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/6/QSM_MEGE_7T/BET_mask.nii -applyxfm -init /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/1/flirt_qsm_inv.mat -out /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/1/QSM_MEGE_7T/BET_mask_new.nii -paddingsize 0.0 -interp trilinear -ref /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/1/QSM_MEGE_7T/BET_mask.nii
/usr/local/fsl/5.0.9/bin/flirt -in /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/6/QSM_MEGE_7T/BET_mask.nii -applyxfm -init /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/2/flirt_qsm_inv.mat -out /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/2/QSM_MEGE_7T/BET_mask_new.nii -paddingsize 0.0 -interp trilinear -ref /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/2/QSM_MEGE_7T/BET_mask.nii
/usr/local/fsl/5.0.9/bin/flirt -in /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/6/QSM_MEGE_7T/BET_mask.nii -applyxfm -init /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/3/flirt_qsm_inv.mat -out /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/3/QSM_MEGE_7T/BET_mask_new.nii -paddingsize 0.0 -interp trilinear -ref /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/3/QSM_MEGE_7T/BET_mask.nii
/usr/local/fsl/5.0.9/bin/flirt -in /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/6/QSM_MEGE_7T/BET_mask.nii -applyxfm -init /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/4/flirt_qsm_inv.mat -out /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/4/QSM_MEGE_7T/BET_mask_new.nii -paddingsize 0.0 -interp trilinear -ref /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/4/QSM_MEGE_7T/BET_mask.nii
/usr/local/fsl/5.0.9/bin/flirt -in /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/6/QSM_MEGE_7T/BET_mask.nii -applyxfm -init /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/5/flirt_qsm_inv.mat -out /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/5/QSM_MEGE_7T/BET_mask_new.nii -paddingsize 0.0 -interp trilinear -ref /gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/5/QSM_MEGE_7T/BET_mask.nii

paths = {'/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/1/QSM_MEGE_7T','/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/2/QSM_MEGE_7T','/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/3/QSM_MEGE_7T','/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/4/QSM_MEGE_7T','/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/recon/5/QSM_MEGE_7T'};

for orientation = 1:5
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

	% [ph_corr(:,:,:,1:2:end),mag_corr(:,:,:,1:2:end)] = geme_cmb(mag_all(:,:,:,1:2:end,:).*exp(1j*ph_all(:,:,:,1:2:end,:)),vox,TE(1:2:end),mask);
	% [ph_corr(:,:,:,2:2:end),mag_corr(:,:,:,2:2:end)] = geme_cmb(mag_all(:,:,:,2:2:end,:).*exp(1j*ph_all(:,:,:,2:2:end,:)),vox,TE(2:2:end),mask);

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


	% (4) FUDGE laplacian unwrapping
	disp('--> unwrap aliasing phase using fudge...');
	for i = 1:imsize(4)
	    unph(:,:,:,i) = fudge(ph_corr(:,:,:,i));
	end
	nii = make_nii(unph, vox);
	save_nii(nii,'unph_fudge_before_correction.nii');


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

	nii = make_nii(unph, vox);
	save_nii(nii,'unph_fudge.nii');

	unph_fudge = unph;
	save('raw.mat','unph_fudge','-append');

	mkdir('fudge');
	cd('fudge');

	clear unph_fudge ph_corr


	% set parameters
	fit_thr = 20;
	tik_reg = 1e-4;
	cgs_num = 200;


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
	% for smv_rad = [1 2 3]
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
