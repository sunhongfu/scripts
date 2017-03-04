% yuhan's dataset   
% work with "dataset1_0.6mm_iso"
load Yuhan_QSM_data;


mkdir('QSM_prelude');
cd QSM_prelude;

% img = mag.*exp(1j*phase);
imsize = size(mag);
vox = voxel_size;

% save niftis for each echotime
mkdir('src');
for echo = 1:imsize(4)
    nii = make_nii(mag(:,:,:,echo),vox);
    save_nii(nii,['src/mag' num2str(echo) '.nii']);
end

bet_thr = 0.1;
% generate mask from magnitude of the 1th echo
disp('--> extract brain volume and generate mask ...');
setenv('bet_thr',num2str(bet_thr));
[status,cmdout] = unix('rm BET*');
unix('bet2 src/mag1.nii BET -f ${bet_thr} -m -w 4');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);



% save niftis for each echotime
mkdir('src');
for echo = 1:imsize(4)
    nii = make_nii((phase(:,:,:,echo)),vox);
    save_nii(nii,['src/phase' num2str(echo) '.nii']);
end


% angles!!!
z_prjs = [0 0 1]


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% unwrap phase from each echo
disp('--> unwrap aliasing phase for all TEs using prelude...');

setenv('echo_num',num2str(imsize(4)));
bash_command = sprintf(['for ph in src/phase[1-$echo_num].nii\n' ...
'do\n' ...
'	base=`basename $ph`;\n' ...
'	dir=`dirname $ph`;\n' ...
'	mag=$dir/"mag"${base:5};\n' ...
'	unph="unph"${base:5};\n' ...
'	prelude -a $mag -p $ph -u $unph -m BET_mask.nii -n 12&\n' ...
'done\n' ...
'wait\n' ...
'gunzip -f unph*.gz\n']);

unix(bash_command);

for echo = 1:imsize(4)
    nii = load_nii(['unph' num2str(echo) '.nii']);
    tmp = double(nii.img);
    unph(:,:,:,echo) = tmp - round(mean(tmp(mask==1))/(2*pi))*2*pi;
end


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

% % check and correct for 2pi jump between echoes
% disp('--> correct for potential 2pi jumps between TEs ...')

% % nii = load_nii('unph_cmb1.nii');
% % unph1 = double(nii.img);
% % nii = load_nii('unph_cmb2.nii');
% % unph2 = double(nii.img);
% % unph_diff = unph2 - unph1;

% nii = load_nii('unph_diff.nii');
% unph_diff = double(nii.img);

% for echo = 2:imsize(4)
%     meandiff = unph_cmb(:,:,:,echo)-unph_cmb(:,:,:,1)-double(echo-1)*unph_diff;
%     meandiff = meandiff(mask==1);
%     meandiff = mean(meandiff(:))
%     njump = round(meandiff/(2*pi));
%     disp(['    ' num2str(njump) ' 2pi jumps for TE' num2str(echo)]);
%     unph_cmb(:,:,:,echo) = unph_cmb(:,:,:,echo) - njump*2*pi;
%     unph_cmb(:,:,:,echo) = unph_cmb(:,:,:,echo).*mask;
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% echo fitting
[tfs, fit_residual] = echofit(unph,mag,TE-TE(1),0);
% normalize to main field
% ph = gamma*dB*TE
% dB/B = ph/(gamma*TE*B0)
% units: TE s, gamma 2.675e8 rad/(sT), B0 3T
tfs = tfs/(2.675e8*3)*1e6; % unit ppm
% nii = make_nii(tfs,voxel_size);
% save_nii(nii,'tfs.nii');
% nii = make_nii(fit_residual,voxel_size);
% save_nii(nii,'fit_residual.nii');





% extra filtering according to fitting residuals
% generate reliability map "R"
fit_residual_blur = smooth3(fit_residual,'box',round(1./voxel_size)*2+1); 
nii = make_nii(fit_residual_blur,voxel_size);
save_nii(nii,'fit_residual_blur.nii');
R = ones(size(fit_residual_blur));
R(fit_residual_blur >= 20) = 0;


% RESHARP and inversion
smv_rad = 3;
tik_reg = 1e-3;
tv_reg = 8e-4;
inv_num = 500;
cgs_num = 500;

disp('--> RESHARP to remove background field ...');
[lfs_resharp, mask_resharp] = resharp(tfs,mask.*R,voxel_size,smv_rad,tik_reg,cgs_num);


% save nifti
mkdir('RESHARP');
nii = make_nii(lfs_resharp,voxel_size);
save_nii(nii,'RESHARP/lfs_resharp_tik_1e-3_num_500.nii');

% inversion of susceptibility 
disp('--> TV susceptibility inversion on RESHARP...');
sus_resharp = tvdi(lfs_resharp, mask_resharp, voxel_size, tv_reg, ...
    mag(:,:,:,end), [], inv_num); 


% save nifti
nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
save_nii(nii,'RESHARP/sus_resharp_tv_8e-4_num_500.nii');

save all.mat
