function [maps, img] = MRF_Recon_DM_svd(FilePath, slice_range, varargin)
%%-----------------------------------------------------------------------%%
%  Authors: M.A. Cloos [1,2]
%  M.Cloos@uq.eud.au
%  Date: 2020 March
%  [1] New York University School of Medicine, https://www.cai2r.net
%  [2] University of Queensland , https://cai.centre.uq.edu.au、
%
%  Modified by Yang Gao, University of Queensland. 
% 
%  Input Parameters: FilePath, MRI scanner raw data path. 
%                    slice_range: silce range, default: 0 (for reconstructing all slices)
%                    SaveMapsPath and SaveimgPath (optional): dictionary matching maps, and
%                    aliased images for saving results; 
% 
%%-----------------------------------------------------------------------%%
% clear all; close all; clc;
addpath(genpath('./_src'));
addpath(genpath('./'));

LASTN = maxNumCompThreads(10) 

if nargin < 2 || isempty(slice_range) || ~ exist('slice_range','var') 
    slice_range = 0;      % 0 is all slices 
end

if nargin == 3
    SaveMapsPath = varargin{1}; 
end 

if nargin == 4
    SaveMapsPath = varargin{1}; 
    SaveimgPath = varargin{2}; 
end 

%%-----------------------------------------------------------------------%%
% Settings:
%%-----------------------------------------------------------------------%%
includes_noise_scan = true; 
reset_noise_cov     = true;
remove_os_before_FT = false;
remove_os_after__FT = true;
compress_rx = 8;      % max numer of svd compressed coil elements
refferen_rx = 'SOS';  % 'SOS'= square root of sum of squares % 'mode1' = first SVD component in coil dimention
matrix4__rx = 96;     % Centeral area of k-space used for RX estimation
% % slice_range = 0;      % 0 is all slices 
kShift      = 0; %-0.8;    % correction for gradient delay in dweltimes (1.0 is one dwelltime)
svd_range   = 200; % may need more!

%%-----------------------------------------------------------------------%%
% load_dictionary
%%-----------------------------------------------------------------------%%
% % load('dictionary.mat');

% load dictionary_largedict2_normed.mat; 

S = load('dictionary_small_nosvd.mat');
dict = S.dictionary;

% 
% %remove delay's
% tmp = zeros(size(dictionary.atoms,1),size(dictionary.atoms,2)-3);
% tmp(:,  1:250 ) = dictionary.atoms(:,  1:250 );
% tmp(:,251:500 ) = dictionary.atoms(:,252:501 );
% tmp(:,501:750 ) = dictionary.atoms(:,503:752 );
% tmp(:,751:1000) = dictionary.atoms(:,754:1003);
% 
% dictionary.atoms  = tmp .';
% dictionary.lookup = dictionary.lookup .'; 
% clear('tmp');

% -----------------------------------------------------------------------%%
% Singular value based fingerprint compression
% -----------------------------------------------------------------------%%

[U,~,~] = svd(dict.atoms,'econ');
U = U(:,1:svd_range);
% disp('---U matrix found');
% 
% % load SVD_largeDict.mat; 
% 
%% -----------------------------------------------------------------------%%
% Compress dictionary
%------------------------------------------------------------------------%%     

dict.atoms = transpose(transpose(dict.atoms)*U);
for i=1:size(dict.atoms,2)
    dict.atoms(:,i)= dict.atoms(:,i)/norm(dict.atoms(:,i));
    dict.lookup(1,i) = norm(dict.atoms(:,i));
end
disp('---dictionary compressed');

% S = load('dictionary_small_svd.mat') %hongfu
% dict = S.dictionary;

%% -----------------------------------------------------------------------%%
%  Load raw data (VB or VD)
%%-----------------------------------------------------------------------%%
if nargin < 1 || isempty(FilePath) || ~ exist('FilePath','var') 
    MrData = RawDataObj( remove_os_before_FT );
else
    [FileFolder, FileName, FileExt] = fileparts(FilePath); 
    MrData = RawDataObj( remove_os_before_FT , [FileFolder, filesep], [FileName, FileExt]);
end


fileID = fopen([MrData.file_path '/' MrData.file_name]);
bytes = fread(fileID,1000000,'char');% 'ubit8');
fclose(fileID);

fileID = fopen('header.txt','w');
fwrite(fileID,bytes,'char');% 'ubit8');
fclose(fileID);


MrData.setKSpaceShift( kShift );
disp([num2str(MrData.Dim.nSl) ' Slices']);


if size(MrData.data, 2) < max(slice_range) || min(slice_range) < 1 
    error('incorrect slice setting!');
end 

MrData.setSliceRange( slice_range );
MrData.coil_compression( compress_rx );

MrData.extractNoiseScan( includes_noise_scan );
MrData.data = single(MrData.data);

if reset_noise_cov
    disp('Not using noise cov!!!');
    MrData.invNoiseCov = eye(MrData.Dim.nCh);
end

%%-----------------------------------------------------------------------%%
% Compress rawdata
%%-----------------------------------------------------------------------%%     
MrData.applyCompression(U); %Hongfu comment out

