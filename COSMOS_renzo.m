% generate mask for each orientation based on the registeration
unix('/usr/share/fsl/5.0/bin/convert_xfm -omat /home/hongfu/Desktop/9175/QSM_SPGRE_LEFT/mask_flirt.mat -inverse /home/hongfu/Desktop/9175/QSM_SPGRE_LEFT/mag_flirt.mat');
unix('/usr/share/fsl/5.0/bin/flirt -in /home/hongfu/Desktop/9175/QSM_SPGRE_CENTER/QSM_SPGR_GE/BET_mask.nii -applyxfm -init /home/hongfu/Desktop/9175/QSM_SPGRE_LEFT/mask_flirt.mat -out /home/hongfu/Desktop/9175/QSM_SPGRE_LEFT/mask_flirt.nii -paddingsize 0.0 -interp trilinear -ref /home/hongfu/Desktop/9175/QSM_SPGRE_CENTER/QSM_SPGR_GE/BET_mask.nii');

unix('/usr/share/fsl/5.0/bin/convert_xfm -omat /home/hongfu/Desktop/9175/QSM_SPGRE_RIGHT/mask_flirt.mat -inverse /home/hongfu/Desktop/9175/QSM_SPGRE_RIGHT/mag_flirt.mat');
unix('/usr/share/fsl/5.0/bin/flirt -in /home/hongfu/Desktop/9175/QSM_SPGRE_CENTER/QSM_SPGR_GE/BET_mask.nii -applyxfm -init /home/hongfu/Desktop/9175/QSM_SPGRE_RIGHT/mask_flirt.mat -out /home/hongfu/Desktop/9175/QSM_SPGRE_RIGHT/mask_flirt.nii -paddingsize 0.0 -interp trilinear -ref /home/hongfu/Desktop/9175/QSM_SPGRE_CENTER/QSM_SPGR_GE/BET_mask.nii');

unix('/usr/share/fsl/5.0/bin/convert_xfm -omat /home/hongfu/Desktop/9175/QSM_SPGRE_FORWARD/mask_flirt.mat -inverse /home/hongfu/Desktop/9175/QSM_SPGRE_FORWARD/mag_flirt.mat');
unix('/usr/share/fsl/5.0/bin/flirt -in /home/hongfu/Desktop/9175/QSM_SPGRE_CENTER/QSM_SPGR_GE/BET_mask.nii -applyxfm -init /home/hongfu/Desktop/9175/QSM_SPGRE_FORWARD/mask_flirt.mat -out /home/hongfu/Desktop/9175/QSM_SPGRE_FORWARD/mask_flirt.nii -paddingsize 0.0 -interp trilinear -ref /home/hongfu/Desktop/9175/QSM_SPGRE_CENTER/QSM_SPGR_GE/BET_mask.nii');

unix('/usr/share/fsl/5.0/bin/convert_xfm -omat /home/hongfu/Desktop/9175/QSM_SPGRE_BACKWARD/mask_flirt.mat -inverse /home/hongfu/Desktop/9175/QSM_SPGRE_BACKWARD/mag_flirt.mat');
unix('/usr/share/fsl/5.0/bin/flirt -in /home/hongfu/Desktop/9175/QSM_SPGRE_CENTER/QSM_SPGR_GE/BET_mask.nii -applyxfm -init /home/hongfu/Desktop/9175/QSM_SPGRE_BACKWARD/mask_flirt.mat -out /home/hongfu/Desktop/9175/QSM_SPGRE_BACKWARD/mask_flirt.nii -paddingsize 0.0 -interp trilinear -ref /home/hongfu/Desktop/9175/QSM_SPGRE_CENTER/QSM_SPGR_GE/BET_mask.nii');


load all.mat
r_mask = 0;
nii = load_nii('BET_mask.nii');
mask = double(nii.img);


% phase offset correction
% if unipolar
if strcmpi('unipolar',readout)
    ph_corr = geme_cmb(mag.*exp(1j*ph),vox,TE,mask);
% if bipolar
elseif strcmpi('bipolar',readout)
    ph_corr = zeros(imsize);
    ph_corr(:,:,:,1:2:end) = geme_cmb(mag(:,:,:,1:2:end).*exp(1j*ph(:,:,:,1:2:end)),vox,TE(1:2:end),mask);
    ph_corr(:,:,:,2:2:end) = geme_cmb(mag(:,:,:,2:2:end).*exp(1j*ph(:,:,:,2:2:end)),vox,TE(2:2:end),mask);
else
    error('is the sequence unipolar or bipolar readout?')
end

% save offset corrected phase niftis
for echo = 1:imsize(4)
    nii = make_nii(ph_corr(:,:,:,echo),vox);
    save_nii(nii,['src/ph_corr' num2str(echo) '.nii']);
end


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

% fit phase images with echo times
disp('--> magnitude weighted LS fit of phase to TE ...');
[tfs, fit_residual] = echofit(unph,mag,TE,0); 

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
% units: TE s, gamma 2.675e8 rad/(sT), B0 4.7T
tfs = -tfs/(2.675e8*dicom_info.MagneticFieldStrength)*1e6; % unit ppm

nii = make_nii(tfs,vox);
save_nii(nii,'tfs.nii');

disp('--> RESHARP to remove background field ...');
[lfs_resharp, mask_resharp] = resharp(tfs,mask.*R,vox,smv_rad,tik_reg,cgs_num);
% % 3D 2nd order polyfit to remove any residual background
% lfs_resharp= poly3d(lfs_resharp,mask_resharp);

% save nifti
mkdir('RESHARP');
nii = make_nii(lfs_resharp,vox);
save_nii(nii,['RESHARP/lfs_resharp_tik_', num2str(tik_reg), '_num_', num2str(cgs_num), '.nii']);

% inversion of susceptibility 
disp('--> TV susceptibility inversion on RESHARP...');
sus_resharp = tvdi(lfs_resharp,mask_resharp,vox,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 

% save nifti
nii = make_nii(sus_resharp.*mask_resharp,vox);
save_nii(nii,['RESHARP/sus_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);
