! mv BET_mask.nii BET_mask_old.nii
! mv BET.nii BET_old.nii

clear mask
nii = load_nii('BET_mask_new.nii');
mask = double(nii.img);
nii = make_nii(mask,voxelSize);
save_nii(nii,'BET_mask.nii');
nii = make_nii(abs(img_cmb(:,:,:,1)).*mask,voxelSize);
save_nii(nii,'BET.nii');

% combine phase using double-echo method
% always use geme_cmb even for only 1 receiver
% this function can properly remove offset
% if par.nrcvrs > 1
    ph_cmb = geme_cmb(img,voxelSize,te);
% else
%     ph_cmb = angle(img);
% end


% save niftis after coil combination
for echo = 1:size(ph_cmb,4)
    nii = make_nii(ph_cmb(:,:,:,echo),voxelSize);
    save_nii(nii,['combine/ph_cmb' num2str(echo) '.nii']);
end

img_cmb = mag_cmb.*exp(1j.*ph_cmb);
clear mag_cmb ph_cmb


% keep only the first 'echo_num' echoes
echo_num = 3;
img_cmb = img_cmb(:,:,:,1:echo_num);
ne = echo_num;
te = par.te + (0:ne-1)*par.esp;


% unwrap phase from each echo
disp('--> unwrap aliasing phase for all TEs using prelude...');

