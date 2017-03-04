NUM_RUNS = 108;
voxelSize = [4 4 4];
% NUM_RUNS = 104;
% voxelSize = [3 3 3];
% NUM_RUNS = 114;
% voxelSize = [2 2 2];

bash_script = ['bet meanmag_all.nii BET001 -f 0.5 -m'];
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
QSM_dir = strtrim(ls('QSM*','-d'));
cd(QSM_dir)
! rm BET*
load all
mask_all = flipdim(flipdim(rmask,1),2);
mask_all = uint16(mask_all);
nii = make_nii(mask_all,voxelSize);
save_nii(nii,'mask_all.nii');



% process QSM on individual run volume
for i = 1:size(img_all,5) % all time series
  % img_cmb = squeeze(img_all(:,:,:,:,i));
  img_cmb = img_cmb_all(:,:,:,i);

 
	nii = make_nii(mask_all(:,:,:,i),voxelSize);
	save_nii(nii,['BET' num2str(i,'%03i') '_mask.nii']);
	mask = double(mask_all(:,:,:,i));


    % unwrap the phase
    % if strcmpi('prelude',ph_unwrap)
        % unwrap combined phase with PRELUDE
        disp('--> unwrap aliasing phase using prelude...');
        setenv('time_series',num2str(i,'%03i'));
        bash_script = ['prelude -a combine/mag_cmb${time_series}.nii ' ...
            '-p combine/ph_cmb${time_series}.nii -u unph${time_series}.nii ' ...
            '-m BET${time_series}_mask.nii -n 8'];
        unix(bash_script);
        unix('gunzip -f unph${time_series}.nii.gz');
        nii = load_nii(['unph' num2str(i,'%03i') '.nii']);
        unph = double(nii.img);



    % background field removal
    disp('--> RESHARP to remove background field ...');
    mkdir('RESHARP');
    [lph_resharp,mask_resharp] = resharp(unph,mask,voxelSize,smv_rad,tik_reg);

    % normalize to ppm unit
    TE = params.protocol_header.alTE{1}/1e6;
    B_0 = params.protocol_header.m_flMagneticFieldStrength;
    gamma = 2.675222e8;
    lfs_resharp = lph_resharp/(gamma*TE*B_0)*1e6; % unit ppm

    nii = make_nii(lfs_resharp,voxelSize);
    save_nii(nii,['RESHARP/lfs_resharp_poly' num2str(i,'%03i') '.nii']);



    disp('--> TV susceptibility inversion ...');
    sus_resharp = tvdi(lfs_resharp,mask_resharp,voxelSize,tv_reg,abs(img_cmb), ...
        z_prjs,inv_num);
    nii = make_nii(sus_resharp.*mask_resharp,voxelSize);
    save_nii(nii,['RESHARP/sus_resharp' num2str(i,'%03i') '.nii']);



end

