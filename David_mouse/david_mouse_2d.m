
%
%
% For Hongfu's QSM processing
%
% Written by David Wright
%
% Reads in & Reco's 2D Bruker fid
%
%

    
directory = pwd;

 
% Eg: directory = '6';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              % 
%         load kSpace (Bruker fid)             %
%                                              %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

infile=[directory,'/fid'];
infid=fopen(infile,'r','ieee-le');
[buf,count] = fread(infid,'int32');

dim_x  = 160;
dim_y  = 160;
slices  = 64;
echoes = 8;
coils  = 4;

kspace=zeros(dim_x,coils,echoes,slices,dim_y);
kspace(:)=complex(buf(1:2:count),buf(2:2:count));
kspace=permute(kspace,[1,5,4,3,2]);

clear buf directory infid infile count;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              % 
%           Adjust for phase offset            %
%                                              %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

phoffset=-0.199999999999998;
fovphase=2.88;

kspace=reshape(kspace,[dim_x,dim_y,(4*echoes*slices)]);

for z=1:length(kspace)
    for k=1:dim_y
        kspace(:,k,z)=kspace(:,k,z)*exp(-1i*pi*2*phoffset*k/(fovphase*10));
    end
end

clear phoffset fovphase k z;

kspace=reshape(kspace,[dim_x,dim_y,slices,echoes,coils]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              % 
%            Reconstruct Image                 %
%                                              %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

image=zeros(dim_x,dim_y,slices,echoes,coils);

for coil=1:coils
    for echo=1:echoes
       for slice=1:slices
           imagetemp(:,:)=fftshift(fft2(fftshift(kspace(:,:,slice,echo,coil))));
           image(:,:,slice,echo,coil)=imagetemp;
       end
    end
end

% clear imagetemp kspace coil echo slice;




%%% HONGFU edit
% assume this is interleaved
img = zeros(size(image));
img(:,:,1:2:end,:,:) = image(:,:,1:end/2,:,:);
img(:,:,2:2:end,:,:) = image(:,:,end/2+1:end,:,:);

TE = (7.5 + (0:7)*7.5)*1e-3;
delta_TE = 7.5*1e-3;
voxel_size = [0.18 0.18 0.18];
matrix_size = [160 160 64];
CF = 200.3*1e6;

PVM_SPackArrGradOrient = str2num('0.00136096694744709 0.0871312153523045 0.99619591400497 0.999836549053541 -0.0180784080152812 0.000215268064122768 0.0180283927645914 0.996032791867247 -0.0871415777884603');
af = reshape(PVM_SPackArrGradOrient,3,3);
%af(3,:) = -af(3,:);
%Affine3D = [af(:,2),af(:,1),af(:,3)];
Affine3D = af;
B0_dir = Affine3D\[0 0 1]';
TR = 4400*1e-3;
NumEcho = 8;


% QSM reconstruction
mkdir QSM
cd QSM

%% combine the coils
% sum-of-squres combine magnitude
mag_cmb = sqrt(sum(abs(img).^2,5));
nii = make_nii(mag_cmb, voxel_size);
save_nii(nii,'mag_cmb.nii');

imsize = size(img);
mkdir src

for i = 1:imsize(4)
	nii = make_nii(mag_cmb(:,:,:,i),voxel_size);
	save_nii(nii,['src/mag' num2str(i) '.nii']);

	% N3 correction
	setenv('echonum',num2str(i));
	unix('nii2mnc src/mag${echonum}.nii src/mag${echonum}.mnc');
	unix('nu_correct src/mag${echonum}.mnc src/corr_mag${echonum}.mnc -V1.0 -distance 10');
	unix('mnc2nii src/corr_mag${echonum}.mnc src/corr_mag${echonum}.nii');

end

! rm src/*.mnc

% correct for phase ramps in slice dimension
img_backup = img;
for echo = 1:8
	for slice = 1:64
		img(:,:,slice,echo,:) = img(:,:,slice,echo,:).*exp(1j*slice*pi*(-0.34+(echo-1)*1.17));
	end
end


n3_mag_cmb = zeros(imsize(1:4));
for echo = 1:imsize(4)
    nii = load_nii(['src/corr_mag' num2str(echo) '.nii']);
    n3_mag_cmb(:,:,:,echo) = double(nii.img);
end

mag_cmb_mean = mean(mag_cmb,4);
nii = make_nii(mag_cmb_mean,voxel_size);
save_nii(nii,'mag_cmb_mean.nii');

mag_cmb_sos = sqrt(sum(mag_cmb.^2,4));
nii = make_nii(mag_cmb_sos,voxel_size);
save_nii(nii,'mag_cmb_sos.nii');


n3_mag_cmb_mean = mean(n3_mag_cmb,4);
nii = make_nii(n3_mag_cmb_mean,voxel_size);
save_nii(nii,'n3_mag_cmb_mean.nii');

n3_mag_cmb_sos = sqrt(sum(n3_mag_cmb.^2,4));
nii = make_nii(n3_mag_cmb_sos,voxel_size);
save_nii(nii,'n3_mag_cmb_sos.nii');


% mask based on mag_cmb_mean
mask = ones(size(n3_mag_cmb_mean));
% smooth the n3_mag_cmb of first echo
n3_mag_cmb_blur = smooth3(n3_mag_cmb(:,:,:,1),'box',round(0.1./voxel_size)*2+1); 
mask(n3_mag_cmb_blur<200000) = 0;
nii = make_nii(mask,voxel_size);
save_nii(nii,'mask.nii');


ph_corr = geme_cmb_mouse(img,voxel_size,TE,mask);
nii = make_nii(ph_corr,voxel_size);
save_nii(nii,'ph_corr.nii');


for echo = 1:imsize(4)
    nii = make_nii(ph_corr(:,:,:,echo),voxel_size);
    save_nii(nii,['src/corr_ph' num2str(echo) '.nii']);
end



%% Method 1: complex fitting
iField = n3_mag_cmb.*exp(1j.*ph_corr);

% [iFreq_raw N_std] = Fit_ppm_complex(iField);
[iFreq_raw N_std] = Fit_ppm_complex(iField(:,:,:,1:4));

nii = make_nii(iFreq_raw,voxel_size);
save_nii(nii,'iFreq_raw.nii');

% phase unwrapping using prelude
! rm *.mnc
!prelude -a n3_mag_cmb_mean.nii -p iFreq_raw.nii -u iFreq_un -m mask.nii
!gunzip -f iFreq_un.nii.gz
nii = load_nii('iFreq_un.nii');
iFreq = double(nii.img);


% (1) RESHARP background field removal + iLSQR
[RDF, mask_resharp] = resharp(iFreq,mask,voxel_size,0.3,5e-4,500);
nii = make_nii(RDF,voxel_size);
save_nii(nii,'RDF_resharp_10.nii');

lfs_resharp = RDF/(2.675e8*9.4*delta_TE*1e-6);

% iLSQR method
z_prjs = B0_dir;
chi_iLSQR_0 = QSM_iLSQR(lfs_resharp*(2.675e8*9.4)/1e6,mask_resharp,'H',z_prjs,'voxelsize',voxel_size,'niter',50,'TE',1000,'B0',9.4);
nii = make_nii(chi_iLSQR_0,voxel_size);
save_nii(nii,'chi_iLSQR_0.nii');



% (2) RESHARP + MEDI
% MEDI
%%%%% normalize signal intensity by noise to get SNR %%%
%%%% Generate the Magnitude image %%%%
iMag = n3_mag_cmb_sos;
matrix_size = single(imsize(1:3));
voxel_size = voxel_size;
delta_TE = TE(2) - TE(1);
B0_dir = z_prjs';
% CF = 42.6036*9.4 *1e6; %%% CF is wrong
iFreq = [];

Mask = mask_resharp;
save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
     voxel_size delta_TE CF B0_dir;
QSM = MEDI_L1('lambda',10000);
nii = make_nii(QSM.*Mask,voxel_size);
save_nii(nii,['MEDI10000_10.nii']);

QSM = MEDI_L1('lambda',5000);
nii = make_nii(QSM.*Mask,voxel_size);
save_nii(nii,['MEDI5000_10.nii']);




%% Method 2: unwrap of each echo then fit

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% unwrap the phase using best path
disp('--> unwrap aliasing phase using bestpath...');
mask_unwrp = uint8(abs(mask)*255);
fid = fopen('mask_unwrp.dat','w');
fwrite(fid,mask_unwrp,'uchar');
fclose(fid);

[pathstr, ~, ~] = fileparts(which('3DSRNCP.m'));
setenv('pathstr',pathstr);
setenv('nv',num2str(imsize(1)));
setenv('np',num2str(imsize(2)));
setenv('ns',num2str(imsize(3)));

unph = zeros(imsize(1:4));

for echo_num = 1:imsize(4)
    setenv('echo_num',num2str(echo_num));
    fid = fopen(['wrapped_phase' num2str(echo_num) '.dat'],'w');
    fwrite(fid,ph_corr(:,:,:,echo_num),'float');
    fclose(fid);
    if isdeployed
        bash_script = ['~/bin/3DSRNCP wrapped_phase${echo_num}.dat mask_unwrp.dat ' ...
        'unwrapped_phase${echo_num}.dat $nv $np $ns reliability${echo_num}.dat'];
    else    
        bash_script = ['${pathstr}/3DSRNCP wrapped_phase${echo_num}.dat mask_unwrp.dat ' ...
        'unwrapped_phase${echo_num}.dat $nv $np $ns reliability${echo_num}.dat'];
    end
    unix(bash_script) ;

    fid = fopen(['unwrapped_phase' num2str(echo_num) '.dat'],'r');
    tmp = fread(fid,'float');
    % tmp = tmp - tmp(1);
    unph(:,:,:,echo_num) = reshape(tmp - round(mean(tmp(mask==1))/(2*pi))*2*pi ,imsize(1:3)).*mask;
    fclose(fid);

    fid = fopen(['reliability' num2str(echo_num) '.dat'],'r');
    reliability_raw = fread(fid,'float');
    reliability_raw = reshape(reliability_raw,imsize(1:3));
    fclose(fid);

    nii = make_nii(reliability_raw.*mask,voxel_size);
    save_nii(nii,['reliability_raw' num2str(echo_num) '.nii']);
end

unph = unph.*repmat(mask,[1 1 1 imsize(4)]);
nii = make_nii(unph,voxel_size);
save_nii(nii,'unph_bestpath.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


disp('--> unwrap aliasing phase for all TEs using prelude...');
setenv('echo_num',num2str(imsize(4)));
bash_command = sprintf(['for ph in src/corr_ph*.nii\n' ...
'do\n' ...
'   base=`basename $ph`;\n' ...
'   dir=`dirname $ph`;\n' ...
'   mag=$dir/"corr_mag"${base:7};\n' ...
'   unph="unph"${base:7};\n' ...
'   prelude -a $mag -p $ph -u $unph -m mask.nii &\n' ...
'done\n' ...
'wait\n' ...
'gunzip -f unph*.gz\n']);
unix(bash_command);


unph = zeros(imsize(1:4));
for echo = 1:imsize(4)
    nii = load_nii(['unph' num2str(echo) '.nii']);
    unph(:,:,:,echo) = double(nii.img);
end


% 2pi jumps correction
% nii = load_nii('unph_diff.nii');
% unph_diff = double(nii.img);

unph_diff = unph(:,:,:,2) - unph(:,:,:,1);
mask_mid = zeros(size(mask));
mask_mid(44:124,44:84,20:50) = 1;
for echo = 2:imsize(4)
    meandiff = unph(:,:,:,echo)-unph(:,:,:,1)-double(echo-1)*unph_diff;
    meandiff = meandiff(mask_mid==1);
    meandiff = mean(meandiff(:));
    njump = round(meandiff/(2*pi));
    disp(['    ' num2str(njump) ' 2pi jumps for TE' num2str(echo)]);
    % unph(:,:,:,echo) = unph(:,:,:,echo) - njump*2*pi;
    % unph(:,:,:,echo) = unph(:,:,:,echo).*mask;
end

nii = make_nii(unph,voxel_size);
save_nii(nii,'unph_corr.nii');


% fit phase images with echo times
disp('--> magnitude weighted LS fit of phase to TE ...');
% [tfs0, fit_residual0] = echofit(unph,n3_mag_cmb,TE,0); 
[tfs0, fit_residual0] = echofit(unph(:,:,:,1:4),n3_mag_cmb(:,:,:,1:4),TE(1:4),0); 
nii = make_nii(tfs0,voxel_size);
save_nii(nii,'tfs0.nii');
nii = make_nii(fit_residual0,voxel_size);
save_nii(nii,'fit_residual0.nii');

r_mask = 1;
fit_thr = 20; % all 8 echoes
% fit_thr = 10; % first 10 echoes (bestpath)
% fit_thr = 20; % first 10 echoes (prelude)
% extra filtering according to fitting residuals
if r_mask
    % generate reliability map
    fit_residual_blur = smooth3(fit_residual0,'box',round(0.1./voxel_size)*2+1); 
    nii = make_nii(fit_residual_blur,voxel_size);
    save_nii(nii,'fit_residual_blur0.nii');
    R = ones(size(fit_residual_blur));
    R(fit_residual_blur >= fit_thr) = 0;
else
    R = 1;
end

% normalize to main field
% ph = gamma*dB*TE
% dB/B = ph/(gamma*TE*B0)
% units: TE s, gamma 2.675e8 rad/(sT), B0 3T
tfs = tfs0/(2.675e8*9.4)*1e6; % unit ppm

nii = make_nii(tfs,voxel_size);
save_nii(nii,'tfs.nii');


disp('--> RESHARP to remove background field ...');
smv_rad = 0.3;
tik_reg = 5e-4;
cgs_num = 500;
tv_reg = 2e-4;
z_prjs = B0_dir;
inv_num = 500;

[lfs_resharp, mask_resharp] = resharp(tfs,mask.*R,voxel_size,smv_rad,tik_reg,cgs_num);
% % 3D 2nd order polyfit to remove any residual background
% lfs_resharp= lfs_resharp - poly3d(lfs_resharp,mask_resharp);

% save nifti
[~,~,~] = mkdir('RESHARP');
nii = make_nii(lfs_resharp,voxel_size);
save_nii(nii,['RESHARP/lfs_resharp0_tik_', num2str(tik_reg), '_num_', num2str(cgs_num), '.nii']);

% % inversion of susceptibility 
% disp('--> TV susceptibility inversion on RESHARP...');
% sus_resharp = tvdi(lfs_resharp,mask_resharp,voxel_size,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 
% % save nifti
% nii = make_nii(sus_resharp.*mask_resharp,voxel_size);
% save_nii(nii,['RESHARP/sus_resharp_tik_', num2str(tik_reg), '_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);

% iLSQR method
chi_iLSQR = QSM_iLSQR(lfs_resharp*(2.675e8*9.4)/1e6,mask_resharp,'H',z_prjs,'voxelsize',voxel_size,'niter',50,'TE',1000,'B0',9.4);
nii = make_nii(chi_iLSQR,voxel_size);
save_nii(nii,'RESHARP/chi_iLSQR0.nii');


