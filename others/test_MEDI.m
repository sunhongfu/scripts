setenv('path_nft',path_nft);
for echo = 1:ne
	setenv('echo',num2str(echo));
	! bet $path_nft/combine/mag_te${echo}.nii BET_${echo} -f 0.4 -m -R
	! gunzip -f BET_${echo}_mask.nii.gz
end

% save nifti
for echo =  1:ne
    nii = make_nii(ph_cmb(:,:,:,echo),voxelSize);
    save_nii(nii,[path_nft '/combine/ph_te' num2str(echo) '.nii']);
end

bash_command = sprintf(['for ph in $path_nft/combine/ph*\n' ...
'do\n' ...
'   base=`basename $ph`;\n' ...
'   num=${base//[^0-9]/};\n' ...
'   dir=`dirname $ph`;\n' ...
'   mag=$dir/"mag"${base:2};\n' ...
'   unph="unph"${base:2};\n' ...
'   prelude -a $mag -p $ph -u $unph -m BET_${num}_mask.nii -n 8&\n' ...
'done\n' ...
'wait\n' ...
'gunzip -f unph*.gz\n']);

unix(bash_command);


for echo = 1:10
	nii = load_nii(['BET_' num2str(echo) '_mask.nii']);
	mask(:,:,:,echo) = double(nii.img);
end

for echo = 1:ne
    nii = load_nii(['unph_te' num2str(echo) '.nii']);
    unph_cmb(:,:,:,echo) = double(nii.img);
end

if par.nrcvrs == 1
	ph_diff = angle(img(:,:,:,2)./img(:,:,:,1));
	nii = make_nii(ph_diff,voxelSize);
	save_nii(nii,'ph_diff.nii');
	! prelude -a $path_nft/combine/mag_te2.nii -p ph_diff.nii -u unph_diff.nii -m BET_2_mask.nii -n 8
	! gunzip -f unph_diff.nii.gz
end

