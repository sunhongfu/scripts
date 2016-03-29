% function qsm_swi15(meas_in, path_out, options)
%QSM_SWI15 Quantitative susceptibility mapping from SWI sequence at 1.5T.
%   QSM_SWI15(MEAS_IN, PATH_OUT, OPTIONS) reconstructs susceptibility maps.
%
%   Re-define the following default settings if necessary
%
%   MEAS_IN     - filename or directory of meas file(.out)  : *.out
%   PATH_OUT    - directory to save nifti and/or matrixes   : QSM_SWI15
%   OPTIONS     - parameter structure including fields below
%    .ref_coil  - reference coil to use for phase combine   : 1
%    .eig_rad   - radius (mm) of eig decomp kernel          : 5
%    .bet_thr   - threshold for BET brain mask              : 0.4
%    .ph_unwrap - 'prelude' or 'laplacian' or 'bestpath'    : 'prelude'
%    .bkg_rm    - background field removal method(s)        : 'resharp'
%    .smv_rad   - radius (mm) of SMV convolution kernel     : 5
%    .tik_reg   - Tikhonov regularization for RESHARP       : 5e-4
%    .t_svd     - truncation of SVD for SHARP               : 0.05
%    .lbv_layer - number of layers to be stripped off LBV   : 2
%    .tv_reg    - Total variation regularization parameter  : 0.0005
%    .inv_num   - iteration number of TVDI (nlcg)           : 500
%    .save_all  - save the entire workspace/variables       : 1


% default settings
if ~ exist('meas_in','var') || isempty(meas_in)
	listing = dir([pwd '/*.out']);
    if ~isempty(listing)
        filename = listing(1).name;
        pathstr = pwd;
    else
        error('cannot find meas file');
    end
elseif exist(meas_in,'dir')
    listing = dir([meas_in '/*.out']);
    if ~isempty(listing)
        pathstr = cd(cd(meas_in));
        filename = listing(1).name;
    else
        error('cannot find meas file');
    end
elseif exist(meas_in,'file')
    [pathstr,name,ext] = fileparts(meas_in);
    if isempty(pathstr)
        pathstr = pwd;
    end
    pathstr = cd(cd(pathstr));
    filename = [name ext];
else
    error('cannot find meas file');
end

if ~ exist('path_out','var') || isempty(path_out)
    path_out = pathstr;
end

if ~ exist('options','var') || isempty(options)
    options = [];
end

if ~ isfield(options,'ref_coil')
    options.ref_coil = 1;
end

if ~ isfield(options,'eig_rad')
    options.eig_rad = 5;
end

if ~ isfield(options,'bet_smooth')
    options.bet_smooth = 3;
end

if ~ isfield(options,'bet_thr')
    options.bet_thr = 0.4;
end

if ~ isfield(options,'ph_unwrap')
    options.ph_unwrap = 'bestpath';
    % other options are 'prelude' and 'laplacian'
end

if ~ isfield(options,'bkg_rm')
    options.bkg_rm = {'lbv'};
    % options.bkg_rm = {'pdf','sharp','resharp','lbv'};
end

if ~ isfield(options,'t_svd')
    options.t_svd = 0.05;
end

if ~ isfield(options,'smv_rad')
    options.smv_rad = 5;
end

if ~ isfield(options,'tik_reg')
    options.tik_reg = 5e-4;
end

if ~ isfield(options,'lbv_layer')
    options.lbv_layer = 2;
end

if ~ isfield(options,'tv_reg')
    options.tv_reg = 5e-4;
end

if ~ isfield(options,'inv_num')
    options.inv_num = 500;
end

if ~ isfield(options,'save_all')
    options.save_all = 1;
end

if isfield(options,'dicompath')
    dicompath = cd(cd(options.dicompath));
    listing = dir([dicompath, '/*.IMA']);
    dicomfile = [dicompath, '/' listing(1).name];
