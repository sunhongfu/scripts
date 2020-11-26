% test on ME-GRE (FLASH3D with 3 echoes)
% 
% 2020/10/30, Feng X


%%
datafile = '/Volumes/LaCie/tumor/xiang_mouse/3echo_GRE_for_mice_brain/7741_000_0.MRD';
% datafile = 'C:\Document_Local\Research_Development_Projects\SWI-QSM\7227\7227_000_0.MRD';

reordering1 = 'seq';
reordering2 = 'cen';

[im,dim,par] = Get_mrd_3D5(datafile,reordering1, reordering2);

% Outputs: complex data, raw dimension [no_expts,no_echoes,no_slices,no_views,no_views_2,no_samples], MRD/PPR parameters
% no_views for phase encoding
% no_views_2 for partition encoding

par.pe1_order
par.pe2_centric_on

% echo, phase, slice, readout
size(im)
nEcho = size(im,1);
nSlice = size(im,3);

%% check the system default recon mag, using FFT (interpolated matrix)


header1 = dicominfo('/Volumes/LaCie/tumor/xiang_mouse/3echo_GRE_for_mice_brain/1/7741_00001.dcm');
data1 = dicomread('/Volumes/LaCie/tumor/xiang_mouse/3echo_GRE_for_mice_brain/1/7741_00001.dcm');

size(data1)
% imshow(data1,[])

%% 
imCut = permute(im,[2 4 3 1]); %phase, RO, slice, echo
% imCut = permute(im,[4 2 3 1]); %RO, phase,  slice, echo

Nky = size(imCut,1)
Nkx = size(imCut,2)

%zero padding along Phase, RO
% to make the same matrix size compared to PCS recon dicom, e.g, data1,
% 256*256
% imPadding = zeros(256,256,nSlice,nEcho);
% for echo = 1:nEcho
%     for slice = 1:nSlice
%         imPadding(:,:,slice,echo) = padarray(imCut(:,:,slice,echo),[(256-Nky)/2 (256-Nkx)/2],'both');     
%     end
% end




%% between odd and even echoes
% filp RO direction in even echoes

imPadding2 = imCut;
for echo=2:2:nEcho
    imPadding2(:,:,:,echo) = flip(imCut(:,:,:,echo), 2);
end


%%
% imageRecon = zeros(size(imPadding(:,:,:,1)));
% imageRecon = fftshift(fftshift(fftshift(fft(fft(fft(imPadding(:,:,:,1),[],1),[],2),[],3),1),2),3);

imageRecon = zeros(size(imPadding2));
% imageRecon2 = imageRecon;
for echo=1:size(imPadding2,4)
    %imageRecon(:,:,:,echo) = fftshift(fftshift(fftshift(fft(fft(fft(imPadding(:,:,:,echo),[],1),[],2),[],3),1),2),3);
    imageRecon(:,:,:,echo) = ifftshift(ifftshift(ifftshift(ifft(ifft(ifft(ifftshift(ifftshift(ifftshift(imPadding2(:,:,:,echo),1),2),3),[],1),[],2),[],3),1),2),3);
%     imageRecon2(:,:,:,echo) = fftshift(fftshift(fftshift(fft(fft(fft(fftshift(fftshift(fftshift(imPadding2(:,:,:,echo),1),2),3),[],1),[],2),[],3),1),2),3);

end

% ----CRITICAL operation---- 
% firstly, apply with ifftshift, then iFFT, then ifftshift

% %%
% figure
% for ii=1:nSlice
%     for echo=1:3:nEcho %1:nEcho %
%         subplot(121);
% %         if mod(echo,2)==1
%             imshow( abs(imageRecon(:,:,ii,echo)), []);
%             %imshow( abs(imageRecon2(:,:,ii,echo)), []);
% %         else
% %             imshow( fliplr(abs(imageRecon(:,:,ii,echo))), []);
% %         end
%         title(['mag sl' num2str(ii) ' echo' num2str(echo)]);
        
