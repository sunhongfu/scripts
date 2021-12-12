addpath(genpath('/Users/uqhsun8/Documents/MATLAB/functions/GRAPPA_berkin/'))

[prot,header,text] = read_meas_prot('/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_24Sep21/meas_MID00351_FID05065_wip925b_TI2_ECHO2_VC_CS9_SAM54.dat');

load('raw.mat', 'mag_corr')
load('raw.mat', 'unph')
load('raw.mat', 'mask')

TE = prot.alTE*1e-6;

z_prjs = [0 0 1];

vox = [prot.sSliceArray.dReadoutFOV/prot.lBaseResolution, prot.sSliceArray.dPhaseFOV/prot.iNoOfFourierLines, prot.sSliceArray.dThickness*(1+prot.dSliceOversamplingForDialog)/prot.iNoOfFourierPartitions]

% set parameters
fit_thr = 10;
tik_reg = 1e-6;
cgs_num = 500;
lsqr_num = 500;
% tv_reg = 2e-4;
inv_num = 500;
dicom_info.MagneticFieldStrength = 7; 



% use only the first 4 echoes
[tfs_0, fit_residual_0] = echofit(unph(:,:,:,1:4),mag_corr(:,:,:,1:4),TE(1:4),0); 

mkdir 4echoes
cd 4echoes

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
    
    