else
    dicomfile = [];
    setenv('pathstr',pathstr);
    [~,dicomfile] = unix('find "$pathstr" -name *.IMA -print -quit');
    dicomfile = strtrim(dicomfile);
    % if ~ isempty(cmout)
    %     dicoms = strsplit(cmout,'.IMA');
    %     dicomfile = [dicoms{1},'.IMA'];
    % end
end

ref_coil  = options.ref_coil;
eig_rad   = options.eig_rad;
bet_smooth= options.bet_smooth;
bet_thr   = options.bet_thr;
ph_unwrap = options.ph_unwrap;
bkg_rm    = options.bkg_rm;
t_svd     = options.t_svd;
smv_rad   = options.smv_rad;
tik_reg   = options.tik_reg;
lbv_layer = options.lbv_layer;
tv_reg    = options.tv_reg;
inv_num   = options.inv_num;
save_all  = options.save_all;


% define directories
path_qsm = [path_out, filesep, 'QSM_SWI15'];
mkdir(path_qsm);
init_dir = pwd;
cd(path_qsm);
disp(['Start recon of ' filename]);


% generate raw img
rawfile = {[pathstr,filesep],filename};
[img,params] = swi15_recon(rawfile);


% size and resolution
[nv,np,ns,~] = size(img);
nv = nv;
np = np;
ns = ns;
FOV = params.protocol_header.sSliceArray.asSlice{1};
voxelSize = [FOV.dPhaseFOV/nv, FOV.dReadoutFOV/np,  FOV.dThickness/ns];


% angles!!!
if ~ isempty(dicomfile)
    % read in dicom header, this is accurate information
    info = dicominfo(dicomfile);
    Xz = info.ImageOrientationPatient(3);
    Yz = info.ImageOrientationPatient(6);
    Zz = sqrt(1 - Xz^2 - Yz^2);
    disp('find the dicom');
    dicomfile
    z_prjs = [Xz, Yz, Zz]
else % this would be just an estimation
    sNormal = params.protocol_header.sSliceArray.asSlice{1}.sNormal;
    if ~ isfield(sNormal,'dSag')
        sNormal.dSag = 0;
    end
    if ischar(sNormal.dSag)
        sNormal.dSag = 0;
    end
    if ~ isfield(sNormal,'dCor')
        sNormal.dCor = 0;
    end
    if ischar(sNormal.dCor)
        sNormal.dCor = 0;
    end
    if ~ isfield(sNormal,'dTra')
        sNormal.dTra = 0;
    end
    if ischar(sNormal.dTra)
        sNormal.dTra = 0;
    end
    disp('no dicom found, try to use normal vector');
    z_prjs = [-sNormal.dSag, -sNormal.dCor, sNormal.dTra]
end

% combine RF coils
if size(img,4) > 1
    img_cmb = adaptive_cmb(img,voxelSize,ref_coil,eig_rad);
else
    img_cmb = img;
end
mkdir('combine');
nii = make_nii(abs(img_cmb),voxelSize);
save_nii(nii,'combine/mag_cmb.nii');
nii = make_nii(angle(img_cmb),voxelSize);
save_nii(nii,'combine/ph_cmb.nii');


% % combine coils (2D SVD)
% img_cmb = zeros([nv,np,ns]);
% matlabpool open
% parfor i = 1:ns
%     img_cmb(:,:,i) = coilCombinePar(img(:,:,i,:));
% end
% matlabpool close
% mkdir('combine');
% nii = make_nii(abs(img_cmb),voxelSize);
% save_nii(nii,'combine/mag_cmb.nii');
% nii = make_nii(angle(img_cmb),voxelSize);
% save_nii(nii,'ph_cmb.nii');


% generate brain mask
setenv('bet_thr',num2str(bet_thr));
setenv('bet_smooth',num2str(bet_smooth));
[status,cmdout] = unix('rm BET*');
unix('bet2 combine/mag_cmb.nii BET -f ${bet_thr} -w ${bet_smooth} -m');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);



