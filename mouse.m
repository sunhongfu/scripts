[iField voxel_size matrix_size TE delta_TE CF Affine3D B0_dir TR NumEcho] = Read_Bruker_raw(pwd);
iField = iField(:,:,70:112,:);
matrix_size(3) = 43;

mkdir src
nii = make_nii(abs(iField),voxel_size);
save_nii(nii,'src/mag.nii');
nii = make_nii(angle(iField),voxel_size);
save_nii(nii,'src/ph.nii');

imsize = size(iField);

for i = 1:size(iField,4)
	nii = make_nii(abs(iField(:,:,:,i)),voxel_size);
	save_nii(nii,['src/mag' num2str(i) '.nii']);

	% N3 correction
	setenv('echonum',num2str(i));
	unix('nii2mnc src/mag${echonum}.nii src/mag${echonum}.mnc');
	unix('nu_correct src/mag${echonum}.mnc src/corr_mag${echonum}.mnc -V1.0 -distance 10');
	unix('mnc2nii src/corr_mag${echonum}.mnc src/corr_mag${echonum}.nii');

	nii = make_nii(angle(iField(:,:,:,i)),voxel_size);
	save_nii(nii,['src/ph' num2str(i) '.nii']);
end


mag = zeros(imsize);
for echo = 1:imsize(4)
    nii = load_nii(['src/corr_mag' num2str(echo) '.nii']);
    mag(:,:,:,echo) = double(nii.img);
end

% % extract brain using itk-snap
% nii = load_nii('mask.nii');
% mask = double(nii.img);

mask = zeros(imsize(1:3));
mask(mag(:,:,:,1)>1.5) = 1;

nii = make_nii(mask,voxel_size);
save_nii(nii,'mask.nii');

% % phase offset correction?
% ph_corr = geme_cmb(iField,voxel_size,TE,mask);
% % save offset corrected phase niftis
% for echo = 1:size(iField,4)
%     nii = make_nii(ph_corr(:,:,:,echo),voxel_size);
%     save_nii(nii,['src/corr_ph' num2str(echo) '.nii']);
% end