%%-----------------------------------------------------------------------%%
% Estimate Recieve Sensitivities 
%%-----------------------------------------------------------------------%%
I_rx = make_rx(MrData, matrix4__rx, refferen_rx);
disp('got rx profiles');

%%-----------------------------------------------------------------------%%
% Extract the tradjectory & dimenions
%%-----------------------------------------------------------------------%%
trj = get_trajectory(MrData);
dim = MrData.Dim;

%%-----------------------------------------------------------------------%%
% Matched filter reconstruction
%%-----------------------------------------------------------------------%%
tmp = zeros(dim.nRe,dim.nRe,dim.nCh);
img = zeros(dim.nSl,dim.nRe,dim.nRe,dim.nSe);
echo = 1;

save trj.mat trj dim; 
%%-----------------------------------------------------------------------%%
% Same trajectory for everything
%%-----------------------------------------------------------------------%%
disp('preparing FT opperator...');
FT = NUFFT(squeeze(trj.k(1,:,:,1)), squeeze(trj.w(1,:,:,1)), 1, 0, [dim.nRe,dim.nRe], 2);
disp('FT opperator ready!');

pb1 = CmdLineProgressBar(' Matched Filter Reconstrcution: '); 
for se=1:dim.nSe    
    for sl=1:dim.nSl
        for ch=1:dim.nCh
            tmp(:,:,ch) = FT'*double(squeeze(MrData.data(echo,sl,ch,:,:,se)));
        end %/channel
        img(sl,:,:,se) = opt_comb(tmp,squeeze(I_rx(sl,:,:,:)), MrData.invNoiseCov );
    end %/Slice
    pb1.print((se-1)*dim.nSl+sl, dim.nSl * dim.nSe );
end %/Set

%%-----------------------------------------------------------------------%%
% make mask
%%-----------------------------------------------------------------------%%
mask = make_mask(img, MrData.noise, MrData.invNoiseCov);

% %%
% figure(99);
% imshow(squeeze(abs(img(1,:,:,1))),[0,0.001]); title('1st SVD image abs');
% figure(98);
% imshow(squeeze(angle(img(1,:,:,1))),[-pi,pi]); title('1st SVD image phase');
%%

%%-----------------------------------------------------------------------%%
% Release memory
%%-----------------------------------------------------------------------%%
clear('FT');
clear('tmp');
% clear('MrData');


%%-----------------------------------------------------------------------%%
% Remove oversampling
%%-----------------------------------------------------------------------%%
if remove_os_after__FT
    parI = round(size(img,2)/4);
    staI = parI+1;
    endI = round(3*parI);
    img  = img(:,staI:endI,staI:endI,:);
    mask = mask(:,staI:endI,staI:endI,:);
    I_rx = I_rx(:,staI:endI,staI:endI,:);
end

%% -----------------------------------------------------------------------%%
% Dictionary Matching
%%-----------------------------------------------------------------------%%
img = single(img); %makes the matching much faster 
maps = zeros(4,size(img,1),size(img,2),size(img,3));

for i=1:size(img,1)
    [map, ~] = fast_match(img(i,:,:,:), dict, dict.chuck);
    maps(:,i,:,:) = map;
    disp(num2str(i));
end 

maps_save = maps;
maps_save(1,:,:,:) = abs(maps(1,:,:,:));

%% save data
if nargin == 3
    %nii = make_nii(maps);
    %save_nii(nii, SaveMapsPath);
    niftiwrite(permute(squeeze(maps_save),[2,3,1]), SaveMapsPath);
end

if nargin == 4
    %nii = make_nii(maps);
    %save_nii(nii, SaveMapsPath);
    niftiwrite(permute(squeeze(maps_save),[2,3,1]), SaveMapsPath);
    
    %nii = make_nii(img);
    %save_nii(nii, SaveimgPath);
    data(:,:,:,1:200) = real(img); 
    data(:,:,:,201:400) = imag(img); 
    niftiwrite(data, SaveimgPath);
end




%%-----------------------------------------------------------------------%%
%% saving dat
%%-----------------------------------------------------------------------%%
% save('2022_07_18_Phantom.mat','maps');

disp('done!');

%%-----------------------------------------------------------------------%%
%% Preview
%% -----------------------------------------------------------------------%%
% dSl = 2; % display slice
% figure(1); imshow(squeeze(abs(maps(1,dSl,:,:))),[   0,   1]); title('PD');
% figure(2); imshow(squeeze(maps(2,dSl,:,:)),     [   0,3000]); title('T1');
% figure(3); imshow(squeeze(maps(3,dSl,:,:)),     [   0, 200]); title('T2');
% figure(4); imshow(squeeze(maps(4,dSl,:,:)),     [-100, 100]); title('B0');
% % do wtice because of matlab bug?
% figure(1); imshow(squeeze(abs(maps(1,dSl,:,:))),[   0,   1]); title('PD');
% figure(2); imshow(squeeze(maps(2,dSl,:,:)),     [   0,3000]); title('T1');
% figure(3); imshow(squeeze(maps(3,dSl,:,:)),     [   0, 200]); title('T2');
% figure(4); imshow(squeeze(maps(4,dSl,:,:)),     [-100, 100]); title('B0');


end