% phase unwrapping, prelude is preferred!
if strcmpi('prelude',ph_unwrap)
    % unwrap combined phase with PRELUDE
    disp('--> unwrap aliasing phase ...');
    bash_script = ['prelude -a combine/mag_cmb.nii -p combine/ph_cmb.nii ' ...
        '-u unph.nii -m BET_mask.nii -n 8'];
    unix(bash_script);
    unix('gunzip -f unph.nii.gz');
    nii = load_nii('unph.nii');
    unph = double(nii.img);


    % % unwrap with Laplacian based method
    % unph = unwrapLaplacian(angle(img_cmb), size(img_cmb), voxelSize);
    % nii = make_nii(unph, voxelSize);
    % save_nii(nii,'unph_lap.nii');


elseif strcmpi('laplacian',ph_unwrap)
    % Ryan Topfer's Laplacian unwrapping
    Options.voxelSize = voxelSize;
    unph = lapunwrap(angle(img_cmb), Options);
    nii = make_nii(unph, voxelSize);
    save_nii(nii,'unph_lap.nii');


elseif strcmpi('bestpath',ph_unwrap)
    % unwrap the phase using best path
    fid = fopen('wrapped_phase.dat','w');
    [pathstr, ~, ~] = fileparts(which('3DSRNCP.m'));
    setenv('pathstr',pathstr);
    setenv('nv',num2str(nv));
    setenv('np',num2str(np));
    setenv('ns',num2str(ns));

    fwrite(fid,angle(img_cmb),'float');
    fclose(fid);
    % mask_unwrp = uint8(hemo_mask.*255);
    mask_unwrp = uint8(abs(mask)*255);
    fid = fopen('mask_unwrp.dat','w');
    fwrite(fid,mask_unwrp,'uchar');
    fclose(fid);

    bash_script = ['${pathstr}/3DSRNCP wrapped_phase.dat mask_unwrp.dat unwrapped_phase.dat ' ...
        '$nv $np $ns reliability.dat'];
    unix(bash_script);

    fid = fopen('unwrapped_phase.dat','r');
    tmp = fread(fid,'float');
    unph = reshape(tmp - round(mean(tmp(mask==1))/(2*pi))*2*pi,[nv np ns]).*mask;
    fclose(fid);

    nii = make_nii(unph,voxelSize);
    save_nii(nii,'unph_best.nii');

    fid = fopen('reliability.dat','r');
    reliability = fread(fid,'float');
    fclose(fid);
    reliability = reshape(reliability,[nv,np,ns]);
    reliability = 1./reliability.*mask;
    % reliability_smooth = smooth3(reliability,'gaussian',[7,7,3],1);
    reliability(reliability <= 0.1) = 0;
    reliability(reliability > 0.1) = 1;
    nii = make_nii(reliability,voxelSize);
    save_nii(nii,'reliability.nii');

else
    error('what unwrapping methods to use? prelude or laplacian or bestpath?')
end


% normalize to ppm unit
TE = params.protocol_header.alTE{1}/1e6;
B_0 = params.protocol_header.m_flMagneticFieldStrength;
gamma = 2.675222e8;
tfs = unph/(gamma*TE*B_0)*1e6; % unit ppm

nii = make_nii(tfs,voxelSize);
save_nii(nii,'tfs.nii');

% PDF
if sum(strcmpi('pdf',bkg_rm))
    disp('--> PDF to remove background field ...');
    [lfs_pdf,mask_pdf] = pdf(tfs,mask,voxelSize,smv_rad, ...
        abs(img_cmb),z_prjs);
    % 3D 2nd order polyfit to remove any residual background
    lfs_pdf= poly3d(lfs_pdf,mask_pdf);

    % save nifti
    mkdir('PDF');
    nii = make_nii(lfs_pdf,voxelSize);
    save_nii(nii,'PDF/lfs_pdf.nii');

    % inversion of susceptibility 
    disp('--> TV susceptibility inversion on PDF...');
    sus_pdf = tvdi(lfs_pdf, mask_pdf, voxelSize, tv_reg, ...
        abs(img_cmb), z_prjs, inv_num); 

    % save nifti
    nii = make_nii(sus_pdf.*mask_pdf,voxelSize);
    save_nii(nii,'PDF/sus_pdf.nii');