!rm src/*.mnc
% unwrap each echo
disp('--> unwrap aliasing phase for all TEs using prelude...');
setenv('echo_num',num2str(size(iField,4)));
bash_command = sprintf(['for ph in src/ph[1-$echo_num].nii\n' ...
'do\n' ...
'   base=`basename $ph`;\n' ...
'   dir=`dirname $ph`;\n' ...
'   mag=$dir/"corr_mag"${base:2};\n' ...
'   unph="unph"${base:2};\n' ...
'   prelude -a $mag -p $ph -u $unph -m mask.nii -n 12&\n' ...
'done\n' ...
'wait\n' ...
'gunzip -f unph*.gz\n']);
unix(bash_command);


unph = zeros(imsize);
for echo = 1:imsize(4)
    nii = load_nii(['unph' num2str(echo) '.nii']);
    unph(:,:,:,echo) = double(nii.img);
end


% check and correct for 2pi jump between echoes
disp('--> correct for potential 2pi jumps between TEs ...')


unph(:,:,:,3) = unph(:,:,:,3)-2*pi;
unph(:,:,:,4) = unph(:,:,:,4)-2*pi;
unph(:,:,:,5) = unph(:,:,:,5)-4*pi;

unph = unph.*repmat(mask,[1 1 1 5]);
nii = make_nii(unph,voxel_size);
save_nii(nii,'unph_prelude.nii');



% nii = load_nii('unph_cmb1.nii');
% unph1 = double(nii.img);
% nii = load_nii('unph_cmb2.nii');
% unph2 = double(nii.img);
% unph_diff = unph2 - unph1;

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




% unwrap the phase using best path
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

unph = zeros(imsize);
ph_corr = angle(iField);

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

    fid = fopen(['reliability' num2str(echo_num) '.dat'],'r');
    reliability_raw = fread(fid,'float');
    reliability_raw = reshape(reliability_raw,imsize(1:3));
    fclose(fid);

    nii = make_nii(reliability_raw.*mask,voxel_size);
    save_nii(nii,['reliability_raw' num2str(echo_num) '.nii']);
end

unph(:,:,:,3) = unph(:,:,:,3)-2*pi;
unph(:,:,:,4) = unph(:,:,:,4)-2*pi;
unph(:,:,:,5) = unph(:,:,:,5)-4*pi;

unph = unph.*repmat(mask,[1 1 1 5]);
nii = make_nii(unph,voxel_size);
save_nii(nii,'unph_bestpath.nii');



% fit phase images with echo times
disp('--> magnitude weighted LS fit of phase to TE ...');
[tfs, fit_residual] = echofit(unph,mag,TE,1); 

r_mask = 1;
fit_thr = 0.5;
% extra filtering according to fitting residuals
if r_mask
    % generate reliability map
    fit_residual_blur = smooth3(fit_residual,'box',round(0.1./voxel_size)*2+1); 
    nii = make_nii(fit_residual_blur,voxel_size);
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
tfs = -tfs/(2.675e8*9.4)*1e6; % unit ppm

nii = make_nii(tfs,voxel_size);
save_nii(nii,'tfs.nii');


disp('--> RESHARP to remove background field ...');
smv_rad = 0.3;
tik_reg = 5e-4;
cgs_num = 500;
tv_reg = 2e-4;
z_prjs = B0_dir;
inv_num = 5000;

[lfs_resharp, mask_resharp] = resharp(tfs,mask.*R,voxel_size,smv_rad,tik_reg,cgs_num);
% % 3D 2nd order polyfit to remove any residual background
% lfs_resharp= lfs_resharp - poly3d(lfs_resharp,mask_resharp);

% save nifti
[~,~,~] = mkdir('RESHARP');
nii = make_nii(lfs_resharp,voxel_size);
save_nii(nii,['RESHARP/lfs_resharp_tik_', num2str(tik_reg), '_num_', num2str(cgs_num), '.nii']);

% inversion of susceptibility 
disp('--> TV susceptibility inversion on RESHARP...');
sus_resharp = tvdi(lfs_resharp,mask_resharp,voxel_size,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 

% save nifti
nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
save_nii(nii,['RESHARP/sus_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mkdir TFS_TIK_PRE_ERO0
cd TFS_TIK_PRE_ERO0
tfs_pad = padarray(tfs,[0 0 20]);
mask_pad = padarray(mask,[0 0 20]);
% R_pad = padarray(R,[0 0 20]);
r=0;
Tik_weight = [1e-4, 1e-3, 5e-3];
TV_weight = 1e-4;
for i = 1:length(Tik_weight)
	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 200);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_200.nii']);
	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 500);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_500.nii']);
	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 2000);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);
	chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), voxel_size, B0_dir, 2000);
	nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),voxel_size);
	save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);
end
cd ..












[iFreq_raw N_std] = Fit_ppm_complex(iField);
nii = make_nii(iFreq_raw,voxel_size);
save_nii(nii,'iFreq_raw.nii');


% phase unwrapping using prelude
!prelude -a mag1.nii -p iFreq_raw.nii -u iFreq_un -m mask.nii -n 8&\n' ...

nii = load_nii('iFreq_un.nii');
iFreq = double(nii.img);


% RESHARP background field removal
[RDF, mask_resharp] = resharp(iFreq,mask,voxel_size,0.3,1e-4,200);
nii = make_nii(RDF,voxel_size);
save_nii(nii,'RDF_resharp.nii');

lfs_resharp = RDF/(2.675e8*9.4*delta_TE*1e-6);

% TVDI
sus_resharp = tvdi(lfs_resharp,mask_resharp,voxel_size,5e-5,abs(iField(:,:,:,end)),B0_dir,500);
nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
save_nii(nii,'QSM_resharp_5e-5.nii');

sus_resharp = tvdi(lfs_resharp,mask_resharp,voxel_size,1e-5,abs(iField(:,:,:,end)),B0_dir,500);
nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
save_nii(nii,'QSM_resharp_1e-5.nii');

sus_resharp = tvdi(lfs_resharp,mask_resharp,voxel_size,1e-4,abs(iField(:,:,:,end)),B0_dir,500);
nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
save_nii(nii,'QSM_resharp_1e-4.nii');

sus_resharp = tvdi(lfs_resharp,mask_resharp,voxel_size,1e-3,abs(iField(:,:,:,end)),B0_dir,500);
nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
save_nii(nii,'QSM_resharp_1e-3.nii');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mkdir TFS_TIK_PRE_ERO0
cd TFS_TIK_PRE_ERO0
tfs_pad = padarray(iFreq/(2.675e8*9.4*delta_TE*1e-6),[0 0 20]);
mask_pad = padarray(mask,[0 0 20]);
% R_pad = padarray(R,[0 0 20]);
r=0;
Tik_weight = [1e-3];
TV_weight = 2e-4;
for i = 1:length(Tik_weight)
	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 200);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_200.nii']);
	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 500);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_500.nii']);
	% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 2000);
	% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
	% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);
	chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), voxel_size, B0_dir, 2000);
	nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),voxel_size);
	save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);
end
cd ..

