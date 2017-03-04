% 333 single volume
meas_in = '2014.10.30-13.20.25-epi_333_TR3_meas.out';

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

if ~ isfield(options,'ph_corr')
    options.ph_corr = 3;
    % 1: linear
    % 2: non-linear
    % 3: MTF
end

if ~ isfield(options,'ref_coi')
    options.ref_coi = 8;
end

if ~ isfield(options,'eig_rad')
    options.eig_rad = 5;
end

if ~ isfield(options,'bet_thr')
    options.bet_thr = 0.45;
end

if ~ isfield(options,'smv_rad')
    options.smv_rad = 6;
end

if ~ isfield(options,'tik_reg')
    options.tik_reg = 5e-4;
end

if ~ isfield(options,'tv_reg')
    options.tv_reg = 1e-4;
end

if ~ isfield(options,'tvdi_n')
    options.tvdi_n = 200;
end

if ~ isfield(options,'sav_all')
    options.sav_all = 0;
end

ph_corr = options.ph_corr;
ref_coi = options.ref_coi;
eig_rad = options.eig_rad;
bet_thr = options.bet_thr;
smv_rad = options.smv_rad;
tik_reg = options.tik_reg;
tv_reg  = options.tv_reg;
tvdi_n  = options.tvdi_n;
sav_all = options.sav_all;


% define directories
[~,name] = fileparts(filename);
% path_qsm = [path_out, filesep, strrep(name,' ','_') '_QSM_EPI15_v200'];
path_qsm = [path_out, filesep, 'QSM_' name];
mkdir(path_qsm);
init_dir = pwd;
cd(path_qsm);
disp(['Start recon of ' filename]);


% generate raw img
disp('--> reconstruct to complex img ...');
[img,params] = epi15_recon([pathstr,filesep,filename],ph_corr);


% zero-interpolation
k = ifftshift(ifftn(ifftshift(img)));
k_pad = padarray(k,size(k)/2);

% low pass filter to reduce gibbs-ringing
% 3D low-pass hann filter
Nro = size(k,1);
Npe = size(k,2);
Ns = size(k,3);
fw = 0.75;

x = hann(round(fw*Nro/2)*2);
x1 = [x(1:length(x)/2); ones([Nro-length(x),1]); x(length(x)/2+1:end)];
y = hann(round(fw*Npe/2)*2);
y1 = [y(1:length(y)/2); ones([Npe-length(y),1]); y(length(y)/2+1:end)];
z = hann(round(fw*Ns/2)*2);
z1 = [z(1:length(z)/2); ones([Ns-length(z),1]); z(length(z)/2+1:end)];
        
[X,Y,Z] = ndgrid(x1,y1,z1);
F = X.*Y.*Z;
F = padarray(F,size(k)/2);
% F = repmat(F,[1 1 1 size(k,4)]);

k = k.*F;

img = fftshift(fftn(fftshift(k)));


% size and resolution
[Nro,Npe,~,~] = size(img);
FOV = params.protocol_header.sSliceArray.asSlice{1};
voxelSize = [FOV.dReadoutFOV/Nro, FOV.dPhaseFOV/Npe,  FOV.dThickness];


% combine RF coils
disp('--> combine RF rcvrs ...');
if size(img,4)>1
    img_cmb = sense_se(img,voxelSize,ref_coi,eig_rad);
else
    img_cmb = img;
end

mkdir('combine');
nii = make_nii(abs(img_cmb),voxelSize);
save_nii(nii,'combine/mag_cmb.nii');
nii = make_nii(angle(img_cmb),voxelSize);
save_nii(nii,'combine/ph_cmb.nii');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % combine coils
% % 
% img_cmb = zeros(Nro,Npe,Ns);
% matlabpool open
% parfor i = 1:Ns
%     img_cmb(:,:,i) = coilCombinePar(img(:,:,i,:));
% end
% matlabpool close
% nii = make_nii(abs(img_cmb),voxelSize);
% save_nii(nii,'mag.nii');
% nii = make_nii(angle(img_cmb),voxelSize);
% save_nii(nii,'ph.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% generate brain mask
disp('--> extract brain volume and generate mask ...');
setenv('bet_thr',num2str(bet_thr));
unix('bet combine/mag_cmb.nii BET -f ${bet_thr} -m -R');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);


% unwrap combined phase with PRELUDE
disp('--> unwrap aliasing phase ...');
unix('prelude -a combine/mag_cmb.nii -p combine/ph_cmb.nii -u unph.nii -m BET_mask.nii -n 8');
unix('gunzip -f unph.nii.gz');
nii = load_nii('unph.nii');
unph = double(nii.img);

% unwrap with Laplacian based method
% unph = unwrapLaplacian(angle(img_cmb), size(img_cmb), voxelSize);
% nii = make_nii(unph, voxelSize);
% save_nii(nii,'unph_lap.nii');


% % background field removal
% % % (1) PDF to remove air
% sNormal = params.protocol_header.sSliceArray.asSlice{1}.sNormal;
% if ~ isfield(sNormal,'dSag')
%     sNormal.dSag = 0;
% end
% if ischar(sNormal.dSag)
%     sNormal.dSag = 0;
% end
% if ~ isfield(sNormal,'dCor')
%     sNormal.dCor = 0;
% end
% if ischar(sNormal.dCor)
%     sNormal.dCor = 0;
% end
% if ~ isfield(sNormal,'dTra')
%     sNormal.dTra = 0;
% end
% if ischar(sNormal.dTra)
%     sNormal.dTra = 0;
% end
% z_prjs = [-sNormal.dSag, -sNormal.dCor, sNormal.dTra];

% weights = mask.*abs(img_cmb);
% [lfs_pdf,mask_pdf] = pdf(unph,mask,voxelSize,smv_rad,weights,z_prjs);
% % nii = make_nii(lfs_pdf_noAir.*mask_pdf_ero.*hemo_mask,voxelSize);
% nii = make_nii(lfs_pdf,voxelSize);
% save_nii(nii,'lfs_pdf.nii');
% nii = make_nii(mask_pdf,voxelSize);
% save_nii(nii,'mask_pdf.nii');




disp('--> RESHARP to remove background field ...');
mkdir('RESHARP');
[lph_resharp,mask_resharp] = resharp(unph,mask,voxelSize,smv_rad,tik_reg);

% normalize to ppm unit
TE = params.protocol_header.alTE{1}/1e6;
B_0 = params.protocol_header.m_flMagneticFieldStrength;
gamma = 2.675222e8;
lfs_resharp = lph_resharp/(gamma*TE*B_0)*1e6; % unit ppm

nii = make_nii(lfs_resharp,voxelSize);
save_nii(nii,'RESHARP/lfs_resharp.nii');


% susceptibility inversion
disp('--> TV susceptibility inversion ...');
% account for oblique slicing (head tilted)
% theta = -acos(params.protocol_header.sSliceArray.asSlice{1}.sNormal.dTra);
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
nor_vec = [sNormal.dSag, sNormal.dCor, sNormal.dTra]

% sus_resharp = tvdi(lfs_resharp,mask_resharp,voxelSize,tv_reg,abs(img_cmb),theta,tvdi_n);
[sus_resharp,residual] = tvdi(lfs_resharp,mask_resharp,voxelSize,tv_reg,abs(img_cmb),nor_vec,tvdi_n);
nii = make_nii(sus_resharp.*mask_resharp,voxelSize);
save_nii(nii,'RESHARP/sus_resharp.nii');

