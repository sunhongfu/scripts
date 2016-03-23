% load in the MATLAB matrix and the NIFTI
load param


% left rotation
cd right

nii = load_nii('gre_fc_mag_e1.nii');
mag(:,:,:,1) = double(nii.img);
nii = load_nii('gre_fc_mag_e2.nii');
mag(:,:,:,2) = double(nii.img);
nii = load_nii('gre_fc_mag_e3.nii');
mag(:,:,:,3) = double(nii.img);
nii = load_nii('gre_fc_mag_e4.nii');
mag(:,:,:,4) = double(nii.img);
nii = load_nii('gre_fc_mag_e5.nii');
mag(:,:,:,5) = double(nii.img);

nii = load_nii('gre_fc_phase_e1.nii');
phase(:,:,:,1) = double(nii.img);
nii = load_nii('gre_fc_phase_e2.nii');
phase(:,:,:,2) = double(nii.img);
nii = load_nii('gre_fc_phase_e3.nii');
phase(:,:,:,3) = double(nii.img);
nii = load_nii('gre_fc_phase_e4.nii');
phase(:,:,:,4) = double(nii.img);
nii = load_nii('gre_fc_phase_e5.nii');
phase(:,:,:,5) = double(nii.img);



bet_thr = 0.1;
% generate mask from magnitude of the 1th echo
disp('--> extract brain volume and generate mask ...');
setenv('bet_thr',num2str(bet_thr));
[status,cmdout] = unix('rm BET*');
unix('bet2 gre_fc_mag_e1.nii BET -f ${bet_thr} -m -w 4');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);

imsize = size(mag);

% save niftis for each echotime
mkdir('src');
for echo = 1:imsize(4)
    nii = make_nii(mag(:,:,:,echo),voxel_size);
    save_nii(nii,['src/mag' num2str(echo) '.nii']);
end

% save niftis for each echotime
mkdir('src');
for echo = 1:imsize(4)
    nii = make_nii((phase(:,:,:,echo)),voxel_size);
    save_nii(nii,['src/phase' num2str(echo) '.nii']);
end




% (1) unwrap using PRELUDE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% unwrap phase from each echo
disp('--> unwrap aliasing phase for all TEs using prelude...');

nii = make_nii(mask,voxel_size);
save_nii(nii,'BET_mask.nii');

setenv('echo_num',num2str(imsize(4)));
bash_command = sprintf(['for ph in src/phase[1-$echo_num].nii\n' ...
'do\n' ...
'   base=`basename $ph`;\n' ...
'   dir=`dirname $ph`;\n' ...
'   mag=$dir/"mag"${base:5};\n' ...
'   unph="unph"${base:5};\n' ...
'   prelude -a $mag -p $ph -u $unph -m BET_mask.nii -n 12&\n' ...
'done\n' ...
'wait\n' ...
'gunzip -f unph*.gz\n']);

unix(bash_command);

for echo = 1:imsize(4)
    nii = load_nii(['unph' num2str(echo) '.nii']);
    tmp = double(nii.img);
    unph(:,:,:,echo) = tmp - round(mean(tmp(mask==1))/(2*pi))*2*pi;
end


% echo fitting
[tfs, fit_residual] = echofit(unph,mag,TE-TE(1),0); % zero intercept
% [tfs1, fit_residual1, off1] = echofit(unph(:,:,:,2:4),mag(:,:,:,2:4),TE(2:4),1); % non-zero intercept

% normalize to main field
% ph = gamma*dB*TE
% dB/B = ph/(gamma*TE*B0)
% units: TE s, gamma 2.675e8 rad/(sT), B0 3T
tfs = tfs/(2.675e8*3)*1e6; % unit ppm


% extra filtering according to fitting residuals
% generate reliability map "R"
fit_residual_blur = smooth3(fit_residual,'box',round(1./voxel_size)*2+1); 
nii = make_nii(fit_residual_blur,voxel_size);
save_nii(nii,'fit_residual_blur.nii');
R = ones(size(fit_residual_blur));
R(fit_residual_blur >= 20) = 0;



% (1) RESHARP and inversion
smv_rad = 3;
tik_reg = 1e-3;
tv_reg = 5e-4;
inv_num = 500;
cgs_num = 500;

disp('--> RESHARP to remove background field ...');
[lfs_resharp, mask_resharp] = resharp(tfs,mask.*R,voxel_size,smv_rad,tik_reg,cgs_num);


% save nifti
mkdir('RESHARP');
nii = make_nii(lfs_resharp,voxel_size);
save_nii(nii,'RESHARP/lfs_resharp.nii');




