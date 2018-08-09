cd /Users/hongfusun/DATA/ME-MP2RAGE/rois

% Input files
labelNames = dir('*.nii');
name = struct2cell(labelNames);

% Output folder
roipath = pwd;
% Flags: i = image
flags = 'i';

for i = 1:length(name)
    P = name{1,i};
    rootn = name{1,i};
    % Remove '.nii' from end of name
    rootn(length(rootn)-3:length(rootn)) =[];
    mars_img2rois(P, roipath, rootn, flags);
end;




% measure the ROIs on data

allRois = dir('*_roi.mat');
orig_dir = pwd;

% Get CO2 data for m calculations
for i = 1:length(allRois)
    
    roi_files = allRois(i).name;
    nameparts = strsplit(allRois(i).name, ('_'));
    % name = strcat(nameparts{1,1},'_',nameparts{1,2},'_','CO2','_','e1','_','mdata');
    cd ..
    % cd ..  
    % cd CO2/e1/first_level/normalised/perfusion_regressor/hrf
    im_dir = pwd;
    P = dir('chi_iLSQR_smvrad2_adj_to_MNI.nii');
    data = fullfile(im_dir,P.name);
    cd ('rois');
    % make maroi ROI objects
    rois = maroi('load_cell', roi_files);
    % extract data into marsy data object
    mY = get_marsy(rois{:}, data, 'mean'); 
    [Y Yvar] = summary_data(mY) 
    % save(name,'-regexp','^(?!(i)$).')
    clearvars P mY Y Yvar im_dir data
    
end
    