end


% SHARP (t_svd: truncation threthold for t_svd)
if sum(strcmpi('sharp',bkg_rm))
    disp('--> SHARP to remove background field ...');
    [lfs_sharp, mask_sharp] = sharp(tfs,mask,voxelSize,smv_rad,t_svd);
    % 3D 2nd order polyfit to remove any residual background
    lfs_sharp= poly3d(lfs_sharp,mask_sharp);

    % save nifti
    mkdir('SHARP');
    nii = make_nii(lfs_sharp,voxelSize);
    save_nii(nii,'SHARP/lfs_sharp.nii');
    
    % inversion of susceptibility 
    disp('--> TV susceptibility inversion on SHARP...');
    sus_sharp = tvdi(lfs_sharp, mask_sharp, voxelSize, tv_reg, ...
        abs(img_cmb), z_prjs, inv_num); 
   
    % save nifti
    nii = make_nii(sus_sharp.*mask_sharp,voxelSize);
    save_nii(nii,'SHARP/sus_sharp.nii');
end


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
        abs(img_cmb), z_prjs, inv_num); 
   
    % save nifti
    nii = make_nii(sus_resharp.*mask_resharp,voxelSize);
    save_nii(nii,'RESHARP/sus_resharp.nii');
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
    sus_lbv = tvdi(lfs_lbv,mask_lbv.*reliability,voxelSize,tv_reg, ...
        abs(img_cmb),z_prjs,inv_num);   

    % save nifti
    nii = make_nii(sus_lbv.*mask_lbv,voxelSize);
    save_nii(nii,'LBV/sus_lbv_masked.nii');
end


% save all variables for debugging purpose
if save_all
    clear nii;
    save('all.mat','-v7.3');
end

% save parameters used in the recon
save('parameters.mat','options','-v7.3')


%% clean up
% unix('rm *.nii*');
cd(init_dir);




% (1) reliability weighted
weights = abs(img_cmb)./max(abs(img_cmb(:))).*mask_lbv.*reliability;
weights = smooth3(weights,'gaussian',[7,7,3],1);
% weights = smooth3(weights,'gaussian',[7,7,3],0.5);
nii = make_nii(weights,voxelSize);
save_nii(nii,'weights.nii');

% inversion of susceptibility 
disp('--> TV susceptibility inversion on lbv...');
sus_lbv = tvdi(lfs_lbv,mask_lbv,voxelSize,tv_reg, ...
    weights,z_prjs,inv_num);   

% save nifti
nii = make_nii(sus_lbv.*mask_lbv,voxelSize);
save_nii(nii,'LBV/sus_lbv_weighted.nii');



% (2) magnitude threshold weighted
thr = 0.2;
img_smooth = smooth3((img_cmb).*reliability,'gaussian',[7,7,3],2);
% calculate the median value of magnitude
tmp = abs(img_smooth(logical(mask_lbv)));
size(tmp)
median(tmp(:))
hemo_mask = mask_lbv;
hemo_mask((abs(img_smooth)<=thr*median(tmp(:)))) = 0;
nii = make_nii(hemo_mask,voxelSize);
save_nii(nii,['hemo_mask_' num2str(thr) '.nii']);

weights = abs(img_cmb)./max(abs(img_cmb(:))).*hemo_mask;

weights = smooth3(weights,'gaussian',[7,7,3],2);

nii = make_nii(weights,voxelSize);
save_nii(nii,'weights.nii');


% inversion of susceptibility 
disp('--> TV susceptibility inversion on lbv...');
sus_lbv = tvdi(lfs_lbv,mask_lbv,voxelSize,tv_reg, ...
    weights,z_prjs,inv_num);   

