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



bet_thr = 0.4;
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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% phase unwrapping
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

%unph = zeros(imsize);
%
%for echo_num = 1:imsize(4)
%    setenv('echo_num',num2str(echo_num));
%    fid = fopen(['wrapped_phase' num2str(echo_num) '.dat'],'w');
%    fwrite(fid,phase(:,:,:,echo_num),'float');
%    fclose(fid);
%
%    bash_script = ['${pathstr}/3DSRNCP wrapped_phase${echo_num}.dat mask_unwrp.dat ' ...
%        'unwrapped_phase${echo_num}.dat $nv $np $ns reliability${echo_num}.dat'];
%    unix(bash_script) ;
%
%    fid = fopen(['unwrapped_phase' num2str(echo_num) '.dat'],'r');
%    tmp = fread(fid,'float');
%    % tmp = tmp - tmp(1);
%    unph(:,:,:,echo_num) = reshape(tmp - round(mean(tmp(mask==1))/(2*pi))*2*pi ,imsize(1:3)).*mask;
%    fclose(fid);
%
%    fid = fopen(['reliability' num2str(echo_num) '.dat'],'r');
%    reliability_raw = fread(fid,'float');
%    reliability_raw = reshape(reliability_raw,imsize(1:3));
%    fclose(fid);
%
%    nii = make_nii(reliability_raw.*mask,voxel_size);
%    save_nii(nii,['reliability_raw' num2str(echo_num) '.nii']);
%end
%
%nii = make_nii(unph,voxel_size);
%save_nii(nii,'unph_bestpath.nii');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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

%for echo = 1:imsize(4)
%    nii = load_nii(['unph' num2str(echo) '.nii']);
%    tmp = double(nii.img);
%    unph(:,:,:,echo) = mask.*(tmp - round(mean(tmp(mask==1))/(2*pi))*2*pi);
%end
%
%nii = make_nii(unph,voxel_size);
%save_nii(nii,'unph.nii');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% check and correct for 2pi jump between echoes
disp('--> correct for potential 2pi jumps between TEs ...')

ph_diff = angle(exp(1j*phase(:,:,:,2))./exp(1j*phase(:,:,:,1)));

% unwrap ph_diff
fid = fopen('ph_diff.dat','w');
fwrite(fid,ph_diff,'float');
fclose(fid);
bash_script = ['${pathstr}/3DSRNCP ph_diff.dat mask_unwrp.dat ' ...
    'unph_diff.dat $nv $np $ns reliability_diff.dat'];
unix(bash_script) ;

fid = fopen('unph_diff.dat','r');
tmp = fread(fid,'float');
% tmp = tmp - tmp(1);
unph_diff= reshape(tmp - round(mean(tmp(mask==1))/(2*pi))*2*pi ,imsize(1:3)).*mask;
fclose(fid);


for echo = 2:imsize(4)
    meandiff = unph(:,:,:,echo)-unph(:,:,:,1)-double(echo-1)*unph_diff;
    meandiff = meandiff(mask==1);
    meandiff = mean(meandiff(:))
    njump = round(meandiff/(2*pi));
    disp(['    ' num2str(njump) ' 2pi jumps for TE' num2str(echo)]);
    unph(:,:,:,echo) = unph(:,:,:,echo) - njump*2*pi;
    unph(:,:,:,echo) = unph(:,:,:,echo).*mask;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% echo fitting
% [tfs, fit_residual] = echofit(unph,mag,TE-TE(1),0); % zero intercept
[tfs, fit_residual] = echofit(unph,mag,[0,delta_TE,2*delta_TE,3*delta_TE,4*delta_TE],1);
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
smv_rad = 4;
tik_reg = 1e-4;
tv_reg = 5e-4;
inv_num = 500;
cgs_num = 500;

disp('--> RESHARP to remove background field ...');
[lfs_resharp, mask_resharp] = resharp(tfs,mask.*R,voxel_size,smv_rad,tik_reg,cgs_num);


% save nifti
mkdir('RESHARP');
nii = make_nii(lfs_resharp,voxel_size);
save_nii(nii,'RESHARP/lfs_resharp.nii');



% inversion of susceptibility on straight only
disp('--> TV susceptibility inversion on RESHARP...');
sus_resharp = tvdi(lfs_resharp, mask, voxel_size, tv_reg, ...
    mag(:,:,:,end), [], inv_num); 


% save nifti
nii = make_nii(sus_resharp.*mask,voxel_size);
save_nii(nii,'RESHARP/sus_resharp.nii');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% register left and right images to straight with FLIRT
/usr/share/fsl/5.0/bin/flirt -in /media/data/QSM_data/COSMOS/fc/left/src/mag1.nii -ref /media/data/QSM_data/COSMOS/fc/straight/src/mag1.nii -out /media/data/QSM_data/COSMOS/fc/left/src/mag_flirt.nii -omat /media/data/QSM_data/COSMOS/fc/left/src/mag_flirt.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear
/usr/share/fsl/5.0/bin/flirt -in /media/data/QSM_data/COSMOS/fc/left/RESHARP/lfs_resharp.nii -applyxfm -init /media/data/QSM_data/COSMOS/fc/left/src/mag_flirt.mat -out /media/data/QSM_data/COSMOS/fc/left/RESHARP/lfs_resharp_left_flirt.nii -paddingsize 0.0 -interp trilinear -ref /media/data/QSM_data/COSMOS/fc/left/src/mag_flirt.nii.gz
/usr/share/fsl/5.0/bin/flirt -in /media/data/QSM_data/COSMOS/fc/right/src/mag1.nii -ref /media/data/QSM_data/COSMOS/fc/straight/src/mag1.nii -out /media/data/QSM_data/COSMOS/fc/right/src/mag_flirt.nii -omat /media/data/QSM_data/COSMOS/fc/right/src/mag_flirt.mat -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 6  -interp trilinear
/usr/share/fsl/5.0/bin/flirt -in /media/data/QSM_data/COSMOS/fc/right/RESHARP/lfs_resharp.nii -applyxfm -init /media/data/QSM_data/COSMOS/fc/right/src/mag_flirt.mat -out /media/data/QSM_data/COSMOS/fc/right/RESHARP/lfs_resharp_right_flirt.nii -paddingsize 0.0 -interp trilinear -ref /media/data/QSM_data/COSMOS/fc/right/src/mag_flirt.nii.gz



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load in rotation matrix
cd left/src
load mag_flirt -ascii
rot_mat_left = mag_flirt(1:3,1:3);

