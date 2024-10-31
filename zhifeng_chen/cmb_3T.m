% load('/Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_3T_TR72ms_TE36ms/img_pocs/pocs1/all.mat','mag','ph');
% cmp1 = mag.*exp(1j*ph);

% load('/Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_3T_TR72ms_TE36ms/img_pocs/pocs2/all.mat','mag','ph');
% cmp2 = mag.*exp(1j*ph);

% cmp_cmb = cmp1 + cmp2;

% mag = abs(cmp_cmb);
% ph = angle(cmp_cmb);

% mkdir /Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_3T_TR72ms_TE36ms/img_pocs/cmb
% cd /Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_3T_TR72ms_TE36ms/img_pocs/cmb



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('/Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_3T_TR72ms_TE36ms/img_buda/buda1/all.mat','mag','ph');
cmp1 = mag.*exp(1j*ph);

load('/Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_3T_TR72ms_TE36ms/img_buda/buda2/all.mat','mag','ph');
cmp2 = mag.*exp(1j*ph);

cmp_cmb = cmp1 + cmp2;

mag = abs(cmp_cmb);
ph = angle(cmp_cmb);

mkdir /Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_3T_TR72ms_TE36ms/img_buda/cmb
cd /Volumes/LaCie_Bottom/collaborators/Zhifeng_Chen/Recon_Results_3T_TR72ms_TE36ms/img_buda/cmb



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% acquisition parameters
TE = 0.036;
vox = [1 1 1];
B0 = 3;
z_prjs = [0 0 1];

EchoTime = 36;
MagneticFieldStrength = 3;


% phase unwrapping of img_buda
if ~ exist('options','var') || isempty(options)
options = [];
end
if ~ isfield(options,'bet_thr')
options.bet_thr = 0.1;
end
if ~ isfield(options,'bet_smooth')
options.bet_smooth = 2;
end
if ~ isfield(options,'ph_unwrap')
options.ph_unwrap = 'laplacian';
end
if ~ isfield(options,'bkg_rm')
options.bkg_rm = 'resharp';
end
if ~ isfield(options,'t_svd')
options.t_svd = 0.1;
end
if ~ isfield(options,'smv_rad')
options.smv_rad = 3;
end
if ~ isfield(options,'tik_reg')
options.tik_reg = 1e-3;
end
if ~ isfield(options,'cgs_num')
options.cgs_num = 500;
end
if ~ isfield(options,'lbv_tol')
options.lbv_tol = 0.01;
end
if ~ isfield(options,'lbv_peel')
options.lbv_peel = 2;
end
if ~ isfield(options,'tv_reg')
options.tv_reg = 5e-4;
end
if ~ isfield(options,'inv_num')
options.inv_num = 500;
end
bet_thr    = options.bet_thr;
bet_smooth = options.bet_smooth;
ph_unwrap  = options.ph_unwrap;
bkg_rm     = options.bkg_rm;
t_svd      = options.t_svd;
smv_rad    = options.smv_rad;
tik_reg    = options.tik_reg;
cgs_num    = options.cgs_num;
lbv_tol    = options.lbv_tol;
lbv_peel   = options.lbv_peel;
tv_reg     = options.tv_reg;
inv_num    = options.inv_num;
% save magnitude/phase in NIFTI form
mkdir('src');
nii = make_nii(mag,vox);
save_nii(nii,'src/mag.nii');
nii = make_nii(ph,vox);
save_nii(nii,'src/ph.nii');
% extract the brain and generate mask
setenv('bet_thr',num2str(bet_thr));
setenv('bet_smooth',num2str(bet_smooth));
[status,cmdout] = unix('rm BET*');
unix('bet2 src/mag.nii BET -f ${bet_thr} -m -w ${bet_smooth}');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);



% iQSM-plus
QSM = iQSM_plus(-ph, TE, 'mag', mag, 'mask', mask, 'voxel_size', vox, 'B0', B0, 'B0_dir', z_prjs, 'eroded_rad', 3, 'output_dir', 'iQSM_ero3');
QSM = iQSM_plus(-ph, TE, 'mag', mag, 'mask', mask, 'voxel_size', vox, 'B0', B0, 'B0_dir', z_prjs, 'eroded_rad', 0, 'output_dir', 'iQSM_ero0');
QSM = iQSM_plus(-ph, TE, 'mag', mag, 'voxel_size', vox, 'B0', B0, 'B0_dir', z_prjs, 'output_dir', 'iQSM_wholehead');




% conventional method below