% save nifti
nii = make_nii(sus_lbv.*mask_lbv,voxelSize);
save_nii(nii,'LBV/sus_lbv_masked.nii');

save all_masked.mat



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% super-position method to reduce artifacts
imsize = size(sus_lbv);
hemo_mask = ones(imsize);
% hemo_mask((weights<=0.1) & (mask_lbv>0)) = 0;
hemo_mask(sus_lbv>=0.5) = 0;

% % threshold the magnitude
% % untrusted worthy hemorrhage as 0, others 1
% hemo_mask = mask;
% hemo_mask(abs(img_smooth)<=0.3) = 0;

nii = make_nii(hemo_mask,voxelSize);
save_nii(nii,'hemo_mask.nii');


% remove the hemorrhage dipole fields
% % LBV to remove hemorrhage
lfs_noHemo_lbv = LBV(lfs_lbv,mask_lbv.*hemo_mask,imsize,voxelSize,0.0001,1); % strip 1 layers
% lfs_noHemo_lbv = LBV(lfs_lbv,1-(mask_lbv-hemo_mask_lbv),imsize,voxelSize,0.01,1); % strip 1 layers
mask_noHemo_lbv = ones(imsize);
mask_noHemo_lbv(lfs_noHemo_lbv == 0) = 0;

% lfs_noHemo_lbv = poly3d(lfs_noHemo_lbv,mask_noHemo_lbv);

nii = make_nii(lfs_noHemo_lbv,voxelSize);
save_nii(nii,'lfs_noHemo_lbv.nii');

nii = make_nii(mask_noHemo_lbv,voxelSize);
save_nii(nii,'mask_noHemo_lbv.nii');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inversion on remaining part (noHemo) of the brain
weights = abs(img_cmb).*mask_lbv.*mask_noHemo_lbv;
sus_noHemo_lbv = tvdi(lfs_noHemo_lbv,mask_lbv.*mask_noHemo_lbv,voxelSize,tv_reg,weights,z_prjs); 
nii = make_nii(sus_noHemo_lbv.*mask_lbv.*mask_noHemo_lbv,voxelSize);
save_nii(nii,['sus_noHemo_lbv.nii']);


% super add together
sus_super_lbv = sus_noHemo_lbv.*mask_lbv.*mask_noHemo_lbv + sus_lbv.*(mask_lbv - mask_noHemo_lbv);
nii = make_nii(sus_super_lbv,voxelSize);
save_nii(nii,'sus_super_lbv.nii');




% baseline fix
%%%%% make this a seperate function in the future
Nx = size(sus_super_lbv,1);
Ny = size(sus_super_lbv,2);
Nz = size(sus_super_lbv,3);
FOV = voxelSize.*[Nx,Ny,Nz];
FOVx = FOV(1);
FOVy = FOV(2);
FOVz = FOV(3);

x = -Nx/2:Nx/2-1;
y = -Ny/2:Ny/2-1;
z = -Nz/2:Nz/2-1;
[kx,ky,kz] = ndgrid(x/FOVx,y/FOVy,z/FOVz);
D = 1/3 - (kx.*z_prjs(1)+ky.*z_prjs(2)+kz.*z_prjs(3)).^2./(kx.^2 + ky.^2 + kz.^2);
D(floor(Nx/2+1),floor(Ny/2+1),floor(Nz/2+1)) = 0;
D = fftshift(D);

W = weights;

x1 = W.*ifftn(D.*fftn(mask_lbv - mask_noHemo_lbv));
x2 = W.*(lfs_lbv - ifftn(D.*fftn(sus_super_lbv)));
x1 = x1(:);
x2 = x2(:);
o = real(x1'*x2/(x1'*x1))

sus_super_fix_lbv = sus_super_lbv + o*(mask_lbv - mask_noHemo_lbv);
nii = make_nii(sus_super_fix_lbv,voxelSize);
save_nii(nii,'sus_super_fix_lbv.nii');


% save the workspace
save all_super.mat
