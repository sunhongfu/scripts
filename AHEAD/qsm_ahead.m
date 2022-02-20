% recon code for AHEAD sample data

% load in phase and mag
for echo = 1:4
    nii = load_untouch_nii(['/Volumes/LaCie_Top/AHEAD/Mp2rageme/sub-091_ses-1_acq-wb_inv-2_echo-' num2str(echo) '_part-mag_mprage.nii']);
    mag(:,:,:,echo) = double(nii.img +32768);
    nii = load_untouch_nii(['/Volumes/LaCie_Top/AHEAD/Mp2rageme/sub-091_ses-1_acq-wb_inv-2_echo-' num2str(echo) '_part-ph_mprage.nii']);
    ph(:,:,:,echo) = double(nii.img); 
end
ph = 2*pi.*(ph - min(ph(:)))/(max(ph(:)) - min(ph(:))) - pi;


% extract z_prjs from nifti header
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for example:
% srow_x: [-0.0163 0.0357 0.6987 -83.8686]
% srow_y: [-0.6085 -0.2014 -0.0047 114.1026]
% srow_z: [-0.2008 0.6075 -0.0426 -43.3919]

% R = [ srow_x(1:3)
%       srow_y(1:3)
%       srow_z(1:3)]

% R(:,1)=R(:,1)/pixdim(2)
% R(:,2)=R(:,2)/pixdim(3)
% R(:,3)=R(:,3)/pixdim(4)

% R is the affine matrix map FOV to scanner coordinate
% therefore R(3,:) is the z_prjs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
z_prjs = nii.hdr.hist.srow_z(1:3)./nii.hdr.dime.pixdim(2:4)
vox = nii.hdr.dime.pixdim(2:4)
TE = [3, 11.5, 19, 28.5]*1e-3;
imsize = size(mag);
% unipolar readout according to Caan paper

% % typecast correction
% imsize_ori = size(mag);
% mag = double(reshape(typecast(mag(:),'uint16'),imsize_ori))-2^15;
% ph = double(reshape(typecast(ph(:),'uint16'),imsize_ori))-2^15;




% tmp_ph = 2*pi.*(tmp_ph - min(tmp_ph(:)))/(max(tmp_ph(:)) - min(tmp_ph(:))) - pi;

% % permute into axial

% vox = [0.7 0.64 0.64];

% ph_a = flip(permute(ph, [3 1 2 4]) ,1);
% nii = make_nii(ph_a);
% save_nii(nii,'ph_a_all.nii');

% mag_a = flip(permute(mag, [3 1 2 4]) ,1);
% nii = make_nii(mag_a);
% save_nii(nii,'mag_a_all.nii');



% % ditch the first echo
% ph_a = ph_a(:,:,:,2:4);
% mag_a = mag_a(:,:,:,2:4);
% TE = [11.5, 19, 28.5]*1e-3;
% imsize = size(mag_a);


% BEGIN THE QSM RECON PIPELINE
% initial quick brain mask
% simple sum-of-square combination
nii = make_nii((mag(:,:,:,1)),vox);
save_nii(nii,'mag1_sos.nii');

% unix('N4BiasFieldCorrection -i mag1_sos.nii -o mag1_sos_n4.nii');

unix('bet2 mag1_sos.nii BET -f 0.4 -m');
% set a lower threshold for postmortem
% unix('bet2 mag1_sos.nii BET -f 0.1 -m');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);

% coil combination % smoothing factor 10?
[ph_corr,mag_corr] = poem(mag,ph,vox,TE,mask);
nii = make_nii(ph_corr);
save_nii(nii,'ph_corr.nii');

% % no phase offset correction??
% mag_corr = mag;
% ph_corr = ph;



% newStr = extractBetween(text,'ParamLong."ucReadOutMode"','}');

% if newStr{1}(20) == '2' %bipolar 
%     [ph_corr(:,:,:,1:2:end),mag_corr(:,:,:,1:2:end)] = poem(Mag_inv2(:,:,:,1:2:end,:),Ph_inv2(:,:,:,1:2:end,:),vox,TE(1:2:end),mask);
%     !mkdir odd_box3d; mv offsets* odd_box3d
%     [ph_corr(:,:,:,2:2:end),mag_corr(:,:,:,2:2:end)] = poem(Mag_inv2(:,:,:,2:2:end,:),Ph_inv2(:,:,:,2:2:end,:),vox,TE(2:2:end),mask);
%     !mkdir even_box3d; mv offsets* even_box3d
% else % unipolar
%     [ph_corr,mag_corr] = poem(Mag_inv2,Ph_inv2,vox,TE,mask);
% end


% clear mag_a ph_a

% save niftis after coil combination
mkdir('src');
for echo = 1:imsize(4)
    nii = make_nii(mag_corr(:,:,:,echo),vox);
    save_nii(nii,['src/mag_corr' num2str(echo) '.nii']);
    nii = make_nii(ph_corr(:,:,:,echo),vox);
    save_nii(nii,['src/ph_corr' num2str(echo) '.nii']);
end

save('raw.mat','ph_corr','mag_corr','mask');



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
fit_thr = 40;
tik_reg = 1e-6;
cgs_num = 500;
lsqr_num = 500;
% tv_reg = 2e-4;
inv_num = 500;
dicom_info.MagneticFieldStrength = 7; 

% fit phase images with echo times
disp('--> magnitude weighted LS fit of phase to TE ...');
[tfs_0, fit_residual_0] = echofit(unph,mag_corr,TE,0); 
% [tfs_0, fit_residual_0] = echofit(unph,mag_corr,TE,1); 


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