%         subplot(122);
% %         if mod(echo,2)==1
%             imshow( angle(imageRecon(:,:,ii,echo)), [-pi pi]);
%             %imshow( angle(imageRecon2(:,:,ii,echo)), [-pi pi]);
% %         else
% %             imshow( fliplr(angle(imageRecon(:,:,ii,echo))), [-pi pi]);
% %         end
%         title(['phase sl' num2str(ii) ' echo' num2str(echo)]);
%         pause(.2)
%     end
% end

% %%

% figure;
% ii = 54;
% subplot(211)
% imshow( abs([imageRecon(:,:,ii,1) imageRecon(:,:,ii,2) imageRecon(:,:,ii,3)]), [])
% subplot(212)
% % imshow( abs([imageRecon2(:,:,129-ii,1) imageRecon2(:,:,129-ii,2) imageRecon2(:,:,129-ii,3)]), [])
% imshow( (abs([imageRecon2(:,:,129-ii,1) imageRecon2(:,:,129-ii,2) imageRecon2(:,:,129-ii,3)])), [])
% % imshow( flipud(abs([imageRecon2(:,:,ii,1) imageRecon2(:,:,ii,2) imageRecon2(:,:,ii,3)])), [])
% %%
% figure;
% ii = 54;
% subplot(211)
% imshow( angle([imageRecon(:,:,ii,1) imageRecon(:,:,ii,2) imageRecon(:,:,ii,3)]), [])
% subplot(212)
% % imshow( angle([imageRecon2(:,:,129-ii,1) imageRecon2(:,:,129-ii,2) imageRecon2(:,:,129-ii,3)]), [])
% imshow( flipud(angle([imageRecon2(:,:,129-ii,1) imageRecon2(:,:,129-ii,2) imageRecon2(:,:,129-ii,3)])), [])
% % imshow( flipud(angle([imageRecon2(:,:,ii,1) imageRecon2(:,:,ii,2) imageRecon2(:,:,ii,3)])), [])


% %% 
% ii = 68
% echo=1
% ph1 = angle(imageRecon(:,:,ii,echo));
% % imshow(ph1, [])

% % ph2 = angle(imageRecon2(:,:,ii,echo));
% figure;
% subplot(121); imshow(ph1, [])
% % subplot(122); imshow(ph2, [])

% mag1 = abs(imageRecon(:,:,ii,echo));
% % mag2 = abs(imageRecon2(:,:,ii,echo));
% % figure;
% subplot(122); imshow(mag1, [])
% % subplot(122); imshow(mag2, [])

% generate NII for 1st echo mag from system default recon

fileDir = '/Volumes/LaCie/tumor/xiang_mouse/3echo_GRE_for_mice_brain/1'
fileList = dir(fileDir)
numFile = size(fileList,1)-2;

dataMag = zeros(size(data1,1),size(data1,2),nSlice);
for ii=1:nSlice
   dataMag(:,:,ii)= dicomread(fullfile(fileDir, fileList(ii+2).name));
end

voxel_size =zeros(1,3);
voxel_size(1) = header1.PixelSpacing(1);
voxel_size(2) = header1.PixelSpacing(2);
voxel_size(3) = header1.SliceThickness;

nii = make_nii(dataMag,voxel_size);
save_nii(nii, 'mag1.nii');

%%% UPSCALING, critical
nii = make_nii(dataMag,voxel_size.*10); % mimic human brain size
save_nii(nii, 'mag1_upscale10.nii');


%% using FSL BET to extract the brain mask, based on upscaling version 
% command, running inside ubuntu, or WSL

% bet2 mag1_upscale10.nii  mag1_upscale10 -m -r 50 -f 0.3 -c 73 136 65
% bet2 mag1_upscale10.nii  mag1_upscale10 -m -r 50 -f 0.3 -c 63 129 75
!bet2 mag1_upscale10.nii  mag1_upscale10 -m -r 50 -f 0.3 -c 49 97 68
!gzip -d mag1_upscale10_mask.nii.gz


