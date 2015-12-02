% work with datasets of "QSM_gre_data_20150819", "20151102/1mm_iso"


% load in the MATLAB matrix and the NIFTI
load param

% nii = load_nii('gre_mag_e1.nii');
% mag(:,:,:,1) = double(nii.img);
% nii = load_nii('gre_mag_e2.nii');
% mag(:,:,:,2) = double(nii.img);
% nii = load_nii('gre_mag_e3.nii');
% mag(:,:,:,3) = double(nii.img);
% nii = load_nii('gre_mag_e4.nii');
% mag(:,:,:,4) = double(nii.img);

% nii = load_nii('gre_phase_e1.nii');
% phase(:,:,:,1) = double(nii.img);
% nii = load_nii('gre_phase_e2.nii');
% phase(:,:,:,2) = double(nii.img);
% nii = load_nii('gre_phase_e3.nii');
% phase(:,:,:,3) = double(nii.img);
% nii = load_nii('gre_phase_e4.nii');
% phase(:,:,:,4) = double(nii.img);


nii = load_nii('mag_e1.nii');
mag(:,:,:,1) = double(nii.img);
nii = load_nii('mag_e2.nii');
mag(:,:,:,2) = double(nii.img);
nii = load_nii('mag_e3.nii');
mag(:,:,:,3) = double(nii.img);
nii = load_nii('mag_e4.nii');
mag(:,:,:,4) = double(nii.img);
nii = load_nii('mag_e5.nii');
mag(:,:,:,5) = double(nii.img);

nii = load_nii('phase_e1.nii');
phase(:,:,:,1) = double(nii.img);
nii = load_nii('phase_e2.nii');
phase(:,:,:,2) = double(nii.img);
nii = load_nii('phase_e3.nii');
phase(:,:,:,3) = double(nii.img);
nii = load_nii('phase_e4.nii');
phase(:,:,:,4) = double(nii.img);
nii = load_nii('phase_e5.nii');
phase(:,:,:,5) = double(nii.img);

% nii = load_nii('brain_mask_larger.nii');
nii = load_nii('brain_bet2_mask.nii');
mask = double(nii.img);

mkdir('QSM_prelude');
cd('QSM_prelude');
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


% (2) unwrap using best path
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % phase unwrapping
% % unwrap the phase using best path
% disp('--> unwrap aliasing phase using bestpath...');
% mask_unwrp = uint8(abs(mask)*255);
% fid = fopen('mask_unwrp.dat','w');
% fwrite(fid,mask_unwrp,'uchar');
% fclose(fid);

% [pathstr, ~, ~] = fileparts(which('3DSRNCP.m'));
% setenv('pathstr',pathstr);
% setenv('nv',num2str(imsize(1)));
% setenv('np',num2str(imsize(2)));
% setenv('ns',num2str(imsize(3)));


% unph = zeros(imsize);

% for echo_num = 1:imsize(4)
%     setenv('echo_num',num2str(echo_num));
%     fid = fopen(['wrapped_phase' num2str(echo_num) '.dat'],'w');
%     fwrite(fid,phase(:,:,:,echo_num),'float');
%     fclose(fid);

%     bash_script = ['${pathstr}/3DSRNCP wrapped_phase${echo_num}.dat mask_unwrp.dat ' ...
%         'unwrapped_phase${echo_num}.dat $nv $np $ns reliability${echo_num}.dat'];
%     unix(bash_script) ;

%     fid = fopen(['unwrapped_phase' num2str(echo_num) '.dat'],'r');
%     tmp = fread(fid,'float');
%     % tmp = tmp - tmp(1);
%     unph(:,:,:,echo_num) = reshape(tmp - round(mean(tmp(mask==1))/(2*pi))*2*pi ,imsize(1:3)).*mask;
%     fclose(fid);

%     fid = fopen(['reliability' num2str(echo_num) '.dat'],'r');
%     reliability_raw = fread(fid,'float');
%     reliability_raw = reshape(reliability_raw,imsize(1:3));
%     fclose(fid);

%     nii = make_nii(reliability_raw.*mask,voxel_size);
%     save_nii(nii,['reliability_raw' num2str(echo_num) '.nii']);
% end

% nii = make_nii(unph,voxel_size);
% save_nii(nii,'unph_bestpath.nii');
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



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

% inversion of susceptibility 
disp('--> TV susceptibility inversion on RESHARP...');
sus_resharp = tvdi(lfs_resharp, mask_resharp, voxel_size, tv_reg, ...
    mag(:,:,:,end), [], inv_num); 


% save nifti
nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
save_nii(nii,'RESHARP/sus_resharp.nii');



% (2) LBV and inversion
lbv_tol = 0.01;
lbv_peel = 2;
tv_reg = 5e-4;
inv_num = 500;

disp('--> LBV to remove background field ...');
lfs_lbv = LBV(tfs,mask.*R,imsize(1:3),voxel_size,lbv_tol,lbv_peel); % strip 2 layers
mask_lbv = ones(imsize(1:3));
mask_lbv(lfs_lbv==0) = 0;
% 3D 2nd order polyfit to remove any residual background
lfs_lbv= poly3d(lfs_lbv,mask_lbv);

% save nifti
mkdir('LBV');
nii = make_nii(lfs_lbv,voxel_size);
save_nii(nii,'LBV/lfs_lbv.nii');

% inversion of susceptibility 
disp('--> TV susceptibility inversion on lbv...');
sus_lbv = tvdi(lfs_lbv,mask_lbv,voxel_size,tv_reg,mag(:,:,:,end),[],inv_num);   

% save nifti
nii = make_nii(sus_lbv.*mask_lbv,voxel_size);
save_nii(nii,'LBV/sus_lbv.nii');

save all.mat
