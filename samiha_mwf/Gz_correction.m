function Gz_correction(mag_fname, Gz_fname, fname_mask)

% *************************************************************************
% Gz_correction(mag_fname, Gz_fname, fname_mask)
%
% DESCRIPTION: This function will correct a MGRE data set for the effects
% of B0 field inhomogeneities in the z-direction, given a z-gradient map 
% (Gz_fname). The MGRE signal will be divided by a sinc correction factor 
% that includes Gz (see M.A. Fernadez-Seara and F.W. Wehrli, MRM, 2000). 
% Note that sinc(x) = sin(pi*x)/(pi*x)
%
% INPUTS: 
% mag_fname: MGRE data
% Gz_fname: units of Hz/cm
% fname_mask: processing mask
%
% OUTPUTS:
% mag_fname_corrected.mnc
% max_echoes.mnc
%
% AUTHOR: Eva Alonso Ortiz, MSc
%         McConnell Brain Imaging Center, McGill University
%
% LAST MODIFIED: Aug. 2016
%*************************************************************************

%% constants
gamma = 2*pi*42.58e6; % rad*Hz/T


%% open data files
[mag_desc,mag] = niak_read_minc(mag_fname);
[Gz_desc,Gz] = niak_read_minc(Gz_fname);
[mask_desc,mask] = niak_read_minc(fname_mask);

% find echo times
num_echoes = mag_desc.info.dimensions(1,4);
echo_times = calc_echo_times(num_echoes);
echo_times = echo_times*1e-3; % convert to seconds

% find slice thickness (cm)
delta_z = mag_desc.info.voxel_size(3)/10;
mag_F = zeros(size(mag));
corrected_mag = zeros(size(mag));
max_echoes = zeros(size(mask));

% calculate corrected signal decay
% currently using field maps that are in Hz/cm
for i=1:size(mag,1)
    for j=1:size(mag,2)
        for k=1:size(mag,3)
            if (mask(i,j,k) ~= 0) 

                    max_echoes(i,j,k) = num_echoes;
                    mag_F(i,j,k,:) = abs(sinc(Gz(i,j,k)*(delta_z/(2*pi))*echo_times(:)));
                    corrected_mag(i,j,k,:) = mag(i,j,k,:)./mag_F(i,j,k,:);
                    % if the correction factor has a zero-crossing, do not
                    % use all the echoes to fit the signal
                    if (min(squeeze(mag_F(i,j,k,:))) < 0.1)
                        [zmax,imax,zmin,imin]= extrema(squeeze(mag_F(i,j,k,:)));
                         max_echoes(i,j,k) = (min(imin(imin>1))-5);
                    end

            end
        end
    end
end

%% save corrected magnitude data map
[pathstr, name, ext] = fileparts(mag_fname);
mag_desc.file_name = strcat(name,'_corrected.mnc');
mag_desc.info.dimensions = [size(mag,1), size(mag,2), size(mag,3), num_echoes];
niak_write_minc(mag_desc,corrected_mag);

% save max_echoes map
mask_desc.file_name = 'max_echoes.mnc';
niak_write_minc(mask_desc,max_echoes); 