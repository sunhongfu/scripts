NUM_RUNS = 65;
voxelSize = [1.5 1.5 2];
% voxelSize = [3 3 3];
% voxelSize = [2 2 2];

bash_script = ['bet meanmag_all.nii BET001 -f 0.35 -m'];
unix('rm -rf BET*');
unix(bash_script);


% repeat the mask
unix('gunzip -f BET001.nii.gz');
unix('gunzip -f BET001_mask.nii.gz');

mask = load_nii('BET001_mask.nii');
mask = double(mask.img);

mask_rep = repmat(mask,[1 1 1 NUM_RUNS]);
nii = make_nii(mask_rep,voxelSize);
save_nii(nii,'mask_rep.nii');

m=[voxelSize(1) 0 0 0; 0 voxelSize(2) 0 0; 0 0 voxelSize(3) 0; 0 0 0 1];
load sus_all
for i = 2:size(mat,3)
	% mat(:,:,i) = inv(inv(m)*mat(:,:,i))*m;
		mat(:,:,i) = m*inv(mat(:,:,i))*m;
end
save('mask_rep.mat','mat');


P = spm_select('ExtList', pwd, '^mask_rep.nii',1:200);
flags.mask=0;
spm_reslice(P,flags);

nii = load_nii('rmask_rep.nii');
rmask = nii.img;

cd ..
cd QSM_EPI47_v1
! rm BET*
load all
mask_all = flipdim(permute(rmask,[2 1 3 4]),3);
mask_all = uint16(mask_all);
nii = make_nii(mask_all,voxelSize);
save_nii(nii,'mask_all.nii');



% process QSM on individual run volume
for i = 1:size(img_all,4) % all time series
	img_cmb = img_cmb_all(:,:,:,i);

	nii = make_nii(mask_all(:,:,:,i),voxelSize);
	save_nii(nii,['BET' num2str(i,'%03i') '_mask.nii']);
	mask = double(mask_all(:,:,:,i));

	% unwrap the phase
	if strcmpi('prelude',ph_unwrap)
	    % unwrap combined phase with PRELUDE
	    disp('--> unwrap aliasing phase ...');
	    setenv('time_series',num2str(i,'%03i'));
	    bash_script = ['prelude -a combine/mag_cmb${time_series}.nii ' ...
	        '-p combine/ph_cmcurb${time_series}.nii -u unph${time_series}.nii ' ...
	        '-m BET${time_series}_mask.nii -n 8'];
	    unix(bash_script);
	    unix('gunzip -f unph${time_series}.nii.gz');
	    nii = load_nii(['unph' num2str(i,'%03i') '.nii']);
	    unph = double(nii.img);

	elseif strcmpi('laplacian',ph_unwrap)
		% Ryan Topfer's Laplacian unwrapping
	    disp('--> unwrap aliasing phase using laplacian...');
	    Options.voxelSize = voxelSize;
		unph = lapunwrap(angle(img_cmb), Options);
		nii = make_nii(unph, voxelSize);
		save_nii(nii,['unph_lap' num2str(i,'%03i') '.nii']);

	end


	% normalize to ppm unit
	tfs = -unph/(2.675e8*par.te*4.7)*1e6; % unit ppm
	nii = make_nii(tfs,voxelSize);
	save_nii(nii,'tfs.nii');


	% intrinsic euler angles 
	% z-x-z convention, psi first, then theta, lastly phi
	% psi and theta are left-handed, while gamma is right-handed!
	% alpha = - par.psi/180*pi;
	beta = - par.theta/180*pi;
	gamma =  par.phi/180*pi;
	z_prjs = [sin(beta)*sin(gamma), sin(beta)*cos(gamma), cos(beta)];
	if ~ isequal(z_prjs,[0 0 1])
		disp('This is angled slicing');
		disp(z_prjs);
	end




	% RE-SHARP (tik_reg: Tikhonov regularization parameter)
	if sum(strcmpi('resharp',bkg_rm))
	    disp('--> RESHARP to remove background field ...');
	    [lfs_resharp, mask_resharp] = resharp(tfs,mask,voxelSize,smv_rad,tik_reg);
	    % 3D 2nd order polyfit to remove any residual background
	    lfs_resharp= poly2d(lfs_resharp,mask_resharp);

	    % save nifti
	    mkdir('RESHARP');
	    nii = make_nii(lfs_resharp,voxelSize);
	    save_nii(nii,['RESHARP/lfs_resharp' num2str(i,'%03i') '.nii']);

	    % inversion of susceptibility 
	    disp('--> TV susceptibility inversion on RESHARP...');
	    sus_resharp = tvdi(lfs_resharp, mask_resharp, voxelSize, tv_reg, ...
	        abs(img_cmb), z_prjs, inv_num); 
	   
	    % save nifti
	    nii = make_nii(sus_resharp.*mask_resharp,voxelSize);
	    save_nii(nii,['RESHARP/sus_resharp' num2str(i,'%03i') '.nii']);

	    if save_all
			lfs_resharp_all(:,:,:,i) = lfs_resharp;
			mask_resharp_all(:,:,:,i) = mask_resharp;
			sus_resharp_all(:,:,:,i) = sus_resharp;
		end
	end


	% LBV
	if sum(strcmpi('lbv',bkg_rm))
	    disp('--> LBV to remove background field ...');
	    lfs_lbv = LBV(tfs,mask,size(tfs),voxelSize,0.01,lbv_layer); % strip 2 layers
	    mask_lbv = ones(size(mask));
	    mask_lbv(lfs_lbv==0) = 0;
	    % 3D 2nd order polyfit to remove any residual background
	    lfs_lbv= poly2d(lfs_lbv,mask_lbv);

	    % save nifti
	    mkdir('LBV');
	    nii = make_nii(lfs_lbv,voxelSize);
	    save_nii(nii,['LBV/lfs_lbv' num2str(i,'%03i') '.nii']);

	    % inversion of susceptibility 
	    disp('--> TV susceptibility inversion on lbv...');
	    sus_lbv = tvdi(lfs_lbv,mask_lbv,voxelSize,tv_reg, ...
	        abs(img_cmb),z_prjs,inv_num);   

	    % save nifti
	    nii = make_nii(sus_lbv.*mask_lbv,voxelSize);
	    save_nii(nii,['LBV/sus_lbv' num2str(i,'%03i') '.nii']);

	    if save_all
			lfs_lbv_all(:,:,:,i) = lfs_lbv;
			mask_lbv_all(:,:,:,i) = mask_lbv;
			sus_lbv_all(:,:,:,i) = sus_lbv;
		end
	end

end