cd ../..
cd right/src
load mag_flirt -ascii
rot_mat_right = mag_flirt(1:3,1:3);


z_prjs_left = rot_mat_left'*[0 0 1]'; % (each orientation has own R and z_prjs)

Nx = imsize(1);
Ny = imsize(2);
Nz = imsize(3);
FOV = voxel_size.*[Nx,Ny,Nz];
FOVx = FOV(1);
FOVy = FOV(2);
FOVz = FOV(3);

x = -Nx/2:Nx/2-1;
y = -Ny/2:Ny/2-1;
z = -Nz/2:Nz/2-1;
[kx,ky,kz] = ndgrid(x/FOVx,y/FOVy,z/FOVz);
% D = 1/3 - kz.^2./(kx.^2 + ky.^2 + kz.^2);
D_left = 1/3 - (kx.*z_prjs_left(1)+ky.*z_prjs_left(2)+kz.*z_prjs_left(3)).^2./(kx.^2 + ky.^2 + kz.^2);
D_left(floor(Nx/2+1),floor(Ny/2+1),floor(Nz/2+1)) = 0;
D_left = fftshift(D_left);



z_prjs_right = rot_mat_right'*[0 0 1]'; % (each orientation has own R and z_prjs)

Nx = imsize(1);
Ny = imsize(2);
Nz = imsize(3);
FOV = voxel_size.*[Nx,Ny,Nz];
FOVx = FOV(1);
FOVy = FOV(2);
FOVz = FOV(3);

x = -Nx/2:Nx/2-1;
y = -Ny/2:Ny/2-1;
z = -Nz/2:Nz/2-1;
[kx,ky,kz] = ndgrid(x/FOVx,y/FOVy,z/FOVz);
% D = 1/3 - kz.^2./(kx.^2 + ky.^2 + kz.^2);
D_right = 1/3 - (kx.*z_prjs_right(1)+ky.*z_prjs_right(2)+kz.*z_prjs_right(3)).^2./(kx.^2 + ky.^2 + kz.^2);
D_right(floor(Nx/2+1),floor(Ny/2+1),floor(Nz/2+1)) = 0;
D_right = fftshift(D_right);




z_prjs_straight = [0 0 1]'; % (each orientation has own R and z_prjs)

Nx = imsize(1);
Ny = imsize(2);
Nz = imsize(3);
FOV = voxel_size.*[Nx,Ny,Nz];
FOVx = FOV(1);
FOVy = FOV(2);
FOVz = FOV(3);

x = -Nx/2:Nx/2-1;
y = -Ny/2:Ny/2-1;
z = -Nz/2:Nz/2-1;
[kx,ky,kz] = ndgrid(x/FOVx,y/FOVy,z/FOVz);
% D = 1/3 - kz.^2./(kx.^2 + ky.^2 + kz.^2);
D_straight = 1/3 - (kx.*z_prjs_straight(1)+ky.*z_prjs_straight(2)+kz.*z_prjs_straight(3)).^2./(kx.^2 + ky.^2 + kz.^2);
D_straight(floor(Nx/2+1),floor(Ny/2+1),floor(Nz/2+1)) = 0;
D_straight = fftshift(D_straight);




%% COSMOS reconstruction with closed-form solution
cd ../..
cd straight/RESHARP
nii = load_nii('lfs_resharp.nii');
lfs_resharp_straight = double(nii.img);
mask = and(lfs_resharp_straight,1);

cd ../..
cd left/RESHARP
unix('gunzip -f *.gz');
nii = load_nii('lfs_resharp_left_flirt.nii');
lfs_resharp_left = double(nii.img);
mask = and(mask,lfs_resharp_left);

cd ../..
cd right/RESHARP
unix('gunzip -f *.gz');
nii = load_nii('lfs_resharp_right_flirt.nii');
lfs_resharp_right = double(nii.img);
mask = and(mask,lfs_resharp_right);



lfs_resharp = cat(4,lfs_resharp_left.*mask,lfs_resharp_straight.*mask,lfs_resharp_right.*mask);
kernel = cat(4,D_left,D_straight,D_right);

for t = 1:size(lfs_resharp,4)
    lfs_resharp_k(:,:,:,t) = fftn(lfs_resharp(:,:,:,t));
end

kernel_sum = sum(abs(kernel).^2, 4);

chi_cosmos = real( ifftn( sum(kernel .* lfs_resharp_k, 4) ./ (eps + kernel_sum) ) ) .* mask;


nii = make_nii(chi_cosmos,voxel_size);
save_nii(nii,'chi_cosmos.nii');