nii = load_nii('unph_diff.nii');
unph_diff = double(nii.img);
% checking 2pi jumps
meandiff = mean(unph_diff(mask(:,:,:,2)==1))
njump = round(meandiff/(2*pi))
%unph_diff = unph_diff - njump*2*pi;
nii = make_nii(unph_diff.*mask(:,:,:,2),voxelSize);
save_nii(nii,'unph_diff.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for echo = 2:10
    meandiff = unph_cmb(:,:,:,echo)-unph_cmb(:,:,:,1)-(echo-1)*unph_diff;
    meandiff = meandiff(mask(:,:,:,echo)==1); 
    meandiff = mean(meandiff(:));
    njump = round(meandiff/(2*pi));
    disp(['    ' num2str(njump) ' 2pi jumps for TE' num2str(echo)]);
    unph_cmb(:,:,:,echo) = unph_cmb(:,:,:,echo) - njump*2*pi;
end

unph_cmb = unph_cmb.*mask;

mkdir([path_nft '/unwrap']);
for echo = 1:ne
    nii = make_nii(unph_cmb(:,:,:,echo).*mask(:,:,:,echo),voxelSize);
    save_nii(nii,[path_nft '/unwrap/prelude_unph_te' num2str(echo) '.nii']);
end



%% RESHARP and inversion for each echo
% normalize with echo time and main field
ker_rad = 6;
tik_reg = 1e-3;
tv_reg = 5e-4;


mkdir([path_nft '/rmbkg']);
mkdir([path_nft '/inversion']);
for echo = 2:10
	%[lfs(:,:,:,echo),mask_ero(:,:,:,echo)] = resharp(unph_cmb(:,:,:,echo),mask(:,:,:,echo),voxelSize,ker_rad,tik_reg);
	%lfs(:,:,:,echo) = -lfs(:,:,:,echo)/(par.te+(echo-1)*par.esp)/(2.675e8*4.7)*1e6;
	%nii = make_nii(lfs(:,:,:,echo),voxelSize);
	%save_nii(nii,[path_nft '/rmbkg/lfs_resharp_te' num2str(echo) '.nii']);
	sus(:,:,:,echo) = tvdi(lfs(:,:,:,echo), mask_ero(:,:,:,echo), voxelSize, tv_reg, mag_cmb(:,:,:,echo));
	nii = make_nii(sus(:,:,:,echo),voxelSize);
	save_nii(nii,[path_nft '/inversion/sus_resharp_te' num2str(echo) '.nii']);
end


%% RESHARP and inversion for each echo
% normalize with echo time and main field
ker_rad = 6;
tik_reg = 1e-3;
tv_reg = 5e-4;
mkdir([path_nft '/rmbkg']);
mkdir([path_nft '/inversion']);
for echo = 1:10
	tfs(:,:,:,echo) = -unph_cmb(:,:,:,echo)/(par.te+(echo-1)*par.esp)/(2.675e8*4.7)*1e6;
	[lfs(:,:,:,echo),mask_ero] = resharp(tfs(:,:,:,echo),mask,voxelSize,ker_rad,tik_reg);
	nii = make_nii(lfs(:,:,:,echo),voxelSize);
	save_nii(nii,[path_nft '/rmbkg/lfs_resharp_te' num2str(echo) '.nii']);
	sus(:,:,:,echo) = tvdi(lfs(:,:,:,echo), mask_ero, voxelSize, tv_reg, mag_cmb(:,:,:,echo));
	nii = make_nii(sus(:,:,:,echo),voxelSize);
	save_nii(nii,[path_nft '/inversion/sus_resharp_te' num2str(echo) '.nii']);
end


%%%%%%%%%%%% try out MEDI_toolbox %%%%%%%%%%%%%%
load('/media/data/Hongfu/dana_jun18/Control020_REF_20100719/gemsme3d_R2s_01.fid/QSM/matrix/combine/mag_cmb.mat')
load('/media/data/Hongfu/dana_jun18/Control020_REF_20100719/gemsme3d_R2s_01.fid/QSM/matrix/combine/ph_cmb.mat')

iField = mag_cmb.*exp(1i*ph_cmb);
voxel_size = voxelSize;
matrix_size = [np,nv,nv2];
matrix_size=single(matrix_size);
CF = 200.4208227*1e6;
delta_TE = par.esp;
TE = par.te+(0:par.ne-1)*par.esp;
TE = TE';
B0_dir = [0,0,1]';



%%%%%%%%%%%%%%%
%%%%% provide a Mask here if possible %%%%%%
if (~exist('Mask','var'))                     
    Mask = genMask(iField, voxel_size);
end

%%%%% provide a noise_level here if possible %%%%%%
if (~exist('noise_level','var'))
    noise_level = calfieldnoise(iField, Mask);
end

%%%%% normalize signal intensity by noise to get SNR %%%
iField = iField/noise_level;

%%%% Generate the Magnitude image %%%%
iMag = sqrt(sum(abs(iField).^2,4));

% STEP 2a: Field Map Estimation
%%%%%Estimate the frequency offset in each of the voxel using a 
%%%%%complex fitting %%%%
[iFreq_raw N_std] = Fit_ppm_complex(iField);

% STEP 2b: Spatial phase unwrapping %%%%
iFreq = unwrapPhase(iMag, iFreq_raw, matrix_size);
nii = make_nii(iFreq,voxelSize);
save_nii(nii,'iFreq.nii');

% STEP 2c: Background Field Removal
%%%% Background field removal %%%%
[RDF shim] = PDF(iFreq, N_std, Mask,matrix_size,voxel_size, B0_dir);
nii = make_nii(RDF,voxelSize);
save_nii(nii,'RDF.nii');

% STEP 3: Dipole Inversion
save RDF.mat RDF iFreq iFreq_raw iMag N_std Mask matrix_size...
     voxel_size delta_TE CF B0_dir;
%%%% run MEDI %%%%%
QSM = MEDI_L1('lambda',300);
nii = make_nii(QSM,voxelSize);
save_nii(nii,'QSM_300.nii');