imsize = size(ph);
% phase unwrapping, prelude is preferred!
if strcmpi('prelude',ph_unwrap)
    % unwrap phase with PRELUDE
    disp('--> unwrap aliasing phase ...');
    bash_script = ['prelude -a src/mag.nii -p src/ph.nii ' ...
        '-u unph.nii -m BET_mask.nii -n 8'];
    unix(bash_script);
    unix('gunzip -f unph.nii.gz');
    nii = load_nii('unph.nii');
    unph = double(nii.img);

elseif strcmpi('laplacian',ph_unwrap)
    % Ryan Topfer's Laplacian unwrapping
    Options.voxelSize = vox;
    unph = lapunwrap(ph, Options).*mask;
    nii = make_nii(unph, vox);
    save_nii(nii,'unph_lap.nii');

elseif strcmpi('bestpath',ph_unwrap)
    % unwrap the phase using best path
    [pathstr, ~, ~] = fileparts(which('3DSRNCP.m'));
    setenv('pathstr',pathstr);
    setenv('nv',num2str(imsize(1)));
    setenv('np',num2str(imsize(2)));
    setenv('ns',num2str(imsize(3)));

    fid = fopen('wrapped_phase.dat','w');
    fwrite(fid,ph,'float');
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
    unph = reshape(tmp - round(mean(tmp(mask==1))/(2*pi))*2*pi,imsize(1:3)).*mask;
    fclose(fid);

    nii = make_nii(unph,vox);
    save_nii(nii,'unph_bestpath.nii');

    fid = fopen('reliability.dat','r');
    reliability_raw = fread(fid,'float');
    reliability_raw = reshape(reliability_raw,imsize(1:3));
    fclose(fid);

    nii = make_nii(reliability_raw.*mask,vox);
    save_nii(nii,'reliability_raw.nii');

else
    error('what unwrapping methods to use? prelude or laplacian or bestpath?')
end


% normalize total field (tfs) to ppm unit
tfs = unph/(2.675e8*EchoTime*MagneticFieldStrength)*1e9; % unit ppm

nii = make_nii(tfs,vox);
save_nii(nii,'tfs.nii');


% background field removal

% RE-SHARP (tik_reg: Tikhonov regularization parameter)
if sum(strcmpi('resharp',bkg_rm))
    disp('--> RESHARP to remove background field ...');
    [lfs_resharp, mask_resharp] = resharp(tfs,mask,vox,smv_rad,tik_reg,cgs_num);
    % % 3D 2nd order polyfit to remove any residual background
    % lfs_resharp= poly3d(lfs_resharp,mask_resharp);

    % save nifti
    mkdir('RESHARP');
    nii = make_nii(lfs_resharp,vox);
    save_nii(nii,'RESHARP/lfs_resharp.nii');

    % % inversion of susceptibility 
    % disp('--> TV susceptibility inversion on RESHARP...');
    % sus_resharp = tvdi(lfs_resharp,mask_resharp,vox,tv_reg,mag,z_prjs,inv_num); 
   
    % % save nifti
    % nii = make_nii(sus_resharp.*mask_resharp,vox);
    % save_nii(nii,'RESHARP/sus_resharp.nii');

    % iLSQR
    chi_iLSQR = QSM_iLSQR(lfs_resharp*(2.675e8*MagneticFieldStrength)/1e6,mask_resharp,'H',z_prjs,'voxelsize',vox,'niter',50,'TE',1000,'B0',MagneticFieldStrength);
    nii = make_nii(chi_iLSQR,vox);
    save_nii(nii,['RESHARP/chi_iLSQR_smvrad' num2str(smv_rad) '.nii']);
    % 
    % % MEDI
    % %%%%% normalize signal intensity by noise to get SNR %%%
    % %%%% Generate the Magnitude image %%%%
    % iMag = sqrt(sum(mag.^2,4));
    % % [iFreq_raw N_std] = Fit_ppm_complex(ph_corr);
    % matrix_size = single(imsize(1:3));
    % voxel_size = vox;
    % delta_TE = TE(2) - TE(1);
    % B0_dir = z_prjs';
    % CF = dicom_info.ImagingFrequency *1e6;
    % iFreq = [];
    % N_std = 1;
    % RDF = lfs_resharp*2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6;
    % Mask = mask_resharp;
    % save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
    %      voxel_size delta_TE CF B0_dir;
    % QSM = MEDI_L1('lambda',1000);
    % nii = make_nii(QSM.*Mask,vox);
    % save_nii(nii,['RESHARP/MEDI1000_RESHARP_smvrad' num2str(smv_rad) '.nii']);
end


vars = who;
exclude = {'img_buda', 'img_hybrid_sense', 'img_pocs'};
vars_to_save = setdiff(vars, exclude);
save('all.mat', vars_to_save{:});