%% load the mask data

maskTmp = load_nii('mag1_upscale10_mask.nii');
brainMask = maskTmp.img;

imageRecon2 = flip(imageRecon,2); %keep consistent with dicom
% imageRecon2 = imageRecon; %keep consistent with dicom


% angles!!! (z projections)
Xz = header1.ImageOrientationPatient(3);
Yz = header1.ImageOrientationPatient(6);
%Zz = sqrt(1 - Xz^2 - Yz^2);
Zxyz = cross(header1.ImageOrientationPatient(1:3),header1.ImageOrientationPatient(4:6));
Zz = Zxyz(3);
z_prjs = [Xz, Yz, Zz];


% ii=64; 
% figure; 
% subplot(131);imshow(abs(imageRecon2(:,:,ii,2)).* (double(brainMask(:,:,ii))), []);
% subplot(132);imshow(abs(imageRecon2(:,:,ii,2)), []);
% subplot(133);imshow(data1, []);

% brainMask needs to be flipped along COLUMN

% Mask = flip(brainMask,1);
Mask = brainMask;
mag = abs(imageRecon2);
ph = angle(imageRecon2);

imsize = size(imageRecon2)
TE = [0.005, 0.00945, 0.0139]
% bipolar correction
ph_corr = poem_bi3(mag,ph,voxel_size,TE,Mask);

nii = make_nii(ph_corr,voxel_size);
save_nii(nii,'ph_corr.nii');


% save offset corrected phase niftis
mkdir src
for echo = 1:imsize(4)
    nii = make_nii(ph_corr(:,:,:,echo),voxel_size);
    save_nii(nii,['src/ph_corr' num2str(echo) '.nii']);
    nii = make_nii(mag(:,:,:,echo),voxel_size);
    save_nii(nii,['src/mag' num2str(echo) '.nii']);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% option 1: BEST PATH
% unwrap the phase using best path
disp('--> unwrap aliasing phase using bestpath...');
mask = double(Mask);
mask_unwrp = uint8(abs(mask)*255);
fid = fopen('mask_unwrp.dat','w');
fwrite(fid,mask_unwrp,'uchar');
fclose(fid);

[pathstr, ~, ~] = fileparts(which('3DSRNCP.m'));
setenv('pathstr',pathstr);
setenv('nv',num2str(imsize(1)));
setenv('np',num2str(imsize(2)));
setenv('ns',num2str(imsize(3)));

unph = zeros(imsize);

for echo_num = 1:imsize(4)
    setenv('echo_num',num2str(echo_num));
    fid = fopen(['wrapped_phase' num2str(echo_num) '.dat'],'w');
    fwrite(fid,ph_corr(:,:,:,echo_num),'float');
    fclose(fid);

    bash_script = ['${pathstr}/3DSRNCP wrapped_phase${echo_num}.dat mask_unwrp.dat ' ...
        'unwrapped_phase${echo_num}.dat $nv $np $ns reliability${echo_num}.dat'];
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

nii = make_nii(unph,voxel_size);
save_nii(nii,'unph_bestpath.nii');

fit_thr = 20;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% option 2: PRELUDE
% unwrap phase from each echo
nii = make_nii(Mask,voxel_size);
save_nii(nii,'BET_mask.nii');
disp('--> unwrap aliasing phase for all TEs using prelude...');
setenv('echo_num',num2str(imsize(4)));
bash_command = sprintf(['for ph in src/ph_corr[1-$echo_num].nii\n' ...
'do\n' ...
'	base=`basename $ph`;\n' ...
'	dir=`dirname $ph`;\n' ...
'	mag=$dir/"mag"${base:7};\n' ...
'	unph="unph"${base:7};\n' ...
'	prelude -a $mag -p $ph -u $unph -m BET_mask.nii -n 12&\n' ...
'done\n' ...
'wait\n' ...
'gunzip -f unph*.gz\n']);
unix(bash_command);

