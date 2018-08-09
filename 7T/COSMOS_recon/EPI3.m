% EPI (CMRR), Sum of Squares combined

% read in uncombined magnitude and phase images
path_mag = '/home/hongfu/NCIgb5_scratch/hongfu/SPECIMAN/1.10.1/1.10.1.344/1.10.1.344.1.1/1.10.1.344.1.1.80/dicom_series/';
path_ph = '/home/hongfu/NCIgb5_scratch/hongfu/SPECIMAN/1.10.1/1.10.1.344/1.10.1.344.1.1/1.10.1.344.1.1.81/dicom_series/';
path_out = '/home/hongfu/NCIgb5_scratch/hongfu/EPI/HEAD_SMS2';

%% read in DICOMs of both uncombined magnitude and raw unfiltered phase images

%% read in DICOMs of both uncombined magnitude and raw unfiltered phase images
path_mag = cd(cd(path_mag));
mag_list = dir([path_mag '/0001.dcm']);
mag_list = mag_list(~strncmpi('.', {mag_list.name}, 1));
path_ph = cd(cd(path_ph));
ph_list = dir([path_ph '/0001.dcm']);
ph_list = ph_list(~strncmpi('.', {ph_list.name}, 1));

% number of slices (mag and ph should be the same)
nSL = length(ph_list);

% get the sequence parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EchoTrainLength = 3; % this number is wrong in DICOM header
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% for i = 1:nSL/EchoTrainLength:nSL % read in TEs
%     dicom_info = dicominfo([path_ph,filesep,ph_list(i).name]);
%     TE(dicom_info.EchoNumber) = dicom_info.EchoTime*1e-3;
% end

dicom_info = dicominfo([path_ph,filesep,ph_list(1).name]);
TE(dicom_info.EchoNumber) = dicom_info.EchoTime*1e-3;

vox = [dicom_info.PixelSpacing(1), dicom_info.PixelSpacing(2), dicom_info.SliceThickness];

% angles (z projections of the image x y z coordinates) 
Xz = dicom_info.ImageOrientationPatient(3);
Yz = dicom_info.ImageOrientationPatient(6);
Zxyz = cross(dicom_info.ImageOrientationPatient(1:3),dicom_info.ImageOrientationPatient(4:6));
Zz = Zxyz(3);
z_prjs = [Xz, Yz, Zz];

% read in measurements
mag = zeros(dicom_info.Rows,dicom_info.Columns,nSL,'single');
ph = zeros(dicom_info.Rows,dicom_info.Columns,nSL,'single');
for i = 1:nSL
    mag(:,:,i) = single(dicomread([path_mag,filesep,mag_list(i).name]));
    ph(:,:,i) = single(dicomread([path_ph,filesep,ph_list(i).name]));
end

% crop mosaic into individual images
AcqMatrix = regexp(dicom_info.Private_0051_100b,'(\d)*(\d)','match');
if strcmpi(dicom_info.InPlanePhaseEncodingDirection,'COL') % A/P
% phase encoding along column
    wRow = round(str2num(AcqMatrix{1})/dicom_info.PercentSampling*100);
    wCol = str2num(AcqMatrix{2});
else % L/R
    wCol = round(str2num(AcqMatrix{1})/dicom_info.PercentSampling*100);
    wRow = str2num(AcqMatrix{2});
end

nCol = double(dicom_info.Columns/wCol);
nRow = double(dicom_info.Rows/wRow);
nChan = double(dicom_info.Private_0019_100a);

mag_all = zeros(wRow,wCol,nChan,nSL,'single');
% ph_all = zeros(wRow,wCol,nChan,nSL,'single');
for i = 1:nSL
    for x = 1:wRow
        for y = 1:wCol
            for z = 1:nChan
                X = floor((z-1)/nCol)*wRow + x;
                Y = mod(z-1,nCol)*wCol + y;
                mag_all(x,y,z,i) = mag(X,Y,i);
                ph_all(x,y,z,i) = ph(X,Y,i);
            end
        end
    end
end

% reshape and permute into COLS, ROWS, SLICES, ECHOES, CHANS
mag_all = reshape(mag_all,[wRow,wCol,nChan]);
mag_all = permute(mag_all,[2 1 3]);
ph_all = reshape(ph_all,[wRow,wCol,nChan]);
ph_all = permute(ph_all,[2 1 3]);
% 0028,0106  Smallest Image Pixel Value: 0
% 0028,0107  Largest Image Pixel Value: 4094
% conver scale to -pi to pi
ph_all = 2*pi.*(ph_all - single(dicom_info.SmallestImagePixelValue))./(single(dicom_info.LargestImagePixelValue - dicom_info.SmallestImagePixelValue)) - pi;

ph_all(:,:,64:126)=angle(exp(1j.*(ph_all(:,:,64:126)-pi)));

imsize = size(ph_all);

% define output directories
path_qsm = [path_out '/QSM_MEGE_7T'];
mkdir(path_qsm);
init_dir = pwd;
cd(path_qsm);
% save the raw data for future use
clear mag ph
save('raw.mat','-v7.3');



% save magnitude and phase for each echo
mkdir('src');
for i = 1:size(mag_all,4) % all time series
    nii = make_nii(mag_all(:,:,:,i),vox);
    save_nii(nii,['src/mag' num2str(i,'%03i') '.nii']);
    nii = make_nii(ph_all(:,:,:,i),vox);
    save_nii(nii,['src/ph' num2str(i,'%03i') '.nii']);
end



bet_thr=0.3

% generate BET on 1st volume
[status,cmdout] = unix('rm BET*');
disp('--> extract brain volume and generate mask ...');
setenv('bet_thr',num2str(bet_thr));
bash_script = ['bet2 src/mag001.nii BET ' ...
    '-f ${bet_thr} -m'];
unix(bash_script);
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii(['BET_mask.nii']);
mask = double(nii.img);


mask_all = mask;
i = 1;

nii = make_nii(mask_all(:,:,:,i),vox);
    save_nii(nii,['BET' num2str(i,'%03i') '_mask.nii']);
    mask = mask_all(:,:,:,i);
    mag = mag_all(:,:,:,i);
    ph = ph_all(:,:,:,i);

% Ryan Topfer's Laplacian unwrapping
        disp('--> unwrap aliasing phase using laplacian...');
        Options.voxelSize = vox;
        unph = lapunwrap(ph, Options);
        nii = make_nii(unph, vox);
        save_nii(nii,['unph_lap' num2str(i,'%03i') '.nii']);


    tfs = unph/(2.675e8*dicom_info.EchoTime*dicom_info.MagneticFieldStrength)*1e9; % unit ppm

disp('--> RESHARP to remove background field ...');
        [lfs_resharp, mask_resharp] = resharp(tfs,mask,vox,5,1e-4,200);
        % 2D 2nd order polyfit to remove any residual background
        % lfs_resharp = lfs_resharp - poly2d(lfs_resharp,mask_resharp);

        % save nifti
        mkdir('RESHARP');
        nii = make_nii(lfs_resharp,vox);
        save_nii(nii,['RESHARP/lfs_resharp' num2str(i,'%03i') '.nii']);

smv_rad =5;
% iLSQR
chi_iLSQR = QSM_iLSQR(lfs_resharp*(2.675e8*dicom_info.MagneticFieldStrength)/1e6,mask_resharp,'H',z_prjs,'voxelsize',vox,'niter',50,'TE',1000,'B0',dicom_info.MagneticFieldStrength);
nii = make_nii(chi_iLSQR,vox);
save_nii(nii,['RESHARP/chi_iLSQR_niter50_smvrad' num2str(smv_rad) '.nii']);


