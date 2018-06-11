% Imports images (.nii) and transform into MarsBaR ROIs

% Input files
labelNames = dir('V*_thr.nii');
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