unph = zeros(imsize);
for echo = 1:imsize(4)
    nii = load_nii(['unph' num2str(echo) '.nii']);
    unph(:,:,:,echo) = double(nii.img);
end

fit_thr = 5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% check and correct for 2pi jump between echoes
disp('--> correct for potential 2pi jumps between TEs ...')

% nii = load_nii('unph_cmb1.nii');
% unph1 = double(nii.img);
% nii = load_nii('unph_cmb2.nii');
% unph2 = double(nii.img);
% unph_diff = unph2 - unph1;

nii = load_nii('unph_diff.nii');
unph_diff = double(nii.img);

for echo = 2:imsize(4)
    meandiff = unph(:,:,:,echo)-unph(:,:,:,1)-double(echo-1)*unph_diff;
    meandiff = meandiff(mask==1);
    meandiff = mean(meandiff(:));
    njump = round(meandiff/(2*pi));
    disp(['    ' num2str(njump) ' 2pi jumps for TE' num2str(echo)]);
    unph(:,:,:,echo) = unph(:,:,:,echo) - njump*2*pi;
    unph(:,:,:,echo) = unph(:,:,:,echo).*mask;
end


% fit phase images with echo times
disp('--> magnitude weighted LS fit of phase to TE ...');
[tfs, fit_residual] = echofit(unph,mag,TE,0); 


% extra filtering according to fitting residuals
% generate reliability map
fit_residual_blur = smooth3(fit_residual,'box',round(0.1./voxel_size)*2+1); 
nii = make_nii(fit_residual_blur,voxel_size);
save_nii(nii,'fit_residual_blur.nii');
R = ones(size(fit_residual_blur));
R(fit_residual_blur >= fit_thr) = 0;


% normalize to main field
% ph = gamma*dB*TE
% dB/B = ph/(gamma*TE*B0)
% units: TE s, gamma 2.675e8 rad/(sT), B0 4.7T
tfs = tfs/(2.675e8*header1.MagneticFieldStrength)*1e6; % unit ppm

nii = make_nii(tfs,voxel_size);
save_nii(nii,'tfs.nii');

% RE-SHARP (tik_reg: Tikhonov regularization parameter)
disp('--> RESHARP to remove background field ...');
[lfs_resharp, mask_resharp] = resharp(tfs,mask.*R,voxel_size,0.3,1e-4,200);
% % 3D 2nd order polyfit to remove any residual background
% lfs_resharp= poly3d(lfs_resharp,mask_resharp);

% save nifti
mkdir('RESHARP');
nii = make_nii(lfs_resharp,voxel_size);
save_nii(nii,'RESHARP/lfs_resharp.nii');

% inversion of susceptibility 
disp('--> TV susceptibility inversion on RESHARP...');
% iLSQR
chi_iLSQR = QSM_iLSQR(lfs_resharp*(2.675e8*header1.MagneticFieldStrength)/1e6,mask_resharp,'H',z_prjs,'voxelsize',voxel_size,'niter',50,'TE',1000,'B0',header1.MagneticFieldStrength);
nii = make_nii(chi_iLSQR,voxel_size);
save_nii(nii,['RESHARP/chi_iLSQR.nii']);
    

















%% check TE info
% header1 = dicominfo('C:\Document_Local\Research_Development_Projects\SWI-QSM\7227\dcm\7227_00001.dcm');
% header1.EchoTime
% header1 = dicominfo('C:\Document_Local\Research_Development_Projects\SWI-QSM\7227\dcm\7227_00129.dcm');
% header1.EchoTime
% header1 = dicominfo('C:\Document_Local\Research_Development_Projects\SWI-QSM\7227\dcm\7227_00257.dcm');
% header1.EchoTime
% header1 = dicominfo('C:\Document_Local\Research_Development_Projects\SWI-QSM\7227\dcm\7227_00385.dcm');
% header1.EchoTime

