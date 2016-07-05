load spgr1_qsm_data

vox = [0.9375 0.9375 0.9444];
TE = spgr1_par.TE;
imsize = size(t1ffe1_mag);

mkdir('QSM');
cd QSM;


% save niftis for each echotime
mkdir('src');
for echo = 1:imsize(4)
    nii = make_nii(t1ffe1_mag(:,:,:,echo),vox);
    save_nii(nii,['src/mag_cmb' num2str(echo) '.nii']);
end


% generate mask from srcd magnitude of the 1th echo
bet_thr = 0.6;
disp('--> extract brain volume and generate mask ...');
setenv('bet_thr',num2str(bet_thr));
[status,cmdout] = unix('rm BET*');
unix('bet src/mag_cmb1.nii BET -f ${bet_thr} -m -R');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);


% bipolar phase correction
ph_cmb = zeros(imsize);
ph_cmb(:,:,:,1:2:end) = geme_cmb(t1ffe1_mag(:,:,:,1:2:end).*exp(1j*t1ffe1_phase(:,:,:,1:2:end)),vox,TE(1:2:end),mask);
ph_cmb(:,:,:,2:2:end) = geme_cmb(t1ffe1_mag(:,:,:,2:2:end).*exp(1j*t1ffe1_phase(:,:,:,2:2:end)),vox,TE(2:2:end),mask);

% save phase niftis for each echotime
for echo = 1:imsize(4)
    nii = make_nii((ph_cmb(:,:,:,echo)),vox);
    save_nii(nii,['src/ph_cmb' num2str(echo) '.nii']);
end



% unwrap phase from each echo
disp('--> unwrap aliasing phase for all TEs using prelude...');
bash_command = sprintf(['for ph in src/ph_cmb*.nii\n' ...
'do\n' ...
'	base=`basename $ph`;\n' ...
'	dir=`dirname $ph`;\n' ...
'	mag=$dir/"mag"${base:2};\n' ...
'	unph="unph"${base:2};\n' ...
'	prelude -a $mag -p $ph -u $unph -m BET_mask.nii -n 12&\n' ...
'done\n' ...
'wait\n' ...
'gunzip -f unph*.gz\n']);

unix(bash_command);


unph_cmb = zeros(imsize);
for echo = 1:imsize(4)
    nii = load_nii(['unph_cmb' num2str(echo) '.nii']);
    unph_cmb(:,:,:,echo) = double(nii.img);
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

for echo = 2:imsize(4)
    meandiff = unph_cmb(:,:,:,echo)-unph_cmb(:,:,:,1)-double(echo-1)*unph_diff;
    meandiff = meandiff(mask==1);
    meandiff = mean(meandiff(:))
    njump = round(meandiff/(2*pi));
    disp(['    ' num2str(njump) ' 2pi jumps for TE' num2str(echo)]);
    unph_cmb(:,:,:,echo) = unph_cmb(:,:,:,echo) - njump*2*pi;
    unph_cmb(:,:,:,echo) = unph_cmb(:,:,:,echo).*mask;
end



% fit phase images with echo times
disp('--> magnitude weighted LS fit of phase to TE ...');
[tfs, fit_residual] = echofit(unph_cmb,t1ffe1_mag,TE);

r_mask = 1;
fit_thr = 10;
if r_mask
    % generate reliability map
    fit_residual_blur = smooth3(fit_residual,'box',round(4./vox/2)*2+1);
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
tfs = tfs/(2.675e8*3.0)*1e9; % unit ppm


% (1) RESHARP method
%%%%%%%%%%%%%%%%%%%%%%%%%%%
smv_rad = 4;
tik_reg = 5e-4;
tv_reg = 5e-4;
% 8e-4 seems to give the best balance 

inv_num = 500;
z_prjs = [1 0 0];

disp('--> RESHARP to remove background field ...');
[lfs_resharp, mask_resharp] = resharp(tfs,mask.*R,vox,smv_rad,tik_reg);

% save nifti
mkdir('RESHARP');
nii = make_nii(lfs_resharp,vox);
save_nii(nii,'RESHARP/lfs_resharp.nii');

% inversion of susceptibility 
disp('--> TV susceptibility inversion on RESHARP...');
sus_resharp = tvdi(lfs_resharp, mask_resharp, vox, tv_reg, ...
    t1ffe1_mag(:,:,:,end), z_prjs, inv_num);


% save nifti
nii = make_nii(sus_resharp.*mask_resharp,vox);
save_nii(nii,'RESHARP/sus_resharp.nii');


% (2) LBV method
lbv_tol = 1e-4;
lbv_peel = 2;

lfs_lbv = LBV(tfs,mask.*R,imsize(1:3),vox,lbv_tol,lbv_peel); % strip 2 layers
mask_lbv = ones(size(mask));
mask_lbv(lfs_lbv==0) = 0;
% 3D 2nd order polyfit to remove any residual background
lfs_lbv= poly3d(lfs_lbv,mask_lbv);

% save nifti
mkdir('LBV');
nii = make_nii(lfs_lbv,vox);
save_nii(nii,'LBV/lfs_lbv.nii');

% inversion of susceptibility
disp('--> TV susceptibility inversion on lbv...');
sus_lbv = tvdi(lfs_lbv,mask_lbv,vox,tv_reg, t1ffe1_mag(:,:,:,end),z_prjs,inv_num);

% save nifti
nii = make_nii(sus_lbv.*mask_lbv,vox);
save_nii(nii,'LBV/sus_lbv.nii');

