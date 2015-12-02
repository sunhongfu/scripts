load all.mat
bkg_rm={'resharp','esharp'};
tik_reg=1e-3;
tv_reg=1e-3;

nii = load_nii('Control005_JCB2_20111116.nii');
mask = double(nii.img);

mkdir('newmask');
cd('newmask');


% unwrap the phase using best path
[pathstr, ~, ~] = fileparts(which('3DSRNCP.m'));
setenv('pathstr',pathstr);
setenv('nv',num2str(nv));
setenv('np',num2str(np));
setenv('ns',num2str(ns));

fid = fopen('wrapped_phase.dat','w');
fwrite(fid,angle(img_cmb),'float');
fclose(fid);
mask_unwrp = uint8(abs(mask)*255);
fid = fopen('mask_unwrp.dat','w');
fwrite(fid,mask_unwrp,'uchar');
fclose(fid);

bash_script = ['${pathstr}/3DSRNCP wrapped_phase.dat mask_unwrp.dat unwrapped_phase.dat ' ...
    '$nv $np $ns reliability.dat'];
unix(bash_script);

fid = fopen('unwrapped_phase.dat','r');
tmp = fread(fid,'float');
unph = reshape(tmp - round(mean(tmp(mask==1))/(2*pi))*2*pi,[nv,np,ns]).*mask;
fclose(fid);

nii = make_nii(unph,voxelSize);
save_nii(nii,'unph_bestpath.nii');

% fid = fopen('reliability.dat','r');
% reliability_raw = fread(fid,'float');
% reliability_raw = reshape(reliability_raw,[nv,np,ns]);
% fclose(fid);

% nii = make_nii(reliability_raw.*mask,voxelSize);
% save_nii(nii,'reliability_raw.nii');


% normalize to echo time and field strength
% ph = gamma*dB*TE
% dB/B = ph/(gamma*TE*B0)
% units: TE s, gamma 2.675e8 rad/(sT), B0 4.7T
% tfs = -unph_poly/(2.675e8*Pars.te*4.7)*1e6; % unit ppm
tfs = -unph/(2.675e8*Pars.te*4.7)*1e6; % unit ppm
nii = make_nii(tfs,voxelSize);
save_nii(nii,'tfs.nii');


% weights
weights = abs(img_cmb);

% RE-SHARP (tik_reg: Tikhonov regularization parameter)
if sum(strcmpi('resharp',bkg_rm))
    disp('--> RESHARP to remove background field ...');
    [lfs_resharp, mask_resharp] = resharp(tfs,mask,voxelSize,smv_rad,tik_reg);
    % 3D 2nd order polyfit to remove any residual background
    lfs_resharp= poly3d(lfs_resharp,mask_resharp);

    % save nifti
    mkdir('RESHARP');
    nii = make_nii(lfs_resharp,voxelSize);
    save_nii(nii,'RESHARP/lfs_resharp.nii');

    % inversion of susceptibility 
    disp('--> TV susceptibility inversion on RESHARP...');
    sus_resharp = tvdi(lfs_resharp, mask_resharp, voxelSize, tv_reg, ...
        weights, z_prjs, inv_num); 
   
    % save nifti
    nii = make_nii(sus_resharp.*mask_resharp,voxelSize);
    save_nii(nii,'RESHARP/sus_resharp.nii');
end


% E-SHARP (SHARP edge extension)
if sum(strcmpi('esharp',bkg_rm))
    disp('--> E-SHARP to remove background field ...');
    Parameters.voxelSize             = voxelSize; % in mm
    Parameters.resharpRegularization = tik_reg ;
    Parameters.resharpKernelRadius   = smv_rad ; % in mm
    Parameters.radius                = [ 10 10 5 ] ;

% pad matrix size to even number
    pad_size = mod(size(tfs),2);
    tfs = padarray(tfs, pad_size, 'post');
    mask = padarray(mask, pad_size, 'post');

    % taking off additional 3 voxels from edge - not sure the outermost 
    % phase data included in the original mask is reliable. 
    tfs        = tfs .* mask;
    mask       = shaver( ( tfs ~= 0 ), 3) ; % 3 voxels taken off
    totalField = mask .* tfs ;

    % resharp 
    [reducedLocalField, maskReduced] = ...
        resharp( totalField, ...
                 double(mask), ...
                 Parameters.voxelSize, ...
                 Parameters.resharpKernelRadius, ...
                 Parameters.resharpRegularization ) ;

    % extrapolation ~ esharp 
    reducedBackgroundField = maskReduced .* ( totalField - reducedLocalField) ;

    extendedBackgroundField = extendharmonicfield( ...
       reducedBackgroundField, mask, maskReduced, Parameters) ;

    backgroundField = extendedBackgroundField + reducedBackgroundField ;
    localField      = totalField - backgroundField ;

    lfs_esharp      = localField(1+pad_size(1):end,1+pad_size(2):end,1+pad_size(3):end);
    mask_esharp     = mask(1+pad_size(1):end,1+pad_size(2):end,1+pad_size(3):end);  

    % 3D 2nd order polyfit to remove any residual background
    lfs_esharp = poly3d(lfs_esharp,mask_esharp);

    % save nifti
    mkdir('ESHARP');
    nii = make_nii(lfs_esharp,voxelSize);
    save_nii(nii,'ESHARP/lfs_esharp.nii');

    % inversion of susceptibility 
    disp('--> TV susceptibility inversion on ESHARP...');
    sus_esharp = tvdi(lfs_esharp, mask_esharp, voxelSize, tv_reg, ...
        weights, z_prjs, inv_num); 
   
    % save nifti
    nii = make_nii(sus_esharp.*mask_esharp,voxelSize);
    save_nii(nii,'ESHARP/sus_esharp.nii');
end