%% Prepare all the required dataset for MEDI
% [iField,voxel_size,matrix_size,CF,delta_TE,TE,B0_dir]

% iField = imageRecon;
% iField = imageRecon2(:,:,:,1:2:end); % only odd eches
% iField = imageRecon2; % only odd eches
% iField = imageRecon2(:,:,:,1); % only 1 eches
iField = imageRecon2(:,:,:,1:2:end); % only 1 eches

% voxel_size = voxel_size;
matrix_size = [size(data1,1),size(data1,2),nSlice];
CF = header1.ImagingFrequency *1e6;
% delta_TE = 0.005;

% TE = 0.005;
% delta_TE = 0.005;
TE = [0.005,  0.0139];
delta_TE = 0.0139-0.005;
% TE = [0.005, 0.00945, 0.0139];
% delta_TE = 0.0045;

NumEcho = length(TE);

imsize = size(iField);

%% B0_dir
% angles!!! (z projections)
Xz = header1.ImageOrientationPatient(3);
Yz = header1.ImageOrientationPatient(6);
Zxyz = cross(header1.ImageOrientationPatient(1:3),header1.ImageOrientationPatient(4:6));
Zz = Zxyz(3);
z_prjs = [Xz, Yz, Zz];

%%% SHOULD BE THE CASE
B0_dir = z_prjs;

