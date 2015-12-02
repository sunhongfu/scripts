load all

img_corr = img;

% have a peak of the raw phase
nii = make_nii(angle(img_corr),voxelSize);
save_nii(nii,'rawphase.nii');


% combine receivers
if Pars.RCVRS_ > 1
    % combine RF coils
    disp('--> combine RF rcvrs ...');
    img_cmb = adaptive_cmb(img_corr,voxelSize,ref_coil,eig_rad);
else  % single channel  
    img_cmb = img_corr;
end

% save nifti
mkdir('combine');
nii = make_nii(abs(img_cmb),voxelSize);
save_nii(nii,'combine/mag_cmb.nii');
nii = make_nii(angle(img_cmb),voxelSize);
save_nii(nii,'combine/ph_cmb.nii');






! mv BET_mask.nii BET_mask_old.nii
! mv BET.nii BET_old.nii


clear mask
nii = load_nii('BET_mask_new2.nii');
mask = double(nii.img);
nii = make_nii(mask,voxelSize);
save_nii(nii,'BET_mask.nii');
nii = make_nii(abs(img_cmb).*mask,voxelSize);
save_nii(nii,'BET.nii');

ph_unwrap = 'bestpath';
tv_reg = 1e-3;
tik_reg = 1e-3;
inv_num = 500;
bkg_rm = {'resharp', 'esharp'};

