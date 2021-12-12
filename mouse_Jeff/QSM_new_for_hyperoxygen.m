clear
load raw.mat


mkdir QSM_new
cd QSM_new

!mv ../src .



% 2 thresholding magnitude of TE1
% mask based on mag_cmb_mean
mask = ones(size(mag(:,:,:,1)));
mask(mag(:,:,:,1)<20000) = 0;
nii = make_nii(mask,voxel_size);
save_nii(nii,'mask_thr.nii');


% phase offset correction?
% ph_corr = geme_cmb_mouse(mag.*exp(1j*ph),voxel_size,TE,mask);
ph_corr = angle(iField);
% save offset corrected phase niftis
for echo = 1:imsize(4)
    nii = make_nii(ph_corr(:,:,:,echo),voxel_size);
    save_nii(nii,['src/corr_ph' num2str(echo) '.nii']);
end


% !rm src/*.mnc src/*.imp
clear iField



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

unph = zeros(imsize(1:4));

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


unph = unph.*repmat(mask,[1 1 1 imsize(4)]);
nii = make_nii(unph,voxel_size);
save_nii(nii,'unph_bestpath.nii');


% unwrap the phase difference
ph_diff = angle(exp(1j*(ph_corr(:,:,:,2)-ph_corr(:,:,:,1))));
nii = make_nii(ph_diff,voxel_size);
save_nii(nii,'ph_diff.nii');

fid = fopen(['wrapped_ph_diff.dat'],'w');
fwrite(fid,ph_diff,'float');
fclose(fid);
if isdeployed
    bash_script = ['~/bin/3DSRNCP wrapped_ph_diff.dat mask_unwrp.dat ' ...
    'unwrapped_ph_diff.dat $nv $np $ns reliability_ph_diff.dat'];
else    
    bash_script = ['${pathstr}/3DSRNCP wrapped_ph_diff.dat mask_unwrp.dat ' ...
    'unwrapped_ph_diff.dat $nv $np $ns reliability_ph_diff.dat'];
end
unix(bash_script) ;
fid = fopen(['unwrapped_ph_diff.dat'],'r');
tmp = fread(fid,'float');
% tmp = tmp - tmp(1);



mask_roi = zeros(size(mask));
% mask_roi(86:106,86:106,45:50) =1;

mask_roi(round(imsize(1)/2)-5:round(imsize(1)/2)+5,round(imsize(2)/2)-5:round(imsize(2)/2)+5,round(imsize(3)/2)-5:round(imsize(3)/2)+5) =1;



njumps = mean(tmp(mask_roi==1))/(2*pi)
% if njumps>-1 & njumps<0
%     njumps = -1;
% end

unph_diff = reshape(tmp - round(njumps)*2*pi ,imsize(1:3)).*mask;
fclose(fid);


nii = make_nii(unph_diff,voxel_size);
save_nii(nii,'unph_diff.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% correct for 2pi shifts in the first unwrapped echo
tmp = unph(:,:,:,1);
njumps = mean(tmp(mask_roi==1))/(2*pi)
% if njumps>-1 & njumps<0
%     njumps = -1;
% end

unph(:,:,:,1) = reshape(tmp - round(njumps)*2*pi ,imsize(1:3)).*mask;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% check and correct for 2pi jump between echoes
disp('--> correct for potential 2pi jumps between TEs ...')


% nii = load_nii('unph_diff.nii');
% unph_diff = double(nii.img);

% unph_diff = unph(:,:,:,2) - unph(:,:,:,1);

for echo = 2:imsize(4)
    meandiff = unph(:,:,:,echo)-unph(:,:,:,1)-double(echo-1)*unph_diff;
    meandiff = meandiff(mask_roi==1);
    meandiff = mean(meandiff(:))
    njump = round(meandiff/(2*pi));
    disp(['    ' num2str(njump) ' 2pi jumps for TE' num2str(echo)]);
    unph(:,:,:,echo) = unph(:,:,:,echo) - njump*2*pi;
    unph(:,:,:,echo) = unph(:,:,:,echo).*mask;
end

nii = make_nii(unph,voxel_size);
save_nii(nii,'unph.nii');


% fit phase images with echo times
disp('--> magnitude weighted LS fit of phase to TE ...');
[tfs0, fit_residual0] = echofit(unph,mag,TE,0); 
nii = make_nii(tfs0,voxel_size);
save_nii(nii,'tfs0.nii');
nii = make_nii(fit_residual0,voxel_size);
save_nii(nii,'fit_residual0.nii');

% [tfs1, fit_residual1] = echofit(unph,mag,TE,1); 
% nii = make_nii(tfs1,voxel_size);
% save_nii(nii,'tfs1.nii');
% nii = make_nii(fit_residual1,voxel_size);
% save_nii(nii,'fit_residual1.nii');

r_mask = 1;
fit_thr = 40;
% extra filtering according to fitting residuals
if r_mask
    % generate reliability map
    fit_residual_blur = smooth3(fit_residual0,'box',round(0.1./voxel_size)*2+1); 
    nii = make_nii(fit_residual_blur,voxel_size);
    save_nii(nii,'fit_residual_blur0.nii');
    R = ones(size(fit_residual_blur));
    R(fit_residual_blur >= fit_thr) = 0;
else
    R = 1;
end


% normalize to main field
% ph = gamma*dB*TE
% dB/B = ph/(gamma*TE*B0)
% units: TE s, gamma 2.675e8 rad/(sT), B0 3T
tfs = -tfs0/(2.675e8*9.4)*1e6; % unit ppm

nii = make_nii(tfs,voxel_size);
save_nii(nii,'tfs.nii');


clear ph_corr fit_residual0 fit_residual_blur mask_roi mask_unwrp ph_dif reliability_raw tfs0 tmp unph unph_diff


disp('--> RESHARP to remove background field ...');
smv_rad = 0.15;
tik_reg = 1e-4;
cgs_num = 200;
tv_reg = 2e-4;
z_prjs = B0_dir;
inv_num = 500;

[lfs_resharp, mask_resharp] = resharp_stencil(tfs,mask.*R,voxel_size,smv_rad,tik_reg,cgs_num);
% % 3D 2nd order polyfit to remove any residual background
% lfs_resharp= lfs_resharp - poly3d(lfs_resharp,mask_resharp);

% save nifti
[~,~,~] = mkdir('RESHARP_new');
nii = make_nii(lfs_resharp,voxel_size);
save_nii(nii,['RESHARP_new/lfs_resharp0_tik_', num2str(tik_reg), '_num_', num2str(cgs_num), '.nii']);

% % inversion of susceptibility 
% disp('--> TV susceptibility inversion on RESHARP...');
% sus_resharp = tvdi(lfs_resharp,mask_resharp,voxel_size,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 
% % save nifti
% nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
% save_nii(nii,['RESHARP/sus_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);

% iLSQR method
chi_iLSQR = QSM_iLSQR(lfs_resharp*(2.675e8*9.4)/1e6,mask_resharp,'H',z_prjs,'voxelsize',voxel_size,'niter',50,'TE',1000,'B0',9.4);
nii = make_nii(chi_iLSQR,voxel_size);
save_nii(nii,'RESHARP_new/chi_iLSQR0.nii');






[lfs_resharp, mask_resharp] = resharp(tfs,mask.*R,voxel_size,smv_rad,tik_reg,cgs_num);
% % 3D 2nd order polyfit to remove any residual background
% lfs_resharp= lfs_resharp - poly3d(lfs_resharp,mask_resharp);

% save nifti
[~,~,~] = mkdir('RESHARP');
nii = make_nii(lfs_resharp,voxel_size);
save_nii(nii,['RESHARP/lfs_resharp0_tik_', num2str(tik_reg), '_num_', num2str(cgs_num), '.nii']);

% % inversion of susceptibility 
% disp('--> TV susceptibility inversion on RESHARP...');
% sus_resharp = tvdi(lfs_resharp,mask_resharp,voxel_size,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 
% % save nifti
% nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
% save_nii(nii,['RESHARP/sus_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);

% iLSQR method
chi_iLSQR = QSM_iLSQR(lfs_resharp*(2.675e8*9.4)/1e6,mask_resharp,'H',z_prjs,'voxelsize',voxel_size,'niter',50,'TE',1000,'B0',9.4);
nii = make_nii(chi_iLSQR,voxel_size);
save_nii(nii,'RESHARP/chi_iLSQR0.nii');



% % MEDI
% %%%%% normalize signal intensity by noise to get SNR %%%
% %%%% Generate the Magnitude image %%%%
% iMag = sqrt(sum(mag.^2,4));
% matrix_size = single(imsize(1:3));
% voxel_size = voxel_size;
% delta_TE = TE(2) - TE(1);
% B0_dir = z_prjs';
% CF = 42.6036*9.4 *1e6;
% iFreq = [];
% N_std = 1;

% RDF = lfs_resharp*2.675e8*9.4*delta_TE*1e-6;
% Mask = mask_resharp;
% save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
%      voxel_size delta_TE CF B0_dir;
% QSM = MEDI_L1('lambda',10000);
% nii = make_nii(QSM.*Mask,voxel_size);
% save_nii(nii,['RESHARP/MEDI10000_RESHARP_smvrad' num2str(smv_rad) '.nii']);



% % V-SHARP + iLSQR
% B0 =9.4;
% voxelsize = voxel_size;
% padsize = [12 12 12];
% smvsize = 12;
% [TissuePhase3d, mask_vsharp] = V_SHARP(tfs ,single(mask.*R),'smvsize',smvsize,'voxelsize',voxelsize*10);
% nii = make_nii(TissuePhase3d,voxel_size);
% % save nifti
% [~,~,~] = mkdir('VSHARP');
% save_nii(nii,'VSHARP/VSHARP.nii');

% chi_iLSQR_0 = QSM_iLSQR(TissuePhase3d*(2.675e8*9.4)/1e6,mask_vsharp,'H',z_prjs,'voxelsize',voxel_size,'niter',50,'TE',1000,'B0',9.4);
% nii = make_nii(chi_iLSQR_0,voxel_size);
% save_nii(nii,'VSHARP/chi_iLSQR_0_vsharp.nii');




% % R2* recon
% cd ..
% mkdir r2star
% cd r2star
% [R2 T2 amp] = r2imgfit2(double(mag),TE,repmat(mask,[1 1 1 imsize(4)]));
% delete(gcp('nocreate'))
% nii = make_nii(R2,voxel_size);
% save_nii(nii,'R2.nii');
% nii = make_nii(T2,voxel_size);
% save_nii(nii,'T2.nii');
% nii = make_nii(amp,voxel_size);
% save_nii(nii,'amp.nii');

