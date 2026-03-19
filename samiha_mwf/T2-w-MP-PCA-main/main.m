% This script processes 4D nifti T2s-weighted magnitude and phase data, where the 4th dimension represents echo times.
% 
% INPUT:
% - Scans_dir: Path to the directory containing all the scans (default: current directory).
% - Data_dir: Name of the folder containing a specific scan for denoising and creating R2s and T2s maps.
% - Data_Mag: Name of the nifti magnitude file.
% - Data_Phs: Name of the nifti phase file.
% - window: Size of the sliding window for denoising (scalar).
% - slice: Slice index for processing and analysis.
%
% OUTPUT:
% - Denoised images (magnitude and phase).
% - R2s (sec^-1) and T2s (mses) maps for original and denoised data.
% - Figures displaying original vs. denoised results.
%
% EXTERNAL FUNCTIONS:
% - MPPCAdenoise: Denoises complex-valued images using MPPCA.
% - R2s_T2s_fit: Computes R2* and T2* maps from magnitude data.

Scans_dir = pwd;
Data_dir  = "Data";
Data_Mag  = "MagnitudeTimeseries.nii";
Data_Phs  = "PhaseTimeseries.nii";
window    = 3; 
slice     = 30;

root_dir = fullfile(Scans_dir, Data_dir);
Scan_Info = niftiinfo(fullfile(root_dir, Data_Mag));

Mag_Decay_Org = double(niftiread(fullfile(root_dir, Data_Mag)));
Phs_Decay_Org = double(niftiread(fullfile(root_dir, Data_Phs)))/4096*pi;

Echos = size(Mag_Decay_Org,4);
% Define regular expressions to extract TE and dTE
te_pattern = 'TE=([\d\.]+)'; % Pattern for TE
dte_pattern = 'dTE=([\d\.]+)'; % Pattern for dTE
% Extract values using regular expressions
te_match = regexp(Scan_Info.Description, te_pattern, 'tokens');
dte_match = regexp(Scan_Info.Description, dte_pattern, 'tokens');
first_echo = str2double(te_match{1});
dTE        = str2double(dte_match{1});
TEs = first_echo + (0:Echos-1)*dTE;


% Create complex matrix: Magnitude and unwrapped phase for denoising
Comp_decay_Img = Mag_Decay_Org .* exp(1i * Phs_Decay_Org);

% Denoising every scan repetition
Denoised_data = MPPCAdenoise(Comp_decay_Img, repmat(window, [1,3]));

Mag_Decay_Den = abs(Denoised_data);
Phs_Decay_Den = angle(Denoised_data);

% Calculate R2* and T2* maps for original data
[T2s_map_Org, R2s_map_Org, gof_map_Org] = R2s_T2s_fit(Mag_Decay_Org, TEs, slice);

% Calculate R2* and T2* maps for denoised data
[T2s_map_Den, R2s_map_Den, gof_map_Den] = R2s_T2s_fit(Mag_Decay_Den, TEs, slice);

%%
% plot figuers
plot_comparison(Mag_Decay_Org(:,:,slice,1), Mag_Decay_Den(:,:,slice,1), 'T2s-weighted image', 'gray', [0 700]);
plot_comparison(R2s_map_Org, R2s_map_Den, 'R2s map', 'parula', [0 0.05]);
plot_comparison(T2s_map_Org, T2s_map_Den, 'T2s map', 'parula',[0 180]);

function plot_comparison(data1, data2, titleText, cmap, caxis)
    figure;
    subplot(1,2,1);
    imagesc(data1); axis image; colormap(cmap); clim(caxis);
    set(gca,'visible','off'); title('Original');
    subplot(1,2,2);
    imagesc(data2); axis image; colormap(cmap); clim(caxis);
    set(gca,'visible','off'); title('Denoised');
    sgtitle(titleText);
end