% phase unwrapping, prelude is preferred!
if strcmpi('prelude',ph_unwrap)
    % unwrap combined phase with PRELUDE
    disp('--> unwrap aliasing phase using prelude...');
    bash_script = ['prelude -a combine/mag_cmb.nii -p combine/ph_cmb.nii ' ...
        '-u unph.nii -m BET_mask.nii -n 12'];
    unix(bash_script);
    unix('gunzip -f unph.nii.gz');
    nii = load_nii('unph.nii');
    unph = double(nii.img);

    % % unwrap with Laplacian based method (TianLiu's)
    % unph = unwrapLaplacian(angle(img_cmb), size(img_cmb), voxelSize);
    % nii = make_nii(unph, voxelSize);
    % save_nii(nii,'unph_lap.nii');

elseif strcmpi('laplacian',ph_unwrap)
    % Ryan Topfer's Laplacian unwrapping
    disp('--> unwrap aliasing phase using laplacian...');
    Options.voxelSize = voxelSize;
    unph = lapunwrap(angle(img_cmb), Options);
    nii = make_nii(unph, voxelSize);
    save_nii(nii,'unph_lap.nii');

elseif strcmpi('bestpath',ph_unwrap)
    % unwrap the phase using best path
    disp('--> unwrap aliasing phase using bestpath...');
    fid = fopen('wrapped_phase.dat','w');
    fwrite(fid,angle(img_cmb),'float');
    fclose(fid);
    % mask_unwrp = uint8(hemo_mask.*255);
    mask_unwrp = uint8(abs(mask)*255);
    fid = fopen('mask_unwrp.dat','w');
    fwrite(fid,mask_unwrp,'uchar');
    fclose(fid);

    unix('cp /home/hongfu/Documents/MATLAB/3DSRNCP 3DSRNCP');
    setenv('nv',num2str(nv));
    setenv('np',num2str(np));
    setenv('ns',num2str(ns));
    bash_script = ['./3DSRNCP wrapped_phase.dat mask_unwrp.dat ' ...
        'unwrapped_phase.dat $nv $np $ns reliability.dat'];
    unix(bash_script) ;

    fid = fopen('unwrapped_phase.dat','r');
    unph = fread(fid,'float');
    unph = reshape(unph - unph(1) ,[nv,np,ns]);
    fclose(fid);
    nii = make_nii(unph,voxelSize);
    save_nii(nii,'unph.nii');

    fid = fopen('reliability.dat','r');
    reliability_raw = fread(fid,'float');
    fclose(fid);
    reliability_raw = reshape(reliability_raw,[nv,np,ns]);
    reliability = mask;
    reliability(reliability_raw >= 20) = 0;
    % reliability(reliability > 0.1) = 1;
    nii = make_nii(reliability,voxelSize);
    save_nii(nii,'reliability.nii');
    weights = abs(img_cmb)./max(abs(img_cmb(:))).*mask.*reliability;
    weights = smooth3(weights,'gaussian',[7,7,3],1);
    % weights = smooth3(weights,'gaussian',[7,7,3],0.5);
    nii = make_nii(weights,voxelSize);
    save_nii(nii,'weights.nii');
else
    error('what unwrapping methods to use? prelude or laplacian or bestpath?')
end


% normalize to echo time and field strength
% ph = gamma*dB*TE
% dB/B = ph/(gamma*TE*B0)
% units: TE s, gamma 2.675e8 rad/(sT), B0 4.7T
% tfs = -unph_poly/(2.675e8*Pars.te*4.7)*1e6; % unit ppm
tfs = -unph/(2.675e8*Pars.te*4.7)*1e6; % unit ppm
nii = make_nii(tfs,voxelSize);
save_nii(nii,'tfs.nii');


if ~ exist('weights')
    weights = abs(img_cmb);
end

% PDF
if sum(strcmpi('pdf',bkg_rm))
    disp('--> PDF to remove background field ...');
    [lfs_pdf,mask_pdf] = pdf(tfs,mask,voxelSize,smv_rad, ...
        weights,z_prjs);
    % 3D 2nd order polyfit to remove any residual background
    % lfs_pdf= poly3d(lfs_pdf,mask_pdf);

    % save nifti
    mkdir('PDF');
    nii = make_nii(lfs_pdf,voxelSize);
    save_nii(nii,'PDF/lfs_pdf.nii');

    % inversion of susceptibility 
    disp('--> TV susceptibility inversion on PDF...');
    sus_pdf = tvdi(lfs_pdf, mask_pdf, voxelSize, tv_reg, ...
        weights, z_prjs, inv_num); 

    % save nifti
    nii = make_nii(sus_pdf.*mask_pdf,voxelSize);
    save_nii(nii,'PDF/sus_pdf.nii');
end


% SHARP (t_svd: truncation threthold for t_svd)
if sum(strcmpi('sharp',bkg_rm))
    disp('--> SHARP to remove background field ...');
    [lfs_sharp, mask_sharp] = sharp(tfs,mask,voxelSize,smv_rad,t_svd);
    % 3D 2nd order polyfit to remove any residual background
    % lfs_sharp= poly3d(lfs_sharp,mask_sharp);

    % save nifti
    mkdir('SHARP');
    nii = make_nii(lfs_sharp,voxelSize);
    save_nii(nii,'SHARP/lfs_sharp.nii');
    
    % inversion of susceptibility 
    disp('--> TV susceptibility inversion on SHARP...');
    sus_sharp = tvdi(lfs_sharp, mask_sharp, voxelSize, tv_reg, ...
        weights, z_prjs, inv_num); 
   
    % save nifti
    nii = make_nii(sus_sharp.*mask_sharp,voxelSize);
    save_nii(nii,'SHARP/sus_sharp.nii');
end


% RE-SHARP (tik_reg: Tikhonov regularization parameter)
if sum(strcmpi('resharp',bkg_rm))
    disp('--> RESHARP to remove background field ...');
    [lfs_resharp, mask_resharp] = resharp(tfs,mask,voxelSize,smv_rad,tik_reg);
    % 3D 2nd order polyfit to remove any residual background
    % lfs_resharp= poly3d(lfs_resharp,mask_resharp);

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
    % Parameters.radius                = [ 10 10 5 ] ;

% pad matrix size to even number
    pad_size = mod(size(tfs),2);
    tfs = padarray(tfs, pad_size, 'post');
    mask = padarray(mask, pad_size, 'post');

    % taking off additional 3 voxels from edge - not sure the outermost 
    % phase data included in the original mask is reliable. 
    tfs        = tfs .* mask;
    mask       = double(shaver( ( tfs ~= 0 ), 1 )) ; % 1 voxel taken off
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
    % lfs_esharp = poly3d(lfs_esharp,mask_esharp);

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


% LBV
if sum(strcmpi('lbv',bkg_rm))
    disp('--> LBV to remove background field ...');
    lfs_lbv = LBV(tfs,mask,size(tfs),voxelSize,0.01,lbv_layer); % strip 2 layers
    mask_lbv = ones(size(mask));
    mask_lbv(lfs_lbv==0) = 0;
    % 3D 2nd order polyfit to remove any residual background
    lfs_lbv= poly3d(lfs_lbv,mask_lbv);

    % save nifti
    mkdir('LBV');
    nii = make_nii(lfs_lbv,voxelSize);
    save_nii(nii,'LBV/lfs_lbv.nii');

    % inversion of susceptibility 
    disp('--> TV susceptibility inversion on lbv...');
    sus_lbv = tvdi(lfs_lbv,mask_lbv,voxelSize,tv_reg, ...
        weights,z_prjs,inv_num);   

    % save nifti
    nii = make_nii(sus_lbv.*mask_lbv,voxelSize);
    save_nii(nii,'LBV/sus_lbv.nii');
end


% clean the directory
if clean_all
    disp('--> clean temp nifti files ...');
    unix('ls | grep -v "combine\|RESHARP" | xargs rm -rf');
else
    % save all variables for future reference
    clear nii;
    disp('--> save the entire workspace ...');
    save('all.mat','-v7.3');
end

% save parameters used in the recon
save('parameters.mat','options','-v7.3')

% go back to the initial directory
cd(init_dir);
