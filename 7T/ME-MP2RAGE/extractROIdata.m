% Extract data from ROIs for NBR project

% Use this script to extract ROI data from images. ROIs and images must
% already be registered. 
% Uses MarsBar functions

% RJWilliams 22 Feb 2018

allRois = dir('V*_roi.mat');
orig_dir = pwd;

% Get CO2 data for m calculations
for i = 1:length(allRois)
    
    roi_files = allRois(i).name;
    nameparts = strsplit(allRois(i).name, ('_'));
    name = strcat(nameparts{1,1},'_',nameparts{1,2},'_','CO2','_','e1','_','mdata');
    cd ..
    cd ..  
    cd CO2/e1/first_level/normalised/perfusion_regressor/hrf
    im_dir = pwd;
    P = dir('beta_0001.nii');
    data = fullfile(im_dir,P.name);
    cd (orig_dir);
    % make maroi ROI objects
    rois = maroi('load_cell', roi_files);
    % extract data into marsy data object
    mY = get_marsy(rois{:}, data, 'mean'); 
    [Y Yvar] = summary_data(mY); 
    save(name,'-regexp','^(?!(i)$).')
    clearvars P mY Y Yvar im_dir data
    
end
    
  