% minSlice = 1e10;
% maxSlice = -1e10;
% for i = 1:length(fileList)-2
%     info = dicominfo(['C:\Document_Local\Research_Development_Projects\SWI-QSM\RAW-MRD-DATA\6305\recon_echo1_mag' '\' fileList(i+2).name]);
%     if info.SliceLocation<minSlice
%         minSlice = info.SliceLocation;
%         minLoc = info.ImagePositionPatient;
%     end
%     if info.SliceLocation>maxSlice
%         maxSlice = info.SliceLocation;
%         maxLoc = info.ImagePositionPatient;
%     end
% end
% Affine2D = reshape(info.ImageOrientationPatient,[3 2]);
% Affine3D = [Affine2D (maxLoc-minLoc)/( (matrix_size(3)-1)*voxel_size(3))];
% B0_dir = Affine3D\[0 0 1]';

%%
option.unwrapping = 'laplacian';
option.BFremoval = 'lbv';
option.lambda = 1000;
option.lambda_CSF = 100;
option.savenii = 0;
disp(option)
%%
numTE = numel(TE);
if numTE >= 2
    dTEarray = TE(2:end)-TE(1:end-1);
    if size(dTEarray,1)==1
        flag = dTEarray==(dTEarray(1).*ones(1,numTE-1));
    else
        flag = dTEarray==(dTEarray(1).*ones(numTE-1,1));
    end
end
 
if numTE==1 || prod(flag)  
    % Estimate the frequency offset in each of the voxel using a complex
    % fitting (even echo spacing)
    [iFreq_raw N_std] = Fit_ppm_complex(iField);
else
    % Estimate the frequency offset in each of the voxel using a complex
    % fitting (uneven echo spacing)
    [iFreq_raw N_std] = Fit_ppm_complex_TE(iField,TE);
end

% Compute magnitude image
[iFreq_raw N_std] = Fit_ppm_complex(iField);

iMag = sqrt(sum(abs(iField).^2,4));

Visu3D(iMag)
Visu3D(iFreq_raw)

%% Spatial phase unwrapping 

switch option.unwrapping
    case 'region' % region growing
        iFreq_rg = unwrapPhase(iMag, iFreq_raw, matrix_size);
    case 'laplacian'
        iFreq_lp  = unwrapLaplacian(iFreq_raw, matrix_size, voxel_size);
    case 'cut' %(graph-cut based), very slow
        iFreq_cut = unwrapping_gc(iFreq_raw,iMag,voxel_size);
    otherwise
        error('unwrapping method not supported!')
end

%%
% Visu3D(iFreq_raw)

Visu3D(iFreq_rg) %  good
Visu3D(iFreq_lp)
Visu3D(iFreq_cut)


ii = 54
figure;
subplot(131); imshow(iFreq_rg(:,:,ii),[]); title('rg')
subplot(132); imshow(iFreq_lp(:,:,ii),[]); title('lp')
subplot(133); imshow(iFreq_cut(:,:,ii),[]); title('cut')



% Mask = Mask>0;
%%

switch option.BFremoval
    case 'pdf' % using Projection onto Dipole Fields
        RDF = PDF(iFreq, N_std, Mask,matrix_size,voxel_size, B0_dir);
    case 'lbv' % using Laplacian Boundary Value
        RDF = LBV(iFreq,Mask,matrix_size,voxel_size,0.005);
    otherwise
        error('background field removal method not supported!')
end
%% try different combination of phase unwrapping and backfield removal

RDF_rg_pdf = PDF(iFreq_rg, N_std, double(Mask),matrix_size,voxel_size, B0_dir);
RDF_lp_pdf = PDF(iFreq_lp, N_std, double(Mask), matrix_size,voxel_size, B0_dir);
RDF_gc_pdf = PDF(iFreq_cut, N_std, double(Mask),matrix_size,voxel_size, B0_dir);

RDF_rg_lbv = LBV(iFreq_rg,double(Mask),matrix_size,voxel_size,0.005);
RDF_lp_lbv = LBV(iFreq_lp,double(Mask),matrix_size,voxel_size,0.005);
RDF_gc_lbv = LBV(iFreq_cut,double(Mask),matrix_size,voxel_size,0.005);



%%
Visu3D(RDF_rg_pdf)
Visu3D(RDF_rg_lbv)
% Visu3D(RDF_gc_pdf)
Visu3D(RDF_lp_pdf)
Visu3D(RDF_lp_lbv)
% Visu3D(RDF_gc_lbv)

% RDF_lp_lbv with more info, but noisy
ii = 68
figure;
subplot(221); imshow(RDF_rg_pdf(:,:,ii),[]); title('RDF rg pdf')
subplot(222); imshow(RDF_rg_lbv(:,:,ii),[]); title('RDF rg lbv')
subplot(223); imshow(RDF_lp_pdf(:,:,ii),[]); title('RDF lp pdf')
subplot(224); imshow(RDF_lp_lbv(:,:,ii),[]); title('RDF lp lbv')

figure; 
subplot(121); imshow(RDF_gc_pdf(:,:,ii),[]); title('RDF gc pdf')
subplot(122); imshow(RDF_gc_lbv(:,:,ii),[]); title('RDF gc lbv')

% LBV returns more tissue info, compared to PDF

%% SHARP + V-SHART missing




%%
% R2* map needed for ventricular CSF mask

% compute R2star using Log-Linear (LL) algorithms for two-echo GRE,
% added by XF, 2019-05-06

% if length(TE)>2
%     R2s = arlo(TE, abs(iField));
% elseif length(TE)==2
%     R2s = computeR2s_LL(TE, abs(iField));  
% else
%     disp(['no R2star'])
% end
% 
% % Ventricular CSF mask for zero referencing
% %%% for mice brain, did not work 
% % Mask_CSF = extract_CSF(R2s, Mask, voxel_size);
% 
% Mask_CSF = SMV(Mask, matrix_size, voxel_size, 1)>0.999;
% figure;
% subplot(121);imshow(Mask(:,:,ii), []);
% subplot(122);imshow(Mask_CSF(:,:,ii), []);
% 
% %%
% ii=23
% % imshow(R2s(:,:,ii) .* Mask(:,:,ii), [])
% 
% R2s1sl = zeros(size(R2s));
% Mask1sl = zeros(size(Mask));
% R2s1sl(:,:,ii) = R2s(:,:,ii);
% Mask1sl(:,:,ii) = Mask(:,:,ii);
% Mask_CSF = extract_CSF(R2s1sl, Mask1sl, voxel_size);

% figure;
% for ii=40:50
%  imshow(iMag(:,:,ii),[])
%  title(['slice ' num2str(ii)])
%  pause
% end

% ii=46; % with clear CSF
ii=59; % with clear CSF
temp = iMag(:,:,ii) .* double(Mask(:,:,ii));
imshow(temp,[])
imshow(temp<8000,[])

tempCSF = temp<8000;
imshow(temp.*tempCSF,[])

tempRect = zeros(size(iMag(:,:,ii)));
tempRect(55:100,100:162)=1;
figure; imshow(tempRect)

Mask_CSF = zeros(size(Mask));
Mask_CSF(:,:,ii) = tempRect.*tempCSF;
figure; imshow(Mask_CSF(:,:,ii).*iMag(:,:,ii), [])

Mask = double(Mask);
Mask_CSF = double(Mask_CSF);
%%
% iFreq = iFreq_rg;
% RDF = RDF_rg_pdf;
% RDF = RDF_rg_lbv;

iFreq = iFreq_lp;
% RDF = RDF_lp_pdf;
RDF = RDF_lp_lbv;
% RDF = TissuePhase3d_lp;

save RDF.mat RDF iFreq iFreq_raw iMag N_std Mask matrix_size voxel_size delta_TE CF B0_dir Mask_CSF;

%%
% Morphology enabled dipole inversion with zero reference using CSF (MEDI+0)
% MAKE SURE the current MATLAB working dir has 'results' folder
% option.lambda = 1000;
option.lambda = 5000;
option.lambda_CSF = 100;

QSM = MEDI_L1('lambda',option.lambda,'lambda_CSF',option.lambda_CSF);

Visu3D(QSM)

%% save
% write QSM as DICOMs
write_QSM_dir(QSM, DICOM_dir,result_dir)

if option.savenii
    nii = make_nii(QSM,voxel_size);
    save_nii(nii,fullfile(result_dir,'QSM.nii'));
end



%% switch to TV reg

% tv_reg     = 5e-4;
% inv_num    = 500;
% sus_lbv = tvdi(RDF,Mask,voxel_size,tv_reg,iMag,z_prjs,inv_num);   
% 

tfs0 = iFreq_rg;
tfs = -tfs0/(2.675e8*7)*1e6; % unit ppm

B0 =7;
voxelsize = voxel_size;
padsize = [12 12 12];
smvsize = 12;
[TissuePhase3d_rg, mask_vsharp] = V_SHARP(tfs ,single(Mask),'smvsize',smvsize,'voxelsize',voxelsize*10);

Visu3D(TissuePhase3d_rg)

%
tfs0 = iFreq_lp;
tfs = -tfs0/(2.675e8*7)*1e6; % unit ppm
[TissuePhase3d_lp, mask_vsharp] = V_SHARP(tfs ,single(Mask),'smvsize',smvsize,'voxelsize',voxelsize*10);

Visu3D(TissuePhase3d_lp)
%TissuePhase3d_lp is bit noisy

%
tfs0 = iFreq_cut;
tfs = -tfs0/(2.675e8*7)*1e6; % unit ppm
[TissuePhase3d_gc, mask_vsharp] = V_SHARP(tfs ,single(Mask),'smvsize',smvsize,'voxelsize',voxelsize*10);

Visu3D(TissuePhase3d_gc)




%% switch to iLSQR


TissuePhase3d = TissuePhase3d_rg;
chi_iLSQR_rg = QSM_iLSQR(TissuePhase3d*(2.675e8*7)/1e6,Mask,'H',z_prjs,'voxelsize',voxel_size,'niter',500,'TE',TE(1),'B0',7);
nii = make_nii(chi_iLSQR_rg,voxel_size);
save_nii(nii,['results/chi_iLSQR_rg.nii']);

TissuePhase3d = TissuePhase3d_gc;
chi_iLSQR_rg = QSM_iLSQR(TissuePhase3d*(2.675e8*7)/1e6,Mask,'H',z_prjs,'voxelsize',voxel_size,'niter',500,'TE',TE(1),'B0',7);
nii = make_nii(chi_iLSQR_rg,voxel_size);
save_nii(nii,['results/chi_iLSQR_gc.nii']);


TissuePhase3d = TissuePhase3d_lp;
chi_iLSQR_lp = QSM_iLSQR(TissuePhase3d*(2.675e8*7)/1e6,Mask,'H',z_prjs,'voxelsize',voxel_size,'niter',500,'TE',TE(1),'B0',7);
nii = make_nii(chi_iLSQR_lp,voxel_size);
save_nii(nii,['results/chi_iLSQR_lp.nii']);


%
TissuePhase3d = RDF_rg_pdf;
chi_iLSQR_rg_pdf = QSM_iLSQR(TissuePhase3d*(2.675e8*7)/1e6,Mask,'H',z_prjs,'voxelsize',voxel_size,'niter',500,'TE',TE(1),'B0',7);
nii = make_nii(chi_iLSQR_rg_pdf,voxel_size);
save_nii(nii,['results/chi_iLSQR_rg_pdf.nii']);

TissuePhase3d = RDF_rg_lbv;
chi_iLSQR_rg_lbv = QSM_iLSQR(TissuePhase3d*(2.675e8*7)/1e6,Mask,'H',z_prjs,'voxelsize',voxel_size,'niter',500,'TE',TE(1),'B0',7);
nii = make_nii(chi_iLSQR_rg_lbv,voxel_size);
save_nii(nii,['results/chi_iLSQR_rg_lbv.nii']);

TissuePhase3d = RDF_lp_pdf;
chi_iLSQR_lp_pdf = QSM_iLSQR(TissuePhase3d*(2.675e8*7)/1e6,Mask,'H',z_prjs,'voxelsize',voxel_size,'niter',500,'TE',TE(1),'B0',7);
nii = make_nii(chi_iLSQR_lp_pdf,voxel_size);
save_nii(nii,['results/chi_iLSQR_lp_pdf.nii']);

TissuePhase3d = RDF_gc_lbv;
chi_iLSQR_rg_lbv = QSM_iLSQR(TissuePhase3d*(2.675e8*7)/1e6,Mask,'H',z_prjs,'voxelsize',voxel_size,'niter',500,'TE',TE(1),'B0',7);
nii = make_nii(chi_iLSQR_rg_lbv,voxel_size);
save_nii(nii,['results/chi_iLSQR_gc_lbv.nii']);

TissuePhase3d = RDF_lp_lbv;
chi_iLSQR_rg_lbv = QSM_iLSQR(TissuePhase3d*(2.675e8*7)/1e6,Mask,'H',z_prjs,'voxelsize',voxel_size,'niter',500,'TE',TE(1),'B0',7);
nii = make_nii(chi_iLSQR_rg_lbv,voxel_size);
save_nii(nii,['results/chi_iLSQR_lp_lbv.nii']);

TissuePhase3d = RDF_gc_pdf;
chi_iLSQR_gc_pdf = QSM_iLSQR(TissuePhase3d*(2.675e8*7)/1e6,Mask,'H',z_prjs,'voxelsize',voxel_size,'niter',500,'TE',TE(1),'B0',7);
nii = make_nii(chi_iLSQR_gc_pdf,voxel_size);
save_nii(nii,['results/chi_iLSQR_gc_pdf.nii']);

