% read in uncombined magnitude and phase images
path_mag = '/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/1.10.1/1.10.1.344/1.10.1.344.1.1/1.10.1.344.1.1.72/dicom_series';
path_ph = '/gpfs/M2Scratch/NCIgb5/hongfu/SPECIMAN/1.10.1/1.10.1.344/1.10.1.344.1.1/1.10.1.344.1.1.73/dicom_series';
path_out = '/home/hongfu/NCIgb5_scratch/hongfu/EPI/72';

%% read in DICOMs of both uncombined magnitude and raw unfiltered phase images

%% read in DICOMs of both uncombined magnitude and raw unfiltered phase images
path_mag = cd(cd(path_mag));
mag_list = dir([path_mag '/*.dcm']);
mag_list = mag_list(~strncmpi('.', {mag_list.name}, 1));
path_ph = cd(cd(path_ph));
ph_list = dir([path_ph '/*.dcm']);
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

dicom_info = dicominfo([path_mag,filesep,mag_list(1).name]);
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
% ph = zeros(dicom_info.Rows,dicom_info.Columns,nSL,'single');
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

imsize = size(ph_all);

% define output directories
path_qsm = [path_out '/QSM_MEGE_7T'];
mkdir(path_qsm);
init_dir = pwd;
cd(path_qsm);
% save the raw data for future use
clear mag ph
save('raw.mat','-v7.3');