setenv('echo_num',num2str(echo_num));
bash_command = sprintf(['for ph in combine/ph_cmb[1-$echo_num].nii\n' ...
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

unph_cmb = zeros(nv,np,nv2,ne);
for echo = 1:ne
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

for echo = 2:ne
    meandiff = unph_cmb(:,:,:,echo)-unph_cmb(:,:,:,1)-(echo-1)*unph_diff;
    meandiff = meandiff(mask==1);
    meandiff = mean(meandiff(:))
    njump = round(meandiff/(2*pi))
    disp(['    ' num2str(njump) ' 2pi jumps for TE' num2str(echo)]);
    unph_cmb(:,:,:,echo) = unph_cmb(:,:,:,echo) - njump*2*pi;
    unph_cmb(:,:,:,echo) = unph_cmb(:,:,:,echo).*mask;
end


% fit phase images with echo times
disp('--> magnitude weighted LS fit of phase to TE ...');
[tfs, fit_residual] = echofit(unph_cmb,abs(img_cmb),te); 

% normalize to main field
% ph = gamma*dB*TE
% dB/B = ph/(gamma*TE*B0)
% units: TE s, gamma 2.675e8 rad/(sT), B0 4.7T
tfs = -tfs/(2.675e8*4.7)*1e6; % unit ppm


if r_mask
    % generate reliability map
    fit_residual_blur = smooth3(fit_residual,'box',round(smv_rad./voxelSize/2)*2+1); 
    nii = make_nii(fit_residual_blur,voxelSize);
    save_nii(nii,'fit_residual_blur.nii');
    R = ones(size(fit_residual_blur));
    R(fit_residual_blur >= fit_thr) = 0;
else
    R = 1;
end

tik_reg = 1e-3;
tv_reg = 8e-4;
inv_num = 500;
bkg_rm = {'resharp', 'esharp'};


% PDF
if sum(strcmpi('pdf',bkg_rm))
    disp('--> PDF to remove background field ...');
    [lfs_pdf,mask_pdf] = pdf(tfs,mask.*R,voxelSize,smv_rad, ...
        abs(img_cmb(:,:,:,end)),z_prjs);
    % % 3D 2nd order polyfit to remove any residual background
    % lfs_pdf= poly3d(lfs_pdf,mask_pdf);

    % save nifti
    mkdir('PDF');
    nii = make_nii(lfs_pdf,voxelSize);
    save_nii(nii,'PDF/lfs_pdf.nii');

    % inversion of susceptibility 
    disp('--> TV susceptibility inversion on PDF...');
    sus_pdf = tvdi(lfs_pdf, mask_pdf, voxelSize, tv_reg, ...
        abs(img_cmb(:,:,:,echo_num)), z_prjs, inv_num); 

    % save nifti
    nii = make_nii(sus_pdf.*mask_pdf,voxelSize);
    save_nii(nii,'PDF/sus_pdf.nii');
end


% SHARP (t_svd: truncation threthold for t_svd)
if sum(strcmpi('sharp',bkg_rm))
    disp('--> SHARP to remove background field ...');
    [lfs_sharp, mask_sharp] = sharp(tfs,mask.*R,voxelSize,smv_rad,t_svd);
    % % 3D 2nd order polyfit to remove any residual background
    % lfs_sharp= poly3d(lfs_sharp,mask_sharp);

    % save nifti
    mkdir('SHARP');
    nii = make_nii(lfs_sharp,voxelSize);
    save_nii(nii,'SHARP/lfs_sharp.nii');
    
    % inversion of susceptibility 
    disp('--> TV susceptibility inversion on SHARP...');
    sus_sharp = tvdi(lfs_sharp, mask_sharp, voxelSize, tv_reg, ...
        abs(img_cmb(:,:,:,echo_num)), z_prjs, inv_num); 
   
    % save nifti
    nii = make_nii(sus_sharp.*mask_sharp,voxelSize);
    save_nii(nii,'SHARP/sus_sharp.nii');
end


% RE-SHARP (tik_reg: Tikhonov regularization parameter)
if sum(strcmpi('resharp',bkg_rm))
    disp('--> RESHARP to remove background field ...');
    [lfs_resharp, mask_resharp] = resharp(tfs,mask.*R,voxelSize,smv_rad,tik_reg);


    % save nifti
    mkdir('RESHARP');
    nii = make_nii(lfs_resharp,voxelSize);
    save_nii(nii,'RESHARP/lfs_resharp.nii');


    % inversion of susceptibility 
    disp('--> TV susceptibility inversion on RESHARP...');
    sus_resharp = tvdi(lfs_resharp, mask_resharp, voxelSize, tv_reg, ...
        abs(img_cmb(:,:,:,echo_num)), z_prjs, inv_num); 
   

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
    tfs = double(padarray(tfs, pad_size, 'post'));
    mask = double(padarray(mask, pad_size, 'post'));

    % taking off additional 3 voxels from edge - not sure the outermost 
    % phase data included in the original mask is reliable. 
    tfs        = tfs .* mask;
    mask       = shaver( ( tfs ~= 0 ), 1 ) ; % 1 voxel taken off
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

    % save nifti
    mkdir('ESHARP');
    nii = make_nii(lfs_esharp,voxelSize);
    save_nii(nii,'ESHARP/lfs_esharp.nii');

    % inversion of susceptibility 
    disp('--> TV susceptibility inversion on ESHARP...');
    sus_esharp = tvdi(lfs_esharp, mask_esharp, voxelSize, tv_reg, ...
        abs(img_cmb(:,:,:,echo_num)), z_prjs, inv_num);

    % save nifti
    nii = make_nii(sus_esharp.*mask_esharp,voxelSize);
    save_nii(nii,'ESHARP/sus_esharp.nii');
end




% LBV
if sum(strcmpi('lbv',bkg_rm))
    disp('--> LBV to remove background field ...');
    lfs_lbv = LBV(tfs,mask.*R,size(tfs),voxelSize,0.01,2); % strip 2 layers
    mask_lbv = ones(size(mask));
    mask_lbv(lfs_lbv==0) = 0;
    % % 3D 2nd order polyfit to remove phase-offset
    % lfs_lbv= poly3d(lfs_lbv,mask_lbv);


    % save nifti
    mkdir('LBV');
    nii = make_nii(lfs_lbv,voxelSize);
    save_nii(nii,'LBV/lfs_lbv.nii');


    % inversion of susceptibility 
    disp('--> TV susceptibility inversion on lbv...');
    sus_lbv = tvdi(lfs_lbv,mask_lbv,voxelSize,tv_reg, ...
        abs(img_cmb(:,:,:,echo_num)),z_prjs,inv_num);   

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


