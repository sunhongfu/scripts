% Load accelerated Pfile
pfile = GERecon('Pfile.Load', acceleratedPfile);

% Run calibration on reference Pfile
GERecon('Calibration.Process', calibrationPfile);

for s = 1:pfile.slices
    % for c = 1:pfile.channels

    %     % Load K-Space
    %     kspace = GERecon('Pfile.KSpace', s, 1, c);
    %     aliasedImage = GERecon('Transform', kspace);

    %     aliasedImages(:,:,c,:) = aliasedImage;
    % end

    % Get corners and orientation for this slice location via
    % the Pfile.Info interface.  This structure provides enough
    % slice information to support slice ASSET acceleration.
    info = GERecon('Pfile.Info', s);

           unaliasedImage = GERecon('Asset.Unalias', channelImages, info);

    % Create Magnitude Image
    magnitudeImage = abs(unaliasedImage);

    % phase image
    phaseImage = angle(unaliasedImage);

    % Apply Gradwarp
    gradwarpedImage = GERecon('Gradwarp', magnitudeImage, info.Corners);

    % Orient the image and corners
    finalImage = GERecon('Orient', gradwarpedImage, info.Orientation);

    % Display
    imagesc(finalImage);
    imagesc(phaseImage);

    % Display
    title(['Slice: ' num2str(s)]);

    % Save DICOMs
    filename = ['DICOMs/image' num2str(s) '.dcm'];
    filename2 = ['DICOMs2/image' num2str(s) '.dcm'];
    GERecon('Dicom.Write', filename, finalImage, s, ...
        info.Orientation, info.Corners);
    GERecon('Dicom.Write', filename2, phaseImage, s, ...
        info.Orientation, info.Corners);        

    pause(0.1);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%
% alternative way

directory = fileparts(mfilename('/Users/hongfusun/DATA/p-files/oct7'));
pfile = fullfile(directory, 'P31232.7');
calibration = fullfile(directory, 'P32328.7');

AssetRecon(pfile, calibration);
