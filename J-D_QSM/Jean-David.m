load spgr_data2_chunks
load par_test

img = cat(4, t1ffe2a,t1ffe2b);
imsize = size(img);
vox = par.RecVoxelSize;
TE = TE2;

mkdir('QSM');
cd QSM;

% save niftis for each echotime
mkdir('combine');
for echo = 1:imsize(4)
    nii = make_nii(abs(img(:,:,:,echo)),vox);
    save_nii(nii,['combine/mag_cmb' num2str(echo) '.nii']);
end

bet_thr = 0.6;
% generate mask from combined magnitude of the 1th echo
disp('--> extract brain volume and generate mask ...');
setenv('bet_thr',num2str(bet_thr));
[status,cmdout] = unix('rm BET*');
unix('bet combine/mag_cmb1.nii BET -f ${bet_thr} -m -R');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);

ph_cmb = zeros(imsize);
ph_cmb(:,:,:,1:2:end) = geme_cmb(img(:,:,:,1:2:end),vox,TE(1:2:end));
ph_cmb(:,:,:,2:2:end) = geme_cmb(img(:,:,:,2:2:end),vox,TE(2:2:end));

% save niftis for each echotime
mkdir('combine');
for echo = 1:imsize(4)
    nii = make_nii((ph_cmb(:,:,:,echo)),vox);
    save_nii(nii,['combine/ph_cmb' num2str(echo) '.nii']);
end


% % angles!!!
% Xz = dicom_info.ImageOrientationPatient(3);
% Yz = dicom_info.ImageOrientationPatient(6);
% Zz = sqrt(1 - Xz^2 - Yz^2);
% z_prjs = [Xz, Yz, Zz];


% unwrap phase from each echo
disp('--> unwrap aliasing phase for all TEs using prelude...');

% setenv('echo_num',num2str(imsize(4)));
bash_command = sprintf(['for ph in combine/ph_cmb*.nii\n' ...
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
[tfs, fit_residual] = echofit(unph_cmb,abs(img),TE); 

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
tfs = tfs/(2.675e8*par.FieldStrength)*1e9; % unit ppm


smv_rad = 4;
tik_reg = 1e-3;


%%%%%%%%%%%%%%%%%%%%%%%%%%%
tv_reg = 8e-4;
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
    abs(img(:,:,:,end)), z_prjs, inv_num); 


% save nifti
nii = make_nii(sus_resharp.*mask_resharp,vox);
save_nii(nii,'RESHARP/sus_resharp.nii');
