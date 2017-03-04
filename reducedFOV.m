% reduced FOV

% cover the deep grey matter regions
% from slice 40 to 85
% truncate on the total field map
tfs_backup = tfs;
mask_backup = mask;
mag_backup = mag;
R_backup = R;
tfs = tfs(:,:,52:72);
mask = mask(:,:,52:72);
mag = mag(:,:,52:72,:);
R = R(:,:,52:72,:);

imsize = size(tfs);

% (1) perform RESHARP + TVDI
    disp('--> RESHARP to remove background field ...');
    [lfs_resharp, mask_resharp] = resharp(tfs,mask,vox,smv_rad,tik_reg,cgs_num);
    % % 3D 2nd order polyfit to remove any residual background
    % lfs_resharp= lfs_resharp - poly3d(lfs_resharp,mask_resharp);

    % save nifti
    [status,message,messageid] = mkdir('RESHARP');
    nii = make_nii(lfs_resharp,vox);
    save_nii(nii,['RESHARP/lfs_trunc_resharp_tik_', num2str(tik_reg), '_num_', num2str(cgs_num), '.nii']);

% (i)
    % inversion of susceptibility 
    disp('--> TV susceptibility inversion on RESHARP...');
    sus_resharp = tvdi(lfs_resharp,mask_resharp,vox,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 
   
    % save nifti
    nii = make_nii(sus_resharp.*mask_resharp,vox);
    save_nii(nii,['RESHARP/sus_trunc_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);

% (ii)
	% pad 20 slices before inversion
	lfs_resharp_pad = padarray(lfs_resharp,[0 0 20]);
	mask_resharp_pad = padarray(mask_resharp,[0 0 20]);
	mag_pad = padarray(mag,[0 0 20 0]);

	disp('--> TV susceptibility inversion on RESHARP...');
    sus_resharp_pad = tvdi(lfs_resharp_pad,mask_resharp_pad,vox,tv_reg,mag_pad(:,:,:,end),z_prjs,inv_num); 
   
    % save nifti
    nii = make_nii(sus_resharp_pad.*mask_resharp_pad,vox);
    save_nii(nii,['RESHARP/sus_trunc_pad20_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);



% (2) perform PDF + TVDI
    disp('--> PDF to remove background field ...');
    lfs_pdf = projectionontodipolefields(tfs,mask,vox,mag(:,:,:,end),z_prjs);
    % 3D 2nd order polyfit to remove any residual background
    % lfs_pdf= lfs_pdf - poly3d(lfs_pdf,mask_pdf);

    % save nifti
    [status,message,messageid] = mkdir('PDF');
    nii = make_nii(lfs_pdf,vox);
    save_nii(nii,'PDF/lfs_trunc_pdf.nii');

% (i)
    % inversion of susceptibility 
    disp('--> TV susceptibility inversion on PDF...');
    sus_pdf = tvdi(lfs_pdf,mask,vox,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 

    % save nifti
    nii = make_nii(sus_pdf.*mask,vox);
    save_nii(nii,['PDF/sus_trunc_pdf_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);

% (ii)
	% pad 20 slices before inversion
	lfs_pdf_pad = padarray(lfs_pdf,[0 0 20]);
	mask_pad = padarray(mask,[0 0 20]);
	mag_pad = padarray(mag,[0 0 20 0]);

	disp('--> TV susceptibility inversion on PDF...');
    sus_pdf_pad = tvdi(lfs_pdf_pad,mask_pad,vox,tv_reg,mag_pad(:,:,:,end),z_prjs,inv_num); 

    % save nifti
    nii = make_nii(sus_pdf_pad.*mask_pad,vox);
    save_nii(nii,['PDF/sus_trunc_pad20_pdf_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);



% (3) perform LBV + TVDI
   disp('--> LBV to remove background field ...');
   
  % add zero slices
  tfs_pad = padarray(tfs,[0 0 20]);
  mask_pad = padarray(mask,[0 0 20]);

   lfs_lbv = LBV(tfs_pad,mask_pad,size(tfs_pad),vox,lbv_tol,0); % strip 1 layers
   lfs_lbv = lfs_lbv(:,:,21:end-20);
   mask_lbv = ones(size(lfs_lbv));
   mask_lbv(lfs_lbv==0) = 0;
   % 3D 2nd order polyfit to remove any residual background
   % lfs_lbv= lfs_lbv - poly3d(lfs_lbv,mask_lbv);

   % save nifti
   [status,message,messageid] = mkdir('LBV');
   nii = make_nii(lfs_lbv,vox);
   save_nii(nii,'LBV/lfs_trunc_lbv.nii');

% (i) 
   % inversion of susceptibility 
   disp('--> TV susceptibility inversion on lbv...');
   sus_lbv = tvdi(lfs_lbv,mask_lbv,vox,tv_reg,mag(:,:,:,end),z_prjs,inv_num);   

   % save nifti
   nii = make_nii(sus_lbv.*mask_lbv,vox);
   save_nii(nii,['LBV/sus_trunc_lbv_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);

% (ii)
   % pad 20 zeros before inversion
   lfs_lbv_pad = padarray(lfs_lbv,[0 0 20]);
   mask_lbv_pad = padarray(mask_lbv,[0 0 20]);
   mag_pad = padarray(mag,[0 0 20 0]);
   
   disp('--> TV susceptibility inversion on lbv...');
   sus_lbv_pad = tvdi(lfs_lbv_pad,mask_lbv_pad,vox,tv_reg,mag_pad(:,:,:,end),z_prjs,inv_num);   

   % save nifti
   nii = make_nii(sus_lbv_pad.*mask_lbv_pad,vox);
   save_nii(nii,['LBV/sus_trunc_pad20_lbv_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);




% (4) perform Tik-QSM
% try different padding size

% pad zeros
tfs = padarray(tfs,[0 0 20]);
mask = padarray(mask,[0 0 20]);
R = padarray(R,[0 0 20]);

for r = [1 2 3] 

    [X,Y,Z] = ndgrid(-r:r,-r:r,-r:r);
    h = (X.^2/r^2 + Y.^2/r^2 + Z.^2/r^2 <= 1);
    ker = h/sum(h(:));
    imsize = size(mask);
    mask_tmp = convn(mask,ker,'same');
    mask_ero = zeros(imsize);
    mask_ero(mask_tmp > 1-1/sum(h(:))) = 1; % no error tolerance

    % try total field inversion on regular mask, regular prelude
    Tik_weight = 0.002;
    TV_weight = 0.005;
    [chi, res] = tikhonov_qsm(tfs, mask_ero, 1, mask_ero, mask_ero, TV_weight, Tik_weight, vox, z_prjs, 2000);
    nii = make_nii(chi(:,:,21:end-20).*mask_ero(:,:,21:end-20),vox);
    save_nii(nii,['chi_brain_smaller__pad20_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight) '_2000.nii']);

end

